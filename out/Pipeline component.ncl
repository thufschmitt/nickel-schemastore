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
          ArgumentType = predicates.contract_from_predicate
              definitions.predicate.ArgumentType,
          CachingStrategySpec
            | doc m%"
            Optional configuration that specifies how the task execution may be skipped if the output data exist in cache.
            "%
            = { maxCacheStaleness | String | optional, },
          ComponentReference
            | doc m%"
            Component reference. Contains information that can be used to locate and load a component by name, digest or URL
            "%
            = {
                digest | String | optional,
                name | String | optional,
                spec | definitions.contract.ComponentSpec | optional,
                tag | String | optional,
                url | String | optional,
              },
          ComponentSpec
            | doc m%"
            Component specification. Describes the metadata (name, description, source), the interface (inputs and outputs) and the implementation of the component.
            "%
            = {
                description | String | optional,
                implementation | definitions.contract.ImplementationType,
                inputs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.InputSpec
                  ])
                  | optional,
                metadata | definitions.contract.MetadataSpec | optional,
                name | String | optional,
                outputs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.OutputSpec
                  ])
                  | optional,
              },
          ConcatPlaceholder
            | doc m%"
            Represents the command-line argument placeholder that will be replaced at run-time by the concatenated values of its items.
            "%
            = {
                concat
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.StringOrPlaceholder
                  ])
                  | doc m%"
                  Items to concatenate
                  "%,
              },
          ContainerImplementation
            | doc m%"
            Represents the container component implementation.
            "%
            = { container | definitions.contract.ContainerSpec, .. },
          ContainerSpec = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.StringOrPlaceholder
                  ])
                  | doc m%"
                  Arguments to the entrypoint. The docker image's CMD is used if this is not provided.
                  "%
                  | optional,
                command
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.StringOrPlaceholder
                  ])
                  | doc m%"
                  Entrypoint array. Not executed within a shell. The docker image's ENTRYPOINT is used if this is not provided.
                  "%
                  | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.StringOrPlaceholder
                  ])
                  | doc m%"
                  List of environment variables to set in the container.
                  "%
                  | optional,
                image
                  | definitions.contract.StringOrPlaceholder
                  | doc m%"
                  Docker image name.
                  "%,
              },
          ExecutionOptionsSpec
            | doc m%"
            Optional configuration that specifies how the task should be executed. Can be used to set some platform-specific options.
            "%
            = {
                cachingStrategy
                  | definitions.contract.CachingStrategySpec
                  | optional,
                retryStrategy
                  | definitions.contract.RetryStrategySpec
                  | optional,
              },
          GraphImplementation
            | doc m%"
            Represents the graph component implementation.
            "%
            = { graph | definitions.contract.GraphSpec, },
          GraphInputArgument
            | doc m%"
            Represents the component argument value that comes from the graph component input.
            "%
            = {
                graphInput
                  | {
                    inputName | String,
                    type | definitions.contract.TypeSpecType | optional,
                  }
                  | doc m%"
                  References the input of the graph/pipeline.
                  "%,
              },
          GraphSpec
            | doc m%"
            Describes the graph component implementation. It represents a graph of component tasks connected to the upstream sources of data using the argument specifications. It also describes the sources of graph output values.
            "%
            = {
                outputValues
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.TaskOutputArgument
                  ])
                  | optional,
                tasks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.TaskSpec
                  ]),
              },
          IfConditionArgumentType = predicates.contract_from_predicate
              definitions.predicate.IfConditionArgumentType,
          IfPlaceholder
            | doc m%"
            Represents the command-line argument placeholder that will be replaced at run-time by a boolean value specifying whether the caller has passed an argument for the specified optional input.
            "%
            = {
                "if"
                  | {
                    cond | definitions.contract.IfConditionArgumentType,
                    "else"
                      | definitions.contract.ListOfStringsOrPlaceholders
                      | optional,
                    "then" | definitions.contract.ListOfStringsOrPlaceholders,
                    ..
                  },
                ..
              },
          ImplementationType = predicates.contract_from_predicate
              definitions.predicate.ImplementationType,
          InputPathPlaceholder
            | doc m%"
            Represents the command-line argument placeholder that will be replaced at run-time by a local file path pointing to a file containing the input argument value.
            "%
            = {
                inputPath
                  | String
                  | doc m%"
                  Name of the input.
                  "%,
              },
          InputSpec = predicates.contract_from_predicate
              definitions.predicate.InputSpec,
          InputValuePlaceholder
            | doc m%"
            Represents the command-line argument placeholder that will be replaced at run-time by the input argument value.
            "%
            = {
                inputValue
                  | String
                  | doc m%"
                  Name of the input.
                  "%,
              },
          IsPresentPlaceholder
            | doc m%"
            Represents the command-line argument placeholder that will be replaced at run-time by a boolean value specifying whether the caller has passed an argument for the specified optional input.
            "%
            = {
                isPresent
                  | String
                  | doc m%"
                  Name of the input.
                  "%,
              },
          ListOfStringsOrPlaceholders = predicates.contract_from_predicate
              definitions.predicate.ListOfStringsOrPlaceholders,
          MetadataSpec = { annotations | {  .. } | optional, },
          OutputPathPlaceholder
            | doc m%"
            Represents the command-line argument placeholder that will be replaced at run-time by a local file path pointing to a file where the program should write its output data.
            "%
            = {
                outputPath
                  | String
                  | doc m%"
                  Name of the output.
                  "%,
              },
          OutputSpec
            | doc m%"
            Describes the component output specification
            "%
            = {
                annotations | {  .. } | optional,
                description | String | optional,
                name | String,
                type | definitions.contract.TypeSpecType | optional,
              },
          PipelineRunSpec
            | doc m%"
            The object that can be sent to the backend to start a new Run.
            "%
            = {
                onExitTask | definitions.contract.TaskSpec | optional,
                rootTask | definitions.contract.TaskSpec,
              },
          PredicateType = predicates.contract_from_predicate
              definitions.predicate.PredicateType,
          RetryStrategySpec
            | doc m%"
            Optional configuration that specifies how the task should be retried if it fails.
            "%
            = { maxRetries | std.number.Integer | optional, },
          StringOrPlaceholder = predicates.contract_from_predicate
              definitions.predicate.StringOrPlaceholder,
          TaskOutputArgument
            | doc m%"
            Represents the component argument value that comes from the output of a sibling task.
            "%
            = {
                taskOutput
                  | {
                    outputName | String,
                    taskId | String,
                    type | definitions.contract.TypeSpecType | optional,
                  }
                  | doc m%"
                  References the output of a sibling task.
                  "%,
              },
          TaskSpec
            | doc m%"
            'Task specification. Task is a configured component - a component supplied with arguments and other applied configuration changes.
            "%
            = {
                annotations | {  .. } | optional,
                arguments
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.ArgumentType
                  ])
                  | optional,
                componentRef | definitions.contract.ComponentReference,
                executionOptions
                  | definitions.contract.ExecutionOptionsSpec
                  | optional,
                isEnabled | definitions.contract.PredicateType | optional,
              },
          TwoArgumentOperands
            | doc m%"
            Pair of operands for a binary operation.
            "%
            = {
                op1 | definitions.contract.ArgumentType,
                op2 | definitions.contract.ArgumentType,
              },
          TwoLogicalOperands
            | doc m%"
            Pair of operands for a binary logical operation.
            "%
            = {
                op1 | definitions.contract.PredicateType,
                op2 | definitions.contract.PredicateType,
              },
          TypeSpecType = predicates.contract_from_predicate
              definitions.predicate.TypeSpecType,
        },
    predicate = {
          ArgumentType = predicates.oneOf
              [
                predicates.isType '"String",
                definitions.predicate.GraphInputArgument,
                definitions.predicate.TaskOutputArgument
              ],
          CachingStrategySpec
            | doc m%"
            Optional configuration that specifies how the task execution may be skipped if the output data exist in cache.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { maxCacheStaleness = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          ComponentReference
            | doc m%"
            Component reference. Contains information that can be used to locate and load a component by name, digest or URL
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  digest = predicates.isType '"String",
                  name = predicates.isType '"String",
                  spec = definitions.predicate.ComponentSpec,
                  tag = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ComponentSpec
            | doc m%"
            Component specification. Describes the metadata (name, description, source), the interface (inputs and outputs) and the implementation of the component.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "implementation" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  implementation = definitions.predicate.ImplementationType,
                  inputs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.InputSpec
                      ],
                  metadata = definitions.predicate.MetadataSpec,
                  name = predicates.isType '"String",
                  outputs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.OutputSpec
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ConcatPlaceholder
            | doc m%"
            Represents the command-line argument placeholder that will be replaced at run-time by the concatenated values of its items.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "concat" ],
                predicates.records.record
                {
                  concat = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.StringOrPlaceholder
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ContainerImplementation
            | doc m%"
            Represents the container component implementation.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "container" ],
                predicates.records.record
                { container = definitions.predicate.ContainerSpec, }
                {  }
                true
                predicates.always
              ],
          ContainerSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image" ],
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.StringOrPlaceholder
                      ],
                  command = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.StringOrPlaceholder
                      ],
                  env = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.StringOrPlaceholder
                      ],
                  image = definitions.predicate.StringOrPlaceholder,
                }
                {  }
                false
                predicates.never
              ],
          ExecutionOptionsSpec
            | doc m%"
            Optional configuration that specifies how the task should be executed. Can be used to set some platform-specific options.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cachingStrategy = definitions.predicate.CachingStrategySpec,
                  retryStrategy = definitions.predicate.RetryStrategySpec,
                }
                {  }
                false
                predicates.never
              ],
          GraphImplementation
            | doc m%"
            Represents the graph component implementation.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "graph" ],
                predicates.records.record
                { graph = definitions.predicate.GraphSpec, }
                {  }
                false
                predicates.never
              ],
          GraphInputArgument
            | doc m%"
            Represents the component argument value that comes from the graph component input.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "graphInput" ],
                predicates.records.record
                {
                  graphInput = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "inputName" ],
                        predicates.records.record
                        {
                          inputName = predicates.isType '"String",
                          type = definitions.predicate.TypeSpecType,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                false
                predicates.never
              ],
          GraphSpec
            | doc m%"
            Describes the graph component implementation. It represents a graph of component tasks connected to the upstream sources of data using the argument specifications. It also describes the sources of graph output values.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tasks" ],
                predicates.records.record
                {
                  outputValues = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.TaskOutputArgument
                      ],
                  tasks = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.TaskSpec
                      ],
                }
                {  }
                false
                predicates.never
              ],
          IfConditionArgumentType = predicates.oneOf
              [
                definitions.predicate.IsPresentPlaceholder,
                predicates.isType '"Bool",
                predicates.isType '"String",
                definitions.predicate.InputValuePlaceholder
              ],
          IfPlaceholder
            | doc m%"
            Represents the command-line argument placeholder that will be replaced at run-time by a boolean value specifying whether the caller has passed an argument for the specified optional input.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "if" ],
                predicates.records.record
                {
                  "if" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "cond", "then" ],
                        predicates.records.record
                        {
                          cond = definitions.predicate.IfConditionArgumentType,
                          "else" =
                            definitions.predicate.ListOfStringsOrPlaceholders,
                          "then" =
                            definitions.predicate.ListOfStringsOrPlaceholders,
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
          ImplementationType = predicates.oneOf
              [
                definitions.predicate.ContainerImplementation,
                definitions.predicate.GraphImplementation
              ],
          InputPathPlaceholder
            | doc m%"
            Represents the command-line argument placeholder that will be replaced at run-time by a local file path pointing to a file containing the input argument value.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "inputPath" ],
                predicates.records.record
                { inputPath = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          InputSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  annotations = predicates.isType 'Record,
                  "default" = predicates.isType '"String",
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                  type = definitions.predicate.TypeSpecType,
                }
                {  }
                false
                predicates.never
              ],
          InputValuePlaceholder
            | doc m%"
            Represents the command-line argument placeholder that will be replaced at run-time by the input argument value.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "inputValue" ],
                predicates.records.record
                { inputValue = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          IsPresentPlaceholder
            | doc m%"
            Represents the command-line argument placeholder that will be replaced at run-time by a boolean value specifying whether the caller has passed an argument for the specified optional input.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "isPresent" ],
                predicates.records.record
                { isPresent = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          ListOfStringsOrPlaceholders = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.StringOrPlaceholder
              ],
          MetadataSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { annotations = predicates.isType 'Record, }
                {  }
                false
                predicates.never
              ],
          OutputPathPlaceholder
            | doc m%"
            Represents the command-line argument placeholder that will be replaced at run-time by a local file path pointing to a file where the program should write its output data.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "outputPath" ],
                predicates.records.record
                { outputPath = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          OutputSpec
            | doc m%"
            Describes the component output specification
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  annotations = predicates.isType 'Record,
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  type = definitions.predicate.TypeSpecType,
                }
                {  }
                false
                predicates.never
              ],
          PipelineRunSpec
            | doc m%"
            The object that can be sent to the backend to start a new Run.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "rootTask" ],
                predicates.records.record
                {
                  onExitTask = definitions.predicate.TaskSpec,
                  rootTask = definitions.predicate.TaskSpec,
                }
                {  }
                false
                predicates.never
              ],
          PredicateType = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "==" ],
                  predicates.records.record
                  { "==" = definitions.predicate.TwoArgumentOperands, }
                  {  }
                  true
                  predicates.always
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "!=" ],
                  predicates.records.record
                  { "!=" = definitions.predicate.TwoArgumentOperands, }
                  {  }
                  true
                  predicates.always
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ ">" ],
                  predicates.records.record
                  { ">" = definitions.predicate.TwoArgumentOperands, }
                  {  }
                  true
                  predicates.always
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ ">=" ],
                  predicates.records.record
                  { ">=" = definitions.predicate.TwoArgumentOperands, }
                  {  }
                  true
                  predicates.always
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "<" ],
                  predicates.records.record
                  { "<" = definitions.predicate.TwoArgumentOperands, }
                  {  }
                  true
                  predicates.always
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "<=" ],
                  predicates.records.record
                  { "<=" = definitions.predicate.TwoArgumentOperands, }
                  {  }
                  true
                  predicates.always
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "and" ],
                  predicates.records.record
                  { and = definitions.predicate.TwoLogicalOperands, }
                  {  }
                  true
                  predicates.always
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "or" ],
                  predicates.records.record
                  { or = definitions.predicate.TwoLogicalOperands, }
                  {  }
                  true
                  predicates.always
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "not" ],
                  predicates.records.record
                  { not = definitions.predicate.PredicateType, }
                  {  }
                  true
                  predicates.always
                ]
              ],
          RetryStrategySpec
            | doc m%"
            Optional configuration that specifies how the task should be retried if it fails.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { maxRetries = predicates.isType 'Integer, }
                {  }
                false
                predicates.never
              ],
          StringOrPlaceholder = predicates.oneOf
              [
                predicates.isType '"String",
                definitions.predicate.InputValuePlaceholder,
                definitions.predicate.InputPathPlaceholder,
                definitions.predicate.OutputPathPlaceholder,
                definitions.predicate.ConcatPlaceholder,
                definitions.predicate.IfPlaceholder
              ],
          TaskOutputArgument
            | doc m%"
            Represents the component argument value that comes from the output of a sibling task.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "taskOutput" ],
                predicates.records.record
                {
                  taskOutput = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "outputName", "taskId" ],
                        predicates.records.record
                        {
                          outputName = predicates.isType '"String",
                          taskId = predicates.isType '"String",
                          type = definitions.predicate.TypeSpecType,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                false
                predicates.never
              ],
          TaskSpec
            | doc m%"
            'Task specification. Task is a configured component - a component supplied with arguments and other applied configuration changes.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "componentRef" ],
                predicates.records.record
                {
                  annotations = predicates.isType 'Record,
                  arguments = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.ArgumentType
                      ],
                  componentRef = definitions.predicate.ComponentReference,
                  executionOptions = definitions.predicate.ExecutionOptionsSpec,
                  isEnabled = definitions.predicate.PredicateType,
                }
                {  }
                false
                predicates.never
              ],
          TwoArgumentOperands
            | doc m%"
            Pair of operands for a binary operation.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "op1", "op2" ],
                predicates.records.record
                {
                  op1 = definitions.predicate.ArgumentType,
                  op2 = definitions.predicate.ArgumentType,
                }
                {  }
                false
                predicates.never
              ],
          TwoLogicalOperands
            | doc m%"
            Pair of operands for a binary logical operation.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "op1", "op2" ],
                predicates.records.record
                {
                  op1 = definitions.predicate.PredicateType,
                  op2 = definitions.predicate.PredicateType,
                }
                {  }
                false
                predicates.never
              ],
          TypeSpecType = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true
                  definitions.predicate.TypeSpecType
                ]
              ],
        },
  }
in

predicates.contract_from_predicate definitions.predicate.ComponentSpec