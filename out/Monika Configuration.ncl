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
          alerts
            | doc m%"
            The condition which will trigger an alert and the subsequent notification
            "%
            = predicates.contract_from_predicate definitions.predicate.alerts,
          body
            | doc m%"
            The data bytes transmitted in an HTTP transaction message immediately following the headers if there are any
            "%
            = predicates.contract_from_predicate definitions.predicate.body,
          headers
            | doc m%"
            A list of strings sent and received by both the client program and server on every HTTP request and response
            "%
            = {
                Accept
                  | String
                  | doc m%"
                  Media type(s) that is/are acceptable for the response
                  "%
                  | optional,
                Accept-Charset
                  | String
                  | doc m%"
                  Character sets that are acceptable
                  "%
                  | optional,
                Accept-Encoding
                  | String
                  | doc m%"
                  List of acceptable encodings
                  "%
                  | optional,
                Authorization
                  | String
                  | doc m%"
                  Authentication credentials for HTTP authentication
                  "%
                  | optional,
                Cache-Control
                  | String
                  | doc m%"
                  Used to specify directives that must be obeyed by all caching mechanisms along the request-response chain
                  "%
                  | optional,
                Connection
                  | String
                  | doc m%"
                  General header that allows the sender or client to specify options that are desired for that particular connection
                  "%
                  | optional,
                Content-Type
                  | String
                  | doc m%"
                  The Media type of the body of the request (used with POST and PUT requests
                  "%
                  | optional,
                Cookie
                  | String
                  | doc m%"
                  An HTTP cookie previously sent by the server with Set-Cookie
                  "%
                  | optional,
                Keep-Alive
                  | String
                  | doc m%"
                  General header used to inform how long a persistent connection should stay open
                  "%
                  | optional,
                Origin
                  | String
                  | doc m%"
                  Initiates a request for cross-origin resource sharing (asks server for Access-Control-* response fields)
                  "%
                  | optional,
                Referer
                  | String
                  | doc m%"
                  This is the address of the previous web page (referrer) from which a link to the currently requested page was followed
                  "%
                  | optional,
                User-Agent
                  | String
                  | doc m%"
                  The user agent string of the user agent
                  "%
                  | optional,
                ..
              },
          incidentThreshold
            | doc m%"
            Number of times an alert should return true before Monika sends incident notifications
            "%
            = std.number.Integer,
          interval
            | doc m%"
            The number of seconds to repeat the probe
            "%
            = std.number.Integer,
          mariadb
            | doc m%"
            Monitor MariaDB/Mysql health
            "%
            = predicates.contract_from_predicate definitions.predicate.mariadb,
          mongo
            | doc m%"
            Monitor MongoDB health 
            "%
            = predicates.contract_from_predicate definitions.predicate.mongo,
          ping
            | doc m%"
            The ICMP ping probe
            "%
            = predicates.contract_from_predicate definitions.predicate.ping,
          postgres
            | doc m%"
            Monitor postgres readiness
            "%
            = predicates.contract_from_predicate definitions.predicate.postgres,
          recoveryThreshold
            | doc m%"
            Number of times an alert should return false before Monika sends recovery notifications
            "%
            = std.number.Integer,
          redis
            | doc m%"
            Monitor redis health 
            "%
            = predicates.contract_from_predicate definitions.predicate.redis,
          requests
            | doc m%"
            The http or ping request to probe for
            "%
            = predicates.contract_from_predicate definitions.predicate.requests,
          socket
            | doc m%"
            Socket is a TCP type request
            "%
            = {
                data
                  | String
                  | doc m%"
                  Data payload for the request
                  "%,
                host
                  | String
                  | doc m%"
                  Address to your host
                  "%,
                port
                  | std.number.Integer
                  | doc m%"
                  Host port to connect to
                  "%,
              },
          urlFormat = predicates.contract_from_predicate
              definitions.predicate.urlFormat,
        },
    predicate = {
          alerts
            | doc m%"
            The condition which will trigger an alert and the subsequent notification
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.records.required [ "assertion", "message" ],
                      predicates.records.record
                      {
                        assertion = predicates.isType '"String",
                        message = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ],
                    predicates.allOf
                    [
                      predicates.records.required [ "message", "query" ],
                      predicates.records.record
                      {
                        message = predicates.isType '"String",
                        query = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ]
                  ]
                ])
              ],
          body
            | doc m%"
            The data bytes transmitted in an HTTP transaction message immediately following the headers if there are any
            "%
            = predicates.always,
          headers
            | doc m%"
            A list of strings sent and received by both the client program and server on every HTTP request and response
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  Accept = predicates.isType '"String",
                  Accept-Charset = predicates.isType '"String",
                  Accept-Encoding = predicates.isType '"String",
                  Authorization = predicates.isType '"String",
                  Cache-Control = predicates.isType '"String",
                  Connection = predicates.isType '"String",
                  Content-Type = predicates.isType '"String",
                  Cookie = predicates.isType '"String",
                  Keep-Alive = predicates.isType '"String",
                  Origin = predicates.isType '"String",
                  Referer = predicates.isType '"String",
                  User-Agent = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          incidentThreshold
            | doc m%"
            Number of times an alert should return true before Monika sends incident notifications
            "%
            = predicates.isType 'Integer,
          interval
            | doc m%"
            The number of seconds to repeat the probe
            "%
            = predicates.isType 'Integer,
          mariadb
            | doc m%"
            Monitor MariaDB/Mysql health
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "database", "host", "password", "port", "username" ],
                  predicates.records.record
                  {
                    database = predicates.always,
                    host = predicates.isType '"String",
                    password = predicates.isType '"String",
                    port = predicates.isType 'Integer,
                    username = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          mongo
            | doc m%"
            Monitor MongoDB health 
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
                    host = predicates.isType '"String",
                    password = predicates.isType '"String",
                    port = predicates.isType 'Integer,
                    uri = predicates.isType '"String",
                    username = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          ping
            | doc m%"
            The ICMP ping probe
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "uri" ],
                  predicates.records.record
                  { uri = predicates.isType '"String", }
                  {  }
                  false
                  predicates.never
                ])
              ],
          postgres
            | doc m%"
            Monitor postgres readiness
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.records.required [ "uri" ],
                      predicates.records.record
                      { uri = predicates.isType '"String", }
                      {  }
                      false
                      predicates.never
                    ],
                    predicates.allOf
                    [
                      predicates.records.required
                      [ "database", "host", "port" ],
                      predicates.records.record
                      {
                        database = predicates.isType '"String",
                        host = predicates.isType '"String",
                        password = predicates.isType '"String",
                        port = predicates.isType 'Integer,
                        username = predicates.isType '"String",
                      }
                      {  }
                      true
                      predicates.always
                    ]
                  ]
                ])
              ],
          recoveryThreshold
            | doc m%"
            Number of times an alert should return false before Monika sends recovery notifications
            "%
            = predicates.isType 'Integer,
          redis
            | doc m%"
            Monitor redis health 
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.records.required [ "uri" ],
                      predicates.records.record
                      { uri = predicates.isType '"String", }
                      {  }
                      true
                      predicates.always
                    ],
                    predicates.allOf
                    [
                      predicates.records.required [ "host", "port" ],
                      predicates.records.record
                      {
                        host = predicates.isType '"String",
                        password = predicates.isType '"String",
                        port = predicates.isType 'Integer,
                        username = predicates.isType '"String",
                      }
                      {  }
                      true
                      predicates.always
                    ]
                  ]
                ])
              ],
          requests
            | doc m%"
            The http or ping request to probe for
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "url" ],
                  predicates.records.record
                  {
                    alerts = definitions.predicate.alerts,
                    allowUnauthorized = predicates.isType '"Bool",
                    body = definitions.predicate.body,
                    headers = definitions.predicate.headers,
                    method = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "GET", "POST", "DELETE", "PUT", "PATCH" ]
                        ],
                    ping = predicates.isType '"Bool",
                    saveBody = predicates.isType '"Bool",
                    timeout = predicates.isType 'Integer,
                    url = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          socket
            | doc m%"
            Socket is a TCP type request
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "data", "host", "port" ],
                predicates.records.record
                {
                  data = predicates.isType '"String",
                  host = predicates.isType '"String",
                  port = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          urlFormat = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^https?://"
              ],
        },
  }
