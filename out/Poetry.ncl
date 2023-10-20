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
          poetry-author-pattern
            | doc m%"
            Pattern that matches `Name <email>` like 'King Arthur' or 'Miss Islington &lt;miss-islington@python.org&gt;'.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.poetry-author-pattern,
          poetry-authors
            | doc m%"
            List of authors that contributed to the package. This is typically the main maintainers, not the full list.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.poetry-authors,
          poetry-build-config
            | doc m%"
            Build specific configurations.
            "%
            = {
                generate-setup-file
                  | Bool
                  | doc m%"
                  Generate and include a setup.py file in sdist.
                  "%
                  | optional,
                script | definitions.contract.poetry-build-script | optional,
              },
          poetry-build-script
            | doc m%"
            The python script file used to build extensions.
            "%
            = String,
          poetry-build-section = predicates.contract_from_predicate
              definitions.predicate.poetry-build-section,
          poetry-dependency = definitions.contract.poetry-pep440-version,
          poetry-dependency-any = predicates.contract_from_predicate
              definitions.predicate.poetry-dependency-any,
          poetry-extra-script-legacy
            | doc m%"
            A script that should be installed only if extras are activated.
            "%
            = {
                callable
                  | definitions.contract.poetry-script-legacy
                  | doc m%"
                  The entry point of the script. Deprecated in favour of reference.
                  "%
                  | optional,
                extras
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The required extras for this script.
                  "%
                  | optional,
              },
          poetry-extra-scripts
            | doc m%"
            Either a console entry point or a script file that'll be included in the distribution package.
            "%
            = {
                extras
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The required extras for this script. Only applicable if type is console.
                  "%
                  | optional,
                reference
                  | String
                  | doc m%"
                  If type is file this is the relative path of the script file, if console it is the module name.
                  "%,
                type
                  | std.enum.TagOrString
                  | [| 'console, 'file |]
                  | doc m%"
                  Value can be either file or console.
                  "%,
              },
          poetry-file-dependency = {
                extras
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The required extras for this dependency.
                  "%
                  | optional,
                file
                  | String
                  | doc m%"
                  The path to the file.
                  "%,
                markers
                  | String
                  | doc m%"
                  The PEP 508 compliant environment markers for which the dependency should be installed.
                  "%
                  | optional,
                "optional"
                  | Bool
                  | doc m%"
                  Whether the dependency is optional or not.
                  "%
                  | optional,
                platform
                  | String
                  | doc m%"
                  The platform(s) for which the dependency should be installed.
                  "%
                  | optional,
                python
                  | String
                  | doc m%"
                  The python versions for which the dependency should be installed.
                  "%
                  | optional,
              },
          poetry-git-dependency = {
                allow-prereleases
                  | Bool
                  | doc m%"
                  Whether the dependency allows prereleases or not.
                  "%
                  | optional,
                allows-prereleases
                  | Bool
                  | doc m%"
                  Whether the dependency allows prereleases or not.
                  "%
                  | optional,
                branch
                  | String
                  | doc m%"
                  The branch to checkout.
                  "%
                  | optional,
                develop
                  | Bool
                  | doc m%"
                  Whether to install the dependency in development mode.
                  "%
                  | optional,
                extras
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The required extras for this dependency.
                  "%
                  | optional,
                git
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.anyOf
                    [
                      predicates.always,
                      predicates.strings.pattern
                      "^([A-Za-z0-9\\-]+@|https://|http://)[A-Za-z0-9\\-]+\\.[A-Za-z0-9\\-]+(:|/)[A-Za-z0-9\\-]+/[A-Za-z0-9\\-]+\\.git$"
                    ]
                  ])
                  | doc m%"
                  The url of the git repository.
                  "%,
                markers
                  | String
                  | doc m%"
                  The PEP 508 compliant environment markers for which the dependency should be installed.
                  "%
                  | optional,
                "optional"
                  | Bool
                  | doc m%"
                  Whether the dependency is optional or not.
                  "%
                  | optional,
                platform
                  | String
                  | doc m%"
                  The platform(s) for which the dependency should be installed.
                  "%
                  | optional,
                python
                  | String
                  | doc m%"
                  The python versions for which the dependency should be installed.
                  "%
                  | optional,
                rev
                  | String
                  | doc m%"
                  The revision to checkout.
                  "%
                  | optional,
                subdirectory
                  | String
                  | doc m%"
                  The relative path to the directory where the package is located.
                  "%
                  | optional,
                tag
                  | String
                  | doc m%"
                  The tag to checkout.
                  "%
                  | optional,
              },
          poetry-include-path
            | doc m%"
            Path to file or directory to include.
            "%
            = String,
          poetry-long-dependency = {
                allow-prereleases
                  | Bool
                  | doc m%"
                  Whether the dependency allows prereleases or not.
                  "%
                  | optional,
                allows-prereleases
                  | Bool
                  | doc m%"
                  Whether the dependency allows prereleases or not.
                  "%
                  | optional,
                extras
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The required extras for this dependency.
                  "%
                  | optional,
                markers
                  | String
                  | doc m%"
                  The PEP 508 compliant environment markers for which the dependency should be installed.
                  "%
                  | optional,
                "optional"
                  | Bool
                  | doc m%"
                  Whether the dependency is optional or not.
                  "%
                  | optional,
                platform
                  | String
                  | doc m%"
                  The platform(s) for which the dependency should be installed.
                  "%
                  | optional,
                python
                  | String
                  | doc m%"
                  The python versions for which the dependency should be installed.
                  "%
                  | optional,
                source
                  | String
                  | doc m%"
                  The exclusive source used to search for this dependency.
                  "%
                  | optional,
                version | definitions.contract.poetry-pep440-version,
              },
          poetry-maintainers
            | doc m%"
            List of maintainers, other than the original author(s), that upkeep the package.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.poetry-maintainers,
          poetry-multiple-constraints-dependency =
            predicates.contract_from_predicate
              definitions.predicate.poetry-multiple-constraints-dependency,
          poetry-package-format
            | doc m%"
            A Python packaging format.
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| 'wheel, 'sdist |] ],
          poetry-package-formats
            | doc m%"
            The format(s) for which the package must be included.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.poetry-package-formats,
          poetry-path-dependency = {
                develop
                  | Bool
                  | doc m%"
                  Whether to install the dependency in development mode.
                  "%
                  | optional,
                extras
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The required extras for this dependency.
                  "%
                  | optional,
                markers
                  | String
                  | doc m%"
                  The PEP 508 compliant environment markers for which the dependency should be installed.
                  "%
                  | optional,
                "optional"
                  | Bool
                  | doc m%"
                  Whether the dependency is optional or not.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  The path to the dependency.
                  "%,
                platform
                  | String
                  | doc m%"
                  The platform(s) for which the dependency should be installed.
                  "%
                  | optional,
                python
                  | String
                  | doc m%"
                  The python versions for which the dependency should be installed.
                  "%
                  | optional,
              },
          poetry-pep440-version
            | doc m%"
            A version constraint. Validates against the PEP 440's version pattern.
            "%
            = String,
          poetry-script-legacy
            | doc m%"
            A simple script pointing to a callable object.
            "%
            = String,
          poetry-script-table = predicates.contract_from_predicate
              definitions.predicate.poetry-script-table,
          poetry-url-dependency = {
                extras
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The required extras for this dependency.
                  "%
                  | optional,
                markers
                  | String
                  | doc m%"
                  The PEP 508 compliant environment markers for which the dependency should be installed.
                  "%
                  | optional,
                "optional"
                  | Bool
                  | doc m%"
                  Whether the dependency is optional or not.
                  "%
                  | optional,
                platform
                  | String
                  | doc m%"
                  The platform(s) for which the dependency should be installed.
                  "%
                  | optional,
                python
                  | String
                  | doc m%"
                  The python versions for which the dependency should be installed.
                  "%
                  | optional,
                url
                  | String
                  | doc m%"
                  The url to the file.
                  "%,
              },
        },
    predicate = {
          poetry-author-pattern
            | doc m%"
            Pattern that matches `Name <email>` like 'King Arthur' or 'Miss Islington &lt;miss-islington@python.org&gt;'.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^(?:[- .,\\w\\d'’\"():&]+)(?: <(?:.+?)>)?"
              ],
          poetry-authors
            | doc m%"
            List of authors that contributed to the package. This is typically the main maintainers, not the full list.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.poetry-author-pattern
              ],
          poetry-build-config
            | doc m%"
            Build specific configurations.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  generate-setup-file = predicates.isType '"Bool",
                  script = definitions.predicate.poetry-build-script,
                }
                {  }
                false
                predicates.never
              ],
          poetry-build-script
            | doc m%"
            The python script file used to build extensions.
            "%
            = predicates.isType '"String",
          poetry-build-section = predicates.oneOf
              [
                definitions.predicate.poetry-build-script,
                definitions.predicate.poetry-build-config
              ],
          poetry-dependency = definitions.predicate.poetry-pep440-version,
          poetry-dependency-any = predicates.oneOf
              [
                definitions.predicate.poetry-dependency,
                definitions.predicate.poetry-long-dependency,
                definitions.predicate.poetry-git-dependency,
                definitions.predicate.poetry-file-dependency,
                definitions.predicate.poetry-path-dependency,
                definitions.predicate.poetry-url-dependency,
                definitions.predicate.poetry-multiple-constraints-dependency
              ],
          poetry-extra-script-legacy
            | doc m%"
            A script that should be installed only if extras are activated.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  callable = definitions.predicate.poetry-script-legacy,
                  extras = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          poetry-extra-scripts
            | doc m%"
            Either a console entry point or a script file that'll be included in the distribution package.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "reference", "type" ],
                predicates.records.record
                {
                  extras = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  reference = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "file", "console" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          poetry-file-dependency = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "file" ],
                predicates.records.record
                {
                  extras = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  file = predicates.isType '"String",
                  markers = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                  platform = predicates.isType '"String",
                  python = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          poetry-git-dependency = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "git" ],
                predicates.records.record
                {
                  allow-prereleases = predicates.isType '"Bool",
                  allows-prereleases = predicates.isType '"Bool",
                  branch = predicates.isType '"String",
                  develop = predicates.isType '"Bool",
                  extras = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  git = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.anyOf
                        [
                          predicates.always,
                          predicates.strings.pattern
                          "^([A-Za-z0-9\\-]+@|https://|http://)[A-Za-z0-9\\-]+\\.[A-Za-z0-9\\-]+(:|/)[A-Za-z0-9\\-]+/[A-Za-z0-9\\-]+\\.git$"
                        ]
                      ],
                  markers = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                  platform = predicates.isType '"String",
                  python = predicates.isType '"String",
                  rev = predicates.isType '"String",
                  subdirectory = predicates.isType '"String",
                  tag = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          poetry-include-path
            | doc m%"
            Path to file or directory to include.
            "%
            = predicates.isType '"String",
          poetry-long-dependency = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "version" ],
                predicates.records.record
                {
                  allow-prereleases = predicates.isType '"Bool",
                  allows-prereleases = predicates.isType '"Bool",
                  extras = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  markers = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                  platform = predicates.isType '"String",
                  python = predicates.isType '"String",
                  source = predicates.isType '"String",
                  version = definitions.predicate.poetry-pep440-version,
                }
                {  }
                false
                predicates.never
              ],
          poetry-maintainers
            | doc m%"
            List of maintainers, other than the original author(s), that upkeep the package.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.poetry-author-pattern
              ],
          poetry-multiple-constraints-dependency = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.oneOf
                [
                  definitions.predicate.poetry-dependency,
                  definitions.predicate.poetry-long-dependency,
                  definitions.predicate.poetry-git-dependency,
                  definitions.predicate.poetry-file-dependency,
                  definitions.predicate.poetry-path-dependency,
                  definitions.predicate.poetry-url-dependency
                ]),
                predicates.arrays.minItems 1
              ],
          poetry-package-format
            | doc m%"
            A Python packaging format.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "sdist", "wheel" ]
              ],
          poetry-package-formats
            | doc m%"
            The format(s) for which the package must be included.
            "%
            = predicates.oneOf
              [
                definitions.predicate.poetry-package-format,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.poetry-package-format
                ]
              ],
          poetry-path-dependency = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  develop = predicates.isType '"Bool",
                  extras = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  markers = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                  path = predicates.isType '"String",
                  platform = predicates.isType '"String",
                  python = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          poetry-pep440-version
            | doc m%"
            A version constraint. Validates against the PEP 440's version pattern.
            "%
            = predicates.isType '"String",
          poetry-script-legacy
            | doc m%"
            A simple script pointing to a callable object.
            "%
            = predicates.isType '"String",
          poetry-script-table = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  definitions.predicate.poetry-extra-script-legacy,
                  definitions.predicate.poetry-extra-scripts
                ]
              ],
          poetry-url-dependency = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "url" ],
                predicates.records.record
                {
                  extras = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  markers = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                  platform = predicates.isType '"String",
                  python = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

{
  authors | definitions.contract.poetry-authors,
  build | definitions.contract.poetry-build-section | optional,
  classifiers
    | Array Dyn
    | doc m%"
    A list of trove classifers.
    "%
    | optional,
  dependencies
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.required [ "python" ],
      predicates.records.record
      {
        python = predicates.allOf
            [
              predicates.isType '"String",
              definitions.predicate.poetry-dependency
            ],
      }
      {
        "^(?!python$)[a-zA-Z-_.0-9]+$" =
          definitions.predicate.poetry-dependency-any,
      }
      true
      predicates.always
    ])
    | doc m%"
    This is a hash of package name (keys) and version constraints (values) that are required to run this package.
    "%
    | optional,
  description
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.pattern "^[^\n]*$" ])
    | doc m%"
    Short package description.
    "%,
  dev-dependencies
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      { "^[a-zA-Z-_.0-9]+$" = definitions.predicate.poetry-dependency-any, }
      true
      predicates.always
    ])
    | doc m%"
    This is a hash of package name (keys) and version constraints (values) that this package requires for developing it (testing tools and such).
    "%
    | optional,
  documentation
    | String
    | doc m%"
    Documentation URL for the project.
    "%
    | optional,
  exclude
    | Array Dyn
    | doc m%"
    A list of files and folders to exclude.
    "%
    | optional,
  extras
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      {
        "^[a-zA-Z-_.0-9]+$" = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ],
      }
      true
      predicates.always
    ])
    | optional,
  group
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      {
        "^[a-zA-Z-_.0-9]+$" = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.required [ "dependencies" ],
              predicates.records.record
              {
                dependencies = predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  }
                      {
                        "^[a-zA-Z-_.0-9]+$" =
                          definitions.predicate.poetry-dependency-any,
                      }
                      false
                      predicates.never
                    ],
                "optional" = predicates.isType '"Bool",
              }
              {  }
              false
              predicates.never
            ],
      }
      true
      predicates.always
    ])
    | doc m%"
    This represents groups of dependencies
    "%
    | optional,
  homepage
    | String
    | doc m%"
    Homepage URL for the project.
    "%
    | optional,
  include
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.anyOf
      [
        definitions.predicate.poetry-include-path,
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "path" ],
          predicates.records.record
          {
            format = definitions.predicate.poetry-package-formats,
            path = definitions.predicate.poetry-include-path,
          }
          {  }
          false
          predicates.never
        ]
      ])
    ])
    | doc m%"
    A list of files and folders to include.
    "%
    | optional,
  keywords
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  license
    | String
    | doc m%"
    License name.
    "%
    | optional,
  maintainers | definitions.contract.poetry-maintainers | optional,
  name
    | String
    | doc m%"
    Package name.
    "%,
  packages
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "include" ],
        predicates.records.record
        {
          format = definitions.predicate.poetry-package-formats,
          from = predicates.isType '"String",
          include = definitions.predicate.poetry-include-path,
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    A list of packages to include in the final distribution.
    "%
    | optional,
  plugins
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      {
        "^[a-zA-Z-_.0-9]+$" = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record {  }
              { "^[a-zA-Z-_.0-9]+$" = predicates.isType '"String", }
              true
              predicates.always
            ],
      }
      true
      predicates.always
    ])
    | doc m%"
    A hash of hashes representing plugins
    "%
    | optional,
  readme
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.isType '"String",
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf (predicates.isType '"String")
      ]
    ])
    | optional,
  repository
    | String
    | doc m%"
    Repository URL for the project.
    "%
    | optional,
  scripts
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      {
        "^[a-zA-Z-_.0-9]+$" = predicates.oneOf
            [
              definitions.predicate.poetry-script-legacy,
              definitions.predicate.poetry-script-table
            ],
      }
      true
      predicates.always
    ])
    | doc m%"
    A hash of scripts to be installed.
    "%
    | optional,
  urls
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } { "^.+$" = predicates.isType '"String", }
      true
      predicates.always
    ])
    | optional,
  version
    | String
    | doc m%"
    Version of the package. It should follow semantic versioning, but it is not enforced.
    "%,
  ..
}