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
          BoltDB
            | doc m%"
            BoltDB config section
            "%
            = {
                file
                  | String
                  | doc m%"
                  file name for the db
                  "%
                  | optional,
                interval
                  | std.number.Integer
                  | doc m%"
                  TTL keys check interval in seconds. It's safe to use 1 second here, but can be a little costly to performance
                  "%
                  | optional,
                permission
                  | std.number.Integer
                  | doc m%"
                  Access permission for the DB file.
                  "%
                  | optional,
                ..
              },
          BoltDB_J
            | doc m%"
            Boltdb jobs driver
            "%
            = { permissions | std.number.Integer | optional, .. },
          Bucket
            | doc m%"
            Hashmap with floats
            "%
            = predicates.contract_from_predicate definitions.predicate.Bucket,
          Duration
            | doc m%"
            Time duration
            "%
            = predicates.contract_from_predicate definitions.predicate.Duration,
          HashMapInt = predicates.contract_from_predicate
              definitions.predicate.HashMapInt,
          Hashmap
            | doc m%"
            Hashmap
            "%
            = predicates.contract_from_predicate definitions.predicate.Hashmap,
          HostAndPort
            | doc m%"
            Host and port
            "%
            = predicates.contract_from_predicate
              definitions.predicate.HostAndPort,
          HostAndPortWithTCP
            | doc m%"
            Host and port with tcp:// prefix
            "%
            = predicates.contract_from_predicate
              definitions.predicate.HostAndPortWithTCP,
          KAFKA_J
            | doc m%"
            Kafka jobs driver
            "%
            = {
                brokers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "127.0.0.1:9092", "127.0.0.1:9002" ]
                    ])
                  ])
                  | doc m%"
                  Kafka broker addresses
                  "%
                  | optional,
                sasl
                  | predicates.contract_from_predicate
                  (predicates.records.record
                  {
                    access_key = predicates.isType '"String",
                    is_token = predicates.isType '"Bool",
                    mechanism = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "aws_msk_iam",
                              "plain",
                              "SCRAM-SHA-256",
                              "SCRAM-SHA-512"
                            ]
                          ])
                        ],
                    nonce = predicates.isType '"String",
                    password = predicates.isType '"String",
                    secret_key = predicates.isType '"String",
                    session_token = predicates.isType '"String",
                    user_agent = predicates.isType '"String",
                    username = predicates.isType '"String",
                    zid = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always)
                  | doc m%"
                  Mechanism used for the authentication
                  "%
                  | optional,
                ..
              },
          LogEncoding
            | doc m%"
            Encoding format
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| 'json, 'console |] ],
          LogLevel
            | doc m%"
            Logging level
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'panic, 'error, 'warn, 'info, 'debug |]
              ],
          LogMode
            | doc m%"
            Logging mode
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| 'raw, 'production, 'development |] ],
          LogOutput = String,
          Memcached
            | doc m%"
            In-memory config section
            "%
            = {
                addr
                  | String
                  | doc m%"
                  Address of the memcached node
                  "%
                  | optional,
                ..
              },
          Memory
            | doc m%"
            In-memory config section
            "%
            = {
                interval
                  | std.number.Integer
                  | doc m%"
                  TTL keys check interval in seconds. It's safe to use 1 second here, but can be a little costly to performance
                  "%
                  | optional,
                ..
              },
          NATS_J
            | doc m%"
            NATS jobs driver
            "%
            = {
                addr
                  | String
                  | doc m%"
                  NATS server address
                  "%
                  | optional,
                ..
              },
          Redis
            | doc m%"
            Redis config section
            "%
            = {
                addrs
                  | Array Dyn
                  | doc m%"
                  Redis server addresses
                  "%
                  | optional,
                db
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.maximum 10 ])
                  | doc m%"
                  Redis db number
                  "%
                  | optional,
                dial_timeout
                  | definitions.contract.Duration
                  | doc m%"
                  dial timeout
                  "%
                  | optional,
                idle_check_freq | definitions.contract.Duration | optional,
                idle_timeout | definitions.contract.Duration | optional,
                master_name | String | optional,
                max_conn_age | definitions.contract.Duration | optional,
                max_retries | std.number.Integer | optional,
                max_retry_backoff | definitions.contract.Duration | optional,
                min_idle_conns | std.number.Integer | optional,
                min_retry_backoff | definitions.contract.Duration | optional,
                password | String | optional,
                pool_size | std.number.Integer | optional,
                pool_timeout | definitions.contract.Duration | optional,
                read_only | Bool | optional,
                read_timeout | definitions.contract.Duration | optional,
                route_by_latency | Bool | optional,
                route_randomly | Bool | optional,
                sentinel_password | String | optional,
                username | String | optional,
                write_timeout | definitions.contract.Duration | optional,
                ..
              },
          Service
            | doc m%"
            User defined service
            "%
            = {
                command
                  | String
                  | doc m%"
                  Command to execute. Can be any command here which can be executed.
                  "%,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Record, definitions.predicate.Hashmap ])
                  | doc m%"
                  Environment variables for the process
                  "%
                  | optional,
                exec_timeout
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.Duration
                  ])
                  | doc m%"
                  Allowed time before stop
                  "%
                  | optional,
                process_num
                  | std.number.Integer
                  | doc m%"
                  Number of copies (processes) to start per command
                  "%
                  | optional,
                remain_after_exit
                  | Bool
                  | doc m%"
                  Remain process after exit. In other words, restart process after exit with any exit code
                  "%
                  | optional,
                restart_sec
                  | std.number.Integer
                  | doc m%"
                  Number of seconds to wait before process restart
                  "%
                  | optional,
                timeout_stop_sec
                  | std.number.Integer
                  | doc m%"
                  Timeout for the process stop operation
                  "%
                  | optional,
                ..
              },
          TCPServers
            | doc m%"
            TCP server
            "%
            = {
                addr
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^[0-9a-zA-Z_.-]+:[0-9]{1,5}$"
                  ])
                  | doc m%"
                  Address to listen
                  "%,
                delimiter
                  | String
                  | doc m%"
                  Data packets delimiter. Every send should end either with EOF or with the delimiter
                  "%
                  | optional,
                read_buf_size
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 100,
                    predicates.numbers.minimum 1
                  ])
                  | doc m%"
                  Chunks that RR uses to read the data. In MB. If you expect big payloads on a TCP server, to reduce `read` syscalls, would be a good practice to use a fairly big enough buffer
                  "%
                  | optional,
                ..
              },
          WorkersPool
            | doc m%"
            Static pool with PHP workers
            "%
            = {
                allocate_timeout
                  | definitions.contract.Duration
                  | doc m%"
                  Timeout for worker allocation. Zero means the default limit - 60s
                  "%
                  | optional,
                command
                  | String
                  | doc m%"
                  Command to use for the pool. Will override the server's command
                  "%
                  | optional,
                debug
                  | Bool
                  | doc m%"
                  Pool debug mode. Worker will be created right before RR passes request to it
                  "%
                  | optional,
                destroy_timeout
                  | definitions.contract.Duration
                  | doc m%"
                  Timeout for worker destroying before process killing. Zero means the default limit - 60s
                  "%
                  | optional,
                max_jobs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  Maximal count of worker executions. Zero (or nothing) means no limit
                  "%
                  | optional,
                num_workers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  How many worker processes will be started. Zero (or nothing) means the number of logical CPUs
                  "%
                  | optional,
                reset_timeout
                  | definitions.contract.Duration
                  | doc m%"
                  Timeout for the pool.Reset operation (./rr reset). Zero means the default limit - 60s
                  "%
                  | optional,
                stream_timeout
                  | definitions.contract.Duration
                  | doc m%"
                  Timeout for the stream cancellation. Zero means the default limit - 60s
                  "%
                  | optional,
                supervisor
                  | {
                    exec_ttl
                      | definitions.contract.Duration
                      | doc m%"
                      Maximal job lifetime (hard limit). Zero means no limit
                      "%
                      | optional,
                    idle_ttl
                      | definitions.contract.Duration
                      | doc m%"
                      How long worker can spend in IDLE mode after first using (soft limit). Zero means no limit
                      "%
                      | optional,
                    max_worker_memory
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ])
                      | doc m%"
                      Maximal worker memory usage in megabytes (soft limit). Zero means no limit
                      "%
                      | optional,
                    ttl
                      | definitions.contract.Duration
                      | doc m%"
                      Maximum time worker is allowed to live (soft limit). Zero means no limit
                      "%
                      | optional,
                    watch_tick
                      | definitions.contract.Duration
                      | doc m%"
                      How often to check the state of the workers
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Supervisor is used to control http workers
                  "%
                  | optional,
                ..
              },
        },
    predicate = {
          BoltDB
            | doc m%"
            BoltDB config section
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  file = predicates.isType '"String",
                  interval = predicates.isType 'Integer,
                  permission = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          BoltDB_J
            | doc m%"
            Boltdb jobs driver
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { permissions = predicates.isType 'Integer, }
                {  }
                true
                predicates.always
              ],
          Bucket
            | doc m%"
            Hashmap with floats
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                { "[+-]?([0-9]*[.])?[0-9]+" = predicates.isType '"Number", }
                false
                predicates.never
              ],
          Duration
            | doc m%"
            Time duration
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[0-9]+[ms]|[s,h]"
              ],
          HashMapInt = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType 'Integer)
              ],
          Hashmap
            | doc m%"
            Hashmap
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                { "^[a-zA-Z0-9._-]+$" = predicates.isType '"String", }
                false
                predicates.never
              ],
          HostAndPort
            | doc m%"
            Host and port
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^([0-9a-zA-Z_.-]+|):[0-9]{1,5}$"
              ],
          HostAndPortWithTCP
            | doc m%"
            Host and port with tcp:// prefix
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^(tcp://[0-9a-zA-Z_.-]+|):[0-9]{1,5}$"
              ],
          KAFKA_J
            | doc m%"
            Kafka jobs driver
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  brokers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "127.0.0.1:9092", "127.0.0.1:9002" ]
                        ])
                      ],
                  sasl = predicates.records.record
                      {
                        access_key = predicates.isType '"String",
                        is_token = predicates.isType '"Bool",
                        mechanism = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.arrays.arrayOf
                              (predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "aws_msk_iam",
                                  "plain",
                                  "SCRAM-SHA-256",
                                  "SCRAM-SHA-512"
                                ]
                              ])
                            ],
                        nonce = predicates.isType '"String",
                        password = predicates.isType '"String",
                        secret_key = predicates.isType '"String",
                        session_token = predicates.isType '"String",
                        user_agent = predicates.isType '"String",
                        username = predicates.isType '"String",
                        zid = predicates.isType '"String",
                      }
                      {  }
                      true
                      predicates.always,
                }
                {  }
                true
                predicates.always
              ],
          LogEncoding
            | doc m%"
            Encoding format
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "console", "json" ]
              ],
          LogLevel
            | doc m%"
            Logging level
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "debug", "info", "warn", "error", "panic" ]
              ],
          LogMode
            | doc m%"
            Logging mode
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "development", "production", "raw" ]
              ],
          LogOutput = predicates.isType '"String",
          Memcached
            | doc m%"
            In-memory config section
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { addr = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          Memory
            | doc m%"
            In-memory config section
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { interval = predicates.isType 'Integer, }
                {  }
                true
                predicates.always
              ],
          NATS_J
            | doc m%"
            NATS jobs driver
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { addr = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          Redis
            | doc m%"
            Redis config section
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addrs = predicates.isType '"Array",
                  db = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 10
                      ],
                  dial_timeout = definitions.predicate.Duration,
                  idle_check_freq = definitions.predicate.Duration,
                  idle_timeout = definitions.predicate.Duration,
                  master_name = predicates.isType '"String",
                  max_conn_age = definitions.predicate.Duration,
                  max_retries = predicates.isType 'Integer,
                  max_retry_backoff = definitions.predicate.Duration,
                  min_idle_conns = predicates.isType 'Integer,
                  min_retry_backoff = definitions.predicate.Duration,
                  password = predicates.isType '"String",
                  pool_size = predicates.isType 'Integer,
                  pool_timeout = definitions.predicate.Duration,
                  read_only = predicates.isType '"Bool",
                  read_timeout = definitions.predicate.Duration,
                  route_by_latency = predicates.isType '"Bool",
                  route_randomly = predicates.isType '"Bool",
                  sentinel_password = predicates.isType '"String",
                  username = predicates.isType '"String",
                  write_timeout = definitions.predicate.Duration,
                }
                {  }
                true
                predicates.always
              ],
          Service
            | doc m%"
            User defined service
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "command" ],
                predicates.records.record
                {
                  command = predicates.isType '"String",
                  env = predicates.allOf
                      [
                        predicates.isType 'Record,
                        definitions.predicate.Hashmap
                      ],
                  exec_timeout = predicates.allOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.Duration
                      ],
                  process_num = predicates.isType 'Integer,
                  remain_after_exit = predicates.isType '"Bool",
                  restart_sec = predicates.isType 'Integer,
                  timeout_stop_sec = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          TCPServers
            | doc m%"
            TCP server
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "addr" ],
                predicates.records.record
                {
                  addr = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-zA-Z_.-]+:[0-9]{1,5}$"
                      ],
                  delimiter = predicates.isType '"String",
                  read_buf_size = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 100,
                        predicates.numbers.minimum 1
                      ],
                }
                {  }
                true
                predicates.always
              ],
          WorkersPool
            | doc m%"
            Static pool with PHP workers
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allocate_timeout = definitions.predicate.Duration,
                  command = predicates.isType '"String",
                  debug = predicates.isType '"Bool",
                  destroy_timeout = definitions.predicate.Duration,
                  max_jobs = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  num_workers = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  reset_timeout = definitions.predicate.Duration,
                  stream_timeout = definitions.predicate.Duration,
                  supervisor = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          exec_ttl = definitions.predicate.Duration,
                          idle_ttl = definitions.predicate.Duration,
                          max_worker_memory = predicates.allOf
                              [
                                predicates.isType 'Integer,
                                predicates.numbers.minimum 0
                              ],
                          ttl = definitions.predicate.Duration,
                          watch_tick = definitions.predicate.Duration,
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
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.minProperties 1,
  predicates.records.required [ "version" ],
  predicates.records.record
  {
    amqp = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            addr = predicates.isType '"String",
            tls = predicates.records.record
                {
                  cert = predicates.isType '"String",
                  client_auth_type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "request_client_cert",
                          "require_any_client_cert",
                          "verify_client_cert_if_given",
                          "no_client_certs",
                          "require_and_verify_client_cert"
                        ]
                      ],
                  key = predicates.isType '"String",
                  root_ca = predicates.isType '"String",
                }
                {  }
                true
                predicates.always,
          }
          {  }
          true
          predicates.always
        ],
    beanstalk = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            addr = predicates.isType '"String",
            timeout = predicates.allOf
                [ predicates.isType '"String", definitions.predicate.Duration ],
          }
          {  }
          true
          predicates.always
        ],
    centrifuge = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            grpc_api_address = predicates.isType '"String",
            name = predicates.isType '"String",
            pool = definitions.predicate.WorkersPool,
            proxy_address = predicates.isType '"String",
            tls = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    cert = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    key = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
            use_compressor = predicates.isType '"Bool",
            version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    fileserver = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            address = predicates.always,
            calculate_etag = predicates.always,
            serve = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "prefix" ],
                    predicates.records.record
                    {
                      bytes_range = predicates.isType '"Bool",
                      cache_duration = predicates.isType 'Integer,
                      compress = predicates.isType '"Bool",
                      max_age = predicates.isType 'Integer,
                      prefix = predicates.isType '"String",
                      root = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always
                  ]),
                  predicates.arrays.minItems 1
                ],
            stream_request_body = predicates.always,
            weak = predicates.always,
          }
          {  }
          true
          predicates.always
        ],
    grpc = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            listen = predicates.allOf
                [
                  predicates.isType '"String",
                  definitions.predicate.HostAndPortWithTCP
                ],
            max_concurrent_streams = predicates.isType 'Integer,
            max_connection_age = definitions.predicate.Duration,
            max_connection_age_grace = definitions.predicate.Duration,
            max_connection_idle = definitions.predicate.Duration,
            max_recv_msg_size = predicates.isType 'Integer,
            max_send_msg_size = predicates.isType 'Integer,
            ping_time = definitions.predicate.Duration,
            pool = predicates.allOf
                [
                  predicates.isType 'Record,
                  definitions.predicate.WorkersPool
                ],
            proto = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            timeout = definitions.predicate.Duration,
            tls = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    cert = predicates.isType '"String",
                    client_auth_type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "request_client_cert",
                            "require_any_client_cert",
                            "verify_client_cert_if_given",
                            "no_client_certs",
                            "require_and_verify_client_cert"
                          ]
                        ],
                    key = predicates.isType '"String",
                    root_ca = predicates.isType '"String",
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
    http = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "address" ],
          predicates.records.record
          {
            access_logs = predicates.isType '"Bool",
            address = definitions.predicate.HostAndPort,
            cache = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    api = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            basepath = predicates.isType '"String",
                            prometheus = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  { basepath = predicates.isType '"String", }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            souin = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  { basepath = predicates.isType '"String", }
                                  {  }
                                  true
                                  predicates.always
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    cache_keys = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          {
                            "^[a-zA-Z0-9._-]+$" = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    disable_body = predicates.isType '"Bool",
                                    disable_host = predicates.isType '"Bool",
                                    disable_method = predicates.isType '"Bool",
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                          }
                          true
                          predicates.always
                        ],
                    cdn = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            api_key = predicates.isType '"String",
                            dynamic = predicates.isType '"Bool",
                            provider = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum
                                  [
                                    "fastly",
                                    "cloudflare",
                                    "akamai",
                                    "varnish"
                                  ]
                                ],
                            strategy = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "soft", "hard" ]
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    default_cache = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            allowed_http_verbs = predicates.isType '"Array",
                            cache_name = predicates.isType '"String",
                            default_cache_control = predicates.isType '"String",
                            distributed = predicates.isType '"Bool",
                            etcd = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    configuration = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            endpoints = predicates.isType
                                                '"Array",
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
                            headers = predicates.isType '"Array",
                            key = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    disable_body = predicates.isType '"Bool",
                                    disable_host = predicates.isType '"Bool",
                                    disable_method = predicates.isType '"Bool",
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            olric = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  { url = predicates.isType '"String", }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            regex = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  { exclude = predicates.isType '"String", }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            stale = predicates.isType '"String",
                            timeout = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    backend = predicates.isType '"String",
                                    cache = predicates.isType '"String",
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            ttl = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    log_level = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "DEBUG",
                            "INFO",
                            "WARN",
                            "DPANIC",
                            "PANIC",
                            "ERROR",
                            "FATAL"
                          ]
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
            fcgi = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "address" ],
                  predicates.records.record
                  { address = predicates.isType '"String", }
                  {  }
                  true
                  predicates.always
                ],
            headers = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    cors = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            allow_credentials = predicates.isType '"Bool",
                            allowed_headers = predicates.isType '"String",
                            allowed_methods = predicates.isType '"String",
                            allowed_origin = predicates.isType '"String",
                            exposed_headers = predicates.isType '"String",
                            max_age = predicates.isType 'Integer,
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    request = definitions.predicate.Hashmap,
                    response = definitions.predicate.Hashmap,
                  }
                  {  }
                  true
                  predicates.always
                ],
            http2 = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    h2c = predicates.isType '"Bool",
                    max_concurrent_streams = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
            max_request_size = predicates.allOf
                [ predicates.isType 'Integer, predicates.numbers.minimum 0 ],
            middleware = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum
                    [
                      "headers",
                      "gzip",
                      "static",
                      "sendfile",
                      "http_metrics",
                      "cache",
                      "proxy_ip_parser",
                      "otel"
                    ],
                    predicates.strings.pattern "^[0-9a-zA-Z_]+$"
                  ])
                ],
            pool = definitions.predicate.WorkersPool,
            raw_body = predicates.isType '"Bool",
            ssl = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "address", "cert", "key" ],
                  predicates.records.record
                  {
                    acme = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "domains", "email" ],
                          predicates.records.record
                          {
                            alt_http_port = predicates.isType 'Integer,
                            alt_tlsalpn_port = predicates.isType 'Integer,
                            certs_dir = predicates.isType '"String",
                            challenge_type = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "http-01", "tlsalpn-01" ]
                                ],
                            domains = predicates.isType '"Array",
                            email = predicates.isType '"String",
                            use_production_endpoint = predicates.isType '"Bool",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    address = definitions.predicate.HostAndPort,
                    cert = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    client_auth_type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "request_client_cert",
                            "require_any_client_cert",
                            "verify_client_cert_if_given",
                            "no_client_certs",
                            "require_and_verify_client_cert"
                          ]
                        ],
                    key = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    redirect = predicates.isType '"Bool",
                    root_ca = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
            static = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "dir" ],
                  predicates.records.record
                  {
                    allow = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    calculate_etag = predicates.isType '"Bool",
                    dir = predicates.isType '"String",
                    forbid = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    response = definitions.predicate.Hashmap,
                    weak = predicates.isType '"Bool",
                  }
                  {  }
                  true
                  predicates.always
                ],
            trusted_subnets = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            uploads = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    allow = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    dir = predicates.isType '"String",
                    forbid = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
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
    jobs = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            consume = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            num_pollers = predicates.isType 'Integer,
            pipeline_size = predicates.isType 'Integer,
            pipelines = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    config = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          {
                            "^[a-zA-Z0-9._-]+$" = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.oneOf
                                  [
                                    predicates.records.record
                                    {
                                      file = predicates.isType '"String",
                                      permissions = predicates.isType 'Integer,
                                      prefetch = predicates.isType 'Integer,
                                      "priority" = predicates.isType 'Integer,
                                    }
                                    {  }
                                    true
                                    predicates.always,
                                    predicates.records.record
                                    {
                                      consume_all = predicates.isType '"Bool",
                                      consumer_id = predicates.isType '"String",
                                      exchange = predicates.isType '"String",
                                      exchange_auto_deleted = predicates.isType
                                          '"Bool",
                                      exchange_durable = predicates.isType
                                          '"Bool",
                                      exchange_type = predicates.isType
                                          '"String",
                                      exclusive = predicates.isType '"Bool",
                                      multiple_ack = predicates.isType '"Bool",
                                      prefetch = predicates.isType 'Integer,
                                      "priority" = predicates.isType 'Integer,
                                      queue = predicates.isType '"String",
                                      queue_auto_deleted = predicates.isType
                                          '"Bool",
                                      queue_headers =
                                        definitions.predicate.Hashmap,
                                      redial_timeout = predicates.isType
                                          'Integer,
                                      requeue_on_fail = predicates.isType
                                          '"Bool",
                                      routing_key = predicates.isType '"String",
                                    }
                                    {  }
                                    true
                                    predicates.always,
                                    predicates.records.record
                                    {
                                      auto_create_topics_enable =
                                        predicates.isType '"Bool",
                                      consumer_options = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              consume_offset = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      type = predicates.allOf
                                                          [
                                                            predicates.isType
                                                            '"String",
                                                            predicates.enum
                                                            [
                                                              "AtEnd",
                                                              "At",
                                                              "AfterMilli",
                                                              "AtStart",
                                                              "Relative",
                                                              "WithEpoch"
                                                            ]
                                                          ],
                                                      value = predicates.isType
                                                          'Integer,
                                                    }
                                                    {  }
                                                    true
                                                    predicates.always
                                                  ],
                                              consume_partitions =
                                                predicates.records.record {  }
                                                  {
                                                    "^[a-zA-Z0-9._-]+$" =
                                                      predicates.allOf
                                                        [
                                                          predicates.isType
                                                          '"String",
                                                          predicates.records.record
                                                          {  }
                                                          {
                                                            "^[0-9]+$" =
                                                              predicates.allOf
                                                                [
                                                                  predicates.isType
                                                                  'Integer,
                                                                  predicates.records.record
                                                                  {
                                                                    type =
                                                                      predicates.allOf
                                                                        [
                                                                          predicates.isType
                                                                          '"String",
                                                                          predicates.enum
                                                                          [
                                                                            "AtEnd",
                                                                            "At",
                                                                            "AfterMilli",
                                                                            "AtStart",
                                                                            "Relative",
                                                                            "WithEpoch"
                                                                          ]
                                                                        ],
                                                                    value =
                                                                      predicates.isType
                                                                        'Integer,
                                                                  }
                                                                  {  }
                                                                  true
                                                                  predicates.always
                                                                ],
                                                          }
                                                          true
                                                          predicates.always
                                                        ],
                                                  }
                                                  true
                                                  predicates.always,
                                              consume_regexp = predicates.isType
                                                  '"Bool",
                                              max_fetch_message_size =
                                                predicates.isType 'Integer,
                                              min_fetch_message_size =
                                                predicates.isType 'Integer,
                                              topics = predicates.isType
                                                  '"Array",
                                            }
                                            {  }
                                            true
                                            predicates.always
                                          ],
                                      group_options = predicates.records.record
                                          {
                                            block_rebalance_on_poll =
                                              predicates.isType '"Bool",
                                            group_id = predicates.isType
                                                '"String",
                                          }
                                          {  }
                                          true
                                          predicates.always,
                                      "priority" = predicates.isType 'Integer,
                                      producer_options = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              compression_codec =
                                                predicates.allOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.enum
                                                    [
                                                      "none",
                                                      "gzip",
                                                      "snappy",
                                                      "lz4",
                                                      "zstd"
                                                    ]
                                                  ],
                                              delivery_timeout =
                                                predicates.isType 'Integer,
                                              disable_idempotent =
                                                predicates.isType '"Bool",
                                              max_message_bytes =
                                                predicates.isType 'Integer,
                                              request_timeout =
                                                predicates.isType 'Integer,
                                              required_acks = predicates.allOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.enum
                                                    [
                                                      "NoAck",
                                                      "LeaderAck",
                                                      "AllISRAck"
                                                    ]
                                                  ],
                                              transaction_timeout =
                                                predicates.isType '"Bool",
                                            }
                                            {  }
                                            true
                                            predicates.always
                                          ],
                                    }
                                    {  }
                                    true
                                    predicates.always,
                                    predicates.records.record
                                    {
                                      prefetch = predicates.isType 'Integer,
                                      "priority" = predicates.isType 'Integer,
                                    }
                                    {  }
                                    true
                                    predicates.always,
                                    predicates.records.record
                                    {
                                      consume_all = predicates.isType '"Bool",
                                      prefetch = predicates.isType 'Integer,
                                      "priority" = predicates.isType 'Integer,
                                      reserve_timeout =
                                        definitions.predicate.Duration,
                                      tube = predicates.isType '"String",
                                      tube_priority = predicates.isType
                                          'Integer,
                                    }
                                    {  }
                                    true
                                    predicates.always,
                                    predicates.records.record
                                    {
                                      attributes = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record {  }
                                              {  }
                                              true
                                              (predicates.isType '"Number")
                                            ])
                                          ],
                                      consume_all = predicates.isType '"Bool",
                                      prefetch = predicates.isType 'Integer,
                                      "priority" = predicates.isType 'Integer,
                                      queue = predicates.isType '"String",
                                      skip_queue_declaration = predicates.isType
                                          '"Bool",
                                      tags = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record {  }
                                              {  }
                                              true
                                              (predicates.isType '"String")
                                            ])
                                          ],
                                      visibility_timeout = predicates.isType
                                          'Integer,
                                      wait_time_seconds = predicates.isType
                                          'Integer,
                                    }
                                    {  }
                                    true
                                    predicates.always,
                                    predicates.records.record
                                    {
                                      consume_all = predicates.isType '"Bool",
                                      delete_after_ack = predicates.isType
                                          '"Bool",
                                      delete_stream_on_stop = predicates.isType
                                          '"Bool",
                                      deliver_new = predicates.isType '"String",
                                      prefetch = predicates.isType 'Integer,
                                      "priority" = predicates.isType 'Integer,
                                      rate_limit = predicates.isType 'Integer,
                                      stream = predicates.isType '"String",
                                      subject = predicates.isType '"String",
                                    }
                                    {  }
                                    true
                                    predicates.always
                                  ],
                                  predicates.records.maxProperties 1,
                                  predicates.records.record {  } {  } true
                                  predicates.always
                                ],
                          }
                          true
                          predicates.always
                        ],
                    driver = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "amqp",
                              "sqs",
                              "beanstalk",
                              "boltdb",
                              "memory",
                              "nats",
                              "kafka"
                            ]
                          ])
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
            pool = predicates.allOf
                [
                  predicates.isType 'Record,
                  definitions.predicate.WorkersPool
                ],
            timeout = predicates.isType 'Integer,
          }
          {  }
          true
          predicates.always
        ],
    kafka = definitions.predicate.KAFKA_J,
    kv = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.minProperties 1,
          predicates.records.record {  }
          {
            "[a-zA-Z0-9_-]*" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "driver" ],
                  predicates.records.record
                  {
                    config = predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            definitions.predicate.BoltDB
                          ],
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            definitions.predicate.Memcached
                          ],
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            definitions.predicate.Redis
                          ],
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            definitions.predicate.Memory
                          ]
                        ],
                    driver = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always
                ],
          }
          true
          predicates.always
        ],
    logs = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            channels = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      encoding = definitions.predicate.LogEncoding,
                      err_output = definitions.predicate.LogOutput,
                      level = definitions.predicate.LogLevel,
                      mode = definitions.predicate.LogMode,
                      output = definitions.predicate.LogOutput,
                    }
                    {  }
                    true
                    predicates.always
                  ])
                ],
            encoding = definitions.predicate.LogEncoding,
            err_output = definitions.predicate.LogOutput,
            file_logger_options = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    compress = predicates.isType '"Bool",
                    log_output = predicates.isType '"String",
                    max_age = predicates.isType 'Integer,
                    max_backups = predicates.isType 'Integer,
                    max_size = predicates.isType 'Integer,
                  }
                  {  }
                  true
                  predicates.always
                ],
            level = definitions.predicate.LogLevel,
            mode = definitions.predicate.LogMode,
            output = definitions.predicate.LogOutput,
          }
          {  }
          true
          predicates.always
        ],
    metrics = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            address = predicates.isType '"String",
            collect = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^[a-zA-Z0-9._-]+$" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            buckets = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"Number")
                                ],
                            help = predicates.isType '"String",
                            labels = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.minItems 1
                                ],
                            objectives = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record {  } {  } true
                                    (predicates.isType '"Number")
                                  ])
                                ],
                            type = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum
                                  [ "histogram", "gauge", "counter", "summary" ]
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ],
                  }
                  true
                  predicates.always
                ],
          }
          {  }
          true
          predicates.always
        ],
    nats = definitions.predicate.NATS_J,
    otel = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            client = predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ "http", "grpc" ],
                    predicates.strings.pattern "^[0-9a-zA-Z_]+$"
                  ])
                ],
            compress = predicates.isType '"Bool",
            custom_url = predicates.isType '"String",
            endpoint = predicates.isType '"String",
            exporter = predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum
                    [
                      "zipkin",
                      "stdout",
                      "stderr",
                      "otlp",
                      "jaeger",
                      "jaeger_agent"
                    ],
                    predicates.strings.pattern "^[0-9a-zA-Z_]+$"
                  ])
                ],
            headers = definitions.predicate.Hashmap,
            insecure = predicates.isType '"Bool",
            service_name = predicates.isType '"String",
            service_version = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    redis = predicates.allOf
        [ predicates.isType 'Record, definitions.predicate.Redis ],
    reload = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            interval = definitions.predicate.Duration,
            patterns = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            services = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.minProperties 0,
                  predicates.records.record {  }
                  {
                    "^[a-zA-Z0-9._-]+$" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            dirs = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.strings.minLength 1
                                  ])
                                ],
                            ignore = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.strings.minLength 1
                                  ])
                                ],
                            patterns = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.strings.minLength 1
                                  ])
                                ],
                            recursive = predicates.isType '"Bool",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                  }
                  false
                  predicates.never
                ],
          }
          {  }
          true
          predicates.always
        ],
    rpc = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            listen = predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern
                  "^tcp://[0-9a-zA-Z_.-]+:[0-9]{1,5}$"
                ],
          }
          {  }
          true
          predicates.always
        ],
    server = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "command" ],
          predicates.records.record
          {
            after_init = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    command = predicates.isType '"String",
                    env = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record {  }
                            {
                              "^[a-zA-Z0-9._-]+$" = predicates.isType '"String",
                            }
                            false
                            predicates.never
                          ])
                        ],
                    exec_timeout = definitions.predicate.Duration,
                  }
                  {  }
                  true
                  predicates.always
                ],
            command = predicates.isType '"String",
            env = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { "^[a-zA-Z0-9._-]+$" = predicates.isType '"String", }
                    false
                    predicates.never
                  ])
                ],
            group = predicates.isType '"String",
            on_init = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    command = predicates.isType '"String",
                    env = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record {  }
                            {
                              "^[a-zA-Z0-9._-]+$" = predicates.isType '"String",
                            }
                            false
                            predicates.never
                          ])
                        ],
                    exec_timeout = definitions.predicate.Duration,
                  }
                  {  }
                  true
                  predicates.always
                ],
            relay = predicates.isType '"String",
            relay_timeout = definitions.predicate.Duration,
            user = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    service = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "^[a-zA-Z0-9._-]+$" = predicates.allOf
                [ predicates.isType 'Record, definitions.predicate.Service ],
          }
          true
          predicates.always
        ],
    sqs = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            endpoint = predicates.isType '"String",
            key = predicates.isType '"String",
            region = predicates.isType '"String",
            secret = predicates.isType '"String",
            session_token = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    status = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "address" ],
          predicates.records.record
          {
            address = predicates.isType '"String",
            unavailable_status_code = predicates.isType 'Integer,
          }
          {  }
          true
          predicates.always
        ],
    tcp = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            pool = predicates.allOf
                [
                  predicates.isType 'Record,
                  definitions.predicate.WorkersPool
                ],
            servers = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.minProperties 1,
                  predicates.records.record {  }
                  {
                    "^[a-zA-Z0-9._-]+$" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          definitions.predicate.TCPServers
                        ],
                  }
                  true
                  predicates.always
                ],
          }
          {  }
          true
          predicates.always
        ],
    temporal = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            activities = predicates.allOf
                [
                  predicates.isType 'Record,
                  definitions.predicate.WorkersPool
                ],
            address = predicates.isType '"String",
            cache_size = predicates.isType 'Integer,
            metrics = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        address = predicates.isType '"String",
                        prefix = predicates.isType '"String",
                        type = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"String"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ],
                    predicates.records.record
                    {
                      flush_bytes = predicates.isType 'Integer,
                      flush_interval = predicates.isType '"String",
                      host_port = predicates.isType '"String",
                      prefix = predicates.isType '"String",
                      tag_prefix = predicates.isType '"String",
                      tag_separator = predicates.isType '"String",
                      tags = definitions.predicate.Hashmap,
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.records.record
                  {
                    driver = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "prometheus", "statsd" ]
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
            namespace = predicates.isType '"String",
            tls = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    cert = predicates.isType '"String",
                    client_auth_type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "request_client_cert",
                            "require_any_client_cert",
                            "verify_client_cert_if_given",
                            "no_client_certs",
                            "require_and_verify_client_cert"
                          ]
                        ],
                    key = predicates.isType '"String",
                    root_ca = predicates.isType '"String",
                    server_name = predicates.isType '"String",
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
    version = predicates.allOf
        [ predicates.isType '"String", predicates.enum [ "3" ] ],
  }
  {  }
  true
  predicates.always
])