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
                Keys
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Key
                  ]),
              },
          AWSCloudProvider = {
                global | definitions.contract.GlobalAwsOpts,
                service_override
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
                FSType | String,
                Partition | std.number.Integer,
                ReadOnly | Bool,
                VolumeID | String,
              },
          AciNetworkProvider = {
                aep | String | optional,
                apic_hosts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                apic_refresh_time | String | optional,
                apic_user_crt | String | optional,
                apic_user_key | String | optional,
                apic_user_name | String | optional,
                capic | String | optional,
                controller_log_level | String | optional,
                drop_log_enable | String | optional,
                enable_endpoint_slice | String | optional,
                encap_type | String | optional,
                ep_registry | String | optional,
                extern_dynamic | String | optional,
                extern_static | String | optional,
                gbp_pod_subnet | String | optional,
                host_agent_log_level | String | optional,
                image_pull_policy | String | optional,
                image_pull_secret | String | optional,
                infra_vlan | String | optional,
                install_istio | String | optional,
                istio_profile | String | optional,
                kafka_brokers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                kafka_client_crt | String | optional,
                kafka_client_key | String | optional,
                kube_api_vlan | String | optional,
                l3out | String | optional,
                l3out_external_networks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                max_nodes_svc_graph | String | optional,
                mcast_range_end | String | optional,
                mcast_range_start | String | optional,
                no_priority_class | String | optional,
                node_subnet | String | optional,
                node_svc_subnet | String | optional,
                opflex_client_ssl | String | optional,
                opflex_log_level | String | optional,
                opflex_mode | String | optional,
                opflex_server_port
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | optional,
                overlay_vrf_name | String | optional,
                ovs_memory_limit | String | optional,
                pbr_tracking_non_snat | String | optional,
                pod_subnet_chunk_size | String | optional,
                run_gbp_container | String | optional,
                run_opflex_server_container | String | optional,
                service_monitor_interval | String | optional,
                service_vlan | String | optional,
                snat_contract_scope | String | optional,
                snat_namespace | String | optional,
                snat_port_range_end
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | optional,
                snat_port_range_start
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | optional,
                snat_ports_per_node
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | optional,
                subnet_domain_name | String | optional,
                system_id | String | optional,
                tenant | String | optional,
                token | String | optional,
                use_aci_anywhere_crd | String | optional,
                use_aci_cni_priority_class | String | optional,
                use_host_netns_volume | String | optional,
                use_opflex_server_volume | String | optional,
                use_privileged_container | String | optional,
                vmm_controller | String | optional,
                vmm_domain | String | optional,
                vrf_name | String | optional,
                vrf_tenant | String | optional,
              },
          AdmissionConfiguration = {
                APIVersion | String,
                Kind | String,
                Plugins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.AdmissionPluginConfiguration
                  ]),
              },
          AdmissionPluginConfiguration = {
                Configuration | definitions.contract.Unknown,
                Name | String,
                Path | String,
              },
          AuditLog = {
                configuration | definitions.contract.AuditLogConfig | optional,
                enabled | Bool | optional,
              },
          AuditLogConfig = {
                format | String | optional,
                max_age | std.number.Integer | optional,
                max_backup | std.number.Integer | optional,
                max_size | std.number.Integer | optional,
                path | String | optional,
                policy | definitions.contract.Policy | optional,
              },
          AuthWebhookConfig = {
                cache_timeout
                  | String
                  | doc m%"
                  CacheTimeout controls how long to cache authentication decisions
                  "%
                  | optional,
                config_file
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
                CachingMode | String,
                DataDiskURI | String,
                DiskName | String,
                FSType | String,
                Kind | String,
                ReadOnly | Bool,
              },
          AzureFileVolumeSource = {
                ReadOnly | Bool,
                SecretName | String,
                ShareName | String,
              },
          BackupConfig = {
                S3BackupConfig | definitions.contract.S3BackupConfig | optional,
                enabled | Bool,
                interval_hours | std.number.Integer,
                retention | std.number.Integer,
                safe_timestamp | Bool,
                timeout | std.number.Integer,
              },
          BastionHost = {
                address
                  | String
                  | doc m%"
                  Address of Bastion Host
                  "%
                  | optional,
                ignore_proxy_env_vars
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
                ssh_agent_auth
                  | Bool
                  | doc m%"
                  SSH Agent Auth enable
                  "%
                  | optional,
                ssh_cert
                  | String
                  | doc m%"
                  SSH Certificate
                  "%
                  | optional,
                ssh_cert_path
                  | String
                  | doc m%"
                  SSH Certificate Path
                  "%
                  | optional,
                ssh_key
                  | String
                  | doc m%"
                  SSH Private Key
                  "%
                  | optional,
                ssh_key_path
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
                Driver | String,
                FSType | String,
                NodePublishSecretRef
                  | definitions.contract.LocalObjectReference,
                ReadOnly | Bool,
                VolumeAttributes
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
                  ]),
              },
          CalicoNetworkProvider = {
                CloudProvider
                  | String
                  | doc m%"
                  Cloud provider type used with calico
                  "%,
              },
          CanalNetworkProvider = { Iface | String, },
          CephFSVolumeSource = {
                Monitors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                Path | String,
                ReadOnly | Bool,
                SecretFile | String,
                SecretRef | definitions.contract.LocalObjectReference,
                User | String,
              },
          CinderVolumeSource = {
                FSType | String,
                ReadOnly | Bool,
                SecretRef | definitions.contract.LocalObjectReference,
                VolumeID | String,
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
                Key | String,
                Name | String,
                Optional | Bool,
              },
          ConfigMapProjection = {
                Items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.KeyToPath
                  ]),
                Name | String,
                Optional | Bool,
              },
          ConfigMapVolumeSource = {
                DefaultMode | std.number.Integer,
                Items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.KeyToPath
                  ]),
                Name | String,
                Optional | Bool,
              },
          Configuration = {
                APIVersion | String,
                Kind | String,
                Limits
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Limit
                  ]),
              },
          DNSConfig = {
                linear_autoscaler_params
                  | definitions.contract.LinearAutoscalerParams
                  | doc m%"
                  Autoscaler fields to determine number of dns replicas
                  "%
                  | optional,
                node_selector
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
                update_strategy
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
                RollingUpdate | definitions.contract.RollingUpdateDaemonSet,
                Strategy | String,
              },
          DeploymentStrategy = {
                RollingUpdate | definitions.contract.RollingUpdateDeployment,
                Strategy | String,
              },
          DiskVsphereOpts = { scsicontrollertype | String | optional, },
          DownwardAPIProjection = {
                Items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.DownwardAPIVolumeFile
                  ]),
              },
          DownwardAPIVolumeFile = {
                FieldRef | definitions.contract.ObjectFieldSelector,
                Mode | std.number.Integer,
                Path | String,
                ResourceFieldRef | definitions.contract.ResourceFieldSelector,
              },
          DownwardAPIVolumeSource = {
                DefaultMode | std.number.Integer,
                Items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.DownwardAPIVolumeFile
                  ]),
              },
          Duration = {  },
          ECRCredentialPlugin = {
                aws_access_key_id | String,
                aws_secret_access_key | String,
                aws_session_token | String,
              },
          ETCDService = {
                backup_config
                  | definitions.contract.BackupConfig
                  | doc m%"
                  Backup backend for etcd snapshots
                  "%
                  | optional,
                ca_cert
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
                external_urls
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
                extra_args
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
                extra_binds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extra_env
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
                win_extra_args
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
                win_extra_binds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                win_extra_env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          EmptyDirVolumeSource = {
                Medium | String,
                SizeLimit | definitions.contract.Quantity,
              },
          EncryptionConfiguration = {
                APIVersion | String,
                Kind | String,
                Resources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ResourceConfiguration
                  ]),
              },
          EnvVarSource = {
                ConfigMapKeyRef | definitions.contract.ConfigMapKeySelector,
                FieldRef | definitions.contract.ObjectFieldSelector,
                ResourceFieldRef | definitions.contract.ResourceFieldSelector,
                SecretKeyRef | definitions.contract.SecretKeySelector,
              },
          EphemeralVolumeSource = {
                VolumeClaimTemplate
                  | definitions.contract.PersistentVolumeClaimTemplate,
              },
          EventRateLimit = {
                configuration | definitions.contract.Configuration | optional,
                enabled | Bool | optional,
              },
          ExtraEnv = {
                Name | String,
                Value | String,
                ValueFrom | definitions.contract.EnvVarSource,
              },
          ExtraVolume = {
                AWSElasticBlockStore
                  | definitions.contract.AWSElasticBlockStoreVolumeSource,
                AzureDisk | definitions.contract.AzureDiskVolumeSource,
                AzureFile | definitions.contract.AzureFileVolumeSource,
                CSI | definitions.contract.CSIVolumeSource,
                CephFS | definitions.contract.CephFSVolumeSource,
                Cinder | definitions.contract.CinderVolumeSource,
                ConfigMap | definitions.contract.ConfigMapVolumeSource,
                DownwardAPI | definitions.contract.DownwardAPIVolumeSource,
                EmptyDir | definitions.contract.EmptyDirVolumeSource,
                Ephemeral | definitions.contract.EphemeralVolumeSource,
                FC | definitions.contract.FCVolumeSource,
                FlexVolume | definitions.contract.FlexVolumeSource,
                Flocker | definitions.contract.FlockerVolumeSource,
                GCEPersistentDisk
                  | definitions.contract.GCEPersistentDiskVolumeSource,
                GitRepo | definitions.contract.GitRepoVolumeSource,
                Glusterfs | definitions.contract.GlusterfsVolumeSource,
                HostPath | definitions.contract.HostPathVolumeSource,
                ISCSI | definitions.contract.ISCSIVolumeSource,
                NFS | definitions.contract.NFSVolumeSource,
                Name | String,
                PersistentVolumeClaim
                  | definitions.contract.PersistentVolumeClaimVolumeSource,
                PhotonPersistentDisk
                  | definitions.contract.PhotonPersistentDiskVolumeSource,
                PortworxVolume | definitions.contract.PortworxVolumeSource,
                Projected | definitions.contract.ProjectedVolumeSource,
                Quobyte | definitions.contract.QuobyteVolumeSource,
                RBD | definitions.contract.RBDVolumeSource,
                ScaleIO | definitions.contract.ScaleIOVolumeSource,
                Secret | definitions.contract.SecretVolumeSource,
                StorageOS | definitions.contract.StorageOSVolumeSource,
                VsphereVolume
                  | definitions.contract.VsphereVirtualDiskVolumeSource,
              },
          ExtraVolumeMount = {
                MountPath | String,
                MountPropagation | String,
                Name | String,
                ReadOnly | Bool,
                SubPath | String,
                SubPathExpr | String,
              },
          FCVolumeSource = {
                FSType | String,
                Lun | std.number.Integer,
                ReadOnly | Bool,
                TargetWWNs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                WWIDs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
              },
          FieldsV1 = { Raw | String, },
          FlannelNetworkProvider = {
                Iface
                  | String
                  | doc m%"
                  Alternate cloud interface for flannel
                  "%,
              },
          FlexVolumeSource = {
                Driver | String,
                FSType | String,
                Options
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
                  ]),
                ReadOnly | Bool,
                SecretRef | definitions.contract.LocalObjectReference,
              },
          FlockerVolumeSource = { DatasetName | String, DatasetUUID | String, },
          GCEPersistentDiskVolumeSource = {
                FSType | String,
                PDName | String,
                Partition | std.number.Integer,
                ReadOnly | Bool,
              },
          GitRepoVolumeSource = {
                Directory | String,
                Repository | String,
                Revision | String,
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
                EndpointsName | String,
                Path | String,
                ReadOnly | Bool,
              },
          GroupResources = {
                Group | String,
                ResourceNames
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                Resources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
              },
          HostPathVolumeSource = { Path | String, Type | String, },
          ISCSIVolumeSource = {
                DiscoveryCHAPAuth | Bool,
                FSType | String,
                IQN | String,
                ISCSIInterface | String,
                InitiatorName | String,
                Lun | std.number.Integer,
                Portals
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                ReadOnly | Bool,
                SecretRef | definitions.contract.LocalObjectReference,
                SessionCHAPAuth | Bool,
                TargetPortal | String,
              },
          IdentityConfiguration = {  },
          IngressConfig = {
                default_backend
                  | Bool
                  | doc m%"
                  Enable or disable nginx default-http-backend
                  "%
                  | optional,
                default_http_backend_priority_class_name
                  | String
                  | doc m%"
                  Priority class name for Nginx-Ingress's "default-http-backend" deployment
                  "%
                  | optional,
                dns_policy
                  | String
                  | doc m%"
                  DNS Policy
                  "%
                  | optional,
                extra_args
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
                extra_envs
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
                extra_volume_mounts
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
                extra_volumes
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
                http_port
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | doc m%"
                  Http port for ingress controller daemonset
                  "%
                  | optional,
                https_port
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | doc m%"
                  Https port for ingress controller daemonset
                  "%
                  | optional,
                network_mode
                  | String
                  | doc m%"
                  NetworkMode selector for ingress controller pods. Default is HostNetwork
                  "%
                  | optional,
                nginx_ingress_controller_priority_class_name
                  | String
                  | doc m%"
                  Priority class name for Nginx-Ingress's "nginx-ingress-controller" daemonset
                  "%
                  | optional,
                node_selector
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
                update_strategy
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
                CacheSize | std.number.Integer,
                Endpoint | String,
                Name | String,
                Timeout | definitions.contract.Duration,
              },
          Key = { Name | String, Secret | String, },
          KeyToPath = {
                Key | String,
                Mode | std.number.Integer,
                Path | String,
              },
          KubeAPIService = {
                admission_configuration
                  | definitions.contract.AdmissionConfiguration
                  | doc m%"
                  AdmissionConfiguration
                  "%
                  | optional,
                always_pull_images
                  | Bool
                  | doc m%"
                  Enable/Disable AlwaysPullImages admissions plugin
                  "%
                  | optional,
                audit_log
                  | definitions.contract.AuditLog
                  | doc m%"
                  Audit Log Configuration
                  "%
                  | optional,
                event_rate_limit
                  | definitions.contract.EventRateLimit
                  | doc m%"
                  Event Rate Limit configuration
                  "%
                  | optional,
                extra_args
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
                extra_binds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extra_env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                image | String | optional,
                pod_security_policy
                  | Bool
                  | doc m%"
                  Enabled/Disable PodSecurityPolicy
                  "%
                  | optional,
                secrets_encryption_config
                  | definitions.contract.SecretsEncryptionConfig
                  | doc m%"
                  Secrets encryption provider config
                  "%
                  | optional,
                service_cluster_ip_range
                  | String
                  | doc m%"
                  Virtual IP range that will be used by Kubernetes services
                  "%
                  | optional,
                service_node_port_range
                  | String
                  | doc m%"
                  Port range for services defined with NodePort type
                  "%
                  | optional,
                win_extra_args
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
                win_extra_binds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                win_extra_env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          KubeControllerService = {
                cluster_cidr
                  | String
                  | doc m%"
                  CIDR Range for Pods in cluster
                  "%
                  | optional,
                extra_args
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
                extra_binds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extra_env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                image | String | optional,
                service_cluster_ip_range
                  | String
                  | doc m%"
                  Virtual IP range that will be used by Kubernetes services
                  "%
                  | optional,
                win_extra_args
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
                win_extra_binds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                win_extra_env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          KubeletService = {
                cluster_dns_server
                  | String
                  | doc m%"
                  Cluster DNS service ip
                  "%
                  | optional,
                cluster_domain
                  | String
                  | doc m%"
                  Domain of the cluster (default: "cluster.local")
                  "%
                  | optional,
                extra_args
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
                extra_binds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extra_env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                fail_swap_on
                  | Bool
                  | doc m%"
                  Fail if swap is enabled
                  "%
                  | optional,
                generate_serving_certificate
                  | Bool
                  | doc m%"
                  Generate per node kubelet serving certificates created using kube-ca
                  "%
                  | optional,
                image | String | optional,
                infra_container_image
                  | String
                  | doc m%"
                  The image whose network/ipc namespaces containers in each pod will use
                  "%
                  | optional,
                win_extra_args
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
                win_extra_binds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                win_extra_env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          KubeproxyService = {
                extra_args
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
                extra_binds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extra_env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                image | String | optional,
                win_extra_args
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
                win_extra_binds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                win_extra_env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          LabelSelector = {
                MatchExpressions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.LabelSelectorRequirement
                  ]),
                MatchLabels
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
                  ]),
              },
          LabelSelectorRequirement = {
                Key | String,
                Operator | String,
                Values
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
              },
          Limit = {
                Burst | std.number.Integer,
                CacheSize | std.number.Integer,
                QPS | std.number.Integer,
                Type | String,
              },
          LinearAutoscalerParams = {
                cores_per_replica | Number | optional,
                max | std.number.Integer,
                min | std.number.Integer,
                nodes_per_replica | Number | optional,
                prevent_single_point_failure | Bool | optional,
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
          LocalObjectReference = { Name | String, },
          ManagedFieldsEntry = {
                APIVersion | String,
                FieldsType | String,
                FieldsV1 | definitions.contract.FieldsV1,
                Manager | String,
                Operation | String,
                Time | String,
              },
          MetadataOpenstackOpts = {
                request-timeout | std.number.Integer,
                search-order | String,
              },
          MonitoringConfig = {
                metrics_server_priority_class_name
                  | String
                  | doc m%"
                  Priority class name for Metrics-Server's "metrics-server" deployment
                  "%
                  | optional,
                node_selector
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
                  "%,
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
                update_strategy
                  | definitions.contract.DeploymentStrategy
                  | doc m%"
                  Update strategy
                  "%
                  | optional,
              },
          NFSVolumeSource = {
                Path | String,
                ReadOnly | Bool,
                Server | String,
              },
          NetworkConfig = {
                aci_network_provider
                  | definitions.contract.AciNetworkProvider
                  | doc m%"
                  AciNetworkProvider
                  "%
                  | optional,
                calico_network_provider
                  | definitions.contract.CalicoNetworkProvider
                  | doc m%"
                  CalicoNetworkProvider
                  "%
                  | optional,
                canal_network_provider
                  | definitions.contract.CanalNetworkProvider
                  | doc m%"
                  CanalNetworkProvider
                  "%
                  | optional,
                flannel_network_provider
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
                node_selector
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
                update_strategy
                  | definitions.contract.DaemonSetUpdateStrategy
                  | doc m%"
                  Network plugin daemonset upgrade strategy
                  "%
                  | optional,
                weave_network_provider
                  | definitions.contract.WeaveNetworkProvider
                  | doc m%"
                  WeaveNetworkProvider
                  "%
                  | optional,
              },
          NetworkVshpereOpts = { public-network | String | optional, },
          NodeDrainInput = {
                delete_local_data
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
                grace_period
                  | std.number.Integer
                  | doc m%"
                  Period of time in seconds given to each pod to terminate gracefully.
                  If negative, the default value specified in the pod will be used
                  "%
                  | optional,
                ignore_daemonsets
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
                max_unavailable_controlplane
                  | String
                  | doc m%"
                  MaxUnavailableControlplane input can be a number of nodes or a percentage of nodes
                  "%
                  | optional,
                max_unavailable_worker
                  | String
                  | doc m%"
                  MaxUnavailableWorker input can be a number of nodes or a percentage of nodes (example, max_unavailable_worker: 2 OR max_unavailable_worker: 20%)
                  "%
                  | optional,
                node_drain_input
                  | definitions.contract.NodeDrainInput
                  | optional,
              },
          Nodelocal = {
                ip_address
                  | String
                  | doc m%"
                  link-local IP for nodelocal DNS
                  "%
                  | optional,
                node_local_dns_priority_class_name
                  | String
                  | doc m%"
                  Priority class name for NodeLocal's "node-local-dns" daemonset
                  "%
                  | optional,
                node_selector
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
                update_strategy
                  | definitions.contract.DaemonSetUpdateStrategy
                  | doc m%"
                  Nodelocal DNS daemonset upgrade strategy
                  "%
                  | optional,
              },
          ObjectFieldSelector = { APIVersion | String, FieldPath | String, },
          OpenstackCloudProvider = {
                block_storage | definitions.contract.BlockStorageOpenstackOpts,
                global | definitions.contract.GlobalOpenstackOpts,
                load_balancer | definitions.contract.LoadBalancerOpenstackOpts,
                metadata | definitions.contract.MetadataOpenstackOpts,
                route | definitions.contract.RouteOpenstackOpts,
              },
          OwnerReference = {
                APIVersion | String,
                BlockOwnerDeletion | Bool,
                Controller | Bool,
                Kind | String,
                Name | String,
                UID | String,
              },
          PersistentVolumeClaimSpec = {
                AccessModes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                DataSource | definitions.contract.TypedLocalObjectReference,
                Resources | definitions.contract.ResourceRequirements,
                Selector | definitions.contract.LabelSelector,
                StorageClassName | String,
                VolumeMode | String,
                VolumeName | String,
              },
          PersistentVolumeClaimTemplate = {
                Annotations
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
                  ]),
                ClusterName | String,
                CreationTimestamp | definitions.contract.Time,
                DeletionGracePeriodSeconds | std.number.Integer,
                DeletionTimestamp | String,
                Finalizers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                GenerateName | String,
                Generation | std.number.Integer,
                Labels
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
                  ]),
                ManagedFields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ManagedFieldsEntry
                  ]),
                Name | String,
                Namespace | String,
                OwnerReferences
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.OwnerReference
                  ]),
                ResourceVersion | String,
                SelfLink | String,
                Spec | definitions.contract.PersistentVolumeClaimSpec,
                UID | String,
              },
          PersistentVolumeClaimVolumeSource = {
                ClaimName | String,
                ReadOnly | Bool,
              },
          PhotonPersistentDiskVolumeSource = {
                FSType | String,
                PdID | String,
              },
          Policy = {
                APIVersion | String,
                Annotations
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
                  ]),
                ClusterName | String,
                CreationTimestamp | definitions.contract.Time,
                DeletionGracePeriodSeconds | std.number.Integer,
                DeletionTimestamp | String,
                Finalizers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                GenerateName | String,
                Generation | std.number.Integer,
                Kind | String,
                Labels
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
                  ]),
                ManagedFields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ManagedFieldsEntry
                  ]),
                Name | String,
                Namespace | String,
                OmitStages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                OwnerReferences
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.OwnerReference
                  ]),
                ResourceVersion | String,
                Rules
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.PolicyRule
                  ]),
                SelfLink | String,
                UID | String,
              },
          PolicyRule = {
                Level | String,
                Namespaces
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                NonResourceURLs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                OmitStages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                Resources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.GroupResources
                  ]),
                UserGroups
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                Users
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                Verbs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
              },
          PortworxVolumeSource = {
                FSType | String,
                ReadOnly | Bool,
                VolumeID | String,
              },
          PrivateRegistry = {
                ecr_credential_plugin
                  | definitions.contract.ECRCredentialPlugin
                  | doc m%"
                  ECRCredentialPlugin
                  "%
                  | optional,
                is_default
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
                DefaultMode | std.number.Integer,
                Sources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.VolumeProjection
                  ]),
              },
          ProviderConfiguration = {
                AESCBC | definitions.contract.AESConfiguration,
                AESGCM | definitions.contract.AESConfiguration,
                Identity | definitions.contract.IdentityConfiguration,
                KMS | definitions.contract.KMSConfiguration,
                Secretbox | definitions.contract.SecretboxConfiguration,
              },
          Quantity = {  },
          QuobyteVolumeSource = {
                Group | String,
                ReadOnly | Bool,
                Registry | String,
                Tenant | String,
                User | String,
                Volume | String,
              },
          RBDVolumeSource = {
                CephMonitors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                FSType | String,
                Keyring | String,
                RBDImage | String,
                RBDPool | String,
                RadosUser | String,
                ReadOnly | Bool,
                SecretRef | definitions.contract.LocalObjectReference,
              },
          RKEConfigNode = {
                address
                  | String
                  | doc m%"
                  IP or FQDN that is fully resolvable and used for SSH communication
                  "%
                  | optional,
                docker_socket
                  | String
                  | doc m%"
                  Optional - Docker socket on the node that will be used in tunneling
                  "%
                  | optional,
                hostname_override
                  | String
                  | doc m%"
                  Optional - Hostname of the node
                  "%
                  | optional,
                internal_address
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
                ssh_agent_auth
                  | Bool
                  | doc m%"
                  SSH Agent Auth enable
                  "%
                  | optional,
                ssh_cert
                  | String
                  | doc m%"
                  SSH Certificate
                  "%
                  | optional,
                ssh_cert_path
                  | String
                  | doc m%"
                  SSH Certificate Path
                  "%
                  | optional,
                ssh_key
                  | String
                  | doc m%"
                  SSH Private Key
                  "%
                  | optional,
                ssh_key_path
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
                kube-api
                  | definitions.contract.KubeAPIService
                  | doc m%"
                  KubeAPI Service
                  "%
                  | optional,
                kube-controller
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
                aci_cni_deploy_container
                  | String
                  | doc m%"
                  Cni deployer container image for Cisco ACI
                  "%
                  | optional,
                aci_controller_container
                  | String
                  | doc m%"
                  Controller container image for Cisco ACI
                  "%
                  | optional,
                aci_gbp_server_container
                  | String
                  | doc m%"
                  GBP Server container image for Cisco ACI
                  "%
                  | optional,
                aci_host_container
                  | String
                  | doc m%"
                  host container image for Cisco ACI
                  "%
                  | optional,
                aci_mcast_container
                  | String
                  | doc m%"
                  mcast daemon container image for Cisco ACI
                  "%
                  | optional,
                aci_opflex_container
                  | String
                  | doc m%"
                  opflex agent container image for Cisco ACI
                  "%
                  | optional,
                aci_opflex_server_container
                  | String
                  | doc m%"
                  Opflex Server container image for Cisco ACI
                  "%
                  | optional,
                aci_ovs_container
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
                calico_cni
                  | String
                  | doc m%"
                  Calico CNI image
                  "%
                  | optional,
                calico_controllers
                  | String
                  | doc m%"
                  Calico Controllers image
                  "%
                  | optional,
                calico_ctl
                  | String
                  | doc m%"
                  Calicoctl image
                  "%
                  | optional,
                calico_flexvol
                  | String
                  | doc m%"
                  CalicoFlexVol image
                  "%
                  | optional,
                calico_node
                  | String
                  | doc m%"
                  Calico Node image
                  "%
                  | optional,
                canal_cni
                  | String
                  | doc m%"
                  Canal CNI image
                  "%
                  | optional,
                canal_controllers
                  | String
                  | doc m%"
                  Canal Controllers Image needed for Calico/Canal v3.14.0+
                  "%
                  | optional,
                canal_flannel
                  | String
                  | doc m%"
                  CanalFlannel image
                  "%
                  | optional,
                canal_flexvol
                  | String
                  | doc m%"
                  CanalFlexVol image
                  "%
                  | optional,
                canal_node
                  | String
                  | doc m%"
                  Canal Node Image
                  "%
                  | optional,
                cert_downloader
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
                coredns_autoscaler
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
                flannel_cni
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
                ingress_backend
                  | String
                  | doc m%"
                  Ingress Controller Backend image
                  "%
                  | optional,
                ingress_webhook
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
                kubedns_autoscaler
                  | String
                  | doc m%"
                  KubeDNS autoscaler image
                  "%
                  | optional,
                kubedns_sidecar
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
                kubernetes_services_sidecar
                  | String
                  | doc m%"
                  rke-service-sidekick image
                  "%
                  | optional,
                metrics_server
                  | String
                  | doc m%"
                  Metrics Server image
                  "%
                  | optional,
                nginx_proxy
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
                pod_infra_container
                  | String
                  | doc m%"
                  Pod infra container image
                  "%
                  | optional,
                weave_cni
                  | String
                  | doc m%"
                  Weave CNI image
                  "%
                  | optional,
                weave_node
                  | String
                  | doc m%"
                  Weave Node image
                  "%
                  | optional,
                windows_pod_infra_container
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
                addon_job_timeout
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
                addons_include
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
                bastion_host
                  | definitions.contract.BastionHost
                  | doc m%"
                  Bastion/Jump Host configuration
                  "%
                  | optional,
                cloud_provider
                  | definitions.contract.CloudProvider
                  | doc m%"
                  Cloud Provider options
                  "%
                  | optional,
                cluster_name
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
                enable_cri_dockerd
                  | Bool
                  | doc m%"
                  Enable/disable using cri-dockerd
                  "%
                  | optional,
                ignore_docker_version
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
                kubernetes_version
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
                prefix_path
                  | String
                  | doc m%"
                  kubernetes directory path
                  "%
                  | optional,
                private_registries
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
                rotate_certificates
                  | definitions.contract.RotateCertificates
                  | doc m%"
                  Rotating Certificates Option
                  "%
                  | optional,
                rotate_encryption_key
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
                ssh_agent_auth
                  | Bool
                  | doc m%"
                  SSH Agent Auth enable
                  "%
                  | optional,
                ssh_cert_path
                  | String
                  | doc m%"
                  SSH Certificate Path
                  "%
                  | optional,
                ssh_key_path
                  | String
                  | doc m%"
                  SSH Private Key Path
                  "%
                  | optional,
                system_images
                  | definitions.contract.RKESystemImages
                  | doc m%"
                  List of images used internally for proxy, cert download and kubedns
                  "%
                  | optional,
                upgrade_strategy
                  | definitions.contract.NodeUpgradeStrategy
                  | doc m%"
                  Upgrade Strategy for the cluster
                  "%
                  | optional,
                win_prefix_path
                  | String
                  | doc m%"
                  kubernetes directory path for windows
                  "%
                  | optional,
              },
          ResourceConfiguration = {
                Providers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ProviderConfiguration
                  ]),
                Resources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
              },
          ResourceFieldSelector = {
                ContainerName | String,
                Divisor | definitions.contract.Quantity,
                Resource | String,
              },
          ResourceRequirements = {
                Limits
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = definitions.predicate.Quantity, }
                    true
                    predicates.always
                  ]),
                Requests
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = definitions.predicate.Quantity, }
                    true
                    predicates.always
                  ]),
              },
          RestoreConfig = {
                restore | Bool | optional,
                snapshot_name | String | optional,
              },
          RollingUpdateDaemonSet = {
                MaxSurge | definitions.contract.IntOrString,
                MaxUnavailable | definitions.contract.IntOrString,
              },
          RollingUpdateDeployment = {
                MaxSurge | definitions.contract.IntOrString,
                MaxUnavailable | definitions.contract.IntOrString,
              },
          RotateCertificates = {
                CACertificates
                  | Bool
                  | doc m%"
                  Rotate CA Certificates
                  "%,
                Services
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Services to rotate their certs
                  "%,
              },
          RouteOpenstackOpts = {
                router-id
                  | String
                  | doc m%"
                  required
                  "%,
              },
          S3BackupConfig = {
                access_key | String,
                bucket_name | String,
                custom_ca | String,
                endpoint | String,
                folder | String,
                region | String,
                secret_key | String,
              },
          ScaleIOVolumeSource = {
                FSType | String,
                Gateway | String,
                ProtectionDomain | String,
                ReadOnly | Bool,
                SSLEnabled | Bool,
                SecretRef | definitions.contract.LocalObjectReference,
                StorageMode | String,
                StoragePool | String,
                System | String,
                VolumeName | String,
              },
          SchedulerService = {
                extra_args
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
                extra_binds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extra_env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                image | String | optional,
                win_extra_args
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
                win_extra_binds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                win_extra_env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          SecretKeySelector = { Key | String, Name | String, Optional | Bool, },
          SecretProjection = {
                Items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.KeyToPath
                  ]),
                Name | String,
                Optional | Bool,
              },
          SecretVolumeSource = {
                DefaultMode | std.number.Integer,
                Items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.KeyToPath
                  ]),
                Optional | Bool,
                SecretName | String,
              },
          SecretboxConfiguration = {
                Keys
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Key
                  ]),
              },
          SecretsEncryptionConfig = {
                custom_config
                  | definitions.contract.EncryptionConfiguration
                  | doc m%"
                  Custom Encryption Provider configuration object
                  "%,
                enabled
                  | Bool
                  | doc m%"
                  Enable/disable secrets encryption provider config
                  "%
                  | optional,
              },
          ServiceAccountTokenProjection = {
                Audience | String,
                ExpirationSeconds | std.number.Integer,
                Path | String,
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
                FSType | String,
                ReadOnly | Bool,
                SecretRef | definitions.contract.LocalObjectReference,
                VolumeName | String,
                VolumeNamespace | String,
              },
          Time = {  },
          Toleration = {
                Effect | String,
                Key | String,
                Operator | String,
                TolerationSeconds | std.number.Integer,
                Value | String,
              },
          TypedLocalObjectReference = {
                APIGroup | String,
                Kind | String,
                Name | String,
              },
          Unknown = {
                ContentEncoding | String,
                ContentType | String,
                Raw | String,
                apiVersion | String | optional,
                kind | String | optional,
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
                ConfigMap | definitions.contract.ConfigMapProjection,
                DownwardAPI | definitions.contract.DownwardAPIProjection,
                Secret | definitions.contract.SecretProjection,
                ServiceAccountToken
                  | definitions.contract.ServiceAccountTokenProjection,
              },
          VsphereCloudProvider = {
                disk | definitions.contract.DiskVsphereOpts | optional,
                global | definitions.contract.GlobalVsphereOpts | optional,
                network | definitions.contract.NetworkVshpereOpts | optional,
                virtual_center
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
                FSType | String,
                StoragePolicyID | String,
                StoragePolicyName | String,
                VolumePath | String,
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
                predicates.records.required [ "Keys" ],
                predicates.records.record
                {
                  Keys = predicates.allOf
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
                  service_override = predicates.allOf
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
                predicates.records.required
                [ "FSType", "Partition", "ReadOnly", "VolumeID" ],
                predicates.records.record
                {
                  FSType = predicates.isType '"String",
                  Partition = predicates.isType 'Integer,
                  ReadOnly = predicates.isType '"Bool",
                  VolumeID = predicates.isType '"String",
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
                  apic_hosts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  apic_refresh_time = predicates.isType '"String",
                  apic_user_crt = predicates.isType '"String",
                  apic_user_key = predicates.isType '"String",
                  apic_user_name = predicates.isType '"String",
                  capic = predicates.isType '"String",
                  controller_log_level = predicates.isType '"String",
                  drop_log_enable = predicates.isType '"String",
                  enable_endpoint_slice = predicates.isType '"String",
                  encap_type = predicates.isType '"String",
                  ep_registry = predicates.isType '"String",
                  extern_dynamic = predicates.isType '"String",
                  extern_static = predicates.isType '"String",
                  gbp_pod_subnet = predicates.isType '"String",
                  host_agent_log_level = predicates.isType '"String",
                  image_pull_policy = predicates.isType '"String",
                  image_pull_secret = predicates.isType '"String",
                  infra_vlan = predicates.isType '"String",
                  install_istio = predicates.isType '"String",
                  istio_profile = predicates.isType '"String",
                  kafka_brokers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  kafka_client_crt = predicates.isType '"String",
                  kafka_client_key = predicates.isType '"String",
                  kube_api_vlan = predicates.isType '"String",
                  l3out = predicates.isType '"String",
                  l3out_external_networks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  max_nodes_svc_graph = predicates.isType '"String",
                  mcast_range_end = predicates.isType '"String",
                  mcast_range_start = predicates.isType '"String",
                  no_priority_class = predicates.isType '"String",
                  node_subnet = predicates.isType '"String",
                  node_svc_subnet = predicates.isType '"String",
                  opflex_client_ssl = predicates.isType '"String",
                  opflex_log_level = predicates.isType '"String",
                  opflex_mode = predicates.isType '"String",
                  opflex_server_port = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  overlay_vrf_name = predicates.isType '"String",
                  ovs_memory_limit = predicates.isType '"String",
                  pbr_tracking_non_snat = predicates.isType '"String",
                  pod_subnet_chunk_size = predicates.isType '"String",
                  run_gbp_container = predicates.isType '"String",
                  run_opflex_server_container = predicates.isType '"String",
                  service_monitor_interval = predicates.isType '"String",
                  service_vlan = predicates.isType '"String",
                  snat_contract_scope = predicates.isType '"String",
                  snat_namespace = predicates.isType '"String",
                  snat_port_range_end = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  snat_port_range_start = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  snat_ports_per_node = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  subnet_domain_name = predicates.isType '"String",
                  system_id = predicates.isType '"String",
                  tenant = predicates.isType '"String",
                  token = predicates.isType '"String",
                  use_aci_anywhere_crd = predicates.isType '"String",
                  use_aci_cni_priority_class = predicates.isType '"String",
                  use_host_netns_volume = predicates.isType '"String",
                  use_opflex_server_volume = predicates.isType '"String",
                  use_privileged_container = predicates.isType '"String",
                  vmm_controller = predicates.isType '"String",
                  vmm_domain = predicates.isType '"String",
                  vrf_name = predicates.isType '"String",
                  vrf_tenant = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          AdmissionConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "APIVersion", "Kind", "Plugins" ],
                predicates.records.record
                {
                  APIVersion = predicates.isType '"String",
                  Kind = predicates.isType '"String",
                  Plugins = predicates.allOf
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
                predicates.records.required [ "Configuration", "Name", "Path" ],
                predicates.records.record
                {
                  Configuration = definitions.predicate.Unknown,
                  Name = predicates.isType '"String",
                  Path = predicates.isType '"String",
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
                  max_age = predicates.isType 'Integer,
                  max_backup = predicates.isType 'Integer,
                  max_size = predicates.isType 'Integer,
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
                  cache_timeout = predicates.isType '"String",
                  config_file = predicates.isType '"String",
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
                predicates.records.required
                [
                  "CachingMode",
                  "DataDiskURI",
                  "DiskName",
                  "FSType",
                  "Kind",
                  "ReadOnly"
                ],
                predicates.records.record
                {
                  CachingMode = predicates.isType '"String",
                  DataDiskURI = predicates.isType '"String",
                  DiskName = predicates.isType '"String",
                  FSType = predicates.isType '"String",
                  Kind = predicates.isType '"String",
                  ReadOnly = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          AzureFileVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "ReadOnly", "SecretName", "ShareName" ],
                predicates.records.record
                {
                  ReadOnly = predicates.isType '"Bool",
                  SecretName = predicates.isType '"String",
                  ShareName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          BackupConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "enabled",
                  "interval_hours",
                  "retention",
                  "safe_timestamp",
                  "timeout"
                ],
                predicates.records.record
                {
                  S3BackupConfig = definitions.predicate.S3BackupConfig,
                  enabled = predicates.isType '"Bool",
                  interval_hours = predicates.isType 'Integer,
                  retention = predicates.isType 'Integer,
                  safe_timestamp = predicates.isType '"Bool",
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
                  ignore_proxy_env_vars = predicates.isType '"Bool",
                  port = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  ssh_agent_auth = predicates.isType '"Bool",
                  ssh_cert = predicates.isType '"String",
                  ssh_cert_path = predicates.isType '"String",
                  ssh_key = predicates.isType '"String",
                  ssh_key_path = predicates.isType '"String",
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
                predicates.records.required
                [
                  "Driver",
                  "FSType",
                  "NodePublishSecretRef",
                  "ReadOnly",
                  "VolumeAttributes"
                ],
                predicates.records.record
                {
                  Driver = predicates.isType '"String",
                  FSType = predicates.isType '"String",
                  NodePublishSecretRef =
                    definitions.predicate.LocalObjectReference,
                  ReadOnly = predicates.isType '"Bool",
                  VolumeAttributes = predicates.allOf
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
                predicates.records.required [ "CloudProvider" ],
                predicates.records.record
                { CloudProvider = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          CanalNetworkProvider = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "Iface" ],
                predicates.records.record
                { Iface = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          CephFSVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "Monitors",
                  "Path",
                  "ReadOnly",
                  "SecretFile",
                  "SecretRef",
                  "User"
                ],
                predicates.records.record
                {
                  Monitors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  Path = predicates.isType '"String",
                  ReadOnly = predicates.isType '"Bool",
                  SecretFile = predicates.isType '"String",
                  SecretRef = definitions.predicate.LocalObjectReference,
                  User = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CinderVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "FSType", "ReadOnly", "SecretRef", "VolumeID" ],
                predicates.records.record
                {
                  FSType = predicates.isType '"String",
                  ReadOnly = predicates.isType '"Bool",
                  SecretRef = definitions.predicate.LocalObjectReference,
                  VolumeID = predicates.isType '"String",
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
                predicates.records.required [ "Key", "Name", "Optional" ],
                predicates.records.record
                {
                  Key = predicates.isType '"String",
                  Name = predicates.isType '"String",
                  Optional = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ConfigMapProjection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "Items", "Name", "Optional" ],
                predicates.records.record
                {
                  Items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.KeyToPath
                      ],
                  Name = predicates.isType '"String",
                  Optional = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ConfigMapVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "DefaultMode", "Items", "Name", "Optional" ],
                predicates.records.record
                {
                  DefaultMode = predicates.isType 'Integer,
                  Items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.KeyToPath
                      ],
                  Name = predicates.isType '"String",
                  Optional = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          Configuration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "APIVersion", "Kind", "Limits" ],
                predicates.records.record
                {
                  APIVersion = predicates.isType '"String",
                  Kind = predicates.isType '"String",
                  Limits = predicates.allOf
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
                  linear_autoscaler_params =
                    definitions.predicate.LinearAutoscalerParams,
                  node_selector = predicates.allOf
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
                  update_strategy = definitions.predicate.DeploymentStrategy,
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
                predicates.records.required [ "RollingUpdate", "Strategy" ],
                predicates.records.record
                {
                  RollingUpdate = definitions.predicate.RollingUpdateDaemonSet,
                  Strategy = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          DeploymentStrategy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "RollingUpdate", "Strategy" ],
                predicates.records.record
                {
                  RollingUpdate = definitions.predicate.RollingUpdateDeployment,
                  Strategy = predicates.isType '"String",
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
                predicates.records.required [ "Items" ],
                predicates.records.record
                {
                  Items = predicates.allOf
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
                predicates.records.required
                [ "FieldRef", "Mode", "Path", "ResourceFieldRef" ],
                predicates.records.record
                {
                  FieldRef = definitions.predicate.ObjectFieldSelector,
                  Mode = predicates.isType 'Integer,
                  Path = predicates.isType '"String",
                  ResourceFieldRef =
                    definitions.predicate.ResourceFieldSelector,
                }
                {  }
                false
                predicates.never
              ],
          DownwardAPIVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "DefaultMode", "Items" ],
                predicates.records.record
                {
                  DefaultMode = predicates.isType 'Integer,
                  Items = predicates.allOf
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
                predicates.records.required
                [
                  "aws_access_key_id",
                  "aws_secret_access_key",
                  "aws_session_token"
                ],
                predicates.records.record
                {
                  aws_access_key_id = predicates.isType '"String",
                  aws_secret_access_key = predicates.isType '"String",
                  aws_session_token = predicates.isType '"String",
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
                  backup_config = definitions.predicate.BackupConfig,
                  ca_cert = predicates.isType '"String",
                  cert = predicates.isType '"String",
                  creation = predicates.isType '"String",
                  external_urls = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extra_args = predicates.allOf
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
                  extra_binds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extra_env = predicates.allOf
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
                  win_extra_args = predicates.allOf
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
                  win_extra_binds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  win_extra_env = predicates.allOf
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
                predicates.records.required [ "Medium", "SizeLimit" ],
                predicates.records.record
                {
                  Medium = predicates.isType '"String",
                  SizeLimit = definitions.predicate.Quantity,
                }
                {  }
                false
                predicates.never
              ],
          EncryptionConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "APIVersion", "Kind", "Resources" ],
                predicates.records.record
                {
                  APIVersion = predicates.isType '"String",
                  Kind = predicates.isType '"String",
                  Resources = predicates.allOf
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
                predicates.records.required
                [
                  "ConfigMapKeyRef",
                  "FieldRef",
                  "ResourceFieldRef",
                  "SecretKeyRef"
                ],
                predicates.records.record
                {
                  ConfigMapKeyRef = definitions.predicate.ConfigMapKeySelector,
                  FieldRef = definitions.predicate.ObjectFieldSelector,
                  ResourceFieldRef =
                    definitions.predicate.ResourceFieldSelector,
                  SecretKeyRef = definitions.predicate.SecretKeySelector,
                }
                {  }
                false
                predicates.never
              ],
          EphemeralVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "VolumeClaimTemplate" ],
                predicates.records.record
                {
                  VolumeClaimTemplate =
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
                predicates.records.required [ "Name", "Value", "ValueFrom" ],
                predicates.records.record
                {
                  Name = predicates.isType '"String",
                  Value = predicates.isType '"String",
                  ValueFrom = definitions.predicate.EnvVarSource,
                }
                {  }
                false
                predicates.never
              ],
          ExtraVolume = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "AWSElasticBlockStore",
                  "AzureDisk",
                  "AzureFile",
                  "CSI",
                  "CephFS",
                  "Cinder",
                  "ConfigMap",
                  "DownwardAPI",
                  "EmptyDir",
                  "Ephemeral",
                  "FC",
                  "FlexVolume",
                  "Flocker",
                  "GCEPersistentDisk",
                  "GitRepo",
                  "Glusterfs",
                  "HostPath",
                  "ISCSI",
                  "NFS",
                  "Name",
                  "PersistentVolumeClaim",
                  "PhotonPersistentDisk",
                  "PortworxVolume",
                  "Projected",
                  "Quobyte",
                  "RBD",
                  "ScaleIO",
                  "Secret",
                  "StorageOS",
                  "VsphereVolume"
                ],
                predicates.records.record
                {
                  AWSElasticBlockStore =
                    definitions.predicate.AWSElasticBlockStoreVolumeSource,
                  AzureDisk = definitions.predicate.AzureDiskVolumeSource,
                  AzureFile = definitions.predicate.AzureFileVolumeSource,
                  CSI = definitions.predicate.CSIVolumeSource,
                  CephFS = definitions.predicate.CephFSVolumeSource,
                  Cinder = definitions.predicate.CinderVolumeSource,
                  ConfigMap = definitions.predicate.ConfigMapVolumeSource,
                  DownwardAPI = definitions.predicate.DownwardAPIVolumeSource,
                  EmptyDir = definitions.predicate.EmptyDirVolumeSource,
                  Ephemeral = definitions.predicate.EphemeralVolumeSource,
                  FC = definitions.predicate.FCVolumeSource,
                  FlexVolume = definitions.predicate.FlexVolumeSource,
                  Flocker = definitions.predicate.FlockerVolumeSource,
                  GCEPersistentDisk =
                    definitions.predicate.GCEPersistentDiskVolumeSource,
                  GitRepo = definitions.predicate.GitRepoVolumeSource,
                  Glusterfs = definitions.predicate.GlusterfsVolumeSource,
                  HostPath = definitions.predicate.HostPathVolumeSource,
                  ISCSI = definitions.predicate.ISCSIVolumeSource,
                  NFS = definitions.predicate.NFSVolumeSource,
                  Name = predicates.isType '"String",
                  PersistentVolumeClaim =
                    definitions.predicate.PersistentVolumeClaimVolumeSource,
                  PhotonPersistentDisk =
                    definitions.predicate.PhotonPersistentDiskVolumeSource,
                  PortworxVolume = definitions.predicate.PortworxVolumeSource,
                  Projected = definitions.predicate.ProjectedVolumeSource,
                  Quobyte = definitions.predicate.QuobyteVolumeSource,
                  RBD = definitions.predicate.RBDVolumeSource,
                  ScaleIO = definitions.predicate.ScaleIOVolumeSource,
                  Secret = definitions.predicate.SecretVolumeSource,
                  StorageOS = definitions.predicate.StorageOSVolumeSource,
                  VsphereVolume =
                    definitions.predicate.VsphereVirtualDiskVolumeSource,
                }
                {  }
                false
                predicates.never
              ],
          ExtraVolumeMount = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "MountPath",
                  "MountPropagation",
                  "Name",
                  "ReadOnly",
                  "SubPath",
                  "SubPathExpr"
                ],
                predicates.records.record
                {
                  MountPath = predicates.isType '"String",
                  MountPropagation = predicates.isType '"String",
                  Name = predicates.isType '"String",
                  ReadOnly = predicates.isType '"Bool",
                  SubPath = predicates.isType '"String",
                  SubPathExpr = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FCVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "FSType", "Lun", "ReadOnly", "TargetWWNs", "WWIDs" ],
                predicates.records.record
                {
                  FSType = predicates.isType '"String",
                  Lun = predicates.isType 'Integer,
                  ReadOnly = predicates.isType '"Bool",
                  TargetWWNs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  WWIDs = predicates.allOf
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
                predicates.records.required [ "Raw" ],
                predicates.records.record { Raw = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          FlannelNetworkProvider = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "Iface" ],
                predicates.records.record
                { Iface = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          FlexVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "Driver", "FSType", "Options", "ReadOnly", "SecretRef" ],
                predicates.records.record
                {
                  Driver = predicates.isType '"String",
                  FSType = predicates.isType '"String",
                  Options = predicates.allOf
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
                  ReadOnly = predicates.isType '"Bool",
                  SecretRef = definitions.predicate.LocalObjectReference,
                }
                {  }
                false
                predicates.never
              ],
          FlockerVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "DatasetName", "DatasetUUID" ],
                predicates.records.record
                {
                  DatasetName = predicates.isType '"String",
                  DatasetUUID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GCEPersistentDiskVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "FSType", "PDName", "Partition", "ReadOnly" ],
                predicates.records.record
                {
                  FSType = predicates.isType '"String",
                  PDName = predicates.isType '"String",
                  Partition = predicates.isType 'Integer,
                  ReadOnly = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          GitRepoVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "Directory", "Repository", "Revision" ],
                predicates.records.record
                {
                  Directory = predicates.isType '"String",
                  Repository = predicates.isType '"String",
                  Revision = predicates.isType '"String",
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
                predicates.records.required
                [ "EndpointsName", "Path", "ReadOnly" ],
                predicates.records.record
                {
                  EndpointsName = predicates.isType '"String",
                  Path = predicates.isType '"String",
                  ReadOnly = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          GroupResources = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "Group", "ResourceNames", "Resources" ],
                predicates.records.record
                {
                  Group = predicates.isType '"String",
                  ResourceNames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  Resources = predicates.allOf
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
                predicates.records.required [ "Path", "Type" ],
                predicates.records.record
                {
                  Path = predicates.isType '"String",
                  Type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ISCSIVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "DiscoveryCHAPAuth",
                  "FSType",
                  "IQN",
                  "ISCSIInterface",
                  "InitiatorName",
                  "Lun",
                  "Portals",
                  "ReadOnly",
                  "SecretRef",
                  "SessionCHAPAuth",
                  "TargetPortal"
                ],
                predicates.records.record
                {
                  DiscoveryCHAPAuth = predicates.isType '"Bool",
                  FSType = predicates.isType '"String",
                  IQN = predicates.isType '"String",
                  ISCSIInterface = predicates.isType '"String",
                  InitiatorName = predicates.isType '"String",
                  Lun = predicates.isType 'Integer,
                  Portals = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  ReadOnly = predicates.isType '"Bool",
                  SecretRef = definitions.predicate.LocalObjectReference,
                  SessionCHAPAuth = predicates.isType '"Bool",
                  TargetPortal = predicates.isType '"String",
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
                  default_backend = predicates.isType '"Bool",
                  default_http_backend_priority_class_name = predicates.isType
                      '"String",
                  dns_policy = predicates.isType '"String",
                  extra_args = predicates.allOf
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
                  extra_envs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.ExtraEnv
                      ],
                  extra_volume_mounts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ExtraVolumeMount
                      ],
                  extra_volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ExtraVolume
                      ],
                  http_port = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  https_port = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  network_mode = predicates.isType '"String",
                  nginx_ingress_controller_priority_class_name =
                    predicates.isType '"String",
                  node_selector = predicates.allOf
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
                  update_strategy =
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
                predicates.records.required
                [ "CacheSize", "Endpoint", "Name", "Timeout" ],
                predicates.records.record
                {
                  CacheSize = predicates.isType 'Integer,
                  Endpoint = predicates.isType '"String",
                  Name = predicates.isType '"String",
                  Timeout = definitions.predicate.Duration,
                }
                {  }
                false
                predicates.never
              ],
          Key = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "Name", "Secret" ],
                predicates.records.record
                {
                  Name = predicates.isType '"String",
                  Secret = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          KeyToPath = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "Key", "Mode", "Path" ],
                predicates.records.record
                {
                  Key = predicates.isType '"String",
                  Mode = predicates.isType 'Integer,
                  Path = predicates.isType '"String",
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
                  admission_configuration =
                    definitions.predicate.AdmissionConfiguration,
                  always_pull_images = predicates.isType '"Bool",
                  audit_log = definitions.predicate.AuditLog,
                  event_rate_limit = definitions.predicate.EventRateLimit,
                  extra_args = predicates.allOf
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
                  extra_binds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extra_env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  image = predicates.isType '"String",
                  pod_security_policy = predicates.isType '"Bool",
                  secrets_encryption_config =
                    definitions.predicate.SecretsEncryptionConfig,
                  service_cluster_ip_range = predicates.isType '"String",
                  service_node_port_range = predicates.isType '"String",
                  win_extra_args = predicates.allOf
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
                  win_extra_binds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  win_extra_env = predicates.allOf
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
                  cluster_cidr = predicates.isType '"String",
                  extra_args = predicates.allOf
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
                  extra_binds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extra_env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  image = predicates.isType '"String",
                  service_cluster_ip_range = predicates.isType '"String",
                  win_extra_args = predicates.allOf
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
                  win_extra_binds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  win_extra_env = predicates.allOf
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
                  cluster_dns_server = predicates.isType '"String",
                  cluster_domain = predicates.isType '"String",
                  extra_args = predicates.allOf
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
                  extra_binds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extra_env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  fail_swap_on = predicates.isType '"Bool",
                  generate_serving_certificate = predicates.isType '"Bool",
                  image = predicates.isType '"String",
                  infra_container_image = predicates.isType '"String",
                  win_extra_args = predicates.allOf
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
                  win_extra_binds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  win_extra_env = predicates.allOf
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
                  extra_args = predicates.allOf
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
                  extra_binds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extra_env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  image = predicates.isType '"String",
                  win_extra_args = predicates.allOf
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
                  win_extra_binds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  win_extra_env = predicates.allOf
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
                predicates.records.required
                [ "MatchExpressions", "MatchLabels" ],
                predicates.records.record
                {
                  MatchExpressions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.LabelSelectorRequirement
                      ],
                  MatchLabels = predicates.allOf
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
                predicates.records.required [ "Key", "Operator", "Values" ],
                predicates.records.record
                {
                  Key = predicates.isType '"String",
                  Operator = predicates.isType '"String",
                  Values = predicates.allOf
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
                predicates.records.required
                [ "Burst", "CacheSize", "QPS", "Type" ],
                predicates.records.record
                {
                  Burst = predicates.isType 'Integer,
                  CacheSize = predicates.isType 'Integer,
                  QPS = predicates.isType 'Integer,
                  Type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          LinearAutoscalerParams = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "max", "min" ],
                predicates.records.record
                {
                  cores_per_replica = predicates.isType '"Number",
                  max = predicates.isType 'Integer,
                  min = predicates.isType 'Integer,
                  nodes_per_replica = predicates.isType '"Number",
                  prevent_single_point_failure = predicates.isType '"Bool",
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
                predicates.records.required [ "Name" ],
                predicates.records.record
                { Name = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          ManagedFieldsEntry = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "APIVersion",
                  "FieldsType",
                  "FieldsV1",
                  "Manager",
                  "Operation",
                  "Time"
                ],
                predicates.records.record
                {
                  APIVersion = predicates.isType '"String",
                  FieldsType = predicates.isType '"String",
                  FieldsV1 = definitions.predicate.FieldsV1,
                  Manager = predicates.isType '"String",
                  Operation = predicates.isType '"String",
                  Time = predicates.isType '"String",
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
                predicates.records.required [ "replicas" ],
                predicates.records.record
                {
                  metrics_server_priority_class_name = predicates.isType
                      '"String",
                  node_selector = predicates.allOf
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
                  update_strategy = definitions.predicate.DeploymentStrategy,
                }
                {  }
                false
                predicates.never
              ],
          NFSVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "Path", "ReadOnly", "Server" ],
                predicates.records.record
                {
                  Path = predicates.isType '"String",
                  ReadOnly = predicates.isType '"Bool",
                  Server = predicates.isType '"String",
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
                  aci_network_provider =
                    definitions.predicate.AciNetworkProvider,
                  calico_network_provider =
                    definitions.predicate.CalicoNetworkProvider,
                  canal_network_provider =
                    definitions.predicate.CanalNetworkProvider,
                  flannel_network_provider =
                    definitions.predicate.FlannelNetworkProvider,
                  mtu = predicates.isType 'Integer,
                  node_selector = predicates.allOf
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
                  update_strategy =
                    definitions.predicate.DaemonSetUpdateStrategy,
                  weave_network_provider =
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
                  delete_local_data = predicates.isType '"Bool",
                  "force" = predicates.isType '"Bool",
                  grace_period = predicates.isType 'Integer,
                  ignore_daemonsets = predicates.isType '"Bool",
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
                  max_unavailable_controlplane = predicates.isType '"String",
                  max_unavailable_worker = predicates.isType '"String",
                  node_drain_input = definitions.predicate.NodeDrainInput,
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
                  ip_address = predicates.isType '"String",
                  node_local_dns_priority_class_name = predicates.isType
                      '"String",
                  node_selector = predicates.allOf
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
                  update_strategy =
                    definitions.predicate.DaemonSetUpdateStrategy,
                }
                {  }
                false
                predicates.never
              ],
          ObjectFieldSelector = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "APIVersion", "FieldPath" ],
                predicates.records.record
                {
                  APIVersion = predicates.isType '"String",
                  FieldPath = predicates.isType '"String",
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
                  "block_storage",
                  "global",
                  "load_balancer",
                  "metadata",
                  "route"
                ],
                predicates.records.record
                {
                  block_storage =
                    definitions.predicate.BlockStorageOpenstackOpts,
                  global = definitions.predicate.GlobalOpenstackOpts,
                  load_balancer =
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
                [
                  "APIVersion",
                  "BlockOwnerDeletion",
                  "Controller",
                  "Kind",
                  "Name",
                  "UID"
                ],
                predicates.records.record
                {
                  APIVersion = predicates.isType '"String",
                  BlockOwnerDeletion = predicates.isType '"Bool",
                  Controller = predicates.isType '"Bool",
                  Kind = predicates.isType '"String",
                  Name = predicates.isType '"String",
                  UID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PersistentVolumeClaimSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "AccessModes",
                  "DataSource",
                  "Resources",
                  "Selector",
                  "StorageClassName",
                  "VolumeMode",
                  "VolumeName"
                ],
                predicates.records.record
                {
                  AccessModes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  DataSource = definitions.predicate.TypedLocalObjectReference,
                  Resources = definitions.predicate.ResourceRequirements,
                  Selector = definitions.predicate.LabelSelector,
                  StorageClassName = predicates.isType '"String",
                  VolumeMode = predicates.isType '"String",
                  VolumeName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PersistentVolumeClaimTemplate = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "Annotations",
                  "ClusterName",
                  "CreationTimestamp",
                  "DeletionGracePeriodSeconds",
                  "DeletionTimestamp",
                  "Finalizers",
                  "GenerateName",
                  "Generation",
                  "Labels",
                  "ManagedFields",
                  "Name",
                  "Namespace",
                  "OwnerReferences",
                  "ResourceVersion",
                  "SelfLink",
                  "Spec",
                  "UID"
                ],
                predicates.records.record
                {
                  Annotations = predicates.allOf
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
                  ClusterName = predicates.isType '"String",
                  CreationTimestamp = definitions.predicate.Time,
                  DeletionGracePeriodSeconds = predicates.isType 'Integer,
                  DeletionTimestamp = predicates.isType '"String",
                  Finalizers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  GenerateName = predicates.isType '"String",
                  Generation = predicates.isType 'Integer,
                  Labels = predicates.allOf
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
                  ManagedFields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ManagedFieldsEntry
                      ],
                  Name = predicates.isType '"String",
                  Namespace = predicates.isType '"String",
                  OwnerReferences = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.OwnerReference
                      ],
                  ResourceVersion = predicates.isType '"String",
                  SelfLink = predicates.isType '"String",
                  Spec = definitions.predicate.PersistentVolumeClaimSpec,
                  UID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PersistentVolumeClaimVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "ClaimName", "ReadOnly" ],
                predicates.records.record
                {
                  ClaimName = predicates.isType '"String",
                  ReadOnly = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          PhotonPersistentDiskVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "FSType", "PdID" ],
                predicates.records.record
                {
                  FSType = predicates.isType '"String",
                  PdID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Policy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "APIVersion",
                  "Annotations",
                  "ClusterName",
                  "CreationTimestamp",
                  "DeletionGracePeriodSeconds",
                  "DeletionTimestamp",
                  "Finalizers",
                  "GenerateName",
                  "Generation",
                  "Kind",
                  "Labels",
                  "ManagedFields",
                  "Name",
                  "Namespace",
                  "OmitStages",
                  "OwnerReferences",
                  "ResourceVersion",
                  "Rules",
                  "SelfLink",
                  "UID"
                ],
                predicates.records.record
                {
                  APIVersion = predicates.isType '"String",
                  Annotations = predicates.allOf
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
                  ClusterName = predicates.isType '"String",
                  CreationTimestamp = definitions.predicate.Time,
                  DeletionGracePeriodSeconds = predicates.isType 'Integer,
                  DeletionTimestamp = predicates.isType '"String",
                  Finalizers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  GenerateName = predicates.isType '"String",
                  Generation = predicates.isType 'Integer,
                  Kind = predicates.isType '"String",
                  Labels = predicates.allOf
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
                  ManagedFields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ManagedFieldsEntry
                      ],
                  Name = predicates.isType '"String",
                  Namespace = predicates.isType '"String",
                  OmitStages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  OwnerReferences = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.OwnerReference
                      ],
                  ResourceVersion = predicates.isType '"String",
                  Rules = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.PolicyRule
                      ],
                  SelfLink = predicates.isType '"String",
                  UID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PolicyRule = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "Level",
                  "Namespaces",
                  "NonResourceURLs",
                  "OmitStages",
                  "Resources",
                  "UserGroups",
                  "Users",
                  "Verbs"
                ],
                predicates.records.record
                {
                  Level = predicates.isType '"String",
                  Namespaces = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  NonResourceURLs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  OmitStages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  Resources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.GroupResources
                      ],
                  UserGroups = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  Users = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  Verbs = predicates.allOf
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
                predicates.records.required
                [ "FSType", "ReadOnly", "VolumeID" ],
                predicates.records.record
                {
                  FSType = predicates.isType '"String",
                  ReadOnly = predicates.isType '"Bool",
                  VolumeID = predicates.isType '"String",
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
                  ecr_credential_plugin =
                    definitions.predicate.ECRCredentialPlugin,
                  is_default = predicates.isType '"Bool",
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
                predicates.records.required [ "DefaultMode", "Sources" ],
                predicates.records.record
                {
                  DefaultMode = predicates.isType 'Integer,
                  Sources = predicates.allOf
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
                predicates.records.required
                [ "AESCBC", "AESGCM", "Identity", "KMS", "Secretbox" ],
                predicates.records.record
                {
                  AESCBC = definitions.predicate.AESConfiguration,
                  AESGCM = definitions.predicate.AESConfiguration,
                  Identity = definitions.predicate.IdentityConfiguration,
                  KMS = definitions.predicate.KMSConfiguration,
                  Secretbox = definitions.predicate.SecretboxConfiguration,
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
                predicates.records.required
                [ "Group", "ReadOnly", "Registry", "Tenant", "User", "Volume" ],
                predicates.records.record
                {
                  Group = predicates.isType '"String",
                  ReadOnly = predicates.isType '"Bool",
                  Registry = predicates.isType '"String",
                  Tenant = predicates.isType '"String",
                  User = predicates.isType '"String",
                  Volume = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          RBDVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "CephMonitors",
                  "FSType",
                  "Keyring",
                  "RBDImage",
                  "RBDPool",
                  "RadosUser",
                  "ReadOnly",
                  "SecretRef"
                ],
                predicates.records.record
                {
                  CephMonitors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  FSType = predicates.isType '"String",
                  Keyring = predicates.isType '"String",
                  RBDImage = predicates.isType '"String",
                  RBDPool = predicates.isType '"String",
                  RadosUser = predicates.isType '"String",
                  ReadOnly = predicates.isType '"Bool",
                  SecretRef = definitions.predicate.LocalObjectReference,
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
                  docker_socket = predicates.isType '"String",
                  hostname_override = predicates.isType '"String",
                  internal_address = predicates.isType '"String",
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
                  ssh_agent_auth = predicates.isType '"Bool",
                  ssh_cert = predicates.isType '"String",
                  ssh_cert_path = predicates.isType '"String",
                  ssh_key = predicates.isType '"String",
                  ssh_key_path = predicates.isType '"String",
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
                  kube-api = definitions.predicate.KubeAPIService,
                  kube-controller = definitions.predicate.KubeControllerService,
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
                  aci_cni_deploy_container = predicates.isType '"String",
                  aci_controller_container = predicates.isType '"String",
                  aci_gbp_server_container = predicates.isType '"String",
                  aci_host_container = predicates.isType '"String",
                  aci_mcast_container = predicates.isType '"String",
                  aci_opflex_container = predicates.isType '"String",
                  aci_opflex_server_container = predicates.isType '"String",
                  aci_ovs_container = predicates.isType '"String",
                  alpine = predicates.isType '"String",
                  calico_cni = predicates.isType '"String",
                  calico_controllers = predicates.isType '"String",
                  calico_ctl = predicates.isType '"String",
                  calico_flexvol = predicates.isType '"String",
                  calico_node = predicates.isType '"String",
                  canal_cni = predicates.isType '"String",
                  canal_controllers = predicates.isType '"String",
                  canal_flannel = predicates.isType '"String",
                  canal_flexvol = predicates.isType '"String",
                  canal_node = predicates.isType '"String",
                  cert_downloader = predicates.isType '"String",
                  coredns = predicates.isType '"String",
                  coredns_autoscaler = predicates.isType '"String",
                  dnsmasq = predicates.isType '"String",
                  etcd = predicates.isType '"String",
                  flannel = predicates.isType '"String",
                  flannel_cni = predicates.isType '"String",
                  ingress = predicates.isType '"String",
                  ingress_backend = predicates.isType '"String",
                  ingress_webhook = predicates.isType '"String",
                  kubedns = predicates.isType '"String",
                  kubedns_autoscaler = predicates.isType '"String",
                  kubedns_sidecar = predicates.isType '"String",
                  kubernetes = predicates.isType '"String",
                  kubernetes_services_sidecar = predicates.isType '"String",
                  metrics_server = predicates.isType '"String",
                  nginx_proxy = predicates.isType '"String",
                  nodelocal = predicates.isType '"String",
                  pod_infra_container = predicates.isType '"String",
                  weave_cni = predicates.isType '"String",
                  weave_node = predicates.isType '"String",
                  windows_pod_infra_container = predicates.isType '"String",
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
                  addon_job_timeout = predicates.isType 'Integer,
                  addons = predicates.isType '"String",
                  addons_include = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  authentication = definitions.predicate.AuthnConfig,
                  authorization = definitions.predicate.AuthzConfig,
                  bastion_host = definitions.predicate.BastionHost,
                  cloud_provider = definitions.predicate.CloudProvider,
                  cluster_name = predicates.isType '"String",
                  dns = definitions.predicate.DNSConfig,
                  enable_cri_dockerd = predicates.isType '"Bool",
                  ignore_docker_version = predicates.isType '"Bool",
                  ingress = definitions.predicate.IngressConfig,
                  kubernetes_version = predicates.isType '"String",
                  monitoring = definitions.predicate.MonitoringConfig,
                  network = definitions.predicate.NetworkConfig,
                  nodes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.RKEConfigNode
                      ],
                  prefix_path = predicates.isType '"String",
                  private_registries = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.PrivateRegistry
                      ],
                  restore = definitions.predicate.RestoreConfig,
                  rotate_certificates =
                    definitions.predicate.RotateCertificates,
                  rotate_encryption_key = predicates.isType '"Bool",
                  services = definitions.predicate.RKEConfigServices,
                  ssh_agent_auth = predicates.isType '"Bool",
                  ssh_cert_path = predicates.isType '"String",
                  ssh_key_path = predicates.isType '"String",
                  system_images = definitions.predicate.RKESystemImages,
                  upgrade_strategy = definitions.predicate.NodeUpgradeStrategy,
                  win_prefix_path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ResourceConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "Providers", "Resources" ],
                predicates.records.record
                {
                  Providers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ProviderConfiguration
                      ],
                  Resources = predicates.allOf
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
                predicates.records.required
                [ "ContainerName", "Divisor", "Resource" ],
                predicates.records.record
                {
                  ContainerName = predicates.isType '"String",
                  Divisor = definitions.predicate.Quantity,
                  Resource = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ResourceRequirements = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "Limits", "Requests" ],
                predicates.records.record
                {
                  Limits = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = definitions.predicate.Quantity, }
                        true
                        predicates.always
                      ],
                  Requests = predicates.allOf
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
                  snapshot_name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          RollingUpdateDaemonSet = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "MaxSurge", "MaxUnavailable" ],
                predicates.records.record
                {
                  MaxSurge = definitions.predicate.IntOrString,
                  MaxUnavailable = definitions.predicate.IntOrString,
                }
                {  }
                false
                predicates.never
              ],
          RollingUpdateDeployment = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "MaxSurge", "MaxUnavailable" ],
                predicates.records.record
                {
                  MaxSurge = definitions.predicate.IntOrString,
                  MaxUnavailable = definitions.predicate.IntOrString,
                }
                {  }
                false
                predicates.never
              ],
          RotateCertificates = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "CACertificates", "Services" ],
                predicates.records.record
                {
                  CACertificates = predicates.isType '"Bool",
                  Services = predicates.allOf
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
                predicates.records.required
                [
                  "access_key",
                  "bucket_name",
                  "custom_ca",
                  "endpoint",
                  "folder",
                  "region",
                  "secret_key"
                ],
                predicates.records.record
                {
                  access_key = predicates.isType '"String",
                  bucket_name = predicates.isType '"String",
                  custom_ca = predicates.isType '"String",
                  endpoint = predicates.isType '"String",
                  folder = predicates.isType '"String",
                  region = predicates.isType '"String",
                  secret_key = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ScaleIOVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "FSType",
                  "Gateway",
                  "ProtectionDomain",
                  "ReadOnly",
                  "SSLEnabled",
                  "SecretRef",
                  "StorageMode",
                  "StoragePool",
                  "System",
                  "VolumeName"
                ],
                predicates.records.record
                {
                  FSType = predicates.isType '"String",
                  Gateway = predicates.isType '"String",
                  ProtectionDomain = predicates.isType '"String",
                  ReadOnly = predicates.isType '"Bool",
                  SSLEnabled = predicates.isType '"Bool",
                  SecretRef = definitions.predicate.LocalObjectReference,
                  StorageMode = predicates.isType '"String",
                  StoragePool = predicates.isType '"String",
                  System = predicates.isType '"String",
                  VolumeName = predicates.isType '"String",
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
                  extra_args = predicates.allOf
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
                  extra_binds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extra_env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  image = predicates.isType '"String",
                  win_extra_args = predicates.allOf
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
                  win_extra_binds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  win_extra_env = predicates.allOf
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
                predicates.records.required [ "Key", "Name", "Optional" ],
                predicates.records.record
                {
                  Key = predicates.isType '"String",
                  Name = predicates.isType '"String",
                  Optional = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          SecretProjection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "Items", "Name", "Optional" ],
                predicates.records.record
                {
                  Items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.KeyToPath
                      ],
                  Name = predicates.isType '"String",
                  Optional = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          SecretVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "DefaultMode", "Items", "Optional", "SecretName" ],
                predicates.records.record
                {
                  DefaultMode = predicates.isType 'Integer,
                  Items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.KeyToPath
                      ],
                  Optional = predicates.isType '"Bool",
                  SecretName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SecretboxConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "Keys" ],
                predicates.records.record
                {
                  Keys = predicates.allOf
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
                predicates.records.required [ "custom_config" ],
                predicates.records.record
                {
                  custom_config = definitions.predicate.EncryptionConfiguration,
                  enabled = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ServiceAccountTokenProjection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "Audience", "ExpirationSeconds", "Path" ],
                predicates.records.record
                {
                  Audience = predicates.isType '"String",
                  ExpirationSeconds = predicates.isType 'Integer,
                  Path = predicates.isType '"String",
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
                predicates.records.required
                [
                  "FSType",
                  "ReadOnly",
                  "SecretRef",
                  "VolumeName",
                  "VolumeNamespace"
                ],
                predicates.records.record
                {
                  FSType = predicates.isType '"String",
                  ReadOnly = predicates.isType '"Bool",
                  SecretRef = definitions.predicate.LocalObjectReference,
                  VolumeName = predicates.isType '"String",
                  VolumeNamespace = predicates.isType '"String",
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
                predicates.records.required
                [ "Effect", "Key", "Operator", "TolerationSeconds", "Value" ],
                predicates.records.record
                {
                  Effect = predicates.isType '"String",
                  Key = predicates.isType '"String",
                  Operator = predicates.isType '"String",
                  TolerationSeconds = predicates.isType 'Integer,
                  Value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          TypedLocalObjectReference = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "APIGroup", "Kind", "Name" ],
                predicates.records.record
                {
                  APIGroup = predicates.isType '"String",
                  Kind = predicates.isType '"String",
                  Name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Unknown = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "ContentEncoding", "ContentType", "Raw" ],
                predicates.records.record
                {
                  ContentEncoding = predicates.isType '"String",
                  ContentType = predicates.isType '"String",
                  Raw = predicates.isType '"String",
                  apiVersion = predicates.isType '"String",
                  kind = predicates.isType '"String",
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
                predicates.records.required
                [ "ConfigMap", "DownwardAPI", "Secret", "ServiceAccountToken" ],
                predicates.records.record
                {
                  ConfigMap = definitions.predicate.ConfigMapProjection,
                  DownwardAPI = definitions.predicate.DownwardAPIProjection,
                  Secret = definitions.predicate.SecretProjection,
                  ServiceAccountToken =
                    definitions.predicate.ServiceAccountTokenProjection,
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
                  virtual_center = predicates.allOf
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
                predicates.records.required
                [
                  "FSType",
                  "StoragePolicyID",
                  "StoragePolicyName",
                  "VolumePath"
                ],
                predicates.records.record
                {
                  FSType = predicates.isType '"String",
                  StoragePolicyID = predicates.isType '"String",
                  StoragePolicyName = predicates.isType '"String",
                  VolumePath = predicates.isType '"String",
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