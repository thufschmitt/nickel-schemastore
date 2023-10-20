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

let rec definitions = { contract = {  }, predicate = {  }, } in
predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.record
  {
    GLOBAL = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            backend_packages = predicates.isType '"Array",
            build_file_prelude_globs = predicates.isType '"Array",
            build_ignore = predicates.isType '"Array",
            build_patterns = predicates.isType '"Array",
            ca_certs_path = predicates.isType '"String",
            cache_content_behavior = predicates.enum
                [ "fetch", "validate", "defer" ],
            colors = predicates.isType '"Bool",
            concurrent = predicates.isType '"Bool",
            docker_execution = predicates.isType '"Bool",
            dynamic_ui = predicates.isType '"Bool",
            dynamic_ui_renderer = predicates.enum
                [ "indicatif-spinner", "experimental-prodash" ],
            engine_visualize_to = predicates.always,
            ignore_warnings = predicates.isType '"Array",
            keep_sandboxes = predicates.enum
                [ "always", "on_failure", "never" ],
            level = predicates.enum
                [ "trace", "debug", "info", "warn", "error" ],
            local_cache = predicates.isType '"Bool",
            local_execution_root_dir = predicates.isType '"String",
            local_store_dir = predicates.isType '"String",
            local_store_directories_max_size_bytes = predicates.isType
                '"Number",
            local_store_files_max_size_bytes = predicates.isType '"Number",
            local_store_processes_max_size_bytes = predicates.isType '"Number",
            local_store_shard_count = predicates.isType '"Number",
            log_levels_by_target = predicates.isType 'Record,
            log_show_rust_3rdparty = predicates.isType '"Bool",
            logdir = predicates.isType '"String",
            loop = predicates.isType '"Bool",
            loop_max = predicates.isType '"Number",
            named_caches_dir = predicates.isType '"String",
            pants_bin_name = predicates.isType '"String",
            pants_config_files = predicates.isType '"Array",
            pants_distdir = predicates.isType '"String",
            pants_ignore = predicates.isType '"Array",
            pants_ignore_use_gitignore = predicates.isType '"Bool",
            pants_physical_workdir_base = predicates.isType '"String",
            pants_subprocessdir = predicates.isType '"String",
            pants_version = predicates.isType '"String",
            pants_workdir = predicates.isType '"String",
            pantsd = predicates.isType '"Bool",
            pantsd_invalidation_globs = predicates.isType '"Array",
            pantsd_max_memory_usage = predicates.always,
            pantsd_pailgun_port = predicates.isType '"Number",
            pantsd_timeout_when_multiple_invocations = predicates.isType
                '"Number",
            pantsrc = predicates.isType '"Bool",
            pantsrc_files = predicates.isType '"Array",
            plugins = predicates.isType '"Array",
            plugins_force_resolve = predicates.isType '"Bool",
            print_stacktrace = predicates.isType '"Bool",
            process_execution_cache_namespace = predicates.isType '"String",
            process_execution_graceful_shutdown_timeout = predicates.isType
                '"Number",
            process_execution_local_enable_nailgun = predicates.isType '"Bool",
            process_execution_local_parallelism = predicates.isType '"Number",
            process_execution_remote_parallelism = predicates.isType '"Number",
            process_per_child_memory_usage = predicates.always,
            process_total_child_memory_usage = predicates.always,
            pythonpath = predicates.isType '"Array",
            remote_ca_certs_path = predicates.isType '"String",
            remote_cache_read = predicates.isType '"Bool",
            remote_cache_rpc_concurrency = predicates.isType '"Number",
            remote_cache_rpc_timeout_millis = predicates.isType '"Number",
            remote_cache_warnings = predicates.enum
                [ "ignore", "first_only", "backoff" ],
            remote_cache_write = predicates.isType '"Bool",
            remote_execution = predicates.isType '"Bool",
            remote_execution_address = predicates.isType '"String",
            remote_execution_append_only_caches_base_path = predicates.isType
                '"String",
            remote_execution_extra_platform_properties = predicates.isType
                '"Array",
            remote_execution_headers = predicates.isType 'Record,
            remote_execution_overall_deadline_secs = predicates.isType
                '"Number",
            remote_execution_rpc_concurrency = predicates.isType '"Number",
            remote_instance_name = predicates.isType '"String",
            remote_oauth_bearer_token_path = predicates.isType '"String",
            remote_store_address = predicates.isType '"String",
            remote_store_batch_api_size_limit = predicates.isType '"Number",
            remote_store_chunk_bytes = predicates.isType '"Number",
            remote_store_headers = predicates.isType 'Record,
            remote_store_rpc_concurrency = predicates.isType '"Number",
            remote_store_rpc_retries = predicates.isType '"Number",
            remote_store_rpc_timeout_millis = predicates.isType '"Number",
            rule_threads_core = predicates.isType '"Number",
            rule_threads_max = predicates.isType '"Number",
            session_end_tasks_timeout = predicates.isType '"Number",
            show_log_target = predicates.isType '"Bool",
            spec_files = predicates.isType '"Array",
            stats_record_option_scopes = predicates.isType '"Array",
            streaming_workunits_complete_async = predicates.isType '"Bool",
            streaming_workunits_level = predicates.enum
                [ "trace", "debug", "info", "warn", "error" ],
            streaming_workunits_report_interval = predicates.isType '"Number",
            subproject_roots = predicates.isType '"Array",
            tag = predicates.isType '"Array",
            unmatched_build_file_globs = predicates.enum
                [ "ignore", "warn", "error" ],
            unmatched_cli_globs = predicates.enum [ "ignore", "warn", "error" ],
            verify_config = predicates.isType '"Bool",
            watch_filesystem = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    anonymous-telemetry = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            enabled = predicates.isType '"Bool",
            repo_id = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    autoflake = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            console_script = predicates.isType '"String",
            entry_point = predicates.isType '"String",
            install_from_resolve = predicates.isType '"String",
            interpreter_constraints = predicates.isType '"Array",
            requirements = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    black = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            config = predicates.always,
            config_discovery = predicates.isType '"Bool",
            console_script = predicates.isType '"String",
            entry_point = predicates.isType '"String",
            install_from_resolve = predicates.isType '"String",
            interpreter_constraints = predicates.isType '"Array",
            requirements = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    build-deprecations-fixer = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record { skip = predicates.isType '"Bool", } {  }
          true
          predicates.always
        ],
    changed = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            dependents = predicates.enum [ "none", "direct", "transitive" ],
            diffspec = predicates.isType '"String",
            since = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    check = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record { only = predicates.isType '"Array", } {  }
          true
          predicates.always
        ],
    check-default-tools = predicates.isType 'Record,
    cli = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record { alias = predicates.isType 'Record, } {  }
          true
          predicates.always
        ],
    count-loc = predicates.isType 'Record,
    coursier = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            known_versions = predicates.isType '"Array",
            repos = predicates.isType '"Array",
            url_platform_mapping = predicates.isType 'Record,
            url_template = predicates.isType '"String",
            use_unsupported_version = predicates.enum [ "error", "warning" ],
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    coverage-py = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            config = predicates.always,
            config_discovery = predicates.isType '"Bool",
            console_script = predicates.isType '"String",
            entry_point = predicates.isType '"String",
            fail_under = predicates.isType '"Number",
            filter = predicates.isType '"Array",
            global_report = predicates.isType '"Bool",
            install_from_resolve = predicates.isType '"String",
            interpreter_constraints = predicates.isType '"Array",
            output_dir = predicates.isType '"String",
            report = predicates.enum
                [ "console", "xml", "html", "raw", "json", "lcov" ],
            requirements = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    debug-adapter = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            host = predicates.isType '"String",
            port = predicates.isType '"Number",
          }
          {  }
          true
          predicates.always
        ],
    debugpy = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            console_script = predicates.isType '"String",
            entry_point = predicates.isType '"String",
            install_from_resolve = predicates.isType '"String",
            interpreter_constraints = predicates.isType '"Array",
            requirements = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    dependees = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            closed = predicates.isType '"Bool",
            output_file = predicates.isType '"String",
            sep = predicates.isType '"String",
            transitive = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    dependencies = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            closed = predicates.isType '"Bool",
            output_file = predicates.isType '"String",
            sep = predicates.isType '"String",
            transitive = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    dependents = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            closed = predicates.isType '"Bool",
            output_file = predicates.isType '"String",
            sep = predicates.isType '"String",
            transitive = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    docformatter = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            console_script = predicates.isType '"String",
            entry_point = predicates.isType '"String",
            install_from_resolve = predicates.isType '"String",
            interpreter_constraints = predicates.isType '"Array",
            requirements = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    docker = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            build_args = predicates.isType '"Array",
            build_target_stage = predicates.isType '"String",
            build_verbose = predicates.isType '"Bool",
            default_context_root = predicates.always,
            default_repository = predicates.isType '"String",
            env_vars = predicates.isType '"Array",
            executable_search_paths = predicates.isType '"Array",
            registries = predicates.oneOf
                [ predicates.isType 'Record, predicates.isType '"String" ],
            run_args = predicates.isType '"Array",
            tailor = predicates.isType '"Bool",
            tools = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    dockerfile-parser = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            install_from_resolve = predicates.isType '"String",
            interpreter_constraints = predicates.isType '"Array",
            requirements = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    environments-preview = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record { names = predicates.isType 'Record, } {  }
          true
          predicates.always
        ],
    experimental-bsp = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            groups_config_files = predicates.isType '"Array",
            runner_env_vars = predicates.isType '"Array",
            server = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    experimental-deploy = predicates.isType 'Record,
    experimental-explorer = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            address = predicates.isType '"String",
            port = predicates.isType '"Number",
          }
          {  }
          true
          predicates.always
        ],
    export = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            py_editable_in_resolve = predicates.isType '"Array",
            py_resolve_format = predicates.enum
                [ "mutable_virtualenv", "symlinked_immutable_virtualenv" ],
            resolve = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    export-codegen = predicates.isType 'Record,
    filedeps = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            absolute = predicates.isType '"Bool",
            globs = predicates.isType '"Bool",
            output_file = predicates.isType '"String",
            sep = predicates.isType '"String",
            transitive = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    filter = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            address_regex = predicates.isType '"Array",
            granularity = predicates.enum [ "all", "file", "BUILD" ],
            output_file = predicates.isType '"String",
            sep = predicates.isType '"String",
            tag_regex = predicates.isType '"Array",
            target_type = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    fix = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            batch_size = predicates.isType '"Number",
            only = predicates.isType '"Array",
            skip_formatters = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    flake8 = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            config = predicates.always,
            config_discovery = predicates.isType '"Bool",
            console_script = predicates.isType '"String",
            entry_point = predicates.isType '"String",
            extra_files = predicates.isType '"Array",
            install_from_resolve = predicates.isType '"String",
            requirements = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
            source_plugins = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    fmt = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            batch_size = predicates.isType '"Number",
            only = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    generate-lockfiles = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            custom_command = predicates.isType '"String",
            diff = predicates.isType '"Bool",
            diff_include_unchanged = predicates.isType '"Bool",
            resolve = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    go-generate = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record { env_vars = predicates.isType '"Array", }
          {  }
          true
          predicates.always
        ],
    go-test = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            block_profile = predicates.isType '"Bool",
            cover_mode = predicates.enum [ "set", "count", "atomic" ],
            coverage_html = predicates.isType '"Bool",
            coverage_output_dir = predicates.isType '"String",
            coverage_packages = predicates.isType '"Array",
            cpu_profile = predicates.isType '"Bool",
            force_asan = predicates.isType '"Bool",
            force_msan = predicates.isType '"Bool",
            force_race = predicates.isType '"Bool",
            mem_profile = predicates.isType '"Bool",
            mutex_profile = predicates.isType '"Bool",
            output_test_binary = predicates.isType '"Bool",
            skip = predicates.isType '"Bool",
            trace = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    gofmt = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    golang = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            asdf_bin_relpath = predicates.isType '"String",
            asdf_tool_name = predicates.isType '"String",
            cgo_c_flags = predicates.isType '"Array",
            cgo_cxx_flags = predicates.isType '"Array",
            cgo_enabled = predicates.isType '"Bool",
            cgo_fortran_binary_name = predicates.isType '"String",
            cgo_fortran_flags = predicates.isType '"Array",
            cgo_gcc_binary_name = predicates.isType '"String",
            cgo_gxx_binary_name = predicates.isType '"String",
            cgo_linker_flags = predicates.isType '"Array",
            cgo_tool_search_paths = predicates.isType '"Array",
            external_linker_binary_name = predicates.isType '"String",
            go_search_paths = predicates.isType '"Array",
            minimum_expected_version = predicates.isType '"String",
            subprocess_env_vars = predicates.isType '"Array",
            tailor_binary_targets = predicates.isType '"Bool",
            tailor_go_mod_targets = predicates.isType '"Bool",
            tailor_package_targets = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    google-java-format = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            aosp = predicates.isType '"Bool",
            artifacts = predicates.isType '"Array",
            jvm_options = predicates.isType '"Array",
            lockfile = predicates.isType '"String",
            skip = predicates.isType '"Bool",
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    graphql = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          { open_graphiql = predicates.isType '"Bool", }
          {  }
          true
          predicates.always
        ],
    hadolint = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            config = predicates.always,
            config_discovery = predicates.isType '"Bool",
            known_versions = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
            url_platform_mapping = predicates.isType 'Record,
            url_template = predicates.isType '"String",
            use_unsupported_version = predicates.enum [ "error", "warning" ],
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    help = predicates.isType 'Record,
    help-advanced = predicates.isType 'Record,
    help-all = predicates.isType 'Record,
    internal-generate-test-lockfile-fixtures = predicates.isType 'Record,
    ipython = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            console_script = predicates.isType '"String",
            entry_point = predicates.isType '"String",
            ignore_cwd = predicates.isType '"Bool",
            install_from_resolve = predicates.isType '"String",
            requirements = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    isort = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            config = predicates.isType '"Array",
            config_discovery = predicates.isType '"Bool",
            console_script = predicates.isType '"String",
            entry_point = predicates.isType '"String",
            install_from_resolve = predicates.isType '"String",
            interpreter_constraints = predicates.isType '"Array",
            requirements = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    jarjar = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            artifacts = predicates.isType '"Array",
            jvm_options = predicates.isType '"Array",
            lockfile = predicates.isType '"String",
            misplaced_class_strategy = predicates.enum
                [ "fatal", "skip", "omit", "move" ],
            skip_manifest = predicates.isType '"Bool",
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    java-dump-source-analysis = predicates.isType 'Record,
    java-infer = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            consumed_types = predicates.isType '"Bool",
            imports = predicates.isType '"Bool",
            third_party_import_mapping = predicates.isType 'Record,
          }
          {  }
          true
          predicates.always
        ],
    javac = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            tailor_source_targets = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    junit = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            artifacts = predicates.isType '"Array",
            jvm_options = predicates.isType '"Array",
            lockfile = predicates.isType '"String",
            skip = predicates.isType '"Bool",
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    jvm = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            debug_args = predicates.isType '"Array",
            default_resolve = predicates.isType '"String",
            global_options = predicates.isType '"Array",
            jdk = predicates.isType '"String",
            nailgun_remote_cache_speculation_delay = predicates.isType
                '"Number",
            reproducible_jars = predicates.isType '"Bool",
            resolves = predicates.isType 'Record,
            tool_jdk = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    jvm-symbol-map = predicates.isType 'Record,
    lint = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            batch_size = predicates.isType '"Number",
            only = predicates.isType '"Array",
            skip_fixers = predicates.isType '"Bool",
            skip_formatters = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    list = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            documented = predicates.isType '"Bool",
            output_file = predicates.isType '"String",
            sep = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    mypy = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            config = predicates.always,
            config_discovery = predicates.isType '"Bool",
            console_script = predicates.isType '"String",
            entry_point = predicates.isType '"String",
            install_from_resolve = predicates.isType '"String",
            interpreter_constraints = predicates.isType '"Array",
            requirements = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
            source_plugins = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    nodejs = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            corepack_env_vars = predicates.isType '"Array",
            executable_search_paths = predicates.isType '"Array",
            known_versions = predicates.isType '"Array",
            package_manager = predicates.isType '"String",
            package_managers = predicates.isType 'Record,
            resolves = predicates.isType 'Record,
            search_path = predicates.isType '"Array",
            url_platform_mapping = predicates.isType 'Record,
            url_template = predicates.isType '"String",
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    nodejs-infer = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            imports = predicates.isType '"Bool",
            package_json_entry_points = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    nodejs-test = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            coverage_output_dir = predicates.isType '"String",
            skip = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    package = predicates.isType 'Record,
    pants-releases = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          { release_notes = predicates.isType 'Record, }
          {  }
          true
          predicates.always
        ],
    paths = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            from = predicates.isType '"String",
            output_file = predicates.isType '"String",
            to = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    peek = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            exclude_defaults = predicates.isType '"Bool",
            include_dep_rules = predicates.isType '"Bool",
            output_file = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    pex = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            executable_search_paths = predicates.isType '"Array",
            venv_use_symlinks = predicates.isType '"Bool",
            verbosity = predicates.isType '"Number",
          }
          {  }
          true
          predicates.always
        ],
    pex-binary-defaults = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            emit_warnings = predicates.isType '"Bool",
            resolve_local_platforms = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    pex-cli = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            known_versions = predicates.isType '"Array",
            url_platform_mapping = predicates.isType 'Record,
            url_template = predicates.isType '"String",
            use_unsupported_version = predicates.enum [ "error", "warning" ],
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    preamble = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            skip = predicates.isType '"Bool",
            template_by_globs = predicates.oneOf
                [ predicates.isType 'Record, predicates.isType '"String" ],
          }
          {  }
          true
          predicates.always
        ],
    prettier = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    publish = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record { output = predicates.isType '"String", }
          {  }
          true
          predicates.always
        ],
    py-constraints = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            output_file = predicates.isType '"String",
            summary = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    pyoxidizer = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            console_script = predicates.isType '"String",
            entry_point = predicates.isType '"String",
            install_from_resolve = predicates.isType '"String",
            interpreter_constraints = predicates.isType '"Array",
            requirements = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    pytest = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            config = predicates.always,
            config_discovery = predicates.isType '"Bool",
            console_script = predicates.isType '"String",
            entry_point = predicates.isType '"String",
            execution_slot_var = predicates.isType '"String",
            install_from_resolve = predicates.isType '"String",
            junit_family = predicates.isType '"String",
            requirements = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
            xdist_enabled = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    python = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            default_resolve = predicates.isType '"String",
            default_run_goal_use_sandbox = predicates.isType '"Bool",
            enable_lockfile_targets = predicates.isType '"Bool",
            enable_resolves = predicates.isType '"Bool",
            interpreter_constraints = predicates.isType '"Array",
            interpreter_versions_universe = predicates.isType '"Array",
            invalid_lockfile_behavior = predicates.enum
                [ "error", "ignore", "warn" ],
            macos_big_sur_compatibility = predicates.isType '"Bool",
            pip_version = predicates.enum
                [
                  "20.3.4-patched",
                  "22.2.2",
                  "22.3",
                  "22.3.1",
                  "23.0",
                  "23.0.1",
                  "23.1",
                  "23.1.1",
                  "23.1.2",
                  "latest"
                ],
            repl_history = predicates.isType '"Bool",
            resolver_manylinux = predicates.isType '"String",
            resolves = predicates.isType 'Record,
            resolves_generate_lockfiles = predicates.isType '"Bool",
            resolves_to_constraints_file = predicates.isType 'Record,
            resolves_to_interpreter_constraints = predicates.isType 'Record,
            resolves_to_no_binary = predicates.isType 'Record,
            resolves_to_only_binary = predicates.isType 'Record,
            run_against_entire_lockfile = predicates.isType '"Bool",
            tailor_ignore_empty_init_files = predicates.isType '"Bool",
            tailor_pex_binary_targets = predicates.isType '"Bool",
            tailor_py_typed_targets = predicates.isType '"Bool",
            tailor_requirements_targets = predicates.isType '"Bool",
            tailor_source_targets = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    python-bootstrap = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            internal_python_build_standalone_info = predicates.isType 'Record,
            names = predicates.isType '"Array",
            search_path = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    python-dump-source-analysis = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            analysis_flavor = predicates.enum
                [ "raw_dependency_inference", "dependency_inference" ],
          }
          {  }
          true
          predicates.always
        ],
    python-infer = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            ambiguity_resolution = predicates.enum [ "none", "by_source_root" ],
            assets = predicates.isType '"Bool",
            assets_min_slashes = predicates.isType '"Number",
            conftests = predicates.isType '"Bool",
            entry_points = predicates.isType '"Bool",
            ignored_unowned_imports = predicates.isType '"Array",
            imports = predicates.isType '"Bool",
            init_files = predicates.enum [ "always", "content_only", "never" ],
            string_imports = predicates.isType '"Bool",
            string_imports_min_dots = predicates.isType '"Number",
            unowned_dependency_behavior = predicates.enum
                [ "error", "warning", "ignore" ],
            use_rust_parser = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    python-native-code = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            cpp_flags = predicates.isType '"Array",
            ld_flags = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    python-repos = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            find_links = predicates.isType '"Array",
            indexes = predicates.isType '"Array",
            path_mappings = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    regex-lint = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            config = predicates.oneOf
                [ predicates.isType 'Record, predicates.isType '"String" ],
            detail_level = predicates.enum
                [ "none", "summary", "nonmatching", "names", "all" ],
            skip = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    repl = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            restartable = predicates.isType '"Bool",
            shell = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    roots = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            output_file = predicates.isType '"String",
            sep = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    run = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            debug_adapter = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    scala = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            tailor_source_targets = predicates.isType '"Bool",
            version_for_resolve = predicates.isType 'Record,
          }
          {  }
          true
          predicates.always
        ],
    scala-dump-source-analysis = predicates.isType 'Record,
    scala-infer = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            consumed_types = predicates.isType '"Bool",
            force_add_siblings_as_dependencies = predicates.isType '"Bool",
            imports = predicates.isType '"Bool",
            package_objects = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    scalac = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            plugins_for_resolve = predicates.isType 'Record,
          }
          {  }
          true
          predicates.always
        ],
    scalafmt = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            artifacts = predicates.isType '"Array",
            jvm_options = predicates.isType '"Array",
            lockfile = predicates.isType '"String",
            skip = predicates.isType '"Bool",
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    scalatest = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            artifacts = predicates.isType '"Array",
            jvm_options = predicates.isType '"Array",
            lockfile = predicates.isType '"String",
            skip = predicates.isType '"Bool",
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    scc = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            known_versions = predicates.isType '"Array",
            url_platform_mapping = predicates.isType 'Record,
            url_template = predicates.isType '"String",
            use_unsupported_version = predicates.enum [ "error", "warning" ],
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    setup-py-generation = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            first_party_dependency_version_scheme = predicates.enum
                [ "exact", "compatible", "any" ],
            generate_setup_default = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    setuptools = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            install_from_resolve = predicates.isType '"String",
            requirements = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    setuptools-scm = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            console_script = predicates.isType '"String",
            entry_point = predicates.isType '"String",
            install_from_resolve = predicates.isType '"String",
            interpreter_constraints = predicates.isType '"Array",
            requirements = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    shell-setup = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            dependency_inference = predicates.isType '"Bool",
            executable_search_paths = predicates.isType '"Array",
            tailor = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    shell-test = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record { skip = predicates.isType '"Bool", } {  }
          true
          predicates.always
        ],
    shellcheck = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            config_discovery = predicates.isType '"Bool",
            known_versions = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
            url_platform_mapping = predicates.isType 'Record,
            url_template = predicates.isType '"String",
            use_unsupported_version = predicates.enum [ "error", "warning" ],
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    shfmt = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            config_discovery = predicates.isType '"Bool",
            known_versions = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
            url_platform_mapping = predicates.isType 'Record,
            url_template = predicates.isType '"String",
            use_unsupported_version = predicates.enum [ "error", "warning" ],
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    shunit2 = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            known_versions = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
            url_platform_mapping = predicates.isType 'Record,
            url_template = predicates.isType '"String",
            use_unsupported_version = predicates.enum [ "error", "warning" ],
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    source = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            marker_filenames = predicates.isType '"Array",
            root_patterns = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    stats = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            log = predicates.isType '"Bool",
            memory_summary = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    subprocess-environment = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record { env_vars = predicates.isType '"Array", }
          {  }
          true
          predicates.always
        ],
    tailor = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            alias_mapping = predicates.isType 'Record,
            build_file_header = predicates.isType '"String",
            build_file_indent = predicates.isType '"String",
            build_file_name = predicates.isType '"String",
            check = predicates.isType '"Bool",
            ignore_adding_targets = predicates.isType '"Array",
            ignore_paths = predicates.isType '"Array",
          }
          {  }
          true
          predicates.always
        ],
    test = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            batch_size = predicates.isType '"Number",
            debug = predicates.isType '"Bool",
            debug_adapter = predicates.isType '"Bool",
            extra_env_vars = predicates.isType '"Array",
            "force" = predicates.isType '"Bool",
            open_coverage = predicates.isType '"Bool",
            output = predicates.enum [ "all", "failed", "none" ],
            report = predicates.isType '"Bool",
            report_dir = predicates.isType '"String",
            shard = predicates.isType '"String",
            timeout_default = predicates.isType '"Number",
            timeout_maximum = predicates.isType '"Number",
            timeouts = predicates.isType '"Bool",
            use_coverage = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    twine = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            ca_certs_path = predicates.isType '"String",
            config = predicates.always,
            config_discovery = predicates.isType '"Bool",
            console_script = predicates.isType '"String",
            entry_point = predicates.isType '"String",
            install_from_resolve = predicates.isType '"String",
            interpreter_constraints = predicates.isType '"Array",
            requirements = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
          }
          {  }
          true
          predicates.always
        ],
    update-build-files = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            check = predicates.isType '"Bool",
            fix_safe_deprecations = predicates.isType '"Bool",
            fmt = predicates.isType '"Bool",
            formatter = predicates.enum [ "yapf", "black" ],
          }
          {  }
          true
          predicates.always
        ],
    version = predicates.isType 'Record,
    workunit-logger = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            enabled = predicates.isType '"Bool",
            logdir = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    yapf = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            args = predicates.isType '"Array",
            config = predicates.always,
            config_discovery = predicates.isType '"Bool",
            console_script = predicates.isType '"String",
            entry_point = predicates.isType '"String",
            install_from_resolve = predicates.isType '"String",
            interpreter_constraints = predicates.isType '"Array",
            requirements = predicates.isType '"Array",
            skip = predicates.isType '"Bool",
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