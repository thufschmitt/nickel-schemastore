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
          addressConfigDef
            | doc m%"
            Datapoint address configuration object
            "%
            = predicates.contract_from_predicate
              definitions.predicate.addressConfigDef,
          alertConfigDef
            | doc m%"
            Allows to configure trigger of alarms and events depending on the datapoint values
            "%
            = predicates.contract_from_predicate
              definitions.predicate.alertConfigDef,
          auditedDef
            | doc m%"
            Flag indication for audit process
            "%
            = predicates.contract_from_predicate
              definitions.predicate.auditedDef,
          broadcastDef
            | doc m%"
            Flag to indicate that the alarm/datapointSet will be broadcasted to NetinHUB channels
            "%
            = predicates.contract_from_predicate
              definitions.predicate.broadcastDef,
          calcConfig
            | doc m%"
            Allows to create new datapoints based on an expression
            "%
            = predicates.contract_from_predicate
              definitions.predicate.calcConfig,
          commonConfigDef
            | doc m%"
            Datapoint common configuration object
            "%
            = predicates.contract_from_predicate
              definitions.predicate.commonConfigDef,
          convConfigDef
            | doc m%"
            Allows to apply enrichment expressions on the value field
            "%
            = predicates.contract_from_predicate
              definitions.predicate.convConfigDef,
          dataTypeDef
            | doc m%"
            Define the type of the data in the NetinDS context, this means how NetinDS will manage the data before the conversions
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'OBJECT,
                  'LONG_ARRAY,
                  'FLOAT_ARRAY,
                  'BOOLEAN_ARRAY,
                  'DOUBLE_ARRAY,
                  'STRING_ARRAY,
                  'INTEGER_ARRAY,
                  'ARRAY,
                  'DATE,
                  'BOOLEAN,
                  'STRING,
                  'DOUBLE,
                  'FLOAT,
                  'LONG,
                  'INTEGER,
                  'BYTE
                |]
              ],
          datapointConfigDef
            | doc m%"
            Object that define a complete datapoint configuration
            "%
            = predicates.contract_from_predicate
              definitions.predicate.datapointConfigDef,
          datapointIdDef
            | doc m%"
            Datapoint identification string
            "%
            = predicates.contract_from_predicate
              definitions.predicate.datapointIdDef,
          datapointSetConfigDef
            | doc m%"
            DatapointSet configuration object
            "%
            = predicates.contract_from_predicate
              definitions.predicate.datapointSetConfigDef,
          datapointSetIdDef
            | doc m%"
            DatapointSet identification string
            "%
            = predicates.contract_from_predicate
              definitions.predicate.datapointSetIdDef,
          datapointSetTypeDef
            | doc m%"
            Define the data structure of this datapointSet, check the documentation for more information
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| 'tableDynamic, 'tableStatic, 'map |] ],
          datapointTypeDef
            | doc m%"
            Define the kind of information types, within NetinDS context, that the driver/zavod instances will generate for this datapoint
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  '"#TIMEPOINT",
                  '"#DATAPOINT",
                  '"@TIMEPOINT",
                  '"@DATAPOINT",
                  'DATAPOINT,
                  'TIMEPOINT,
                  'SIMPLE
                |]
              ],
          defaultValueConfigDef
            | doc m%"
            Allows to apply default values to a datapoint when the value or rawValue is null
            "%
            = predicates.contract_from_predicate
              definitions.predicate.defaultValueConfigDef,
          descriptionDef
            | doc m%"
            Detailed information about the device or system to be monitored by this device
            "%
            = predicates.contract_from_predicate
              definitions.predicate.descriptionDef,
          evaluationForAlarmsDef
            | doc m%"
            Array with all the evaluations that will be checked
            "%
            = {
                audited | definitions.contract.auditedDef,
                broadcast | definitions.contract.broadcastDef,
                expressions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.expressionLogicObjectDef
                  ])
                  | doc m%"
                  Array of logical expression than should return a boolean value
                  "%,
                facility | definitions.contract.facilityDef,
                hidden | definitions.contract.hiddenDef,
                logic | definitions.contract.logicDef,
                onStartup
                  | Bool
                  | doc m%"
                  Indicates wether the alert must be sent when the conditions are met from the beginning
                  "%,
                routing | definitions.contract.routingDef | optional,
                severity | definitions.contract.severityForAlarmsDef,
                text
                  | definitions.contract.textDef
                  | doc m%"
                  Alarm/event descriptive text
                  "%,
                textHelp
                  | definitions.contract.textDef
                  | doc m%"
                  Descriptive information that help to understand the alarm
                  "%,
                ..
              },
          evaluationForLogsDef
            | doc m%"
            Array with all the evaluations that will be checked
            "%
            = {
                audited | definitions.contract.auditedDef,
                broadcast | definitions.contract.broadcastDef,
                expressions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.expressionLogicObjectDef
                  ])
                  | doc m%"
                  Array of logical expression than should return a boolean value
                  "%,
                facility | definitions.contract.facilityDef,
                hidden | definitions.contract.hiddenDef,
                logic | definitions.contract.logicDef,
                onStartup
                  | Bool
                  | doc m%"
                  Indicates wether the alert must be sent when the conditions are met from the beginning
                  "%,
                routing | definitions.contract.routingDef | optional,
                severity | definitions.contract.severityForLogsDef,
                text
                  | definitions.contract.textDef
                  | doc m%"
                  Alarm/event descriptive text
                  "%,
                textHelp
                  | definitions.contract.textDef
                  | doc m%"
                  Descriptive information that help to understand the alarm
                  "%,
                ..
              },
          expressionDef
            | doc m%"
            Expression to be evaluated by NetinDS-Zavod
            "%
            = predicates.contract_from_predicate
              definitions.predicate.expressionDef,
          expressionLogicObjectDef
            | doc m%"
            Expressions that will be checked in this evaluation
            "%
            = {
                expression | definitions.contract.expressionDef,
                symbol | definitions.contract.symbolDef,
              },
          facilityDef
            | doc m%"
            Ident number for the resource group
            "%
            = predicates.contract_from_predicate
              definitions.predicate.facilityDef,
          hiddenDef
            | doc m%"
            Flag to indicate that the alarm is hidden by user request
            "%
            = predicates.contract_from_predicate
              definitions.predicate.hiddenDef,
          logicDef
            | doc m%"
            Logic operation to be applied between all the expressions
            "%
            = predicates.contract_from_predicate definitions.predicate.logicDef,
          originAccessTypeDef
            | doc m%"
            Access level to the datapoint. This is specific for each driver
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'not-accessible, 'read-write, 'write-only, 'read-only |]
              ],
          originAddressDef
            | doc m%"
            Define the address of this datapoint. This is specific for each driver
            "%
            = predicates.contract_from_predicate
              definitions.predicate.originAddressDef,
          originDataTypeDef
            | doc m%"
            Define the type of the data in the driver context, this means how the type of data that driver expect to collect
            "%
            = predicates.contract_from_predicate
              definitions.predicate.originDataTypeDef,
          originDef
            | doc m%"
            Monitored system, subsystem, device or ... source of the datapoint
            "%
            = predicates.contract_from_predicate
              definitions.predicate.originDef,
          originTypeConfigDef
            | doc m%"
            Driver (Origin type) configuration object. Check the specific documentation for each driver
            "%
            = predicates.contract_from_predicate
              definitions.predicate.originTypeConfigDef,
          originTypeDef
            | doc m%"
            Driver (Origin type) identification string for the driver
            "%
            = predicates.contract_from_predicate
              definitions.predicate.originTypeDef,
          pollingGroupDef
            | doc m%"
            Frequency in which the driver should update the value of this datapoint. This is specific for each driver
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  '"1d",
                  '"12h",
                  '"6h",
                  '"4h",
                  '"1h",
                  '"30m",
                  '"15m",
                  '"10m",
                  '"5m",
                  '"1m",
                  '"30s",
                  '"10s",
                  '"5s"
                |]
              ],
          rangerFilterDef
            | doc m%"
            Tags used by Ranger to match discoverd devices with their respective templates
            "%
            = predicates.contract_from_predicate
              definitions.predicate.rangerFilterDef,
          receiveModeDef
            | doc m%"
            Define how the driver should get the value of this datapoint. This is specific for each driver
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'subscription, 'singleQuery, 'polling |]
              ],
          representationCommonConfigDef
            | doc m%"
            Common fields for grid representation
            "%
            = {
                firstColumn
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 8,
                    predicates.numbers.minimum 1
                  ])
                  | doc m%"
                  Define de position of the widget, first column
                  "%,
                firstRow
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  Define de position of the widget, first row
                  "%,
                widgetHeight
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  Define de size of the widget, height
                  "%,
                widgetTitle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.maxLength 800,
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Text for widget title
                  "%,
                widgetType
                  | std.enum.TagOrString
                  | [| 'gauge, 'metric, 'table, 'map |]
                  | doc m%"
                  Select widget type
                  "%,
                widgetWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 8,
                    predicates.numbers.minimum 1
                  ])
                  | doc m%"
                  Define de size of the widget, width
                  "%,
                ..
              },
          representationDataDef
            | doc m%"
            Datapoints that widget will use for representation
            "%
            = predicates.contract_from_predicate
              definitions.predicate.representationDataDef,
          representationDef
            | doc m%"
            What, where and how information show in device view
            "%
            = predicates.contract_from_predicate
              definitions.predicate.representationDef,
          representationGaugeConfigDef
            | doc m%"
            Specific configuration for gauge widget representation
            "%
            = {
                format
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "datapoint" ],
                      predicates.records.record
                      {
                        color = predicates.isType '"String",
                        datapoint = definitions.predicate.datapointIdDef,
                        units = predicates.isType '"String",
                      }
                      {  }
                      true
                      predicates.always
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Representation for each gauge value
                  "%,
                maxValue
                  | Number
                  | doc m%"
                  Define the gauge maximum value
                  "%,
                minValue
                  | Number
                  | doc m%"
                  Define the gauge minimum value
                  "%,
                ranges
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "from", "severity", "to" ],
                      predicates.records.record
                      {
                        from = predicates.isType 'Integer,
                        severity = predicates.isType 'Integer,
                        to = predicates.isType 'Integer,
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ])
                  | doc m%"
                  Value ranges representation
                  "%
                  | optional,
                ..
              },
          representationMapConfigDef
            | doc m%"
            Specific configuration for map widget representation
            "%
            = {
                format
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required
                      [ "alias", "datapoint", "order" ],
                      predicates.records.record
                      {
                        alias = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.maxLength 80,
                              predicates.strings.minLength 1
                            ],
                        datapoint = definitions.predicate.datapointIdDef,
                        fieldType = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum
                              [
                                "string",
                                "boolean",
                                "numeric",
                                "date",
                                "severity"
                              ]
                            ],
                        order = predicates.allOf
                            [
                              predicates.isType 'Integer,
                              predicates.numbers.minimum 0
                            ],
                        utc = predicates.isType '"Bool",
                      }
                      {  }
                      false
                      predicates.never
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Representation for each row
                  "%,
              },
          representationMetricConfigDef
            | doc m%"
            Specific configuration for metric widget representation
            "%
            = {
                lastUpdateEnabled
                  | Bool
                  | doc m%"
                  Indicate if timestamp should be shown
                  "%
                  | optional,
                titleEnabled
                  | Bool
                  | doc m%"
                  Indicate if tittle should be shown
                  "%
                  | optional,
                url
                  | String
                  | doc m%"
                  Define url to opened on click event
                  "%
                  | optional,
                urlEnabled
                  | Bool
                  | doc m%"
                  Indicate if event click must be enable
                  "%
                  | optional,
              },
          representationTableConfigDef
            | doc m%"
            Specific configuration for Table widget representation
            "%
            = {
                filterable
                  | Bool
                  | doc m%"
                  Indicates if the columns should have filters
                  "%
                  | optional,
                format
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required
                      [ "alias", "datapoint", "order" ],
                      predicates.records.record
                      {
                        alias = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.maxLength 80,
                              predicates.strings.minLength 1
                            ],
                        datapoint = definitions.predicate.datapointIdDef,
                        fieldGroup = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum [ "basic", "advanced" ]
                            ],
                        fieldType = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum
                              [
                                "string",
                                "boolean",
                                "numeric",
                                "date",
                                "severity"
                              ]
                            ],
                        filterType = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum
                              [
                                "string",
                                "boolean",
                                "numeric",
                                "date",
                                "severity"
                              ]
                            ],
                        filterable = predicates.isType '"Bool",
                        minScreenSize = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum [ "xs", "s", "m", "l" ]
                            ],
                        order = predicates.allOf
                            [
                              predicates.isType 'Integer,
                              predicates.numbers.minimum 0
                            ],
                        utc = predicates.isType '"Bool",
                        width = predicates.allOf
                            [
                              predicates.isType 'Integer,
                              predicates.numbers.minimum 1
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Representation for each column
                  "%,
                pageSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 10,
                    predicates.numbers.minimum 2
                  ])
                  | doc m%"
                  Rows number for each page
                  "%
                  | optional,
                ..
              },
          routingDef = {
                service
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.maxLength 80
                  ])
                  | doc m%"
                  Define the service that should consume the information
                  "%
                  | optional,
                serviceConfig
                  | {  .. }
                  | doc m%"
                  Object to define the specific configuration of the service
                  "%
                  | optional,
                topic
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.maxLength 80
                  ])
                  | doc m%"
                  Define the topic that should be used to transport the data
                  "%,
                ..
              },
          rowFilterConfigDef
            | doc m%"
            Allows row filtering in table based datapointSets
            "%
            = predicates.contract_from_predicate
              definitions.predicate.rowFilterConfigDef,
          schemaVersionDef
            | doc m%"
            Fixed value designating the version of the template schema
            "%
            = predicates.contract_from_predicate
              definitions.predicate.schemaVersionDef,
          severityDef
            | doc m%"
            Level of criticality of the alarm
            "%
            = predicates.contract_from_predicate
              definitions.predicate.severityDef,
          severityForAlarmsDef
            | doc m%"
            Level of criticality of the alarm
            "%
            = predicates.contract_from_predicate
              definitions.predicate.severityForAlarmsDef,
          severityForLogsDef
            | doc m%"
            Level of criticality of the log
            "%
            = predicates.contract_from_predicate
              definitions.predicate.severityForLogsDef,
          symbolDef
            | doc m%"
            Identification string for logic expression
            "%
            = predicates.contract_from_predicate
              definitions.predicate.symbolDef,
          tableAddressDef
            | doc m%"
            Specific configuration for tabled based datapointSets
            "%
            = {
                indexes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern "^[a-zA-Z0-9#&_-]{1,80}$"
                    ])
                  ])
                  | doc m%"
                  Array of datapointIds that will act as table indexes, this means columns that acts as keys of the table
                  "%
                  | optional,
                rootAddress
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.maxLength 240
                  ])
                  | doc m%"
                  Main address for the table, this information is specific for each kind of driver
                  "%
                  | optional,
                ..
              },
          templateIdDef
            | doc m%"
            Template identification string
            "%
            = predicates.contract_from_predicate
              definitions.predicate.templateIdDef,
          templateVersionDef
            | doc m%"
            SemVer style template version
            "%
            = predicates.contract_from_predicate
              definitions.predicate.templateVersionDef,
          textDef
            | doc m%"
            Alarm/event descriptive text
            "%
            = predicates.contract_from_predicate definitions.predicate.textDef,
          unitsConfigDef
            | doc m%"
            Allows converts between measure units
            "%
            = predicates.contract_from_predicate
              definitions.predicate.unitsConfigDef,
          valueDef
            | doc m%"
            Value or rawValue of a datapoint
            "%
            = predicates.contract_from_predicate definitions.predicate.valueDef,
          valueMapConfigDef
            | doc m%"
            Allows converts rawValue to value based in a key/value map
            "%
            = predicates.contract_from_predicate
              definitions.predicate.valueMapConfigDef,
        },
    predicate = {
          addressConfigDef
            | doc m%"
            Datapoint address configuration object
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "dataType",
                  "originAccessType",
                  "originAddress",
                  "originDataType",
                  "originType",
                  "pollingGroup",
                  "receiveMode"
                ],
                predicates.records.record
                {
                  dataType = definitions.predicate.dataTypeDef,
                  originAccessType = definitions.predicate.originAccessTypeDef,
                  originAddress = definitions.predicate.originAddressDef,
                  originDataType = definitions.predicate.originDataTypeDef,
                  originType = definitions.predicate.originTypeDef,
                  pollingGroup = definitions.predicate.pollingGroupDef,
                  receiveMode = definitions.predicate.receiveModeDef,
                }
                {  }
                false
                predicates.never
              ],
          alertConfigDef
            | doc m%"
            Allows to configure trigger of alarms and events depending on the datapoint values
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "evaluations" ],
                predicates.records.record
                {
                  evaluations = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.evaluationForLogsDef,
                          predicates.arrays.minItems 1
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.evaluationForAlarmsDef,
                          predicates.arrays.minItems 1
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          auditedDef
            | doc m%"
            Flag indication for audit process
            "%
            = predicates.isType '"Bool",
          broadcastDef
            | doc m%"
            Flag to indicate that the alarm/datapointSet will be broadcasted to NetinHUB channels
            "%
            = predicates.isType '"Bool",
          calcConfig
            | doc m%"
            Allows to create new datapoints based on an expression
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "expression" ],
                predicates.records.record
                { expression = definitions.predicate.expressionDef, }
                {  }
                false
                predicates.never
              ],
          commonConfigDef
            | doc m%"
            Datapoint common configuration object
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "datapointId", "datapointType" ],
                predicates.records.record
                {
                  additionalProperties = predicates.never,
                  alias = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.maxLength 80,
                        predicates.strings.minLength 1
                      ],
                  datapointId = definitions.predicate.datapointIdDef,
                  datapointType = definitions.predicate.datapointTypeDef,
                  description = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.maxLength 1200,
                        predicates.strings.minLength 0
                      ],
                  syntaxInfo = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.maxLength 1200,
                        predicates.strings.minLength 0
                      ],
                }
                {  }
                true
                predicates.always
              ],
          convConfigDef
            | doc m%"
            Allows to apply enrichment expressions on the value field
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "expression" ],
                predicates.records.record
                { expression = definitions.predicate.expressionDef, }
                {  }
                false
                predicates.never
              ],
          dataTypeDef
            | doc m%"
            Define the type of the data in the NetinDS context, this means how NetinDS will manage the data before the conversions
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "BYTE",
                  "INTEGER",
                  "LONG",
                  "FLOAT",
                  "DOUBLE",
                  "STRING",
                  "BOOLEAN",
                  "DATE",
                  "ARRAY",
                  "INTEGER_ARRAY",
                  "STRING_ARRAY",
                  "DOUBLE_ARRAY",
                  "BOOLEAN_ARRAY",
                  "FLOAT_ARRAY",
                  "LONG_ARRAY",
                  "OBJECT"
                ]
              ],
          datapointConfigDef
            | doc m%"
            Object that define a complete datapoint configuration
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  predicates.ifThenElse
                  (predicates.allOf
                  [
                    predicates.records.required [ "commonConfig" ],
                    predicates.records.record
                    {
                      commonConfig = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { datapointType = predicates.const "#TIMEPOINT", }
                            {  }
                            true
                            predicates.always
                          ],
                    }
                    {  }
                    true
                    predicates.always
                  ])
                  (predicates.allOf
                  [
                    predicates.records.required
                    [ "addressConfig", "commonConfig" ],
                    predicates.records.record
                    {
                      addressConfig = definitions.predicate.addressConfigDef,
                      commonConfig = definitions.predicate.commonConfigDef,
                    }
                    {  }
                    false
                    predicates.never
                  ])
                  predicates.always,
                  predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.not
                      (predicates.allOf
                      [
                        predicates.records.required [ "calcConfig" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]),
                      predicates.records.required
                      [ "addressConfig", "commonConfig" ],
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.allOf
                    [
                      predicates.not
                      (predicates.allOf
                      [
                        predicates.records.required [ "addressConfig" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]),
                      predicates.records.required
                      [ "calcConfig", "commonConfig" ],
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.allOf
                    [
                      predicates.not
                      (predicates.allOf
                      [
                        predicates.records.required
                        [ "addressConfig", "calcConfig" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]),
                      predicates.records.required
                      [ "commonConfig", "defaultValueConfig" ],
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.allOf
                    [
                      predicates.not
                      (predicates.allOf
                      [
                        predicates.records.required [ "calcConfig" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]),
                      predicates.records.required
                      [ "commonConfig", "defaultValueConfig, addressConfig" ],
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.allOf
                    [
                      predicates.not
                      (predicates.allOf
                      [
                        predicates.records.required [ "addressConfig" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]),
                      predicates.records.required
                      [ "calcConfig", "commonConfig", "defaultValueConfig" ],
                      predicates.records.record {  } {  } true predicates.always
                    ]
                  ]
                ],
                predicates.records.record
                {
                  addressConfig = definitions.predicate.addressConfigDef,
                  alertConfig = definitions.predicate.alertConfigDef,
                  calcConfig = definitions.predicate.calcConfig,
                  commonConfig = definitions.predicate.commonConfigDef,
                  convConfig = definitions.predicate.convConfigDef,
                  defaultValueConfig =
                    definitions.predicate.defaultValueConfigDef,
                  rowFilterConfig = definitions.predicate.rowFilterConfigDef,
                  unitsConfig = definitions.predicate.unitsConfigDef,
                  valueMapConfig = definitions.predicate.valueMapConfigDef,
                }
                {  }
                true
                (predicates.isType 'Record)
              ],
          datapointIdDef
            | doc m%"
            Datapoint identification string
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[a-zA-Z0-9#&_-]{1,80}$"
              ],
          datapointSetConfigDef
            | doc m%"
            DatapointSet configuration object
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.ifThenElse
                (predicates.records.record
                {
                  datapointSetType = predicates.enum
                      [ "tableStatic", "tableDynamic" ],
                }
                {  }
                true
                predicates.always)
                (predicates.allOf
                [
                  predicates.records.required [ "tableAddress" ],
                  predicates.records.record {  } {  } true predicates.always
                ])
                predicates.always,
                predicates.records.required
                [
                  "alias",
                  "datapointSetId",
                  "datapointSetType",
                  "datapoints",
                  "description"
                ],
                predicates.records.record
                {
                  alias = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.maxLength 80,
                        predicates.strings.minLength 1
                      ],
                  broadcast = definitions.predicate.broadcastDef,
                  datapointSetId = definitions.predicate.datapointSetIdDef,
                  datapointSetType = definitions.predicate.datapointSetTypeDef,
                  datapoints = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.datapointConfigDef,
                        predicates.arrays.minItems 1
                      ],
                  description = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.maxLength 1200,
                        predicates.strings.minLength 0
                      ],
                  routing = definitions.predicate.routingDef,
                  tableAddress = definitions.predicate.tableAddressDef,
                }
                {  }
                false
                predicates.never
              ],
          datapointSetIdDef
            | doc m%"
            DatapointSet identification string
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[a-zA-Z0-9_-]{1,40}$"
              ],
          datapointSetTypeDef
            | doc m%"
            Define the data structure of this datapointSet, check the documentation for more information
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "map", "tableStatic", "tableDynamic" ]
              ],
          datapointTypeDef
            | doc m%"
            Define the kind of information types, within NetinDS context, that the driver/zavod instances will generate for this datapoint
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "SIMPLE",
                  "TIMEPOINT",
                  "DATAPOINT",
                  "@DATAPOINT",
                  "@TIMEPOINT",
                  "#DATAPOINT",
                  "#TIMEPOINT"
                ]
              ],
          defaultValueConfigDef
            | doc m%"
            Allows to apply default values to a datapoint when the value or rawValue is null
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required
                    [ "isDefault", "rawValue", "value" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "isDefault", "value" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "isDefault", "rawValue" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  isDefault = predicates.isType '"Bool",
                  rawValue = definitions.predicate.valueDef,
                  value = definitions.predicate.valueDef,
                }
                {  }
                false
                predicates.never
              ],
          descriptionDef
            | doc m%"
            Detailed information about the device or system to be monitored by this device
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 800,
                predicates.strings.minLength 1
              ],
          evaluationForAlarmsDef
            | doc m%"
            Array with all the evaluations that will be checked
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "audited",
                  "broadcast",
                  "expressions",
                  "facility",
                  "hidden",
                  "logic",
                  "onStartup",
                  "severity",
                  "text",
                  "textHelp"
                ],
                predicates.records.record
                {
                  audited = definitions.predicate.auditedDef,
                  broadcast = definitions.predicate.broadcastDef,
                  expressions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.expressionLogicObjectDef
                      ],
                  facility = definitions.predicate.facilityDef,
                  hidden = definitions.predicate.hiddenDef,
                  logic = definitions.predicate.logicDef,
                  onStartup = predicates.isType '"Bool",
                  routing = definitions.predicate.routingDef,
                  severity = definitions.predicate.severityForAlarmsDef,
                  text = definitions.predicate.textDef,
                  textHelp = definitions.predicate.textDef,
                }
                {  }
                true
                predicates.always
              ],
          evaluationForLogsDef
            | doc m%"
            Array with all the evaluations that will be checked
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "audited",
                  "broadcast",
                  "expressions",
                  "facility",
                  "hidden",
                  "logic",
                  "onStartup",
                  "severity",
                  "text",
                  "textHelp"
                ],
                predicates.records.record
                {
                  audited = definitions.predicate.auditedDef,
                  broadcast = definitions.predicate.broadcastDef,
                  expressions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.expressionLogicObjectDef
                      ],
                  facility = definitions.predicate.facilityDef,
                  hidden = definitions.predicate.hiddenDef,
                  logic = definitions.predicate.logicDef,
                  onStartup = predicates.isType '"Bool",
                  routing = definitions.predicate.routingDef,
                  severity = definitions.predicate.severityForLogsDef,
                  text = definitions.predicate.textDef,
                  textHelp = definitions.predicate.textDef,
                }
                {  }
                true
                predicates.always
              ],
          expressionDef
            | doc m%"
            Expression to be evaluated by NetinDS-Zavod
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 800,
                predicates.strings.minLength 1
              ],
          expressionLogicObjectDef
            | doc m%"
            Expressions that will be checked in this evaluation
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "expression", "symbol" ],
                predicates.records.record
                {
                  expression = definitions.predicate.expressionDef,
                  symbol = definitions.predicate.symbolDef,
                }
                {  }
                false
                predicates.never
              ],
          facilityDef
            | doc m%"
            Ident number for the resource group
            "%
            = predicates.allOf
              [
                predicates.isType 'Integer,
                predicates.numbers.maximum 255,
                predicates.numbers.minimum (-1)
              ],
          hiddenDef
            | doc m%"
            Flag to indicate that the alarm is hidden by user request
            "%
            = predicates.isType '"Bool",
          logicDef
            | doc m%"
            Logic operation to be applied between all the expressions
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 80,
                predicates.strings.minLength 1
              ],
          originAccessTypeDef
            | doc m%"
            Access level to the datapoint. This is specific for each driver
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "read-only", "write-only", "read-write", "not-accessible" ]
              ],
          originAddressDef
            | doc m%"
            Define the address of this datapoint. This is specific for each driver
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[\\w\\d_&#:$.-]{1,80}$"
              ],
          originDataTypeDef
            | doc m%"
            Define the type of the data in the driver context, this means how the type of data that driver expect to collect
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[a-zA-Z0-9-_]{1,80}$"
              ],
          originDef
            | doc m%"
            Monitored system, subsystem, device or ... source of the datapoint
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^\\/\\{[a-zA-Z0-9-_.]{1,80}\\}\\/$|^[a-zA-Z0-9-_.]{1,80}$"
              ],
          originTypeConfigDef
            | doc m%"
            Driver (Origin type) configuration object. Check the specific documentation for each driver
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "originType" ],
                predicates.records.record
                { originType = definitions.predicate.originTypeDef, }
                {  }
                true
                predicates.always
              ],
          originTypeDef
            | doc m%"
            Driver (Origin type) identification string for the driver
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[a-zA-Z0-9-]{1,80}$"
              ],
          pollingGroupDef
            | doc m%"
            Frequency in which the driver should update the value of this datapoint. This is specific for each driver
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "5s",
                  "10s",
                  "30s",
                  "1m",
                  "5m",
                  "10m",
                  "15m",
                  "30m",
                  "1h",
                  "4h",
                  "6h",
                  "12h",
                  "1d"
                ]
              ],
          rangerFilterDef
            | doc m%"
            Tags used by Ranger to match discoverd devices with their respective templates
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  description = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.maxLength 800,
                        predicates.strings.minLength 1
                      ],
                  deviceID = predicates.isType '"String",
                  vendorID = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          receiveModeDef
            | doc m%"
            Define how the driver should get the value of this datapoint. This is specific for each driver
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "polling", "singleQuery", "subscription" ]
              ],
          representationCommonConfigDef
            | doc m%"
            Common fields for grid representation
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "firstColumn",
                  "firstRow",
                  "widgetHeight",
                  "widgetTitle",
                  "widgetType",
                  "widgetWidth"
                ],
                predicates.records.record
                {
                  firstColumn = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 8,
                        predicates.numbers.minimum 1
                      ],
                  firstRow = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                  widgetHeight = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                  widgetTitle = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.maxLength 800,
                        predicates.strings.minLength 1
                      ],
                  widgetType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "map", "table", "metric", "gauge" ]
                      ],
                  widgetWidth = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 8,
                        predicates.numbers.minimum 1
                      ],
                }
                {  }
                true
                predicates.always
              ],
          representationDataDef
            | doc m%"
            Datapoints that widget will use for representation
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^device\\[[a-zA-Z0-9_-]{1,40}((\\.[0-9]+)?\\.[a-zA-Z0-9#&_-]{1,80})?\\]$"
              ],
          representationDef
            | doc m%"
            What, where and how information show in device view
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  predicates.ifThenElse
                  (predicates.allOf
                  [
                    predicates.records.required [ "commonConfig" ],
                    predicates.records.record
                    {
                      commonConfig = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { widgetType = predicates.const "map", }
                            {  }
                            true
                            predicates.always
                          ],
                    }
                    {  }
                    true
                    predicates.always
                  ])
                  (predicates.allOf
                  [
                    predicates.records.required
                    [ "commonConfig", "data", "specificConfig" ],
                    predicates.records.record
                    {
                      commonConfig =
                        definitions.predicate.representationCommonConfigDef,
                      data = definitions.predicate.representationDataDef,
                      specificConfig =
                        definitions.predicate.representationMapConfigDef,
                    }
                    {  }
                    true
                    predicates.always
                  ])
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    commonConfig = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          { widgetType = predicates.const "table", }
                          {  }
                          true
                          predicates.always
                        ],
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.allOf
                  [
                    predicates.records.required
                    [ "commonConfig", "data", "specificConfig" ],
                    predicates.records.record
                    {
                      commonConfig =
                        definitions.predicate.representationCommonConfigDef,
                      data = definitions.predicate.representationDataDef,
                      specificConfig =
                        definitions.predicate.representationTableConfigDef,
                    }
                    {  }
                    true
                    predicates.always
                  ])
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    commonConfig = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          { widgetType = predicates.const "metric", }
                          {  }
                          true
                          predicates.always
                        ],
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.allOf
                  [
                    predicates.records.required
                    [ "commonConfig", "data", "specificConfig" ],
                    predicates.records.record
                    {
                      commonConfig =
                        definitions.predicate.representationCommonConfigDef,
                      data = definitions.predicate.representationDataDef,
                      specificConfig =
                        definitions.predicate.representationMetricConfigDef,
                    }
                    {  }
                    true
                    predicates.always
                  ])
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.allOf
                  [
                    predicates.records.required [ "commonConfig" ],
                    predicates.records.record
                    {
                      commonConfig = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { widgetType = predicates.const "gauge", }
                            {  }
                            true
                            predicates.always
                          ],
                    }
                    {  }
                    true
                    predicates.always
                  ])
                  (predicates.allOf
                  [
                    predicates.records.required
                    [ "commonConfig", "data", "specificConfig" ],
                    predicates.records.record
                    {
                      commonConfig =
                        definitions.predicate.representationCommonConfigDef,
                      data = definitions.predicate.representationDataDef,
                      specificConfig =
                        definitions.predicate.representationGaugeConfigDef,
                    }
                    {  }
                    true
                    predicates.always
                  ])
                  predicates.always
                ],
                predicates.records.record
                {
                  commonConfig =
                    definitions.predicate.representationCommonConfigDef,
                  data = definitions.predicate.representationDataDef,
                }
                {  }
                true
                predicates.always
              ],
          representationGaugeConfigDef
            | doc m%"
            Specific configuration for gauge widget representation
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "format", "maxValue", "minValue" ],
                predicates.records.record
                {
                  format = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "datapoint" ],
                          predicates.records.record
                          {
                            color = predicates.isType '"String",
                            datapoint = definitions.predicate.datapointIdDef,
                            units = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ]),
                        predicates.arrays.minItems 1
                      ],
                  maxValue = predicates.isType '"Number",
                  minValue = predicates.isType '"Number",
                  ranges = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "from", "severity", "to" ],
                          predicates.records.record
                          {
                            from = predicates.isType 'Integer,
                            severity = predicates.isType 'Integer,
                            to = predicates.isType 'Integer,
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                }
                {  }
                true
                predicates.always
              ],
          representationMapConfigDef
            | doc m%"
            Specific configuration for map widget representation
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "format" ],
                predicates.records.record
                {
                  format = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "alias", "datapoint", "order" ],
                          predicates.records.record
                          {
                            alias = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.maxLength 80,
                                  predicates.strings.minLength 1
                                ],
                            datapoint = definitions.predicate.datapointIdDef,
                            fieldType = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum
                                  [
                                    "string",
                                    "boolean",
                                    "numeric",
                                    "date",
                                    "severity"
                                  ]
                                ],
                            order = predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.minimum 0
                                ],
                            utc = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ]),
                        predicates.arrays.minItems 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          representationMetricConfigDef
            | doc m%"
            Specific configuration for metric widget representation
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  lastUpdateEnabled = predicates.isType '"Bool",
                  titleEnabled = predicates.isType '"Bool",
                  url = predicates.isType '"String",
                  urlEnabled = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          representationTableConfigDef
            | doc m%"
            Specific configuration for Table widget representation
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "format" ],
                predicates.records.record
                {
                  filterable = predicates.isType '"Bool",
                  format = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "alias", "datapoint", "order" ],
                          predicates.records.record
                          {
                            alias = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.maxLength 80,
                                  predicates.strings.minLength 1
                                ],
                            datapoint = definitions.predicate.datapointIdDef,
                            fieldGroup = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "basic", "advanced" ]
                                ],
                            fieldType = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum
                                  [
                                    "string",
                                    "boolean",
                                    "numeric",
                                    "date",
                                    "severity"
                                  ]
                                ],
                            filterType = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum
                                  [
                                    "string",
                                    "boolean",
                                    "numeric",
                                    "date",
                                    "severity"
                                  ]
                                ],
                            filterable = predicates.isType '"Bool",
                            minScreenSize = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "xs", "s", "m", "l" ]
                                ],
                            order = predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.minimum 0
                                ],
                            utc = predicates.isType '"Bool",
                            width = predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.minimum 1
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ]),
                        predicates.arrays.minItems 1
                      ],
                  pageSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 10,
                        predicates.numbers.minimum 2
                      ],
                }
                {  }
                true
                predicates.always
              ],
          routingDef = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "topic" ],
                predicates.records.record
                {
                  service = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.maxLength 80
                      ],
                  serviceConfig = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  topic = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.maxLength 80
                      ],
                }
                {  }
                true
                predicates.always
              ],
          rowFilterConfigDef
            | doc m%"
            Allows row filtering in table based datapointSets
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  expressions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.expressionLogicObjectDef
                      ],
                  logic = definitions.predicate.logicDef,
                }
                {  }
                true
                predicates.always
              ],
          schemaVersionDef
            | doc m%"
            Fixed value designating the version of the template schema
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "(?<=^v?|\\sv?)(?:(?:0|[1-9][0-9]*).){2}(?:0|[1-9][0-9]*)(?:-(?:0|[1-9][0-9]*|[0-9a-z-]*[a-z-][0-9a-z-]*)(?:.(?:0|[1-9][0-9]*|[0-9a-z-]*[a-z-][0-9a-z-]*))*)?(?:\\+[0-9a-z-]+(?:.[0-9a-z-]+)*)?\\b"
              ],
          severityDef
            | doc m%"
            Level of criticality of the alarm
            "%
            = predicates.allOf
              [
                predicates.isType 'Integer,
                predicates.numbers.maximum 1000,
                predicates.numbers.minimum (-1)
              ],
          severityForAlarmsDef
            | doc m%"
            Level of criticality of the alarm
            "%
            = predicates.allOf
              [
                predicates.isType 'Integer,
                predicates.numbers.maximum 1000,
                predicates.numbers.minimum 201
              ],
          severityForLogsDef
            | doc m%"
            Level of criticality of the log
            "%
            = predicates.allOf
              [
                predicates.isType 'Integer,
                predicates.numbers.maximum 200,
                predicates.numbers.minimum 1
              ],
          symbolDef
            | doc m%"
            Identification string for logic expression
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          tableAddressDef
            | doc m%"
            Specific configuration for tabled based datapointSets
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  indexes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^[a-zA-Z0-9#&_-]{1,80}$"
                        ])
                      ],
                  rootAddress = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.maxLength 240
                      ],
                }
                {  }
                true
                predicates.always
              ],
          templateIdDef
            | doc m%"
            Template identification string
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[a-zA-Z0-9-_ ]{1,80}$"
              ],
          templateVersionDef
            | doc m%"
            SemVer style template version
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "(?<=^v?|\\sv?)(?:(?:0|[1-9][0-9]*).){2}(?:0|[1-9][0-9]*)(?:-(?:0|[1-9][0-9]*|[0-9a-z-]*[a-z-][0-9a-z-]*)(?:.(?:0|[1-9][0-9]*|[0-9a-z-]*[a-z-][0-9a-z-]*))*)?(?:\\+[0-9a-z-]+(?:.[0-9a-z-]+)*)?\\b"
              ],
          textDef
            | doc m%"
            Alarm/event descriptive text
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 800,
                predicates.strings.minLength 1
              ],
          unitsConfigDef
            | doc m%"
            Allows converts between measure units
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.not
                    (predicates.allOf
                    [
                      predicates.records.required [ "exclude", "toBest" ],
                      predicates.records.record {  } {  } true predicates.always
                    ]),
                    predicates.records.required [ "from", "to" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.not
                    (predicates.allOf
                    [
                      predicates.records.required [ "to" ],
                      predicates.records.record {  } {  } true predicates.always
                    ]),
                    predicates.records.required [ "from", "toBest" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  exclude = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  from = predicates.isType '"String",
                  to = predicates.isType '"String",
                  toBest = predicates.isType '"Bool",
                  units = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          valueDef
            | doc m%"
            Value or rawValue of a datapoint
            "%
            = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.isType '"Number",
                predicates.isType '"Bool",
                predicates.isType '"Array",
                predicates.isType 'Record
              ],
          valueMapConfigDef
            | doc m%"
            Allows converts rawValue to value based in a key/value map
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "map" ],
                predicates.records.record
                {
                  map = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            key = predicates.oneOf
                                [
                                  predicates.isType '"String",
                                  predicates.isType '"Number",
                                  predicates.isType '"Bool"
                                ],
                            value = predicates.oneOf
                                [
                                  predicates.isType '"String",
                                  predicates.isType '"Number",
                                  predicates.isType '"Bool",
                                  predicates.isType 'Integer
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ])
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
  predicates.records.required
  [ "datapointSets", "description", "origin", "templateId", "templateVersion" ],
  predicates.records.record
  {
    alias = predicates.allOf
        [
          predicates.isType '"String",
          predicates.strings.maxLength 80,
          predicates.strings.minLength 1
        ],
    datapointSets = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.datapointSetConfigDef,
          predicates.arrays.minItems 1
        ],
    description = definitions.predicate.descriptionDef,
    origin = definitions.predicate.originDef,
    originTypes = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.originTypeConfigDef,
          predicates.arrays.minItems 1,
          predicates.arrays.uniqueItems
        ],
    rangerFilter = definitions.predicate.rangerFilterDef,
    representation = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.representationDef,
          predicates.arrays.minItems 1
        ],
    schemaVersion = definitions.predicate.schemaVersionDef,
    templateId = definitions.predicate.templateIdDef,
    templateVersion = definitions.predicate.templateVersionDef,
  }
  {  }
  false
  predicates.never
])