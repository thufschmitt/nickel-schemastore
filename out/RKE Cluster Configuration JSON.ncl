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
          AESConfiguration = {
                keys
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Key
                  ]),
              },
          AWSCloudProvider = {
                global | definitions.contract.GlobalAwsOpts,
                serviceOverride
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = definitions.predicate.ServiceOverride, }
                    true
                    predicates.always
                  ])
                  | optional,
              },
          AWSElasticBlockStoreVolumeSource = {
                fsType | String | optional,
                partition | std.number.Integer | optional,
                readOnly | Bool | optional,
                volumeID | String,
              },
          AciNetworkProvider = {
                aep | String | optional,
                apicHosts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                apicRefreshTime | String | optional,
                apicUserCrt | String | optional,
                apicUserKey | String | optional,
                apicUserName | String | optional,
                capic | String | optional,
                controllerLogLevel | String | optional,
                dropLogEnable | String | optional,
                enableEndpointSlice | String | optional,
                encapType | String | optional,
                epRegistry | String | optional,
                externDynamic | String | optional,
                externStatic | String | optional,
                gbpPodSubnet | String | optional,
                hostAgentLogLevel | String | optional,
                imagePullPolicy | String | optional,
                imagePullSecret | String | optional,
                infraVlan | String | optional,
                installIstio | String | optional,
                istioProfile | String | optional,
                kafkaBrokers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                kafkaClientCrt | String | optional,
                kafkaClientKey | String | optional,
                kubeApiVlan | String | optional,
                l3out | String | optional,
                l3outExternalNetworks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                maxNodesSvcGraph | String | optional,
                mcastRangeEnd | String | optional,
                mcastRangeStart | String | optional,
                noPriorityClass | String | optional,
                nodeSubnet | String | optional,
                nodeSvcSubnet | String | optional,
                opflexClientSsl | String | optional,
                opflexLogLevel | String | optional,
                opflexMode | String | optional,
                opflexServerPort
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | optional,
                overlayVrfName | String | optional,
                ovsMemoryLimit | String | optional,
                pbrTrackingNonSnat | String | optional,
                podSubnetChunkSize | String | optional,
                runGbpContainer | String | optional,
                runOpflexServerContainer | String | optional,
                serviceMonitorInterval | String | optional,
                serviceVlan | String | optional,
                snatContractScope | String | optional,
                snatNamespace | String | optional,
                snatPortRangeEnd
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | optional,
                snatPortRangeStart
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | optional,
                snatPortsPerNode
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | optional,
                subnetDomainName | String | optional,
                systemId | String | optional,
                tenant | String | optional,
                token | String | optional,
                useAciAnywhereCrd | String | optional,
                useAciCniPriorityClass | String | optional,
                useHostNetnsVolume | String | optional,
                useOpflexServerVolume | String | optional,
                usePrivilegedContainer | String | optional,
                vmmController | String | optional,
                vmmDomain | String | optional,
                vrfName | String | optional,
                vrfTenant | String | optional,
              },
          AdmissionConfiguration = {
                TypeMeta | definitions.contract.TypeMeta,
                plugins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.AdmissionPluginConfiguration
                  ]),
              },
          AdmissionPluginConfiguration = {
                configuration | definitions.contract.Unknown,
                name | String,
                path | String,
              },
          AuditLog = {
                configuration | definitions.contract.AuditLogConfig | optional,
                enabled | Bool | optional,
              },
          AuditLogConfig = {
                format | String | optional,
                maxAge | std.number.Integer | optional,
                maxBackup | std.number.Integer | optional,
                maxSize | std.number.Integer | optional,
                path | String | optional,
                policy | definitions.contract.Policy | optional,
              },
          AuthWebhookConfig = {
                cacheTimeout
                  | String
                  | doc m%"
                  CacheTimeout controls how long to cache authentication decisions
                  "%
                  | optional,
                configFile
                  | String
                  | doc m%"
                  ConfigFile is a multiline string that represent a custom webhook config file
                  "%
                  | optional,
              },
          AuthnConfig = {
                sans
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of additional hostnames and IPs to include in the api server PKI cert
                  "%
                  | optional,
                strategy
                  | String
                  | doc m%"
                  Authentication strategy that will be used in kubernetes cluster
                  "%
                  | optional,
                webhook
                  | definitions.contract.AuthWebhookConfig
                  | doc m%"
                  Webhook configuration options
                  "%
                  | optional,
              },
          AuthzConfig = {
                mode
                  | String
                  | doc m%"
                  Authorization mode used by kubernetes
                  "%
                  | optional,
                options
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Authorization mode options
                  "%
                  | optional,
              },
          AzureCloudProvider = {
                aadClientCertPassword
                  | String
                  | doc m%"
                  The password of the client certificate for an AAD application with RBAC access to talk to Azure RM APIs
                  This's used for client certificate authentication: https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-protocols-oauth-service-to-service
                  "%,
                aadClientCertPath
                  | String
                  | doc m%"
                  The path of a client certificate for an AAD application with RBAC access to talk to Azure RM APIs
                  This's used for client certificate authentication: https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-protocols-oauth-service-to-service
                  "%,
                aadClientId
                  | String
                  | doc m%"
                  The ClientID for an AAD application with RBAC access to talk to Azure RM APIs
                  This's used for service principal authentication: https://github.com/Azure/aks-engine/blob/master/docs/topics/service-principals.md
                  "%,
                aadClientSecret
                  | String
                  | doc m%"
                  The ClientSecret for an AAD application with RBAC access to talk to Azure RM APIs
                  This's used for service principal authentication: https://github.com/Azure/aks-engine/blob/master/docs/topics/service-principals.md
                  "%,
                cloud
                  | String
                  | doc m%"
                  The cloud environment identifier. Takes values from https://github.com/Azure/go-autorest/blob/ec5f4903f77ed9927ac95b19ab8e44ada64c1356/autorest/azure/environments.go#L13
                  "%,
                cloudProviderBackoff
                  | Bool
                  | doc m%"
                  Enable exponential backoff to manage resource request retries
                  "%,
                cloudProviderBackoffDuration
                  | std.number.Integer
                  | doc m%"
                  Backoff duration
                  "%,
                cloudProviderBackoffExponent
                  | std.number.Integer
                  | doc m%"
                  Backoff exponent
                  "%,
                cloudProviderBackoffJitter
                  | std.number.Integer
                  | doc m%"
                  Backoff jitter
                  "%,
                cloudProviderBackoffRetries
                  | std.number.Integer
                  | doc m%"
                  Backoff retry limit
                  "%,
                cloudProviderRateLimit
                  | Bool
                  | doc m%"
                  Enable rate limiting
                  "%,
                cloudProviderRateLimitBucket
                  | std.number.Integer
                  | doc m%"
                  Rate limit Bucket Size
                  "%,
                cloudProviderRateLimitQPS
                  | std.number.Integer
                  | doc m%"
                  Rate limit QPS
                  "%,
                excludeMasterFromStandardLB
                  | Bool
                  | doc m%"
                  Excludes master nodes (labeled with `node-role.kubernetes.io/master`) from the backend pool of Azure standard loadbalancer, default(nil) to `true`
                  If want adding the master nodes to ALB, this should be set to `false` and remove the `node-role.kubernetes.io/master` label from master nodes
                  "%
                  | optional,
                loadBalancerSku
                  | String
                  | doc m%"
                  Sku of Load Balancer and Public IP: `basic` or `standard`, default(blank) to `basic`
                  "%
                  | optional,
                location
                  | String
                  | doc m%"
                  The location of the resource group that the cluster is deployed in
                  "%,
                maximumLoadBalancerRuleCount
                  | std.number.Integer
                  | doc m%"
                  Maximum allowed LoadBalancer Rule Count is the limit enforced by Azure Load balancer, default(0) to 148
                  "%,
                primaryAvailabilitySetName
                  | String
                  | doc m%"
                  (Optional) The name of the availability set that should be used as the load balancer backend
                  If this is set, the Azure cloudprovider will only add nodes from that availability set to the load
                  balancer backend pool. If this is not set, and multiple agent pools (availability sets) are used, then
                  the cloudprovider will try to add all nodes to a single backend pool which is forbidden.
                  In other words, if you use multiple agent pools (availability sets), you MUST set this field.
                  "%,
                primaryScaleSetName
                  | String
                  | doc m%"
                  The name of the scale set that should be used as the load balancer backend.
                  If this is set, the Azure cloudprovider will only add nodes from that scale set to the load
                  balancer backend pool. If this is not set, and multiple agent pools (scale sets) are used, then
                  the cloudprovider will try to add all nodes to a single backend pool which is forbidden.
                  In other words, if you use multiple agent pools (scale sets), you MUST set this field.
                  "%,
                resourceGroup
                  | String
                  | doc m%"
                  The name of the resource group that the cluster is deployed in
                  "%,
                routeTableName
                  | String
                  | doc m%"
                  (Optional in 1.6) The name of the route table attached to the subnet that the cluster is deployed in
                  "%,
                securityGroupName
                  | String
                  | doc m%"
                  The name of the security group attached to the cluster's subnet
                  "%,
                subnetName
                  | String
                  | doc m%"
                  The name of the subnet that the cluster is deployed in
                  "%,
                subscriptionId
                  | String
                  | doc m%"
                  The ID of the Azure Subscription that the cluster is deployed in
                  "%,
                tenantId
                  | String
                  | doc m%"
                  The AAD Tenant ID for the Subscription that the cluster is deployed in
                  "%,
                useInstanceMetadata
                  | Bool
                  | doc m%"
                  Use instance metadata service where possible
                  "%,
                useManagedIdentityExtension
                  | Bool
                  | doc m%"
                  Use managed service identity for the virtual machine to access Azure ARM APIs
                  This's used for managed identity authentication: https://docs.microsoft.com/en-us/azure/active-directory/managed-service-identity/overview
                  For user-assigned managed identity, need to set the below UserAssignedIdentityID
                  "%,
                userAssignedIdentityID
                  | String
                  | doc m%"
                  The Client ID of the user assigned MSI which is assigned to the underlying VMs
                  This's used for managed identity authentication: https://docs.microsoft.com/en-us/azure/active-directory/managed-service-identity/overview
                  "%
                  | optional,
                vmType
                  | String
                  | doc m%"
                  The type of azure nodes. Candidate valudes are: vmss and standard.
                  If not set, it will be default to standard.
                  "%,
                vnetName
                  | String
                  | doc m%"
                  The name of the VNet that the cluster is deployed in
                  "%,
                vnetResourceGroup
                  | String
                  | doc m%"
                  The name of the resource group that the Vnet is deployed in
                  "%,
              },
          AzureDiskVolumeSource = {
                cachingMode | String | optional,
                diskName | String,
                diskURI | String,
                fsType | String | optional,
                kind | String | optional,
                readOnly | Bool | optional,
              },
          AzureFileVolumeSource = {
                readOnly | Bool | optional,
                secretName | String,
                shareName | String,
              },
          BackupConfig = {
                enabled | Bool | optional,
                intervalHours | std.number.Integer | optional,
                retention | std.number.Integer | optional,
                s3BackupConfig | definitions.contract.S3BackupConfig,
                safeTimestamp | Bool | optional,
                timeout | std.number.Integer | optional,
              },
          BastionHost = {
                address
                  | String
                  | doc m%"
                  Address of Bastion Host
                  "%
                  | optional,
                ignoreProxyEnvVars
                  | Bool
                  | doc m%"
                  Ignore proxy environment variables
                  "%
                  | optional,
                port
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | doc m%"
                  SSH Port of Bastion Host
                  "%
                  | optional,
                sshAgentAuth
                  | Bool
                  | doc m%"
                  SSH Agent Auth enable
                  "%
                  | optional,
                sshCert
                  | String
                  | doc m%"
                  SSH Certificate
                  "%
                  | optional,
                sshCertPath
                  | String
                  | doc m%"
                  SSH Certificate Path
                  "%
                  | optional,
                sshKey
                  | String
                  | doc m%"
                  SSH Private Key
                  "%
                  | optional,
                sshKeyPath
                  | String
                  | doc m%"
                  SSH Private Key Path
                  "%
                  | optional,
                user
                  | String
                  | doc m%"
                  ssh User to Bastion Host
                  "%
                  | optional,
              },
          BlockStorageOpenstackOpts = {
                bs-version
                  | String
                  | doc m%"
                  overrides autodetection. v1 or v2. Defaults to auto
                  "%,
                ignore-volume-az | Bool,
                trust-device-path
                  | Bool
                  | doc m%"
                  See Issue #33128
                  "%,
              },
          CSIVolumeSource = {
                driver | String,
                fsType | String | optional,
                nodePublishSecretRef
                  | definitions.contract.LocalObjectReference
                  | optional,
                readOnly | Bool | optional,
                volumeAttributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
              },
          CalicoNetworkProvider = {
                cloudProvider
                  | String
                  | doc m%"
                  Cloud provider type used with calico
                  "%,
              },
          CanalNetworkProvider = { iface | String, },
          CephFSVolumeSource = {
                monitors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                path | String | optional,
                readOnly | Bool | optional,
                secretFile | String | optional,
                secretRef
                  | definitions.contract.LocalObjectReference
                  | optional,
                user | String | optional,
              },
          CinderVolumeSource = {
                fsType | String | optional,
                readOnly | Bool | optional,
                secretRef
                  | definitions.contract.LocalObjectReference
                  | optional,
                volumeID | String,
              },
          CloudProvider = {
                awsCloudProvider
                  | definitions.contract.AWSCloudProvider
                  | doc m%"
                  AWSCloudProvider
                  "%
                  | optional,
                azureCloudProvider
                  | definitions.contract.AzureCloudProvider
                  | doc m%"
                  AzureCloudProvider
                  "%
                  | optional,
                customCloudProvider
                  | String
                  | doc m%"
                  CustomCloudProvider is a multiline string that represent a custom cloud config file
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the Cloud Provider
                  "%
                  | optional,
                openstackCloudProvider
                  | definitions.contract.OpenstackCloudProvider
                  | doc m%"
                  OpenstackCloudProvider
                  "%
                  | optional,
                vsphereCloudProvider
                  | definitions.contract.VsphereCloudProvider
                  | doc m%"
                  VsphereCloudProvider
                  "%
                  | optional,
              },
          ConfigMapKeySelector = {
                LocalObjectReference
                  | definitions.contract.LocalObjectReference,
                key | String,
                "optional" | Bool | optional,
              },
          ConfigMapProjection = {
                LocalObjectReference
                  | definitions.contract.LocalObjectReference,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.KeyToPath
                  ])
                  | optional,
                "optional" | Bool | optional,
              },
          ConfigMapVolumeSource = {
                LocalObjectReference
                  | definitions.contract.LocalObjectReference,
                defaultMode | std.number.Integer | optional,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.KeyToPath
                  ])
                  | optional,
                "optional" | Bool | optional,
              },
          Configuration = {
                TypeMeta | definitions.contract.TypeMeta,
                limits
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Limit
                  ]),
              },
          DNSConfig = {
                linearAutoscalerParams
                  | definitions.contract.LinearAutoscalerParams
                  | doc m%"
                  Autoscaler fields to determine number of dns replicas
                  "%
                  | optional,
                nodeSelector
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  NodeSelector key pair
                  "%
                  | optional,
                nodelocal
                  | definitions.contract.Nodelocal
                  | doc m%"
                  Nodelocal DNS
                  "%
                  | optional,
                options
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  DNS config options
                  "%
                  | optional,
                provider
                  | String
                  | doc m%"
                  DNS provider
                  "%
                  | optional,
                reversecidrs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  ReverseCIDRs
                  "%
                  | optional,
                stubdomains
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Stubdomains
                  "%
                  | optional,
                tolerations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Toleration
                  ])
                  | doc m%"
                  Tolerations for Deployments
                  "%
                  | optional,
                updateStrategy
                  | definitions.contract.DeploymentStrategy
                  | doc m%"
                  Update strategy
                  "%
                  | optional,
                upstreamnameservers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Upstream nameservers
                  "%
                  | optional,
              },
          DaemonSetUpdateStrategy = {
                rollingUpdate
                  | definitions.contract.RollingUpdateDaemonSet
                  | optional,
                strategy | String | optional,
              },
          DeploymentStrategy = {
                rollingUpdate
                  | definitions.contract.RollingUpdateDeployment
                  | optional,
                strategy | String | optional,
              },
          DiskVsphereOpts = { scsicontrollertype | String | optional, },
          DownwardAPIProjection = {
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.DownwardAPIVolumeFile
                  ])
                  | optional,
              },
          DownwardAPIVolumeFile = {
                fieldRef | definitions.contract.ObjectFieldSelector | optional,
                mode | std.number.Integer | optional,
                path | String,
                resourceFieldRef
                  | definitions.contract.ResourceFieldSelector
                  | optional,
              },
          DownwardAPIVolumeSource = {
                defaultMode | std.number.Integer | optional,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.DownwardAPIVolumeFile
                  ])
                  | optional,
              },
          Duration = {  },
          ECRCredentialPlugin = {
                awsAccessKeyId | String | optional,
                awsAccessToken | String | optional,
                awsSecretAccessKey | String | optional,
              },
          ETCDService = {
                backupConfig
                  | definitions.contract.BackupConfig
                  | doc m%"
                  Backup backend for etcd snapshots
                  "%
                  | optional,
                caCert
                  | String
                  | doc m%"
                  External CA certificate
                  "%
                  | optional,
                cert
                  | String
                  | doc m%"
                  External Client certificate
                  "%
                  | optional,
                creation
                  | String
                  | doc m%"
                  Etcd snapshot Creation period
                  "%
                  | optional,
                externalUrls
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of etcd urls
                  "%
                  | optional,
                extraArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                extraBinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extraEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                gid
                  | std.number.Integer
                  | doc m%"
                  GID to run etcd container as
                  "%
                  | optional,
                image | String | optional,
                key
                  | String
                  | doc m%"
                  External Client key
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  External etcd prefix
                  "%
                  | optional,
                retention
                  | String
                  | doc m%"
                  Etcd snapshot Retention period
                  "%
                  | optional,
                snapshot
                  | Bool
                  | doc m%"
                  Etcd Recurring snapshot Service, used by rke only
                  "%
                  | optional,
                uid
                  | std.number.Integer
                  | doc m%"
                  UID to run etcd container as
                  "%
                  | optional,
                winExtraArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                winExtraBinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                winExtraEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          EmptyDirVolumeSource = {
                medium | String | optional,
                sizeLimit | definitions.contract.Quantity | optional,
              },
          EncryptionConfiguration = {
                apiVersion | String | optional,
                kind | String | optional,
                resources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ResourceConfiguration
                  ]),
              },
          EnvVarSource = {
                configMapKeyRef
                  | definitions.contract.ConfigMapKeySelector
                  | optional,
                fieldRef | definitions.contract.ObjectFieldSelector | optional,
                resourceFieldRef
                  | definitions.contract.ResourceFieldSelector
                  | optional,
                secretKeyRef
                  | definitions.contract.SecretKeySelector
                  | optional,
              },
          EphemeralVolumeSource = {
                volumeClaimTemplate
                  | definitions.contract.PersistentVolumeClaimTemplate
                  | optional,
              },
          EventRateLimit = {
                configuration | definitions.contract.Configuration | optional,
                enabled | Bool | optional,
              },
          ExtraEnv = {
                name | String,
                value | String | optional,
                valueFrom | definitions.contract.EnvVarSource | optional,
              },
          ExtraVolume = {
                VolumeSource | definitions.contract.VolumeSource,
                name | String,
              },
          ExtraVolumeMount = {
                mountPath | String,
                mountPropagation | String | optional,
                name | String,
                readOnly | Bool | optional,
                subPath | String | optional,
                subPathExpr | String | optional,
              },
          FCVolumeSource = {
                fsType | String | optional,
                lun | std.number.Integer | optional,
                readOnly | Bool | optional,
                targetWWNs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                wwids
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          FieldsV1 = {  },
          FlannelNetworkProvider = {
                iface
                  | String
                  | doc m%"
                  Alternate cloud interface for flannel
                  "%,
              },
          FlexVolumeSource = {
                driver | String,
                fsType | String | optional,
                options
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                readOnly | Bool | optional,
                secretRef
                  | definitions.contract.LocalObjectReference
                  | optional,
              },
          FlockerVolumeSource = {
                datasetName | String | optional,
                datasetUUID | String | optional,
              },
          GCEPersistentDiskVolumeSource = {
                fsType | String | optional,
                partition | std.number.Integer | optional,
                pdName | String,
                readOnly | Bool | optional,
              },
          GitRepoVolumeSource = {
                directory | String | optional,
                repository | String,
                revision | String | optional,
              },
          GlobalAwsOpts = {
                disable-security-group-ingress
                  | Bool
                  | doc m%"
                  The aws provider creates an inbound rule per load balancer on the node security
                  group. However, this can run into the AWS security group rule limit of 50 if
                  many LoadBalancers are created.
                  
                  This flag disables the automatic ingress creation. It requires that the user
                  has setup a rule that allows inbound traffic on kubelet ports from the
                  local VPC subnet (so load balancers can access it). E.g. 10.82.0.0/16 30000-32000.
                  "%,
                disable-strict-zone-check
                  | Bool
                  | doc m%"
                  During the instantiation of an new AWS cloud provider, the detected region
                  is validated against a known set of regions.
                  
                  In a non-standard, AWS like environment (e.g. Eucalyptus), this check may
                  be undesirable.  Setting this to true will disable the check and provide
                  a warning that the check was skipped.  Please note that this is an
                  experimental feature and work-in-progress for the moment.  If you find
                  yourself in an non-AWS cloud and open an issue, please indicate that in the
                  issue body.
                  "%,
                elb-security-group
                  | String
                  | doc m%"
                  AWS has a hard limit of 500 security groups. For large clusters creating a security group for each ELB
                  can cause the max number of security groups to be reached. If this is set instead of creating a new
                  Security group for each ELB this security group will be used instead.
                  "%,
                kubernetes-cluster-id
                  | String
                  | doc m%"
                  KubernetesClusterID is the cluster id we'll use to identify our cluster resources
                  "%,
                kubernetes-cluster-tag
                  | String
                  | doc m%"
                  KubernetesClusterTag is the legacy cluster id we'll use to identify our cluster resources
                  "%,
                role-arn
                  | String
                  | doc m%"
                  RoleARN is the IAM role to assume when interaction with AWS APIs.
                  "%,
                routetable-id
                  | String
                  | doc m%"
                  RouteTableID enables using a specific RouteTable
                  "%,
                subnet-id
                  | String
                  | doc m%"
                  SubnetID enables using a specific subnet to use for ELB's
                  "%,
                vpc
                  | String
                  | doc m%"
                  The AWS VPC flag enables the possibility to run the master components
                  on a different aws account, on a different cloud provider or on-premises.
                  If the flag is set also the KubernetesClusterTag must be provided
                  "%,
                zone
                  | String
                  | doc m%"
                  TODO: Is there any use for this?  We can get it from the instance metadata service
                  Maybe if we're not running on AWS, e.g. bootstrap; for now it is not very useful
                  "%,
              },
          GlobalOpenstackOpts = {
                auth-url | String,
                ca-file | String,
                domain-id | String,
                domain-name | String,
                password | String,
                region | String,
                tenant-id | String,
                tenant-name | String,
                trust-id | String,
                user-id | String,
                username | String,
              },
          GlobalVsphereOpts = {
                datacenter | String | optional,
                datacenters | String | optional,
                datastore | String | optional,
                insecure-flag | Bool | optional,
                password | String | optional,
                port
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | optional,
                server | String | optional,
                soap-roundtrip-count | std.number.Integer | optional,
                user | String | optional,
                vm-name | String | optional,
                vm-uuid | String | optional,
                working-dir | String | optional,
              },
          GlusterfsVolumeSource = {
                endpoints | String,
                path | String,
                readOnly | Bool | optional,
              },
          GroupResources = {
                group | String | optional,
                resourceNames
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                resources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          HostPathVolumeSource = { path | String, type | String | optional, },
          ISCSIVolumeSource = {
                chapAuthDiscovery | Bool | optional,
                chapAuthSession | Bool | optional,
                fsType | String | optional,
                initiatorName | String | optional,
                iqn | String,
                iscsiInterface | String | optional,
                lun | std.number.Integer,
                portals
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                readOnly | Bool | optional,
                secretRef
                  | definitions.contract.LocalObjectReference
                  | optional,
                targetPortal | String,
              },
          IdentityConfiguration = {  },
          IngressConfig = {
                defaultBackend
                  | Bool
                  | doc m%"
                  Enable or disable nginx default-http-backend
                  "%
                  | optional,
                defaultHttpBackendPriorityClassName
                  | String
                  | doc m%"
                  Priority class name for Nginx-Ingress's "default-http-backend" deployment
                  "%
                  | optional,
                dnsPolicy
                  | String
                  | doc m%"
                  DNS Policy
                  "%
                  | optional,
                extraArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Ingress controller extra arguments
                  "%
                  | optional,
                extraEnvs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.ExtraEnv
                  ])
                  | doc m%"
                  Extra Env vars
                  "%
                  | optional,
                extraVolumeMounts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ExtraVolumeMount
                  ])
                  | doc m%"
                  Extra volume mounts
                  "%
                  | optional,
                extraVolumes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.ExtraVolume
                  ])
                  | doc m%"
                  Extra volumes
                  "%
                  | optional,
                httpPort
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | doc m%"
                  Http port for ingress controller daemonset
                  "%
                  | optional,
                httpsPort
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | doc m%"
                  Https port for ingress controller daemonset
                  "%
                  | optional,
                networkMode
                  | String
                  | doc m%"
                  NetworkMode selector for ingress controller pods. Default is HostNetwork
                  "%
                  | optional,
                nginxIngressControllerPriorityClassName
                  | String
                  | doc m%"
                  Priority class name for Nginx-Ingress's "nginx-ingress-controller" daemonset
                  "%
                  | optional,
                nodeSelector
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  NodeSelector key pair
                  "%
                  | optional,
                options
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  These options are NOT for configuring Ingress's addon template.
                  They are used for its ConfigMap options specifically.
                  "%
                  | optional,
                provider
                  | String
                  | doc m%"
                  Ingress controller type used by kubernetes
                  "%
                  | optional,
                tolerations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Toleration
                  ])
                  | doc m%"
                  Tolerations for Deployments
                  "%
                  | optional,
                updateStrategy
                  | definitions.contract.DaemonSetUpdateStrategy
                  | doc m%"
                  nginx daemonset upgrade strategy
                  "%
                  | optional,
              },
          IntOrString = {
                IntVal | std.number.Integer,
                StrVal | String,
                Type | std.number.Integer,
              },
          KMSConfiguration = {
                cachesize | std.number.Integer | optional,
                endpoint | String,
                name | String,
                timeout | definitions.contract.Duration | optional,
              },
          Key = { name | String, secret | String, },
          KeyToPath = {
                key | String,
                mode | std.number.Integer | optional,
                path | String,
              },
          KubeAPIService = {
                admissionConfiguration
                  | definitions.contract.AdmissionConfiguration
                  | doc m%"
                  AdmissionConfiguration
                  "%
                  | optional,
                alwaysPullImages
                  | Bool
                  | doc m%"
                  Enable/Disable AlwaysPullImages admissions plugin
                  "%
                  | optional,
                auditLog
                  | definitions.contract.AuditLog
                  | doc m%"
                  Audit Log Configuration
                  "%
                  | optional,
                eventRateLimit
                  | definitions.contract.EventRateLimit
                  | doc m%"
                  Event Rate Limit configuration
                  "%
                  | optional,
                extraArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                extraBinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extraEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                image | String | optional,
                podSecurityPolicy
                  | Bool
                  | doc m%"
                  Enabled/Disable PodSecurityPolicy
                  "%
                  | optional,
                secretsEncryptionConfig
                  | definitions.contract.SecretsEncryptionConfig
                  | doc m%"
                  Secrets encryption provider config
                  "%
                  | optional,
                serviceClusterIpRange
                  | String
                  | doc m%"
                  Virtual IP range that will be used by Kubernetes services
                  "%
                  | optional,
                serviceNodePortRange
                  | String
                  | doc m%"
                  Port range for services defined with NodePort type
                  "%
                  | optional,
                winExtraArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                winExtraBinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                winExtraEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          KubeControllerService = {
                clusterCidr
                  | String
                  | doc m%"
                  CIDR Range for Pods in cluster
                  "%
                  | optional,
                extraArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                extraBinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extraEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                image | String | optional,
                serviceClusterIpRange
                  | String
                  | doc m%"
                  Virtual IP range that will be used by Kubernetes services
                  "%
                  | optional,
                winExtraArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                winExtraBinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                winExtraEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          KubeletService = {
                clusterDnsServer
                  | String
                  | doc m%"
                  Cluster DNS service ip
                  "%
                  | optional,
                clusterDomain
                  | String
                  | doc m%"
                  Domain of the cluster (default: "cluster.local")
                  "%
                  | optional,
                extraArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                extraBinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extraEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                failSwapOn
                  | Bool
                  | doc m%"
                  Fail if swap is enabled
                  "%
                  | optional,
                generateServingCertificate
                  | Bool
                  | doc m%"
                  Generate per node kubelet serving certificates created using kube-ca
                  "%
                  | optional,
                image | String | optional,
                infraContainerImage
                  | String
                  | doc m%"
                  The image whose network/ipc namespaces containers in each pod will use
                  "%
                  | optional,
                winExtraArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                winExtraBinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                winExtraEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          KubeproxyService = {
                extraArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                extraBinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extraEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                image | String | optional,
                winExtraArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                winExtraBinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                winExtraEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          LabelSelector = {
                matchExpressions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.LabelSelectorRequirement
                  ])
                  | optional,
                matchLabels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
              },
          LabelSelectorRequirement = {
                key | String,
                operator | String,
                values
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          Limit = {
                burst | std.number.Integer,
                cacheSize | std.number.Integer | optional,
                qps | std.number.Integer,
                type | String,
              },
          LinearAutoscalerParams = {
                coresPerReplica | Number | optional,
                max | std.number.Integer | optional,
                min | std.number.Integer | optional,
                nodesPerReplica | Number | optional,
                preventSinglePointFailure | Bool | optional,
              },
          LoadBalancerOpenstackOpts = {
                create-monitor | Bool,
                floating-network-id
                  | String
                  | doc m%"
                  If specified, will create floating ip for loadbalancer, or do not create floating ip.
                  "%,
                lb-method
                  | String
                  | doc m%"
                  default to ROUND_ROBIN.
                  "%,
                lb-provider | String,
                lb-version
                  | String
                  | doc m%"
                  overrides autodetection. Only support v2.
                  "%,
                manage-security-groups | Bool,
                monitor-delay | String,
                monitor-max-retries | std.number.Integer,
                monitor-timeout | String,
                subnet-id
                  | String
                  | doc m%"
                  overrides autodetection.
                  "%,
                use-octavia
                  | Bool
                  | doc m%"
                  uses Octavia V2 service catalog endpoint
                  "%,
              },
          LocalObjectReference = { name | String | optional, },
          ManagedFieldsEntry = {
                apiVersion | String | optional,
                fieldsType | String | optional,
                fieldsV1 | definitions.contract.FieldsV1 | optional,
                manager | String | optional,
                operation | String | optional,
                time | String | optional,
              },
          MetadataOpenstackOpts = {
                request-timeout | std.number.Integer,
                search-order | String,
              },
          MonitoringConfig = {
                metricsServerPriorityClassName
                  | String
                  | doc m%"
                  Priority class name for Metrics-Server's "metrics-server" deployment
                  "%
                  | optional,
                nodeSelector
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  NodeSelector key pair
                  "%
                  | optional,
                options
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  These options are NOT for configuring the Metrics-Server's addon template.
                  They are used to pass command args to the metric-server's deployment containers specifically.
                  "%
                  | optional,
                provider
                  | String
                  | doc m%"
                  Monitoring server provider
                  "%
                  | optional,
                replicas
                  | std.number.Integer
                  | doc m%"
                  Number of monitoring addon pods
                  "%
                  | optional,
                tolerations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Toleration
                  ])
                  | doc m%"
                  Tolerations for Deployments
                  "%
                  | optional,
                updateStrategy
                  | definitions.contract.DeploymentStrategy
                  | doc m%"
                  Update strategy
                  "%
                  | optional,
              },
          NFSVolumeSource = {
                path | String,
                readOnly | Bool | optional,
                server | String,
              },
          NetworkConfig = {
                aciNetworkProvider
                  | definitions.contract.AciNetworkProvider
                  | doc m%"
                  AciNetworkProvider
                  "%
                  | optional,
                calicoNetworkProvider
                  | definitions.contract.CalicoNetworkProvider
                  | doc m%"
                  CalicoNetworkProvider
                  "%
                  | optional,
                canalNetworkProvider
                  | definitions.contract.CanalNetworkProvider
                  | doc m%"
                  CanalNetworkProvider
                  "%
                  | optional,
                flannelNetworkProvider
                  | definitions.contract.FlannelNetworkProvider
                  | doc m%"
                  FlannelNetworkProvider
                  "%
                  | optional,
                mtu
                  | std.number.Integer
                  | doc m%"
                  Set MTU for CNI provider
                  "%
                  | optional,
                nodeSelector
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  NodeSelector key pair
                  "%
                  | optional,
                options
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Plugin options to configure network properties
                  "%
                  | optional,
                plugin
                  | String
                  | doc m%"
                  Network Plugin That will be used in kubernetes cluster
                  "%
                  | optional,
                tolerations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Toleration
                  ])
                  | doc m%"
                  Tolerations for Deployments
                  "%
                  | optional,
                updateStrategy
                  | definitions.contract.DaemonSetUpdateStrategy
                  | doc m%"
                  Network plugin daemonset upgrade strategy
                  "%
                  | optional,
                weaveNetworkProvider
                  | definitions.contract.WeaveNetworkProvider
                  | doc m%"
                  WeaveNetworkProvider
                  "%
                  | optional,
              },
          NetworkVshpereOpts = { public-network | String | optional, },
          NodeDrainInput = {
                deleteLocalData
                  | Bool
                  | doc m%"
                  Continue even if there are pods using emptyDir
                  "%
                  | optional,
                "force"
                  | Bool
                  | doc m%"
                  Drain node even if there are pods not managed by a ReplicationController, Job, or DaemonSet
                  Drain will not proceed without Force set to true if there are such pods
                  "%
                  | optional,
                gracePeriod
                  | std.number.Integer
                  | doc m%"
                  Period of time in seconds given to each pod to terminate gracefully.
                  If negative, the default value specified in the pod will be used
                  "%
                  | optional,
                ignoreDaemonSets
                  | Bool
                  | doc m%"
                  If there are DaemonSet-managed pods, drain will not proceed without IgnoreDaemonSets set to true
                  (even when set to true, kubectl won't delete pods - so setting default to true)
                  "%
                  | optional,
                timeout
                  | std.number.Integer
                  | doc m%"
                  Time to wait (in seconds) before giving up for one try
                  "%,
              },
          NodeUpgradeStrategy = {
                drain | Bool | optional,
                maxUnavailableControlplane
                  | String
                  | doc m%"
                  MaxUnavailableControlplane input can be a number of nodes or a percentage of nodes
                  "%
                  | optional,
                maxUnavailableWorker
                  | String
                  | doc m%"
                  MaxUnavailableWorker input can be a number of nodes or a percentage of nodes (example, max_unavailable_worker: 2 OR max_unavailable_worker: 20%)
                  "%
                  | optional,
                nodeDrainInput | definitions.contract.NodeDrainInput | optional,
              },
          Nodelocal = {
                ipAddress
                  | String
                  | doc m%"
                  link-local IP for nodelocal DNS
                  "%
                  | optional,
                nodeLocalDnsPriorityClassName
                  | String
                  | doc m%"
                  Priority class name for NodeLocal's "node-local-dns" daemonset
                  "%
                  | optional,
                nodeSelector
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  NodeSelector key pair
                  "%
                  | optional,
                updateStrategy
                  | definitions.contract.DaemonSetUpdateStrategy
                  | doc m%"
                  Nodelocal DNS daemonset upgrade strategy
                  "%
                  | optional,
              },
          ObjectFieldSelector = {
                apiVersion | String | optional,
                fieldPath | String,
              },
          ObjectMeta = {
                annotations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                clusterName | String | optional,
                creationTimestamp | definitions.contract.Time | optional,
                deletionGracePeriodSeconds | std.number.Integer | optional,
                deletionTimestamp | String | optional,
                finalizers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                generateName | String | optional,
                generation | std.number.Integer | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                managedFields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ManagedFieldsEntry
                  ])
                  | optional,
                name | String | optional,
                namespace | String | optional,
                ownerReferences
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.OwnerReference
                  ])
                  | optional,
                resourceVersion | String | optional,
                selfLink | String | optional,
                uid | String | optional,
              },
          OpenstackCloudProvider = {
                blockStorage | definitions.contract.BlockStorageOpenstackOpts,
                global | definitions.contract.GlobalOpenstackOpts,
                loadBalancer | definitions.contract.LoadBalancerOpenstackOpts,
                metadata | definitions.contract.MetadataOpenstackOpts,
                route | definitions.contract.RouteOpenstackOpts,
              },
          OwnerReference = {
                apiVersion | String,
                blockOwnerDeletion | Bool | optional,
                controller | Bool | optional,
                kind | String,
                name | String,
                uid | String,
              },
          PersistentVolumeClaimSpec = {
                accessModes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                dataSource
                  | definitions.contract.TypedLocalObjectReference
                  | optional,
                resources
                  | definitions.contract.ResourceRequirements
                  | optional,
                selector | definitions.contract.LabelSelector | optional,
                storageClassName | String | optional,
                volumeMode | String | optional,
                volumeName | String | optional,
              },
          PersistentVolumeClaimTemplate = {
                metadata | definitions.contract.ObjectMeta | optional,
                spec | definitions.contract.PersistentVolumeClaimSpec,
              },
          PersistentVolumeClaimVolumeSource = {
                claimName | String,
                readOnly | Bool | optional,
              },
          PhotonPersistentDiskVolumeSource = {
                fsType | String | optional,
                pdID | String,
              },
          Policy = {
                TypeMeta | definitions.contract.TypeMeta,
                metadata | definitions.contract.ObjectMeta | optional,
                omitStages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                rules
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.PolicyRule
                  ]),
              },
          PolicyRule = {
                level | String,
                namespaces
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                nonResourceURLs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                omitStages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                resources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.GroupResources
                  ])
                  | optional,
                userGroups
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                users
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                verbs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          PortworxVolumeSource = {
                fsType | String | optional,
                readOnly | Bool | optional,
                volumeID | String,
              },
          PrivateRegistry = {
                ecrCredentialPlugin
                  | definitions.contract.ECRCredentialPlugin
                  | doc m%"
                  ECRCredentialPlugin
                  "%
                  | optional,
                isDefault
                  | Bool
                  | doc m%"
                  Default registry
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  Password for registry access
                  "%
                  | optional,
                url
                  | String
                  | doc m%"
                  URL for the registry
                  "%
                  | optional,
                user
                  | String
                  | doc m%"
                  User name for registry acces
                  "%
                  | optional,
              },
          ProjectedVolumeSource = {
                defaultMode | std.number.Integer | optional,
                sources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.VolumeProjection
                  ]),
              },
          ProviderConfiguration = {
                aescbc | definitions.contract.AESConfiguration | optional,
                aesgcm | definitions.contract.AESConfiguration | optional,
                identity
                  | definitions.contract.IdentityConfiguration
                  | optional,
                kms | definitions.contract.KMSConfiguration | optional,
                secretbox
                  | definitions.contract.SecretboxConfiguration
                  | optional,
              },
          Quantity = {  },
          QuobyteVolumeSource = {
                group | String | optional,
                readOnly | Bool | optional,
                registry | String,
                tenant | String | optional,
                user | String | optional,
                volume | String,
              },
          RBDVolumeSource = {
                fsType | String | optional,
                image | String,
                keyring | String | optional,
                monitors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                pool | String | optional,
                readOnly | Bool | optional,
                secretRef
                  | definitions.contract.LocalObjectReference
                  | optional,
                user | String | optional,
              },
          RKEConfigNode = {
                address
                  | String
                  | doc m%"
                  IP or FQDN that is fully resolvable and used for SSH communication
                  "%
                  | optional,
                dockerSocket
                  | String
                  | doc m%"
                  Optional - Docker socket on the node that will be used in tunneling
                  "%
                  | optional,
                hostnameOverride
                  | String
                  | doc m%"
                  Optional - Hostname of the node
                  "%
                  | optional,
                internalAddress
                  | String
                  | doc m%"
                  Optional - Internal address that will be used for components communication
                  "%
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Node Labels
                  "%
                  | optional,
                nodeName
                  | String
                  | doc m%"
                  Name of the host provisioned via docker machine
                  "%
                  | optional,
                port
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | doc m%"
                  Port used for SSH communication
                  "%
                  | optional,
                role
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Node role in kubernetes cluster (controlplane, worker, or etcd)
                  "%
                  | optional,
                sshAgentAuth
                  | Bool
                  | doc m%"
                  SSH Agent Auth enable
                  "%
                  | optional,
                sshCert
                  | String
                  | doc m%"
                  SSH Certificate
                  "%
                  | optional,
                sshCertPath
                  | String
                  | doc m%"
                  SSH Certificate Path
                  "%
                  | optional,
                sshKey
                  | String
                  | doc m%"
                  SSH Private Key
                  "%
                  | optional,
                sshKeyPath
                  | String
                  | doc m%"
                  SSH Private Key Path
                  "%
                  | optional,
                taints
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.RKETaint
                  ])
                  | doc m%"
                  Node Taints
                  "%
                  | optional,
                user
                  | String
                  | doc m%"
                  SSH usesr that will be used by RKE
                  "%
                  | optional,
              },
          RKEConfigServices = {
                etcd
                  | definitions.contract.ETCDService
                  | doc m%"
                  Etcd Service
                  "%
                  | optional,
                kubeApi
                  | definitions.contract.KubeAPIService
                  | doc m%"
                  KubeAPI Service
                  "%
                  | optional,
                kubeController
                  | definitions.contract.KubeControllerService
                  | doc m%"
                  KubeController Service
                  "%
                  | optional,
                kubelet
                  | definitions.contract.KubeletService
                  | doc m%"
                  Kubelet Service
                  "%
                  | optional,
                kubeproxy
                  | definitions.contract.KubeproxyService
                  | doc m%"
                  KubeProxy Service
                  "%
                  | optional,
                scheduler
                  | definitions.contract.SchedulerService
                  | doc m%"
                  Scheduler Service
                  "%
                  | optional,
              },
          RKESystemImages = {
                aciCniDeployContainer
                  | String
                  | doc m%"
                  Cni deployer container image for Cisco ACI
                  "%
                  | optional,
                aciControllerContainer
                  | String
                  | doc m%"
                  Controller container image for Cisco ACI
                  "%
                  | optional,
                aciGbpServerContainer
                  | String
                  | doc m%"
                  GBP Server container image for Cisco ACI
                  "%
                  | optional,
                aciHostContainer
                  | String
                  | doc m%"
                  host container image for Cisco ACI
                  "%
                  | optional,
                aciMcastContainer
                  | String
                  | doc m%"
                  mcast daemon container image for Cisco ACI
                  "%
                  | optional,
                aciOpflexContainer
                  | String
                  | doc m%"
                  opflex agent container image for Cisco ACI
                  "%
                  | optional,
                aciOpflexServerContainer
                  | String
                  | doc m%"
                  Opflex Server container image for Cisco ACI
                  "%
                  | optional,
                aciOvsContainer
                  | String
                  | doc m%"
                  OpenvSwitch container image for Cisco ACI
                  "%
                  | optional,
                alpine
                  | String
                  | doc m%"
                  Alpine image
                  "%
                  | optional,
                calicoCni
                  | String
                  | doc m%"
                  Calico CNI image
                  "%
                  | optional,
                calicoControllers
                  | String
                  | doc m%"
                  Calico Controllers image
                  "%
                  | optional,
                calicoCtl
                  | String
                  | doc m%"
                  Calicoctl image
                  "%
                  | optional,
                calicoFlexVol
                  | String
                  | doc m%"
                  CalicoFlexVol image
                  "%
                  | optional,
                calicoNode
                  | String
                  | doc m%"
                  Calico Node image
                  "%
                  | optional,
                canalCni
                  | String
                  | doc m%"
                  Canal CNI image
                  "%
                  | optional,
                canalControllers
                  | String
                  | doc m%"
                  Canal Controllers Image needed for Calico/Canal v3.14.0+
                  "%
                  | optional,
                canalFlannel
                  | String
                  | doc m%"
                  CanalFlannel image
                  "%
                  | optional,
                canalFlexVol
                  | String
                  | doc m%"
                  CanalFlexVol image
                  "%
                  | optional,
                canalNode
                  | String
                  | doc m%"
                  Canal Node Image
                  "%
                  | optional,
                certDownloader
                  | String
                  | doc m%"
                  rke-cert-deployer image
                  "%
                  | optional,
                coredns
                  | String
                  | doc m%"
                  CoreDNS image
                  "%
                  | optional,
                corednsAutoscaler
                  | String
                  | doc m%"
                  CoreDNS autoscaler image
                  "%
                  | optional,
                dnsmasq
                  | String
                  | doc m%"
                  DNSMasq image
                  "%
                  | optional,
                etcd
                  | String
                  | doc m%"
                  etcd image
                  "%
                  | optional,
                flannel
                  | String
                  | doc m%"
                  Flannel image
                  "%
                  | optional,
                flannelCni
                  | String
                  | doc m%"
                  Flannel CNI image
                  "%
                  | optional,
                ingress
                  | String
                  | doc m%"
                  Ingress Controller image
                  "%
                  | optional,
                ingressBackend
                  | String
                  | doc m%"
                  Ingress Controller Backend image
                  "%
                  | optional,
                ingressWebhook
                  | String
                  | doc m%"
                  Ingress Webhook image
                  "%
                  | optional,
                kubedns
                  | String
                  | doc m%"
                  KubeDNS image
                  "%
                  | optional,
                kubednsAutoscaler
                  | String
                  | doc m%"
                  KubeDNS autoscaler image
                  "%
                  | optional,
                kubednsSidecar
                  | String
                  | doc m%"
                  KubeDNS side car image
                  "%
                  | optional,
                kubernetes
                  | String
                  | doc m%"
                  Kubernetes image
                  "%
                  | optional,
                kubernetesServicesSidecar
                  | String
                  | doc m%"
                  rke-service-sidekick image
                  "%
                  | optional,
                metricsServer
                  | String
                  | doc m%"
                  Metrics Server image
                  "%
                  | optional,
                nginxProxy
                  | String
                  | doc m%"
                  rke-nginx-proxy image
                  "%
                  | optional,
                nodelocal
                  | String
                  | doc m%"
                  Nodelocal image
                  "%
                  | optional,
                podInfraContainer
                  | String
                  | doc m%"
                  Pod infra container image
                  "%
                  | optional,
                weaveCni
                  | String
                  | doc m%"
                  Weave CNI image
                  "%
                  | optional,
                weaveNode
                  | String
                  | doc m%"
                  Weave Node image
                  "%
                  | optional,
                windowsPodInfraContainer
                  | String
                  | doc m%"
                  Pod infra container image for Windows
                  "%
                  | optional,
              },
          RKETaint = {
                effect | String | optional,
                key | String | optional,
                timeAdded | String | optional,
                value | String | optional,
              },
          RancherKubernetesEngineConfig = {
                addonJobTimeout
                  | std.number.Integer
                  | doc m%"
                  Timeout in seconds for status check on addon deployment jobs
                  "%
                  | optional,
                addons
                  | String
                  | doc m%"
                  YAML manifest for user provided addons to be deployed on the cluster
                  "%
                  | optional,
                addonsInclude
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of urls or paths for addons
                  "%
                  | optional,
                authentication
                  | definitions.contract.AuthnConfig
                  | doc m%"
                  Authentication configuration used in the cluster (default: x509)
                  "%
                  | optional,
                authorization
                  | definitions.contract.AuthzConfig
                  | doc m%"
                  Authorization mode configuration used in the cluster
                  "%
                  | optional,
                bastionHost
                  | definitions.contract.BastionHost
                  | doc m%"
                  Bastion/Jump Host configuration
                  "%
                  | optional,
                cloudProvider
                  | definitions.contract.CloudProvider
                  | doc m%"
                  Cloud Provider options
                  "%
                  | optional,
                clusterName
                  | String
                  | doc m%"
                  Cluster Name used in the kube config
                  "%
                  | optional,
                dns
                  | definitions.contract.DNSConfig
                  | doc m%"
                  DNS Config
                  "%
                  | optional,
                enableCriDockerd
                  | Bool
                  | doc m%"
                  Enable/disable using cri-dockerd
                  "%
                  | optional,
                ignoreDockerVersion
                  | Bool
                  | doc m%"
                  Enable/disable strict docker version checking
                  "%
                  | optional,
                ingress
                  | definitions.contract.IngressConfig
                  | doc m%"
                  Ingress controller used in the cluster
                  "%
                  | optional,
                kubernetesVersion
                  | String
                  | doc m%"
                  Kubernetes version to use (if kubernetes image is specified, image version takes precedence)
                  "%
                  | optional,
                monitoring
                  | definitions.contract.MonitoringConfig
                  | doc m%"
                  Monitoring Config
                  "%
                  | optional,
                network
                  | definitions.contract.NetworkConfig
                  | doc m%"
                  Network configuration used in the kubernetes cluster (flannel, calico)
                  "%
                  | optional,
                nodes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.RKEConfigNode
                  ])
                  | doc m%"
                  Kubernetes nodes
                  "%
                  | optional,
                prefixPath
                  | String
                  | doc m%"
                  kubernetes directory path
                  "%
                  | optional,
                privateRegistries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.PrivateRegistry
                  ])
                  | doc m%"
                  List of private registries and their credentials
                  "%
                  | optional,
                restore
                  | definitions.contract.RestoreConfig
                  | doc m%"
                  RestoreCluster flag
                  "%
                  | optional,
                rotateCertificates
                  | definitions.contract.RotateCertificates
                  | doc m%"
                  Rotating Certificates Option
                  "%
                  | optional,
                rotateEncryptionKey
                  | Bool
                  | doc m%"
                  Rotate Encryption Key Option
                  "%
                  | optional,
                services
                  | definitions.contract.RKEConfigServices
                  | doc m%"
                  Kubernetes components
                  "%
                  | optional,
                sshAgentAuth
                  | Bool
                  | doc m%"
                  SSH Agent Auth enable
                  "%
                  | optional,
                sshCertPath
                  | String
                  | doc m%"
                  SSH Certificate Path
                  "%
                  | optional,
                sshKeyPath
                  | String
                  | doc m%"
                  SSH Private Key Path
                  "%
                  | optional,
                systemImages
                  | definitions.contract.RKESystemImages
                  | doc m%"
                  List of images used internally for proxy, cert download and kubedns
                  "%
                  | optional,
                upgradeStrategy
                  | definitions.contract.NodeUpgradeStrategy
                  | doc m%"
                  Upgrade Strategy for the cluster
                  "%
                  | optional,
                winPrefixPath
                  | String
                  | doc m%"
                  kubernetes directory path for windows
                  "%
                  | optional,
              },
          ResourceConfiguration = {
                providers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ProviderConfiguration
                  ]),
                resources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
              },
          ResourceFieldSelector = {
                containerName | String | optional,
                divisor | definitions.contract.Quantity | optional,
                resource | String,
              },
          ResourceRequirements = {
                limits
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = definitions.predicate.Quantity, }
                    true
                    predicates.always
                  ])
                  | optional,
                requests
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = definitions.predicate.Quantity, }
                    true
                    predicates.always
                  ])
                  | optional,
              },
          RestoreConfig = {
                restore | Bool | optional,
                snapshotName | String | optional,
              },
          RollingUpdateDaemonSet = {
                maxSurge | definitions.contract.IntOrString | optional,
                maxUnavailable | definitions.contract.IntOrString | optional,
              },
          RollingUpdateDeployment = {
                maxSurge | definitions.contract.IntOrString | optional,
                maxUnavailable | definitions.contract.IntOrString | optional,
              },
          RotateCertificates = {
                caCertificates
                  | Bool
                  | doc m%"
                  Rotate CA Certificates
                  "%
                  | optional,
                services
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Services to rotate their certs
                  "%
                  | optional,
              },
          RouteOpenstackOpts = {
                router-id
                  | String
                  | doc m%"
                  required
                  "%,
              },
          S3BackupConfig = {
                accessKey | String | optional,
                bucketName | String | optional,
                customCa | String | optional,
                endpoint | String,
                folder | String | optional,
                region | String | optional,
                secretKey | String | optional,
              },
          ScaleIOVolumeSource = {
                fsType | String | optional,
                gateway | String,
                protectionDomain | String | optional,
                readOnly | Bool | optional,
                secretRef | definitions.contract.LocalObjectReference,
                sslEnabled | Bool | optional,
                storageMode | String | optional,
                storagePool | String | optional,
                system | String,
                volumeName | String | optional,
              },
          SchedulerService = {
                extraArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                extraBinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extraEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                image | String | optional,
                winExtraArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                winExtraBinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                winExtraEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          SecretKeySelector = {
                LocalObjectReference
                  | definitions.contract.LocalObjectReference,
                key | String,
                "optional" | Bool | optional,
              },
          SecretProjection = {
                LocalObjectReference
                  | definitions.contract.LocalObjectReference,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.KeyToPath
                  ])
                  | optional,
                "optional" | Bool | optional,
              },
          SecretVolumeSource = {
                defaultMode | std.number.Integer | optional,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.KeyToPath
                  ])
                  | optional,
                "optional" | Bool | optional,
                secretName | String | optional,
              },
          SecretboxConfiguration = {
                keys
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Key
                  ]),
              },
          SecretsEncryptionConfig = {
                customConfig
                  | definitions.contract.EncryptionConfiguration
                  | doc m%"
                  Custom Encryption Provider configuration object
                  "%
                  | optional,
                enabled
                  | Bool
                  | doc m%"
                  Enable/disable secrets encryption provider config
                  "%
                  | optional,
              },
          ServiceAccountTokenProjection = {
                audience | String | optional,
                expirationSeconds | std.number.Integer | optional,
                path | String,
              },
          ServiceOverride = {
                region | String,
                service | String,
                signing-method | String,
                signing-name | String,
                signing-region | String,
                url | String,
              },
          StorageOSVolumeSource = {
                fsType | String | optional,
                readOnly | Bool | optional,
                secretRef
                  | definitions.contract.LocalObjectReference
                  | optional,
                volumeName | String | optional,
                volumeNamespace | String | optional,
              },
          Time = {  },
          Toleration = {
                effect | String | optional,
                key | String | optional,
                operator | String | optional,
                tolerationSeconds | std.number.Integer | optional,
                value | String | optional,
              },
          TypeMeta = {
                apiVersion | String | optional,
                kind | String | optional,
              },
          TypedLocalObjectReference = {
                apiGroup | String,
                kind | String,
                name | String,
              },
          Unknown = {
                ContentEncoding | String,
                ContentType | String,
                Raw | String,
                TypeMeta | definitions.contract.TypeMeta,
              },
          VirtualCenterConfig = {
                datacenters | String | optional,
                password | String | optional,
                port
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | optional,
                soap-roundtrip-count | std.number.Integer | optional,
                user | String | optional,
              },
          VolumeProjection = {
                configMap | definitions.contract.ConfigMapProjection | optional,
                downwardAPI
                  | definitions.contract.DownwardAPIProjection
                  | optional,
                secret | definitions.contract.SecretProjection | optional,
                serviceAccountToken
                  | definitions.contract.ServiceAccountTokenProjection
                  | optional,
              },
          VolumeSource = {
                awsElasticBlockStore
                  | definitions.contract.AWSElasticBlockStoreVolumeSource
                  | optional,
                azureDisk
                  | definitions.contract.AzureDiskVolumeSource
                  | optional,
                azureFile
                  | definitions.contract.AzureFileVolumeSource
                  | optional,
                cephfs | definitions.contract.CephFSVolumeSource | optional,
                cinder | definitions.contract.CinderVolumeSource | optional,
                configMap
                  | definitions.contract.ConfigMapVolumeSource
                  | optional,
                csi | definitions.contract.CSIVolumeSource | optional,
                downwardAPI
                  | definitions.contract.DownwardAPIVolumeSource
                  | optional,
                emptyDir | definitions.contract.EmptyDirVolumeSource | optional,
                ephemeral
                  | definitions.contract.EphemeralVolumeSource
                  | optional,
                fc | definitions.contract.FCVolumeSource | optional,
                flexVolume | definitions.contract.FlexVolumeSource | optional,
                flocker | definitions.contract.FlockerVolumeSource | optional,
                gcePersistentDisk
                  | definitions.contract.GCEPersistentDiskVolumeSource
                  | optional,
                gitRepo | definitions.contract.GitRepoVolumeSource | optional,
                glusterfs
                  | definitions.contract.GlusterfsVolumeSource
                  | optional,
                hostPath | definitions.contract.HostPathVolumeSource | optional,
                iscsi | definitions.contract.ISCSIVolumeSource | optional,
                nfs | definitions.contract.NFSVolumeSource | optional,
                persistentVolumeClaim
                  | definitions.contract.PersistentVolumeClaimVolumeSource
                  | optional,
                photonPersistentDisk
                  | definitions.contract.PhotonPersistentDiskVolumeSource
                  | optional,
                portworxVolume
                  | definitions.contract.PortworxVolumeSource
                  | optional,
                projected
                  | definitions.contract.ProjectedVolumeSource
                  | optional,
                quobyte | definitions.contract.QuobyteVolumeSource | optional,
                rbd | definitions.contract.RBDVolumeSource | optional,
                scaleIO | definitions.contract.ScaleIOVolumeSource | optional,
                secret | definitions.contract.SecretVolumeSource | optional,
                storageos
                  | definitions.contract.StorageOSVolumeSource
                  | optional,
                vsphereVolume
                  | definitions.contract.VsphereVirtualDiskVolumeSource
                  | optional,
              },
          VsphereCloudProvider = {
                disk | definitions.contract.DiskVsphereOpts | optional,
                global | definitions.contract.GlobalVsphereOpts | optional,
                network | definitions.contract.NetworkVshpereOpts | optional,
                virtualCenter
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = definitions.predicate.VirtualCenterConfig, }
                    true
                    predicates.always
                  ])
                  | optional,
                workspace
                  | definitions.contract.WorkspaceVsphereOpts
                  | optional,
              },
          VsphereVirtualDiskVolumeSource = {
                fsType | String | optional,
                storagePolicyID | String | optional,
                storagePolicyName | String | optional,
                volumePath | String,
              },
          WeaveNetworkProvider = { password | String | optional, },
          WorkspaceVsphereOpts = {
                datacenter | String | optional,
                default-datastore | String | optional,
                folder | String | optional,
                resourcepool-path | String | optional,
                server | String | optional,
              },
        },
    predicate = {
          AESConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "keys" ],
                predicates.records.record
                {
                  keys = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Key
                      ],
                }
                {  }
                false
                predicates.never
              ],
          AWSCloudProvider = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "global" ],
                predicates.records.record
                {
                  global = definitions.predicate.GlobalAwsOpts,
                  serviceOverride = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = definitions.predicate.ServiceOverride, }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          AWSElasticBlockStoreVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "volumeID" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  partition = predicates.isType 'Integer,
                  readOnly = predicates.isType '"Bool",
                  volumeID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          AciNetworkProvider = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  aep = predicates.isType '"String",
                  apicHosts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  apicRefreshTime = predicates.isType '"String",
                  apicUserCrt = predicates.isType '"String",
                  apicUserKey = predicates.isType '"String",
                  apicUserName = predicates.isType '"String",
                  capic = predicates.isType '"String",
                  controllerLogLevel = predicates.isType '"String",
                  dropLogEnable = predicates.isType '"String",
                  enableEndpointSlice = predicates.isType '"String",
                  encapType = predicates.isType '"String",
                  epRegistry = predicates.isType '"String",
                  externDynamic = predicates.isType '"String",
                  externStatic = predicates.isType '"String",
                  gbpPodSubnet = predicates.isType '"String",
                  hostAgentLogLevel = predicates.isType '"String",
                  imagePullPolicy = predicates.isType '"String",
                  imagePullSecret = predicates.isType '"String",
                  infraVlan = predicates.isType '"String",
                  installIstio = predicates.isType '"String",
                  istioProfile = predicates.isType '"String",
                  kafkaBrokers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  kafkaClientCrt = predicates.isType '"String",
                  kafkaClientKey = predicates.isType '"String",
                  kubeApiVlan = predicates.isType '"String",
                  l3out = predicates.isType '"String",
                  l3outExternalNetworks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  maxNodesSvcGraph = predicates.isType '"String",
                  mcastRangeEnd = predicates.isType '"String",
                  mcastRangeStart = predicates.isType '"String",
                  noPriorityClass = predicates.isType '"String",
                  nodeSubnet = predicates.isType '"String",
                  nodeSvcSubnet = predicates.isType '"String",
                  opflexClientSsl = predicates.isType '"String",
                  opflexLogLevel = predicates.isType '"String",
                  opflexMode = predicates.isType '"String",
                  opflexServerPort = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  overlayVrfName = predicates.isType '"String",
                  ovsMemoryLimit = predicates.isType '"String",
                  pbrTrackingNonSnat = predicates.isType '"String",
                  podSubnetChunkSize = predicates.isType '"String",
                  runGbpContainer = predicates.isType '"String",
                  runOpflexServerContainer = predicates.isType '"String",
                  serviceMonitorInterval = predicates.isType '"String",
                  serviceVlan = predicates.isType '"String",
                  snatContractScope = predicates.isType '"String",
                  snatNamespace = predicates.isType '"String",
                  snatPortRangeEnd = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  snatPortRangeStart = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  snatPortsPerNode = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  subnetDomainName = predicates.isType '"String",
                  systemId = predicates.isType '"String",
                  tenant = predicates.isType '"String",
                  token = predicates.isType '"String",
                  useAciAnywhereCrd = predicates.isType '"String",
                  useAciCniPriorityClass = predicates.isType '"String",
                  useHostNetnsVolume = predicates.isType '"String",
                  useOpflexServerVolume = predicates.isType '"String",
                  usePrivilegedContainer = predicates.isType '"String",
                  vmmController = predicates.isType '"String",
                  vmmDomain = predicates.isType '"String",
                  vrfName = predicates.isType '"String",
                  vrfTenant = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          AdmissionConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "TypeMeta", "plugins" ],
                predicates.records.record
                {
                  TypeMeta = definitions.predicate.TypeMeta,
                  plugins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.AdmissionPluginConfiguration
                      ],
                }
                {  }
                false
                predicates.never
              ],
          AdmissionPluginConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "configuration", "name", "path" ],
                predicates.records.record
                {
                  configuration = definitions.predicate.Unknown,
                  name = predicates.isType '"String",
                  path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          AuditLog = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configuration = definitions.predicate.AuditLogConfig,
                  enabled = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          AuditLogConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  format = predicates.isType '"String",
                  maxAge = predicates.isType 'Integer,
                  maxBackup = predicates.isType 'Integer,
                  maxSize = predicates.isType 'Integer,
                  path = predicates.isType '"String",
                  policy = definitions.predicate.Policy,
                }
                {  }
                false
                predicates.never
              ],
          AuthWebhookConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cacheTimeout = predicates.isType '"String",
                  configFile = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          AuthnConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  sans = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  strategy = predicates.isType '"String",
                  webhook = definitions.predicate.AuthWebhookConfig,
                }
                {  }
                false
                predicates.never
              ],
          AuthzConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  mode = predicates.isType '"String",
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          AzureCloudProvider = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "aadClientCertPassword",
                  "aadClientCertPath",
                  "aadClientId",
                  "aadClientSecret",
                  "cloud",
                  "cloudProviderBackoff",
                  "cloudProviderBackoffDuration",
                  "cloudProviderBackoffExponent",
                  "cloudProviderBackoffJitter",
                  "cloudProviderBackoffRetries",
                  "cloudProviderRateLimit",
                  "cloudProviderRateLimitBucket",
                  "cloudProviderRateLimitQPS",
                  "location",
                  "maximumLoadBalancerRuleCount",
                  "primaryAvailabilitySetName",
                  "primaryScaleSetName",
                  "resourceGroup",
                  "routeTableName",
                  "securityGroupName",
                  "subnetName",
                  "subscriptionId",
                  "tenantId",
                  "useInstanceMetadata",
                  "useManagedIdentityExtension",
                  "vmType",
                  "vnetName",
                  "vnetResourceGroup"
                ],
                predicates.records.record
                {
                  aadClientCertPassword = predicates.isType '"String",
                  aadClientCertPath = predicates.isType '"String",
                  aadClientId = predicates.isType '"String",
                  aadClientSecret = predicates.isType '"String",
                  cloud = predicates.isType '"String",
                  cloudProviderBackoff = predicates.isType '"Bool",
                  cloudProviderBackoffDuration = predicates.isType 'Integer,
                  cloudProviderBackoffExponent = predicates.isType 'Integer,
                  cloudProviderBackoffJitter = predicates.isType 'Integer,
                  cloudProviderBackoffRetries = predicates.isType 'Integer,
                  cloudProviderRateLimit = predicates.isType '"Bool",
                  cloudProviderRateLimitBucket = predicates.isType 'Integer,
                  cloudProviderRateLimitQPS = predicates.isType 'Integer,
                  excludeMasterFromStandardLB = predicates.isType '"Bool",
                  loadBalancerSku = predicates.isType '"String",
                  location = predicates.isType '"String",
                  maximumLoadBalancerRuleCount = predicates.isType 'Integer,
                  primaryAvailabilitySetName = predicates.isType '"String",
                  primaryScaleSetName = predicates.isType '"String",
                  resourceGroup = predicates.isType '"String",
                  routeTableName = predicates.isType '"String",
                  securityGroupName = predicates.isType '"String",
                  subnetName = predicates.isType '"String",
                  subscriptionId = predicates.isType '"String",
                  tenantId = predicates.isType '"String",
                  useInstanceMetadata = predicates.isType '"Bool",
                  useManagedIdentityExtension = predicates.isType '"Bool",
                  userAssignedIdentityID = predicates.isType '"String",
                  vmType = predicates.isType '"String",
                  vnetName = predicates.isType '"String",
                  vnetResourceGroup = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          AzureDiskVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "diskName", "diskURI" ],
                predicates.records.record
                {
                  cachingMode = predicates.isType '"String",
                  diskName = predicates.isType '"String",
                  diskURI = predicates.isType '"String",
                  fsType = predicates.isType '"String",
                  kind = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          AzureFileVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "secretName", "shareName" ],
                predicates.records.record
                {
                  readOnly = predicates.isType '"Bool",
                  secretName = predicates.isType '"String",
                  shareName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          BackupConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "s3BackupConfig" ],
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  intervalHours = predicates.isType 'Integer,
                  retention = predicates.isType 'Integer,
                  s3BackupConfig = definitions.predicate.S3BackupConfig,
                  safeTimestamp = predicates.isType '"Bool",
                  timeout = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          BastionHost = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  address = predicates.isType '"String",
                  ignoreProxyEnvVars = predicates.isType '"Bool",
                  port = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  sshAgentAuth = predicates.isType '"Bool",
                  sshCert = predicates.isType '"String",
                  sshCertPath = predicates.isType '"String",
                  sshKey = predicates.isType '"String",
                  sshKeyPath = predicates.isType '"String",
                  user = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          BlockStorageOpenstackOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "bs-version", "ignore-volume-az", "trust-device-path" ],
                predicates.records.record
                {
                  bs-version = predicates.isType '"String",
                  ignore-volume-az = predicates.isType '"Bool",
                  trust-device-path = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          CSIVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "driver" ],
                predicates.records.record
                {
                  driver = predicates.isType '"String",
                  fsType = predicates.isType '"String",
                  nodePublishSecretRef =
                    definitions.predicate.LocalObjectReference,
                  readOnly = predicates.isType '"Bool",
                  volumeAttributes = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          CalicoNetworkProvider = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "cloudProvider" ],
                predicates.records.record
                { cloudProvider = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          CanalNetworkProvider = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "iface" ],
                predicates.records.record
                { iface = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          CephFSVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "monitors" ],
                predicates.records.record
                {
                  monitors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  path = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretFile = predicates.isType '"String",
                  secretRef = definitions.predicate.LocalObjectReference,
                  user = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CinderVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "volumeID" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretRef = definitions.predicate.LocalObjectReference,
                  volumeID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CloudProvider = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  awsCloudProvider = definitions.predicate.AWSCloudProvider,
                  azureCloudProvider = definitions.predicate.AzureCloudProvider,
                  customCloudProvider = predicates.isType '"String",
                  name = predicates.isType '"String",
                  openstackCloudProvider =
                    definitions.predicate.OpenstackCloudProvider,
                  vsphereCloudProvider =
                    definitions.predicate.VsphereCloudProvider,
                }
                {  }
                false
                predicates.never
              ],
          ConfigMapKeySelector = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "LocalObjectReference", "key" ],
                predicates.records.record
                {
                  LocalObjectReference =
                    definitions.predicate.LocalObjectReference,
                  key = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ConfigMapProjection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "LocalObjectReference" ],
                predicates.records.record
                {
                  LocalObjectReference =
                    definitions.predicate.LocalObjectReference,
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.KeyToPath
                      ],
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ConfigMapVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "LocalObjectReference" ],
                predicates.records.record
                {
                  LocalObjectReference =
                    definitions.predicate.LocalObjectReference,
                  defaultMode = predicates.isType 'Integer,
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.KeyToPath
                      ],
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          Configuration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "TypeMeta", "limits" ],
                predicates.records.record
                {
                  TypeMeta = definitions.predicate.TypeMeta,
                  limits = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Limit
                      ],
                }
                {  }
                false
                predicates.never
              ],
          DNSConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  linearAutoscalerParams =
                    definitions.predicate.LinearAutoscalerParams,
                  nodeSelector = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  nodelocal = definitions.predicate.Nodelocal,
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  provider = predicates.isType '"String",
                  reversecidrs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  stubdomains = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                        }
                        true
                        predicates.always
                      ],
                  tolerations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Toleration
                      ],
                  updateStrategy = definitions.predicate.DeploymentStrategy,
                  upstreamnameservers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          DaemonSetUpdateStrategy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  rollingUpdate = definitions.predicate.RollingUpdateDaemonSet,
                  strategy = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          DeploymentStrategy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  rollingUpdate = definitions.predicate.RollingUpdateDeployment,
                  strategy = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          DiskVsphereOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { scsicontrollertype = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          DownwardAPIProjection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DownwardAPIVolumeFile
                      ],
                }
                {  }
                false
                predicates.never
              ],
          DownwardAPIVolumeFile = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  fieldRef = definitions.predicate.ObjectFieldSelector,
                  mode = predicates.isType 'Integer,
                  path = predicates.isType '"String",
                  resourceFieldRef =
                    definitions.predicate.ResourceFieldSelector,
                }
                {  }
                false
                predicates.never
              ],
          DownwardAPIVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultMode = predicates.isType 'Integer,
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DownwardAPIVolumeFile
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Duration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } false predicates.never
              ],
          ECRCredentialPlugin = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  awsAccessKeyId = predicates.isType '"String",
                  awsAccessToken = predicates.isType '"String",
                  awsSecretAccessKey = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ETCDService = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  backupConfig = definitions.predicate.BackupConfig,
                  caCert = predicates.isType '"String",
                  cert = predicates.isType '"String",
                  creation = predicates.isType '"String",
                  externalUrls = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extraArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  extraBinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extraEnv = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  gid = predicates.isType 'Integer,
                  image = predicates.isType '"String",
                  key = predicates.isType '"String",
                  path = predicates.isType '"String",
                  retention = predicates.isType '"String",
                  snapshot = predicates.isType '"Bool",
                  uid = predicates.isType 'Integer,
                  winExtraArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  winExtraBinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  winExtraEnv = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          EmptyDirVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  medium = predicates.isType '"String",
                  sizeLimit = definitions.predicate.Quantity,
                }
                {  }
                false
                predicates.never
              ],
          EncryptionConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "resources" ],
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  kind = predicates.isType '"String",
                  resources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ResourceConfiguration
                      ],
                }
                {  }
                false
                predicates.never
              ],
          EnvVarSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configMapKeyRef = definitions.predicate.ConfigMapKeySelector,
                  fieldRef = definitions.predicate.ObjectFieldSelector,
                  resourceFieldRef =
                    definitions.predicate.ResourceFieldSelector,
                  secretKeyRef = definitions.predicate.SecretKeySelector,
                }
                {  }
                false
                predicates.never
              ],
          EphemeralVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  volumeClaimTemplate =
                    definitions.predicate.PersistentVolumeClaimTemplate,
                }
                {  }
                false
                predicates.never
              ],
          EventRateLimit = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configuration = definitions.predicate.Configuration,
                  enabled = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ExtraEnv = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  value = predicates.isType '"String",
                  valueFrom = definitions.predicate.EnvVarSource,
                }
                {  }
                false
                predicates.never
              ],
          ExtraVolume = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "VolumeSource", "name" ],
                predicates.records.record
                {
                  VolumeSource = definitions.predicate.VolumeSource,
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ExtraVolumeMount = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "mountPath", "name" ],
                predicates.records.record
                {
                  mountPath = predicates.isType '"String",
                  mountPropagation = predicates.isType '"String",
                  name = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  subPath = predicates.isType '"String",
                  subPathExpr = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FCVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  lun = predicates.isType 'Integer,
                  readOnly = predicates.isType '"Bool",
                  targetWWNs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  wwids = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FieldsV1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } false predicates.never
              ],
          FlannelNetworkProvider = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "iface" ],
                predicates.records.record
                { iface = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          FlexVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "driver" ],
                predicates.records.record
                {
                  driver = predicates.isType '"String",
                  fsType = predicates.isType '"String",
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  readOnly = predicates.isType '"Bool",
                  secretRef = definitions.predicate.LocalObjectReference,
                }
                {  }
                false
                predicates.never
              ],
          FlockerVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  datasetName = predicates.isType '"String",
                  datasetUUID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GCEPersistentDiskVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "pdName" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  partition = predicates.isType 'Integer,
                  pdName = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          GitRepoVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "repository" ],
                predicates.records.record
                {
                  directory = predicates.isType '"String",
                  repository = predicates.isType '"String",
                  revision = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GlobalAwsOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "disable-security-group-ingress",
                  "disable-strict-zone-check",
                  "elb-security-group",
                  "kubernetes-cluster-id",
                  "kubernetes-cluster-tag",
                  "role-arn",
                  "routetable-id",
                  "subnet-id",
                  "vpc",
                  "zone"
                ],
                predicates.records.record
                {
                  disable-security-group-ingress = predicates.isType '"Bool",
                  disable-strict-zone-check = predicates.isType '"Bool",
                  elb-security-group = predicates.isType '"String",
                  kubernetes-cluster-id = predicates.isType '"String",
                  kubernetes-cluster-tag = predicates.isType '"String",
                  role-arn = predicates.isType '"String",
                  routetable-id = predicates.isType '"String",
                  subnet-id = predicates.isType '"String",
                  vpc = predicates.isType '"String",
                  zone = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GlobalOpenstackOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "auth-url",
                  "ca-file",
                  "domain-id",
                  "domain-name",
                  "password",
                  "region",
                  "tenant-id",
                  "tenant-name",
                  "trust-id",
                  "user-id",
                  "username"
                ],
                predicates.records.record
                {
                  auth-url = predicates.isType '"String",
                  ca-file = predicates.isType '"String",
                  domain-id = predicates.isType '"String",
                  domain-name = predicates.isType '"String",
                  password = predicates.isType '"String",
                  region = predicates.isType '"String",
                  tenant-id = predicates.isType '"String",
                  tenant-name = predicates.isType '"String",
                  trust-id = predicates.isType '"String",
                  user-id = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GlobalVsphereOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  datacenter = predicates.isType '"String",
                  datacenters = predicates.isType '"String",
                  datastore = predicates.isType '"String",
                  insecure-flag = predicates.isType '"Bool",
                  password = predicates.isType '"String",
                  port = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  server = predicates.isType '"String",
                  soap-roundtrip-count = predicates.isType 'Integer,
                  user = predicates.isType '"String",
                  vm-name = predicates.isType '"String",
                  vm-uuid = predicates.isType '"String",
                  working-dir = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GlusterfsVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "endpoints", "path" ],
                predicates.records.record
                {
                  endpoints = predicates.isType '"String",
                  path = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          GroupResources = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  group = predicates.isType '"String",
                  resourceNames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  resources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          HostPathVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ISCSIVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "iqn", "lun", "targetPortal" ],
                predicates.records.record
                {
                  chapAuthDiscovery = predicates.isType '"Bool",
                  chapAuthSession = predicates.isType '"Bool",
                  fsType = predicates.isType '"String",
                  initiatorName = predicates.isType '"String",
                  iqn = predicates.isType '"String",
                  iscsiInterface = predicates.isType '"String",
                  lun = predicates.isType 'Integer,
                  portals = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  readOnly = predicates.isType '"Bool",
                  secretRef = definitions.predicate.LocalObjectReference,
                  targetPortal = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          IdentityConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } false predicates.never
              ],
          IngressConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultBackend = predicates.isType '"Bool",
                  defaultHttpBackendPriorityClassName = predicates.isType
                      '"String",
                  dnsPolicy = predicates.isType '"String",
                  extraArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  extraEnvs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.ExtraEnv
                      ],
                  extraVolumeMounts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ExtraVolumeMount
                      ],
                  extraVolumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ExtraVolume
                      ],
                  httpPort = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  httpsPort = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  networkMode = predicates.isType '"String",
                  nginxIngressControllerPriorityClassName = predicates.isType
                      '"String",
                  nodeSelector = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  provider = predicates.isType '"String",
                  tolerations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Toleration
                      ],
                  updateStrategy =
                    definitions.predicate.DaemonSetUpdateStrategy,
                }
                {  }
                false
                predicates.never
              ],
          IntOrString = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "IntVal", "StrVal", "Type" ],
                predicates.records.record
                {
                  IntVal = predicates.isType 'Integer,
                  StrVal = predicates.isType '"String",
                  Type = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          KMSConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "endpoint", "name" ],
                predicates.records.record
                {
                  cachesize = predicates.isType 'Integer,
                  endpoint = predicates.isType '"String",
                  name = predicates.isType '"String",
                  timeout = definitions.predicate.Duration,
                }
                {  }
                false
                predicates.never
              ],
          Key = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "secret" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  secret = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          KeyToPath = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key", "path" ],
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  mode = predicates.isType 'Integer,
                  path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          KubeAPIService = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  admissionConfiguration =
                    definitions.predicate.AdmissionConfiguration,
                  alwaysPullImages = predicates.isType '"Bool",
                  auditLog = definitions.predicate.AuditLog,
                  eventRateLimit = definitions.predicate.EventRateLimit,
                  extraArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  extraBinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extraEnv = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  image = predicates.isType '"String",
                  podSecurityPolicy = predicates.isType '"Bool",
                  secretsEncryptionConfig =
                    definitions.predicate.SecretsEncryptionConfig,
                  serviceClusterIpRange = predicates.isType '"String",
                  serviceNodePortRange = predicates.isType '"String",
                  winExtraArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  winExtraBinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  winExtraEnv = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          KubeControllerService = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clusterCidr = predicates.isType '"String",
                  extraArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  extraBinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extraEnv = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  image = predicates.isType '"String",
                  serviceClusterIpRange = predicates.isType '"String",
                  winExtraArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  winExtraBinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  winExtraEnv = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          KubeletService = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clusterDnsServer = predicates.isType '"String",
                  clusterDomain = predicates.isType '"String",
                  extraArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  extraBinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extraEnv = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  failSwapOn = predicates.isType '"Bool",
                  generateServingCertificate = predicates.isType '"Bool",
                  image = predicates.isType '"String",
                  infraContainerImage = predicates.isType '"String",
                  winExtraArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  winExtraBinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  winExtraEnv = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          KubeproxyService = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  extraArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  extraBinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extraEnv = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  image = predicates.isType '"String",
                  winExtraArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  winExtraBinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  winExtraEnv = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          LabelSelector = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  matchExpressions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.LabelSelectorRequirement
                      ],
                  matchLabels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          LabelSelectorRequirement = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key", "operator" ],
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  operator = predicates.isType '"String",
                  values = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Limit = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "burst", "qps", "type" ],
                predicates.records.record
                {
                  burst = predicates.isType 'Integer,
                  cacheSize = predicates.isType 'Integer,
                  qps = predicates.isType 'Integer,
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          LinearAutoscalerParams = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  coresPerReplica = predicates.isType '"Number",
                  max = predicates.isType 'Integer,
                  min = predicates.isType 'Integer,
                  nodesPerReplica = predicates.isType '"Number",
                  preventSinglePointFailure = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          LoadBalancerOpenstackOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "create-monitor",
                  "floating-network-id",
                  "lb-method",
                  "lb-provider",
                  "lb-version",
                  "manage-security-groups",
                  "monitor-delay",
                  "monitor-max-retries",
                  "monitor-timeout",
                  "subnet-id",
                  "use-octavia"
                ],
                predicates.records.record
                {
                  create-monitor = predicates.isType '"Bool",
                  floating-network-id = predicates.isType '"String",
                  lb-method = predicates.isType '"String",
                  lb-provider = predicates.isType '"String",
                  lb-version = predicates.isType '"String",
                  manage-security-groups = predicates.isType '"Bool",
                  monitor-delay = predicates.isType '"String",
                  monitor-max-retries = predicates.isType 'Integer,
                  monitor-timeout = predicates.isType '"String",
                  subnet-id = predicates.isType '"String",
                  use-octavia = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          LocalObjectReference = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { name = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          ManagedFieldsEntry = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  fieldsType = predicates.isType '"String",
                  fieldsV1 = definitions.predicate.FieldsV1,
                  manager = predicates.isType '"String",
                  operation = predicates.isType '"String",
                  time = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          MetadataOpenstackOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "request-timeout", "search-order" ],
                predicates.records.record
                {
                  request-timeout = predicates.isType 'Integer,
                  search-order = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          MonitoringConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  metricsServerPriorityClassName = predicates.isType '"String",
                  nodeSelector = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  provider = predicates.isType '"String",
                  replicas = predicates.isType 'Integer,
                  tolerations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Toleration
                      ],
                  updateStrategy = definitions.predicate.DeploymentStrategy,
                }
                {  }
                false
                predicates.never
              ],
          NFSVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path", "server" ],
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  server = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          NetworkConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  aciNetworkProvider = definitions.predicate.AciNetworkProvider,
                  calicoNetworkProvider =
                    definitions.predicate.CalicoNetworkProvider,
                  canalNetworkProvider =
                    definitions.predicate.CanalNetworkProvider,
                  flannelNetworkProvider =
                    definitions.predicate.FlannelNetworkProvider,
                  mtu = predicates.isType 'Integer,
                  nodeSelector = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  plugin = predicates.isType '"String",
                  tolerations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Toleration
                      ],
                  updateStrategy =
                    definitions.predicate.DaemonSetUpdateStrategy,
                  weaveNetworkProvider =
                    definitions.predicate.WeaveNetworkProvider,
                }
                {  }
                false
                predicates.never
              ],
          NetworkVshpereOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { public-network = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          NodeDrainInput = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "timeout" ],
                predicates.records.record
                {
                  deleteLocalData = predicates.isType '"Bool",
                  "force" = predicates.isType '"Bool",
                  gracePeriod = predicates.isType 'Integer,
                  ignoreDaemonSets = predicates.isType '"Bool",
                  timeout = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          NodeUpgradeStrategy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  drain = predicates.isType '"Bool",
                  maxUnavailableControlplane = predicates.isType '"String",
                  maxUnavailableWorker = predicates.isType '"String",
                  nodeDrainInput = definitions.predicate.NodeDrainInput,
                }
                {  }
                false
                predicates.never
              ],
          Nodelocal = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ipAddress = predicates.isType '"String",
                  nodeLocalDnsPriorityClassName = predicates.isType '"String",
                  nodeSelector = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  updateStrategy =
                    definitions.predicate.DaemonSetUpdateStrategy,
                }
                {  }
                false
                predicates.never
              ],
          ObjectFieldSelector = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fieldPath" ],
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  fieldPath = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ObjectMeta = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotations = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  clusterName = predicates.isType '"String",
                  creationTimestamp = definitions.predicate.Time,
                  deletionGracePeriodSeconds = predicates.isType 'Integer,
                  deletionTimestamp = predicates.isType '"String",
                  finalizers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  generateName = predicates.isType '"String",
                  generation = predicates.isType 'Integer,
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  managedFields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ManagedFieldsEntry
                      ],
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  ownerReferences = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.OwnerReference
                      ],
                  resourceVersion = predicates.isType '"String",
                  selfLink = predicates.isType '"String",
                  uid = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          OpenstackCloudProvider = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "blockStorage",
                  "global",
                  "loadBalancer",
                  "metadata",
                  "route"
                ],
                predicates.records.record
                {
                  blockStorage =
                    definitions.predicate.BlockStorageOpenstackOpts,
                  global = definitions.predicate.GlobalOpenstackOpts,
                  loadBalancer =
                    definitions.predicate.LoadBalancerOpenstackOpts,
                  metadata = definitions.predicate.MetadataOpenstackOpts,
                  route = definitions.predicate.RouteOpenstackOpts,
                }
                {  }
                false
                predicates.never
              ],
          OwnerReference = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "apiVersion", "kind", "name", "uid" ],
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  blockOwnerDeletion = predicates.isType '"Bool",
                  controller = predicates.isType '"Bool",
                  kind = predicates.isType '"String",
                  name = predicates.isType '"String",
                  uid = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PersistentVolumeClaimSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessModes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  dataSource = definitions.predicate.TypedLocalObjectReference,
                  resources = definitions.predicate.ResourceRequirements,
                  selector = definitions.predicate.LabelSelector,
                  storageClassName = predicates.isType '"String",
                  volumeMode = predicates.isType '"String",
                  volumeName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PersistentVolumeClaimTemplate = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "spec" ],
                predicates.records.record
                {
                  metadata = definitions.predicate.ObjectMeta,
                  spec = definitions.predicate.PersistentVolumeClaimSpec,
                }
                {  }
                false
                predicates.never
              ],
          PersistentVolumeClaimVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "claimName" ],
                predicates.records.record
                {
                  claimName = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          PhotonPersistentDiskVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "pdID" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  pdID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Policy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "TypeMeta", "rules" ],
                predicates.records.record
                {
                  TypeMeta = definitions.predicate.TypeMeta,
                  metadata = definitions.predicate.ObjectMeta,
                  omitStages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  rules = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.PolicyRule
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PolicyRule = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "level" ],
                predicates.records.record
                {
                  level = predicates.isType '"String",
                  namespaces = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  nonResourceURLs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  omitStages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  resources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.GroupResources
                      ],
                  userGroups = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  users = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  verbs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PortworxVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "volumeID" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  volumeID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PrivateRegistry = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ecrCredentialPlugin =
                    definitions.predicate.ECRCredentialPlugin,
                  isDefault = predicates.isType '"Bool",
                  password = predicates.isType '"String",
                  url = predicates.isType '"String",
                  user = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ProjectedVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "sources" ],
                predicates.records.record
                {
                  defaultMode = predicates.isType 'Integer,
                  sources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.VolumeProjection
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ProviderConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  aescbc = definitions.predicate.AESConfiguration,
                  aesgcm = definitions.predicate.AESConfiguration,
                  identity = definitions.predicate.IdentityConfiguration,
                  kms = definitions.predicate.KMSConfiguration,
                  secretbox = definitions.predicate.SecretboxConfiguration,
                }
                {  }
                false
                predicates.never
              ],
          Quantity = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } false predicates.never
              ],
          QuobyteVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "registry", "volume" ],
                predicates.records.record
                {
                  group = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  registry = predicates.isType '"String",
                  tenant = predicates.isType '"String",
                  user = predicates.isType '"String",
                  volume = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          RBDVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image", "monitors" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  image = predicates.isType '"String",
                  keyring = predicates.isType '"String",
                  monitors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  pool = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretRef = definitions.predicate.LocalObjectReference,
                  user = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          RKEConfigNode = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  address = predicates.isType '"String",
                  dockerSocket = predicates.isType '"String",
                  hostnameOverride = predicates.isType '"String",
                  internalAddress = predicates.isType '"String",
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  nodeName = predicates.isType '"String",
                  port = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  role = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  sshAgentAuth = predicates.isType '"Bool",
                  sshCert = predicates.isType '"String",
                  sshCertPath = predicates.isType '"String",
                  sshKey = predicates.isType '"String",
                  sshKeyPath = predicates.isType '"String",
                  taints = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.RKETaint
                      ],
                  user = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          RKEConfigServices = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  etcd = definitions.predicate.ETCDService,
                  kubeApi = definitions.predicate.KubeAPIService,
                  kubeController = definitions.predicate.KubeControllerService,
                  kubelet = definitions.predicate.KubeletService,
                  kubeproxy = definitions.predicate.KubeproxyService,
                  scheduler = definitions.predicate.SchedulerService,
                }
                {  }
                false
                predicates.never
              ],
          RKESystemImages = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  aciCniDeployContainer = predicates.isType '"String",
                  aciControllerContainer = predicates.isType '"String",
                  aciGbpServerContainer = predicates.isType '"String",
                  aciHostContainer = predicates.isType '"String",
                  aciMcastContainer = predicates.isType '"String",
                  aciOpflexContainer = predicates.isType '"String",
                  aciOpflexServerContainer = predicates.isType '"String",
                  aciOvsContainer = predicates.isType '"String",
                  alpine = predicates.isType '"String",
                  calicoCni = predicates.isType '"String",
                  calicoControllers = predicates.isType '"String",
                  calicoCtl = predicates.isType '"String",
                  calicoFlexVol = predicates.isType '"String",
                  calicoNode = predicates.isType '"String",
                  canalCni = predicates.isType '"String",
                  canalControllers = predicates.isType '"String",
                  canalFlannel = predicates.isType '"String",
                  canalFlexVol = predicates.isType '"String",
                  canalNode = predicates.isType '"String",
                  certDownloader = predicates.isType '"String",
                  coredns = predicates.isType '"String",
                  corednsAutoscaler = predicates.isType '"String",
                  dnsmasq = predicates.isType '"String",
                  etcd = predicates.isType '"String",
                  flannel = predicates.isType '"String",
                  flannelCni = predicates.isType '"String",
                  ingress = predicates.isType '"String",
                  ingressBackend = predicates.isType '"String",
                  ingressWebhook = predicates.isType '"String",
                  kubedns = predicates.isType '"String",
                  kubednsAutoscaler = predicates.isType '"String",
                  kubednsSidecar = predicates.isType '"String",
                  kubernetes = predicates.isType '"String",
                  kubernetesServicesSidecar = predicates.isType '"String",
                  metricsServer = predicates.isType '"String",
                  nginxProxy = predicates.isType '"String",
                  nodelocal = predicates.isType '"String",
                  podInfraContainer = predicates.isType '"String",
                  weaveCni = predicates.isType '"String",
                  weaveNode = predicates.isType '"String",
                  windowsPodInfraContainer = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          RKETaint = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  effect = predicates.isType '"String",
                  key = predicates.isType '"String",
                  timeAdded = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          RancherKubernetesEngineConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addonJobTimeout = predicates.isType 'Integer,
                  addons = predicates.isType '"String",
                  addonsInclude = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  authentication = definitions.predicate.AuthnConfig,
                  authorization = definitions.predicate.AuthzConfig,
                  bastionHost = definitions.predicate.BastionHost,
                  cloudProvider = definitions.predicate.CloudProvider,
                  clusterName = predicates.isType '"String",
                  dns = definitions.predicate.DNSConfig,
                  enableCriDockerd = predicates.isType '"Bool",
                  ignoreDockerVersion = predicates.isType '"Bool",
                  ingress = definitions.predicate.IngressConfig,
                  kubernetesVersion = predicates.isType '"String",
                  monitoring = definitions.predicate.MonitoringConfig,
                  network = definitions.predicate.NetworkConfig,
                  nodes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.RKEConfigNode
                      ],
                  prefixPath = predicates.isType '"String",
                  privateRegistries = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.PrivateRegistry
                      ],
                  restore = definitions.predicate.RestoreConfig,
                  rotateCertificates = definitions.predicate.RotateCertificates,
                  rotateEncryptionKey = predicates.isType '"Bool",
                  services = definitions.predicate.RKEConfigServices,
                  sshAgentAuth = predicates.isType '"Bool",
                  sshCertPath = predicates.isType '"String",
                  sshKeyPath = predicates.isType '"String",
                  systemImages = definitions.predicate.RKESystemImages,
                  upgradeStrategy = definitions.predicate.NodeUpgradeStrategy,
                  winPrefixPath = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ResourceConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "providers", "resources" ],
                predicates.records.record
                {
                  providers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ProviderConfiguration
                      ],
                  resources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ResourceFieldSelector = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "resource" ],
                predicates.records.record
                {
                  containerName = predicates.isType '"String",
                  divisor = definitions.predicate.Quantity,
                  resource = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ResourceRequirements = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  limits = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = definitions.predicate.Quantity, }
                        true
                        predicates.always
                      ],
                  requests = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = definitions.predicate.Quantity, }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          RestoreConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  restore = predicates.isType '"Bool",
                  snapshotName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          RollingUpdateDaemonSet = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  maxSurge = definitions.predicate.IntOrString,
                  maxUnavailable = definitions.predicate.IntOrString,
                }
                {  }
                false
                predicates.never
              ],
          RollingUpdateDeployment = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  maxSurge = definitions.predicate.IntOrString,
                  maxUnavailable = definitions.predicate.IntOrString,
                }
                {  }
                false
                predicates.never
              ],
          RotateCertificates = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  caCertificates = predicates.isType '"Bool",
                  services = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          RouteOpenstackOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "router-id" ],
                predicates.records.record
                { router-id = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          S3BackupConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "endpoint" ],
                predicates.records.record
                {
                  accessKey = predicates.isType '"String",
                  bucketName = predicates.isType '"String",
                  customCa = predicates.isType '"String",
                  endpoint = predicates.isType '"String",
                  folder = predicates.isType '"String",
                  region = predicates.isType '"String",
                  secretKey = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ScaleIOVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "gateway", "secretRef", "system" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  gateway = predicates.isType '"String",
                  protectionDomain = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretRef = definitions.predicate.LocalObjectReference,
                  sslEnabled = predicates.isType '"Bool",
                  storageMode = predicates.isType '"String",
                  storagePool = predicates.isType '"String",
                  system = predicates.isType '"String",
                  volumeName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SchedulerService = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  extraArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  extraBinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extraEnv = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  image = predicates.isType '"String",
                  winExtraArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  winExtraBinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  winExtraEnv = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          SecretKeySelector = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "LocalObjectReference", "key" ],
                predicates.records.record
                {
                  LocalObjectReference =
                    definitions.predicate.LocalObjectReference,
                  key = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          SecretProjection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "LocalObjectReference" ],
                predicates.records.record
                {
                  LocalObjectReference =
                    definitions.predicate.LocalObjectReference,
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.KeyToPath
                      ],
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          SecretVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultMode = predicates.isType 'Integer,
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.KeyToPath
                      ],
                  "optional" = predicates.isType '"Bool",
                  secretName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SecretboxConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "keys" ],
                predicates.records.record
                {
                  keys = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Key
                      ],
                }
                {  }
                false
                predicates.never
              ],
          SecretsEncryptionConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  customConfig = definitions.predicate.EncryptionConfiguration,
                  enabled = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ServiceAccountTokenProjection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  audience = predicates.isType '"String",
                  expirationSeconds = predicates.isType 'Integer,
                  path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ServiceOverride = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "region",
                  "service",
                  "signing-method",
                  "signing-name",
                  "signing-region",
                  "url"
                ],
                predicates.records.record
                {
                  region = predicates.isType '"String",
                  service = predicates.isType '"String",
                  signing-method = predicates.isType '"String",
                  signing-name = predicates.isType '"String",
                  signing-region = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          StorageOSVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretRef = definitions.predicate.LocalObjectReference,
                  volumeName = predicates.isType '"String",
                  volumeNamespace = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Time = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } false predicates.never
              ],
          Toleration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  effect = predicates.isType '"String",
                  key = predicates.isType '"String",
                  operator = predicates.isType '"String",
                  tolerationSeconds = predicates.isType 'Integer,
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          TypeMeta = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  kind = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          TypedLocalObjectReference = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "apiGroup", "kind", "name" ],
                predicates.records.record
                {
                  apiGroup = predicates.isType '"String",
                  kind = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Unknown = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "ContentEncoding", "ContentType", "Raw", "TypeMeta" ],
                predicates.records.record
                {
                  ContentEncoding = predicates.isType '"String",
                  ContentType = predicates.isType '"String",
                  Raw = predicates.isType '"String",
                  TypeMeta = definitions.predicate.TypeMeta,
                }
                {  }
                false
                predicates.never
              ],
          VirtualCenterConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  datacenters = predicates.isType '"String",
                  password = predicates.isType '"String",
                  port = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  soap-roundtrip-count = predicates.isType 'Integer,
                  user = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          VolumeProjection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configMap = definitions.predicate.ConfigMapProjection,
                  downwardAPI = definitions.predicate.DownwardAPIProjection,
                  secret = definitions.predicate.SecretProjection,
                  serviceAccountToken =
                    definitions.predicate.ServiceAccountTokenProjection,
                }
                {  }
                false
                predicates.never
              ],
          VolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  awsElasticBlockStore =
                    definitions.predicate.AWSElasticBlockStoreVolumeSource,
                  azureDisk = definitions.predicate.AzureDiskVolumeSource,
                  azureFile = definitions.predicate.AzureFileVolumeSource,
                  cephfs = definitions.predicate.CephFSVolumeSource,
                  cinder = definitions.predicate.CinderVolumeSource,
                  configMap = definitions.predicate.ConfigMapVolumeSource,
                  csi = definitions.predicate.CSIVolumeSource,
                  downwardAPI = definitions.predicate.DownwardAPIVolumeSource,
                  emptyDir = definitions.predicate.EmptyDirVolumeSource,
                  ephemeral = definitions.predicate.EphemeralVolumeSource,
                  fc = definitions.predicate.FCVolumeSource,
                  flexVolume = definitions.predicate.FlexVolumeSource,
                  flocker = definitions.predicate.FlockerVolumeSource,
                  gcePersistentDisk =
                    definitions.predicate.GCEPersistentDiskVolumeSource,
                  gitRepo = definitions.predicate.GitRepoVolumeSource,
                  glusterfs = definitions.predicate.GlusterfsVolumeSource,
                  hostPath = definitions.predicate.HostPathVolumeSource,
                  iscsi = definitions.predicate.ISCSIVolumeSource,
                  nfs = definitions.predicate.NFSVolumeSource,
                  persistentVolumeClaim =
                    definitions.predicate.PersistentVolumeClaimVolumeSource,
                  photonPersistentDisk =
                    definitions.predicate.PhotonPersistentDiskVolumeSource,
                  portworxVolume = definitions.predicate.PortworxVolumeSource,
                  projected = definitions.predicate.ProjectedVolumeSource,
                  quobyte = definitions.predicate.QuobyteVolumeSource,
                  rbd = definitions.predicate.RBDVolumeSource,
                  scaleIO = definitions.predicate.ScaleIOVolumeSource,
                  secret = definitions.predicate.SecretVolumeSource,
                  storageos = definitions.predicate.StorageOSVolumeSource,
                  vsphereVolume =
                    definitions.predicate.VsphereVirtualDiskVolumeSource,
                }
                {  }
                false
                predicates.never
              ],
          VsphereCloudProvider = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  disk = definitions.predicate.DiskVsphereOpts,
                  global = definitions.predicate.GlobalVsphereOpts,
                  network = definitions.predicate.NetworkVshpereOpts,
                  virtualCenter = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = definitions.predicate.VirtualCenterConfig, }
                        true
                        predicates.always
                      ],
                  workspace = definitions.predicate.WorkspaceVsphereOpts,
                }
                {  }
                false
                predicates.never
              ],
          VsphereVirtualDiskVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "volumePath" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  storagePolicyID = predicates.isType '"String",
                  storagePolicyName = predicates.isType '"String",
                  volumePath = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          WeaveNetworkProvider = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { password = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          WorkspaceVsphereOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  datacenter = predicates.isType '"String",
                  default-datastore = predicates.isType '"String",
                  folder = predicates.isType '"String",
                  resourcepool-path = predicates.isType '"String",
                  server = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

definitions.contract.RancherKubernetesEngineConfig