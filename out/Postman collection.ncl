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
          auth
            | doc m%"
            Represents authentication helpers provided by Postman
            "%
            = {
                apikey
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.auth-attribute
                  ])
                  | doc m%"
                  The attributes for API Key Authentication.
                  "%
                  | optional,
                awsv4
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.auth-attribute
                  ])
                  | doc m%"
                  The attributes for [AWS Auth](http://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html).
                  "%
                  | optional,
                basic
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.auth-attribute
                  ])
                  | doc m%"
                  The attributes for [Basic Authentication](https://en.wikipedia.org/wiki/Basic_access_authentication).
                  "%
                  | optional,
                bearer
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.auth-attribute
                  ])
                  | doc m%"
                  The helper attributes for [Bearer Token Authentication](https://tools.ietf.org/html/rfc6750)
                  "%
                  | optional,
                digest
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.auth-attribute
                  ])
                  | doc m%"
                  The attributes for [Digest Authentication](https://en.wikipedia.org/wiki/Digest_access_authentication).
                  "%
                  | optional,
                edgegrid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.auth-attribute
                  ])
                  | doc m%"
                  The attributes for [Akamai EdgeGrid Authentication](https://developer.akamai.com/legacy/introduction/Client_Auth.html).
                  "%
                  | optional,
                hawk
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.auth-attribute
                  ])
                  | doc m%"
                  The attributes for [Hawk Authentication](https://github.com/hueniverse/hawk)
                  "%
                  | optional,
                noauth
                  | predicates.contract_from_predicate predicates.always
                  | optional,
                ntlm
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.auth-attribute
                  ])
                  | doc m%"
                  The attributes for [NTLM Authentication](https://msdn.microsoft.com/en-us/library/cc237488.aspx)
                  "%
                  | optional,
                oauth1
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.auth-attribute
                  ])
                  | doc m%"
                  The attributes for [OAuth2](https://oauth.net/1/)
                  "%
                  | optional,
                oauth2
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.auth-attribute
                  ])
                  | doc m%"
                  Helper attributes for [OAuth2](https://oauth.net/2/)
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [|
                    'ntlm,
                    'oauth2,
                    'oauth1,
                    'noauth,
                    'hawk,
                    'edgegrid,
                    'digest,
                    'bearer,
                    'basic,
                    'awsv4,
                    'apikey
                  |],
                ..
              },
          auth-attribute
            | doc m%"
            Represents an attribute for any authorization method provided by Postman. For example `username` and `password` are set as auth attributes for Basic Authentication method.
            "%
            = {
                key | String,
                type | String | optional,
                value
                  | predicates.contract_from_predicate predicates.always
                  | optional,
                ..
              },
          certificate
            | doc m%"
            A representation of an ssl certificate
            "%
            = {
                cert
                  | {
                    src
                      | predicates.contract_from_predicate predicates.always
                      | doc m%"
                      The path to file containing key for certificate, on the file system
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  An object containing path to file certificate, on the file system
                  "%
                  | optional,
                key
                  | {
                    src
                      | predicates.contract_from_predicate predicates.always
                      | doc m%"
                      The path to file containing key for certificate, on the file system
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  An object containing path to file containing private key, on the file system
                  "%
                  | optional,
                matches
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of Url match pattern strings, to identify Urls this certificate can be used for.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  A name for the certificate for user reference
                  "%
                  | optional,
                passphrase
                  | String
                  | doc m%"
                  The passphrase for the certificate
                  "%
                  | optional,
                ..
              },
          certificate-list
            | doc m%"
            A representation of a list of ssl certificates
            "%
            = predicates.contract_from_predicate
              definitions.predicate.certificate-list,
          cookie
            | doc m%"
            A Cookie, that follows the [Google Chrome format](https://developer.chrome.com/extensions/cookies)
            "%
            = {
                domain
                  | String
                  | doc m%"
                  The domain for which this cookie is valid.
                  "%,
                expires
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  When the cookie expires.
                  "%
                  | optional,
                extensions
                  | Array Dyn
                  | doc m%"
                  Custom attributes for a cookie go here, such as the [Priority Field](https://code.google.com/p/chromium/issues/detail?id=232693)
                  "%
                  | optional,
                hostOnly
                  | Bool
                  | doc m%"
                  True if the cookie is a host-only cookie. (i.e. a request's URL domain must exactly match the domain of the cookie).
                  "%
                  | optional,
                httpOnly
                  | Bool
                  | doc m%"
                  Indicates if this cookie is HTTP Only. (if True, the cookie is inaccessible to client-side scripts)
                  "%
                  | optional,
                maxAge | String | optional,
                name
                  | String
                  | doc m%"
                  This is the name of the Cookie.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  The path associated with the Cookie.
                  "%,
                secure
                  | Bool
                  | doc m%"
                  Indicates if the 'secure' flag is set on the Cookie, meaning that it is transmitted over secure connections only. (typically HTTPS)
                  "%
                  | optional,
                session
                  | Bool
                  | doc m%"
                  True if the cookie is a session cookie.
                  "%
                  | optional,
                value
                  | String
                  | doc m%"
                  The value of the Cookie.
                  "%
                  | optional,
                ..
              },
          cookie-list
            | doc m%"
            A representation of a list of cookies
            "%
            = predicates.contract_from_predicate
              definitions.predicate.cookie-list,
          description
            | doc m%"
            A Description can be a raw text, or be an object, which holds the description along with its format.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.description,
          event
            | doc m%"
            Defines a script associated with an associated event name
            "%
            = predicates.contract_from_predicate definitions.predicate.event,
          event-list
            | doc m%"
            Postman allows you to configure scripts to run when specific events occur. These scripts are stored here, and can be referenced in the collection by their ID.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.event-list,
          header
            | doc m%"
            Represents a single HTTP Header
            "%
            = {
                description | definitions.contract.description | optional,
                disabled
                  | Bool
                  | doc m%"
                  If set to true, the current header will not be sent with requests.
                  "%
                  | optional,
                key
                  | String
                  | doc m%"
                  This holds the LHS of the HTTP Header, e.g ``Content-Type`` or ``X-Custom-Header``
                  "%,
                value
                  | String
                  | doc m%"
                  The value (or the RHS) of the Header is stored in this field.
                  "%,
                ..
              },
          header-list
            | doc m%"
            A representation for a list of headers
            "%
            = predicates.contract_from_predicate
              definitions.predicate.header-list,
          info
            | doc m%"
            Detailed description of the info block
            "%
            = predicates.contract_from_predicate definitions.predicate.info,
          item
            | doc m%"
            Items are entities which contain an actual HTTP request, and sample responses attached to it.
            "%
            = {
                description | definitions.contract.description | optional,
                event | definitions.contract.event-list | optional,
                id
                  | String
                  | doc m%"
                  A unique ID that is used to identify collections internally
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  A human readable identifier for the current item.
                  "%
                  | optional,
                protocolProfileBehavior
                  | definitions.contract.protocol-profile-behavior
                  | optional,
                request | definitions.contract.request,
                response
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.response
                  ])
                  | optional,
                variable | definitions.contract.variable-list | optional,
                ..
              },
          item-group
            | doc m%"
            One of the primary goals of Postman is to organize the development of APIs. To this end, it is necessary to be able to group requests together. This can be achived using 'Folders'. A folder just is an ordered set of requests.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.item-group,
          protocol-profile-behavior
            | doc m%"
            Set of configurations used to alter the usual behavior of sending the request
            "%
            = predicates.contract_from_predicate
              definitions.predicate.protocol-profile-behavior,
          proxy-config
            | doc m%"
            Using the Proxy, you can configure your custom proxy into the postman for particular url match
            "%
            = predicates.contract_from_predicate
              definitions.predicate.proxy-config,
          request
            | doc m%"
            A request represents an HTTP request. If a string, the string is assumed to be the request URL and the method is assumed to be 'GET'.
            "%
            = predicates.contract_from_predicate definitions.predicate.request,
          response
            | doc m%"
            A response represents an HTTP response.
            "%
            = predicates.contract_from_predicate definitions.predicate.response,
          script
            | doc m%"
            A script is a snippet of Javascript code that can be used to to perform setup or teardown operations on a particular response.
            "%
            = predicates.contract_from_predicate definitions.predicate.script,
          url
            | doc m%"
            If object, contains the complete broken-down URL for this request. If string, contains the literal request URL.
            "%
            = predicates.contract_from_predicate definitions.predicate.url,
          variable
            | doc m%"
            Using variables in your Postman requests eliminates the need to duplicate requests, which can save a lot of time. Variables can be defined, and referenced to from any part of a request.
            "%
            = predicates.contract_from_predicate definitions.predicate.variable,
          variable-list
            | doc m%"
            Collection variables allow you to define a set of variables, that are a *part of the collection*, as opposed to environments, which are separate entities.
            *Note: Collection variables must not contain any sensitive information.*
            "%
            = predicates.contract_from_predicate
              definitions.predicate.variable-list,
          version
            | doc m%"
            Postman allows you to version your collections as they grow, and this field holds the version number. While optional, it is recommended that you use this field to its fullest extent!
            "%
            = predicates.contract_from_predicate definitions.predicate.version,
        },
    predicate = {
          auth
            | doc m%"
            Represents authentication helpers provided by Postman
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  apikey = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.auth-attribute
                      ],
                  awsv4 = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.auth-attribute
                      ],
                  basic = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.auth-attribute
                      ],
                  bearer = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.auth-attribute
                      ],
                  digest = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.auth-attribute
                      ],
                  edgegrid = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.auth-attribute
                      ],
                  hawk = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.auth-attribute
                      ],
                  noauth = predicates.always,
                  ntlm = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.auth-attribute
                      ],
                  oauth1 = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.auth-attribute
                      ],
                  oauth2 = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.auth-attribute
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "apikey",
                          "awsv4",
                          "basic",
                          "bearer",
                          "digest",
                          "edgegrid",
                          "hawk",
                          "noauth",
                          "oauth1",
                          "oauth2",
                          "ntlm"
                        ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          auth-attribute
            | doc m%"
            Represents an attribute for any authorization method provided by Postman. For example `username` and `password` are set as auth attributes for Basic Authentication method.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key" ],
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  type = predicates.isType '"String",
                  value = predicates.always,
                }
                {  }
                true
                predicates.always
              ],
          certificate
            | doc m%"
            A representation of an ssl certificate
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cert = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record { src = predicates.always, }
                        {  }
                        true
                        predicates.always
                      ],
                  key = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record { src = predicates.always, }
                        {  }
                        true
                        predicates.always
                      ],
                  matches = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                  passphrase = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          certificate-list
            | doc m%"
            A representation of a list of ssl certificates
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.certificate
              ],
          cookie
            | doc m%"
            A Cookie, that follows the [Google Chrome format](https://developer.chrome.com/extensions/cookies)
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "domain", "path" ],
                predicates.records.record
                {
                  domain = predicates.isType '"String",
                  expires = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  extensions = predicates.isType '"Array",
                  hostOnly = predicates.isType '"Bool",
                  httpOnly = predicates.isType '"Bool",
                  maxAge = predicates.isType '"String",
                  name = predicates.isType '"String",
                  path = predicates.isType '"String",
                  secure = predicates.isType '"Bool",
                  session = predicates.isType '"Bool",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          cookie-list
            | doc m%"
            A representation of a list of cookies
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.cookie
              ],
          description
            | doc m%"
            A Description can be a raw text, or be an object, which holds the description along with its format.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    content = predicates.isType '"String",
                    type = predicates.isType '"String",
                    version = predicates.always,
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.isType '"String",
                predicates.isType 'Null
              ],
          event
            | doc m%"
            Defines a script associated with an associated event name
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "listen" ],
                predicates.records.record
                {
                  disabled = predicates.isType '"Bool",
                  id = predicates.isType '"String",
                  listen = predicates.isType '"String",
                  script = definitions.predicate.script,
                }
                {  }
                true
                predicates.always
              ],
          event-list
            | doc m%"
            Postman allows you to configure scripts to run when specific events occur. These scripts are stored here, and can be referenced in the collection by their ID.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.event
              ],
          header
            | doc m%"
            Represents a single HTTP Header
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key", "value" ],
                predicates.records.record
                {
                  description = definitions.predicate.description,
                  disabled = predicates.isType '"Bool",
                  key = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          header-list
            | doc m%"
            A representation for a list of headers
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.header
              ],
          info
            | doc m%"
            Detailed description of the info block
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "schema" ],
                predicates.records.record
                {
                  _postman_id = predicates.isType '"String",
                  description = definitions.predicate.description,
                  name = predicates.isType '"String",
                  schema = predicates.isType '"String",
                  version = definitions.predicate.version,
                }
                {  }
                true
                predicates.always
              ],
          item
            | doc m%"
            Items are entities which contain an actual HTTP request, and sample responses attached to it.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "request" ],
                predicates.records.record
                {
                  description = definitions.predicate.description,
                  event = definitions.predicate.event-list,
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                  protocolProfileBehavior =
                    definitions.predicate.protocol-profile-behavior,
                  request = definitions.predicate.request,
                  response = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.response
                      ],
                  variable = definitions.predicate.variable-list,
                }
                {  }
                true
                predicates.always
              ],
          item-group
            | doc m%"
            One of the primary goals of Postman is to organize the development of APIs. To this end, it is necessary to be able to group requests together. This can be achived using 'Folders'. A folder just is an ordered set of requests.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "item" ],
                predicates.records.record
                {
                  auth = predicates.oneOf
                      [ predicates.isType 'Null, definitions.predicate.auth ],
                  description = definitions.predicate.description,
                  event = definitions.predicate.event-list,
                  item = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.item,
                          definitions.predicate.item-group
                        ])
                      ],
                  name = predicates.isType '"String",
                  protocolProfileBehavior =
                    definitions.predicate.protocol-profile-behavior,
                  variable = definitions.predicate.variable-list,
                }
                {  }
                true
                predicates.always
              ],
          protocol-profile-behavior
            | doc m%"
            Set of configurations used to alter the usual behavior of sending the request
            "%
            = predicates.isType 'Record,
          proxy-config
            | doc m%"
            Using the Proxy, you can configure your custom proxy into the postman for particular url match
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  disabled = predicates.isType '"Bool",
                  host = predicates.isType '"String",
                  "match" = predicates.isType '"String",
                  port = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  tunnel = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          request
            | doc m%"
            A request represents an HTTP request. If a string, the string is assumed to be the request URL and the method is assumed to be 'GET'.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    auth = predicates.oneOf
                        [ predicates.isType 'Null, definitions.predicate.auth ],
                    body = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              disabled = predicates.isType '"Bool",
                              file = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      content = predicates.isType '"String",
                                      src = predicates.oneOf
                                          [
                                            predicates.isType '"String",
                                            predicates.isType 'Null
                                          ],
                                    }
                                    {  }
                                    true
                                    predicates.always
                                  ],
                              formdata = predicates.allOf
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
                                          predicates.records.required [ "key" ],
                                          predicates.records.record
                                          {
                                            contentType = predicates.isType
                                                '"String",
                                            description =
                                              definitions.predicate.description,
                                            disabled = predicates.isType
                                                '"Bool",
                                            key = predicates.isType '"String",
                                            type = predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.const "text"
                                                ],
                                            value = predicates.isType '"String",
                                          }
                                          {  }
                                          true
                                          predicates.always
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.records.required [ "key" ],
                                          predicates.records.record
                                          {
                                            contentType = predicates.isType
                                                '"String",
                                            description =
                                              definitions.predicate.description,
                                            disabled = predicates.isType
                                                '"Bool",
                                            key = predicates.isType '"String",
                                            src = predicates.anyOf
                                                [
                                                  predicates.isType '"Array",
                                                  predicates.isType '"String",
                                                  predicates.isType 'Null
                                                ],
                                            type = predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.const "file"
                                                ],
                                          }
                                          {  }
                                          true
                                          predicates.always
                                        ]
                                      ]
                                    ])
                                  ],
                              graphql = predicates.isType 'Record,
                              mode = predicates.enum
                                  [
                                    "raw",
                                    "urlencoded",
                                    "formdata",
                                    "file",
                                    "graphql"
                                  ],
                              options = predicates.isType 'Record,
                              raw = predicates.isType '"String",
                              urlencoded = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.required [ "key" ],
                                      predicates.records.record
                                      {
                                        description =
                                          definitions.predicate.description,
                                        disabled = predicates.isType '"Bool",
                                        key = predicates.isType '"String",
                                        value = predicates.isType '"String",
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
                          predicates.isType 'Null
                        ],
                    certificate = definitions.predicate.certificate,
                    description = definitions.predicate.description,
                    header = predicates.oneOf
                        [
                          definitions.predicate.header-list,
                          predicates.isType '"String"
                        ],
                    method = predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "GET",
                              "PUT",
                              "POST",
                              "PATCH",
                              "DELETE",
                              "COPY",
                              "HEAD",
                              "OPTIONS",
                              "LINK",
                              "UNLINK",
                              "PURGE",
                              "LOCK",
                              "UNLOCK",
                              "PROPFIND",
                              "VIEW"
                            ]
                          ],
                          predicates.isType '"String"
                        ],
                    proxy = definitions.predicate.proxy-config,
                    url = definitions.predicate.url,
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.isType '"String"
              ],
          response
            | doc m%"
            A response represents an HTTP response.
            "%
            = predicates.records.record
              {
                body = predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ],
                code = predicates.isType 'Integer,
                cookie = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.cookie
                    ],
                header = predicates.oneOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.oneOf
                        [
                          definitions.predicate.header,
                          predicates.isType '"String"
                        ])
                      ],
                      predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ]
                    ],
                id = predicates.isType '"String",
                originalRequest = definitions.predicate.request,
                responseTime = predicates.anyOf
                    [
                      predicates.isType 'Null,
                      predicates.isType '"String",
                      predicates.isType '"Number"
                    ],
                status = predicates.isType '"String",
                timings = predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
              }
              {  }
              true
              predicates.always,
          script
            | doc m%"
            A script is a snippet of Javascript code that can be used to to perform setup or teardown operations on a particular response.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  exec = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                  src = definitions.predicate.url,
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          url
            | doc m%"
            If object, contains the complete broken-down URL for this request. If string, contains the literal request URL.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    hash = predicates.isType '"String",
                    host = predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ]
                        ],
                    path = predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.oneOf
                            [
                              predicates.isType '"String",
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  type = predicates.isType '"String",
                                  value = predicates.isType '"String",
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ])
                          ]
                        ],
                    port = predicates.isType '"String",
                    protocol = predicates.isType '"String",
                    query = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              description = definitions.predicate.description,
                              disabled = predicates.isType '"Bool",
                              key = predicates.anyOf
                                  [
                                    predicates.isType '"String",
                                    predicates.isType 'Null
                                  ],
                              value = predicates.anyOf
                                  [
                                    predicates.isType '"String",
                                    predicates.isType 'Null
                                  ],
                            }
                            {  }
                            true
                            predicates.always
                          ])
                        ],
                    raw = predicates.isType '"String",
                    variable = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.variable
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.isType '"String"
              ],
          variable
            | doc m%"
            Using variables in your Postman requests eliminates the need to duplicate requests, which can save a lot of time. Variables can be defined, and referenced to from any part of a request.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "id" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "key" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "id", "key" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  description = definitions.predicate.description,
                  disabled = predicates.isType '"Bool",
                  id = predicates.isType '"String",
                  key = predicates.isType '"String",
                  name = predicates.isType '"String",
                  system = predicates.isType '"Bool",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "string", "boolean", "any", "number" ]
                      ],
                  value = predicates.always,
                }
                {  }
                true
                predicates.always
              ],
          variable-list
            | doc m%"
            Collection variables allow you to define a set of variables, that are a *part of the collection*, as opposed to environments, which are separate entities.
            *Note: Collection variables must not contain any sensitive information.*
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.variable
              ],
          version
            | doc m%"
            Postman allows you to version your collections as they grow, and this field holds the version number. While optional, it is recommended that you use this field to its fullest extent!
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "major", "minor", "patch" ],
                  predicates.records.record
                  {
                    identifier = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.maxLength 10
                        ],
                    major = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ],
                    meta = predicates.always,
                    minor = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ],
                    patch = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.isType '"String"
              ],
        },
  }
in

{
  auth
    | predicates.contract_from_predicate
    (predicates.oneOf [ predicates.isType 'Null, definitions.predicate.auth ])
    | optional,
  event | definitions.contract.event-list | optional,
  info | definitions.contract.info,
  item
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.oneOf
      [ definitions.predicate.item, definitions.predicate.item-group ])
    ])
    | doc m%"
    Items are the basic unit for a Postman collection. You can think of them as corresponding to a single API endpoint. Each Item has one request and may have multiple API responses associated with it.
    "%,
  protocolProfileBehavior
    | definitions.contract.protocol-profile-behavior
    | optional,
  variable | definitions.contract.variable-list | optional,
  ..
}