in

{
  certificate
    | {
      domains
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.anyOf
          [
            predicates.isType '"String",
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.required [ "domain" ],
              predicates.records.record
              {
                domain = predicates.isType '"String",
                options = predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      { path = predicates.isType '"String", }
                      {  }
                      true
                      predicates.always
                    ],
              }
              {  }
              false
              predicates.never
            ]
          ])
        ])
        | doc m%"
        The list of domains to check
        "%,
      reminder
        | std.number.Integer
        | doc m%"
        The number of days to send notification to user before the domain expires
        "%
        | optional,
    }
    | doc m%"
    Check validity of your TLS certificate(s).
    "%
    | optional,
  db_limit
    | {
      cron_schedule
        | String
        | doc m%"
        Schedule to trim the db in crontab
        "%,
      deleted_data
        | std.number.Integer
        | doc m%"
        Delete strategy when limit reached
        "%,
      max_db_size
        | Number
        | doc m%"
        Maximum Monika database size
        "%,
    }
    | doc m%"
    Database internal configuration
    "%
    | optional,
  notifications
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.anyOf
      [
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "id", "type" ],
          predicates.records.record
          {
            id = predicates.isType '"String",
            type = predicates.const "desktop",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "url" ],
                  predicates.records.record
                  { url = definitions.predicate.urlFormat, }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "discord",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "access_token", "thread_id" ],
                  predicates.records.record
                  {
                    access_token = predicates.isType '"String",
                    thread_id = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "workplace",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "url" ],
                  predicates.records.record
                  { url = definitions.predicate.urlFormat, }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "google-chat",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "url" ],
                  predicates.records.record
                  { url = definitions.predicate.urlFormat, }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "lark",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "apiKey", "domain", "recipients" ],
                  predicates.records.record
                  {
                    apiKey = predicates.isType '"String",
                    domain = predicates.isType '"String",
                    recipients = predicates.allOf
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
            id = predicates.isType '"String",
            type = predicates.const "mailgun",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "url" ],
                  predicates.records.record
                  { url = definitions.predicate.urlFormat, }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "teams",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "url" ],
                  predicates.records.record
                  { url = definitions.predicate.urlFormat, }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "monika-notif",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "key", "probeID" ],
                    predicates.records.record
                    {
                      key = predicates.isType '"String",
                      probeID = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
            id = predicates.isType '"String",
            type = predicates.const "pagerduty",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "apiKey", "recipients", "sender" ],
                  predicates.records.record
                  {
                    apiKey = predicates.isType '"String",
                    recipients = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    sender = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "sendgrid",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "url" ],
                  predicates.records.record
                  { url = definitions.predicate.urlFormat, }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "slack",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "hostname", "port", "recipients" ],
                  predicates.records.record
                  {
                    hostname = predicates.isType '"String",
                    password = predicates.isType '"String",
                    port = predicates.isType 'Integer,
                    recipients = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    username = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always
                ],
            id = predicates.isType '"String",
            type = predicates.const "smtp",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "apiKey", "pageID" ],
                  predicates.records.record
                  {
                    apiKey = predicates.isType '"String",
                    pageID = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "statuspage",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "bot_token", "group_id" ],
                  predicates.records.record
                  {
                    bot_token = predicates.isType '"String",
                    group_id = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "telegram",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "url" ],
                  predicates.records.record
                  { url = definitions.predicate.urlFormat, }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "webhook",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "password", "recipients", "url", "username" ],
                  predicates.records.record
                  {
                    password = predicates.isType '"String",
                    recipients = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    url = definitions.predicate.urlFormat,
                    username = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "whatsapp",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "access_token" ],
                  predicates.records.record
                  { access_token = predicates.isType '"String", }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "dingtalk",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "token", "user" ],
                  predicates.records.record
                  {
                    token = predicates.isType '"String",
                    user = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "pushover",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "token", "url" ],
                  predicates.records.record
                  {
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "gotify",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "geniekey" ],
                  predicates.records.record
                  { geniekey = predicates.isType '"String", }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "opsgenie",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "token" ],
                  predicates.records.record
                  {
                    deviceID = predicates.isType '"String",
                    token = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "pushbullet",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "data", "id", "type" ],
          predicates.records.record
          {
            data = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "apiKey", "pageID" ],
                  predicates.records.record
                  {
                    apiKey = predicates.isType '"String",
                    pageID = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            id = predicates.isType '"String",
            type = predicates.const "instatus",
          }
          {  }
          false
          predicates.never
        ]
      ])
    ])
    | doc m%"
    Alerts of incidents and recoveries will be sent via these notification channels
    "%
    | optional,
  probes
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "id" ],
        predicates.records.record
        {
          alerts = definitions.predicate.alerts,
          description = predicates.isType '"String",
          id = predicates.isType '"String",
          incidentThreshold = definitions.predicate.incidentThreshold,
          interval = definitions.predicate.interval,
          mariadb = definitions.predicate.mariadb,
          mongo = definitions.predicate.mongo,
          mysql = definitions.predicate.mariadb,
          name = predicates.isType '"String",
          ping = definitions.predicate.ping,
          postgres = definitions.predicate.postgres,
          recoveryThreshold = definitions.predicate.recoveryThreshold,
          redis = definitions.predicate.redis,
          requests = definitions.predicate.requests,
          socket = definitions.predicate.socket,
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Probe is a description of the target, methods, timing and payloads to begin monitoring/probing a target.
    "%
    | optional,
  status-notification
    | String
    | doc m%"
    Sends status notification periodically according to a cron schedule. Set to false to disable.
    "%
    | optional,
}