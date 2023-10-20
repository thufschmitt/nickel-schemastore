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
          command_info
            | doc m%"
            Command information
            "%
            = {
                command | String | optional,
                continue_if_failed
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | optional,
                cwd | std.enum.TagOrString | [| 'workspace, 'root |] | optional,
                secured_env
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | optional,
                ..
              },
          enum_descriptor_keys = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'GIT,
                  'CREDENTIALS,
                  'YAML,
                  'XML,
                  'VBDOTNET,
                  'TYPESCRIPT,
                  'TSX,
                  'TERRAFORM,
                  'TEKTON,
                  'SWIFT,
                  'SQL,
                  'SPELL,
                  'SNAKEMAKE,
                  'SCALA,
                  'SALESFORCE,
                  'RUST,
                  'RUBY,
                  'RST,
                  'REPOSITORY,
                  'RAKU,
                  'R,
                  'PYTHON,
                  'PUPPET,
                  'PROTOBUF,
                  'POWERSHELL,
                  'PHP,
                  'PERL,
                  'OPENAPI,
                  'MARKDOWN,
                  'MAKEFILE,
                  'LUA,
                  'LATEX,
                  'KUBERNETES,
                  'KOTLIN,
                  'JSX,
                  'JSON,
                  'JAVASCRIPT,
                  'JAVA,
                  'HTML,
                  'GROOVY,
                  'GRAPHQL,
                  'GO,
                  'GHERKIN,
                  'ENV,
                  'EDITORCONFIG,
                  'DOCKERFILE,
                  'DART,
                  'CSS,
                  'CSHARP,
                  'CPP,
                  'COPYPASTE,
                  'COFFEE,
                  'CLOUDFORMATION,
                  'CLOJURE,
                  'C,
                  'BICEP,
                  'BASH,
                  'ARM,
                  'ANSIBLE,
                  'ACTION
                |]
              ],
          enum_linter_keys = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'TERRAFORM_KICS,
                  'TERRAFORM_CHECKOV,
                  'SPELL_MISSPELL,
                  'REPOSITORY_GOODCHECK,
                  'KUBERNETES_KUBEVAL,
                  'PHP_BUILTIN,
                  'GIT_GIT_DIFF,
                  'DOCKERFILE_DOCKERFILELINT,
                  'CREDENTIALS_SECRETLINT,
                  'YAML_V8R,
                  'YAML_YAMLLINT,
                  'YAML_PRETTIER,
                  'XML_XMLLINT,
                  'VBDOTNET_DOTNET_FORMAT,
                  'TYPESCRIPT_PRETTIER,
                  'TYPESCRIPT_STANDARD,
                  'TYPESCRIPT_ES,
                  'TSX_ESLINT,
                  'TERRAFORM_TERRAFORM_FMT,
                  'TERRAFORM_TERRAGRUNT,
                  'TERRAFORM_TERRASCAN,
                  'TERRAFORM_TFLINT,
                  'TEKTON_TEKTON_LINT,
                  'SWIFT_SWIFTLINT,
                  'SQL_TSQLLINT,
                  'SQL_SQLFLUFF,
                  'SQL_SQL_LINT,
                  'SPELL_LYCHEE,
                  'SPELL_VALE,
                  'SPELL_PROSELINT,
                  'SPELL_CSPELL,
                  'SNAKEMAKE_SNAKEFMT,
                  'SNAKEMAKE_LINT,
                  'SCALA_SCALAFIX,
                  'SALESFORCE_SFDX_SCANNER_LWC,
                  'SALESFORCE_SFDX_SCANNER_AURA,
                  'SALESFORCE_SFDX_SCANNER_APEX,
                  'RUST_CLIPPY,
                  'RUBY_RUBOCOP,
                  'RST_RSTFMT,
                  'RST_RSTCHECK,
                  'RST_RST_LINT,
                  'REPOSITORY_TRUFFLEHOG,
                  'REPOSITORY_TRIVY_SBOM,
                  'REPOSITORY_TRIVY,
                  'REPOSITORY_SYFT,
                  'REPOSITORY_SEMGREP,
                  'REPOSITORY_SECRETLINT,
                  'REPOSITORY_KICS,
                  'REPOSITORY_GRYPE,
                  'REPOSITORY_GITLEAKS,
                  'REPOSITORY_GIT_DIFF,
                  'REPOSITORY_DUSTILOCK,
                  'REPOSITORY_DEVSKIM,
                  'REPOSITORY_CHECKOV,
                  'RAKU_RAKU,
                  'R_LINTR,
                  'PYTHON_RUFF,
                  'PYTHON_PYRIGHT,
                  'PYTHON_MYPY,
                  'PYTHON_BANDIT,
                  'PYTHON_ISORT,
                  'PYTHON_FLAKE8,
                  'PYTHON_BLACK,
                  'PYTHON_PYLINT,
                  'PUPPET_PUPPET_LINT,
                  'PROTOBUF_PROTOLINT,
                  'POWERSHELL_POWERSHELL_FORMATTER,
                  'POWERSHELL_POWERSHELL,
                  'PHP_PHPLINT,
                  'PHP_PSALM,
                  'PHP_PHPSTAN,
                  'PHP_PHPCS,
                  'PERL_PERLCRITIC,
                  'OPENAPI_SPECTRAL,
                  'MARKDOWN_MARKDOWN_TABLE_FORMATTER,
                  'MARKDOWN_MARKDOWN_LINK_CHECK,
                  'MARKDOWN_REMARK_LINT,
                  'MARKDOWN_MARKDOWNLINT,
                  'MAKEFILE_CHECKMAKE,
                  'LUA_LUACHECK,
                  'LATEX_CHKTEX,
                  'KUBERNETES_KUBESCAPE,
                  'KUBERNETES_HELM,
                  'KUBERNETES_KUBECONFORM,
                  'KOTLIN_KTLINT,
                  'JSX_ESLINT,
                  'JSON_NPM_PACKAGE_JSON_LINT,
                  'JSON_PRETTIER,
                  'JSON_V8R,
                  'JSON_ESLINT_PLUGIN_JSONC,
                  'JSON_JSONLINT,
                  'JAVASCRIPT_PRETTIER,
                  'JAVASCRIPT_STANDARD,
                  'JAVASCRIPT_ES,
                  'JAVA_PMD,
                  'JAVA_CHECKSTYLE,
                  'HTML_HTMLHINT,
                  'HTML_DJLINT,
                  'GROOVY_NPM_GROOVY_LINT,
                  'GRAPHQL_GRAPHQL_SCHEMA_LINTER,
                  'GO_REVIVE,
                  'GO_GOLANGCI_LINT,
                  'GHERKIN_GHERKIN_LINT,
                  'ENV_DOTENV_LINTER,
                  'EDITORCONFIG_EDITORCONFIG_CHECKER,
                  'DOCKERFILE_HADOLINT,
                  'DART_DARTANALYZER,
                  'CSS_SCSS_LINT,
                  'CSS_STYLELINT,
                  'CSHARP_CSHARPIER,
                  'CSHARP_DOTNET_FORMAT,
                  'CPP_CPPLINT,
                  'COPYPASTE_JSCPD,
                  'COFFEE_COFFEELINT,
                  'CLOUDFORMATION_CFN_LINT,
                  'CLOJURE_CLJSTYLE,
                  'CLOJURE_CLJ_KONDO,
                  'C_CPPLINT,
                  'BICEP_BICEP_LINTER,
                  'BASH_SHFMT,
                  'BASH_SHELLCHECK,
                  'BASH_EXEC,
                  'ARM_ARM_TTK,
                  'ANSIBLE_ANSIBLE_LINT,
                  'ACTION_ACTIONLINT
                |]
              ],
        },
    predicate = {
          command_info
            | doc m%"
            Command information
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  command = predicates.isType '"String",
                  continue_if_failed = predicates.isType '"Bool",
                  cwd = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "root", "workspace" ]
                      ],
                  secured_env = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          enum_descriptor_keys = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "ACTION",
                  "ANSIBLE",
                  "ARM",
                  "BASH",
                  "BICEP",
                  "C",
                  "CLOJURE",
                  "CLOUDFORMATION",
                  "COFFEE",
                  "COPYPASTE",
                  "CPP",
                  "CSHARP",
                  "CSS",
                  "DART",
                  "DOCKERFILE",
                  "EDITORCONFIG",
                  "ENV",
                  "GHERKIN",
                  "GO",
                  "GRAPHQL",
                  "GROOVY",
                  "HTML",
                  "JAVA",
                  "JAVASCRIPT",
                  "JSON",
                  "JSX",
                  "KOTLIN",
                  "KUBERNETES",
                  "LATEX",
                  "LUA",
                  "MAKEFILE",
                  "MARKDOWN",
                  "OPENAPI",
                  "PERL",
                  "PHP",
                  "POWERSHELL",
                  "PROTOBUF",
                  "PUPPET",
                  "PYTHON",
                  "R",
                  "RAKU",
                  "REPOSITORY",
                  "RST",
                  "RUBY",
                  "RUST",
                  "SALESFORCE",
                  "SCALA",
                  "SNAKEMAKE",
                  "SPELL",
                  "SQL",
                  "SWIFT",
                  "TEKTON",
                  "TERRAFORM",
                  "TSX",
                  "TYPESCRIPT",
                  "VBDOTNET",
                  "XML",
                  "YAML",
                  "CREDENTIALS",
                  "GIT"
                ]
              ],
          enum_linter_keys = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "ACTION_ACTIONLINT",
                  "ANSIBLE_ANSIBLE_LINT",
                  "ARM_ARM_TTK",
                  "BASH_EXEC",
                  "BASH_SHELLCHECK",
                  "BASH_SHFMT",
                  "BICEP_BICEP_LINTER",
                  "C_CPPLINT",
                  "CLOJURE_CLJ_KONDO",
                  "CLOJURE_CLJSTYLE",
                  "CLOUDFORMATION_CFN_LINT",
                  "COFFEE_COFFEELINT",
                  "COPYPASTE_JSCPD",
                  "CPP_CPPLINT",
                  "CSHARP_DOTNET_FORMAT",
                  "CSHARP_CSHARPIER",
                  "CSS_STYLELINT",
                  "CSS_SCSS_LINT",
                  "DART_DARTANALYZER",
                  "DOCKERFILE_HADOLINT",
                  "EDITORCONFIG_EDITORCONFIG_CHECKER",
                  "ENV_DOTENV_LINTER",
                  "GHERKIN_GHERKIN_LINT",
                  "GO_GOLANGCI_LINT",
                  "GO_REVIVE",
                  "GRAPHQL_GRAPHQL_SCHEMA_LINTER",
                  "GROOVY_NPM_GROOVY_LINT",
                  "HTML_DJLINT",
                  "HTML_HTMLHINT",
                  "JAVA_CHECKSTYLE",
                  "JAVA_PMD",
                  "JAVASCRIPT_ES",
                  "JAVASCRIPT_STANDARD",
                  "JAVASCRIPT_PRETTIER",
                  "JSON_JSONLINT",
                  "JSON_ESLINT_PLUGIN_JSONC",
                  "JSON_V8R",
                  "JSON_PRETTIER",
                  "JSON_NPM_PACKAGE_JSON_LINT",
                  "JSX_ESLINT",
                  "KOTLIN_KTLINT",
                  "KUBERNETES_KUBECONFORM",
                  "KUBERNETES_HELM",
                  "KUBERNETES_KUBESCAPE",
                  "LATEX_CHKTEX",
                  "LUA_LUACHECK",
                  "MAKEFILE_CHECKMAKE",
                  "MARKDOWN_MARKDOWNLINT",
                  "MARKDOWN_REMARK_LINT",
                  "MARKDOWN_MARKDOWN_LINK_CHECK",
                  "MARKDOWN_MARKDOWN_TABLE_FORMATTER",
                  "OPENAPI_SPECTRAL",
                  "PERL_PERLCRITIC",
                  "PHP_PHPCS",
                  "PHP_PHPSTAN",
                  "PHP_PSALM",
                  "PHP_PHPLINT",
                  "POWERSHELL_POWERSHELL",
                  "POWERSHELL_POWERSHELL_FORMATTER",
                  "PROTOBUF_PROTOLINT",
                  "PUPPET_PUPPET_LINT",
                  "PYTHON_PYLINT",
                  "PYTHON_BLACK",
                  "PYTHON_FLAKE8",
                  "PYTHON_ISORT",
                  "PYTHON_BANDIT",
                  "PYTHON_MYPY",
                  "PYTHON_PYRIGHT",
                  "PYTHON_RUFF",
                  "R_LINTR",
                  "RAKU_RAKU",
                  "REPOSITORY_CHECKOV",
                  "REPOSITORY_DEVSKIM",
                  "REPOSITORY_DUSTILOCK",
                  "REPOSITORY_GIT_DIFF",
                  "REPOSITORY_GITLEAKS",
                  "REPOSITORY_GRYPE",
                  "REPOSITORY_KICS",
                  "REPOSITORY_SECRETLINT",
                  "REPOSITORY_SEMGREP",
                  "REPOSITORY_SYFT",
                  "REPOSITORY_TRIVY",
                  "REPOSITORY_TRIVY_SBOM",
                  "REPOSITORY_TRUFFLEHOG",
                  "RST_RST_LINT",
                  "RST_RSTCHECK",
                  "RST_RSTFMT",
                  "RUBY_RUBOCOP",
                  "RUST_CLIPPY",
                  "SALESFORCE_SFDX_SCANNER_APEX",
                  "SALESFORCE_SFDX_SCANNER_AURA",
                  "SALESFORCE_SFDX_SCANNER_LWC",
                  "SCALA_SCALAFIX",
                  "SNAKEMAKE_LINT",
                  "SNAKEMAKE_SNAKEFMT",
                  "SPELL_CSPELL",
                  "SPELL_PROSELINT",
                  "SPELL_VALE",
                  "SPELL_LYCHEE",
                  "SQL_SQL_LINT",
                  "SQL_SQLFLUFF",
                  "SQL_TSQLLINT",
                  "SWIFT_SWIFTLINT",
                  "TEKTON_TEKTON_LINT",
                  "TERRAFORM_TFLINT",
                  "TERRAFORM_TERRASCAN",
                  "TERRAFORM_TERRAGRUNT",
                  "TERRAFORM_TERRAFORM_FMT",
                  "TSX_ESLINT",
                  "TYPESCRIPT_ES",
                  "TYPESCRIPT_STANDARD",
                  "TYPESCRIPT_PRETTIER",
                  "VBDOTNET_DOTNET_FORMAT",
                  "XML_XMLLINT",
                  "YAML_PRETTIER",
                  "YAML_YAMLLINT",
                  "YAML_V8R",
                  "CREDENTIALS_SECRETLINT",
                  "DOCKERFILE_DOCKERFILELINT",
                  "GIT_GIT_DIFF",
                  "PHP_BUILTIN",
                  "KUBERNETES_KUBEVAL",
                  "REPOSITORY_GOODCHECK",
                  "SPELL_MISSPELL",
                  "TERRAFORM_CHECKOV",
                  "TERRAFORM_KICS"
                ]
              ],
        },
  }
in

