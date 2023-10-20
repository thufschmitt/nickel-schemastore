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
          CharFilter = predicates.contract_from_predicate
              definitions.predicate.CharFilter,
          CustomAnalyzer = {
                charFilters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.CharFilter
                  ])
                  | doc m%"
                  Array containing zero or more character filters.
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^(?!^lucene\\.|builtin\\.|mongodb\\.).*"
                  ])
                  | doc m%"
                  Name of the custom analyzer.
                  Names must be unique within an index, and may not start with any of the following strings:
                  - lucene.
                  - builtin.
                  - mongodb.
                  "%,
                tokenFilters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.TokenFilter
                  ])
                  | doc m%"
                  Array containing zero or more token filters.
                  "%
                  | optional,
                tokenizer | definitions.contract.Tokenizer,
              },
          Mappings
            | doc m%"
            Specifies how to index fields at different paths for this index.
            "%
            = predicates.contract_from_predicate definitions.predicate.Mappings,
          MappingsField = predicates.contract_from_predicate
              definitions.predicate.MappingsField,
          StoredSource = predicates.contract_from_predicate
              definitions.predicate.StoredSource,
          Synonym = {
                analyzer
                  | std.enum.TagOrString
                  | [|
                    'shingle,
                    'daitchMokotoffSoundex,
                    'edgeGram,
                    'nGram,
                    '"lucene.ukrainian",
                    '"lucene.turkish",
                    '"lucene.thai",
                    '"lucene.swedish",
                    '"lucene.spanish",
                    '"lucene.sorani",
                    '"lucene.smartcn",
                    '"lucene.russian",
                    '"lucene.romanian",
                    '"lucene.portuguese",
                    '"lucene.persian",
                    '"lucene.norwegian",
                    '"lucene.nori",
                    '"lucene.morfologik",
                    '"lucene.lithuanian",
                    '"lucene.latvian",
                    '"lucene.korean",
                    '"lucene.japanese",
                    '"lucene.italian",
                    '"lucene.irish",
                    '"lucene.indonesian",
                    '"lucene.hungarian",
                    '"lucene.hindi",
                    '"lucene.greek",
                    '"lucene.german",
                    '"lucene.galician",
                    '"lucene.french",
                    '"lucene.finnish",
                    '"lucene.english",
                    '"lucene.dutch",
                    '"lucene.danish",
                    '"lucene.czech",
                    '"lucene.cjk",
                    '"lucene.chinese",
                    '"lucene.catalan",
                    '"lucene.bulgarian",
                    '"lucene.brazilian",
                    '"lucene.bengali",
                    '"lucene.basque",
                    '"lucene.armenian",
                    '"lucene.arabic",
                    '"lucene.keyword",
                    '"lucene.whitespace",
                    '"lucene.simple",
                    '"lucene.standard"
                  |]
                  | optional,
                name | String | optional,
                source | { collection | String | optional, .. } | optional,
              },
          TokenFilter = {
                type
                  | std.enum.TagOrString
                  | [|
                    'trim,
                    'stopword,
                    'snowballStemming,
                    'shingle,
                    'reverse,
                    'regex,
                    'nGram,
                    'lowercase,
                    'length,
                    'icuNormalizer,
                    'icuFolding,
                    'edgeGram,
                    'daitchMokotoffSoundex,
                    'asciiFolding
                  |]
                  | doc m%"
                  Human-readable label that identifies this token filter type.
                  "%,
              },
          Tokenizer
            | doc m%"
            Tokenizer to use to create tokens.
            "%
            = {
                type
                  | std.enum.TagOrString
                  | [|
                    'whitespace,
                    'uaxUrlEmail,
                    'standard,
                    'regexSplit,
                    'regexCaptureGroup,
                    'nGram,
                    'keyword,
                    'edgeGram
                  |],
              },
        },
    predicate = {
          CharFilter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.ifThenElse
                (predicates.records.record
                { type = predicates.const "mapping", }
                {  }
                true
                predicates.always)
                (predicates.allOf
                [
                  predicates.records.required [ "mappings" ],
                  predicates.records.record
                  { mappings = predicates.isType 'Record, }
                  {  }
                  true
                  predicates.always
                ])
                predicates.always,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  ignoredTags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "htmlStrip", "icuNormalize", "mapping", "persian" ]
                      ],
                }
                {  }
                false
                predicates.never,
                predicates.records.dependencies
                {
                  ignoredTags = predicates.records.record
                      { type = predicates.enum [ "htmlStrip" ], }
                      {  }
                      true
                      predicates.always,
                }
              ],
          CustomAnalyzer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "tokenizer" ],
                predicates.records.record
                {
                  charFilters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.CharFilter
                      ],
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?!^lucene\\.|builtin\\.|mongodb\\.).*"
                      ],
                  tokenFilters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.TokenFilter
                      ],
                  tokenizer = definitions.predicate.Tokenizer,
                }
                {  }
                false
                predicates.never
              ],
          Mappings
            | doc m%"
            Specifies how to index fields at different paths for this index.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.records.record { dynamic = predicates.const true, }
                  {  }
                  false
                  predicates.never,
                  predicates.allOf
                  [
                    predicates.records.required [ "fields" ],
                    predicates.records.record
                    {
                      dynamic = predicates.isType '"Bool",
                      fields = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record {  }
                            {
                              "^.*$" = predicates.oneOf
                                  [
                                    definitions.predicate.MappingsField,
                                    predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      definitions.predicate.MappingsField
                                    ]
                                  ],
                            }
                            true
                            predicates.always
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ]
              ],
          MappingsField = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  analyzer = predicates.isType '"String",
                  dynamic = predicates.isType '"Bool",
                  fields = predicates.isType 'Record,
                  foldDiacritics = predicates.isType '"Bool",
                  ignoreAbove = predicates.isType 'Integer,
                  indexDoubles = predicates.isType '"Bool",
                  indexIntegers = predicates.isType '"Bool",
                  indexOptions = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "docs", "freqs", "positions", "offsets" ]
                      ],
                  indexShapes = predicates.isType '"Bool",
                  maxGrams = predicates.isType 'Integer,
                  minGrams = predicates.isType 'Integer,
                  multi = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          analyzer = predicates.isType '"String",
                          type = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "string" ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  norms = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "include", "omit" ]
                      ],
                  representation = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "int64", "double" ]
                      ],
                  searchAnalyzer = predicates.isType '"String",
                  store = predicates.isType '"Bool",
                  tokenization = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "edgeGram", "rightEdgeGram", "nGram" ]
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "autocomplete",
                          "boolean",
                          "date",
                          "dateFacet",
                          "document",
                          "embeddedDocuments",
                          "geo",
                          "number",
                          "numberFacet",
                          "objectId",
                          "string",
                          "stringFacet"
                        ]
                      ],
                }
                {  }
                false
                predicates.never,
                predicates.records.dependencies
                {
                  analyzer = predicates.records.record
                      { type = predicates.enum [ "autocomplete", "string" ], }
                      {  }
                      true
                      predicates.always,
                  dynamic = predicates.records.record
                      {
                        type = predicates.enum
                            [ "document", "embeddedDocuments" ],
                      }
                      {  }
                      true
                      predicates.always,
                  fields = predicates.records.record
                      {
                        type = predicates.enum
                            [ "document", "embeddedDocuments" ],
                      }
                      {  }
                      true
                      predicates.always,
                  foldDiacritics = predicates.records.record
                      { type = predicates.enum [ "autocomplete" ], }
                      {  }
                      true
                      predicates.always,
                  ignoreAbove = predicates.records.record
                      { type = predicates.enum [ "string" ], }
                      {  }
                      true
                      predicates.always,
                  indexDoubles = predicates.records.record
                      { type = predicates.enum [ "number", "numberFacet" ], }
                      {  }
                      true
                      predicates.always,
                  indexIntegers = predicates.records.record
                      { type = predicates.enum [ "number", "numberFacet" ], }
                      {  }
                      true
                      predicates.always,
                  indexOptions = predicates.records.record
                      { type = predicates.enum [ "string" ], }
                      {  }
                      true
                      predicates.always,
                  indexShapes = predicates.records.record
                      { type = predicates.enum [ "geo" ], }
                      {  }
                      true
                      predicates.always,
                  maxGrams = predicates.records.record
                      { type = predicates.enum [ "autocomplete" ], }
                      {  }
                      true
                      predicates.always,
                  minGrams = predicates.records.record
                      { type = predicates.enum [ "autocomplete" ], }
                      {  }
                      true
                      predicates.always,
                  multi = predicates.records.record
                      { type = predicates.enum [ "string" ], }
                      {  }
                      true
                      predicates.always,
                  norms = predicates.records.record
                      { type = predicates.enum [ "string" ], }
                      {  }
                      true
                      predicates.always,
                  representation = predicates.records.record
                      { type = predicates.enum [ "number", "numberFacet" ], }
                      {  }
                      true
                      predicates.always,
                  searchAnalyzer = predicates.records.record
                      { type = predicates.enum [ "string" ], }
                      {  }
                      true
                      predicates.always,
                  store = predicates.records.record
                      { type = predicates.enum [ "string" ], }
                      {  }
                      true
                      predicates.always,
                  tokenization = predicates.records.record
                      { type = predicates.enum [ "autocomplete" ], }
                      {  }
                      true
                      predicates.always,
                }
              ],
          StoredSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "include" ],
                    predicates.records.record
                    {
                      exclude = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                      include = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "exclude" ],
                    predicates.records.record
                    {
                      exclude = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                      include = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ]
              ],
          Synonym = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  analyzer = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "lucene.standard",
                          "lucene.simple",
                          "lucene.whitespace",
                          "lucene.keyword",
                          "lucene.arabic",
                          "lucene.armenian",
                          "lucene.basque",
                          "lucene.bengali",
                          "lucene.brazilian",
                          "lucene.bulgarian",
                          "lucene.catalan",
                          "lucene.chinese",
                          "lucene.cjk",
                          "lucene.czech",
                          "lucene.danish",
                          "lucene.dutch",
                          "lucene.english",
                          "lucene.finnish",
                          "lucene.french",
                          "lucene.galician",
                          "lucene.german",
                          "lucene.greek",
                          "lucene.hindi",
                          "lucene.hungarian",
                          "lucene.indonesian",
                          "lucene.irish",
                          "lucene.italian",
                          "lucene.japanese",
                          "lucene.korean",
                          "lucene.latvian",
                          "lucene.lithuanian",
                          "lucene.morfologik",
                          "lucene.nori",
                          "lucene.norwegian",
                          "lucene.persian",
                          "lucene.portuguese",
                          "lucene.romanian",
                          "lucene.russian",
                          "lucene.smartcn",
                          "lucene.sorani",
                          "lucene.spanish",
                          "lucene.swedish",
                          "lucene.thai",
                          "lucene.turkish",
                          "lucene.ukrainian",
                          "nGram",
                          "edgeGram",
                          "daitchMokotoffSoundex",
                          "shingle"
                        ]
                      ],
                  name = predicates.isType '"String",
                  source = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { collection = predicates.isType '"String", }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          TokenFilter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "asciiFolding",
                          "daitchMokotoffSoundex",
                          "edgeGram",
                          "icuFolding",
                          "icuNormalizer",
                          "length",
                          "lowercase",
                          "nGram",
                          "regex",
                          "reverse",
                          "shingle",
                          "snowballStemming",
                          "stopword",
                          "trim"
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Tokenizer
            | doc m%"
            Tokenizer to use to create tokens.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "edgeGram",
                          "keyword",
                          "nGram",
                          "regexCaptureGroup",
                          "regexSplit",
                          "standard",
                          "uaxUrlEmail",
                          "whitespace"
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

{
  analyzer
    | String
    | doc m%"
    Specifies the analyzer to apply to string fields when indexing.
    If you set this only at the top and do not specify an analyzer for the fields in the index definition, Atlas Search applies this analyzer to all the fields.
    To use a different analyzer for each field, you must specify a different analyzer for the field.
    If omitted, defaults to Standard Analyzer.
    "%
    | optional,
  analyzers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.CustomAnalyzer
    ])
    | doc m%"
    Specifies the Custom Analyzers to use in this index.
    "%
    | optional,
  mappings | definitions.contract.Mappings,
  name
    | String
    | doc m%"
    Specifies a name for the index. In each namespace, names of all indexes in the namespace must be unique.
    If omitted, defaults to default.
    "%
    | optional,
  searchAnalyzer
    | String
    | doc m%"
    Specifies the analyzer to apply to query text before searching with it.
    If omitted, defaults to Standard Analyzer.
    "%
    | optional,
  storedSource
    | predicates.contract_from_predicate
    (predicates.oneOf
    [ predicates.isType '"Bool", definitions.predicate.StoredSource ])
    | doc m%"
    Specifies fields in the documents to store for query-time look-ups using the returnedStoredSource option.
    You can store fields of all BSON Data Types on Atlas Search.
    
    Value can be one of the following:
    true, to store all fields
    false, to not store any fields
    Object that specifies the fields to include or exclude from storage
    
    If omitted, defaults to false.
    "%
    | optional,
  synonyms
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.Synonym
    ])
    | doc m%"
    Synonym mappings to use in your index.
    "%
    | optional,
}