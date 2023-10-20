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
          DNS = predicates.contract_from_predicate definitions.predicate.DNS,
          DefaultDNS = {
                plugin
                  | String
                  | doc m%"
                  DNS plugin override. Defaults to first supported plugin available.
                  "%
                  | optional,
                ..
              },
          DefaultDeploy = predicates.contract_from_predicate
              definitions.predicate.DefaultDeploy,
          DefaultRun = {
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Additional environment variables added to every app that supports environment variables.
                  "%
                  | optional,
                plugin
                  | String
                  | doc m%"
                  Run plugin override. Defaults to first supported plugin available.
                  "%
                  | optional,
                ..
              },
          Defaults = {
                deploy
                  | definitions.contract.DefaultDeploy
                  | doc m%"
                  Deploy config.
                  "%
                  | optional,
                dns
                  | definitions.contract.DefaultDNS
                  | doc m%"
                  DNS config.
                  "%
                  | optional,
                run
                  | definitions.contract.DefaultRun
                  | doc m%"
                  Run config.
                  "%
                  | optional,
              },
          Dependencies = predicates.contract_from_predicate
              definitions.predicate.Dependencies,
          DependencyDatabaseUser = {
                hostname
                  | String
                  | doc m%"
                  Hostname that user is allowed to connect from. Not all databases may support it.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  Explicitly set password, defaults to a randomly generated string.
                  "%
                  | optional,
                ..
              },
          DependencyDeploy = { plugin | String | optional, .. },
          DependencyRun = { plugin | String | optional, .. },
          DependencyStorageCORS = {
                max_age_in_seconds
                  | std.number.Integer
                  | doc m%"
                  The value in seconds to return in the Access-Control-Max-Age header used in preflight responses.
                  "%
                  | optional,
                methods
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The list of HTTP methods on which to include CORS response headers, (GET, OPTIONS, POST, etc) Note: "*" is permitted in the list of methods, and means "any method".
                  "%
                  | optional,
                origins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The list of Origins eligible to receive CORS response headers. Note: "*" is permitted in the list of origins, and means "any Origin".
                  "%
                  | optional,
                response_headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The list of HTTP headers other than the simple response headers to give permission for the user-agent to share across domains.
                  "%
                  | optional,
                ..
              },
          Monitoring = {
                channels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.MonitoringChannel
                  ])
                  | doc m%"
                  Monitoring notification channels.
                  "%
                  | optional,
                plugin
                  | String
                  | doc m%"
                  Monitoring plugin override. Defaults to first supported plugin available.
                  "%
                  | optional,
                targets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.MonitoringTarget
                  ])
                  | doc m%"
                  Monitoring targets.
                  "%
                  | optional,
              },
          MonitoringChannel = predicates.contract_from_predicate
              definitions.predicate.MonitoringChannel,
          MonitoringTarget = {
                frequency
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.enum [ 1, 5, 10, 15 ]
                  ])
                  | doc m%"
                  Check frequency in minutes. Defaults to 5 minutes.
                  "%
                  | optional,
                locations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Check locations to use. Defaults to 'all'.
                  "%
                  | optional,
                url
                  | String
                  | doc m%"
                  Target full url.
                  "%,
              },
          OutblocksProject = {
                defaults
                  | definitions.contract.Defaults
                  | doc m%"
                  Project-wide default app settings.
                  "%
                  | optional,
                dependencies
                  | definitions.contract.Dependencies
                  | doc m%"
                  Project-wide dependencies to provision.
                  "%
                  | optional,
                dns
                  | definitions.contract.DNS
                  | doc m%"
                  Project-wide DNS setup.
                  "%
                  | optional,
                monitoring
                  | definitions.contract.Monitoring
                  | doc m%"
                  Project monitoring setup.
                  "%
                  | optional,
                name | String | optional,
                plugins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Plugin
                  ])
                  | doc m%"
                  Project-wide plugins.
                  "%
                  | optional,
                secrets
                  | definitions.contract.Secrets
                  | doc m%"
                  Project-wide secrets provider.
                  "%
                  | optional,
                state
                  | definitions.contract.State
                  | doc m%"
                  Project-wide state source.
                  "%
                  | optional,
              },
          Plugin = { name | String, .. },
          SSL = {
                cert
                  | String
                  | doc m%"
                  Public key value in PEM format.
                  "%
                  | optional,
                cert_file
                  | String
                  | doc m%"
                  Public key file path. Required to be in PEM format.
                  "%
                  | optional,
                key
                  | String
                  | doc m%"
                  Private key value in PEM format.
                  "%
                  | optional,
                key_file
                  | String
                  | doc m%"
                  Private key file path. Required to be in PEM format.
                  "%
                  | optional,
              },
          Secrets = {
                type
                  | String
                  | doc m%"
                  Secrets provider type, plugin specific value e.g. 'gcp' for gcp plugin.
                  "%
                  | optional,
                ..
              },
          State = {
                path
                  | String
                  | doc m%"
                  Path of local state, used only when state type is 'local'.
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  State type, plugin specific value e.g. 'gcp' for gcp plugin or use 'local' for local state.
                  "%,
                ..
              },
        },
    predicate = {
          DNS = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.records.required [ "domain" ],
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.allOf
                    [
                      predicates.records.required [ "domains" ],
                      predicates.records.record {  } {  } true predicates.always
                    ]
                  ],
                  predicates.records.record
                  {
                    domain = predicates.isType '"String",
                    domains = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    plugin = predicates.isType '"String",
                    ssl = definitions.predicate.SSL,
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          DefaultDNS = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { plugin = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          DefaultDeploy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { plugin = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          DefaultRun = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  env = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  plugin = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Defaults = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  deploy = definitions.predicate.DefaultDeploy,
                  dns = definitions.predicate.DefaultDNS,
                  run = definitions.predicate.DefaultRun,
                }
                {  }
                false
                predicates.never
              ],
          Dependencies = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.allOf
                        [
                          predicates.ifThenElse
                          (predicates.records.record
                          { type = predicates.const "storage", }
                          {  }
                          true
                          predicates.always)
                          (predicates.records.record
                          {
                            cors = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  definitions.predicate.DependencyStorageCORS
                                ],
                            delete_in_days = predicates.isType 'Integer,
                            expire_versions_in_days = predicates.isType
                                'Integer,
                            location = predicates.isType '"String",
                            max_versions = predicates.isType 'Integer,
                            public = predicates.isType '"Bool",
                            versioning = predicates.isType '"Bool",
                          }
                          {  }
                          true
                          predicates.always)
                          predicates.always,
                          predicates.ifThenElse
                          (predicates.anyOf
                          [
                            predicates.records.record
                            { type = predicates.const "mysql", }
                            {  }
                            true
                            predicates.always,
                            predicates.records.record
                            { type = predicates.const "postgresql", }
                            {  }
                            true
                            predicates.always
                          ])
                          (predicates.records.record
                          {
                            flags = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record {  } {  } true
                                  (predicates.isType '"String")
                                ],
                            high_availability = predicates.isType '"Bool",
                            tier = predicates.isType '"String",
                            users = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record {  } {  } true
                                  definitions.predicate.DependencyDatabaseUser
                                ],
                            version = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always)
                          predicates.always
                        ],
                        predicates.records.required [ "type" ],
                        predicates.records.record
                        {
                          deploy = definitions.predicate.DependencyDeploy,
                          run = definitions.predicate.DependencyRun,
                          type = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                false
                predicates.never
              ],
          DependencyDatabaseUser = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  hostname = predicates.isType '"String",
                  password = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          DependencyDeploy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { plugin = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          DependencyRun = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { plugin = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          DependencyStorageCORS = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  max_age_in_seconds = predicates.isType 'Integer,
                  methods = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  origins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  response_headers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Monitoring = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  channels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.MonitoringChannel
                      ],
                  plugin = predicates.isType '"String",
                  targets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.MonitoringTarget
                      ],
                }
                {  }
                false
                predicates.never
              ],
          MonitoringChannel = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "slack", }
                  {  }
                  true
                  predicates.always)
                  (predicates.allOf
                  [
                    predicates.records.required [ "channel", "token", "type" ],
                    predicates.records.record
                    {
                      channel = predicates.isType '"String",
                      token = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always
                  ])
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "email", }
                  {  }
                  true
                  predicates.always)
                  (predicates.allOf
                  [
                    predicates.records.required [ "email", "type" ],
                    predicates.records.record
                    { email = predicates.isType '"String", }
                    {  }
                    true
                    predicates.always
                  ])
                  predicates.always
                ],
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "slack", "email" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          MonitoringTarget = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "url" ],
                predicates.records.record
                {
                  frequency = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.enum [ 1, 5, 10, 15 ]
                      ],
                  locations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          OutblocksProject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaults = definitions.predicate.Defaults,
                  dependencies = definitions.predicate.Dependencies,
                  dns = definitions.predicate.DNS,
                  monitoring = definitions.predicate.Monitoring,
                  name = predicates.isType '"String",
                  plugins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Plugin
                      ],
                  secrets = definitions.predicate.Secrets,
                  state = definitions.predicate.State,
                }
                {  }
                false
                predicates.never
              ],
          Plugin = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                { name = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          SSL = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cert = predicates.isType '"String",
                  cert_file = predicates.isType '"String",
                  key = predicates.isType '"String",
                  key_file = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Secrets = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { type = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          State = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

definitions.contract.OutblocksProject