{
  ACTION_ACTIONLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    ACTION_ACTIONLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  ACTION_ACTIONLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  ACTION_ACTIONLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  ACTION_ACTIONLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    ACTION_ACTIONLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  ACTION_ACTIONLINT_CONFIG_FILE
    | String
    | doc m%"
    ACTION_ACTIONLINT: User custom config file name if different from default
    "%
    | optional,
  ACTION_ACTIONLINT_DIRECTORY | String | optional,
  ACTION_ACTIONLINT_DISABLE_ERRORS | Bool | optional,
  ACTION_ACTIONLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  ACTION_ACTIONLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  ACTION_ACTIONLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  ACTION_ACTIONLINT_FILTER_REGEX_EXCLUDE | String | optional,
  ACTION_ACTIONLINT_FILTER_REGEX_INCLUDE | String | optional,
  ACTION_ACTIONLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  ACTION_ACTIONLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  ACTION_ACTIONLINT_RULES_PATH
    | String
    | doc m%"
    ACTION_ACTIONLINT: Path where to find linter configuration file
    "%
    | optional,
  ACTION_ACTIONLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling ACTION_ACTIONLINT and its pre/post commands
    "%
    | optional,
  ACTION_FILTER_REGEX_EXCLUDE | String | optional,
  ACTION_FILTER_REGEX_INCLUDE | String | optional,
  ADDITIONAL_EXCLUDED_DIRECTORIES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of additional excluded directory basenames to add to MegaLinter default excluded directories. They are excluded at any nested level.
    "%
    | optional,
  ANSIBLE_ANSIBLE_LINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    ANSIBLE_ANSIBLE_LINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  ANSIBLE_ANSIBLE_LINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  ANSIBLE_ANSIBLE_LINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    ANSIBLE_ANSIBLE_LINT: User custom arguments to remove before calling linter
    "%
    | optional,
  ANSIBLE_ANSIBLE_LINT_CONFIG_FILE
    | String
    | doc m%"
    ANSIBLE_ANSIBLE_LINT: User custom config file name if different from default
    "%
    | optional,
  ANSIBLE_ANSIBLE_LINT_DIRECTORY | String | optional,
  ANSIBLE_ANSIBLE_LINT_DISABLE_ERRORS | Bool | optional,
  ANSIBLE_ANSIBLE_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  ANSIBLE_ANSIBLE_LINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  ANSIBLE_ANSIBLE_LINT_FILE_NAME
    | String
    | doc m%"
    ANSIBLE_ANSIBLE_LINT: User custom config file name if different from default
    "%
    | optional,
  ANSIBLE_ANSIBLE_LINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  ANSIBLE_ANSIBLE_LINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  ANSIBLE_ANSIBLE_LINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  ANSIBLE_ANSIBLE_LINT_RULES_PATH
    | String
    | doc m%"
    ANSIBLE_ANSIBLE_LINT: Path where to find linter configuration file
    "%
    | optional,
  ANSIBLE_ANSIBLE_LINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling ANSIBLE_ANSIBLE_LINT and its pre/post commands
    "%
    | optional,
  ANSIBLE_DIRECTORY | String | optional,
  ANSIBLE_FILTER_REGEX_EXCLUDE | String | optional,
  ANSIBLE_FILTER_REGEX_INCLUDE | String | optional,
  APPLY_FIXES
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ predicates.isType '"Array", predicates.isType '"String" ])
    | doc m%"
    'all' to apply formatting and auto-fixes of all linters, or a list of linter keys
    "%
    | optional,
  ARM_ARM_TTK_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    ARM_ARM_TTK: User custom arguments to add in linter CLI call
    "%
    | optional,
  ARM_ARM_TTK_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  ARM_ARM_TTK_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  ARM_ARM_TTK_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    ARM_ARM_TTK: User custom arguments to remove before calling linter
    "%
    | optional,
  ARM_ARM_TTK_CONFIG_FILE
    | String
    | doc m%"
    ARM_ARM_TTK: User custom config file name if different from default
    "%
    | optional,
  ARM_ARM_TTK_DISABLE_ERRORS | Bool | optional,
  ARM_ARM_TTK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  ARM_ARM_TTK_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  ARM_ARM_TTK_FILE_NAME
    | String
    | doc m%"
    ARM_ARM_TTK: User custom config file name if different from default
    "%
    | optional,
  ARM_ARM_TTK_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  ARM_ARM_TTK_FILTER_REGEX_EXCLUDE | String | optional,
  ARM_ARM_TTK_FILTER_REGEX_INCLUDE | String | optional,
  ARM_ARM_TTK_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  ARM_ARM_TTK_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  ARM_ARM_TTK_RULES_PATH
    | String
    | doc m%"
    ARM_ARM_TTK: Path where to find linter configuration file
    "%
    | optional,
  ARM_ARM_TTK_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling ARM_ARM_TTK and its pre/post commands
    "%
    | optional,
  ARM_FILTER_REGEX_EXCLUDE | String | optional,
  ARM_FILTER_REGEX_INCLUDE | String | optional,
  AZURE_COMMENT_REPORTER
    | Bool
    | doc m%"
    Posts MegaLinter results summary in the comments of the related pull request (if existing)
    "%
    | optional,
  AZURE_COMMENT_REPORTER_LINKS_TYPE
    | std.enum.TagOrString
    | [| 'build, 'artifacts |]
    | optional,
  BASH_EXEC_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    BASH_EXEC: User custom arguments to add in linter CLI call
    "%
    | optional,
  BASH_EXEC_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  BASH_EXEC_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  BASH_EXEC_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    BASH_EXEC: User custom arguments to remove before calling linter
    "%
    | optional,
  BASH_EXEC_DISABLE_ERRORS | Bool | optional,
  BASH_EXEC_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  BASH_EXEC_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  BASH_EXEC_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  BASH_EXEC_FILTER_REGEX_EXCLUDE | String | optional,
  BASH_EXEC_FILTER_REGEX_INCLUDE | String | optional,
  BASH_EXEC_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  BASH_EXEC_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  BASH_EXEC_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling BASH_EXEC and its pre/post commands
    "%
    | optional,
  BASH_FILTER_REGEX_EXCLUDE | String | optional,
  BASH_FILTER_REGEX_INCLUDE | String | optional,
  BASH_SHELLCHECK_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    BASH_SHELLCHECK: User custom arguments to add in linter CLI call
    "%
    | optional,
  BASH_SHELLCHECK_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  BASH_SHELLCHECK_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  BASH_SHELLCHECK_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    BASH_SHELLCHECK: User custom arguments to remove before calling linter
    "%
    | optional,
  BASH_SHELLCHECK_DISABLE_ERRORS | Bool | optional,
  BASH_SHELLCHECK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  BASH_SHELLCHECK_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  BASH_SHELLCHECK_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  BASH_SHELLCHECK_FILTER_REGEX_EXCLUDE | String | optional,
  BASH_SHELLCHECK_FILTER_REGEX_INCLUDE | String | optional,
  BASH_SHELLCHECK_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  BASH_SHELLCHECK_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  BASH_SHELLCHECK_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling BASH_SHELLCHECK and its pre/post commands
    "%
    | optional,
  BASH_SHFMT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    BASH_SHFMT: User custom arguments to add in linter CLI call
    "%
    | optional,
  BASH_SHFMT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  BASH_SHFMT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  BASH_SHFMT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    BASH_SHFMT: User custom arguments to remove before calling linter
    "%
    | optional,
  BASH_SHFMT_DISABLE_ERRORS | Bool | optional,
  BASH_SHFMT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  BASH_SHFMT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  BASH_SHFMT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  BASH_SHFMT_FILTER_REGEX_EXCLUDE | String | optional,
  BASH_SHFMT_FILTER_REGEX_INCLUDE | String | optional,
  BASH_SHFMT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  BASH_SHFMT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  BASH_SHFMT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling BASH_SHFMT and its pre/post commands
    "%
    | optional,
  BICEP_BICEP_LINTER_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    BICEP_BICEP_LINTER: User custom arguments to add in linter CLI call
    "%
    | optional,
  BICEP_BICEP_LINTER_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  BICEP_BICEP_LINTER_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  BICEP_BICEP_LINTER_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    BICEP_BICEP_LINTER: User custom arguments to remove before calling linter
    "%
    | optional,
  BICEP_BICEP_LINTER_DISABLE_ERRORS | Bool | optional,
  BICEP_BICEP_LINTER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  BICEP_BICEP_LINTER_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  BICEP_BICEP_LINTER_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  BICEP_BICEP_LINTER_FILTER_REGEX_EXCLUDE | String | optional,
  BICEP_BICEP_LINTER_FILTER_REGEX_INCLUDE | String | optional,
  BICEP_BICEP_LINTER_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  BICEP_BICEP_LINTER_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  BICEP_BICEP_LINTER_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling BICEP_BICEP_LINTER and its pre/post commands
    "%
    | optional,
  BICEP_FILTER_REGEX_EXCLUDE | String | optional,
  BICEP_FILTER_REGEX_INCLUDE | String | optional,
  CLEAR_REPORT_FOLDER
    | Bool
    | doc m%"
    Flag to clear files from report folder (usually megalinter-reports) before starting the linting process
    "%
    | optional,
  CLOJURE_CLJSTYLE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CLOJURE_CLJSTYLE: User custom arguments to add in linter CLI call
    "%
    | optional,
  CLOJURE_CLJSTYLE_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CLOJURE_CLJSTYLE_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  CLOJURE_CLJSTYLE_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CLOJURE_CLJSTYLE: User custom arguments to remove before calling linter
    "%
    | optional,
  CLOJURE_CLJSTYLE_CONFIG_FILE
    | String
    | doc m%"
    CLOJURE_CLJSTYLE: User custom config file name if different from default
    "%
    | optional,
  CLOJURE_CLJSTYLE_DISABLE_ERRORS | Bool | optional,
  CLOJURE_CLJSTYLE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  CLOJURE_CLJSTYLE_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CLOJURE_CLJSTYLE_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CLOJURE_CLJSTYLE_FILTER_REGEX_EXCLUDE | String | optional,
  CLOJURE_CLJSTYLE_FILTER_REGEX_INCLUDE | String | optional,
  CLOJURE_CLJSTYLE_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CLOJURE_CLJSTYLE_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CLOJURE_CLJSTYLE_RULES_PATH
    | String
    | doc m%"
    CLOJURE_CLJSTYLE: Path where to find linter configuration file
    "%
    | optional,
  CLOJURE_CLJSTYLE_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling CLOJURE_CLJSTYLE and its pre/post commands
    "%
    | optional,
  CLOJURE_CLJ_KONDO_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CLOJURE_CLJ_KONDO: User custom arguments to add in linter CLI call
    "%
    | optional,
  CLOJURE_CLJ_KONDO_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CLOJURE_CLJ_KONDO_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  CLOJURE_CLJ_KONDO_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CLOJURE_CLJ_KONDO: User custom arguments to remove before calling linter
    "%
    | optional,
  CLOJURE_CLJ_KONDO_CONFIG_FILE
    | String
    | doc m%"
    CLOJURE_CLJ_KONDO: User custom config file name if different from default
    "%
    | optional,
  CLOJURE_CLJ_KONDO_DISABLE_ERRORS | Bool | optional,
  CLOJURE_CLJ_KONDO_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  CLOJURE_CLJ_KONDO_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CLOJURE_CLJ_KONDO_FILE_NAME
    | String
    | doc m%"
    CLOJURE_CLJ_KONDO: User custom config file name if different from default
    "%
    | optional,
  CLOJURE_CLJ_KONDO_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CLOJURE_CLJ_KONDO_FILTER_REGEX_EXCLUDE | String | optional,
  CLOJURE_CLJ_KONDO_FILTER_REGEX_INCLUDE | String | optional,
  CLOJURE_CLJ_KONDO_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CLOJURE_CLJ_KONDO_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CLOJURE_CLJ_KONDO_RULES_PATH
    | String
    | doc m%"
    CLOJURE_CLJ_KONDO: Path where to find linter configuration file
    "%
    | optional,
  CLOJURE_CLJ_KONDO_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling CLOJURE_CLJ_KONDO and its pre/post commands
    "%
    | optional,
  CLOJURE_FILTER_REGEX_EXCLUDE | String | optional,
  CLOJURE_FILTER_REGEX_INCLUDE | String | optional,
  CLOUDFORMATION_CFN_LINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CLOUDFORMATION_CFN_LINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  CLOUDFORMATION_CFN_LINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CLOUDFORMATION_CFN_LINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  CLOUDFORMATION_CFN_LINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CLOUDFORMATION_CFN_LINT: User custom arguments to remove before calling linter
    "%
    | optional,
  CLOUDFORMATION_CFN_LINT_CONFIG_FILE
    | String
    | doc m%"
    CLOUDFORMATION_CFN_LINT: User custom config file name if different from default
    "%
    | optional,
  CLOUDFORMATION_CFN_LINT_DISABLE_ERRORS | Bool | optional,
  CLOUDFORMATION_CFN_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  CLOUDFORMATION_CFN_LINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CLOUDFORMATION_CFN_LINT_FILE_NAME
    | String
    | doc m%"
    CLOUDFORMATION_CFN_LINT: User custom config file name if different from default
    "%
    | optional,
  CLOUDFORMATION_CFN_LINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CLOUDFORMATION_CFN_LINT_FILTER_REGEX_EXCLUDE | String | optional,
  CLOUDFORMATION_CFN_LINT_FILTER_REGEX_INCLUDE | String | optional,
  CLOUDFORMATION_CFN_LINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CLOUDFORMATION_CFN_LINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CLOUDFORMATION_CFN_LINT_RULES_PATH
    | String
    | doc m%"
    CLOUDFORMATION_CFN_LINT: Path where to find linter configuration file
    "%
    | optional,
  CLOUDFORMATION_CFN_LINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling CLOUDFORMATION_CFN_LINT and its pre/post commands
    "%
    | optional,
  CLOUDFORMATION_FILTER_REGEX_EXCLUDE | String | optional,
  CLOUDFORMATION_FILTER_REGEX_INCLUDE | String | optional,
  COFFEE_COFFEELINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    COFFEE_COFFEELINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  COFFEE_COFFEELINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  COFFEE_COFFEELINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  COFFEE_COFFEELINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    COFFEE_COFFEELINT: User custom arguments to remove before calling linter
    "%
    | optional,
  COFFEE_COFFEELINT_CONFIG_FILE
    | String
    | doc m%"
    COFFEE_COFFEELINT: User custom config file name if different from default
    "%
    | optional,
  COFFEE_COFFEELINT_DISABLE_ERRORS | Bool | optional,
  COFFEE_COFFEELINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  COFFEE_COFFEELINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  COFFEE_COFFEELINT_FILE_NAME
    | String
    | doc m%"
    COFFEE_COFFEELINT: User custom config file name if different from default
    "%
    | optional,
  COFFEE_COFFEELINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  COFFEE_COFFEELINT_FILTER_REGEX_EXCLUDE | String | optional,
  COFFEE_COFFEELINT_FILTER_REGEX_INCLUDE | String | optional,
  COFFEE_COFFEELINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  COFFEE_COFFEELINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  COFFEE_COFFEELINT_RULES_PATH
    | String
    | doc m%"
    COFFEE_COFFEELINT: Path where to find linter configuration file
    "%
    | optional,
  COFFEE_COFFEELINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling COFFEE_COFFEELINT and its pre/post commands
    "%
    | optional,
  COFFEE_FILTER_REGEX_EXCLUDE | String | optional,
  COFFEE_FILTER_REGEX_INCLUDE | String | optional,
  CONFIG_REPORTER
    | Bool
    | doc m%"
    Generates a folder IDE-config located in report folder, containing default MegaLinter configuration files used during the linting, and updated VSCode extensions.js config file
    "%
    | optional,
  CONFIG_REPORTER_SUB_FOLDER | String | optional,
  CONSOLE_REPORTER
    | Bool
    | doc m%"
    
    "%
    | optional,
  CONSOLE_REPORTER_SECTIONS
    | Bool
    | doc m%"
    Define to false if you do not want logs to be organized in sections
    "%
    | optional,
  COPYPASTE_FILTER_REGEX_EXCLUDE | String | optional,
  COPYPASTE_FILTER_REGEX_INCLUDE | String | optional,
  COPYPASTE_JSCPD_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    COPYPASTE_JSCPD: User custom arguments to add in linter CLI call
    "%
    | optional,
  COPYPASTE_JSCPD_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  COPYPASTE_JSCPD_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    COPYPASTE_JSCPD: User custom arguments to remove before calling linter
    "%
    | optional,
  COPYPASTE_JSCPD_CONFIG_FILE
    | String
    | doc m%"
    COPYPASTE_JSCPD: User custom config file name if different from default
    "%
    | optional,
  COPYPASTE_JSCPD_DISABLE_ERRORS | Bool | optional,
  COPYPASTE_JSCPD_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  COPYPASTE_JSCPD_FILE_NAME
    | String
    | doc m%"
    COPYPASTE_JSCPD: User custom config file name if different from default
    "%
    | optional,
  COPYPASTE_JSCPD_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  COPYPASTE_JSCPD_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  COPYPASTE_JSCPD_RULES_PATH
    | String
    | doc m%"
    COPYPASTE_JSCPD: Path where to find linter configuration file
    "%
    | optional,
  COPYPASTE_JSCPD_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling COPYPASTE_JSCPD and its pre/post commands
    "%
    | optional,
  CPP_CPPLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CPP_CPPLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  CPP_CPPLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CPP_CPPLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  CPP_CPPLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CPP_CPPLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  CPP_CPPLINT_DISABLE_ERRORS | Bool | optional,
  CPP_CPPLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  CPP_CPPLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CPP_CPPLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CPP_CPPLINT_FILTER_REGEX_EXCLUDE | String | optional,
  CPP_CPPLINT_FILTER_REGEX_INCLUDE | String | optional,
  CPP_CPPLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CPP_CPPLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CPP_CPPLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling CPP_CPPLINT and its pre/post commands
    "%
    | optional,
  CPP_FILTER_REGEX_EXCLUDE | String | optional,
  CPP_FILTER_REGEX_INCLUDE | String | optional,
  CREDENTIALS_FILTER_REGEX_EXCLUDE | String | optional,
  CREDENTIALS_FILTER_REGEX_INCLUDE | String | optional,
  CREDENTIALS_SECRETLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CREDENTIALS_SECRETLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  CREDENTIALS_SECRETLINT_CONFIG_FILE
    | String
    | doc m%"
    CREDENTIALS_SECRETLINT: User custom config file name if different from default
    "%
    | optional,
  CREDENTIALS_SECRETLINT_DISABLE_ERRORS | Bool | optional,
  CREDENTIALS_SECRETLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  CREDENTIALS_SECRETLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CREDENTIALS_SECRETLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CREDENTIALS_SECRETLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CREDENTIALS_SECRETLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CREDENTIALS_SECRETLINT_RULES_PATH
    | String
    | doc m%"
    CREDENTIALS_SECRETLINT: Path where to find linter configuration file
    "%
    | optional,
  CSHARP_CSHARPIER_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CSHARP_CSHARPIER: User custom arguments to add in linter CLI call
    "%
    | optional,
  CSHARP_CSHARPIER_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CSHARP_CSHARPIER_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  CSHARP_CSHARPIER_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CSHARP_CSHARPIER: User custom arguments to remove before calling linter
    "%
    | optional,
  CSHARP_CSHARPIER_DISABLE_ERRORS | Bool | optional,
  CSHARP_CSHARPIER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  CSHARP_CSHARPIER_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CSHARP_CSHARPIER_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CSHARP_CSHARPIER_FILTER_REGEX_EXCLUDE | String | optional,
  CSHARP_CSHARPIER_FILTER_REGEX_INCLUDE | String | optional,
  CSHARP_CSHARPIER_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CSHARP_CSHARPIER_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CSHARP_CSHARPIER_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling CSHARP_CSHARPIER and its pre/post commands
    "%
    | optional,
  CSHARP_DOTNET_FORMAT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CSHARP_DOTNET_FORMAT: User custom arguments to add in linter CLI call
    "%
    | optional,
  CSHARP_DOTNET_FORMAT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CSHARP_DOTNET_FORMAT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  CSHARP_DOTNET_FORMAT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CSHARP_DOTNET_FORMAT: User custom arguments to remove before calling linter
    "%
    | optional,
  CSHARP_DOTNET_FORMAT_DISABLE_ERRORS | Bool | optional,
  CSHARP_DOTNET_FORMAT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  CSHARP_DOTNET_FORMAT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CSHARP_DOTNET_FORMAT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CSHARP_DOTNET_FORMAT_FILTER_REGEX_EXCLUDE | String | optional,
  CSHARP_DOTNET_FORMAT_FILTER_REGEX_INCLUDE | String | optional,
  CSHARP_DOTNET_FORMAT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CSHARP_DOTNET_FORMAT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CSHARP_DOTNET_FORMAT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling CSHARP_DOTNET_FORMAT and its pre/post commands
    "%
    | optional,
  CSHARP_FILTER_REGEX_EXCLUDE | String | optional,
  CSHARP_FILTER_REGEX_INCLUDE | String | optional,
  CSS_FILTER_REGEX_EXCLUDE | String | optional,
  CSS_FILTER_REGEX_INCLUDE | String | optional,
  CSS_SCSS_LINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CSS_SCSS_LINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  CSS_SCSS_LINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CSS_SCSS_LINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  CSS_SCSS_LINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CSS_SCSS_LINT: User custom arguments to remove before calling linter
    "%
    | optional,
  CSS_SCSS_LINT_CONFIG_FILE
    | String
    | doc m%"
    CSS_SCSS_LINT: User custom config file name if different from default
    "%
    | optional,
  CSS_SCSS_LINT_DISABLE_ERRORS | Bool | optional,
  CSS_SCSS_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  CSS_SCSS_LINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CSS_SCSS_LINT_FILE_NAME
    | String
    | doc m%"
    CSS_SCSS_LINT: User custom config file name if different from default
    "%
    | optional,
  CSS_SCSS_LINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CSS_SCSS_LINT_FILTER_REGEX_EXCLUDE | String | optional,
  CSS_SCSS_LINT_FILTER_REGEX_INCLUDE | String | optional,
  CSS_SCSS_LINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CSS_SCSS_LINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CSS_SCSS_LINT_RULES_PATH
    | String
    | doc m%"
    CSS_SCSS_LINT: Path where to find linter configuration file
    "%
    | optional,
  CSS_SCSS_LINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling CSS_SCSS_LINT and its pre/post commands
    "%
    | optional,
  CSS_STYLELINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CSS_STYLELINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  CSS_STYLELINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CSS_STYLELINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  CSS_STYLELINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    CSS_STYLELINT: User custom arguments to remove before calling linter
    "%
    | optional,
  CSS_STYLELINT_CONFIG_FILE
    | String
    | doc m%"
    CSS_STYLELINT: User custom config file name if different from default
    "%
    | optional,
  CSS_STYLELINT_DISABLE_ERRORS | Bool | optional,
  CSS_STYLELINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  CSS_STYLELINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CSS_STYLELINT_FILE_NAME
    | String
    | doc m%"
    CSS_STYLELINT: User custom config file name if different from default
    "%
    | optional,
  CSS_STYLELINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  CSS_STYLELINT_FILTER_REGEX_EXCLUDE | String | optional,
  CSS_STYLELINT_FILTER_REGEX_INCLUDE | String | optional,
  CSS_STYLELINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CSS_STYLELINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  CSS_STYLELINT_RULES_PATH
    | String
    | doc m%"
    CSS_STYLELINT: Path where to find linter configuration file
    "%
    | optional,
  CSS_STYLELINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling CSS_STYLELINT and its pre/post commands
    "%
    | optional,
  C_CPPLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    C_CPPLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  C_CPPLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  C_CPPLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  C_CPPLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    C_CPPLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  C_CPPLINT_DISABLE_ERRORS | Bool | optional,
  C_CPPLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  C_CPPLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  C_CPPLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  C_CPPLINT_FILTER_REGEX_EXCLUDE | String | optional,
  C_CPPLINT_FILTER_REGEX_INCLUDE | String | optional,
  C_CPPLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  C_CPPLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  C_CPPLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling C_CPPLINT and its pre/post commands
    "%
    | optional,
  C_FILTER_REGEX_EXCLUDE | String | optional,
  C_FILTER_REGEX_INCLUDE | String | optional,
  DART_DARTANALYZER_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    DART_DARTANALYZER: User custom arguments to add in linter CLI call
    "%
    | optional,
  DART_DARTANALYZER_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  DART_DARTANALYZER_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  DART_DARTANALYZER_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    DART_DARTANALYZER: User custom arguments to remove before calling linter
    "%
    | optional,
  DART_DARTANALYZER_CONFIG_FILE
    | String
    | doc m%"
    DART_DARTANALYZER: User custom config file name if different from default
    "%
    | optional,
  DART_DARTANALYZER_DISABLE_ERRORS | Bool | optional,
  DART_DARTANALYZER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  DART_DARTANALYZER_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  DART_DARTANALYZER_FILE_NAME
    | String
    | doc m%"
    DART_DARTANALYZER: User custom config file name if different from default
    "%
    | optional,
  DART_DARTANALYZER_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  DART_DARTANALYZER_FILTER_REGEX_EXCLUDE | String | optional,
  DART_DARTANALYZER_FILTER_REGEX_INCLUDE | String | optional,
  DART_DARTANALYZER_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  DART_DARTANALYZER_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  DART_DARTANALYZER_RULES_PATH
    | String
    | doc m%"
    DART_DARTANALYZER: Path where to find linter configuration file
    "%
    | optional,
  DART_DARTANALYZER_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling DART_DARTANALYZER and its pre/post commands
    "%
    | optional,
  DART_FILTER_REGEX_EXCLUDE | String | optional,
  DART_FILTER_REGEX_INCLUDE | String | optional,
  DEFAULT_BRANCH
    | String
    | doc m%"
    Deprecated: The name of the repository's default branch.
    "%
    | optional,
  DEFAULT_WORKSPACE
    | String
    | doc m%"
    The location containing files to lint if you are running as docker image
    "%
    | optional,
  DISABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.enum_descriptor_keys
    ])
    | doc m%"
    If DISABLE is set, the linters in the listed descriptors will be skipped
    "%
    | optional,
  DISABLE_ERRORS
    | Bool
    | doc m%"
    Flag to have the MegaLinter complete with exit code 0 even if errors were detected.
    "%
    | optional,
  DISABLE_ERRORS_LINTERS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.enum_linter_keys
    ])
    | doc m%"
    If DISABLE_ERRORS_LINTERS is set, the listed linters will be run but errors will be not blocking
    "%
    | optional,
  DISABLE_LINTERS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.enum_linter_keys
    ])
    | doc m%"
    If DISABLE_LINTERS is set, the listed linters will be skipped
    "%
    | optional,
  DOCKERFILE_DOCKERFILELINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    DOCKERFILE_DOCKERFILELINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  DOCKERFILE_DOCKERFILELINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  DOCKERFILE_DOCKERFILELINT_CONFIG_FILE
    | String
    | doc m%"
    DOCKERFILE_DOCKERFILELINT: User custom config file name if different from default
    "%
    | optional,
  DOCKERFILE_DOCKERFILELINT_DISABLE_ERRORS | Bool | optional,
  DOCKERFILE_DOCKERFILELINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  DOCKERFILE_DOCKERFILELINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  DOCKERFILE_DOCKERFILELINT_FILE_NAME
    | String
    | doc m%"
    DOCKERFILE_DOCKERFILELINT: User custom config file name if different from default
    "%
    | optional,
  DOCKERFILE_DOCKERFILELINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  DOCKERFILE_DOCKERFILELINT_FILTER_REGEX_EXCLUDE | String | optional,
  DOCKERFILE_DOCKERFILELINT_FILTER_REGEX_INCLUDE | String | optional,
  DOCKERFILE_DOCKERFILELINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  DOCKERFILE_DOCKERFILELINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  DOCKERFILE_DOCKERFILELINT_RULES_PATH
    | String
    | doc m%"
    DOCKERFILE_DOCKERFILELINT: Path where to find linter configuration file
    "%
    | optional,
  DOCKERFILE_FILTER_REGEX_EXCLUDE | String | optional,
  DOCKERFILE_FILTER_REGEX_INCLUDE | String | optional,
  DOCKERFILE_HADOLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    DOCKERFILE_HADOLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  DOCKERFILE_HADOLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  DOCKERFILE_HADOLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  DOCKERFILE_HADOLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    DOCKERFILE_HADOLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  DOCKERFILE_HADOLINT_CONFIG_FILE
    | String
    | doc m%"
    DOCKERFILE_HADOLINT: User custom config file name if different from default
    "%
    | optional,
  DOCKERFILE_HADOLINT_DISABLE_ERRORS | Bool | optional,
  DOCKERFILE_HADOLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  DOCKERFILE_HADOLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  DOCKERFILE_HADOLINT_FILE_NAME
    | String
    | doc m%"
    DOCKERFILE_HADOLINT: User custom config file name if different from default
    "%
    | optional,
  DOCKERFILE_HADOLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  DOCKERFILE_HADOLINT_FILTER_REGEX_EXCLUDE | String | optional,
  DOCKERFILE_HADOLINT_FILTER_REGEX_INCLUDE | String | optional,
  DOCKERFILE_HADOLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  DOCKERFILE_HADOLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  DOCKERFILE_HADOLINT_RULES_PATH
    | String
    | doc m%"
    DOCKERFILE_HADOLINT: Path where to find linter configuration file
    "%
    | optional,
  DOCKERFILE_HADOLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling DOCKERFILE_HADOLINT and its pre/post commands
    "%
    | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    EDITORCONFIG_EDITORCONFIG_CHECKER: User custom arguments to add in linter CLI call
    "%
    | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    EDITORCONFIG_EDITORCONFIG_CHECKER: User custom arguments to remove before calling linter
    "%
    | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_CONFIG_FILE
    | String
    | doc m%"
    EDITORCONFIG_EDITORCONFIG_CHECKER: User custom config file name if different from default
    "%
    | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_DISABLE_ERRORS | Bool | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_DISABLE_ERRORS_IF_LESS_THAN
    | Number
    | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_FILE_NAME
    | String
    | doc m%"
    EDITORCONFIG_EDITORCONFIG_CHECKER: User custom config file name if different from default
    "%
    | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_FILTER_REGEX_EXCLUDE | String | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_FILTER_REGEX_INCLUDE | String | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_RULES_PATH
    | String
    | doc m%"
    EDITORCONFIG_EDITORCONFIG_CHECKER: Path where to find linter configuration file
    "%
    | optional,
  EDITORCONFIG_EDITORCONFIG_CHECKER_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling EDITORCONFIG_EDITORCONFIG_CHECKER and its pre/post commands
    "%
    | optional,
  EDITORCONFIG_FILTER_REGEX_EXCLUDE | String | optional,
  EDITORCONFIG_FILTER_REGEX_INCLUDE | String | optional,
  EMAIL_REPORTER
    | Bool
    | doc m%"
    MegaLinter can send email with reports to given addresses. Please set EMAIL_REPORTER_** variables if activated
    "%
    | optional,
  EMAIL_REPORTER_EMAIL
    | String
    | doc m%"
    Comma-separated list of recipient emails, that will receive reports
    "%
    | optional,
  EMAIL_REPORTER_SENDER | String | optional,
  EMAIL_REPORTER_SEND_SUCCESS
    | Bool
    | doc m%"
    Define to true if you want to receive reports by mail even when there is no errors or updated sources
    "%
    | optional,
  EMAIL_REPORTER_SMTP_HOST | String | optional,
  EMAIL_REPORTER_SMTP_PASSWORD | String | optional,
  EMAIL_REPORTER_SMTP_PORT | Number | optional,
  EMAIL_REPORTER_SMTP_USERNAME | String | optional,
  ENABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.enum_descriptor_keys
    ])
    | doc m%"
    If ENABLE is not set, all descriptors are activated by default. If set, all linters of listed descriptors will be activated by default
    "%
    | optional,
  ENABLE_LINTERS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.enum_linter_keys
    ])
    | doc m%"
    If ENABLE_LINTERS is set, only listed linters will be processed
    "%
    | optional,
  ENV_DOTENV_LINTER_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    ENV_DOTENV_LINTER: User custom arguments to add in linter CLI call
    "%
    | optional,
  ENV_DOTENV_LINTER_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  ENV_DOTENV_LINTER_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  ENV_DOTENV_LINTER_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    ENV_DOTENV_LINTER: User custom arguments to remove before calling linter
    "%
    | optional,
  ENV_DOTENV_LINTER_DISABLE_ERRORS | Bool | optional,
  ENV_DOTENV_LINTER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  ENV_DOTENV_LINTER_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  ENV_DOTENV_LINTER_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  ENV_DOTENV_LINTER_FILTER_REGEX_EXCLUDE | String | optional,
  ENV_DOTENV_LINTER_FILTER_REGEX_INCLUDE | String | optional,
  ENV_DOTENV_LINTER_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  ENV_DOTENV_LINTER_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  ENV_DOTENV_LINTER_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling ENV_DOTENV_LINTER and its pre/post commands
    "%
    | optional,
  ENV_FILTER_REGEX_EXCLUDE | String | optional,
  ENV_FILTER_REGEX_INCLUDE | String | optional,
  ERROR_ON_MISSING_EXEC_BIT
    | Bool
    | doc m%"
    If set to `false`, the `bash-exec` linter will report a warning if a shell script is not executable. If set to `true`, the `bash-exec` linter will report an error instead
    "%
    | optional,
  EXCLUDED_DIRECTORIES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of excluded directory basenames replacing MegaLinter default excluded directories. They are excluded at any nested level.
    "%
    | optional,
  EXTENDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Base mega-linter.yml config file(s) to extend local configuration from. Can be a single URL or a list of .mega-linter.yml config files URLs
    "%
    | optional,
  FAIL_IF_MISSING_LINTER_IN_FLAVOR
    | Bool
    | doc m%"
    If set to true, MegaLinter fails if a linter is missing in the selected flavor
    "%
    | optional,
  FAIL_IF_UPDATED_SOURCES
    | Bool
    | doc m%"
    If set to true, MegaLinter fails if a linter or formatter has auto-fixed sources, even if there are no errors
    "%
    | optional,
  FILEIO_REPORTER
    | Bool
    | doc m%"
    If you don't use artifacts upload to read MegaLinter reports, you can access them with an hyperlink to file.io. Important: MegaLinter has no affiliation with file.io, but it's supposed to be secured, and only one download is available for a report (snapchat for files, basically)
    "%
    | optional,
  FILEIO_REPORTER_SEND_SUCCESS
    | Bool
    | doc m%"
    Skip posting to file.io if linting is in success
    "%
    | optional,
  FILTER_REGEX_EXCLUDE
    | String
    | doc m%"
    Regular expression defining which files will be excluded from linting
    "%
    | optional,
  FILTER_REGEX_INCLUDE
    | String
    | doc m%"
    Regular expression defining which files will be processed by linters
    "%
    | optional,
  FLAVOR_SUGGESTIONS
    | Bool
    | doc m%"
    Provides suggestions about different MegaLinter flavors to use to improve runtime performances
    "%
    | optional,
  FORMATTERS_DISABLE_ERRORS
    | Bool
    | doc m%"
    Formatter errors will be reported as errors (and not warnings) if this variable is set to false
    "%
    | optional,
  GHERKIN_FILTER_REGEX_EXCLUDE | String | optional,
  GHERKIN_FILTER_REGEX_INCLUDE | String | optional,
  GHERKIN_GHERKIN_LINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    GHERKIN_GHERKIN_LINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  GHERKIN_GHERKIN_LINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GHERKIN_GHERKIN_LINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  GHERKIN_GHERKIN_LINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    GHERKIN_GHERKIN_LINT: User custom arguments to remove before calling linter
    "%
    | optional,
  GHERKIN_GHERKIN_LINT_CONFIG_FILE
    | String
    | doc m%"
    GHERKIN_GHERKIN_LINT: User custom config file name if different from default
    "%
    | optional,
  GHERKIN_GHERKIN_LINT_DISABLE_ERRORS | Bool | optional,
  GHERKIN_GHERKIN_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  GHERKIN_GHERKIN_LINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GHERKIN_GHERKIN_LINT_FILE_NAME
    | String
    | doc m%"
    GHERKIN_GHERKIN_LINT: User custom config file name if different from default
    "%
    | optional,
  GHERKIN_GHERKIN_LINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GHERKIN_GHERKIN_LINT_FILTER_REGEX_EXCLUDE | String | optional,
  GHERKIN_GHERKIN_LINT_FILTER_REGEX_INCLUDE | String | optional,
  GHERKIN_GHERKIN_LINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  GHERKIN_GHERKIN_LINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  GHERKIN_GHERKIN_LINT_RULES_PATH
    | String
    | doc m%"
    GHERKIN_GHERKIN_LINT: Path where to find linter configuration file
    "%
    | optional,
  GHERKIN_GHERKIN_LINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling GHERKIN_GHERKIN_LINT and its pre/post commands
    "%
    | optional,
  GITHUB_API_URL
    | String
    | doc m%"
    URL where the github API can be reached. Must be overridden if using GitHub Enterprise
    "%
    | optional,
  GITHUB_COMMENT_REPORTER
    | Bool
    | doc m%"
    Posts MegaLinter results summary in the comments of the related pull request (if existing)
    "%
    | optional,
  GITHUB_SERVER_URL
    | String
    | doc m%"
    URL of the GitHub instance. Must be overridden if using GitHub Enterprise
    "%
    | optional,
  GITHUB_STATUS_REPORTER
    | Bool
    | doc m%"
    Posts a status on the pull request for each processed linter
    "%
    | optional,
  GITHUB_WORKSPACE
    | String
    | doc m%"
    Base directory for REPORT_OUTPUT_FOLDER, for user-defined linter rules location, for location of linted files if DEFAULT_WORKSPACE is not set
    "%
    | optional,
  GITLAB_ACCESS_TOKEN_MEGALINTER
    | String
    | doc m%"
    Gitlab access token with API access (can be user or project Access token)
    "%
    | optional,
  GITLAB_CERTIFICATE_PATH
    | String
    | doc m%"
    Path to SSL certificate if necessary
    "%
    | optional,
  GITLAB_COMMENT_REPORTER
    | Bool
    | doc m%"
    Posts Mega-Linter results summary in the comments of the related merge request (if existing)
    "%
    | optional,
  GITLAB_COMMENT_REPORTER_OVERWRITE_COMMENT
    | Bool
    | doc m%"
    Set to false to disable the overwrite of existing MegaLinter Merge Request comment in case of new run
    "%
    | optional,
  GITLAB_CUSTOM_CERTIFICATE
    | String
    | doc m%"
    Store your SSL certificate string value in a CI env variable named GITLAB_CUSTOM_CERTIFICATE if you want it to be copied by MegaLinter in a local certificate file that will be used by python gitlab lib
    "%
    | optional,
  GIT_FILTER_REGEX_EXCLUDE | String | optional,
  GIT_FILTER_REGEX_INCLUDE | String | optional,
  GIT_GIT_DIFF_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    GIT_GIT_DIFF: User custom arguments to add in linter CLI call
    "%
    | optional,
  GIT_GIT_DIFF_DISABLE_ERRORS | Bool | optional,
  GIT_GIT_DIFF_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  GIT_GIT_DIFF_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GIT_GIT_DIFF_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GIT_GIT_DIFF_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  GIT_GIT_DIFF_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  GO_FILTER_REGEX_EXCLUDE | String | optional,
  GO_FILTER_REGEX_INCLUDE | String | optional,
  GO_GOLANGCI_LINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    GO_GOLANGCI_LINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  GO_GOLANGCI_LINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GO_GOLANGCI_LINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  GO_GOLANGCI_LINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    GO_GOLANGCI_LINT: User custom arguments to remove before calling linter
    "%
    | optional,
  GO_GOLANGCI_LINT_CONFIG_FILE
    | String
    | doc m%"
    GO_GOLANGCI_LINT: User custom config file name if different from default
    "%
    | optional,
  GO_GOLANGCI_LINT_DISABLE_ERRORS | Bool | optional,
  GO_GOLANGCI_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  GO_GOLANGCI_LINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GO_GOLANGCI_LINT_FILE_NAME
    | String
    | doc m%"
    GO_GOLANGCI_LINT: User custom config file name if different from default
    "%
    | optional,
  GO_GOLANGCI_LINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GO_GOLANGCI_LINT_FILTER_REGEX_EXCLUDE | String | optional,
  GO_GOLANGCI_LINT_FILTER_REGEX_INCLUDE | String | optional,
  GO_GOLANGCI_LINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  GO_GOLANGCI_LINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  GO_GOLANGCI_LINT_RULES_PATH
    | String
    | doc m%"
    GO_GOLANGCI_LINT: Path where to find linter configuration file
    "%
    | optional,
  GO_GOLANGCI_LINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling GO_GOLANGCI_LINT and its pre/post commands
    "%
    | optional,
  GO_REVIVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    GO_REVIVE: User custom arguments to add in linter CLI call
    "%
    | optional,
  GO_REVIVE_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GO_REVIVE_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  GO_REVIVE_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    GO_REVIVE: User custom arguments to remove before calling linter
    "%
    | optional,
  GO_REVIVE_CONFIG_FILE
    | String
    | doc m%"
    GO_REVIVE: User custom config file name if different from default
    "%
    | optional,
  GO_REVIVE_DISABLE_ERRORS | Bool | optional,
  GO_REVIVE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  GO_REVIVE_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GO_REVIVE_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GO_REVIVE_FILTER_REGEX_EXCLUDE | String | optional,
  GO_REVIVE_FILTER_REGEX_INCLUDE | String | optional,
  GO_REVIVE_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  GO_REVIVE_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  GO_REVIVE_RULES_PATH
    | String
    | doc m%"
    GO_REVIVE: Path where to find linter configuration file
    "%
    | optional,
  GO_REVIVE_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling GO_REVIVE and its pre/post commands
    "%
    | optional,
  GRAPHQL_FILTER_REGEX_EXCLUDE | String | optional,
  GRAPHQL_FILTER_REGEX_INCLUDE | String | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    GRAPHQL_GRAPHQL_SCHEMA_LINTER: User custom arguments to add in linter CLI call
    "%
    | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    GRAPHQL_GRAPHQL_SCHEMA_LINTER: User custom arguments to remove before calling linter
    "%
    | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_CONFIG_FILE
    | String
    | doc m%"
    GRAPHQL_GRAPHQL_SCHEMA_LINTER: User custom config file name if different from default
    "%
    | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_DISABLE_ERRORS | Bool | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_FILE_NAME
    | String
    | doc m%"
    GRAPHQL_GRAPHQL_SCHEMA_LINTER: User custom config file name if different from default
    "%
    | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_FILTER_REGEX_EXCLUDE | String | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_FILTER_REGEX_INCLUDE | String | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_RULES_PATH
    | String
    | doc m%"
    GRAPHQL_GRAPHQL_SCHEMA_LINTER: Path where to find linter configuration file
    "%
    | optional,
  GRAPHQL_GRAPHQL_SCHEMA_LINTER_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling GRAPHQL_GRAPHQL_SCHEMA_LINTER and its pre/post commands
    "%
    | optional,
  GROOVY_FILTER_REGEX_EXCLUDE | String | optional,
  GROOVY_FILTER_REGEX_INCLUDE | String | optional,
  GROOVY_NPM_GROOVY_LINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    GROOVY_NPM_GROOVY_LINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  GROOVY_NPM_GROOVY_LINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GROOVY_NPM_GROOVY_LINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  GROOVY_NPM_GROOVY_LINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    GROOVY_NPM_GROOVY_LINT: User custom arguments to remove before calling linter
    "%
    | optional,
  GROOVY_NPM_GROOVY_LINT_CONFIG_FILE
    | String
    | doc m%"
    GROOVY_NPM_GROOVY_LINT: User custom config file name if different from default
    "%
    | optional,
  GROOVY_NPM_GROOVY_LINT_DISABLE_ERRORS | Bool | optional,
  GROOVY_NPM_GROOVY_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  GROOVY_NPM_GROOVY_LINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GROOVY_NPM_GROOVY_LINT_FILE_NAME
    | String
    | doc m%"
    GROOVY_NPM_GROOVY_LINT: User custom config file name if different from default
    "%
    | optional,
  GROOVY_NPM_GROOVY_LINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  GROOVY_NPM_GROOVY_LINT_FILTER_REGEX_EXCLUDE | String | optional,
  GROOVY_NPM_GROOVY_LINT_FILTER_REGEX_INCLUDE | String | optional,
  GROOVY_NPM_GROOVY_LINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  GROOVY_NPM_GROOVY_LINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  GROOVY_NPM_GROOVY_LINT_RULES_PATH
    | String
    | doc m%"
    GROOVY_NPM_GROOVY_LINT: Path where to find linter configuration file
    "%
    | optional,
  GROOVY_NPM_GROOVY_LINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling GROOVY_NPM_GROOVY_LINT and its pre/post commands
    "%
    | optional,
  HTML_DJLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    HTML_DJLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  HTML_DJLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  HTML_DJLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  HTML_DJLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    HTML_DJLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  HTML_DJLINT_DISABLE_ERRORS | Bool | optional,
  HTML_DJLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  HTML_DJLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  HTML_DJLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  HTML_DJLINT_FILTER_REGEX_EXCLUDE | String | optional,
  HTML_DJLINT_FILTER_REGEX_INCLUDE | String | optional,
  HTML_DJLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  HTML_DJLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  HTML_DJLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling HTML_DJLINT and its pre/post commands
    "%
    | optional,
  HTML_FILTER_REGEX_EXCLUDE | String | optional,
  HTML_FILTER_REGEX_INCLUDE | String | optional,
  HTML_HTMLHINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    HTML_HTMLHINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  HTML_HTMLHINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  HTML_HTMLHINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  HTML_HTMLHINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    HTML_HTMLHINT: User custom arguments to remove before calling linter
    "%
    | optional,
  HTML_HTMLHINT_CONFIG_FILE
    | String
    | doc m%"
    HTML_HTMLHINT: User custom config file name if different from default
    "%
    | optional,
  HTML_HTMLHINT_DISABLE_ERRORS | Bool | optional,
  HTML_HTMLHINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  HTML_HTMLHINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  HTML_HTMLHINT_FILE_NAME
    | String
    | doc m%"
    HTML_HTMLHINT: User custom config file name if different from default
    "%
    | optional,
  HTML_HTMLHINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  HTML_HTMLHINT_FILTER_REGEX_EXCLUDE | String | optional,
  HTML_HTMLHINT_FILTER_REGEX_INCLUDE | String | optional,
  HTML_HTMLHINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  HTML_HTMLHINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  HTML_HTMLHINT_RULES_PATH
    | String
    | doc m%"
    HTML_HTMLHINT: Path where to find linter configuration file
    "%
    | optional,
  HTML_HTMLHINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling HTML_HTMLHINT and its pre/post commands
    "%
    | optional,
  IGNORE_GENERATED_FILES | Bool | optional,
  IGNORE_GITIGNORED_FILES | Bool | optional,
  JAVASCRIPT_DEFAULT_STYLE
    | std.enum.TagOrString
    | [| 'prettier, 'standard |]
    | doc m%"
    Style of javascript formatting to apply
    "%
    | optional,
  JAVASCRIPT_ES_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JAVASCRIPT_ES: User custom arguments to add in linter CLI call
    "%
    | optional,
  JAVASCRIPT_ES_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVASCRIPT_ES_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  JAVASCRIPT_ES_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JAVASCRIPT_ES: User custom arguments to remove before calling linter
    "%
    | optional,
  JAVASCRIPT_ES_CONFIG_FILE
    | String
    | doc m%"
    JAVASCRIPT_ES: User custom config file name if different from default
    "%
    | optional,
  JAVASCRIPT_ES_DISABLE_ERRORS | Bool | optional,
  JAVASCRIPT_ES_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  JAVASCRIPT_ES_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVASCRIPT_ES_FILE_NAME
    | String
    | doc m%"
    JAVASCRIPT_ES: User custom config file name if different from default
    "%
    | optional,
  JAVASCRIPT_ES_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVASCRIPT_ES_FILTER_REGEX_EXCLUDE | String | optional,
  JAVASCRIPT_ES_FILTER_REGEX_INCLUDE | String | optional,
  JAVASCRIPT_ES_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JAVASCRIPT_ES_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JAVASCRIPT_ES_RULES_PATH
    | String
    | doc m%"
    JAVASCRIPT_ES: Path where to find linter configuration file
    "%
    | optional,
  JAVASCRIPT_ES_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling JAVASCRIPT_ES and its pre/post commands
    "%
    | optional,
  JAVASCRIPT_FILTER_REGEX_EXCLUDE | String | optional,
  JAVASCRIPT_FILTER_REGEX_INCLUDE | String | optional,
  JAVASCRIPT_PRETTIER_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JAVASCRIPT_PRETTIER: User custom arguments to add in linter CLI call
    "%
    | optional,
  JAVASCRIPT_PRETTIER_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVASCRIPT_PRETTIER_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  JAVASCRIPT_PRETTIER_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JAVASCRIPT_PRETTIER: User custom arguments to remove before calling linter
    "%
    | optional,
  JAVASCRIPT_PRETTIER_CONFIG_FILE
    | String
    | doc m%"
    JAVASCRIPT_PRETTIER: User custom config file name if different from default
    "%
    | optional,
  JAVASCRIPT_PRETTIER_DISABLE_ERRORS | Bool | optional,
  JAVASCRIPT_PRETTIER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  JAVASCRIPT_PRETTIER_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVASCRIPT_PRETTIER_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVASCRIPT_PRETTIER_FILTER_REGEX_EXCLUDE | String | optional,
  JAVASCRIPT_PRETTIER_FILTER_REGEX_INCLUDE | String | optional,
  JAVASCRIPT_PRETTIER_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JAVASCRIPT_PRETTIER_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JAVASCRIPT_PRETTIER_RULES_PATH
    | String
    | doc m%"
    JAVASCRIPT_PRETTIER: Path where to find linter configuration file
    "%
    | optional,
  JAVASCRIPT_PRETTIER_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling JAVASCRIPT_PRETTIER and its pre/post commands
    "%
    | optional,
  JAVASCRIPT_STANDARD_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JAVASCRIPT_STANDARD: User custom arguments to add in linter CLI call
    "%
    | optional,
  JAVASCRIPT_STANDARD_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVASCRIPT_STANDARD_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  JAVASCRIPT_STANDARD_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JAVASCRIPT_STANDARD: User custom arguments to remove before calling linter
    "%
    | optional,
  JAVASCRIPT_STANDARD_DISABLE_ERRORS | Bool | optional,
  JAVASCRIPT_STANDARD_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  JAVASCRIPT_STANDARD_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVASCRIPT_STANDARD_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVASCRIPT_STANDARD_FILTER_REGEX_EXCLUDE | String | optional,
  JAVASCRIPT_STANDARD_FILTER_REGEX_INCLUDE | String | optional,
  JAVASCRIPT_STANDARD_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JAVASCRIPT_STANDARD_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JAVASCRIPT_STANDARD_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling JAVASCRIPT_STANDARD and its pre/post commands
    "%
    | optional,
  JAVA_CHECKSTYLE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JAVA_CHECKSTYLE: User custom arguments to add in linter CLI call
    "%
    | optional,
  JAVA_CHECKSTYLE_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVA_CHECKSTYLE_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  JAVA_CHECKSTYLE_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JAVA_CHECKSTYLE: User custom arguments to remove before calling linter
    "%
    | optional,
  JAVA_CHECKSTYLE_CONFIG_FILE
    | String
    | doc m%"
    JAVA_CHECKSTYLE: User custom config file name if different from default
    "%
    | optional,
  JAVA_CHECKSTYLE_DISABLE_ERRORS | Bool | optional,
  JAVA_CHECKSTYLE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  JAVA_CHECKSTYLE_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVA_CHECKSTYLE_FILE_NAME
    | String
    | doc m%"
    JAVA_CHECKSTYLE: User custom config file name if different from default
    "%
    | optional,
  JAVA_CHECKSTYLE_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVA_CHECKSTYLE_FILTER_REGEX_EXCLUDE | String | optional,
  JAVA_CHECKSTYLE_FILTER_REGEX_INCLUDE | String | optional,
  JAVA_CHECKSTYLE_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JAVA_CHECKSTYLE_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JAVA_CHECKSTYLE_RULES_PATH
    | String
    | doc m%"
    JAVA_CHECKSTYLE: Path where to find linter configuration file
    "%
    | optional,
  JAVA_CHECKSTYLE_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling JAVA_CHECKSTYLE and its pre/post commands
    "%
    | optional,
  JAVA_FILTER_REGEX_EXCLUDE | String | optional,
  JAVA_FILTER_REGEX_INCLUDE | String | optional,
  JAVA_PMD_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JAVA_PMD: User custom arguments to add in linter CLI call
    "%
    | optional,
  JAVA_PMD_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVA_PMD_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  JAVA_PMD_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JAVA_PMD: User custom arguments to remove before calling linter
    "%
    | optional,
  JAVA_PMD_CONFIG_FILE
    | String
    | doc m%"
    JAVA_PMD: User custom config file name if different from default
    "%
    | optional,
  JAVA_PMD_DISABLE_ERRORS | Bool | optional,
  JAVA_PMD_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  JAVA_PMD_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVA_PMD_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JAVA_PMD_FILTER_REGEX_EXCLUDE | String | optional,
  JAVA_PMD_FILTER_REGEX_INCLUDE | String | optional,
  JAVA_PMD_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JAVA_PMD_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JAVA_PMD_RULES_PATH
    | String
    | doc m%"
    JAVA_PMD: Path where to find linter configuration file
    "%
    | optional,
  JAVA_PMD_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling JAVA_PMD and its pre/post commands
    "%
    | optional,
  JSON_ESLINT_PLUGIN_JSONC_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JSON_ESLINT_PLUGIN_JSONC: User custom arguments to add in linter CLI call
    "%
    | optional,
  JSON_ESLINT_PLUGIN_JSONC_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_ESLINT_PLUGIN_JSONC_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  JSON_ESLINT_PLUGIN_JSONC_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JSON_ESLINT_PLUGIN_JSONC: User custom arguments to remove before calling linter
    "%
    | optional,
  JSON_ESLINT_PLUGIN_JSONC_CONFIG_FILE
    | String
    | doc m%"
    JSON_ESLINT_PLUGIN_JSONC: User custom config file name if different from default
    "%
    | optional,
  JSON_ESLINT_PLUGIN_JSONC_DISABLE_ERRORS | Bool | optional,
  JSON_ESLINT_PLUGIN_JSONC_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  JSON_ESLINT_PLUGIN_JSONC_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_ESLINT_PLUGIN_JSONC_FILE_NAME
    | String
    | doc m%"
    JSON_ESLINT_PLUGIN_JSONC: User custom config file name if different from default
    "%
    | optional,
  JSON_ESLINT_PLUGIN_JSONC_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_ESLINT_PLUGIN_JSONC_FILTER_REGEX_EXCLUDE | String | optional,
  JSON_ESLINT_PLUGIN_JSONC_FILTER_REGEX_INCLUDE | String | optional,
  JSON_ESLINT_PLUGIN_JSONC_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JSON_ESLINT_PLUGIN_JSONC_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JSON_ESLINT_PLUGIN_JSONC_RULES_PATH
    | String
    | doc m%"
    JSON_ESLINT_PLUGIN_JSONC: Path where to find linter configuration file
    "%
    | optional,
  JSON_ESLINT_PLUGIN_JSONC_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling JSON_ESLINT_PLUGIN_JSONC and its pre/post commands
    "%
    | optional,
  JSON_FILTER_REGEX_EXCLUDE | String | optional,
  JSON_FILTER_REGEX_INCLUDE | String | optional,
  JSON_JSONLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JSON_JSONLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  JSON_JSONLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_JSONLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  JSON_JSONLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JSON_JSONLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  JSON_JSONLINT_CONFIG_FILE
    | String
    | doc m%"
    JSON_JSONLINT: User custom config file name if different from default
    "%
    | optional,
  JSON_JSONLINT_DISABLE_ERRORS | Bool | optional,
  JSON_JSONLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  JSON_JSONLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_JSONLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_JSONLINT_FILTER_REGEX_EXCLUDE | String | optional,
  JSON_JSONLINT_FILTER_REGEX_INCLUDE | String | optional,
  JSON_JSONLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JSON_JSONLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JSON_JSONLINT_RULES_PATH
    | String
    | doc m%"
    JSON_JSONLINT: Path where to find linter configuration file
    "%
    | optional,
  JSON_JSONLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling JSON_JSONLINT and its pre/post commands
    "%
    | optional,
  JSON_NPM_PACKAGE_JSON_LINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JSON_NPM_PACKAGE_JSON_LINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  JSON_NPM_PACKAGE_JSON_LINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_NPM_PACKAGE_JSON_LINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JSON_NPM_PACKAGE_JSON_LINT: User custom arguments to remove before calling linter
    "%
    | optional,
  JSON_NPM_PACKAGE_JSON_LINT_CONFIG_FILE
    | String
    | doc m%"
    JSON_NPM_PACKAGE_JSON_LINT: User custom config file name if different from default
    "%
    | optional,
  JSON_NPM_PACKAGE_JSON_LINT_DISABLE_ERRORS | Bool | optional,
  JSON_NPM_PACKAGE_JSON_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  JSON_NPM_PACKAGE_JSON_LINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_NPM_PACKAGE_JSON_LINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_NPM_PACKAGE_JSON_LINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JSON_NPM_PACKAGE_JSON_LINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JSON_NPM_PACKAGE_JSON_LINT_RULES_PATH
    | String
    | doc m%"
    JSON_NPM_PACKAGE_JSON_LINT: Path where to find linter configuration file
    "%
    | optional,
  JSON_NPM_PACKAGE_JSON_LINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling JSON_NPM_PACKAGE_JSON_LINT and its pre/post commands
    "%
    | optional,
  JSON_PRETTIER_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JSON_PRETTIER: User custom arguments to add in linter CLI call
    "%
    | optional,
  JSON_PRETTIER_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_PRETTIER_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  JSON_PRETTIER_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JSON_PRETTIER: User custom arguments to remove before calling linter
    "%
    | optional,
  JSON_PRETTIER_CONFIG_FILE
    | String
    | doc m%"
    JSON_PRETTIER: User custom config file name if different from default
    "%
    | optional,
  JSON_PRETTIER_DISABLE_ERRORS | Bool | optional,
  JSON_PRETTIER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  JSON_PRETTIER_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_PRETTIER_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_PRETTIER_FILTER_REGEX_EXCLUDE | String | optional,
  JSON_PRETTIER_FILTER_REGEX_INCLUDE | String | optional,
  JSON_PRETTIER_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JSON_PRETTIER_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JSON_PRETTIER_RULES_PATH
    | String
    | doc m%"
    JSON_PRETTIER: Path where to find linter configuration file
    "%
    | optional,
  JSON_PRETTIER_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling JSON_PRETTIER and its pre/post commands
    "%
    | optional,
  JSON_REPORTER
    | Bool
    | doc m%"
    Output a large execution log in a JSON file named mega-linter-report.json
    "%
    | optional,
  JSON_REPORTER_OUTPUT_DETAIL
    | std.enum.TagOrString
    | [| 'detailed, 'simple |]
    | doc m%"
    Defines if output contain only error files (simple) or all files (detailed)
    "%
    | optional,
  JSON_V8R_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JSON_V8R: User custom arguments to add in linter CLI call
    "%
    | optional,
  JSON_V8R_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_V8R_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  JSON_V8R_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JSON_V8R: User custom arguments to remove before calling linter
    "%
    | optional,
  JSON_V8R_DISABLE_ERRORS | Bool | optional,
  JSON_V8R_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  JSON_V8R_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_V8R_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSON_V8R_FILTER_REGEX_EXCLUDE | String | optional,
  JSON_V8R_FILTER_REGEX_INCLUDE | String | optional,
  JSON_V8R_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JSON_V8R_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JSON_V8R_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling JSON_V8R and its pre/post commands
    "%
    | optional,
  JSX_ESLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JSX_ESLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  JSX_ESLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSX_ESLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  JSX_ESLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    JSX_ESLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  JSX_ESLINT_CONFIG_FILE
    | String
    | doc m%"
    JSX_ESLINT: User custom config file name if different from default
    "%
    | optional,
  JSX_ESLINT_DISABLE_ERRORS | Bool | optional,
  JSX_ESLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  JSX_ESLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSX_ESLINT_FILE_NAME
    | String
    | doc m%"
    JSX_ESLINT: User custom config file name if different from default
    "%
    | optional,
  JSX_ESLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  JSX_ESLINT_FILTER_REGEX_EXCLUDE | String | optional,
  JSX_ESLINT_FILTER_REGEX_INCLUDE | String | optional,
  JSX_ESLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JSX_ESLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  JSX_ESLINT_RULES_PATH
    | String
    | doc m%"
    JSX_ESLINT: Path where to find linter configuration file
    "%
    | optional,
  JSX_ESLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling JSX_ESLINT and its pre/post commands
    "%
    | optional,
  JSX_FILTER_REGEX_EXCLUDE | String | optional,
  JSX_FILTER_REGEX_INCLUDE | String | optional,
  KOTLIN_FILTER_REGEX_EXCLUDE | String | optional,
  KOTLIN_FILTER_REGEX_INCLUDE | String | optional,
  KOTLIN_KTLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    KOTLIN_KTLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  KOTLIN_KTLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KOTLIN_KTLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  KOTLIN_KTLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    KOTLIN_KTLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  KOTLIN_KTLINT_DISABLE_ERRORS | Bool | optional,
  KOTLIN_KTLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  KOTLIN_KTLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KOTLIN_KTLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KOTLIN_KTLINT_FILTER_REGEX_EXCLUDE | String | optional,
  KOTLIN_KTLINT_FILTER_REGEX_INCLUDE | String | optional,
  KOTLIN_KTLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  KOTLIN_KTLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  KOTLIN_KTLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling KOTLIN_KTLINT and its pre/post commands
    "%
    | optional,
  KUBERNETES_DIRECTORY | String | optional,
  KUBERNETES_FILTER_REGEX_EXCLUDE | String | optional,
  KUBERNETES_FILTER_REGEX_INCLUDE | String | optional,
  KUBERNETES_HELM_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    KUBERNETES_HELM: User custom arguments to add in linter CLI call
    "%
    | optional,
  KUBERNETES_HELM_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KUBERNETES_HELM_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    KUBERNETES_HELM: User custom arguments to remove before calling linter
    "%
    | optional,
  KUBERNETES_HELM_DIRECTORY | String | optional,
  KUBERNETES_HELM_DISABLE_ERRORS | Bool | optional,
  KUBERNETES_HELM_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  KUBERNETES_HELM_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KUBERNETES_HELM_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KUBERNETES_HELM_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  KUBERNETES_HELM_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  KUBERNETES_HELM_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling KUBERNETES_HELM and its pre/post commands
    "%
    | optional,
  KUBERNETES_KUBECONFORM_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    KUBERNETES_KUBECONFORM: User custom arguments to add in linter CLI call
    "%
    | optional,
  KUBERNETES_KUBECONFORM_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KUBERNETES_KUBECONFORM_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  KUBERNETES_KUBECONFORM_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    KUBERNETES_KUBECONFORM: User custom arguments to remove before calling linter
    "%
    | optional,
  KUBERNETES_KUBECONFORM_DIRECTORY | String | optional,
  KUBERNETES_KUBECONFORM_DISABLE_ERRORS | Bool | optional,
  KUBERNETES_KUBECONFORM_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  KUBERNETES_KUBECONFORM_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KUBERNETES_KUBECONFORM_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KUBERNETES_KUBECONFORM_FILTER_REGEX_EXCLUDE | String | optional,
  KUBERNETES_KUBECONFORM_FILTER_REGEX_INCLUDE | String | optional,
  KUBERNETES_KUBECONFORM_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  KUBERNETES_KUBECONFORM_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  KUBERNETES_KUBECONFORM_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling KUBERNETES_KUBECONFORM and its pre/post commands
    "%
    | optional,
  KUBERNETES_KUBESCAPE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    KUBERNETES_KUBESCAPE: User custom arguments to add in linter CLI call
    "%
    | optional,
  KUBERNETES_KUBESCAPE_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KUBERNETES_KUBESCAPE_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    KUBERNETES_KUBESCAPE: User custom arguments to remove before calling linter
    "%
    | optional,
  KUBERNETES_KUBESCAPE_DIRECTORY | String | optional,
  KUBERNETES_KUBESCAPE_DISABLE_ERRORS | Bool | optional,
  KUBERNETES_KUBESCAPE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  KUBERNETES_KUBESCAPE_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KUBERNETES_KUBESCAPE_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KUBERNETES_KUBESCAPE_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  KUBERNETES_KUBESCAPE_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  KUBERNETES_KUBESCAPE_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling KUBERNETES_KUBESCAPE and its pre/post commands
    "%
    | optional,
  KUBERNETES_KUBEVAL_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    KUBERNETES_KUBEVAL: User custom arguments to add in linter CLI call
    "%
    | optional,
  KUBERNETES_KUBEVAL_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KUBERNETES_KUBEVAL_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  KUBERNETES_KUBEVAL_DIRECTORY | String | optional,
  KUBERNETES_KUBEVAL_DISABLE_ERRORS | Bool | optional,
  KUBERNETES_KUBEVAL_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  KUBERNETES_KUBEVAL_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KUBERNETES_KUBEVAL_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  KUBERNETES_KUBEVAL_FILTER_REGEX_EXCLUDE | String | optional,
  KUBERNETES_KUBEVAL_FILTER_REGEX_INCLUDE | String | optional,
  KUBERNETES_KUBEVAL_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  KUBERNETES_KUBEVAL_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  LATEX_CHKTEX_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    LATEX_CHKTEX: User custom arguments to add in linter CLI call
    "%
    | optional,
  LATEX_CHKTEX_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  LATEX_CHKTEX_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  LATEX_CHKTEX_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    LATEX_CHKTEX: User custom arguments to remove before calling linter
    "%
    | optional,
  LATEX_CHKTEX_CONFIG_FILE
    | String
    | doc m%"
    LATEX_CHKTEX: User custom config file name if different from default
    "%
    | optional,
  LATEX_CHKTEX_DISABLE_ERRORS | Bool | optional,
  LATEX_CHKTEX_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  LATEX_CHKTEX_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  LATEX_CHKTEX_FILE_NAME
    | String
    | doc m%"
    LATEX_CHKTEX: User custom config file name if different from default
    "%
    | optional,
  LATEX_CHKTEX_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  LATEX_CHKTEX_FILTER_REGEX_EXCLUDE | String | optional,
  LATEX_CHKTEX_FILTER_REGEX_INCLUDE | String | optional,
  LATEX_CHKTEX_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  LATEX_CHKTEX_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  LATEX_CHKTEX_RULES_PATH
    | String
    | doc m%"
    LATEX_CHKTEX: Path where to find linter configuration file
    "%
    | optional,
  LATEX_CHKTEX_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling LATEX_CHKTEX and its pre/post commands
    "%
    | optional,
  LATEX_FILTER_REGEX_EXCLUDE | String | optional,
  LATEX_FILTER_REGEX_INCLUDE | String | optional,
  LINTER_RULES_PATH
    | String
    | doc m%"
    Directory for all linter configuration rules. Can be a local folder or a remote URL. Not necessary if your linters configuration files are at the root of your repository
    "%
    | optional,
  LOG_FILE
    | String
    | doc m%"
    The file name for outputting logs. All output is sent to the log file regardless of LOG_LEVEL
    "%
    | optional,
  LOG_LEVEL
    | std.enum.TagOrString
    | [| 'ERROR, 'WARNING, 'DEBUG, 'INFO |]
    | doc m%"
    How much output the script will generate to the console. One of INFO, DEBUG, WARNING or ERROR.
    "%
    | optional,
  LUA_FILTER_REGEX_EXCLUDE | String | optional,
  LUA_FILTER_REGEX_INCLUDE | String | optional,
  LUA_LUACHECK_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    LUA_LUACHECK: User custom arguments to add in linter CLI call
    "%
    | optional,
  LUA_LUACHECK_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  LUA_LUACHECK_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  LUA_LUACHECK_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    LUA_LUACHECK: User custom arguments to remove before calling linter
    "%
    | optional,
  LUA_LUACHECK_CONFIG_FILE
    | String
    | doc m%"
    LUA_LUACHECK: User custom config file name if different from default
    "%
    | optional,
  LUA_LUACHECK_DISABLE_ERRORS | Bool | optional,
  LUA_LUACHECK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  LUA_LUACHECK_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  LUA_LUACHECK_FILE_NAME
    | String
    | doc m%"
    LUA_LUACHECK: User custom config file name if different from default
    "%
    | optional,
  LUA_LUACHECK_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  LUA_LUACHECK_FILTER_REGEX_EXCLUDE | String | optional,
  LUA_LUACHECK_FILTER_REGEX_INCLUDE | String | optional,
  LUA_LUACHECK_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  LUA_LUACHECK_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  LUA_LUACHECK_RULES_PATH
    | String
    | doc m%"
    LUA_LUACHECK: Path where to find linter configuration file
    "%
    | optional,
  LUA_LUACHECK_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling LUA_LUACHECK and its pre/post commands
    "%
    | optional,
  MAKEFILE_CHECKMAKE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    MAKEFILE_CHECKMAKE: User custom arguments to add in linter CLI call
    "%
    | optional,
  MAKEFILE_CHECKMAKE_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MAKEFILE_CHECKMAKE_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  MAKEFILE_CHECKMAKE_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    MAKEFILE_CHECKMAKE: User custom arguments to remove before calling linter
    "%
    | optional,
  MAKEFILE_CHECKMAKE_CONFIG_FILE
    | String
    | doc m%"
    MAKEFILE_CHECKMAKE: User custom config file name if different from default
    "%
    | optional,
  MAKEFILE_CHECKMAKE_DISABLE_ERRORS | Bool | optional,
  MAKEFILE_CHECKMAKE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  MAKEFILE_CHECKMAKE_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MAKEFILE_CHECKMAKE_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MAKEFILE_CHECKMAKE_FILTER_REGEX_EXCLUDE | String | optional,
  MAKEFILE_CHECKMAKE_FILTER_REGEX_INCLUDE | String | optional,
  MAKEFILE_CHECKMAKE_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  MAKEFILE_CHECKMAKE_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  MAKEFILE_CHECKMAKE_RULES_PATH
    | String
    | doc m%"
    MAKEFILE_CHECKMAKE: Path where to find linter configuration file
    "%
    | optional,
  MAKEFILE_CHECKMAKE_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling MAKEFILE_CHECKMAKE and its pre/post commands
    "%
    | optional,
  MAKEFILE_FILTER_REGEX_EXCLUDE | String | optional,
  MAKEFILE_FILTER_REGEX_INCLUDE | String | optional,
  MARKDOWN_DEFAULT_STYLE
    | std.enum.TagOrString
    | [| 'remark-lint, 'markdownlint |]
    | doc m%"
    Style of markdown formatting to apply
    "%
    | optional,
  MARKDOWN_FILTER_REGEX_EXCLUDE | String | optional,
  MARKDOWN_FILTER_REGEX_INCLUDE | String | optional,
  MARKDOWN_MARKDOWNLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    MARKDOWN_MARKDOWNLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  MARKDOWN_MARKDOWNLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MARKDOWN_MARKDOWNLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  MARKDOWN_MARKDOWNLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    MARKDOWN_MARKDOWNLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  MARKDOWN_MARKDOWNLINT_CONFIG_FILE
    | String
    | doc m%"
    MARKDOWN_MARKDOWNLINT: User custom config file name if different from default
    "%
    | optional,
  MARKDOWN_MARKDOWNLINT_DISABLE_ERRORS | Bool | optional,
  MARKDOWN_MARKDOWNLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  MARKDOWN_MARKDOWNLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MARKDOWN_MARKDOWNLINT_FILE_NAME
    | String
    | doc m%"
    MARKDOWN_MARKDOWNLINT: User custom config file name if different from default
    "%
    | optional,
  MARKDOWN_MARKDOWNLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MARKDOWN_MARKDOWNLINT_FILTER_REGEX_EXCLUDE | String | optional,
  MARKDOWN_MARKDOWNLINT_FILTER_REGEX_INCLUDE | String | optional,
  MARKDOWN_MARKDOWNLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  MARKDOWN_MARKDOWNLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  MARKDOWN_MARKDOWNLINT_RULES_PATH
    | String
    | doc m%"
    MARKDOWN_MARKDOWNLINT: Path where to find linter configuration file
    "%
    | optional,
  MARKDOWN_MARKDOWNLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling MARKDOWN_MARKDOWNLINT and its pre/post commands
    "%
    | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    MARKDOWN_MARKDOWN_LINK_CHECK: User custom arguments to add in linter CLI call
    "%
    | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    MARKDOWN_MARKDOWN_LINK_CHECK: User custom arguments to remove before calling linter
    "%
    | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_CONFIG_FILE
    | String
    | doc m%"
    MARKDOWN_MARKDOWN_LINK_CHECK: User custom config file name if different from default
    "%
    | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_DISABLE_ERRORS | Bool | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_FILE_NAME
    | String
    | doc m%"
    MARKDOWN_MARKDOWN_LINK_CHECK: User custom config file name if different from default
    "%
    | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_FILTER_REGEX_EXCLUDE | String | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_FILTER_REGEX_INCLUDE | String | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_RULES_PATH
    | String
    | doc m%"
    MARKDOWN_MARKDOWN_LINK_CHECK: Path where to find linter configuration file
    "%
    | optional,
  MARKDOWN_MARKDOWN_LINK_CHECK_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling MARKDOWN_MARKDOWN_LINK_CHECK and its pre/post commands
    "%
    | optional,
  MARKDOWN_MARKDOWN_TABLE_FORMATTER_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    MARKDOWN_MARKDOWN_TABLE_FORMATTER: User custom arguments to add in linter CLI call
    "%
    | optional,
  MARKDOWN_MARKDOWN_TABLE_FORMATTER_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MARKDOWN_MARKDOWN_TABLE_FORMATTER_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  MARKDOWN_MARKDOWN_TABLE_FORMATTER_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    MARKDOWN_MARKDOWN_TABLE_FORMATTER: User custom arguments to remove before calling linter
    "%
    | optional,
  MARKDOWN_MARKDOWN_TABLE_FORMATTER_DISABLE_ERRORS | Bool | optional,
  MARKDOWN_MARKDOWN_TABLE_FORMATTER_DISABLE_ERRORS_IF_LESS_THAN
    | Number
    | optional,
  MARKDOWN_MARKDOWN_TABLE_FORMATTER_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MARKDOWN_MARKDOWN_TABLE_FORMATTER_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MARKDOWN_MARKDOWN_TABLE_FORMATTER_FILTER_REGEX_EXCLUDE | String | optional,
  MARKDOWN_MARKDOWN_TABLE_FORMATTER_FILTER_REGEX_INCLUDE | String | optional,
  MARKDOWN_MARKDOWN_TABLE_FORMATTER_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  MARKDOWN_MARKDOWN_TABLE_FORMATTER_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  MARKDOWN_MARKDOWN_TABLE_FORMATTER_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling MARKDOWN_MARKDOWN_TABLE_FORMATTER and its pre/post commands
    "%
    | optional,
  MARKDOWN_MARKDOWN_TABLE_PRETTIFY_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    MARKDOWN_MARKDOWN_TABLE_PRETTIFY: User custom arguments to add in linter CLI call
    "%
    | optional,
  MARKDOWN_MARKDOWN_TABLE_PRETTIFY_DISABLE_ERRORS | Bool | optional,
  MARKDOWN_MARKDOWN_TABLE_PRETTIFY_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MARKDOWN_MARKDOWN_TABLE_PRETTIFY_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MARKDOWN_MARKDOWN_TABLE_PRETTIFY_FILTER_REGEX_EXCLUDE | String | optional,
  MARKDOWN_MARKDOWN_TABLE_PRETTIFY_FILTER_REGEX_INCLUDE | String | optional,
  MARKDOWN_REMARK_LINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    MARKDOWN_REMARK_LINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  MARKDOWN_REMARK_LINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MARKDOWN_REMARK_LINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  MARKDOWN_REMARK_LINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    MARKDOWN_REMARK_LINT: User custom arguments to remove before calling linter
    "%
    | optional,
  MARKDOWN_REMARK_LINT_CONFIG_FILE
    | String
    | doc m%"
    MARKDOWN_REMARK_LINT: User custom config file name if different from default
    "%
    | optional,
  MARKDOWN_REMARK_LINT_DISABLE_ERRORS | Bool | optional,
  MARKDOWN_REMARK_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  MARKDOWN_REMARK_LINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MARKDOWN_REMARK_LINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  MARKDOWN_REMARK_LINT_FILTER_REGEX_EXCLUDE | String | optional,
  MARKDOWN_REMARK_LINT_FILTER_REGEX_INCLUDE | String | optional,
  MARKDOWN_REMARK_LINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  MARKDOWN_REMARK_LINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  MARKDOWN_REMARK_LINT_RULES_PATH
    | String
    | doc m%"
    MARKDOWN_REMARK_LINT: Path where to find linter configuration file
    "%
    | optional,
  MARKDOWN_REMARK_LINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling MARKDOWN_REMARK_LINT and its pre/post commands
    "%
    | optional,
  MEGALINTER_FILES_TO_LINT
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Comma-separated list of files to analyze. Using this variable will bypass other file listing methods
    "%
    | optional,
  MULTI_STATUS
    | Bool
    | doc m%"
    (DEPRECATED, use GITHUB_STATUS_REPORTER) Posts a status on the pull request for each processed linter
    "%
    | optional,
  OPENAPI_FILTER_REGEX_EXCLUDE | String | optional,
  OPENAPI_FILTER_REGEX_INCLUDE | String | optional,
  OPENAPI_SPECTRAL_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    OPENAPI_SPECTRAL: User custom arguments to add in linter CLI call
    "%
    | optional,
  OPENAPI_SPECTRAL_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  OPENAPI_SPECTRAL_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  OPENAPI_SPECTRAL_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    OPENAPI_SPECTRAL: User custom arguments to remove before calling linter
    "%
    | optional,
  OPENAPI_SPECTRAL_CONFIG_FILE
    | String
    | doc m%"
    OPENAPI_SPECTRAL: User custom config file name if different from default
    "%
    | optional,
  OPENAPI_SPECTRAL_DISABLE_ERRORS | Bool | optional,
  OPENAPI_SPECTRAL_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  OPENAPI_SPECTRAL_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  OPENAPI_SPECTRAL_FILE_NAME
    | String
    | doc m%"
    OPENAPI_SPECTRAL: User custom config file name if different from default
    "%
    | optional,
  OPENAPI_SPECTRAL_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  OPENAPI_SPECTRAL_FILTER_REGEX_EXCLUDE | String | optional,
  OPENAPI_SPECTRAL_FILTER_REGEX_INCLUDE | String | optional,
  OPENAPI_SPECTRAL_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  OPENAPI_SPECTRAL_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  OPENAPI_SPECTRAL_RULES_PATH
    | String
    | doc m%"
    OPENAPI_SPECTRAL: Path where to find linter configuration file
    "%
    | optional,
  OPENAPI_SPECTRAL_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling OPENAPI_SPECTRAL and its pre/post commands
    "%
    | optional,
  OUTPUT_DETAIL
    | std.enum.TagOrString
    | [| 'detailed, 'simple |]
    | doc m%"
    (DEPRECATED) Output detail for text reporter: only error files (simple) or all files (detailed)
    "%
    | optional,
  OUTPUT_FORMAT
    | std.enum.TagOrString
    | [| 'tap, 'text |]
    | doc m%"
    (DEPRECATED) Output format: text or tap
    "%
    | optional,
  PARALLEL
    | Bool
    | doc m%"
    Process linters in parallel to improve overall MegaLinter performance. If true, linters of same language or formats are grouped in the same parallel process to avoid lock issues if fixing the same files
    "%
    | optional,
  PERL_FILTER_REGEX_EXCLUDE | String | optional,
  PERL_FILTER_REGEX_INCLUDE | String | optional,
  PERL_PERLCRITIC_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PERL_PERLCRITIC: User custom arguments to add in linter CLI call
    "%
    | optional,
  PERL_PERLCRITIC_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PERL_PERLCRITIC_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  PERL_PERLCRITIC_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PERL_PERLCRITIC: User custom arguments to remove before calling linter
    "%
    | optional,
  PERL_PERLCRITIC_DISABLE_ERRORS | Bool | optional,
  PERL_PERLCRITIC_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PERL_PERLCRITIC_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PERL_PERLCRITIC_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PERL_PERLCRITIC_FILTER_REGEX_EXCLUDE | String | optional,
  PERL_PERLCRITIC_FILTER_REGEX_INCLUDE | String | optional,
  PERL_PERLCRITIC_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PERL_PERLCRITIC_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PERL_PERLCRITIC_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PERL_PERLCRITIC and its pre/post commands
    "%
    | optional,
  PHP_BUILTIN_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PHP_BUILTIN: User custom arguments to add in linter CLI call
    "%
    | optional,
  PHP_BUILTIN_CLI_EXECUTABLE | String | optional,
  PHP_BUILTIN_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  PHP_BUILTIN_DISABLE_ERRORS | Bool | optional,
  PHP_BUILTIN_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PHP_BUILTIN_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PHP_BUILTIN_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PHP_BUILTIN_FILTER_REGEX_EXCLUDE | String | optional,
  PHP_BUILTIN_FILTER_REGEX_INCLUDE | String | optional,
  PHP_BUILTIN_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PHP_BUILTIN_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PHP_FILTER_REGEX_EXCLUDE | String | optional,
  PHP_FILTER_REGEX_INCLUDE | String | optional,
  PHP_PHPCS_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PHP_PHPCS: User custom arguments to add in linter CLI call
    "%
    | optional,
  PHP_PHPCS_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PHP_PHPCS_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  PHP_PHPCS_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PHP_PHPCS: User custom arguments to remove before calling linter
    "%
    | optional,
  PHP_PHPCS_CONFIG_FILE
    | String
    | doc m%"
    PHP_PHPCS: User custom config file name if different from default
    "%
    | optional,
  PHP_PHPCS_DISABLE_ERRORS | Bool | optional,
  PHP_PHPCS_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PHP_PHPCS_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PHP_PHPCS_FILE_NAME
    | String
    | doc m%"
    PHP_PHPCS: User custom config file name if different from default
    "%
    | optional,
  PHP_PHPCS_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PHP_PHPCS_FILTER_REGEX_EXCLUDE | String | optional,
  PHP_PHPCS_FILTER_REGEX_INCLUDE | String | optional,
  PHP_PHPCS_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PHP_PHPCS_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PHP_PHPCS_RULES_PATH
    | String
    | doc m%"
    PHP_PHPCS: Path where to find linter configuration file
    "%
    | optional,
  PHP_PHPCS_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PHP_PHPCS and its pre/post commands
    "%
    | optional,
  PHP_PHPLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PHP_PHPLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  PHP_PHPLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PHP_PHPLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  PHP_PHPLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PHP_PHPLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  PHP_PHPLINT_CONFIG_FILE
    | String
    | doc m%"
    PHP_PHPLINT: User custom config file name if different from default
    "%
    | optional,
  PHP_PHPLINT_DISABLE_ERRORS | Bool | optional,
  PHP_PHPLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PHP_PHPLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PHP_PHPLINT_FILE_NAME
    | String
    | doc m%"
    PHP_PHPLINT: User custom config file name if different from default
    "%
    | optional,
  PHP_PHPLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PHP_PHPLINT_FILTER_REGEX_EXCLUDE | String | optional,
  PHP_PHPLINT_FILTER_REGEX_INCLUDE | String | optional,
  PHP_PHPLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PHP_PHPLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PHP_PHPLINT_RULES_PATH
    | String
    | doc m%"
    PHP_PHPLINT: Path where to find linter configuration file
    "%
    | optional,
  PHP_PHPLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PHP_PHPLINT and its pre/post commands
    "%
    | optional,
  PHP_PHPSTAN_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PHP_PHPSTAN: User custom arguments to add in linter CLI call
    "%
    | optional,
  PHP_PHPSTAN_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PHP_PHPSTAN_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  PHP_PHPSTAN_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PHP_PHPSTAN: User custom arguments to remove before calling linter
    "%
    | optional,
  PHP_PHPSTAN_CONFIG_FILE
    | String
    | doc m%"
    PHP_PHPSTAN: User custom config file name if different from default
    "%
    | optional,
  PHP_PHPSTAN_DISABLE_ERRORS | Bool | optional,
  PHP_PHPSTAN_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PHP_PHPSTAN_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PHP_PHPSTAN_FILE_NAME
    | String
    | doc m%"
    PHP_PHPSTAN: User custom config file name if different from default
    "%
    | optional,
  PHP_PHPSTAN_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PHP_PHPSTAN_FILTER_REGEX_EXCLUDE | String | optional,
  PHP_PHPSTAN_FILTER_REGEX_INCLUDE | String | optional,
  PHP_PHPSTAN_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PHP_PHPSTAN_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PHP_PHPSTAN_RULES_PATH
    | String
    | doc m%"
    PHP_PHPSTAN: Path where to find linter configuration file
    "%
    | optional,
  PHP_PHPSTAN_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PHP_PHPSTAN and its pre/post commands
    "%
    | optional,
  PHP_PSALM_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PHP_PSALM: User custom arguments to add in linter CLI call
    "%
    | optional,
  PHP_PSALM_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PHP_PSALM_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  PHP_PSALM_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PHP_PSALM: User custom arguments to remove before calling linter
    "%
    | optional,
  PHP_PSALM_CONFIG_FILE
    | String
    | doc m%"
    PHP_PSALM: User custom config file name if different from default
    "%
    | optional,
  PHP_PSALM_DISABLE_ERRORS | Bool | optional,
  PHP_PSALM_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PHP_PSALM_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PHP_PSALM_FILE_NAME
    | String
    | doc m%"
    PHP_PSALM: User custom config file name if different from default
    "%
    | optional,
  PHP_PSALM_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PHP_PSALM_FILTER_REGEX_EXCLUDE | String | optional,
  PHP_PSALM_FILTER_REGEX_INCLUDE | String | optional,
  PHP_PSALM_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PHP_PSALM_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PHP_PSALM_RULES_PATH
    | String
    | doc m%"
    PHP_PSALM: Path where to find linter configuration file
    "%
    | optional,
  PHP_PSALM_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PHP_PSALM and its pre/post commands
    "%
    | optional,
  PLUGINS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of MegaLinter plugins. URL must follow format https://**/mega-linter-plugin-**/**.mega-linter-descriptor.yml
    "%
    | optional,
  POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | doc m%"
    Custom bash commands to run after linters
    "%
    | optional,
  POST_GITHUB_COMMENT
    | Bool
    | doc m%"
    (DEPRECATED, use GITHUB_COMMENT_REPORTER) Posts MegaLinter results summary in the comments of the related pull request (if existing)
    "%
    | optional,
  POST_GITLAB_COMMENT
    | Bool
    | doc m%"
    (DEPRECATED, use GITHUB_COMMENT_REPORTER) Posts MegaLinter results summary in the comments of the related merge request (if existing)
    "%
    | optional,
  POWERSHELL_FILTER_REGEX_EXCLUDE | String | optional,
  POWERSHELL_FILTER_REGEX_INCLUDE | String | optional,
  POWERSHELL_POWERSHELL_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    POWERSHELL_POWERSHELL: User custom arguments to add in linter CLI call
    "%
    | optional,
  POWERSHELL_POWERSHELL_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  POWERSHELL_POWERSHELL_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  POWERSHELL_POWERSHELL_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    POWERSHELL_POWERSHELL: User custom arguments to remove before calling linter
    "%
    | optional,
  POWERSHELL_POWERSHELL_CONFIG_FILE
    | String
    | doc m%"
    POWERSHELL_POWERSHELL: User custom config file name if different from default
    "%
    | optional,
  POWERSHELL_POWERSHELL_DISABLE_ERRORS | Bool | optional,
  POWERSHELL_POWERSHELL_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  POWERSHELL_POWERSHELL_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  POWERSHELL_POWERSHELL_FILE_NAME
    | String
    | doc m%"
    POWERSHELL_POWERSHELL: User custom config file name if different from default
    "%
    | optional,
  POWERSHELL_POWERSHELL_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  POWERSHELL_POWERSHELL_FILTER_REGEX_EXCLUDE | String | optional,
  POWERSHELL_POWERSHELL_FILTER_REGEX_INCLUDE | String | optional,
  POWERSHELL_POWERSHELL_FORMATTER_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    POWERSHELL_POWERSHELL_FORMATTER: User custom arguments to add in linter CLI call
    "%
    | optional,
  POWERSHELL_POWERSHELL_FORMATTER_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  POWERSHELL_POWERSHELL_FORMATTER_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  POWERSHELL_POWERSHELL_FORMATTER_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    POWERSHELL_POWERSHELL_FORMATTER: User custom arguments to remove before calling linter
    "%
    | optional,
  POWERSHELL_POWERSHELL_FORMATTER_CONFIG_FILE
    | String
    | doc m%"
    POWERSHELL_POWERSHELL_FORMATTER: User custom config file name if different from default
    "%
    | optional,
  POWERSHELL_POWERSHELL_FORMATTER_DISABLE_ERRORS | Bool | optional,
  POWERSHELL_POWERSHELL_FORMATTER_DISABLE_ERRORS_IF_LESS_THAN
    | Number
    | optional,
  POWERSHELL_POWERSHELL_FORMATTER_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  POWERSHELL_POWERSHELL_FORMATTER_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  POWERSHELL_POWERSHELL_FORMATTER_FILTER_REGEX_EXCLUDE | String | optional,
  POWERSHELL_POWERSHELL_FORMATTER_FILTER_REGEX_INCLUDE | String | optional,
  POWERSHELL_POWERSHELL_FORMATTER_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  POWERSHELL_POWERSHELL_FORMATTER_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  POWERSHELL_POWERSHELL_FORMATTER_RULES_PATH
    | String
    | doc m%"
    POWERSHELL_POWERSHELL_FORMATTER: Path where to find linter configuration file
    "%
    | optional,
  POWERSHELL_POWERSHELL_FORMATTER_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling POWERSHELL_POWERSHELL_FORMATTER and its pre/post commands
    "%
    | optional,
  POWERSHELL_POWERSHELL_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  POWERSHELL_POWERSHELL_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  POWERSHELL_POWERSHELL_RULES_PATH
    | String
    | doc m%"
    POWERSHELL_POWERSHELL: Path where to find linter configuration file
    "%
    | optional,
  POWERSHELL_POWERSHELL_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling POWERSHELL_POWERSHELL and its pre/post commands
    "%
    | optional,
  PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | doc m%"
    Custom bash commands to run before linters
    "%
    | optional,
  PRINT_ALL_FILES
    | Bool
    | doc m%"
    If set to false, only fixed and error files are displayed in logs
    "%
    | optional,
  PRINT_ALPACA
    | Bool
    | doc m%"
    Enable printing alpaca image to console output
    "%
    | optional,
  PROTOBUF_FILTER_REGEX_EXCLUDE | String | optional,
  PROTOBUF_FILTER_REGEX_INCLUDE | String | optional,
  PROTOBUF_PROTOLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PROTOBUF_PROTOLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  PROTOBUF_PROTOLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PROTOBUF_PROTOLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  PROTOBUF_PROTOLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PROTOBUF_PROTOLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  PROTOBUF_PROTOLINT_CONFIG_FILE
    | String
    | doc m%"
    PROTOBUF_PROTOLINT: User custom config file name if different from default
    "%
    | optional,
  PROTOBUF_PROTOLINT_DISABLE_ERRORS | Bool | optional,
  PROTOBUF_PROTOLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PROTOBUF_PROTOLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PROTOBUF_PROTOLINT_FILE_NAME
    | String
    | doc m%"
    PROTOBUF_PROTOLINT: User custom config file name if different from default
    "%
    | optional,
  PROTOBUF_PROTOLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PROTOBUF_PROTOLINT_FILTER_REGEX_EXCLUDE | String | optional,
  PROTOBUF_PROTOLINT_FILTER_REGEX_INCLUDE | String | optional,
  PROTOBUF_PROTOLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PROTOBUF_PROTOLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PROTOBUF_PROTOLINT_RULES_PATH
    | String
    | doc m%"
    PROTOBUF_PROTOLINT: Path where to find linter configuration file
    "%
    | optional,
  PROTOBUF_PROTOLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PROTOBUF_PROTOLINT and its pre/post commands
    "%
    | optional,
  PUPPET_FILTER_REGEX_EXCLUDE | String | optional,
  PUPPET_FILTER_REGEX_INCLUDE | String | optional,
  PUPPET_PUPPET_LINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PUPPET_PUPPET_LINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  PUPPET_PUPPET_LINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PUPPET_PUPPET_LINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  PUPPET_PUPPET_LINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PUPPET_PUPPET_LINT: User custom arguments to remove before calling linter
    "%
    | optional,
  PUPPET_PUPPET_LINT_CONFIG_FILE
    | String
    | doc m%"
    PUPPET_PUPPET_LINT: User custom config file name if different from default
    "%
    | optional,
  PUPPET_PUPPET_LINT_DISABLE_ERRORS | Bool | optional,
  PUPPET_PUPPET_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PUPPET_PUPPET_LINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PUPPET_PUPPET_LINT_FILE_NAME
    | String
    | doc m%"
    PUPPET_PUPPET_LINT: User custom config file name if different from default
    "%
    | optional,
  PUPPET_PUPPET_LINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PUPPET_PUPPET_LINT_FILTER_REGEX_EXCLUDE | String | optional,
  PUPPET_PUPPET_LINT_FILTER_REGEX_INCLUDE | String | optional,
  PUPPET_PUPPET_LINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PUPPET_PUPPET_LINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PUPPET_PUPPET_LINT_RULES_PATH
    | String
    | doc m%"
    PUPPET_PUPPET_LINT: Path where to find linter configuration file
    "%
    | optional,
  PUPPET_PUPPET_LINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PUPPET_PUPPET_LINT and its pre/post commands
    "%
    | optional,
  PYTHON_BANDIT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_BANDIT: User custom arguments to add in linter CLI call
    "%
    | optional,
  PYTHON_BANDIT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_BANDIT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  PYTHON_BANDIT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_BANDIT: User custom arguments to remove before calling linter
    "%
    | optional,
  PYTHON_BANDIT_CONFIG_FILE
    | String
    | doc m%"
    PYTHON_BANDIT: User custom config file name if different from default
    "%
    | optional,
  PYTHON_BANDIT_DISABLE_ERRORS | Bool | optional,
  PYTHON_BANDIT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PYTHON_BANDIT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_BANDIT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_BANDIT_FILTER_REGEX_EXCLUDE | String | optional,
  PYTHON_BANDIT_FILTER_REGEX_INCLUDE | String | optional,
  PYTHON_BANDIT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_BANDIT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_BANDIT_RULES_PATH
    | String
    | doc m%"
    PYTHON_BANDIT: Path where to find linter configuration file
    "%
    | optional,
  PYTHON_BANDIT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PYTHON_BANDIT and its pre/post commands
    "%
    | optional,
  PYTHON_BLACK_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_BLACK: User custom arguments to add in linter CLI call
    "%
    | optional,
  PYTHON_BLACK_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_BLACK_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  PYTHON_BLACK_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_BLACK: User custom arguments to remove before calling linter
    "%
    | optional,
  PYTHON_BLACK_CONFIG_FILE
    | String
    | doc m%"
    PYTHON_BLACK: User custom config file name if different from default
    "%
    | optional,
  PYTHON_BLACK_DISABLE_ERRORS | Bool | optional,
  PYTHON_BLACK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PYTHON_BLACK_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_BLACK_FILE_NAME
    | String
    | doc m%"
    PYTHON_BLACK: User custom config file name if different from default
    "%
    | optional,
  PYTHON_BLACK_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_BLACK_FILTER_REGEX_EXCLUDE | String | optional,
  PYTHON_BLACK_FILTER_REGEX_INCLUDE | String | optional,
  PYTHON_BLACK_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_BLACK_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_BLACK_RULES_PATH
    | String
    | doc m%"
    PYTHON_BLACK: Path where to find linter configuration file
    "%
    | optional,
  PYTHON_BLACK_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PYTHON_BLACK and its pre/post commands
    "%
    | optional,
  PYTHON_FILTER_REGEX_EXCLUDE | String | optional,
  PYTHON_FILTER_REGEX_INCLUDE | String | optional,
  PYTHON_FLAKE8_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_FLAKE8: User custom arguments to add in linter CLI call
    "%
    | optional,
  PYTHON_FLAKE8_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_FLAKE8_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  PYTHON_FLAKE8_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_FLAKE8: User custom arguments to remove before calling linter
    "%
    | optional,
  PYTHON_FLAKE8_CONFIG_FILE
    | String
    | doc m%"
    PYTHON_FLAKE8: User custom config file name if different from default
    "%
    | optional,
  PYTHON_FLAKE8_DISABLE_ERRORS | Bool | optional,
  PYTHON_FLAKE8_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PYTHON_FLAKE8_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_FLAKE8_FILE_NAME
    | String
    | doc m%"
    PYTHON_FLAKE8: User custom config file name if different from default
    "%
    | optional,
  PYTHON_FLAKE8_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_FLAKE8_FILTER_REGEX_EXCLUDE | String | optional,
  PYTHON_FLAKE8_FILTER_REGEX_INCLUDE | String | optional,
  PYTHON_FLAKE8_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_FLAKE8_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_FLAKE8_RULES_PATH
    | String
    | doc m%"
    PYTHON_FLAKE8: Path where to find linter configuration file
    "%
    | optional,
  PYTHON_FLAKE8_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PYTHON_FLAKE8 and its pre/post commands
    "%
    | optional,
  PYTHON_ISORT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_ISORT: User custom arguments to add in linter CLI call
    "%
    | optional,
  PYTHON_ISORT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_ISORT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  PYTHON_ISORT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_ISORT: User custom arguments to remove before calling linter
    "%
    | optional,
  PYTHON_ISORT_CONFIG_FILE
    | String
    | doc m%"
    PYTHON_ISORT: User custom config file name if different from default
    "%
    | optional,
  PYTHON_ISORT_DISABLE_ERRORS | Bool | optional,
  PYTHON_ISORT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PYTHON_ISORT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_ISORT_FILE_NAME
    | String
    | doc m%"
    PYTHON_ISORT: User custom config file name if different from default
    "%
    | optional,
  PYTHON_ISORT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_ISORT_FILTER_REGEX_EXCLUDE | String | optional,
  PYTHON_ISORT_FILTER_REGEX_INCLUDE | String | optional,
  PYTHON_ISORT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_ISORT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_ISORT_RULES_PATH
    | String
    | doc m%"
    PYTHON_ISORT: Path where to find linter configuration file
    "%
    | optional,
  PYTHON_ISORT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PYTHON_ISORT and its pre/post commands
    "%
    | optional,
  PYTHON_MYPY_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_MYPY: User custom arguments to add in linter CLI call
    "%
    | optional,
  PYTHON_MYPY_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_MYPY_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  PYTHON_MYPY_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_MYPY: User custom arguments to remove before calling linter
    "%
    | optional,
  PYTHON_MYPY_CONFIG_FILE
    | String
    | doc m%"
    PYTHON_MYPY: User custom config file name if different from default
    "%
    | optional,
  PYTHON_MYPY_DISABLE_ERRORS | Bool | optional,
  PYTHON_MYPY_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PYTHON_MYPY_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_MYPY_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_MYPY_FILTER_REGEX_EXCLUDE | String | optional,
  PYTHON_MYPY_FILTER_REGEX_INCLUDE | String | optional,
  PYTHON_MYPY_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_MYPY_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_MYPY_RULES_PATH
    | String
    | doc m%"
    PYTHON_MYPY: Path where to find linter configuration file
    "%
    | optional,
  PYTHON_MYPY_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PYTHON_MYPY and its pre/post commands
    "%
    | optional,
  PYTHON_PYLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_PYLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  PYTHON_PYLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_PYLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  PYTHON_PYLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_PYLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  PYTHON_PYLINT_CONFIG_FILE
    | String
    | doc m%"
    PYTHON_PYLINT: User custom config file name if different from default
    "%
    | optional,
  PYTHON_PYLINT_DISABLE_ERRORS | Bool | optional,
  PYTHON_PYLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PYTHON_PYLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_PYLINT_FILE_NAME
    | String
    | doc m%"
    PYTHON_PYLINT: User custom config file name if different from default
    "%
    | optional,
  PYTHON_PYLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_PYLINT_FILTER_REGEX_EXCLUDE | String | optional,
  PYTHON_PYLINT_FILTER_REGEX_INCLUDE | String | optional,
  PYTHON_PYLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_PYLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_PYLINT_RULES_PATH
    | String
    | doc m%"
    PYTHON_PYLINT: Path where to find linter configuration file
    "%
    | optional,
  PYTHON_PYLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PYTHON_PYLINT and its pre/post commands
    "%
    | optional,
  PYTHON_PYRIGHT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_PYRIGHT: User custom arguments to add in linter CLI call
    "%
    | optional,
  PYTHON_PYRIGHT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_PYRIGHT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  PYTHON_PYRIGHT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_PYRIGHT: User custom arguments to remove before calling linter
    "%
    | optional,
  PYTHON_PYRIGHT_CONFIG_FILE
    | String
    | doc m%"
    PYTHON_PYRIGHT: User custom config file name if different from default
    "%
    | optional,
  PYTHON_PYRIGHT_DISABLE_ERRORS | Bool | optional,
  PYTHON_PYRIGHT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PYTHON_PYRIGHT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_PYRIGHT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_PYRIGHT_FILTER_REGEX_EXCLUDE | String | optional,
  PYTHON_PYRIGHT_FILTER_REGEX_INCLUDE | String | optional,
  PYTHON_PYRIGHT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_PYRIGHT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_PYRIGHT_RULES_PATH
    | String
    | doc m%"
    PYTHON_PYRIGHT: Path where to find linter configuration file
    "%
    | optional,
  PYTHON_PYRIGHT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PYTHON_PYRIGHT and its pre/post commands
    "%
    | optional,
  PYTHON_RUFF_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_RUFF: User custom arguments to add in linter CLI call
    "%
    | optional,
  PYTHON_RUFF_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_RUFF_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  PYTHON_RUFF_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    PYTHON_RUFF: User custom arguments to remove before calling linter
    "%
    | optional,
  PYTHON_RUFF_CONFIG_FILE
    | String
    | doc m%"
    PYTHON_RUFF: User custom config file name if different from default
    "%
    | optional,
  PYTHON_RUFF_DISABLE_ERRORS | Bool | optional,
  PYTHON_RUFF_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  PYTHON_RUFF_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_RUFF_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  PYTHON_RUFF_FILTER_REGEX_EXCLUDE | String | optional,
  PYTHON_RUFF_FILTER_REGEX_INCLUDE | String | optional,
  PYTHON_RUFF_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_RUFF_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  PYTHON_RUFF_RULES_PATH
    | String
    | doc m%"
    PYTHON_RUFF: Path where to find linter configuration file
    "%
    | optional,
  PYTHON_RUFF_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling PYTHON_RUFF and its pre/post commands
    "%
    | optional,
  RAKU_FILTER_REGEX_EXCLUDE | String | optional,
  RAKU_FILTER_REGEX_INCLUDE | String | optional,
  RAKU_RAKU_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    RAKU_RAKU: User custom arguments to add in linter CLI call
    "%
    | optional,
  RAKU_RAKU_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RAKU_RAKU_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  RAKU_RAKU_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    RAKU_RAKU: User custom arguments to remove before calling linter
    "%
    | optional,
  RAKU_RAKU_CONFIG_FILE
    | String
    | doc m%"
    RAKU_RAKU: User custom config file name if different from default
    "%
    | optional,
  RAKU_RAKU_DISABLE_ERRORS | Bool | optional,
  RAKU_RAKU_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  RAKU_RAKU_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RAKU_RAKU_FILE_NAME
    | String
    | doc m%"
    RAKU_RAKU: User custom config file name if different from default
    "%
    | optional,
  RAKU_RAKU_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RAKU_RAKU_FILTER_REGEX_EXCLUDE | String | optional,
  RAKU_RAKU_FILTER_REGEX_INCLUDE | String | optional,
  RAKU_RAKU_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  RAKU_RAKU_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  RAKU_RAKU_RULES_PATH
    | String
    | doc m%"
    RAKU_RAKU: Path where to find linter configuration file
    "%
    | optional,
  RAKU_RAKU_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling RAKU_RAKU and its pre/post commands
    "%
    | optional,
  REPORTERS_MARKDOWN_TYPE
    | std.enum.TagOrString
    | [| 'advanced, 'simple |]
    | doc m%"
    Define simple if you do not to have external images in PR/MR comments
    "%
    | optional,
  REPORT_OUTPUT_FOLDER
    | String
    | doc m%"
    The location where the output reporting will be generated to
    "%
    | optional,
  REPOSITORY_CHECKOV_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_CHECKOV: User custom arguments to add in linter CLI call
    "%
    | optional,
  REPOSITORY_CHECKOV_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  REPOSITORY_CHECKOV_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_CHECKOV: User custom arguments to remove before calling linter
    "%
    | optional,
  REPOSITORY_CHECKOV_CONFIG_FILE
    | String
    | doc m%"
    REPOSITORY_CHECKOV: User custom config file name if different from default
    "%
    | optional,
  REPOSITORY_CHECKOV_DISABLE_ERRORS | Bool | optional,
  REPOSITORY_CHECKOV_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  REPOSITORY_CHECKOV_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_CHECKOV_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_CHECKOV_RULES_PATH
    | String
    | doc m%"
    REPOSITORY_CHECKOV: Path where to find linter configuration file
    "%
    | optional,
  REPOSITORY_CHECKOV_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling REPOSITORY_CHECKOV and its pre/post commands
    "%
    | optional,
  REPOSITORY_DEVSKIM_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_DEVSKIM: User custom arguments to add in linter CLI call
    "%
    | optional,
  REPOSITORY_DEVSKIM_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  REPOSITORY_DEVSKIM_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_DEVSKIM: User custom arguments to remove before calling linter
    "%
    | optional,
  REPOSITORY_DEVSKIM_DISABLE_ERRORS | Bool | optional,
  REPOSITORY_DEVSKIM_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  REPOSITORY_DEVSKIM_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_DEVSKIM_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_DEVSKIM_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling REPOSITORY_DEVSKIM and its pre/post commands
    "%
    | optional,
  REPOSITORY_DUSTILOCK_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_DUSTILOCK: User custom arguments to add in linter CLI call
    "%
    | optional,
  REPOSITORY_DUSTILOCK_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  REPOSITORY_DUSTILOCK_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_DUSTILOCK: User custom arguments to remove before calling linter
    "%
    | optional,
  REPOSITORY_DUSTILOCK_DISABLE_ERRORS | Bool | optional,
  REPOSITORY_DUSTILOCK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  REPOSITORY_DUSTILOCK_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_DUSTILOCK_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_DUSTILOCK_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling REPOSITORY_DUSTILOCK and its pre/post commands
    "%
    | optional,
  REPOSITORY_FILTER_REGEX_EXCLUDE | String | optional,
  REPOSITORY_FILTER_REGEX_INCLUDE | String | optional,
  REPOSITORY_GITLEAKS_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_GITLEAKS: User custom arguments to add in linter CLI call
    "%
    | optional,
  REPOSITORY_GITLEAKS_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  REPOSITORY_GITLEAKS_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_GITLEAKS: User custom arguments to remove before calling linter
    "%
    | optional,
  REPOSITORY_GITLEAKS_CONFIG_FILE
    | String
    | doc m%"
    REPOSITORY_GITLEAKS: User custom config file name if different from default
    "%
    | optional,
  REPOSITORY_GITLEAKS_DISABLE_ERRORS | Bool | optional,
  REPOSITORY_GITLEAKS_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  REPOSITORY_GITLEAKS_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_GITLEAKS_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_GITLEAKS_RULES_PATH
    | String
    | doc m%"
    REPOSITORY_GITLEAKS: Path where to find linter configuration file
    "%
    | optional,
  REPOSITORY_GITLEAKS_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling REPOSITORY_GITLEAKS and its pre/post commands
    "%
    | optional,
  REPOSITORY_GIT_DIFF_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_GIT_DIFF: User custom arguments to add in linter CLI call
    "%
    | optional,
  REPOSITORY_GIT_DIFF_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  REPOSITORY_GIT_DIFF_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_GIT_DIFF: User custom arguments to remove before calling linter
    "%
    | optional,
  REPOSITORY_GIT_DIFF_DISABLE_ERRORS | Bool | optional,
  REPOSITORY_GIT_DIFF_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  REPOSITORY_GIT_DIFF_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_GIT_DIFF_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_GIT_DIFF_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling REPOSITORY_GIT_DIFF and its pre/post commands
    "%
    | optional,
  REPOSITORY_GOODCHECK_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_GOODCHECK: User custom arguments to add in linter CLI call
    "%
    | optional,
  REPOSITORY_GOODCHECK_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  REPOSITORY_GOODCHECK_CONFIG_FILE
    | String
    | doc m%"
    REPOSITORY_GOODCHECK: User custom config file name if different from default
    "%
    | optional,
  REPOSITORY_GOODCHECK_DISABLE_ERRORS | Bool | optional,
  REPOSITORY_GOODCHECK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  REPOSITORY_GOODCHECK_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_GOODCHECK_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_GOODCHECK_RULES_PATH
    | String
    | doc m%"
    REPOSITORY_GOODCHECK: Path where to find linter configuration file
    "%
    | optional,
  REPOSITORY_GRYPE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_GRYPE: User custom arguments to add in linter CLI call
    "%
    | optional,
  REPOSITORY_GRYPE_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  REPOSITORY_GRYPE_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_GRYPE: User custom arguments to remove before calling linter
    "%
    | optional,
  REPOSITORY_GRYPE_CONFIG_FILE
    | String
    | doc m%"
    REPOSITORY_GRYPE: User custom config file name if different from default
    "%
    | optional,
  REPOSITORY_GRYPE_DISABLE_ERRORS | Bool | optional,
  REPOSITORY_GRYPE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  REPOSITORY_GRYPE_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_GRYPE_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_GRYPE_RULES_PATH
    | String
    | doc m%"
    REPOSITORY_GRYPE: Path where to find linter configuration file
    "%
    | optional,
  REPOSITORY_GRYPE_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling REPOSITORY_GRYPE and its pre/post commands
    "%
    | optional,
  REPOSITORY_KICS_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_KICS: User custom arguments to add in linter CLI call
    "%
    | optional,
  REPOSITORY_KICS_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  REPOSITORY_KICS_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_KICS: User custom arguments to remove before calling linter
    "%
    | optional,
  REPOSITORY_KICS_CONFIG_FILE
    | String
    | doc m%"
    REPOSITORY_KICS: User custom config file name if different from default
    "%
    | optional,
  REPOSITORY_KICS_DISABLE_ERRORS | Bool | optional,
  REPOSITORY_KICS_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  REPOSITORY_KICS_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_KICS_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_KICS_RULES_PATH
    | String
    | doc m%"
    REPOSITORY_KICS: Path where to find linter configuration file
    "%
    | optional,
  REPOSITORY_KICS_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling REPOSITORY_KICS and its pre/post commands
    "%
    | optional,
  REPOSITORY_SECRETLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_SECRETLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  REPOSITORY_SECRETLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  REPOSITORY_SECRETLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_SECRETLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  REPOSITORY_SECRETLINT_CONFIG_FILE
    | String
    | doc m%"
    REPOSITORY_SECRETLINT: User custom config file name if different from default
    "%
    | optional,
  REPOSITORY_SECRETLINT_DISABLE_ERRORS | Bool | optional,
  REPOSITORY_SECRETLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  REPOSITORY_SECRETLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_SECRETLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_SECRETLINT_RULES_PATH
    | String
    | doc m%"
    REPOSITORY_SECRETLINT: Path where to find linter configuration file
    "%
    | optional,
  REPOSITORY_SECRETLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling REPOSITORY_SECRETLINT and its pre/post commands
    "%
    | optional,
  REPOSITORY_SEMGREP_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_SEMGREP: User custom arguments to add in linter CLI call
    "%
    | optional,
  REPOSITORY_SEMGREP_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  REPOSITORY_SEMGREP_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_SEMGREP: User custom arguments to remove before calling linter
    "%
    | optional,
  REPOSITORY_SEMGREP_DISABLE_ERRORS | Bool | optional,
  REPOSITORY_SEMGREP_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  REPOSITORY_SEMGREP_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_SEMGREP_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_SEMGREP_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling REPOSITORY_SEMGREP and its pre/post commands
    "%
    | optional,
  REPOSITORY_SYFT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_SYFT: User custom arguments to add in linter CLI call
    "%
    | optional,
  REPOSITORY_SYFT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  REPOSITORY_SYFT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_SYFT: User custom arguments to remove before calling linter
    "%
    | optional,
  REPOSITORY_SYFT_CONFIG_FILE
    | String
    | doc m%"
    REPOSITORY_SYFT: User custom config file name if different from default
    "%
    | optional,
  REPOSITORY_SYFT_DISABLE_ERRORS | Bool | optional,
  REPOSITORY_SYFT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  REPOSITORY_SYFT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_SYFT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_SYFT_RULES_PATH
    | String
    | doc m%"
    REPOSITORY_SYFT: Path where to find linter configuration file
    "%
    | optional,
  REPOSITORY_SYFT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling REPOSITORY_SYFT and its pre/post commands
    "%
    | optional,
  REPOSITORY_TRIVY_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_TRIVY: User custom arguments to add in linter CLI call
    "%
    | optional,
  REPOSITORY_TRIVY_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  REPOSITORY_TRIVY_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_TRIVY: User custom arguments to remove before calling linter
    "%
    | optional,
  REPOSITORY_TRIVY_CONFIG_FILE
    | String
    | doc m%"
    REPOSITORY_TRIVY: User custom config file name if different from default
    "%
    | optional,
  REPOSITORY_TRIVY_DISABLE_ERRORS | Bool | optional,
  REPOSITORY_TRIVY_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  REPOSITORY_TRIVY_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_TRIVY_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_TRIVY_RULES_PATH
    | String
    | doc m%"
    REPOSITORY_TRIVY: Path where to find linter configuration file
    "%
    | optional,
  REPOSITORY_TRIVY_SBOM_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_TRIVY_SBOM: User custom arguments to add in linter CLI call
    "%
    | optional,
  REPOSITORY_TRIVY_SBOM_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  REPOSITORY_TRIVY_SBOM_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_TRIVY_SBOM: User custom arguments to remove before calling linter
    "%
    | optional,
  REPOSITORY_TRIVY_SBOM_CONFIG_FILE
    | String
    | doc m%"
    REPOSITORY_TRIVY_SBOM: User custom config file name if different from default
    "%
    | optional,
  REPOSITORY_TRIVY_SBOM_DISABLE_ERRORS | Bool | optional,
  REPOSITORY_TRIVY_SBOM_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  REPOSITORY_TRIVY_SBOM_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_TRIVY_SBOM_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_TRIVY_SBOM_RULES_PATH
    | String
    | doc m%"
    REPOSITORY_TRIVY_SBOM: Path where to find linter configuration file
    "%
    | optional,
  REPOSITORY_TRIVY_SBOM_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling REPOSITORY_TRIVY_SBOM and its pre/post commands
    "%
    | optional,
  REPOSITORY_TRIVY_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling REPOSITORY_TRIVY and its pre/post commands
    "%
    | optional,
  REPOSITORY_TRUFFLEHOG_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_TRUFFLEHOG: User custom arguments to add in linter CLI call
    "%
    | optional,
  REPOSITORY_TRUFFLEHOG_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  REPOSITORY_TRUFFLEHOG_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    REPOSITORY_TRUFFLEHOG: User custom arguments to remove before calling linter
    "%
    | optional,
  REPOSITORY_TRUFFLEHOG_CONFIG_FILE
    | String
    | doc m%"
    REPOSITORY_TRUFFLEHOG: User custom config file name if different from default
    "%
    | optional,
  REPOSITORY_TRUFFLEHOG_DISABLE_ERRORS | Bool | optional,
  REPOSITORY_TRUFFLEHOG_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  REPOSITORY_TRUFFLEHOG_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_TRUFFLEHOG_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  REPOSITORY_TRUFFLEHOG_RULES_PATH
    | String
    | doc m%"
    REPOSITORY_TRUFFLEHOG: Path where to find linter configuration file
    "%
    | optional,
  REPOSITORY_TRUFFLEHOG_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling REPOSITORY_TRUFFLEHOG and its pre/post commands
    "%
    | optional,
  RST_FILTER_REGEX_EXCLUDE | String | optional,
  RST_FILTER_REGEX_INCLUDE | String | optional,
  RST_RSTCHECK_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    RST_RSTCHECK: User custom arguments to add in linter CLI call
    "%
    | optional,
  RST_RSTCHECK_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RST_RSTCHECK_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  RST_RSTCHECK_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    RST_RSTCHECK: User custom arguments to remove before calling linter
    "%
    | optional,
  RST_RSTCHECK_CONFIG_FILE
    | String
    | doc m%"
    RST_RSTCHECK: User custom config file name if different from default
    "%
    | optional,
  RST_RSTCHECK_DISABLE_ERRORS | Bool | optional,
  RST_RSTCHECK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  RST_RSTCHECK_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RST_RSTCHECK_FILE_NAME
    | String
    | doc m%"
    RST_RSTCHECK: User custom config file name if different from default
    "%
    | optional,
  RST_RSTCHECK_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RST_RSTCHECK_FILTER_REGEX_EXCLUDE | String | optional,
  RST_RSTCHECK_FILTER_REGEX_INCLUDE | String | optional,
  RST_RSTCHECK_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  RST_RSTCHECK_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  RST_RSTCHECK_RULES_PATH
    | String
    | doc m%"
    RST_RSTCHECK: Path where to find linter configuration file
    "%
    | optional,
  RST_RSTCHECK_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling RST_RSTCHECK and its pre/post commands
    "%
    | optional,
  RST_RSTFMT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    RST_RSTFMT: User custom arguments to add in linter CLI call
    "%
    | optional,
  RST_RSTFMT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RST_RSTFMT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  RST_RSTFMT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    RST_RSTFMT: User custom arguments to remove before calling linter
    "%
    | optional,
  RST_RSTFMT_DISABLE_ERRORS | Bool | optional,
  RST_RSTFMT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  RST_RSTFMT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RST_RSTFMT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RST_RSTFMT_FILTER_REGEX_EXCLUDE | String | optional,
  RST_RSTFMT_FILTER_REGEX_INCLUDE | String | optional,
  RST_RSTFMT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  RST_RSTFMT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  RST_RSTFMT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling RST_RSTFMT and its pre/post commands
    "%
    | optional,
  RST_RST_LINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    RST_RST_LINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  RST_RST_LINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RST_RST_LINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  RST_RST_LINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    RST_RST_LINT: User custom arguments to remove before calling linter
    "%
    | optional,
  RST_RST_LINT_DISABLE_ERRORS | Bool | optional,
  RST_RST_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  RST_RST_LINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RST_RST_LINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RST_RST_LINT_FILTER_REGEX_EXCLUDE | String | optional,
  RST_RST_LINT_FILTER_REGEX_INCLUDE | String | optional,
  RST_RST_LINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  RST_RST_LINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  RST_RST_LINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling RST_RST_LINT and its pre/post commands
    "%
    | optional,
  RUBY_FILTER_REGEX_EXCLUDE | String | optional,
  RUBY_FILTER_REGEX_INCLUDE | String | optional,
  RUBY_RUBOCOP_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    RUBY_RUBOCOP: User custom arguments to add in linter CLI call
    "%
    | optional,
  RUBY_RUBOCOP_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RUBY_RUBOCOP_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  RUBY_RUBOCOP_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    RUBY_RUBOCOP: User custom arguments to remove before calling linter
    "%
    | optional,
  RUBY_RUBOCOP_CONFIG_FILE
    | String
    | doc m%"
    RUBY_RUBOCOP: User custom config file name if different from default
    "%
    | optional,
  RUBY_RUBOCOP_DISABLE_ERRORS | Bool | optional,
  RUBY_RUBOCOP_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  RUBY_RUBOCOP_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RUBY_RUBOCOP_FILE_NAME
    | String
    | doc m%"
    RUBY_RUBOCOP: User custom config file name if different from default
    "%
    | optional,
  RUBY_RUBOCOP_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RUBY_RUBOCOP_FILTER_REGEX_EXCLUDE | String | optional,
  RUBY_RUBOCOP_FILTER_REGEX_INCLUDE | String | optional,
  RUBY_RUBOCOP_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  RUBY_RUBOCOP_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  RUBY_RUBOCOP_RULES_PATH
    | String
    | doc m%"
    RUBY_RUBOCOP: Path where to find linter configuration file
    "%
    | optional,
  RUBY_RUBOCOP_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling RUBY_RUBOCOP and its pre/post commands
    "%
    | optional,
  RUST_CLIPPY_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    RUST_CLIPPY: User custom arguments to add in linter CLI call
    "%
    | optional,
  RUST_CLIPPY_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RUST_CLIPPY_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    RUST_CLIPPY: User custom arguments to remove before calling linter
    "%
    | optional,
  RUST_CLIPPY_CONFIG_FILE
    | String
    | doc m%"
    RUST_CLIPPY: User custom config file name if different from default
    "%
    | optional,
  RUST_CLIPPY_DISABLE_ERRORS | Bool | optional,
  RUST_CLIPPY_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  RUST_CLIPPY_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RUST_CLIPPY_FILE_NAME
    | String
    | doc m%"
    RUST_CLIPPY: User custom config file name if different from default
    "%
    | optional,
  RUST_CLIPPY_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  RUST_CLIPPY_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  RUST_CLIPPY_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  RUST_CLIPPY_RULES_PATH
    | String
    | doc m%"
    RUST_CLIPPY: Path where to find linter configuration file
    "%
    | optional,
  RUST_CLIPPY_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling RUST_CLIPPY and its pre/post commands
    "%
    | optional,
  RUST_FILTER_REGEX_EXCLUDE | String | optional,
  RUST_FILTER_REGEX_INCLUDE | String | optional,
  R_FILTER_REGEX_EXCLUDE | String | optional,
  R_FILTER_REGEX_INCLUDE | String | optional,
  R_LINTR_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    R_LINTR: User custom arguments to add in linter CLI call
    "%
    | optional,
  R_LINTR_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  R_LINTR_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  R_LINTR_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    R_LINTR: User custom arguments to remove before calling linter
    "%
    | optional,
  R_LINTR_CONFIG_FILE
    | String
    | doc m%"
    R_LINTR: User custom config file name if different from default
    "%
    | optional,
  R_LINTR_DISABLE_ERRORS | Bool | optional,
  R_LINTR_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  R_LINTR_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  R_LINTR_FILE_NAME
    | String
    | doc m%"
    R_LINTR: User custom config file name if different from default
    "%
    | optional,
  R_LINTR_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  R_LINTR_FILTER_REGEX_EXCLUDE | String | optional,
  R_LINTR_FILTER_REGEX_INCLUDE | String | optional,
  R_LINTR_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  R_LINTR_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  R_LINTR_RULES_PATH
    | String
    | doc m%"
    R_LINTR: Path where to find linter configuration file
    "%
    | optional,
  R_LINTR_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling R_LINTR and its pre/post commands
    "%
    | optional,
  SALESFORCE_DIRECTORY | String | optional,
  SALESFORCE_FILTER_REGEX_EXCLUDE | String | optional,
  SALESFORCE_FILTER_REGEX_INCLUDE | String | optional,
  SALESFORCE_SFDX_SCANNER_APEX_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SALESFORCE_SFDX_SCANNER_APEX: User custom arguments to add in linter CLI call
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_APEX_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SALESFORCE_SFDX_SCANNER_APEX_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SALESFORCE_SFDX_SCANNER_APEX: User custom arguments to remove before calling linter
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_APEX_CONFIG_FILE
    | String
    | doc m%"
    SALESFORCE_SFDX_SCANNER_APEX: User custom config file name if different from default
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_APEX_DIRECTORY | String | optional,
  SALESFORCE_SFDX_SCANNER_APEX_DISABLE_ERRORS | Bool | optional,
  SALESFORCE_SFDX_SCANNER_APEX_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SALESFORCE_SFDX_SCANNER_APEX_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SALESFORCE_SFDX_SCANNER_APEX_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SALESFORCE_SFDX_SCANNER_APEX_RULES_PATH
    | String
    | doc m%"
    SALESFORCE_SFDX_SCANNER_APEX: Path where to find linter configuration file
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_APEX_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling SALESFORCE_SFDX_SCANNER_APEX and its pre/post commands
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SALESFORCE_SFDX_SCANNER: User custom arguments to add in linter CLI call
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_AURA_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SALESFORCE_SFDX_SCANNER_AURA: User custom arguments to add in linter CLI call
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_AURA_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SALESFORCE_SFDX_SCANNER_AURA_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SALESFORCE_SFDX_SCANNER_AURA: User custom arguments to remove before calling linter
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_AURA_CONFIG_FILE
    | String
    | doc m%"
    SALESFORCE_SFDX_SCANNER_AURA: User custom config file name if different from default
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_AURA_DIRECTORY | String | optional,
  SALESFORCE_SFDX_SCANNER_AURA_DISABLE_ERRORS | Bool | optional,
  SALESFORCE_SFDX_SCANNER_AURA_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SALESFORCE_SFDX_SCANNER_AURA_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SALESFORCE_SFDX_SCANNER_AURA_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SALESFORCE_SFDX_SCANNER_AURA_RULES_PATH
    | String
    | doc m%"
    SALESFORCE_SFDX_SCANNER_AURA: Path where to find linter configuration file
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_AURA_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling SALESFORCE_SFDX_SCANNER_AURA and its pre/post commands
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_DIRECTORY | String | optional,
  SALESFORCE_SFDX_SCANNER_DISABLE_ERRORS | Bool | optional,
  SALESFORCE_SFDX_SCANNER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SALESFORCE_SFDX_SCANNER_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SALESFORCE_SFDX_SCANNER_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SALESFORCE_SFDX_SCANNER_FILTER_REGEX_EXCLUDE | String | optional,
  SALESFORCE_SFDX_SCANNER_FILTER_REGEX_INCLUDE | String | optional,
  SALESFORCE_SFDX_SCANNER_LWC_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SALESFORCE_SFDX_SCANNER_LWC: User custom arguments to add in linter CLI call
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_LWC_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SALESFORCE_SFDX_SCANNER_LWC_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SALESFORCE_SFDX_SCANNER_LWC: User custom arguments to remove before calling linter
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_LWC_CONFIG_FILE
    | String
    | doc m%"
    SALESFORCE_SFDX_SCANNER_LWC: User custom config file name if different from default
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_LWC_DIRECTORY | String | optional,
  SALESFORCE_SFDX_SCANNER_LWC_DISABLE_ERRORS | Bool | optional,
  SALESFORCE_SFDX_SCANNER_LWC_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SALESFORCE_SFDX_SCANNER_LWC_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SALESFORCE_SFDX_SCANNER_LWC_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SALESFORCE_SFDX_SCANNER_LWC_RULES_PATH
    | String
    | doc m%"
    SALESFORCE_SFDX_SCANNER_LWC: Path where to find linter configuration file
    "%
    | optional,
  SALESFORCE_SFDX_SCANNER_LWC_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling SALESFORCE_SFDX_SCANNER_LWC and its pre/post commands
    "%
    | optional,
  SARIF_REPORTER
    | Bool
    | doc m%"
    Generate SARIF reports that can be used to display issues directly in GitHub UI
    "%
    | optional,
  SARIF_REPORTER_FILE_NAME
    | String
    | doc m%"
    Override SARIF output file name
    "%
    | optional,
  SARIF_REPORTER_LINTERS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.enum_linter_keys
    ])
    | doc m%"
    If SARIF_REPORTER_LINTERS is set, only the linters in the list will output SARIF
    "%
    | optional,
  SCALA_FILTER_REGEX_EXCLUDE | String | optional,
  SCALA_FILTER_REGEX_INCLUDE | String | optional,
  SCALA_SCALAFIX_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SCALA_SCALAFIX: User custom arguments to add in linter CLI call
    "%
    | optional,
  SCALA_SCALAFIX_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SCALA_SCALAFIX_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  SCALA_SCALAFIX_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SCALA_SCALAFIX: User custom arguments to remove before calling linter
    "%
    | optional,
  SCALA_SCALAFIX_CONFIG_FILE
    | String
    | doc m%"
    SCALA_SCALAFIX: User custom config file name if different from default
    "%
    | optional,
  SCALA_SCALAFIX_DISABLE_ERRORS | Bool | optional,
  SCALA_SCALAFIX_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SCALA_SCALAFIX_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SCALA_SCALAFIX_FILE_NAME
    | String
    | doc m%"
    SCALA_SCALAFIX: User custom config file name if different from default
    "%
    | optional,
  SCALA_SCALAFIX_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SCALA_SCALAFIX_FILTER_REGEX_EXCLUDE | String | optional,
  SCALA_SCALAFIX_FILTER_REGEX_INCLUDE | String | optional,
  SCALA_SCALAFIX_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SCALA_SCALAFIX_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SCALA_SCALAFIX_RULES_PATH
    | String
    | doc m%"
    SCALA_SCALAFIX: Path where to find linter configuration file
    "%
    | optional,
  SCALA_SCALAFIX_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling SCALA_SCALAFIX and its pre/post commands
    "%
    | optional,
  SECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of secured environment variables to hide when calling linters
    "%
    | optional,
  SHOW_ELAPSED_TIME
    | Bool
    | doc m%"
    Displays elapsed time for each linter in reports
    "%
    | optional,
  SHOW_SKIPPED_LINTERS
    | Bool
    | doc m%"
    Displays all linters that mega-linter could run but didn't
    "%
    | optional,
  SKIP_CLI_LINT_MODES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.enum [ "file", "list_of_files", "project" ])
    ])
    | doc m%"
    Comma-separated list of cli_lint_modes. To use if you want to skip linters with some CLI lint modes (ex: "file,project"). Available values: file,cli_lint_mode,project
    "%
    | optional,
  SNAKEMAKE_FILTER_REGEX_EXCLUDE | String | optional,
  SNAKEMAKE_FILTER_REGEX_INCLUDE | String | optional,
  SNAKEMAKE_LINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SNAKEMAKE_LINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  SNAKEMAKE_LINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SNAKEMAKE_LINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  SNAKEMAKE_LINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SNAKEMAKE_LINT: User custom arguments to remove before calling linter
    "%
    | optional,
  SNAKEMAKE_LINT_DISABLE_ERRORS | Bool | optional,
  SNAKEMAKE_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SNAKEMAKE_LINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SNAKEMAKE_LINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SNAKEMAKE_LINT_FILTER_REGEX_EXCLUDE | String | optional,
  SNAKEMAKE_LINT_FILTER_REGEX_INCLUDE | String | optional,
  SNAKEMAKE_LINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SNAKEMAKE_LINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SNAKEMAKE_LINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling SNAKEMAKE_LINT and its pre/post commands
    "%
    | optional,
  SNAKEMAKE_SNAKEFMT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SNAKEMAKE_SNAKEFMT: User custom arguments to add in linter CLI call
    "%
    | optional,
  SNAKEMAKE_SNAKEFMT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SNAKEMAKE_SNAKEFMT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  SNAKEMAKE_SNAKEFMT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SNAKEMAKE_SNAKEFMT: User custom arguments to remove before calling linter
    "%
    | optional,
  SNAKEMAKE_SNAKEFMT_CONFIG_FILE
    | String
    | doc m%"
    SNAKEMAKE_SNAKEFMT: User custom config file name if different from default
    "%
    | optional,
  SNAKEMAKE_SNAKEFMT_DISABLE_ERRORS | Bool | optional,
  SNAKEMAKE_SNAKEFMT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SNAKEMAKE_SNAKEFMT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SNAKEMAKE_SNAKEFMT_FILE_NAME
    | String
    | doc m%"
    SNAKEMAKE_SNAKEFMT: User custom config file name if different from default
    "%
    | optional,
  SNAKEMAKE_SNAKEFMT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SNAKEMAKE_SNAKEFMT_FILTER_REGEX_EXCLUDE | String | optional,
  SNAKEMAKE_SNAKEFMT_FILTER_REGEX_INCLUDE | String | optional,
  SNAKEMAKE_SNAKEFMT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SNAKEMAKE_SNAKEFMT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SNAKEMAKE_SNAKEFMT_RULES_PATH
    | String
    | doc m%"
    SNAKEMAKE_SNAKEFMT: Path where to find linter configuration file
    "%
    | optional,
  SNAKEMAKE_SNAKEFMT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling SNAKEMAKE_SNAKEFMT and its pre/post commands
    "%
    | optional,
  SPELL_CSPELL_ANALYZE_FILE_NAMES
    | Bool
    | doc m%"
    If set to true, MegaLinter will also send file names to cspell for analysis.
    "%
    | optional,
  SPELL_CSPELL_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SPELL_CSPELL: User custom arguments to add in linter CLI call
    "%
    | optional,
  SPELL_CSPELL_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_CSPELL_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  SPELL_CSPELL_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SPELL_CSPELL: User custom arguments to remove before calling linter
    "%
    | optional,
  SPELL_CSPELL_CONFIG_FILE
    | String
    | doc m%"
    SPELL_CSPELL: User custom config file name if different from default
    "%
    | optional,
  SPELL_CSPELL_DISABLE_ERRORS | Bool | optional,
  SPELL_CSPELL_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SPELL_CSPELL_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_CSPELL_FILE_NAME
    | String
    | doc m%"
    SPELL_CSPELL: User custom config file name if different from default
    "%
    | optional,
  SPELL_CSPELL_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_CSPELL_FILTER_REGEX_EXCLUDE | String | optional,
  SPELL_CSPELL_FILTER_REGEX_INCLUDE | String | optional,
  SPELL_CSPELL_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SPELL_CSPELL_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SPELL_CSPELL_RULES_PATH
    | String
    | doc m%"
    SPELL_CSPELL: Path where to find linter configuration file
    "%
    | optional,
  SPELL_CSPELL_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling SPELL_CSPELL and its pre/post commands
    "%
    | optional,
  SPELL_FILTER_REGEX_EXCLUDE | String | optional,
  SPELL_FILTER_REGEX_INCLUDE | String | optional,
  SPELL_LYCHEE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SPELL_LYCHEE: User custom arguments to add in linter CLI call
    "%
    | optional,
  SPELL_LYCHEE_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_LYCHEE_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  SPELL_LYCHEE_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SPELL_LYCHEE: User custom arguments to remove before calling linter
    "%
    | optional,
  SPELL_LYCHEE_CONFIG_FILE
    | String
    | doc m%"
    SPELL_LYCHEE: User custom config file name if different from default
    "%
    | optional,
  SPELL_LYCHEE_DISABLE_ERRORS | Bool | optional,
  SPELL_LYCHEE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SPELL_LYCHEE_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_LYCHEE_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_LYCHEE_FILTER_REGEX_EXCLUDE | String | optional,
  SPELL_LYCHEE_FILTER_REGEX_INCLUDE | String | optional,
  SPELL_LYCHEE_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SPELL_LYCHEE_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SPELL_LYCHEE_RULES_PATH
    | String
    | doc m%"
    SPELL_LYCHEE: Path where to find linter configuration file
    "%
    | optional,
  SPELL_LYCHEE_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling SPELL_LYCHEE and its pre/post commands
    "%
    | optional,
  SPELL_MISSPELL_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SPELL_MISSPELL: User custom arguments to add in linter CLI call
    "%
    | optional,
  SPELL_MISSPELL_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_MISSPELL_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  SPELL_MISSPELL_DISABLE_ERRORS | Bool | optional,
  SPELL_MISSPELL_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SPELL_MISSPELL_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_MISSPELL_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_MISSPELL_FILTER_REGEX_EXCLUDE | String | optional,
  SPELL_MISSPELL_FILTER_REGEX_INCLUDE | String | optional,
  SPELL_MISSPELL_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SPELL_MISSPELL_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SPELL_PROSELINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SPELL_PROSELINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  SPELL_PROSELINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_PROSELINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  SPELL_PROSELINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SPELL_PROSELINT: User custom arguments to remove before calling linter
    "%
    | optional,
  SPELL_PROSELINT_CONFIG_FILE
    | String
    | doc m%"
    SPELL_PROSELINT: User custom config file name if different from default
    "%
    | optional,
  SPELL_PROSELINT_DISABLE_ERRORS | Bool | optional,
  SPELL_PROSELINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SPELL_PROSELINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_PROSELINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_PROSELINT_FILTER_REGEX_EXCLUDE | String | optional,
  SPELL_PROSELINT_FILTER_REGEX_INCLUDE | String | optional,
  SPELL_PROSELINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SPELL_PROSELINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SPELL_PROSELINT_RULES_PATH
    | String
    | doc m%"
    SPELL_PROSELINT: Path where to find linter configuration file
    "%
    | optional,
  SPELL_PROSELINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling SPELL_PROSELINT and its pre/post commands
    "%
    | optional,
  SPELL_VALE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SPELL_VALE: User custom arguments to add in linter CLI call
    "%
    | optional,
  SPELL_VALE_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_VALE_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  SPELL_VALE_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SPELL_VALE: User custom arguments to remove before calling linter
    "%
    | optional,
  SPELL_VALE_CONFIG_FILE
    | String
    | doc m%"
    SPELL_VALE: User custom config file name if different from default
    "%
    | optional,
  SPELL_VALE_DISABLE_ERRORS | Bool | optional,
  SPELL_VALE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SPELL_VALE_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_VALE_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SPELL_VALE_FILTER_REGEX_EXCLUDE | String | optional,
  SPELL_VALE_FILTER_REGEX_INCLUDE | String | optional,
  SPELL_VALE_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SPELL_VALE_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SPELL_VALE_RULES_PATH
    | String
    | doc m%"
    SPELL_VALE: Path where to find linter configuration file
    "%
    | optional,
  SPELL_VALE_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling SPELL_VALE and its pre/post commands
    "%
    | optional,
  SQL_FILTER_REGEX_EXCLUDE | String | optional,
  SQL_FILTER_REGEX_INCLUDE | String | optional,
  SQL_SQLFLUFF_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SQL_SQLFLUFF: User custom arguments to add in linter CLI call
    "%
    | optional,
  SQL_SQLFLUFF_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SQL_SQLFLUFF_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  SQL_SQLFLUFF_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SQL_SQLFLUFF: User custom arguments to remove before calling linter
    "%
    | optional,
  SQL_SQLFLUFF_CONFIG_FILE
    | String
    | doc m%"
    SQL_SQLFLUFF: User custom config file name if different from default
    "%
    | optional,
  SQL_SQLFLUFF_DISABLE_ERRORS | Bool | optional,
  SQL_SQLFLUFF_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SQL_SQLFLUFF_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SQL_SQLFLUFF_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SQL_SQLFLUFF_FILTER_REGEX_EXCLUDE | String | optional,
  SQL_SQLFLUFF_FILTER_REGEX_INCLUDE | String | optional,
  SQL_SQLFLUFF_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SQL_SQLFLUFF_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SQL_SQLFLUFF_RULES_PATH
    | String
    | doc m%"
    SQL_SQLFLUFF: Path where to find linter configuration file
    "%
    | optional,
  SQL_SQLFLUFF_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling SQL_SQLFLUFF and its pre/post commands
    "%
    | optional,
  SQL_SQL_LINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SQL_SQL_LINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  SQL_SQL_LINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SQL_SQL_LINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  SQL_SQL_LINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SQL_SQL_LINT: User custom arguments to remove before calling linter
    "%
    | optional,
  SQL_SQL_LINT_CONFIG_FILE
    | String
    | doc m%"
    SQL_SQL_LINT: User custom config file name if different from default
    "%
    | optional,
  SQL_SQL_LINT_DISABLE_ERRORS | Bool | optional,
  SQL_SQL_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SQL_SQL_LINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SQL_SQL_LINT_FILE_NAME
    | String
    | doc m%"
    SQL_SQL_LINT: User custom config file name if different from default
    "%
    | optional,
  SQL_SQL_LINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SQL_SQL_LINT_FILTER_REGEX_EXCLUDE | String | optional,
  SQL_SQL_LINT_FILTER_REGEX_INCLUDE | String | optional,
  SQL_SQL_LINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SQL_SQL_LINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SQL_SQL_LINT_RULES_PATH
    | String
    | doc m%"
    SQL_SQL_LINT: Path where to find linter configuration file
    "%
    | optional,
  SQL_SQL_LINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling SQL_SQL_LINT and its pre/post commands
    "%
    | optional,
  SQL_TSQLLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SQL_TSQLLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  SQL_TSQLLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SQL_TSQLLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  SQL_TSQLLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SQL_TSQLLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  SQL_TSQLLINT_CONFIG_FILE
    | String
    | doc m%"
    SQL_TSQLLINT: User custom config file name if different from default
    "%
    | optional,
  SQL_TSQLLINT_DISABLE_ERRORS | Bool | optional,
  SQL_TSQLLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SQL_TSQLLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SQL_TSQLLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SQL_TSQLLINT_FILTER_REGEX_EXCLUDE | String | optional,
  SQL_TSQLLINT_FILTER_REGEX_INCLUDE | String | optional,
  SQL_TSQLLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SQL_TSQLLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SQL_TSQLLINT_RULES_PATH
    | String
    | doc m%"
    SQL_TSQLLINT: Path where to find linter configuration file
    "%
    | optional,
  SQL_TSQLLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling SQL_TSQLLINT and its pre/post commands
    "%
    | optional,
  SWIFT_FILTER_REGEX_EXCLUDE | String | optional,
  SWIFT_FILTER_REGEX_INCLUDE | String | optional,
  SWIFT_SWIFTLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SWIFT_SWIFTLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  SWIFT_SWIFTLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SWIFT_SWIFTLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    SWIFT_SWIFTLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  SWIFT_SWIFTLINT_CONFIG_FILE
    | String
    | doc m%"
    SWIFT_SWIFTLINT: User custom config file name if different from default
    "%
    | optional,
  SWIFT_SWIFTLINT_DISABLE_ERRORS | Bool | optional,
  SWIFT_SWIFTLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  SWIFT_SWIFTLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SWIFT_SWIFTLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  SWIFT_SWIFTLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SWIFT_SWIFTLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  SWIFT_SWIFTLINT_RULES_PATH
    | String
    | doc m%"
    SWIFT_SWIFTLINT: Path where to find linter configuration file
    "%
    | optional,
  SWIFT_SWIFTLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling SWIFT_SWIFTLINT and its pre/post commands
    "%
    | optional,
  TAP_REPORTER
    | Bool
    | doc m%"
    General execution log mega-linter.log (same as ConsoleReporter log) + a separate log file for each processed linter
    "%
    | optional,
  TAP_REPORTER_SUB_FOLDER
    | String
    | doc m%"
    Sub-folder of reports folder containing TAP logs
    "%
    | optional,
  TEKTON_FILTER_REGEX_EXCLUDE | String | optional,
  TEKTON_FILTER_REGEX_INCLUDE | String | optional,
  TEKTON_TEKTON_LINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TEKTON_TEKTON_LINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  TEKTON_TEKTON_LINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TEKTON_TEKTON_LINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  TEKTON_TEKTON_LINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TEKTON_TEKTON_LINT: User custom arguments to remove before calling linter
    "%
    | optional,
  TEKTON_TEKTON_LINT_CONFIG_FILE
    | String
    | doc m%"
    TEKTON_TEKTON_LINT: User custom config file name if different from default
    "%
    | optional,
  TEKTON_TEKTON_LINT_DISABLE_ERRORS | Bool | optional,
  TEKTON_TEKTON_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  TEKTON_TEKTON_LINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TEKTON_TEKTON_LINT_FILE_NAME
    | String
    | doc m%"
    TEKTON_TEKTON_LINT: User custom config file name if different from default
    "%
    | optional,
  TEKTON_TEKTON_LINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TEKTON_TEKTON_LINT_FILTER_REGEX_EXCLUDE | String | optional,
  TEKTON_TEKTON_LINT_FILTER_REGEX_INCLUDE | String | optional,
  TEKTON_TEKTON_LINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TEKTON_TEKTON_LINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TEKTON_TEKTON_LINT_RULES_PATH
    | String
    | doc m%"
    TEKTON_TEKTON_LINT: Path where to find linter configuration file
    "%
    | optional,
  TEKTON_TEKTON_LINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling TEKTON_TEKTON_LINT and its pre/post commands
    "%
    | optional,
  TERRAFORM_CHECKOV_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TERRAFORM_CHECKOV: User custom arguments to add in linter CLI call
    "%
    | optional,
  TERRAFORM_CHECKOV_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_CHECKOV_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  TERRAFORM_CHECKOV_DISABLE_ERRORS | Bool | optional,
  TERRAFORM_CHECKOV_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  TERRAFORM_CHECKOV_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_CHECKOV_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_CHECKOV_FILTER_REGEX_EXCLUDE | String | optional,
  TERRAFORM_CHECKOV_FILTER_REGEX_INCLUDE | String | optional,
  TERRAFORM_CHECKOV_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TERRAFORM_CHECKOV_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TERRAFORM_FILTER_REGEX_EXCLUDE | String | optional,
  TERRAFORM_FILTER_REGEX_INCLUDE | String | optional,
  TERRAFORM_KICS_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TERRAFORM_KICS: User custom arguments to add in linter CLI call
    "%
    | optional,
  TERRAFORM_KICS_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_KICS_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  TERRAFORM_KICS_DISABLE_ERRORS | Bool | optional,
  TERRAFORM_KICS_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  TERRAFORM_KICS_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_KICS_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_KICS_FILTER_REGEX_EXCLUDE | String | optional,
  TERRAFORM_KICS_FILTER_REGEX_INCLUDE | String | optional,
  TERRAFORM_KICS_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TERRAFORM_KICS_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TERRAFORM_TERRAFORM_FMT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TERRAFORM_TERRAFORM_FMT: User custom arguments to add in linter CLI call
    "%
    | optional,
  TERRAFORM_TERRAFORM_FMT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_TERRAFORM_FMT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  TERRAFORM_TERRAFORM_FMT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TERRAFORM_TERRAFORM_FMT: User custom arguments to remove before calling linter
    "%
    | optional,
  TERRAFORM_TERRAFORM_FMT_DISABLE_ERRORS | Bool | optional,
  TERRAFORM_TERRAFORM_FMT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  TERRAFORM_TERRAFORM_FMT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_TERRAFORM_FMT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_TERRAFORM_FMT_FILTER_REGEX_EXCLUDE | String | optional,
  TERRAFORM_TERRAFORM_FMT_FILTER_REGEX_INCLUDE | String | optional,
  TERRAFORM_TERRAFORM_FMT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TERRAFORM_TERRAFORM_FMT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TERRAFORM_TERRAFORM_FMT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling TERRAFORM_TERRAFORM_FMT and its pre/post commands
    "%
    | optional,
  TERRAFORM_TERRAGRUNT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TERRAFORM_TERRAGRUNT: User custom arguments to add in linter CLI call
    "%
    | optional,
  TERRAFORM_TERRAGRUNT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_TERRAGRUNT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  TERRAFORM_TERRAGRUNT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TERRAFORM_TERRAGRUNT: User custom arguments to remove before calling linter
    "%
    | optional,
  TERRAFORM_TERRAGRUNT_CONFIG_FILE
    | String
    | doc m%"
    TERRAFORM_TERRAGRUNT: User custom config file name if different from default
    "%
    | optional,
  TERRAFORM_TERRAGRUNT_DISABLE_ERRORS | Bool | optional,
  TERRAFORM_TERRAGRUNT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  TERRAFORM_TERRAGRUNT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_TERRAGRUNT_FILE_NAME
    | String
    | doc m%"
    TERRAFORM_TERRAGRUNT: User custom config file name if different from default
    "%
    | optional,
  TERRAFORM_TERRAGRUNT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_TERRAGRUNT_FILTER_REGEX_EXCLUDE | String | optional,
  TERRAFORM_TERRAGRUNT_FILTER_REGEX_INCLUDE | String | optional,
  TERRAFORM_TERRAGRUNT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TERRAFORM_TERRAGRUNT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TERRAFORM_TERRAGRUNT_RULES_PATH
    | String
    | doc m%"
    TERRAFORM_TERRAGRUNT: Path where to find linter configuration file
    "%
    | optional,
  TERRAFORM_TERRAGRUNT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling TERRAFORM_TERRAGRUNT and its pre/post commands
    "%
    | optional,
  TERRAFORM_TERRASCAN_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TERRAFORM_TERRASCAN: User custom arguments to add in linter CLI call
    "%
    | optional,
  TERRAFORM_TERRASCAN_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_TERRASCAN_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TERRAFORM_TERRASCAN: User custom arguments to remove before calling linter
    "%
    | optional,
  TERRAFORM_TERRASCAN_CONFIG_FILE
    | String
    | doc m%"
    TERRAFORM_TERRASCAN: User custom config file name if different from default
    "%
    | optional,
  TERRAFORM_TERRASCAN_DISABLE_ERRORS | Bool | optional,
  TERRAFORM_TERRASCAN_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  TERRAFORM_TERRASCAN_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_TERRASCAN_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_TERRASCAN_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TERRAFORM_TERRASCAN_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TERRAFORM_TERRASCAN_RULES_PATH
    | String
    | doc m%"
    TERRAFORM_TERRASCAN: Path where to find linter configuration file
    "%
    | optional,
  TERRAFORM_TERRASCAN_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling TERRAFORM_TERRASCAN and its pre/post commands
    "%
    | optional,
  TERRAFORM_TFLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TERRAFORM_TFLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  TERRAFORM_TFLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_TFLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TERRAFORM_TFLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  TERRAFORM_TFLINT_CONFIG_FILE
    | String
    | doc m%"
    TERRAFORM_TFLINT: User custom config file name if different from default
    "%
    | optional,
  TERRAFORM_TFLINT_DISABLE_ERRORS | Bool | optional,
  TERRAFORM_TFLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  TERRAFORM_TFLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_TFLINT_FILE_NAME
    | String
    | doc m%"
    TERRAFORM_TFLINT: User custom config file name if different from default
    "%
    | optional,
  TERRAFORM_TFLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TERRAFORM_TFLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TERRAFORM_TFLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TERRAFORM_TFLINT_RULES_PATH
    | String
    | doc m%"
    TERRAFORM_TFLINT: Path where to find linter configuration file
    "%
    | optional,
  TERRAFORM_TFLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling TERRAFORM_TFLINT and its pre/post commands
    "%
    | optional,
  TEXT_REPORTER
    | Bool
    | doc m%"
    General execution log mega-linter.log (same as ConsoleReporter log) + a separate log file for each processed linter
    "%
    | optional,
  TEXT_REPORTER_SUB_FOLDER
    | String
    | doc m%"
    Sub-folder of reports folder containing text logs
    "%
    | optional,
  TSX_ESLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TSX_ESLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  TSX_ESLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TSX_ESLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  TSX_ESLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TSX_ESLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  TSX_ESLINT_CONFIG_FILE
    | String
    | doc m%"
    TSX_ESLINT: User custom config file name if different from default
    "%
    | optional,
  TSX_ESLINT_DISABLE_ERRORS | Bool | optional,
  TSX_ESLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  TSX_ESLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TSX_ESLINT_FILE_NAME
    | String
    | doc m%"
    TSX_ESLINT: User custom config file name if different from default
    "%
    | optional,
  TSX_ESLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TSX_ESLINT_FILTER_REGEX_EXCLUDE | String | optional,
  TSX_ESLINT_FILTER_REGEX_INCLUDE | String | optional,
  TSX_ESLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TSX_ESLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TSX_ESLINT_RULES_PATH
    | String
    | doc m%"
    TSX_ESLINT: Path where to find linter configuration file
    "%
    | optional,
  TSX_ESLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling TSX_ESLINT and its pre/post commands
    "%
    | optional,
  TSX_FILTER_REGEX_EXCLUDE | String | optional,
  TSX_FILTER_REGEX_INCLUDE | String | optional,
  TYPESCRIPT_DEFAULT_STYLE
    | std.enum.TagOrString
    | [| 'prettier, 'standard |]
    | doc m%"
    Style of typescript formatting to apply
    "%
    | optional,
  TYPESCRIPT_ES_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TYPESCRIPT_ES: User custom arguments to add in linter CLI call
    "%
    | optional,
  TYPESCRIPT_ES_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TYPESCRIPT_ES_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  TYPESCRIPT_ES_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TYPESCRIPT_ES: User custom arguments to remove before calling linter
    "%
    | optional,
  TYPESCRIPT_ES_CONFIG_FILE
    | String
    | doc m%"
    TYPESCRIPT_ES: User custom config file name if different from default
    "%
    | optional,
  TYPESCRIPT_ES_DISABLE_ERRORS | Bool | optional,
  TYPESCRIPT_ES_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  TYPESCRIPT_ES_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TYPESCRIPT_ES_FILE_NAME
    | String
    | doc m%"
    TYPESCRIPT_ES: User custom config file name if different from default
    "%
    | optional,
  TYPESCRIPT_ES_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TYPESCRIPT_ES_FILTER_REGEX_EXCLUDE | String | optional,
  TYPESCRIPT_ES_FILTER_REGEX_INCLUDE | String | optional,
  TYPESCRIPT_ES_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TYPESCRIPT_ES_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TYPESCRIPT_ES_RULES_PATH
    | String
    | doc m%"
    TYPESCRIPT_ES: Path where to find linter configuration file
    "%
    | optional,
  TYPESCRIPT_ES_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling TYPESCRIPT_ES and its pre/post commands
    "%
    | optional,
  TYPESCRIPT_FILTER_REGEX_EXCLUDE | String | optional,
  TYPESCRIPT_FILTER_REGEX_INCLUDE | String | optional,
  TYPESCRIPT_PRETTIER_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TYPESCRIPT_PRETTIER: User custom arguments to add in linter CLI call
    "%
    | optional,
  TYPESCRIPT_PRETTIER_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TYPESCRIPT_PRETTIER_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  TYPESCRIPT_PRETTIER_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TYPESCRIPT_PRETTIER: User custom arguments to remove before calling linter
    "%
    | optional,
  TYPESCRIPT_PRETTIER_CONFIG_FILE
    | String
    | doc m%"
    TYPESCRIPT_PRETTIER: User custom config file name if different from default
    "%
    | optional,
  TYPESCRIPT_PRETTIER_DISABLE_ERRORS | Bool | optional,
  TYPESCRIPT_PRETTIER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  TYPESCRIPT_PRETTIER_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TYPESCRIPT_PRETTIER_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TYPESCRIPT_PRETTIER_FILTER_REGEX_EXCLUDE | String | optional,
  TYPESCRIPT_PRETTIER_FILTER_REGEX_INCLUDE | String | optional,
  TYPESCRIPT_PRETTIER_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TYPESCRIPT_PRETTIER_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TYPESCRIPT_PRETTIER_RULES_PATH
    | String
    | doc m%"
    TYPESCRIPT_PRETTIER: Path where to find linter configuration file
    "%
    | optional,
  TYPESCRIPT_PRETTIER_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling TYPESCRIPT_PRETTIER and its pre/post commands
    "%
    | optional,
  TYPESCRIPT_STANDARD_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TYPESCRIPT_STANDARD: User custom arguments to add in linter CLI call
    "%
    | optional,
  TYPESCRIPT_STANDARD_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TYPESCRIPT_STANDARD_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  TYPESCRIPT_STANDARD_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    TYPESCRIPT_STANDARD: User custom arguments to remove before calling linter
    "%
    | optional,
  TYPESCRIPT_STANDARD_DISABLE_ERRORS | Bool | optional,
  TYPESCRIPT_STANDARD_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  TYPESCRIPT_STANDARD_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TYPESCRIPT_STANDARD_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  TYPESCRIPT_STANDARD_FILTER_REGEX_EXCLUDE | String | optional,
  TYPESCRIPT_STANDARD_FILTER_REGEX_INCLUDE | String | optional,
  TYPESCRIPT_STANDARD_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TYPESCRIPT_STANDARD_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  TYPESCRIPT_STANDARD_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling TYPESCRIPT_STANDARD and its pre/post commands
    "%
    | optional,
  UPDATED_SOURCES_REPORTER | Bool | optional,
  UPDATED_SOURCES_REPORTER_DIR | String | optional,
  VALIDATE_ALL_CODEBASE
    | Bool
    | doc m%"
    Will parse the entire repository and find all files to validate across all types. When set to false, only new or edited files will be parsed for validation.
    "%
    | optional,
  VBDOTNET_DOTNET_FORMAT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    VBDOTNET_DOTNET_FORMAT: User custom arguments to add in linter CLI call
    "%
    | optional,
  VBDOTNET_DOTNET_FORMAT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  VBDOTNET_DOTNET_FORMAT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'file |]
    | optional,
  VBDOTNET_DOTNET_FORMAT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    VBDOTNET_DOTNET_FORMAT: User custom arguments to remove before calling linter
    "%
    | optional,
  VBDOTNET_DOTNET_FORMAT_DISABLE_ERRORS | Bool | optional,
  VBDOTNET_DOTNET_FORMAT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  VBDOTNET_DOTNET_FORMAT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  VBDOTNET_DOTNET_FORMAT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  VBDOTNET_DOTNET_FORMAT_FILTER_REGEX_EXCLUDE | String | optional,
  VBDOTNET_DOTNET_FORMAT_FILTER_REGEX_INCLUDE | String | optional,
  VBDOTNET_DOTNET_FORMAT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  VBDOTNET_DOTNET_FORMAT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  VBDOTNET_DOTNET_FORMAT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling VBDOTNET_DOTNET_FORMAT and its pre/post commands
    "%
    | optional,
  VBDOTNET_FILTER_REGEX_EXCLUDE | String | optional,
  VBDOTNET_FILTER_REGEX_INCLUDE | String | optional,
  XML_FILTER_REGEX_EXCLUDE | String | optional,
  XML_FILTER_REGEX_INCLUDE | String | optional,
  XML_XMLLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    XML_XMLLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  XML_XMLLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  XML_XMLLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  XML_XMLLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    XML_XMLLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  XML_XMLLINT_DISABLE_ERRORS | Bool | optional,
  XML_XMLLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  XML_XMLLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  XML_XMLLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  XML_XMLLINT_FILTER_REGEX_EXCLUDE | String | optional,
  XML_XMLLINT_FILTER_REGEX_INCLUDE | String | optional,
  XML_XMLLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  XML_XMLLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  XML_XMLLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling XML_XMLLINT and its pre/post commands
    "%
    | optional,
  YAML_FILTER_REGEX_EXCLUDE | String | optional,
  YAML_FILTER_REGEX_INCLUDE | String | optional,
  YAML_PRETTIER_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    YAML_PRETTIER: User custom arguments to add in linter CLI call
    "%
    | optional,
  YAML_PRETTIER_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  YAML_PRETTIER_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  YAML_PRETTIER_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    YAML_PRETTIER: User custom arguments to remove before calling linter
    "%
    | optional,
  YAML_PRETTIER_CONFIG_FILE
    | String
    | doc m%"
    YAML_PRETTIER: User custom config file name if different from default
    "%
    | optional,
  YAML_PRETTIER_DISABLE_ERRORS | Bool | optional,
  YAML_PRETTIER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  YAML_PRETTIER_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  YAML_PRETTIER_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  YAML_PRETTIER_FILTER_REGEX_EXCLUDE | String | optional,
  YAML_PRETTIER_FILTER_REGEX_INCLUDE | String | optional,
  YAML_PRETTIER_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  YAML_PRETTIER_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  YAML_PRETTIER_RULES_PATH
    | String
    | doc m%"
    YAML_PRETTIER: Path where to find linter configuration file
    "%
    | optional,
  YAML_PRETTIER_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling YAML_PRETTIER and its pre/post commands
    "%
    | optional,
  YAML_V8R_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    YAML_V8R: User custom arguments to add in linter CLI call
    "%
    | optional,
  YAML_V8R_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  YAML_V8R_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  YAML_V8R_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    YAML_V8R: User custom arguments to remove before calling linter
    "%
    | optional,
  YAML_V8R_CONFIG_FILE
    | String
    | doc m%"
    YAML_V8R: User custom config file name if different from default
    "%
    | optional,
  YAML_V8R_DISABLE_ERRORS | Bool | optional,
  YAML_V8R_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  YAML_V8R_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  YAML_V8R_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  YAML_V8R_FILTER_REGEX_EXCLUDE | String | optional,
  YAML_V8R_FILTER_REGEX_INCLUDE | String | optional,
  YAML_V8R_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  YAML_V8R_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  YAML_V8R_RULES_PATH
    | String
    | doc m%"
    YAML_V8R: Path where to find linter configuration file
    "%
    | optional,
  YAML_V8R_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling YAML_V8R and its pre/post commands
    "%
    | optional,
  YAML_YAMLLINT_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    YAML_YAMLLINT: User custom arguments to add in linter CLI call
    "%
    | optional,
  YAML_YAMLLINT_CLI_EXECUTABLE
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  YAML_YAMLLINT_CLI_LINT_MODE
    | std.enum.TagOrString
    | [| 'project, 'list_of_files, 'file |]
    | optional,
  YAML_YAMLLINT_COMMAND_REMOVE_ARGUMENTS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"Array", predicates.isType '"String" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    YAML_YAMLLINT: User custom arguments to remove before calling linter
    "%
    | optional,
  YAML_YAMLLINT_CONFIG_FILE
    | String
    | doc m%"
    YAML_YAMLLINT: User custom config file name if different from default
    "%
    | optional,
  YAML_YAMLLINT_DISABLE_ERRORS | Bool | optional,
  YAML_YAMLLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
  YAML_YAMLLINT_FILE_EXTENSIONS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  YAML_YAMLLINT_FILE_NAME
    | String
    | doc m%"
    YAML_YAMLLINT: User custom config file name if different from default
    "%
    | optional,
  YAML_YAMLLINT_FILE_NAMES_REGEX
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  YAML_YAMLLINT_FILTER_REGEX_EXCLUDE | String | optional,
  YAML_YAMLLINT_FILTER_REGEX_INCLUDE | String | optional,
  YAML_YAMLLINT_POST_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  YAML_YAMLLINT_PRE_COMMANDS
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.command_info
    ])
    | optional,
  YAML_YAMLLINT_RULES_PATH
    | String
    | doc m%"
    YAML_YAMLLINT: Path where to find linter configuration file
    "%
    | optional,
  YAML_YAMLLINT_UNSECURED_ENV_VARIABLES
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of env variables explicitly not filtered before calling YAML_YAMLLINT and its pre/post commands
    "%
    | optional,
}