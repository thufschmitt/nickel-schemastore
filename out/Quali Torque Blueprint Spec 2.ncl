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
          ActivitiesObject = {
                deploy
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    definitions.predicate.ActivityObject
                  ])
                  | optional,
                destroy
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    definitions.predicate.ActivityObject
                  ])
                  | optional,
              },
          ActivityObject = {
                commands
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.CommandObject,
                      predicates.isType '"String"
                    ])
                  ])
                  | optional,
              },
          Backend = {
                base-address | String | optional,
                bucket | String | optional,
                container-name | String | optional,
                key-prefix | String | optional,
                region | String | optional,
                storage-account-name | String | optional,
                type | String | optional,
                ..
              },
          BlueprintInputObject = {
                allowed-values
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType 'Integer,
                      predicates.isType '"Bool"
                    ])
                  ])
                  | optional,
                "default"
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType 'Integer,
                    predicates.isType '"String",
                    predicates.isType '"Bool"
                  ])
                  | optional,
                description
                  | String
                  | doc m%"
                  In the relevant UI field, enter a description to be displayed to the user.
                  "%
                  | optional,
                display-style
                  | std.enum.TagOrString
                  | [| 'masked, 'normal, 'multiline |]
                  | optional,
                sensitive | Bool | optional,
                type
                  | std.enum.TagOrString
                  | [| 'credentials, 'agent, 'execution-host, 'string |]
                  | optional,
              },
          BlueprintOutputObject = {
                kind | std.enum.TagOrString | [| 'link, 'regular |] | optional,
                quick | Bool | optional,
                value | String,
              },
          CommandObject = {
                command | String | optional,
                name | String | optional,
              },
          EnvironementVariable = predicates.contract_from_predicate
              definitions.predicate.EnvironementVariable,
          GrainCommand = predicates.contract_from_predicate
              definitions.predicate.GrainCommand,
          GrainInput = predicates.contract_from_predicate
              definitions.predicate.GrainInput,
          GrainObject = {
                depends-on
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^((.+)(,\\s*)?)+[^,]$"
                  ])
                  | optional,
                kind
                  | std.enum.TagOrString
                  | [|
                    'cloudshell,
                    'shell,
                    'kubernetes,
                    'cloudformation,
                    'arm,
                    'blueprint,
                    'ansible,
                    'helm,
                    'terraform
                  |],
                spec | definitions.contract.GrainSpecObject,
                tf-version | String | optional,
              },
          GrainOutput = predicates.contract_from_predicate
              definitions.predicate.GrainOutput,
          GrainScripts = {
                post-helm-install
                  | definitions.contract.ScriptOutputsObject
                  | optional,
                post-kubernetes-install
                  | definitions.contract.ScriptOutputsObject
                  | optional,
                pre-tf-destroy | definitions.contract.ScriptObject | optional,
                pre-tf-init | definitions.contract.ScriptObject | optional,
              },
          GrainSpecHostObject = {
                image | String | optional,
                kubernetes | String | optional,
                name | String | optional,
                region | String | optional,
                service-account | String | optional,
              },
          GrainSpecObject = predicates.contract_from_predicate
              definitions.predicate.GrainSpecObject,
          GrainSpecSourceObject = { path | String, store | String | optional, },
          GrainSpecSources = predicates.contract_from_predicate
              definitions.predicate.GrainSpecSources,
          GrainTag = {
                auto-tag | Bool | optional,
                disable-tags-for
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                ..
              },
          InstructionsSourceObject = { path | String, store | String, },
          ScriptObject = {
                arguments | String | optional,
                source | definitions.contract.ScriptSource | optional,
                ..
              },
          ScriptOutputsObject = {
                arguments | String | optional,
                outputs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                source | definitions.contract.ScriptSource | optional,
                ..
              },
          ScriptSource = {
                path | String | optional,
                store | String | optional,
                ..
              },
          TfVarsFileSourceObject = {
                path | String,
                store | String | optional,
              },
          Torque-Blueprint-Spec2 = {
                description | String | optional,
                grains
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      "^[a-zA-Z0-9-_ ().]{3,45}$" = predicates.oneOf
                          [
                            definitions.predicate.GrainObject,
                            predicates.isType 'Null
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                inputs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      "^[a-zA-Z0-9-_ ().]{3,45}$" = predicates.oneOf
                          [
                            definitions.predicate.BlueprintInputObject,
                            predicates.isType 'Null
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                instructions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.oneOf
                    [
                      predicates.allOf
                      [
                        predicates.records.required [ "text" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                      predicates.allOf
                      [
                        predicates.records.required [ "source" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]
                    ],
                    predicates.records.record
                    {
                      source = definitions.predicate.InstructionsSourceObject,
                      text = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                  | optional,
                outputs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      "^[a-zA-Z0-9-_ ().]{3,45}$" = predicates.oneOf
                          [
                            definitions.predicate.BlueprintOutputObject,
                            predicates.isType 'Null
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                spec_version
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.enum [ 2 ] ]),
              },
        },
    predicate = {
          ActivitiesObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  deploy = predicates.allOf
                      [
                        predicates.isType 'Record,
                        definitions.predicate.ActivityObject
                      ],
                  destroy = predicates.allOf
                      [
                        predicates.isType 'Record,
                        definitions.predicate.ActivityObject
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ActivityObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  commands = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.CommandObject,
                          predicates.isType '"String"
                        ])
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Backend = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  base-address = predicates.isType '"String",
                  bucket = predicates.isType '"String",
                  container-name = predicates.isType '"String",
                  key-prefix = predicates.isType '"String",
                  region = predicates.isType '"String",
                  storage-account-name = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          BlueprintInputObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allowed-values = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Integer,
                          predicates.isType '"Bool"
                        ])
                      ],
                  "default" = predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  display-style = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "multiline", "normal", "masked" ]
                      ],
                  sensitive = predicates.isType '"Bool",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "string", "execution-host", "agent", "credentials" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          BlueprintOutputObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "value" ],
                predicates.records.record
                {
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "regular", "link" ]
                      ],
                  quick = predicates.isType '"Bool",
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CommandObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  command = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          EnvironementVariable = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[A-Z0-9_]+" = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number",
                        predicates.isType '"Bool"
                      ],
                }
                false
                predicates.never
              ],
          GrainCommand = predicates.allOf
              [
                predicates.isType '"String",
                predicates.records.record {  } {  } true predicates.always
              ],
          GrainInput = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[\\w\\-\\.]+$" = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number",
                        predicates.isType '"Bool"
                      ],
                }
                false
                predicates.never
              ],
          GrainObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kind", "spec" ],
                predicates.records.record
                {
                  depends-on = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^((.+)(,\\s*)?)+[^,]$"
                      ],
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "terraform",
                          "helm",
                          "ansible",
                          "blueprint",
                          "arm",
                          "cloudformation",
                          "kubernetes",
                          "shell",
                          "cloudshell"
                        ]
                      ],
                  spec = definitions.predicate.GrainSpecObject,
                  tf-version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GrainOutput = predicates.allOf
              [
                predicates.isType '"String",
                predicates.records.record {  } {  } true predicates.always
              ],
          GrainScripts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  post-helm-install = definitions.predicate.ScriptOutputsObject,
                  post-kubernetes-install =
                    definitions.predicate.ScriptOutputsObject,
                  pre-tf-destroy = definitions.predicate.ScriptObject,
                  pre-tf-init = definitions.predicate.ScriptObject,
                }
                {  }
                false
                predicates.never
              ],
          GrainSpecHostObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  image = predicates.isType '"String",
                  kubernetes = predicates.isType '"String",
                  name = predicates.isType '"String",
                  region = predicates.isType '"String",
                  service-account = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GrainSpecObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "agent" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "host" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "region" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  activities = definitions.predicate.ActivitiesObject,
                  agent = definitions.predicate.GrainSpecHostObject,
                  authentication = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  backend = definitions.predicate.Backend,
                  commands = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.GrainCommand
                      ],
                  env-vars = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.EnvironementVariable
                      ],
                  host = definitions.predicate.GrainSpecHostObject,
                  inputs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.GrainInput
                      ],
                  inventory-file = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ])
                      ],
                  namespace = predicates.isType '"String",
                  outputs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.GrainOutput
                      ],
                  region = predicates.isType '"String",
                  release = predicates.isType '"String",
                  scripts = definitions.predicate.GrainScripts,
                  source = definitions.predicate.GrainSpecSourceObject,
                  sources = definitions.predicate.GrainSpecSources,
                  tags = definitions.predicate.GrainTag,
                  tfvars-files = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.TfVarsFileSourceObject
                      ],
                }
                {  }
                false
                predicates.never
              ],
          GrainSpecSourceObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  store = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GrainSpecSources = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.GrainSpecSourceObject
              ],
          GrainTag = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  auto-tag = predicates.isType '"Bool",
                  disable-tags-for = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          InstructionsSourceObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path", "store" ],
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  store = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ScriptObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  arguments = predicates.isType '"String",
                  source = definitions.predicate.ScriptSource,
                }
                {  }
                true
                predicates.always
              ],
          ScriptOutputsObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  arguments = predicates.isType '"String",
                  outputs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  source = definitions.predicate.ScriptSource,
                }
                {  }
                true
                predicates.always
              ],
          ScriptSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  store = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          TfVarsFileSourceObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  store = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Torque-Blueprint-Spec2 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "spec_version" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  grains = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[a-zA-Z0-9-_ ().]{3,45}$" = predicates.oneOf
                              [
                                definitions.predicate.GrainObject,
                                predicates.isType 'Null
                              ],
                        }
                        true
                        predicates.always
                      ],
                  inputs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[a-zA-Z0-9-_ ().]{3,45}$" = predicates.oneOf
                              [
                                definitions.predicate.BlueprintInputObject,
                                predicates.isType 'Null
                              ],
                        }
                        true
                        predicates.always
                      ],
                  instructions = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.records.required [ "text" ],
                            predicates.records.record {  } {  } true
                            predicates.always
                          ],
                          predicates.allOf
                          [
                            predicates.records.required [ "source" ],
                            predicates.records.record {  } {  } true
                            predicates.always
                          ]
                        ],
                        predicates.records.record
                        {
                          source =
                            definitions.predicate.InstructionsSourceObject,
                          text = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  outputs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[a-zA-Z0-9-_ ().]{3,45}$" = predicates.oneOf
                              [
                                definitions.predicate.BlueprintOutputObject,
                                predicates.isType 'Null
                              ],
                        }
                        true
                        predicates.always
                      ],
                  spec_version = predicates.allOf
                      [ predicates.isType 'Integer, predicates.enum [ 2 ] ],
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

definitions.contract.Torque-Blueprint-Spec2