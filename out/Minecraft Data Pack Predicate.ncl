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
          enchantments = predicates.contract_from_predicate
              definitions.predicate.enchantments,
          integerRange = predicates.contract_from_predicate
              definitions.predicate.integerRange,
          numberProvider = predicates.contract_from_predicate
              definitions.predicate.numberProvider,
          numberRange = {
                max
                  | Number
                  | doc m%"
                  The max value.
                  "%
                  | optional,
                min
                  | Number
                  | doc m%"
                  The minimum value.
                  "%
                  | optional,
                ..
              },
          tagsCommonToAllDamageTypes = {
                bypasses_armor
                  | Bool
                  | doc m%"
                  Checks if the damage bypassed the armor of the player (suffocation damage predominantly).
                  "%
                  | optional,
                bypasses_invulnerability
                  | Bool
                  | doc m%"
                  Checks if the damage bypassed the invulnerability status of the player (void or /kill damage).
                  "%
                  | optional,
                bypasses_magic
                  | Bool
                  | doc m%"
                  Checks if the damage was caused by starvation.
                  "%
                  | optional,
                direct_entity
                  | {  .. }
                  | doc m%"
                  The entity that was the direct cause of the damage.
                  "%
                  | optional,
                is_explosion
                  | Bool
                  | doc m%"
                  Checks if the damage originated from an explosion.
                  "%
                  | optional,
                is_fire
                  | Bool
                  | doc m%"
                  Checks if the damage originated from fire.
                  "%
                  | optional,
                is_lightning
                  | Bool
                  | doc m%"
                  Checks if the damage originated from lightning.
                  "%
                  | optional,
                is_magic
                  | Bool
                  | doc m%"
                  Checks if the damage originated from magic.
                  "%
                  | optional,
                is_projectile
                  | Bool
                  | doc m%"
                  Checks if the damage originated from a projectile.
                  "%
                  | optional,
                source_entity
                  | definitions.contract.tagsCommonToAllEntities
                  | doc m%"
                  Checks the entity that was the source of the damage (for example: The skeleton that shot the arrow).
                  "%
                  | optional,
                ..
              },
          tagsCommonToAllEntities = {
                distance
                  | {
                    absolute | definitions.contract.numberRange | optional,
                    horizontal | definitions.contract.numberRange | optional,
                    x | definitions.contract.numberRange | optional,
                    y | definitions.contract.numberRange | optional,
                    z | definitions.contract.numberRange | optional,
                    ..
                  }
                  | optional,
                effects
                  | predicates.contract_from_predicate
                  (predicates.records.record {  } {  } true
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      ambient = predicates.isType '"Bool",
                      amplifier = predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType 'Integer,
                              predicates.isType 'Record
                            ],
                            definitions.predicate.integerRange
                          ],
                      duration = predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType 'Integer,
                              predicates.isType 'Record
                            ],
                            definitions.predicate.integerRange
                          ],
                      visible = predicates.isType '"Bool",
                    }
                    {  }
                    true
                    predicates.always
                  ]))
                  | doc m%"
                  A map of status effects.
                  "%
                  | optional,
                equipment
                  | {
                    chest
                      | definitions.contract.tagsCommonToAllItems
                      | optional,
                    feet | definitions.contract.tagsCommonToAllItems | optional,
                    head | definitions.contract.tagsCommonToAllItems | optional,
                    legs | definitions.contract.tagsCommonToAllItems | optional,
                    mainhand
                      | definitions.contract.tagsCommonToAllItems
                      | optional,
                    offhand
                      | definitions.contract.tagsCommonToAllItems
                      | optional,
                    ..
                  }
                  | optional,
                flags
                  | {
                    is_baby
                      | Bool
                      | doc m%"
                      Test whether the entity is or is not a baby variant.
                      "%
                      | optional,
                    is_on_fire
                      | predicates.contract_from_predicate predicates.always
                      | doc m%"
                      Test whether the entity is or is not on fire.
                      "%
                      | optional,
                    is_sneaking
                      | Bool
                      | doc m%"
                      Test whether the entity is or is not sneaking.
                      "%
                      | optional,
                    is_sprinting
                      | Bool
                      | doc m%"
                      Test whether the entity is or is not sprinting.
                      "%
                      | optional,
                    is_swimming
                      | Bool
                      | doc m%"
                      Test whether the entity is or is not swimming.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Predicate Flags to be checked.
                  "%
                  | optional,
                lightning_bolt
                  | {
                    blocks_set_on_fire
                      | std.number.Integer
                      | doc m%"
                      Number of blocks set on fire by this lightning bolt.
                      "%
                      | optional,
                    entity_struck
                      | definitions.contract.tagsCommonToAllEntities
                      | doc m%"
                      Entity properties of entities struck by this lightning bolt. If present, this tag must match one or more entities.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Lightning bolt properties to be checked. Fails when entity is not a lightning bolt.
                  "%
                  | optional,
                location
                  | definitions.contract.tagsCommonToAllLocations
                  | optional,
                nbt
                  | String
                  | doc m%"
                  An NBT string.
                  "%
                  | optional,
                passenger
                  | definitions.contract.tagsCommonToAllEntities
                  | doc m%"
                  The entity directly riding this entity.
                  "%
                  | optional,
                player
                  | {
                    advancements
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType '"Bool",
                            predicates.isType 'Record
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"Bool")
                        ])
                      ])
                      | doc m%"
                      A map of advancements to check.
                      "%
                      | optional,
                    gamemode
                      | std.enum.TagOrString
                      | [| 'spectator, 'creative, 'adventure, 'survival |]
                      | doc m%"
                      The game mode of the player.
                      "%
                      | optional,
                    level
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType 'Integer,
                          predicates.isType 'Record
                        ],
                        definitions.predicate.integerRange
                      ])
                      | doc m%"
                      The level of the player.
                      "%
                      | optional,
                    looking_at
                      | definitions.contract.tagsCommonToAllEntities
                      | doc m%"
                      The entity that the player is looking at, as long as it is visible and within a radius of 100 blocks.
                      "%
                      | optional,
                    recipes
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"Bool")
                      ])
                      | doc m%"
                      A map of recipies to check.
                      "%
                      | optional,
                    stats
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            stat = predicates.isType '"String",
                            type = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum
                                  [
                                    "minecraft:custom",
                                    "minecraft:crafted",
                                    "minecraft:used",
                                    "minecraft:broken",
                                    "minecraft:mined",
                                    "minecraft:killed",
                                    "minecraft:picked_up",
                                    "minecraft:dropped",
                                    "minecraft:killed_by"
                                  ]
                                ],
                            value = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType 'Integer,
                                    predicates.isType 'Record
                                  ],
                                  definitions.predicate.integerRange
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ])
                      ])
                      | doc m%"
                      List of statistics to match.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Player properties to be checked. Fails when entity is not a player.
                  "%
                  | optional,
                stepping_on
                  | definitions.contract.tagsCommonToAllLocations
                  | doc m%"
                  Location predicate for the block the entity is standing on.
                  "%
                  | optional,
                targeted_entity
                  | definitions.contract.tagsCommonToAllEntities
                  | doc m%"
                  The entity which this entity is targeting for attacks.
                  "%
                  | optional,
                team
                  | String
                  | doc m%"
                  The team the entity belongs to.
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  An entity ID.
                  "%
                  | optional,
                vehicle
                  | definitions.contract.tagsCommonToAllEntities
                  | doc m%"
                   The vehicle that the entity is riding on.
                  "%
                  | optional,
                ..
              },
          tagsCommonToAllItems = {
                count
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Record ],
                    definitions.predicate.integerRange
                  ])
                  | doc m%"
                  The amount of the item.
                  "%
                  | optional,
                durability
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Record ],
                    definitions.predicate.integerRange
                  ])
                  | doc m%"
                  The durability of the item.
                  "%
                  | optional,
                enchantments
                  | definitions.contract.enchantments
                  | doc m%"
                  List of enchantments.
                  "%
                  | optional,
                items
                  | Array Dyn
                  | doc m%"
                  List of item IDs.
                  "%
                  | optional,
                nbt
                  | String
                  | doc m%"
                  An NBT string.
                  "%
                  | optional,
                potion
                  | String
                  | doc m%"
                  A brewed potion ID.
                  "%
                  | optional,
                stored_enchantments
                  | definitions.contract.enchantments
                  | doc m%"
                  List of stored enchantments.
                  "%
                  | optional,
                tag
                  | String
                  | doc m%"
                  An item data pack tag.
                  "%
                  | optional,
                ..
              },
          tagsCommonToAllLocations = {
                biome
                  | std.enum.TagOrString
                  | [|
                    'wooded_mountains,
                    'wooded_hills,
                    'wooded_badlands_plateau,
                    'warm_ocean,
                    'the_void,
                    'the_end,
                    'tall_birch_hills,
                    'tall_birch_forest,
                    'taiga_mountains,
                    'taiga_hills,
                    'taiga,
                    'swamp_hills,
                    'swamp,
                    'sunflower_plains,
                    'stone_shore,
                    'snowy_tundra,
                    'snowy_taiga_mountains,
                    'snowy_taiga_hills,
                    'snowy_taiga,
                    'snowy_mountains,
                    'snowy_beach,
                    'small_end_islands,
                    'shattered_savanna_plateau,
                    'shattered_savanna,
                    'savanna_plateau,
                    'savanna,
                    'river,
                    'plains,
                    'ocean,
                    'nether,
                    'mushroom_fields,
                    'mushroom_field_shore,
                    'mountains,
                    'mountain_edge,
                    'modified_wooded_badlands_plateau,
                    'modified_jungle_edge,
                    'modified_jungle,
                    'modified_gravelly_mountains,
                    'modified_badlands_plateau,
                    'lukewarm_ocean,
                    'jungle_hills,
                    'jungle_edge,
                    'jungle,
                    'ice_spikes,
                    'gravelly_mountains,
                    'giant_tree_taiga_hills,
                    'giant_tree_taiga,
                    'giant_spruce_taiga_hills,
                    'giant_spruce_taiga,
                    'frozen_river,
                    'frozen_ocean,
                    'forest,
                    'flower_forest,
                    'eroded_badlands,
                    'end_midlands,
                    'end_highlands,
                    'end_barrens,
                    'desert_lakes,
                    'desert_hills,
                    'desert,
                    'deep_warm_ocean,
                    'deep_ocean,
                    'deep_lukewarm_ocean,
                    'deep_frozen_ocean,
                    'deep_cold_ocean,
                    'dark_forest_hills,
                    'dark_forest,
                    'cold_ocean,
                    'birch_forest_hills,
                    'birch_forest,
                    'beach,
                    'badlands_plateau,
                    'badlands
                  |]
                  | doc m%"
                  The biome the entity is currently in.
                  "%
                  | optional,
                block
                  | {
                    blocks
                      | Array Dyn
                      | doc m%"
                      A list of block IDs.
                      "%
                      | optional,
                    nbt
                      | String
                      | doc m%"
                      The block NBT.
                      "%
                      | optional,
                    state
                      | {
                        key
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Integer,
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            definitions.predicate.integerRange
                          ])
                          | doc m%"
                          Block property key and value pair.
                          "%
                          | optional,
                        ..
                      }
                      | doc m%"
                      A map of block property names to values. Test will fail if the block doesn't match.
                      "%
                      | optional,
                    tag
                      | String
                      | doc m%"
                      The block tag.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  The block at the location.
                  "%
                  | optional,
                dimension
                  | String
                  | doc m%"
                  The dimension the entity is currently in.
                  "%
                  | optional,
                feature
                  | std.enum.TagOrString
                  | [|
                    'village,
                    'swamp_hut,
                    'stronghold,
                    'shipwreck,
                    'pillager_outpost,
                    'ocean_ruin,
                    'monument,
                    'mineshaft,
                    'mansion,
                    'jungle_pyramid,
                    'igloo,
                    'fortress,
                    'endcity,
                    'desert_pyramid,
                    'buried_treasure
                  |]
                  | doc m%"
                  Name of a structure.
                  "%
                  | optional,
                fluid
                  | {
                    fluid
                      | String
                      | doc m%"
                      The fluid ID.
                      "%
                      | optional,
                    state
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType 'Integer,
                          predicates.isType '"String",
                          predicates.isType 'Record
                        ],
                        definitions.predicate.integerRange
                      ])
                      | doc m%"
                      A map of fluid property names to values. Test will fail if the fluid doesn't match.
                      "%
                      | optional,
                    tag
                      | String
                      | doc m%"
                      The fluid tag.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  The fluid at the location.
                  "%
                  | optional,
                light
                  | {
                    light
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType 'Integer,
                          predicates.isType 'Record
                        ],
                        definitions.predicate.integerRange
                      ])
                      | doc m%"
                      The light Level of visible light. Calculated using: (max(sky-darkening,block)).
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  The light at the location.
                  "%
                  | optional,
                position
                  | {
                    x
                      | definitions.contract.numberRange
                      | doc m%"
                      The X position.
                      "%
                      | optional,
                    y
                      | definitions.contract.numberRange
                      | doc m%"
                      The Y position.
                      "%
                      | optional,
                    z
                      | definitions.contract.numberRange
                      | doc m%"
                      The Z position.
                      "%
                      | optional,
                    ..
                  }
                  | optional,
                smokey
                  | Bool
                  | doc m%"
                  True if the block is closely above a campfire or soul campfire.
                  "%
                  | optional,
                ..
              },
        },
    predicate = {
          enchantments = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    enchantment = predicates.isType '"String",
                    levels = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Integer,
                            predicates.isType 'Record
                          ],
                          definitions.predicate.integerRange
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          integerRange = predicates.records.record
              {
                max = predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Integer, predicates.isType 'Record ],
                      definitions.predicate.numberProvider
                    ],
                min = predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Integer, predicates.isType 'Record ],
                      definitions.predicate.numberProvider
                    ],
              }
              {  }
              true
              predicates.always,
          numberProvider = predicates.allOf
              [
                predicates.allOf
                [
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "minecraft:constant", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  { value = predicates.isType '"Number", }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "minecraft:uniform", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    max = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType '"Number",
                            predicates.isType 'Record
                          ],
                          definitions.predicate.numberProvider
                        ],
                    min = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType '"Number",
                            predicates.isType 'Record
                          ],
                          definitions.predicate.numberProvider
                        ],
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "minecraft:binomial", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    n = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Integer,
                            predicates.isType 'Record
                          ],
                          definitions.predicate.numberProvider
                        ],
                    p = definitions.predicate.numberProvider,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "minecraft:score", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    scale = predicates.isType '"Number",
                    score = predicates.isType '"String",
                    target = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType 'Record
                          ],
                          predicates.enum
                          [
                            "this",
                            "killer",
                            "direct_killer",
                            "player_killer"
                          ],
                          predicates.allOf
                          [
                            predicates.ifThenElse
                            (predicates.records.record
                            { type = predicates.const "fixed", }
                            {  }
                            true
                            predicates.always)
                            (predicates.records.record
                            { name = predicates.isType '"String", }
                            {  }
                            true
                            predicates.always)
                            predicates.always,
                            predicates.ifThenElse
                            (predicates.records.record
                            { type = predicates.const "context", }
                            {  }
                            true
                            predicates.always)
                            (predicates.records.record
                            {
                              target = predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.enum
                                    [
                                      "this",
                                      "killer",
                                      "direct_killer",
                                      "player_killer"
                                    ]
                                  ],
                            }
                            {  }
                            true
                            predicates.always)
                            predicates.always
                          ],
                          predicates.records.record
                          {
                            type = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "fixed", "context" ]
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ],
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always
                ],
                predicates.records.record
                {
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "minecraft:constant",
                          "minecraft:uniform",
                          "minecraft:binomial",
                          "minecraft:score"
                        ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          numberRange = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  max = predicates.isType '"Number",
                  min = predicates.isType '"Number",
                }
                {  }
                true
                predicates.always
              ],
          tagsCommonToAllDamageTypes = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bypasses_armor = predicates.isType '"Bool",
                  bypasses_invulnerability = predicates.isType '"Bool",
                  bypasses_magic = predicates.isType '"Bool",
                  direct_entity = predicates.isType 'Record,
                  is_explosion = predicates.isType '"Bool",
                  is_fire = predicates.isType '"Bool",
                  is_lightning = predicates.isType '"Bool",
                  is_magic = predicates.isType '"Bool",
                  is_projectile = predicates.isType '"Bool",
                  source_entity = definitions.predicate.tagsCommonToAllEntities,
                }
                {  }
                true
                predicates.always
              ],
          tagsCommonToAllEntities = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  distance = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          absolute = definitions.predicate.numberRange,
                          horizontal = definitions.predicate.numberRange,
                          x = definitions.predicate.numberRange,
                          y = definitions.predicate.numberRange,
                          z = definitions.predicate.numberRange,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  effects = predicates.records.record {  } {  } true
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          ambient = predicates.isType '"Bool",
                          amplifier = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.isType 'Record
                                ],
                                definitions.predicate.integerRange
                              ],
                          duration = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.isType 'Record
                                ],
                                definitions.predicate.integerRange
                              ],
                          visible = predicates.isType '"Bool",
                        }
                        {  }
                        true
                        predicates.always
                      ]),
                  equipment = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          chest = definitions.predicate.tagsCommonToAllItems,
                          feet = definitions.predicate.tagsCommonToAllItems,
                          head = definitions.predicate.tagsCommonToAllItems,
                          legs = definitions.predicate.tagsCommonToAllItems,
                          mainhand = definitions.predicate.tagsCommonToAllItems,
                          offhand = definitions.predicate.tagsCommonToAllItems,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  flags = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          is_baby = predicates.isType '"Bool",
                          is_on_fire = predicates.always,
                          is_sneaking = predicates.isType '"Bool",
                          is_sprinting = predicates.isType '"Bool",
                          is_swimming = predicates.isType '"Bool",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  lightning_bolt = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          blocks_set_on_fire = predicates.isType 'Integer,
                          entity_struck =
                            definitions.predicate.tagsCommonToAllEntities,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  location = definitions.predicate.tagsCommonToAllLocations,
                  nbt = predicates.isType '"String",
                  passenger = definitions.predicate.tagsCommonToAllEntities,
                  player = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          advancements = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  } {  } true
                                (predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType '"Bool",
                                    predicates.isType 'Record
                                  ],
                                  predicates.records.record {  } {  } true
                                  (predicates.isType '"Bool")
                                ])
                              ],
                          gamemode = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "survival",
                                  "adventure",
                                  "creative",
                                  "spectator"
                                ]
                              ],
                          level = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.isType 'Record
                                ],
                                definitions.predicate.integerRange
                              ],
                          looking_at =
                            definitions.predicate.tagsCommonToAllEntities,
                          recipes = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  } {  } true
                                (predicates.isType '"Bool")
                              ],
                          stats = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  } {  } true
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    stat = predicates.isType '"String",
                                    type = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "minecraft:custom",
                                            "minecraft:crafted",
                                            "minecraft:used",
                                            "minecraft:broken",
                                            "minecraft:mined",
                                            "minecraft:killed",
                                            "minecraft:picked_up",
                                            "minecraft:dropped",
                                            "minecraft:killed_by"
                                          ]
                                        ],
                                    value = predicates.allOf
                                        [
                                          predicates.anyOf
                                          [
                                            predicates.isType 'Integer,
                                            predicates.isType 'Record
                                          ],
                                          definitions.predicate.integerRange
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
                  stepping_on = definitions.predicate.tagsCommonToAllLocations,
                  targeted_entity =
                    definitions.predicate.tagsCommonToAllEntities,
                  team = predicates.isType '"String",
                  type = predicates.isType '"String",
                  vehicle = definitions.predicate.tagsCommonToAllEntities,
                }
                {  }
                true
                predicates.always
              ],
          tagsCommonToAllItems = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  count = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType 'Integer,
                          predicates.isType 'Record
                        ],
                        definitions.predicate.integerRange
                      ],
                  durability = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType 'Integer,
                          predicates.isType 'Record
                        ],
                        definitions.predicate.integerRange
                      ],
                  enchantments = definitions.predicate.enchantments,
                  items = predicates.isType '"Array",
                  nbt = predicates.isType '"String",
                  potion = predicates.isType '"String",
                  stored_enchantments = definitions.predicate.enchantments,
                  tag = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          tagsCommonToAllLocations = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  biome = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "badlands",
                          "badlands_plateau",
                          "beach",
                          "birch_forest",
                          "birch_forest_hills",
                          "cold_ocean",
                          "dark_forest",
                          "dark_forest_hills",
                          "deep_cold_ocean",
                          "deep_frozen_ocean",
                          "deep_lukewarm_ocean",
                          "deep_ocean",
                          "deep_warm_ocean",
                          "desert",
                          "desert_hills",
                          "desert_lakes",
                          "end_barrens",
                          "end_highlands",
                          "end_midlands",
                          "eroded_badlands",
                          "flower_forest",
                          "forest",
                          "frozen_ocean",
                          "frozen_river",
                          "giant_spruce_taiga",
                          "giant_spruce_taiga_hills",
                          "giant_tree_taiga",
                          "giant_tree_taiga_hills",
                          "gravelly_mountains",
                          "ice_spikes",
                          "jungle",
                          "jungle_edge",
                          "jungle_hills",
                          "lukewarm_ocean",
                          "modified_badlands_plateau",
                          "modified_gravelly_mountains",
                          "modified_jungle",
                          "modified_jungle_edge",
                          "modified_wooded_badlands_plateau",
                          "mountain_edge",
                          "mountains",
                          "mushroom_field_shore",
                          "mushroom_fields",
                          "nether",
                          "ocean",
                          "plains",
                          "river",
                          "savanna",
                          "savanna_plateau",
                          "shattered_savanna",
                          "shattered_savanna_plateau",
                          "small_end_islands",
                          "snowy_beach",
                          "snowy_mountains",
                          "snowy_taiga",
                          "snowy_taiga_hills",
                          "snowy_taiga_mountains",
                          "snowy_tundra",
                          "stone_shore",
                          "sunflower_plains",
                          "swamp",
                          "swamp_hills",
                          "taiga",
                          "taiga_hills",
                          "taiga_mountains",
                          "tall_birch_forest",
                          "tall_birch_hills",
                          "the_end",
                          "the_void",
                          "warm_ocean",
                          "wooded_badlands_plateau",
                          "wooded_hills",
                          "wooded_mountains"
                        ]
                      ],
                  block = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          blocks = predicates.isType '"Array",
                          nbt = predicates.isType '"String",
                          state = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  key = predicates.allOf
                                      [
                                        predicates.anyOf
                                        [
                                          predicates.isType '"Bool",
                                          predicates.isType 'Integer,
                                          predicates.isType '"String",
                                          predicates.isType 'Record
                                        ],
                                        definitions.predicate.integerRange
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          tag = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  dimension = predicates.isType '"String",
                  feature = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "buried_treasure",
                          "desert_pyramid",
                          "endcity",
                          "fortress",
                          "igloo",
                          "jungle_pyramid",
                          "mansion",
                          "mineshaft",
                          "monument",
                          "ocean_ruin",
                          "pillager_outpost",
                          "shipwreck",
                          "stronghold",
                          "swamp_hut",
                          "village"
                        ]
                      ],
                  fluid = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          fluid = predicates.isType '"String",
                          state = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType '"Bool",
                                  predicates.isType 'Integer,
                                  predicates.isType '"String",
                                  predicates.isType 'Record
                                ],
                                definitions.predicate.integerRange
                              ],
                          tag = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  light = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          light = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.isType 'Record
                                ],
                                definitions.predicate.integerRange
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  position = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          x = definitions.predicate.numberRange,
                          y = definitions.predicate.numberRange,
                          z = definitions.predicate.numberRange,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  smokey = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.allOf
  [
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:alternative", }
    {  }
    true
    predicates.always)
    (predicates.records.record { terms = predicates.isType 'Record, } {  } true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:block_state_property", }
    {  }
    true
    predicates.always)
    (predicates.records.record
    {
      block = predicates.isType '"String",
      properties = predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record {  } {  } true
            (predicates.isType '"String")
          ],
    }
    {  }
    true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:damage_source_properties", }
    {  }
    true
    predicates.always)
    (predicates.records.record
    { predicate = definitions.predicate.tagsCommonToAllDamageTypes, }
    {  }
    true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:entity_properties", }
    {  }
    true
    predicates.always)
    (predicates.records.record
    {
      entity = predicates.allOf
          [
            predicates.isType '"String",
            predicates.enum [ "this", "killer", "killer_player" ]
          ],
      predicate = definitions.predicate.tagsCommonToAllEntities,
    }
    {  }
    true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:entity_scores", }
    {  }
    true
    predicates.always)
    (predicates.records.record
    {
      entity = predicates.allOf
          [
            predicates.isType '"String",
            predicates.enum [ "this", "killer", "killer_player" ]
          ],
      scores = predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record {  } {  } true
            (predicates.allOf
            [
              predicates.anyOf
              [ predicates.isType 'Integer, predicates.isType 'Record ],
              definitions.predicate.integerRange
            ])
          ],
    }
    {  }
    true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:inverted", }
    {  }
    true
    predicates.always)
    (predicates.records.record { term = predicates.isType 'Record, } {  } true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:killed_by_player", }
    {  }
    true
    predicates.always)
    (predicates.records.record { inverse = predicates.isType '"Bool", } {  }
    true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:location_check", }
    {  }
    true
    predicates.always)
    (predicates.records.record
    {
      offsetX = predicates.isType 'Integer,
      offsetY = predicates.isType 'Integer,
      offsetZ = predicates.isType 'Integer,
      predicate = definitions.predicate.tagsCommonToAllLocations,
    }
    {  }
    true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:match_tool", }
    {  }
    true
    predicates.always)
    (predicates.records.record
    { predicate = definitions.predicate.tagsCommonToAllItems, }
    {  }
    true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:random_chance", }
    {  }
    true
    predicates.always)
    (predicates.records.record
    {
      chance = predicates.allOf
          [
            predicates.isType '"Number",
            predicates.numbers.maximum 1,
            predicates.numbers.minimum 0
          ],
    }
    {  }
    true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:random_chance_with_looting", }
    {  }
    true
    predicates.always)
    (predicates.records.record
    {
      chance = predicates.isType '"Number",
      looting_multiplier = predicates.isType '"Number",
    }
    {  }
    true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:reference", }
    {  }
    true
    predicates.always)
    (predicates.records.record { name = predicates.isType '"String", } {  } true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:survives_explosion", }
    {  }
    true
    predicates.always)
    predicates.always
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:table_bonus", }
    {  }
    true
    predicates.always)
    (predicates.records.record
    {
      chances = predicates.isType '"Array",
      enchantment = predicates.isType 'Integer,
    }
    {  }
    true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:time_check", }
    {  }
    true
    predicates.always)
    (predicates.records.record
    {
      period = predicates.isType 'Integer,
      value = predicates.allOf
          [
            predicates.anyOf
            [ predicates.isType 'Integer, predicates.isType 'Record ],
            definitions.predicate.integerRange
          ],
    }
    {  }
    true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:weather_check", }
    {  }
    true
    predicates.always)
    (predicates.records.record
    {
      raining = predicates.isType '"Bool",
      thundering = predicates.isType '"Bool",
    }
    {  }
    true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { conditions = predicates.const "minecraft:value_check", }
    {  }
    true
    predicates.always)
    (predicates.records.record
    {
      range = predicates.allOf
          [
            predicates.anyOf
            [ predicates.isType 'Integer, predicates.isType 'Record ],
            definitions.predicate.integerRange
          ],
      value = predicates.allOf
          [
            predicates.anyOf
            [ predicates.isType 'Integer, predicates.isType 'Record ],
            definitions.predicate.numberProvider
          ],
    }
    {  }
    true
    predicates.always)
    predicates.always
  ],
  predicates.records.record
  {
    conditions = predicates.allOf
        [
          predicates.isType '"String",
          predicates.enum
          [
            "minecraft:alternative",
            "minecraft:block_state_property",
            "minecraft:damage_source_properties",
            "minecraft:entity_properties",
            "minecraft:entity_scores",
            "minecraft:inverted",
            "minecraft:killed_by_player",
            "minecraft:location_check",
            "minecraft:match_tool",
            "minecraft:random_chance",
            "minecraft:random_chance_with_looting",
            "minecraft:reference",
            "minecraft:survives_explosion",
            "minecraft:table_bonus",
            "minecraft:time_check",
            "minecraft:weather_check",
            "minecraft:value_check"
          ]
        ],
  }
  {  }
  true
  predicates.always
])