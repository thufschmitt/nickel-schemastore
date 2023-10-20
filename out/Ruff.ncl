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
          ApiBan = {
                msg
                  | String
                  | doc m%"
                  The message to display when the API is used.
                  "%,
              },
          ConstantType = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'tuple, 'str, 'int, 'float, 'complex, 'bytes |]
              ],
          Convention = predicates.contract_from_predicate
              definitions.predicate.Convention,
          Flake8AnnotationsOptions = {
                allow-star-arg-any
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether to suppress `ANN401` for dynamically typed `*args` and `**kwargs` arguments.
                  "%
                  | optional,
                ignore-fully-untyped
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether to suppress `ANN*` rules for any declaration that hasn't been typed at all. This makes it easier to gradually add types to a codebase.
                  "%
                  | optional,
                mypy-init-return
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether to allow the omission of a return type hint for `__init__` if at least one argument is annotated.
                  "%
                  | optional,
                suppress-dummy-args
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether to suppress `ANN000`-level violations for arguments matching the "dummy" variable regex (like `_`).
                  "%
                  | optional,
                suppress-none-returning
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether to suppress `ANN200`-level violations for functions that meet either of the following criteria:
                  
                  - Contain no `return` statement. - Explicit `return` statement(s) all return `None` (explicitly or implicitly).
                  "%
                  | optional,
              },
          Flake8BanditOptions = {
                check-typed-exception
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether to disallow `try`-`except`-`pass` (`S110`) for specific exception types. By default, `try`-`except`-`pass` is only disallowed for `Exception` and `BaseException`.
                  "%
                  | optional,
                hardcoded-tmp-directory
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of directories to consider temporary.
                  "%
                  | optional,
                hardcoded-tmp-directory-extend
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of directories to consider temporary, in addition to those specified by `hardcoded-tmp-directory`.
                  "%
                  | optional,
              },
          Flake8BugbearOptions = {
                extend-immutable-calls
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Additional callable functions to consider "immutable" when evaluating, e.g., the `function-call-in-default-argument` rule (`B008`) or `function-call-in-dataclass-defaults` rule (`RUF009`).
                  
                  Expects to receive a list of fully-qualified names (e.g., `fastapi.Query`, rather than `Query`).
                  "%
                  | optional,
              },
          Flake8BuiltinsOptions = {
                builtins-ignorelist
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Ignore list of builtins.
                  "%
                  | optional,
              },
          Flake8ComprehensionsOptions = {
                allow-dict-calls-with-keyword-arguments
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Allow `dict` calls that make use of keyword arguments (e.g., `dict(a=1, b=2)`).
                  "%
                  | optional,
              },
          Flake8CopyrightOptions = {
                author
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Author to enforce within the copyright notice. If provided, the author must be present immediately following the copyright notice.
                  "%
                  | optional,
                min-file-size
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  A minimum file size (in bytes) required for a copyright notice to be enforced. By default, all files are validated.
                  "%
                  | optional,
                notice-rgx
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The regular expression used to match the copyright notice, compiled with the [`regex`](https://docs.rs/regex/latest/regex/) crate.
                  
                  Defaults to `(?i)Copyright\s+(\(C\)\s+)?\d{4}(-\d{4})*`, which matches the following: - `Copyright 2023` - `Copyright (C) 2023` - `Copyright 2021-2023` - `Copyright (C) 2021-2023`
                  "%
                  | optional,
              },
          Flake8ErrMsgOptions = {
                max-string-length
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Maximum string length for string literals in exception messages.
                  "%
                  | optional,
              },
          Flake8GetTextOptions = {
                extend-function-names
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Additional function names to consider as internationalization calls, in addition to those included in `function-names`.
                  "%
                  | optional,
                function-names
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The function names to consider as internationalization calls.
                  "%
                  | optional,
              },
          Flake8ImplicitStrConcatOptions = {
                allow-multiline
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether to allow implicit string concatenations for multiline strings. By default, implicit concatenations of multiline strings are allowed (but continuation lines, delimited with a backslash, are prohibited).
                  
                  Note that setting `allow-multiline = false` should typically be coupled with disabling `explicit-string-concatenation` (`ISC003`). Otherwise, both explicit and implicit multiline string concatenations will be seen as violations.
                  "%
                  | optional,
              },
          Flake8ImportConventionsOptions = {
                aliases
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  The conventional aliases for imports. These aliases can be extended by the `extend_aliases` option.
                  "%
                  | optional,
                banned-aliases
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
                    predicates.records.record {  } {  } true
                    (predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ])
                  ])
                  | doc m%"
                  A mapping from module to its banned import aliases.
                  "%
                  | optional,
                banned-from
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A list of modules that should not be imported from using the `from ... import ...` syntax.
                  
                  For example, given `banned-from = ["pandas"]`, `from pandas import DataFrame` would be disallowed, while `import pandas` would be allowed.
                  "%
                  | optional,
                extend-aliases
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A mapping from module to conventional import alias. These aliases will be added to the `aliases` mapping.
                  "%
                  | optional,
              },
          Flake8PytestStyleOptions = {
                fixture-parentheses
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Boolean flag specifying whether `@pytest.fixture()` without parameters should have parentheses. If the option is set to `true` (the default), `@pytest.fixture()` is valid and `@pytest.fixture` is invalid. If set to `false`, `@pytest.fixture` is valid and `@pytest.fixture()` is invalid.
                  "%
                  | optional,
                mark-parentheses
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Boolean flag specifying whether `@pytest.mark.foo()` without parameters should have parentheses. If the option is set to `true` (the default), `@pytest.mark.foo()` is valid and `@pytest.mark.foo` is invalid. If set to `false`, `@pytest.fixture` is valid and `@pytest.mark.foo()` is invalid.
                  "%
                  | optional,
                parametrize-names-type
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ParametrizeNameType,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Expected type for multiple argument names in `@pytest.mark.parametrize`. The following values are supported:
                  
                  - `csv` — a comma-separated list, e.g. `@pytest.mark.parametrize('name1,name2', ...)` - `tuple` (default) — e.g. `@pytest.mark.parametrize(('name1', 'name2'), ...)` - `list` — e.g. `@pytest.mark.parametrize(['name1', 'name2'], ...)`
                  "%
                  | optional,
                parametrize-values-row-type
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ParametrizeValuesRowType,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Expected type for each row of values in `@pytest.mark.parametrize` in case of multiple parameters. The following values are supported:
                  
                  - `tuple` (default) — e.g. `@pytest.mark.parametrize(('name1', 'name2'), [(1, 2), (3, 4)])` - `list` — e.g. `@pytest.mark.parametrize(('name1', 'name2'), [[1, 2], [3, 4]])`
                  "%
                  | optional,
                parametrize-values-type
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ParametrizeValuesType,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Expected type for the list of values rows in `@pytest.mark.parametrize`. The following values are supported:
                  
                  - `tuple` — e.g. `@pytest.mark.parametrize('name', (1, 2, 3))` - `list` (default) — e.g. `@pytest.mark.parametrize('name', [1, 2, 3])`
                  "%
                  | optional,
                raises-extend-require-match-for
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of additional exception names that require a match= parameter in a `pytest.raises()` call. This extends the default list of exceptions that require a match= parameter. This option is useful if you want to extend the default list of exceptions that require a match= parameter without having to specify the entire list. Note that this option does not remove any exceptions from the default list.
                  
                  Supports glob patterns. For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
                  "%
                  | optional,
                raises-require-match-for
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of exception names that require a match= parameter in a `pytest.raises()` call.
                  
                  Supports glob patterns. For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
                  "%
                  | optional,
              },
          Flake8QuotesOptions = {
                avoid-escape
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether to avoid using single quotes if a string contains single quotes, or vice-versa with double quotes, as per [PEP 8](https://peps.python.org/pep-0008/#string-quotes). This minimizes the need to escape quotation marks within strings.
                  "%
                  | optional,
                docstring-quotes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Quote, predicates.isType 'Null ])
                  | doc m%"
                  Quote style to prefer for docstrings (either "single" or "double").
                  "%
                  | optional,
                inline-quotes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Quote, predicates.isType 'Null ])
                  | doc m%"
                  Quote style to prefer for inline strings (either "single" or "double").
                  "%
                  | optional,
                multiline-quotes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Quote, predicates.isType 'Null ])
                  | doc m%"
                  Quote style to prefer for multiline strings (either "single" or "double").
                  "%
                  | optional,
              },
          Flake8SelfOptions = {
                extend-ignore-names
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Additional names to ignore when considering `flake8-self` violations, in addition to those included in `ignore-names`.
                  "%
                  | optional,
                ignore-names
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of names to ignore when considering `flake8-self` violations.
                  "%
                  | optional,
              },
          Flake8TidyImportsOptions = {
                ban-relative-imports
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Strictness, predicates.isType 'Null ])
                  | doc m%"
                  Whether to ban all relative imports (`"all"`), or only those imports that extend into the parent module or beyond (`"parents"`).
                  "%
                  | optional,
                banned-api
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
                    predicates.records.record {  } {  } true
                    definitions.predicate.ApiBan
                  ])
                  | doc m%"
                  Specific modules or module members that may not be imported or accessed. Note that this rule is only meant to flag accidental uses, and can be circumvented via `eval` or `importlib`.
                  "%
                  | optional,
                banned-module-level-imports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of specific modules that may not be imported at module level, and should instead be imported lazily (e.g., within a function definition, or an `if TYPE_CHECKING:` block, or some other nested context).
                  "%
                  | optional,
              },
          Flake8TypeCheckingOptions = {
                exempt-modules
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Exempt certain modules from needing to be moved into type-checking blocks.
                  "%
                  | optional,
                runtime-evaluated-base-classes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Exempt classes that list any of the enumerated classes as a base class from needing to be moved into type-checking blocks.
                  
                  Common examples include Pydantic's `pydantic.BaseModel` and SQLAlchemy's `sqlalchemy.orm.DeclarativeBase`, but can also support user-defined classes that inherit from those base classes. For example, if you define a common `DeclarativeBase` subclass that's used throughout your project (e.g., `class Base(DeclarativeBase) ...` in `base.py`), you can add it to this list (`runtime-evaluated-base-classes = ["base.Base"]`) to exempt models from being moved into type-checking blocks.
                  "%
                  | optional,
                runtime-evaluated-decorators
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Exempt classes decorated with any of the enumerated decorators from needing to be moved into type-checking blocks.
                  "%
                  | optional,
                strict
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Enforce TC001, TC002, and TC003 rules even when valid runtime imports are present for the same module.
                  
                  See flake8-type-checking's [strict](https://github.com/snok/flake8-type-checking#strict) option.
                  "%
                  | optional,
              },
          Flake8UnusedArgumentsOptions = {
                ignore-variadic-names
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether to allow unused variadic arguments, like `*args` and `**kwargs`.
                  "%
                  | optional,
              },
          FormatOptions
            | doc m%"
            Experimental: Configures how `ruff format` formats your code.
            
            Please provide feedback in [this discussion](https://github.com/astral-sh/ruff/discussions/7310).
            "%
            = {
                indent-style
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.IndentStyle,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Whether to use 4 spaces or hard tabs for indenting code.
                  
                  Defaults to 4 spaces. We care about accessibility; if you do not need tabs for accessibility, we do not recommend you use them.
                  "%
                  | optional,
                line-ending
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.LineEnding, predicates.isType 'Null ])
                  | doc m%"
                  The character Ruff uses at the end of a line.
                  
                  * `lf`: Line endings will be converted to `\n`. The default line ending on Unix. * `cr-lf`: Line endings will be converted to `\r\n`. The default line ending on Windows. * `auto`: The newline style is detected automatically on a file per file basis. Files with mixed line endings will be converted to the first detected line ending. Defaults to `\n` for files that contain no line endings. * `native`: Line endings will be converted to `\n` on Unix and `\r\n` on Windows.
                  "%
                  | optional,
                preview
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether to enable the unstable preview style formatting.
                  "%
                  | optional,
                quote-style
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.QuoteStyle, predicates.isType 'Null ])
                  | doc m%"
                  Whether to prefer single `'` or double `"` quotes for strings. Defaults to double quotes.
                  
                  In compliance with [PEP 8](https://peps.python.org/pep-0008/) and [PEP 257](https://peps.python.org/pep-0257/), Ruff prefers double quotes for multiline strings and docstrings, regardless of the configured quote style.
                  
                  Ruff may also deviate from this option if using the configured quotes would require escaping quote characters within the string. For example, given:
                  
                  ```python a = "a string without any quotes" b = "It's monday morning" ```
                  
                  Ruff will change `a` to use single quotes when using `quote-style = "single"`. However, `a` will be unchanged, as converting to single quotes would require the inner `'` to be escaped, which leads to less readable code: `'It\'s monday morning'`.
                  "%
                  | optional,
                skip-magic-trailing-comma
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Ruff uses existing trailing commas as an indication that short lines should be left separate. If this option is set to `true`, the magic trailing comma is ignored.
                  
                  For example, Ruff leaves the arguments separate even though collapsing the arguments to a single line doesn't exceed the line width if `skip-magic-trailing-comma = false`:
                  
                  ```python # The arguments remain on separate lines because of the trailing comma after `b` def test( a, b, ): pass ```
                  
                  Setting `skip-magic-trailing-comma = true` changes the formatting to:
                  
                  ```python # The arguments remain on separate lines because of the trailing comma after `b` def test(a, b): pass ```
                  "%
                  | optional,
              },
          ImportSection = predicates.contract_from_predicate
              definitions.predicate.ImportSection,
          ImportType = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'local-folder,
                  'first-party,
                  'third-party,
                  'standard-library,
                  'future
                |]
              ],
          IndentStyle = predicates.contract_from_predicate
              definitions.predicate.IndentStyle,
          IsortOptions = {
                case-sensitive
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Sort imports taking into account case sensitivity.
                  "%
                  | optional,
                classes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An override list of tokens to always recognize as a Class for `order-by-type` regardless of casing.
                  "%
                  | optional,
                combine-as-imports
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Combines as imports on the same line. See isort's [`combine-as-imports`](https://pycqa.github.io/isort/docs/configuration/options.html#combine-as-imports) option.
                  "%
                  | optional,
                constants
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An override list of tokens to always recognize as a CONSTANT for `order-by-type` regardless of casing.
                  "%
                  | optional,
                detect-same-package
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether to automatically mark imports from within the same package as first-party. For example, when `detect-same-package = true`, then when analyzing files within the `foo` package, any imports from within the `foo` package will be considered first-party.
                  
                  This heuristic is often unnecessary when `src` is configured to detect all first-party sources; however, if `src` is _not_ configured, this heuristic can be useful to detect first-party imports from _within_ (but not _across_) first-party packages.
                  "%
                  | optional,
                extra-standard-library
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of modules to consider standard-library, in addition to those known to Ruff in advance.
                  
                  Supports glob patterns. For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
                  "%
                  | optional,
                force-single-line
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Forces all from imports to appear on their own line.
                  "%
                  | optional,
                force-sort-within-sections
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Don't sort straight-style imports (like `import sys`) before from-style imports (like `from itertools import groupby`). Instead, sort the imports by module, independent of import style.
                  "%
                  | optional,
                force-to-top
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Force specific imports to the top of their appropriate section.
                  "%
                  | optional,
                force-wrap-aliases
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Force `import from` statements with multiple members and at least one alias (e.g., `import A as B`) to wrap such that every line contains exactly one member. For example, this formatting would be retained, rather than condensing to a single line:
                  
                  ```python from .utils import ( test_directory as test_directory, test_id as test_id ) ```
                  
                  Note that this setting is only effective when combined with `combine-as-imports = true`. When `combine-as-imports` isn't enabled, every aliased `import from` will be given its own line, in which case, wrapping is not necessary.
                  "%
                  | optional,
                forced-separate
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of modules to separate into auxiliary block(s) of imports, in the order specified.
                  "%
                  | optional,
                known-first-party
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of modules to consider first-party, regardless of whether they can be identified as such via introspection of the local filesystem.
                  
                  Supports glob patterns. For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
                  "%
                  | optional,
                known-local-folder
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of modules to consider being a local folder. Generally, this is reserved for relative imports (`from . import module`).
                  
                  Supports glob patterns. For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
                  "%
                  | optional,
                known-third-party
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of modules to consider third-party, regardless of whether they can be identified as such via introspection of the local filesystem.
                  
                  Supports glob patterns. For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
                  "%
                  | optional,
                lines-after-imports
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType 'Null ])
                  | doc m%"
                  The number of blank lines to place after imports. Use `-1` for automatic determination.
                  "%
                  | optional,
                lines-between-types
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The number of lines to place between "direct" and `import from` imports.
                  "%
                  | optional,
                no-lines-before
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    definitions.predicate.ImportSection
                  ])
                  | doc m%"
                  A list of sections that should _not_ be delineated from the previous section via empty lines.
                  "%
                  | optional,
                order-by-type
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Order imports by type, which is determined by case, in addition to alphabetically.
                  "%
                  | optional,
                relative-imports-order
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.RelativeImportsOrder,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Whether to place "closer" imports (fewer `.` characters, most local) before "further" imports (more `.` characters, least local), or vice versa.
                  
                  The default ("furthest-to-closest") is equivalent to isort's `reverse-relative` default (`reverse-relative = false`); setting this to "closest-to-furthest" is equivalent to isort's `reverse-relative = true`.
                  "%
                  | optional,
                required-imports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Add the specified import line to all files.
                  "%
                  | optional,
                section-order
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    definitions.predicate.ImportSection
                  ])
                  | doc m%"
                  Override in which order the sections should be output. Can be used to move custom sections.
                  "%
                  | optional,
                sections
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
                    predicates.records.record {  } {  } true
                    (predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ])
                  ])
                  | doc m%"
                  A list of mappings from section names to modules. By default custom sections are output last, but this can be overridden with `section-order`.
                  "%
                  | optional,
                single-line-exclusions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  One or more modules to exclude from the single line rule.
                  "%
                  | optional,
                split-on-trailing-comma
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  If a comma is placed after the last member in a multi-line import, then the imports will never be folded into one line.
                  
                  See isort's [`split-on-trailing-comma`](https://pycqa.github.io/isort/docs/configuration/options.html#split-on-trailing-comma) option.
                  "%
                  | optional,
                variables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An override list of tokens to always recognize as a var for `order-by-type` regardless of casing.
                  "%
                  | optional,
              },
          LineEnding = predicates.contract_from_predicate
              definitions.predicate.LineEnding,
          LineLength
            | doc m%"
            The length of a line of text that is considered too long.
            
            The allowed range of values is 1..=320
            "%
            = predicates.contract_from_predicate
              definitions.predicate.LineLength,
          LintOptions
            | doc m%"
            Experimental section to configure Ruff's linting. This new section will eventually replace the top-level linting options.
            
            Options specified in the `lint` section take precedence over the top-level settings.
            "%
            = {
                allowed-confusables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.maxLength 1,
                      predicates.strings.minLength 1
                    ])
                  ])
                  | doc m%"
                  A list of allowed "confusable" Unicode characters to ignore when enforcing `RUF001`, `RUF002`, and `RUF003`.
                  "%
                  | optional,
                dummy-variable-rgx
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A regular expression used to identify "dummy" variables, or those which should be ignored when enforcing (e.g.) unused-variable rules. The default expression matches `_`, `__`, and `_var`, but not `_var_`.
                  "%
                  | optional,
                explicit-preview-rules
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether to require exact codes to select preview rules. When enabled, preview rules will not be selected by prefixes — the full code of each preview rule will be required to enable the rule.
                  "%
                  | optional,
                extend-fixable
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.RuleSelector
                  ])
                  | doc m%"
                  A list of rule codes or prefixes to consider fixable, in addition to those specified by `fixable`.
                  "%
                  | optional,
                extend-per-file-ignores
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
                    predicates.records.record {  } {  } true
                    (predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.RuleSelector
                    ])
                  ])
                  | doc m%"
                  A list of mappings from file pattern to rule codes or prefixes to exclude, in addition to any rules excluded by `per-file-ignores`.
                  "%
                  | optional,
                extend-safe-fixes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.RuleSelector
                  ])
                  | doc m%"
                  A list of rule codes or prefixes for which unsafe fixes should be considered safe.
                  "%
                  | optional,
                extend-select
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.RuleSelector
                  ])
                  | doc m%"
                  A list of rule codes or prefixes to enable, in addition to those specified by `select`.
                  "%
                  | optional,
                extend-unsafe-fixes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.RuleSelector
                  ])
                  | doc m%"
                  A list of rule codes or prefixes for which safe fixes should be considered unsafe.
                  "%
                  | optional,
                external
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of rule codes that are unsupported by Ruff, but should be preserved when (e.g.) validating `# noqa` directives. Useful for retaining `# noqa` directives that cover plugins not yet implemented by Ruff.
                  "%
                  | optional,
                fixable
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.RuleSelector
                  ])
                  | doc m%"
                  A list of rule codes or prefixes to consider fixable. By default, all rules are considered fixable.
                  "%
                  | optional,
                flake8-annotations
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8AnnotationsOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-annotations` plugin.
                  "%
                  | optional,
                flake8-bandit
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8BanditOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-bandit` plugin.
                  "%
                  | optional,
                flake8-bugbear
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8BugbearOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-bugbear` plugin.
                  "%
                  | optional,
                flake8-builtins
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8BuiltinsOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-builtins` plugin.
                  "%
                  | optional,
                flake8-comprehensions
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8ComprehensionsOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-comprehensions` plugin.
                  "%
                  | optional,
                flake8-copyright
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8CopyrightOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-copyright` plugin.
                  "%
                  | optional,
                flake8-errmsg
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8ErrMsgOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-errmsg` plugin.
                  "%
                  | optional,
                flake8-gettext
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8GetTextOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-gettext` plugin.
                  "%
                  | optional,
                flake8-implicit-str-concat
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8ImplicitStrConcatOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-implicit-str-concat` plugin.
                  "%
                  | optional,
                flake8-import-conventions
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8ImportConventionsOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-import-conventions` plugin.
                  "%
                  | optional,
                flake8-pytest-style
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8PytestStyleOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-pytest-style` plugin.
                  "%
                  | optional,
                flake8-quotes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8QuotesOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-quotes` plugin.
                  "%
                  | optional,
                flake8-self
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8SelfOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8_self` plugin.
                  "%
                  | optional,
                flake8-tidy-imports
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8TidyImportsOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-tidy-imports` plugin.
                  "%
                  | optional,
                flake8-type-checking
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8TypeCheckingOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-type-checking` plugin.
                  "%
                  | optional,
                flake8-unused-arguments
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Flake8UnusedArgumentsOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `flake8-unused-arguments` plugin.
                  "%
                  | optional,
                ignore
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.RuleSelector
                  ])
                  | doc m%"
                  A list of rule codes or prefixes to ignore. Prefixes can specify exact rules (like `F841`), entire categories (like `F`), or anything in between.
                  
                  When breaking ties between enabled and disabled rules (via `select` and `ignore`, respectively), more specific prefixes override less specific prefixes.
                  "%
                  | optional,
                ignore-init-module-imports
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Avoid automatically removing unused imports in `__init__.py` files. Such imports will still be flagged, but with a dedicated message suggesting that the import is either added to the module's `__all__` symbol, or re-exported with a redundant alias (e.g., `import os as os`).
                  "%
                  | optional,
                isort
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.IsortOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `isort` plugin.
                  "%
                  | optional,
                logger-objects
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of objects that should be treated equivalently to a `logging.Logger` object.
                  
                  This is useful for ensuring proper diagnostics (e.g., to identify `logging` deprecations and other best-practices) for projects that re-export a `logging.Logger` object from a common module.
                  
                  For example, if you have a module `logging_setup.py` with the following contents: ```python import logging
                  
                  logger = logging.getLogger(__name__) ```
                  
                  Adding `"logging_setup.logger"` to `logger-objects` will ensure that `logging_setup.logger` is treated as a `logging.Logger` object when imported from other modules (e.g., `from logging_setup import logger`).
                  "%
                  | optional,
                mccabe
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.McCabeOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `mccabe` plugin.
                  "%
                  | optional,
                pep8-naming
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Pep8NamingOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `pep8-naming` plugin.
                  "%
                  | optional,
                per-file-ignores
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
                    predicates.records.record {  } {  } true
                    (predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.RuleSelector
                    ])
                  ])
                  | doc m%"
                  A list of mappings from file pattern to rule codes or prefixes to exclude, when considering any matching files.
                  "%
                  | optional,
                pycodestyle
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.PycodestyleOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `pycodestyle` plugin.
                  "%
                  | optional,
                pydocstyle
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.PydocstyleOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `pydocstyle` plugin.
                  "%
                  | optional,
                pyflakes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.PyflakesOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `pyflakes` plugin.
                  "%
                  | optional,
                pylint
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.PylintOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `pylint` plugin.
                  "%
                  | optional,
                pyupgrade
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.PyUpgradeOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the `pyupgrade` plugin.
                  "%
                  | optional,
                select
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.RuleSelector
                  ])
                  | doc m%"
                  A list of rule codes or prefixes to enable. Prefixes can specify exact rules (like `F841`), entire categories (like `F`), or anything in between.
                  
                  When breaking ties between enabled and disabled rules (via `select` and `ignore`, respectively), more specific prefixes override less specific prefixes.
                  "%
                  | optional,
                task-tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of task tags to recognize (e.g., "TODO", "FIXME", "XXX").
                  
                  Comments starting with these tags will be ignored by commented-out code detection (`ERA`), and skipped by line-length rules (`E501`) if `ignore-overlong-task-comments` is set to `true`.
                  "%
                  | optional,
                typing-modules
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of modules whose exports should be treated equivalently to members of the `typing` module.
                  
                  This is useful for ensuring proper type annotation inference for projects that re-export `typing` and `typing_extensions` members from a compatibility module. If omitted, any members imported from modules apart from `typing` and `typing_extensions` will be treated as ordinary Python objects.
                  "%
                  | optional,
                unfixable
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.RuleSelector
                  ])
                  | doc m%"
                  A list of rule codes or prefixes to consider non-fixable.
                  "%
                  | optional,
              },
          McCabeOptions = {
                max-complexity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The maximum McCabe complexity to allow before triggering `C901` errors.
                  "%
                  | optional,
              },
          ParametrizeNameType = std.contract.Sequence
              [ std.enum.TagOrString, [| 'list, 'tuple, 'csv |] ],
          ParametrizeValuesRowType = std.contract.Sequence
              [ std.enum.TagOrString, [| 'list, 'tuple |] ],
          ParametrizeValuesType = std.contract.Sequence
              [ std.enum.TagOrString, [| 'list, 'tuple |] ],
          Pep8NamingOptions = {
                classmethod-decorators
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of decorators that, when applied to a method, indicate that the method should be treated as a class method (in addition to the builtin `@classmethod`).
                  
                  For example, Ruff will expect that any method decorated by a decorator in this list takes a `cls` argument as its first argument.
                  
                  Expects to receive a list of fully-qualified names (e.g., `pydantic.validator`, rather than `validator`).
                  "%
                  | optional,
                extend-ignore-names
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Additional names (or patterns) to ignore when considering `pep8-naming` violations, in addition to those included in `ignore-names`
                  
                  Supports glob patterns. For example, to ignore all names starting with or ending with `_test`, you could use `ignore-names = ["test_*", "*_test"]`. For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
                  "%
                  | optional,
                ignore-names
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of names (or patterns) to ignore when considering `pep8-naming` violations.
                  
                  Supports glob patterns. For example, to ignore all names starting with or ending with `_test`, you could use `ignore-names = ["test_*", "*_test"]`. For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
                  "%
                  | optional,
                staticmethod-decorators
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of decorators that, when applied to a method, indicate that the method should be treated as a static method (in addition to the builtin `@staticmethod`).
                  
                  For example, Ruff will expect that any method decorated by a decorator in this list has no `self` or `cls` argument.
                  
                  Expects to receive a list of fully-qualified names (e.g., `belay.Device.teardown`, rather than `teardown`).
                  "%
                  | optional,
              },
          PyUpgradeOptions = {
                keep-runtime-typing
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether to avoid PEP 585 (`List[int]` -> `list[int]`) and PEP 604 (`Union[str, int]` -> `str | int`) rewrites even if a file imports `from __future__ import annotations`.
                  
                  This setting is only applicable when the target Python version is below 3.9 and 3.10 respectively, and is most commonly used when working with libraries like Pydantic and FastAPI, which rely on the ability to parse type annotations at runtime. The use of `from __future__ import annotations` causes Python to treat the type annotations as strings, which typically allows for the use of language features that appear in later Python versions but are not yet supported by the current version (e.g., `str | int`). However, libraries that rely on runtime type annotations will break if the annotations are incompatible with the current Python version.
                  
                  For example, while the following is valid Python 3.8 code due to the presence of `from __future__ import annotations`, the use of `str| int` prior to Python 3.10 will cause Pydantic to raise a `TypeError` at runtime:
                  
                  ```python from __future__ import annotations
                  
                  import pydantic
                  
                  class Foo(pydantic.BaseModel): bar: str | int ```
                  "%
                  | optional,
              },
          PycodestyleOptions = {
                ignore-overlong-task-comments
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether line-length violations (`E501`) should be triggered for comments starting with `task-tags` (by default: \["TODO", "FIXME", and "XXX"\]).
                  "%
                  | optional,
                max-doc-length
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.LineLength, predicates.isType 'Null ])
                  | doc m%"
                  The maximum line length to allow for line-length violations within documentation (`W505`), including standalone comments. By default, this is set to null which disables reporting violations.
                  
                  See the [`doc-line-too-long`](https://docs.astral.sh/ruff/rules/doc-line-too-long/) rule for more information.
                  "%
                  | optional,
              },
          PydocstyleOptions = {
                convention
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Convention, predicates.isType 'Null ])
                  | doc m%"
                  Whether to use Google-style or NumPy-style conventions or the PEP257 defaults when analyzing docstring sections.
                  
                  Enabling a convention will force-disable any rules that are not included in the specified convention. As such, the intended use is to enable a convention and then selectively disable any additional rules on top of it.
                  
                  For example, to use Google-style conventions but avoid requiring documentation for every function parameter:
                  
                  ```toml [tool.ruff] # Enable all `pydocstyle` rules, limiting to those that adhere to the # Google convention via `convention = "google"`, below. select = ["D"]
                  
                  # On top of the Google convention, disable `D417`, which requires # documentation for every function parameter. ignore = ["D417"]
                  
                  [tool.ruff.pydocstyle] convention = "google" ```
                  
                  As conventions force-disable all rules not included in the convention, enabling _additional_ rules on top of a convention is currently unsupported.
                  "%
                  | optional,
                ignore-decorators
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Ignore docstrings for functions or methods decorated with the specified fully-qualified decorators.
                  "%
                  | optional,
                property-decorators
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of decorators that, when applied to a method, indicate that the method should be treated as a property (in addition to the builtin `@property` and standard-library `@functools.cached_property`).
                  
                  For example, Ruff will expect that any method decorated by a decorator in this list can use a non-imperative summary line.
                  "%
                  | optional,
              },
          PyflakesOptions = {
                extend-generics
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Additional functions or classes to consider generic, such that any subscripts should be treated as type annotation (e.g., `ForeignKey` in `django.db.models.ForeignKey["User"]`.
                  
                  Expects to receive a list of fully-qualified names (e.g., `django.db.models.ForeignKey`, rather than `ForeignKey`).
                  "%
                  | optional,
              },
          PylintOptions = {
                allow-magic-value-types
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.ConstantType
                  ])
                  | doc m%"
                  Constant types to ignore when used as "magic values" (see: `PLR2004`).
                  "%
                  | optional,
                max-args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Maximum number of arguments allowed for a function or method definition (see: `PLR0913`).
                  "%
                  | optional,
                max-branches
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Maximum number of branches allowed for a function or method body (see: `PLR0912`).
                  "%
                  | optional,
                max-public-methods
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Maximum number of public methods allowed for a class (see: `PLR0904`).
                  "%
                  | optional,
                max-returns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Maximum number of return statements allowed for a function or method body (see `PLR0911`)
                  "%
                  | optional,
                max-statements
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Maximum number of statements allowed for a function or method body (see: `PLR0915`).
                  "%
                  | optional,
              },
          PythonVersion = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'py312, 'py311, 'py310, 'py39, 'py38, 'py37 |]
              ],
          Quote = predicates.contract_from_predicate
              definitions.predicate.Quote,
          QuoteStyle = std.contract.Sequence
              [ std.enum.TagOrString, [| 'double, 'single |] ],
          RelativeImportsOrder = predicates.contract_from_predicate
              definitions.predicate.RelativeImportsOrder,
          RuleSelector = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'YTT303,
                  'YTT302,
                  'YTT301,
                  'YTT30,
                  'YTT3,
                  'YTT204,
                  'YTT203,
                  'YTT202,
                  'YTT201,
                  'YTT20,
                  'YTT2,
                  'YTT103,
                  'YTT102,
                  'YTT101,
                  'YTT10,
                  'YTT1,
                  'YTT,
                  'W605,
                  'W60,
                  'W6,
                  'W505,
                  'W50,
                  'W5,
                  'W293,
                  'W292,
                  'W291,
                  'W29,
                  'W2,
                  'W191,
                  'W19,
                  'W1,
                  'W,
                  'UP040,
                  'UP04,
                  'UP039,
                  'UP038,
                  'UP037,
                  'UP036,
                  'UP035,
                  'UP034,
                  'UP033,
                  'UP032,
                  'UP031,
                  'UP030,
                  'UP03,
                  'UP029,
                  'UP028,
                  'UP027,
                  'UP026,
                  'UP025,
                  'UP024,
                  'UP023,
                  'UP022,
                  'UP021,
                  'UP020,
                  'UP02,
                  'UP019,
                  'UP018,
                  'UP017,
                  'UP015,
                  'UP014,
                  'UP013,
                  'UP012,
                  'UP011,
                  'UP010,
                  'UP01,
                  'UP009,
                  'UP008,
                  'UP007,
                  'UP006,
                  'UP005,
                  'UP004,
                  'UP003,
                  'UP001,
                  'UP00,
                  'UP0,
                  'UP,
                  'TRY401,
                  'TRY400,
                  'TRY40,
                  'TRY4,
                  'TRY302,
                  'TRY301,
                  'TRY300,
                  'TRY30,
                  'TRY3,
                  'TRY201,
                  'TRY200,
                  'TRY20,
                  'TRY2,
                  'TRY004,
                  'TRY003,
                  'TRY002,
                  'TRY00,
                  'TRY0,
                  'TRY,
                  'TID253,
                  'TID252,
                  'TID251,
                  'TID25,
                  'TID2,
                  'TID,
                  'TD007,
                  'TD006,
                  'TD005,
                  'TD004,
                  'TD003,
                  'TD002,
                  'TD001,
                  'TD00,
                  'TD0,
                  'TD,
                  'TCH005,
                  'TCH004,
                  'TCH003,
                  'TCH002,
                  'TCH001,
                  'TCH00,
                  'TCH0,
                  'TCH,
                  'T203,
                  'T201,
                  'T20,
                  'T2,
                  'T100,
                  'T10,
                  'T1,
                  'T,
                  'SLOT002,
                  'SLOT001,
                  'SLOT000,
                  'SLOT00,
                  'SLOT0,
                  'SLOT,
                  'SLF001,
                  'SLF00,
                  'SLF0,
                  'SLF,
                  'SIM910,
                  'SIM91,
                  'SIM9,
                  'SIM401,
                  'SIM40,
                  'SIM4,
                  'SIM300,
                  'SIM30,
                  'SIM3,
                  'SIM223,
                  'SIM222,
                  'SIM221,
                  'SIM220,
                  'SIM22,
                  'SIM212,
                  'SIM211,
                  'SIM210,
                  'SIM21,
                  'SIM208,
                  'SIM202,
                  'SIM201,
                  'SIM20,
                  'SIM2,
                  'SIM118,
                  'SIM117,
                  'SIM116,
                  'SIM115,
                  'SIM114,
                  'SIM112,
                  'SIM110,
                  'SIM11,
                  'SIM109,
                  'SIM108,
                  'SIM107,
                  'SIM105,
                  'SIM103,
                  'SIM102,
                  'SIM101,
                  'SIM10,
                  'SIM1,
                  'SIM,
                  'S701,
                  'S70,
                  'S7,
                  'S612,
                  'S61,
                  'S609,
                  'S608,
                  'S607,
                  'S606,
                  'S605,
                  'S604,
                  'S603,
                  'S602,
                  'S601,
                  'S60,
                  'S6,
                  'S509,
                  'S508,
                  'S507,
                  'S506,
                  'S505,
                  'S501,
                  'S50,
                  'S5,
                  'S324,
                  'S323,
                  'S321,
                  'S320,
                  'S32,
                  'S319,
                  'S318,
                  'S317,
                  'S316,
                  'S315,
                  'S314,
                  'S313,
                  'S312,
                  'S311,
                  'S310,
                  'S31,
                  'S308,
                  'S307,
                  'S306,
                  'S305,
                  'S304,
                  'S303,
                  'S302,
                  'S301,
                  'S30,
                  'S3,
                  'S201,
                  'S20,
                  'S2,
                  'S113,
                  'S112,
                  'S110,
                  'S11,
                  'S108,
                  'S107,
                  'S106,
                  'S105,
                  'S104,
                  'S103,
                  'S102,
                  'S101,
                  'S10,
                  'S1,
                  'S,
                  'RUF200,
                  'RUF20,
                  'RUF2,
                  'RUF100,
                  'RUF10,
                  'RUF1,
                  'RUF019,
                  'RUF018,
                  'RUF017,
                  'RUF016,
                  'RUF015,
                  'RUF013,
                  'RUF012,
                  'RUF011,
                  'RUF010,
                  'RUF01,
                  'RUF009,
                  'RUF008,
                  'RUF007,
                  'RUF006,
                  'RUF005,
                  'RUF003,
                  'RUF002,
                  'RUF001,
                  'RUF00,
                  'RUF0,
                  'RUF,
                  'RSE102,
                  'RSE10,
                  'RSE1,
                  'RSE,
                  'RET508,
                  'RET507,
                  'RET506,
                  'RET505,
                  'RET504,
                  'RET503,
                  'RET502,
                  'RET501,
                  'RET50,
                  'RET5,
                  'RET,
                  'Q003,
                  'Q002,
                  'Q001,
                  'Q000,
                  'Q00,
                  'Q0,
                  'Q,
                  'PYI056,
                  'PYI055,
                  'PYI054,
                  'PYI053,
                  'PYI052,
                  'PYI051,
                  'PYI050,
                  'PYI05,
                  'PYI049,
                  'PYI048,
                  'PYI047,
                  'PYI046,
                  'PYI045,
                  'PYI044,
                  'PYI043,
                  'PYI042,
                  'PYI041,
                  'PYI04,
                  'PYI036,
                  'PYI035,
                  'PYI034,
                  'PYI033,
                  'PYI032,
                  'PYI030,
                  'PYI03,
                  'PYI029,
                  'PYI026,
                  'PYI025,
                  'PYI024,
                  'PYI021,
                  'PYI020,
                  'PYI02,
                  'PYI019,
                  'PYI018,
                  'PYI017,
                  'PYI016,
                  'PYI015,
                  'PYI014,
                  'PYI013,
                  'PYI012,
                  'PYI011,
                  'PYI010,
                  'PYI01,
                  'PYI009,
                  'PYI008,
                  'PYI007,
                  'PYI006,
                  'PYI005,
                  'PYI004,
                  'PYI003,
                  'PYI002,
                  'PYI001,
                  'PYI00,
                  'PYI0,
                  'PYI,
                  'PTH207,
                  'PTH206,
                  'PTH205,
                  'PTH204,
                  'PTH203,
                  'PTH202,
                  'PTH201,
                  'PTH20,
                  'PTH2,
                  'PTH124,
                  'PTH123,
                  'PTH122,
                  'PTH121,
                  'PTH120,
                  'PTH12,
                  'PTH119,
                  'PTH118,
                  'PTH117,
                  'PTH116,
                  'PTH115,
                  'PTH114,
                  'PTH113,
                  'PTH112,
                  'PTH111,
                  'PTH110,
                  'PTH11,
                  'PTH109,
                  'PTH108,
                  'PTH107,
                  'PTH106,
                  'PTH105,
                  'PTH104,
                  'PTH103,
                  'PTH102,
                  'PTH101,
                  'PTH100,
                  'PTH10,
                  'PTH1,
                  'PTH,
                  'PT027,
                  'PT026,
                  'PT025,
                  'PT024,
                  'PT023,
                  'PT022,
                  'PT021,
                  'PT020,
                  'PT02,
                  'PT019,
                  'PT018,
                  'PT017,
                  'PT016,
                  'PT015,
                  'PT014,
                  'PT013,
                  'PT012,
                  'PT011,
                  'PT010,
                  'PT01,
                  'PT009,
                  'PT008,
                  'PT007,
                  'PT006,
                  'PT005,
                  'PT004,
                  'PT003,
                  'PT002,
                  'PT001,
                  'PT00,
                  'PT0,
                  'PT,
                  'PLW3301,
                  'PLW330,
                  'PLW33,
                  'PLW3201,
                  'PLW320,
                  'PLW32,
                  'PLW3,
                  'PLW2901,
                  'PLW290,
                  'PLW29,
                  'PLW2,
                  'PLW1641,
                  'PLW164,
                  'PLW16,
                  'PLW1510,
                  'PLW151,
                  'PLW1509,
                  'PLW1508,
                  'PLW150,
                  'PLW15,
                  'PLW1,
                  'PLW0711,
                  'PLW071,
                  'PLW07,
                  'PLW0603,
                  'PLW0602,
                  'PLW060,
                  'PLW06,
                  'PLW0406,
                  'PLW040,
                  'PLW04,
                  'PLW0131,
                  'PLW013,
                  'PLW0129,
                  'PLW0127,
                  'PLW0120,
                  'PLW012,
                  'PLW01,
                  'PLW0,
                  'PLW,
                  'PLR6301,
                  'PLR630,
                  'PLR63,
                  'PLR6,
                  'PLR5501,
                  'PLR550,
                  'PLR55,
                  'PLR5,
                  'PLR2004,
                  'PLR200,
                  'PLR20,
                  'PLR2,
                  'PLR1722,
                  'PLR172,
                  'PLR1714,
                  'PLR1711,
                  'PLR171,
                  'PLR1706,
                  'PLR1701,
                  'PLR170,
                  'PLR17,
                  'PLR1,
                  'PLR0915,
                  'PLR0913,
                  'PLR0912,
                  'PLR0911,
                  'PLR091,
                  'PLR0904,
                  'PLR090,
                  'PLR09,
                  'PLR0402,
                  'PLR040,
                  'PLR04,
                  'PLR0206,
                  'PLR020,
                  'PLR02,
                  'PLR0133,
                  'PLR013,
                  'PLR0124,
                  'PLR012,
                  'PLR01,
                  'PLR0,
                  'PLR,
                  'PLE2515,
                  'PLE2514,
                  'PLE2513,
                  'PLE2512,
                  'PLE2510,
                  'PLE251,
                  'PLE2502,
                  'PLE250,
                  'PLE25,
                  'PLE2,
                  'PLE1700,
                  'PLE170,
                  'PLE17,
                  'PLE1507,
                  'PLE150,
                  'PLE15,
                  'PLE1310,
                  'PLE131,
                  'PLE1307,
                  'PLE1300,
                  'PLE130,
                  'PLE13,
                  'PLE1206,
                  'PLE1205,
                  'PLE120,
                  'PLE12,
                  'PLE1142,
                  'PLE114,
                  'PLE11,
                  'PLE1,
                  'PLE0605,
                  'PLE0604,
                  'PLE060,
                  'PLE06,
                  'PLE0307,
                  'PLE0302,
                  'PLE030,
                  'PLE03,
                  'PLE0241,
                  'PLE024,
                  'PLE02,
                  'PLE0118,
                  'PLE0117,
                  'PLE0116,
                  'PLE011,
                  'PLE0101,
                  'PLE0100,
                  'PLE010,
                  'PLE01,
                  'PLE0,
                  'PLE,
                  'PLC3002,
                  'PLC300,
                  'PLC30,
                  'PLC3,
                  'PLC1901,
                  'PLC190,
                  'PLC19,
                  'PLC1,
                  'PLC0414,
                  'PLC041,
                  'PLC04,
                  'PLC0208,
                  'PLC0205,
                  'PLC020,
                  'PLC02,
                  'PLC0132,
                  'PLC0131,
                  'PLC013,
                  'PLC0105,
                  'PLC010,
                  'PLC01,
                  'PLC0,
                  'PLC,
                  'PL,
                  'PIE810,
                  'PIE81,
                  'PIE808,
                  'PIE807,
                  'PIE804,
                  'PIE800,
                  'PIE80,
                  'PIE8,
                  'PIE796,
                  'PIE794,
                  'PIE790,
                  'PIE79,
                  'PIE7,
                  'PIE,
                  'PGH005,
                  'PGH004,
                  'PGH003,
                  'PGH002,
                  'PGH001,
                  'PGH00,
                  'PGH0,
                  'PGH,
                  'PERF403,
                  'PERF402,
                  'PERF401,
                  'PERF40,
                  'PERF4,
                  'PERF203,
                  'PERF20,
                  'PERF2,
                  'PERF102,
                  'PERF101,
                  'PERF10,
                  'PERF1,
                  'PERF,
                  'PD901,
                  'PD90,
                  'PD9,
                  'PD101,
                  'PD10,
                  'PD1,
                  'PD015,
                  'PD013,
                  'PD012,
                  'PD011,
                  'PD010,
                  'PD01,
                  'PD009,
                  'PD008,
                  'PD007,
                  'PD004,
                  'PD003,
                  'PD002,
                  'PD00,
                  'PD0,
                  'PD,
                  'NURSERY,
                  'NPY003,
                  'NPY002,
                  'NPY001,
                  'NPY00,
                  'NPY0,
                  'NPY,
                  'N999,
                  'N99,
                  'N9,
                  'N818,
                  'N817,
                  'N816,
                  'N815,
                  'N814,
                  'N813,
                  'N812,
                  'N811,
                  'N81,
                  'N807,
                  'N806,
                  'N805,
                  'N804,
                  'N803,
                  'N802,
                  'N801,
                  'N80,
                  'N8,
                  'N,
                  'LOG009,
                  'LOG007,
                  'LOG002,
                  'LOG001,
                  'LOG00,
                  'LOG0,
                  'LOG,
                  'ISC003,
                  'ISC002,
                  'ISC001,
                  'ISC00,
                  'ISC0,
                  'ISC,
                  'INT003,
                  'INT002,
                  'INT001,
                  'INT00,
                  'INT0,
                  'INT,
                  'INP001,
                  'INP00,
                  'INP0,
                  'INP,
                  'ICN003,
                  'ICN002,
                  'ICN001,
                  'ICN00,
                  'ICN0,
                  'ICN,
                  'I002,
                  'I001,
                  'I00,
                  'I0,
                  'I,
                  'G202,
                  'G201,
                  'G20,
                  'G2,
                  'G101,
                  'G10,
                  'G1,
                  'G010,
                  'G01,
                  'G004,
                  'G003,
                  'G002,
                  'G001,
                  'G00,
                  'G0,
                  'G,
                  'FURB177,
                  'FURB171,
                  'FURB17,
                  'FURB148,
                  'FURB145,
                  'FURB140,
                  'FURB14,
                  'FURB132,
                  'FURB131,
                  'FURB13,
                  'FURB113,
                  'FURB11,
                  'FURB105,
                  'FURB10,
                  'FURB1,
                  'FURB,
                  'FLY002,
                  'FLY00,
                  'FLY0,
                  'FLY,
                  'FIX004,
                  'FIX003,
                  'FIX002,
                  'FIX001,
                  'FIX00,
                  'FIX0,
                  'FIX,
                  'FBT003,
                  'FBT002,
                  'FBT001,
                  'FBT00,
                  'FBT0,
                  'FBT,
                  'FA102,
                  'FA100,
                  'FA10,
                  'FA1,
                  'FA,
                  'F901,
                  'F90,
                  'F9,
                  'F842,
                  'F841,
                  'F84,
                  'F823,
                  'F822,
                  'F821,
                  'F82,
                  'F811,
                  'F81,
                  'F8,
                  'F722,
                  'F72,
                  'F707,
                  'F706,
                  'F704,
                  'F702,
                  'F701,
                  'F70,
                  'F7,
                  'F634,
                  'F633,
                  'F632,
                  'F631,
                  'F63,
                  'F622,
                  'F621,
                  'F62,
                  'F602,
                  'F601,
                  'F60,
                  'F6,
                  'F541,
                  'F54,
                  'F525,
                  'F524,
                  'F523,
                  'F522,
                  'F521,
                  'F52,
                  'F509,
                  'F508,
                  'F507,
                  'F506,
                  'F505,
                  'F504,
                  'F503,
                  'F502,
                  'F501,
                  'F50,
                  'F5,
                  'F407,
                  'F406,
                  'F405,
                  'F404,
                  'F403,
                  'F402,
                  'F401,
                  'F40,
                  'F4,
                  'F,
                  'EXE005,
                  'EXE004,
                  'EXE003,
                  'EXE002,
                  'EXE001,
                  'EXE00,
                  'EXE0,
                  'EXE,
                  'ERA001,
                  'ERA00,
                  'ERA0,
                  'ERA,
                  'EM103,
                  'EM102,
                  'EM101,
                  'EM10,
                  'EM1,
                  'EM,
                  'E999,
                  'E99,
                  'E902,
                  'E90,
                  'E9,
                  'E743,
                  'E742,
                  'E741,
                  'E74,
                  'E731,
                  'E73,
                  'E722,
                  'E721,
                  'E72,
                  'E714,
                  'E713,
                  'E712,
                  'E711,
                  'E71,
                  'E703,
                  'E702,
                  'E701,
                  'E70,
                  'E7,
                  'E501,
                  'E50,
                  'E5,
                  'E402,
                  'E401,
                  'E40,
                  'E4,
                  'E275,
                  'E274,
                  'E273,
                  'E272,
                  'E271,
                  'E27,
                  'E266,
                  'E265,
                  'E262,
                  'E261,
                  'E26,
                  'E252,
                  'E251,
                  'E25,
                  'E242,
                  'E241,
                  'E24,
                  'E231,
                  'E23,
                  'E228,
                  'E227,
                  'E226,
                  'E225,
                  'E224,
                  'E223,
                  'E222,
                  'E221,
                  'E22,
                  'E211,
                  'E21,
                  'E203,
                  'E202,
                  'E201,
                  'E20,
                  'E2,
                  'E117,
                  'E116,
                  'E115,
                  'E114,
                  'E113,
                  'E112,
                  'E111,
                  'E11,
                  'E101,
                  'E10,
                  'E1,
                  'E,
                  'DTZ012,
                  'DTZ011,
                  'DTZ01,
                  'DTZ007,
                  'DTZ006,
                  'DTZ005,
                  'DTZ004,
                  'DTZ003,
                  'DTZ002,
                  'DTZ001,
                  'DTZ00,
                  'DTZ0,
                  'DTZ,
                  'DJ013,
                  'DJ012,
                  'DJ01,
                  'DJ008,
                  'DJ007,
                  'DJ006,
                  'DJ003,
                  'DJ001,
                  'DJ00,
                  'DJ0,
                  'DJ,
                  'D419,
                  'D418,
                  'D417,
                  'D416,
                  'D415,
                  'D414,
                  'D413,
                  'D412,
                  'D411,
                  'D410,
                  'D41,
                  'D409,
                  'D408,
                  'D407,
                  'D406,
                  'D405,
                  'D404,
                  'D403,
                  'D402,
                  'D401,
                  'D400,
                  'D40,
                  'D4,
                  'D301,
                  'D300,
                  'D30,
                  'D3,
                  'D215,
                  'D214,
                  'D213,
                  'D212,
                  'D211,
                  'D210,
                  'D21,
                  'D209,
                  'D208,
                  'D207,
                  'D206,
                  'D205,
                  'D204,
                  'D203,
                  'D202,
                  'D201,
                  'D200,
                  'D20,
                  'D2,
                  'D107,
                  'D106,
                  'D105,
                  'D104,
                  'D103,
                  'D102,
                  'D101,
                  'D100,
                  'D10,
                  'D1,
                  'D,
                  'CPY001,
                  'CPY00,
                  'CPY0,
                  'CPY,
                  'COM819,
                  'COM818,
                  'COM812,
                  'COM81,
                  'COM8,
                  'COM,
                  'C901,
                  'C90,
                  'C9,
                  'C419,
                  'C418,
                  'C417,
                  'C416,
                  'C415,
                  'C414,
                  'C413,
                  'C411,
                  'C410,
                  'C41,
                  'C409,
                  'C408,
                  'C406,
                  'C405,
                  'C404,
                  'C403,
                  'C402,
                  'C401,
                  'C400,
                  'C40,
                  'C4,
                  'C,
                  'BLE001,
                  'BLE00,
                  'BLE0,
                  'BLE,
                  'B905,
                  'B904,
                  'B90,
                  'B9,
                  'B034,
                  'B033,
                  'B032,
                  'B031,
                  'B030,
                  'B03,
                  'B029,
                  'B028,
                  'B027,
                  'B026,
                  'B025,
                  'B024,
                  'B023,
                  'B022,
                  'B021,
                  'B020,
                  'B02,
                  'B019,
                  'B018,
                  'B017,
                  'B016,
                  'B015,
                  'B014,
                  'B013,
                  'B012,
                  'B011,
                  'B010,
                  'B01,
                  'B009,
                  'B008,
                  'B007,
                  'B006,
                  'B005,
                  'B004,
                  'B003,
                  'B002,
                  'B00,
                  'B0,
                  'B,
                  'ASYNC102,
                  'ASYNC101,
                  'ASYNC100,
                  'ASYNC10,
                  'ASYNC1,
                  'ASYNC,
                  'ARG005,
                  'ARG004,
                  'ARG003,
                  'ARG002,
                  'ARG001,
                  'ARG00,
                  'ARG0,
                  'ARG,
                  'ANN401,
                  'ANN40,
                  'ANN4,
                  'ANN206,
                  'ANN205,
                  'ANN204,
                  'ANN202,
                  'ANN201,
                  'ANN20,
                  'ANN2,
                  'ANN102,
                  'ANN101,
                  'ANN10,
                  'ANN1,
                  'ANN003,
                  'ANN002,
                  'ANN001,
                  'ANN00,
                  'ANN0,
                  'ANN,
                  'ALL,
                  'AIR001,
                  'AIR00,
                  'AIR0,
                  'AIR,
                  'A003,
                  'A002,
                  'A001,
                  'A00,
                  'A0,
                  'A
                |]
              ],
          SerializationFormat = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'azure,
                  'pylint,
                  'gitlab,
                  'github,
                  'grouped,
                  'junit,
                  'json-lines,
                  'json,
                  'text
                |]
              ],
          Strictness = predicates.contract_from_predicate
              definitions.predicate.Strictness,
          TabSize
            | doc m%"
            The size of a tab.
            "%
            = predicates.contract_from_predicate definitions.predicate.TabSize,
          Version = String,
        },
    predicate = {
          ApiBan = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "msg" ],
                predicates.records.record { msg = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          ConstantType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "bytes", "complex", "float", "int", "str", "tuple" ]
              ],
          Convention = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "google" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "numpy" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "pep257" ] ]
              ],
          Flake8AnnotationsOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allow-star-arg-any = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  ignore-fully-untyped = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  mypy-init-return = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  suppress-dummy-args = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  suppress-none-returning = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8BanditOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  check-typed-exception = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  hardcoded-tmp-directory = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  hardcoded-tmp-directory-extend = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8BugbearOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  extend-immutable-calls = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8BuiltinsOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  builtins-ignorelist = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8ComprehensionsOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allow-dict-calls-with-keyword-arguments = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8CopyrightOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  author = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  min-file-size = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                        predicates.numbers.minimum 0
                      ],
                  notice-rgx = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8ErrMsgOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  max-string-length = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8GetTextOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  extend-function-names = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  function-names = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8ImplicitStrConcatOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allow-multiline = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8ImportConventionsOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  aliases = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Record, predicates.isType 'Null ],
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  banned-aliases = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Record, predicates.isType 'Null ],
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ])
                      ],
                  banned-from = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  extend-aliases = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Record, predicates.isType 'Null ],
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8PytestStyleOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fixture-parentheses = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  mark-parentheses = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  parametrize-names-type = predicates.anyOf
                      [
                        definitions.predicate.ParametrizeNameType,
                        predicates.isType 'Null
                      ],
                  parametrize-values-row-type = predicates.anyOf
                      [
                        definitions.predicate.ParametrizeValuesRowType,
                        predicates.isType 'Null
                      ],
                  parametrize-values-type = predicates.anyOf
                      [
                        definitions.predicate.ParametrizeValuesType,
                        predicates.isType 'Null
                      ],
                  raises-extend-require-match-for = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  raises-require-match-for = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8QuotesOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  avoid-escape = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  docstring-quotes = predicates.anyOf
                      [ definitions.predicate.Quote, predicates.isType 'Null ],
                  inline-quotes = predicates.anyOf
                      [ definitions.predicate.Quote, predicates.isType 'Null ],
                  multiline-quotes = predicates.anyOf
                      [ definitions.predicate.Quote, predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8SelfOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  extend-ignore-names = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  ignore-names = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8TidyImportsOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ban-relative-imports = predicates.anyOf
                      [
                        definitions.predicate.Strictness,
                        predicates.isType 'Null
                      ],
                  banned-api = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Record, predicates.isType 'Null ],
                        predicates.records.record {  } {  } true
                        definitions.predicate.ApiBan
                      ],
                  banned-module-level-imports = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8TypeCheckingOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  exempt-modules = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  runtime-evaluated-base-classes = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  runtime-evaluated-decorators = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  strict = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          Flake8UnusedArgumentsOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ignore-variadic-names = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          FormatOptions
            | doc m%"
            Experimental: Configures how `ruff format` formats your code.
            
            Please provide feedback in [this discussion](https://github.com/astral-sh/ruff/discussions/7310).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  indent-style = predicates.anyOf
                      [
                        definitions.predicate.IndentStyle,
                        predicates.isType 'Null
                      ],
                  line-ending = predicates.anyOf
                      [
                        definitions.predicate.LineEnding,
                        predicates.isType 'Null
                      ],
                  preview = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  quote-style = predicates.anyOf
                      [
                        definitions.predicate.QuoteStyle,
                        predicates.isType 'Null
                      ],
                  skip-magic-trailing-comma = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          ImportSection = predicates.anyOf
              [ definitions.predicate.ImportType, predicates.isType '"String" ],
          ImportType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "future",
                  "standard-library",
                  "third-party",
                  "first-party",
                  "local-folder"
                ]
              ],
          IndentStyle = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "tab" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "space" ] ]
              ],
          IsortOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  case-sensitive = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  classes = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  combine-as-imports = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  constants = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  detect-same-package = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  extra-standard-library = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  force-single-line = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  force-sort-within-sections = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  force-to-top = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  force-wrap-aliases = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  forced-separate = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  known-first-party = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  known-local-folder = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  known-third-party = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  lines-after-imports = predicates.anyOf
                      [ predicates.isType 'Integer, predicates.isType 'Null ],
                  lines-between-types = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                        predicates.numbers.minimum 0
                      ],
                  no-lines-before = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.ImportSection
                      ],
                  order-by-type = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  relative-imports-order = predicates.anyOf
                      [
                        definitions.predicate.RelativeImportsOrder,
                        predicates.isType 'Null
                      ],
                  required-imports = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  section-order = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.ImportSection
                      ],
                  sections = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Record, predicates.isType 'Null ],
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ])
                      ],
                  single-line-exclusions = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  split-on-trailing-comma = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  variables = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          LineEnding = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "lf" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "cr-lf" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "auto" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "native" ] ]
              ],
          LineLength
            | doc m%"
            The length of a line of text that is considered too long.
            
            The allowed range of values is 1..=320
            "%
            = predicates.allOf
              [
                predicates.isType 'Integer,
                predicates.numbers.maximum 320,
                predicates.numbers.minimum 1
              ],
          LintOptions
            | doc m%"
            Experimental section to configure Ruff's linting. This new section will eventually replace the top-level linting options.
            
            Options specified in the `lint` section take precedence over the top-level settings.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allowed-confusables = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.maxLength 1,
                          predicates.strings.minLength 1
                        ])
                      ],
                  dummy-variable-rgx = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  explicit-preview-rules = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  extend-fixable = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.RuleSelector
                      ],
                  extend-per-file-ignores = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Record, predicates.isType 'Null ],
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.RuleSelector
                        ])
                      ],
                  extend-safe-fixes = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.RuleSelector
                      ],
                  extend-select = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.RuleSelector
                      ],
                  extend-unsafe-fixes = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.RuleSelector
                      ],
                  external = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  fixable = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.RuleSelector
                      ],
                  flake8-annotations = predicates.anyOf
                      [
                        definitions.predicate.Flake8AnnotationsOptions,
                        predicates.isType 'Null
                      ],
                  flake8-bandit = predicates.anyOf
                      [
                        definitions.predicate.Flake8BanditOptions,
                        predicates.isType 'Null
                      ],
                  flake8-bugbear = predicates.anyOf
                      [
                        definitions.predicate.Flake8BugbearOptions,
                        predicates.isType 'Null
                      ],
                  flake8-builtins = predicates.anyOf
                      [
                        definitions.predicate.Flake8BuiltinsOptions,
                        predicates.isType 'Null
                      ],
                  flake8-comprehensions = predicates.anyOf
                      [
                        definitions.predicate.Flake8ComprehensionsOptions,
                        predicates.isType 'Null
                      ],
                  flake8-copyright = predicates.anyOf
                      [
                        definitions.predicate.Flake8CopyrightOptions,
                        predicates.isType 'Null
                      ],
                  flake8-errmsg = predicates.anyOf
                      [
                        definitions.predicate.Flake8ErrMsgOptions,
                        predicates.isType 'Null
                      ],
                  flake8-gettext = predicates.anyOf
                      [
                        definitions.predicate.Flake8GetTextOptions,
                        predicates.isType 'Null
                      ],
                  flake8-implicit-str-concat = predicates.anyOf
                      [
                        definitions.predicate.Flake8ImplicitStrConcatOptions,
                        predicates.isType 'Null
                      ],
                  flake8-import-conventions = predicates.anyOf
                      [
                        definitions.predicate.Flake8ImportConventionsOptions,
                        predicates.isType 'Null
                      ],
                  flake8-pytest-style = predicates.anyOf
                      [
                        definitions.predicate.Flake8PytestStyleOptions,
                        predicates.isType 'Null
                      ],
                  flake8-quotes = predicates.anyOf
                      [
                        definitions.predicate.Flake8QuotesOptions,
                        predicates.isType 'Null
                      ],
                  flake8-self = predicates.anyOf
                      [
                        definitions.predicate.Flake8SelfOptions,
                        predicates.isType 'Null
                      ],
                  flake8-tidy-imports = predicates.anyOf
                      [
                        definitions.predicate.Flake8TidyImportsOptions,
                        predicates.isType 'Null
                      ],
                  flake8-type-checking = predicates.anyOf
                      [
                        definitions.predicate.Flake8TypeCheckingOptions,
                        predicates.isType 'Null
                      ],
                  flake8-unused-arguments = predicates.anyOf
                      [
                        definitions.predicate.Flake8UnusedArgumentsOptions,
                        predicates.isType 'Null
                      ],
                  ignore = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.RuleSelector
                      ],
                  ignore-init-module-imports = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  isort = predicates.anyOf
                      [
                        definitions.predicate.IsortOptions,
                        predicates.isType 'Null
                      ],
                  logger-objects = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  mccabe = predicates.anyOf
                      [
                        definitions.predicate.McCabeOptions,
                        predicates.isType 'Null
                      ],
                  pep8-naming = predicates.anyOf
                      [
                        definitions.predicate.Pep8NamingOptions,
                        predicates.isType 'Null
                      ],
                  per-file-ignores = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Record, predicates.isType 'Null ],
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.RuleSelector
                        ])
                      ],
                  pycodestyle = predicates.anyOf
                      [
                        definitions.predicate.PycodestyleOptions,
                        predicates.isType 'Null
                      ],
                  pydocstyle = predicates.anyOf
                      [
                        definitions.predicate.PydocstyleOptions,
                        predicates.isType 'Null
                      ],
                  pyflakes = predicates.anyOf
                      [
                        definitions.predicate.PyflakesOptions,
                        predicates.isType 'Null
                      ],
                  pylint = predicates.anyOf
                      [
                        definitions.predicate.PylintOptions,
                        predicates.isType 'Null
                      ],
                  pyupgrade = predicates.anyOf
                      [
                        definitions.predicate.PyUpgradeOptions,
                        predicates.isType 'Null
                      ],
                  select = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.RuleSelector
                      ],
                  task-tags = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  typing-modules = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  unfixable = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.RuleSelector
                      ],
                }
                {  }
                false
                predicates.never
              ],
          McCabeOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  max-complexity = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ParametrizeNameType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "csv", "tuple", "list" ]
              ],
          ParametrizeValuesRowType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "tuple", "list" ]
              ],
          ParametrizeValuesType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "tuple", "list" ]
              ],
          Pep8NamingOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  classmethod-decorators = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extend-ignore-names = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  ignore-names = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  staticmethod-decorators = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PyUpgradeOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  keep-runtime-typing = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          PycodestyleOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ignore-overlong-task-comments = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  max-doc-length = predicates.anyOf
                      [
                        definitions.predicate.LineLength,
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PydocstyleOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  convention = predicates.anyOf
                      [
                        definitions.predicate.Convention,
                        predicates.isType 'Null
                      ],
                  ignore-decorators = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  property-decorators = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PyflakesOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  extend-generics = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PylintOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allow-magic-value-types = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.ConstantType
                      ],
                  max-args = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                        predicates.numbers.minimum 0
                      ],
                  max-branches = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                        predicates.numbers.minimum 0
                      ],
                  max-public-methods = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                        predicates.numbers.minimum 0
                      ],
                  max-returns = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                        predicates.numbers.minimum 0
                      ],
                  max-statements = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PythonVersion = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "py37", "py38", "py39", "py310", "py311", "py312" ]
              ],
          Quote = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "double" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "single" ] ]
              ],
          QuoteStyle = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "single", "double" ]
              ],
          RelativeImportsOrder = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "closest-to-furthest" ]
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "furthest-to-closest" ]
                ]
              ],
          RuleSelector = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "A",
                  "A0",
                  "A00",
                  "A001",
                  "A002",
                  "A003",
                  "AIR",
                  "AIR0",
                  "AIR00",
                  "AIR001",
                  "ALL",
                  "ANN",
                  "ANN0",
                  "ANN00",
                  "ANN001",
                  "ANN002",
                  "ANN003",
                  "ANN1",
                  "ANN10",
                  "ANN101",
                  "ANN102",
                  "ANN2",
                  "ANN20",
                  "ANN201",
                  "ANN202",
                  "ANN204",
                  "ANN205",
                  "ANN206",
                  "ANN4",
                  "ANN40",
                  "ANN401",
                  "ARG",
                  "ARG0",
                  "ARG00",
                  "ARG001",
                  "ARG002",
                  "ARG003",
                  "ARG004",
                  "ARG005",
                  "ASYNC",
                  "ASYNC1",
                  "ASYNC10",
                  "ASYNC100",
                  "ASYNC101",
                  "ASYNC102",
                  "B",
                  "B0",
                  "B00",
                  "B002",
                  "B003",
                  "B004",
                  "B005",
                  "B006",
                  "B007",
                  "B008",
                  "B009",
                  "B01",
                  "B010",
                  "B011",
                  "B012",
                  "B013",
                  "B014",
                  "B015",
                  "B016",
                  "B017",
                  "B018",
                  "B019",
                  "B02",
                  "B020",
                  "B021",
                  "B022",
                  "B023",
                  "B024",
                  "B025",
                  "B026",
                  "B027",
                  "B028",
                  "B029",
                  "B03",
                  "B030",
                  "B031",
                  "B032",
                  "B033",
                  "B034",
                  "B9",
                  "B90",
                  "B904",
                  "B905",
                  "BLE",
                  "BLE0",
                  "BLE00",
                  "BLE001",
                  "C",
                  "C4",
                  "C40",
                  "C400",
                  "C401",
                  "C402",
                  "C403",
                  "C404",
                  "C405",
                  "C406",
                  "C408",
                  "C409",
                  "C41",
                  "C410",
                  "C411",
                  "C413",
                  "C414",
                  "C415",
                  "C416",
                  "C417",
                  "C418",
                  "C419",
                  "C9",
                  "C90",
                  "C901",
                  "COM",
                  "COM8",
                  "COM81",
                  "COM812",
                  "COM818",
                  "COM819",
                  "CPY",
                  "CPY0",
                  "CPY00",
                  "CPY001",
                  "D",
                  "D1",
                  "D10",
                  "D100",
                  "D101",
                  "D102",
                  "D103",
                  "D104",
                  "D105",
                  "D106",
                  "D107",
                  "D2",
                  "D20",
                  "D200",
                  "D201",
                  "D202",
                  "D203",
                  "D204",
                  "D205",
                  "D206",
                  "D207",
                  "D208",
                  "D209",
                  "D21",
                  "D210",
                  "D211",
                  "D212",
                  "D213",
                  "D214",
                  "D215",
                  "D3",
                  "D30",
                  "D300",
                  "D301",
                  "D4",
                  "D40",
                  "D400",
                  "D401",
                  "D402",
                  "D403",
                  "D404",
                  "D405",
                  "D406",
                  "D407",
                  "D408",
                  "D409",
                  "D41",
                  "D410",
                  "D411",
                  "D412",
                  "D413",
                  "D414",
                  "D415",
                  "D416",
                  "D417",
                  "D418",
                  "D419",
                  "DJ",
                  "DJ0",
                  "DJ00",
                  "DJ001",
                  "DJ003",
                  "DJ006",
                  "DJ007",
                  "DJ008",
                  "DJ01",
                  "DJ012",
                  "DJ013",
                  "DTZ",
                  "DTZ0",
                  "DTZ00",
                  "DTZ001",
                  "DTZ002",
                  "DTZ003",
                  "DTZ004",
                  "DTZ005",
                  "DTZ006",
                  "DTZ007",
                  "DTZ01",
                  "DTZ011",
                  "DTZ012",
                  "E",
                  "E1",
                  "E10",
                  "E101",
                  "E11",
                  "E111",
                  "E112",
                  "E113",
                  "E114",
                  "E115",
                  "E116",
                  "E117",
                  "E2",
                  "E20",
                  "E201",
                  "E202",
                  "E203",
                  "E21",
                  "E211",
                  "E22",
                  "E221",
                  "E222",
                  "E223",
                  "E224",
                  "E225",
                  "E226",
                  "E227",
                  "E228",
                  "E23",
                  "E231",
                  "E24",
                  "E241",
                  "E242",
                  "E25",
                  "E251",
                  "E252",
                  "E26",
                  "E261",
                  "E262",
                  "E265",
                  "E266",
                  "E27",
                  "E271",
                  "E272",
                  "E273",
                  "E274",
                  "E275",
                  "E4",
                  "E40",
                  "E401",
                  "E402",
                  "E5",
                  "E50",
                  "E501",
                  "E7",
                  "E70",
                  "E701",
                  "E702",
                  "E703",
                  "E71",
                  "E711",
                  "E712",
                  "E713",
                  "E714",
                  "E72",
                  "E721",
                  "E722",
                  "E73",
                  "E731",
                  "E74",
                  "E741",
                  "E742",
                  "E743",
                  "E9",
                  "E90",
                  "E902",
                  "E99",
                  "E999",
                  "EM",
                  "EM1",
                  "EM10",
                  "EM101",
                  "EM102",
                  "EM103",
                  "ERA",
                  "ERA0",
                  "ERA00",
                  "ERA001",
                  "EXE",
                  "EXE0",
                  "EXE00",
                  "EXE001",
                  "EXE002",
                  "EXE003",
                  "EXE004",
                  "EXE005",
                  "F",
                  "F4",
                  "F40",
                  "F401",
                  "F402",
                  "F403",
                  "F404",
                  "F405",
                  "F406",
                  "F407",
                  "F5",
                  "F50",
                  "F501",
                  "F502",
                  "F503",
                  "F504",
                  "F505",
                  "F506",
                  "F507",
                  "F508",
                  "F509",
                  "F52",
                  "F521",
                  "F522",
                  "F523",
                  "F524",
                  "F525",
                  "F54",
                  "F541",
                  "F6",
                  "F60",
                  "F601",
                  "F602",
                  "F62",
                  "F621",
                  "F622",
                  "F63",
                  "F631",
                  "F632",
                  "F633",
                  "F634",
                  "F7",
                  "F70",
                  "F701",
                  "F702",
                  "F704",
                  "F706",
                  "F707",
                  "F72",
                  "F722",
                  "F8",
                  "F81",
                  "F811",
                  "F82",
                  "F821",
                  "F822",
                  "F823",
                  "F84",
                  "F841",
                  "F842",
                  "F9",
                  "F90",
                  "F901",
                  "FA",
                  "FA1",
                  "FA10",
                  "FA100",
                  "FA102",
                  "FBT",
                  "FBT0",
                  "FBT00",
                  "FBT001",
                  "FBT002",
                  "FBT003",
                  "FIX",
                  "FIX0",
                  "FIX00",
                  "FIX001",
                  "FIX002",
                  "FIX003",
                  "FIX004",
                  "FLY",
                  "FLY0",
                  "FLY00",
                  "FLY002",
                  "FURB",
                  "FURB1",
                  "FURB10",
                  "FURB105",
                  "FURB11",
                  "FURB113",
                  "FURB13",
                  "FURB131",
                  "FURB132",
                  "FURB14",
                  "FURB140",
                  "FURB145",
                  "FURB148",
                  "FURB17",
                  "FURB171",
                  "FURB177",
                  "G",
                  "G0",
                  "G00",
                  "G001",
                  "G002",
                  "G003",
                  "G004",
                  "G01",
                  "G010",
                  "G1",
                  "G10",
                  "G101",
                  "G2",
                  "G20",
                  "G201",
                  "G202",
                  "I",
                  "I0",
                  "I00",
                  "I001",
                  "I002",
                  "ICN",
                  "ICN0",
                  "ICN00",
                  "ICN001",
                  "ICN002",
                  "ICN003",
                  "INP",
                  "INP0",
                  "INP00",
                  "INP001",
                  "INT",
                  "INT0",
                  "INT00",
                  "INT001",
                  "INT002",
                  "INT003",
                  "ISC",
                  "ISC0",
                  "ISC00",
                  "ISC001",
                  "ISC002",
                  "ISC003",
                  "LOG",
                  "LOG0",
                  "LOG00",
                  "LOG001",
                  "LOG002",
                  "LOG007",
                  "LOG009",
                  "N",
                  "N8",
                  "N80",
                  "N801",
                  "N802",
                  "N803",
                  "N804",
                  "N805",
                  "N806",
                  "N807",
                  "N81",
                  "N811",
                  "N812",
                  "N813",
                  "N814",
                  "N815",
                  "N816",
                  "N817",
                  "N818",
                  "N9",
                  "N99",
                  "N999",
                  "NPY",
                  "NPY0",
                  "NPY00",
                  "NPY001",
                  "NPY002",
                  "NPY003",
                  "NURSERY",
                  "PD",
                  "PD0",
                  "PD00",
                  "PD002",
                  "PD003",
                  "PD004",
                  "PD007",
                  "PD008",
                  "PD009",
                  "PD01",
                  "PD010",
                  "PD011",
                  "PD012",
                  "PD013",
                  "PD015",
                  "PD1",
                  "PD10",
                  "PD101",
                  "PD9",
                  "PD90",
                  "PD901",
                  "PERF",
                  "PERF1",
                  "PERF10",
                  "PERF101",
                  "PERF102",
                  "PERF2",
                  "PERF20",
                  "PERF203",
                  "PERF4",
                  "PERF40",
                  "PERF401",
                  "PERF402",
                  "PERF403",
                  "PGH",
                  "PGH0",
                  "PGH00",
                  "PGH001",
                  "PGH002",
                  "PGH003",
                  "PGH004",
                  "PGH005",
                  "PIE",
                  "PIE7",
                  "PIE79",
                  "PIE790",
                  "PIE794",
                  "PIE796",
                  "PIE8",
                  "PIE80",
                  "PIE800",
                  "PIE804",
                  "PIE807",
                  "PIE808",
                  "PIE81",
                  "PIE810",
                  "PL",
                  "PLC",
                  "PLC0",
                  "PLC01",
                  "PLC010",
                  "PLC0105",
                  "PLC013",
                  "PLC0131",
                  "PLC0132",
                  "PLC02",
                  "PLC020",
                  "PLC0205",
                  "PLC0208",
                  "PLC04",
                  "PLC041",
                  "PLC0414",
                  "PLC1",
                  "PLC19",
                  "PLC190",
                  "PLC1901",
                  "PLC3",
                  "PLC30",
                  "PLC300",
                  "PLC3002",
                  "PLE",
                  "PLE0",
                  "PLE01",
                  "PLE010",
                  "PLE0100",
                  "PLE0101",
                  "PLE011",
                  "PLE0116",
                  "PLE0117",
                  "PLE0118",
                  "PLE02",
                  "PLE024",
                  "PLE0241",
                  "PLE03",
                  "PLE030",
                  "PLE0302",
                  "PLE0307",
                  "PLE06",
                  "PLE060",
                  "PLE0604",
                  "PLE0605",
                  "PLE1",
                  "PLE11",
                  "PLE114",
                  "PLE1142",
                  "PLE12",
                  "PLE120",
                  "PLE1205",
                  "PLE1206",
                  "PLE13",
                  "PLE130",
                  "PLE1300",
                  "PLE1307",
                  "PLE131",
                  "PLE1310",
                  "PLE15",
                  "PLE150",
                  "PLE1507",
                  "PLE17",
                  "PLE170",
                  "PLE1700",
                  "PLE2",
                  "PLE25",
                  "PLE250",
                  "PLE2502",
                  "PLE251",
                  "PLE2510",
                  "PLE2512",
                  "PLE2513",
                  "PLE2514",
                  "PLE2515",
                  "PLR",
                  "PLR0",
                  "PLR01",
                  "PLR012",
                  "PLR0124",
                  "PLR013",
                  "PLR0133",
                  "PLR02",
                  "PLR020",
                  "PLR0206",
                  "PLR04",
                  "PLR040",
                  "PLR0402",
                  "PLR09",
                  "PLR090",
                  "PLR0904",
                  "PLR091",
                  "PLR0911",
                  "PLR0912",
                  "PLR0913",
                  "PLR0915",
                  "PLR1",
                  "PLR17",
                  "PLR170",
                  "PLR1701",
                  "PLR1706",
                  "PLR171",
                  "PLR1711",
                  "PLR1714",
                  "PLR172",
                  "PLR1722",
                  "PLR2",
                  "PLR20",
                  "PLR200",
                  "PLR2004",
                  "PLR5",
                  "PLR55",
                  "PLR550",
                  "PLR5501",
                  "PLR6",
                  "PLR63",
                  "PLR630",
                  "PLR6301",
                  "PLW",
                  "PLW0",
                  "PLW01",
                  "PLW012",
                  "PLW0120",
                  "PLW0127",
                  "PLW0129",
                  "PLW013",
                  "PLW0131",
                  "PLW04",
                  "PLW040",
                  "PLW0406",
                  "PLW06",
                  "PLW060",
                  "PLW0602",
                  "PLW0603",
                  "PLW07",
                  "PLW071",
                  "PLW0711",
                  "PLW1",
                  "PLW15",
                  "PLW150",
                  "PLW1508",
                  "PLW1509",
                  "PLW151",
                  "PLW1510",
                  "PLW16",
                  "PLW164",
                  "PLW1641",
                  "PLW2",
                  "PLW29",
                  "PLW290",
                  "PLW2901",
                  "PLW3",
                  "PLW32",
                  "PLW320",
                  "PLW3201",
                  "PLW33",
                  "PLW330",
                  "PLW3301",
                  "PT",
                  "PT0",
                  "PT00",
                  "PT001",
                  "PT002",
                  "PT003",
                  "PT004",
                  "PT005",
                  "PT006",
                  "PT007",
                  "PT008",
                  "PT009",
                  "PT01",
                  "PT010",
                  "PT011",
                  "PT012",
                  "PT013",
                  "PT014",
                  "PT015",
                  "PT016",
                  "PT017",
                  "PT018",
                  "PT019",
                  "PT02",
                  "PT020",
                  "PT021",
                  "PT022",
                  "PT023",
                  "PT024",
                  "PT025",
                  "PT026",
                  "PT027",
                  "PTH",
                  "PTH1",
                  "PTH10",
                  "PTH100",
                  "PTH101",
                  "PTH102",
                  "PTH103",
                  "PTH104",
                  "PTH105",
                  "PTH106",
                  "PTH107",
                  "PTH108",
                  "PTH109",
                  "PTH11",
                  "PTH110",
                  "PTH111",
                  "PTH112",
                  "PTH113",
                  "PTH114",
                  "PTH115",
                  "PTH116",
                  "PTH117",
                  "PTH118",
                  "PTH119",
                  "PTH12",
                  "PTH120",
                  "PTH121",
                  "PTH122",
                  "PTH123",
                  "PTH124",
                  "PTH2",
                  "PTH20",
                  "PTH201",
                  "PTH202",
                  "PTH203",
                  "PTH204",
                  "PTH205",
                  "PTH206",
                  "PTH207",
                  "PYI",
                  "PYI0",
                  "PYI00",
                  "PYI001",
                  "PYI002",
                  "PYI003",
                  "PYI004",
                  "PYI005",
                  "PYI006",
                  "PYI007",
                  "PYI008",
                  "PYI009",
                  "PYI01",
                  "PYI010",
                  "PYI011",
                  "PYI012",
                  "PYI013",
                  "PYI014",
                  "PYI015",
                  "PYI016",
                  "PYI017",
                  "PYI018",
                  "PYI019",
                  "PYI02",
                  "PYI020",
                  "PYI021",
                  "PYI024",
                  "PYI025",
                  "PYI026",
                  "PYI029",
                  "PYI03",
                  "PYI030",
                  "PYI032",
                  "PYI033",
                  "PYI034",
                  "PYI035",
                  "PYI036",
                  "PYI04",
                  "PYI041",
                  "PYI042",
                  "PYI043",
                  "PYI044",
                  "PYI045",
                  "PYI046",
                  "PYI047",
                  "PYI048",
                  "PYI049",
                  "PYI05",
                  "PYI050",
                  "PYI051",
                  "PYI052",
                  "PYI053",
                  "PYI054",
                  "PYI055",
                  "PYI056",
                  "Q",
                  "Q0",
                  "Q00",
                  "Q000",
                  "Q001",
                  "Q002",
                  "Q003",
                  "RET",
                  "RET5",
                  "RET50",
                  "RET501",
                  "RET502",
                  "RET503",
                  "RET504",
                  "RET505",
                  "RET506",
                  "RET507",
                  "RET508",
                  "RSE",
                  "RSE1",
                  "RSE10",
                  "RSE102",
                  "RUF",
                  "RUF0",
                  "RUF00",
                  "RUF001",
                  "RUF002",
                  "RUF003",
                  "RUF005",
                  "RUF006",
                  "RUF007",
                  "RUF008",
                  "RUF009",
                  "RUF01",
                  "RUF010",
                  "RUF011",
                  "RUF012",
                  "RUF013",
                  "RUF015",
                  "RUF016",
                  "RUF017",
                  "RUF018",
                  "RUF019",
                  "RUF1",
                  "RUF10",
                  "RUF100",
                  "RUF2",
                  "RUF20",
                  "RUF200",
                  "S",
                  "S1",
                  "S10",
                  "S101",
                  "S102",
                  "S103",
                  "S104",
                  "S105",
                  "S106",
                  "S107",
                  "S108",
                  "S11",
                  "S110",
                  "S112",
                  "S113",
                  "S2",
                  "S20",
                  "S201",
                  "S3",
                  "S30",
                  "S301",
                  "S302",
                  "S303",
                  "S304",
                  "S305",
                  "S306",
                  "S307",
                  "S308",
                  "S31",
                  "S310",
                  "S311",
                  "S312",
                  "S313",
                  "S314",
                  "S315",
                  "S316",
                  "S317",
                  "S318",
                  "S319",
                  "S32",
                  "S320",
                  "S321",
                  "S323",
                  "S324",
                  "S5",
                  "S50",
                  "S501",
                  "S505",
                  "S506",
                  "S507",
                  "S508",
                  "S509",
                  "S6",
                  "S60",
                  "S601",
                  "S602",
                  "S603",
                  "S604",
                  "S605",
                  "S606",
                  "S607",
                  "S608",
                  "S609",
                  "S61",
                  "S612",
                  "S7",
                  "S70",
                  "S701",
                  "SIM",
                  "SIM1",
                  "SIM10",
                  "SIM101",
                  "SIM102",
                  "SIM103",
                  "SIM105",
                  "SIM107",
                  "SIM108",
                  "SIM109",
                  "SIM11",
                  "SIM110",
                  "SIM112",
                  "SIM114",
                  "SIM115",
                  "SIM116",
                  "SIM117",
                  "SIM118",
                  "SIM2",
                  "SIM20",
                  "SIM201",
                  "SIM202",
                  "SIM208",
                  "SIM21",
                  "SIM210",
                  "SIM211",
                  "SIM212",
                  "SIM22",
                  "SIM220",
                  "SIM221",
                  "SIM222",
                  "SIM223",
                  "SIM3",
                  "SIM30",
                  "SIM300",
                  "SIM4",
                  "SIM40",
                  "SIM401",
                  "SIM9",
                  "SIM91",
                  "SIM910",
                  "SLF",
                  "SLF0",
                  "SLF00",
                  "SLF001",
                  "SLOT",
                  "SLOT0",
                  "SLOT00",
                  "SLOT000",
                  "SLOT001",
                  "SLOT002",
                  "T",
                  "T1",
                  "T10",
                  "T100",
                  "T2",
                  "T20",
                  "T201",
                  "T203",
                  "TCH",
                  "TCH0",
                  "TCH00",
                  "TCH001",
                  "TCH002",
                  "TCH003",
                  "TCH004",
                  "TCH005",
                  "TD",
                  "TD0",
                  "TD00",
                  "TD001",
                  "TD002",
                  "TD003",
                  "TD004",
                  "TD005",
                  "TD006",
                  "TD007",
                  "TID",
                  "TID2",
                  "TID25",
                  "TID251",
                  "TID252",
                  "TID253",
                  "TRY",
                  "TRY0",
                  "TRY00",
                  "TRY002",
                  "TRY003",
                  "TRY004",
                  "TRY2",
                  "TRY20",
                  "TRY200",
                  "TRY201",
                  "TRY3",
                  "TRY30",
                  "TRY300",
                  "TRY301",
                  "TRY302",
                  "TRY4",
                  "TRY40",
                  "TRY400",
                  "TRY401",
                  "UP",
                  "UP0",
                  "UP00",
                  "UP001",
                  "UP003",
                  "UP004",
                  "UP005",
                  "UP006",
                  "UP007",
                  "UP008",
                  "UP009",
                  "UP01",
                  "UP010",
                  "UP011",
                  "UP012",
                  "UP013",
                  "UP014",
                  "UP015",
                  "UP017",
                  "UP018",
                  "UP019",
                  "UP02",
                  "UP020",
                  "UP021",
                  "UP022",
                  "UP023",
                  "UP024",
                  "UP025",
                  "UP026",
                  "UP027",
                  "UP028",
                  "UP029",
                  "UP03",
                  "UP030",
                  "UP031",
                  "UP032",
                  "UP033",
                  "UP034",
                  "UP035",
                  "UP036",
                  "UP037",
                  "UP038",
                  "UP039",
                  "UP04",
                  "UP040",
                  "W",
                  "W1",
                  "W19",
                  "W191",
                  "W2",
                  "W29",
                  "W291",
                  "W292",
                  "W293",
                  "W5",
                  "W50",
                  "W505",
                  "W6",
                  "W60",
                  "W605",
                  "YTT",
                  "YTT1",
                  "YTT10",
                  "YTT101",
                  "YTT102",
                  "YTT103",
                  "YTT2",
                  "YTT20",
                  "YTT201",
                  "YTT202",
                  "YTT203",
                  "YTT204",
                  "YTT3",
                  "YTT30",
                  "YTT301",
                  "YTT302",
                  "YTT303"
                ]
              ],
          SerializationFormat = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "text",
                  "json",
                  "json-lines",
                  "junit",
                  "grouped",
                  "github",
                  "gitlab",
                  "pylint",
                  "azure"
                ]
              ],
          Strictness = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "parents" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "all" ] ]
              ],
          TabSize
            | doc m%"
            The size of a tab.
            "%
            = predicates.allOf
              [ predicates.isType 'Integer, predicates.numbers.minimum 1 ],
          Version = predicates.isType '"String",
        },
  }
in

{
  allowed-confusables
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType '"String",
        predicates.strings.maxLength 1,
        predicates.strings.minLength 1
      ])
    ])
    | doc m%"
    A list of allowed "confusable" Unicode characters to ignore when enforcing `RUF001`, `RUF002`, and `RUF003`.
    "%
    | optional,
  builtins
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A list of builtins to treat as defined references, in addition to the system builtins.
    "%
    | optional,
  cache-dir
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"String", predicates.isType 'Null ])
    | doc m%"
    A path to the cache directory.
    
    By default, Ruff stores cache results in a `.ruff_cache` directory in the current project root.
    
    However, Ruff will also respect the `RUFF_CACHE_DIR` environment variable, which takes precedence over that default.
    
    This setting will override even the `RUFF_CACHE_DIR` environment variable, if set.
    "%
    | optional,
  dummy-variable-rgx
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"String", predicates.isType 'Null ])
    | doc m%"
    A regular expression used to identify "dummy" variables, or those which should be ignored when enforcing (e.g.) unused-variable rules. The default expression matches `_`, `__`, and `_var`, but not `_var_`.
    "%
    | optional,
  exclude
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A list of file patterns to exclude from linting.
    
    Exclusions are based on globs, and can be either:
    
    - Single-path patterns, like `.mypy_cache` (to exclude any directory named `.mypy_cache` in the tree), `foo.py` (to exclude any file named `foo.py`), or `foo_*.py` (to exclude any file matching `foo_*.py` ). - Relative patterns, like `directory/foo.py` (to exclude that specific file) or `directory/*.py` (to exclude any Python files in `directory`). Note that these paths are relative to the project root (e.g., the directory containing your `pyproject.toml`).
    
    For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
    
    Note that you'll typically want to use [`extend-exclude`](#extend-exclude) to modify the excluded paths.
    "%
    | optional,
  explicit-preview-rules
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Whether to require exact codes to select preview rules. When enabled, preview rules will not be selected by prefixes — the full code of each preview rule will be required to enable the rule.
    "%
    | optional,
  extend
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"String", predicates.isType 'Null ])
    | doc m%"
    A path to a local `pyproject.toml` file to merge into this configuration. User home directory and environment variables will be expanded.
    
    To resolve the current `pyproject.toml` file, Ruff will first resolve this base configuration file, then merge in any properties defined in the current configuration file.
    "%
    | optional,
  extend-exclude
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A list of file patterns to omit from linting, in addition to those specified by `exclude`.
    
    Exclusions are based on globs, and can be either:
    
    - Single-path patterns, like `.mypy_cache` (to exclude any directory named `.mypy_cache` in the tree), `foo.py` (to exclude any file named `foo.py`), or `foo_*.py` (to exclude any file matching `foo_*.py` ). - Relative patterns, like `directory/foo.py` (to exclude that specific file) or `directory/*.py` (to exclude any Python files in `directory`). Note that these paths are relative to the project root (e.g., the directory containing your `pyproject.toml`).
    
    For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
    "%
    | optional,
  extend-fixable
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf definitions.predicate.RuleSelector
    ])
    | doc m%"
    A list of rule codes or prefixes to consider fixable, in addition to those specified by `fixable`.
    "%
    | optional,
  extend-include
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A list of file patterns to include when linting, in addition to those specified by `include`.
    
    Inclusion are based on globs, and should be single-path patterns, like `*.pyw`, to include any file with the `.pyw` extension.
    
    For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
    "%
    | optional,
  extend-per-file-ignores
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType 'Record, predicates.isType 'Null ],
      predicates.records.record {  } {  } true
      (predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf definitions.predicate.RuleSelector
      ])
    ])
    | doc m%"
    A list of mappings from file pattern to rule codes or prefixes to exclude, in addition to any rules excluded by `per-file-ignores`.
    "%
    | optional,
  extend-safe-fixes
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf definitions.predicate.RuleSelector
    ])
    | doc m%"
    A list of rule codes or prefixes for which unsafe fixes should be considered safe.
    "%
    | optional,
  extend-select
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf definitions.predicate.RuleSelector
    ])
    | doc m%"
    A list of rule codes or prefixes to enable, in addition to those specified by `select`.
    "%
    | optional,
  extend-unsafe-fixes
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf definitions.predicate.RuleSelector
    ])
    | doc m%"
    A list of rule codes or prefixes for which safe fixes should be considered unsafe.
    "%
    | optional,
  external
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A list of rule codes that are unsupported by Ruff, but should be preserved when (e.g.) validating `# noqa` directives. Useful for retaining `# noqa` directives that cover plugins not yet implemented by Ruff.
    "%
    | optional,
  fix
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Enable fix behavior by-default when running `ruff` (overridden by the `--fix` and `--no-fix` command-line flags). Only includes automatic fixes unless `--unsafe-fixes` is provided.
    "%
    | optional,
  fix-only
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Like `fix`, but disables reporting on leftover violation. Implies `fix`.
    "%
    | optional,
  fixable
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf definitions.predicate.RuleSelector
    ])
    | doc m%"
    A list of rule codes or prefixes to consider fixable. By default, all rules are considered fixable.
    "%
    | optional,
  flake8-annotations
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Flake8AnnotationsOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `flake8-annotations` plugin.
    "%
    | optional,
  flake8-bandit
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Flake8BanditOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `flake8-bandit` plugin.
    "%
    | optional,
  flake8-bugbear
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Flake8BugbearOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `flake8-bugbear` plugin.
    "%
    | optional,
  flake8-builtins
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Flake8BuiltinsOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `flake8-builtins` plugin.
    "%
    | optional,
  flake8-comprehensions
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.Flake8ComprehensionsOptions,
      predicates.isType 'Null
    ])
    | doc m%"
    Options for the `flake8-comprehensions` plugin.
    "%
    | optional,
  flake8-copyright
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Flake8CopyrightOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `flake8-copyright` plugin.
    "%
    | optional,
  flake8-errmsg
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Flake8ErrMsgOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `flake8-errmsg` plugin.
    "%
    | optional,
  flake8-gettext
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Flake8GetTextOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `flake8-gettext` plugin.
    "%
    | optional,
  flake8-implicit-str-concat
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.Flake8ImplicitStrConcatOptions,
      predicates.isType 'Null
    ])
    | doc m%"
    Options for the `flake8-implicit-str-concat` plugin.
    "%
    | optional,
  flake8-import-conventions
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.Flake8ImportConventionsOptions,
      predicates.isType 'Null
    ])
    | doc m%"
    Options for the `flake8-import-conventions` plugin.
    "%
    | optional,
  flake8-pytest-style
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Flake8PytestStyleOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `flake8-pytest-style` plugin.
    "%
    | optional,
  flake8-quotes
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Flake8QuotesOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `flake8-quotes` plugin.
    "%
    | optional,
  flake8-self
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Flake8SelfOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `flake8_self` plugin.
    "%
    | optional,
  flake8-tidy-imports
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Flake8TidyImportsOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `flake8-tidy-imports` plugin.
    "%
    | optional,
  flake8-type-checking
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.Flake8TypeCheckingOptions,
      predicates.isType 'Null
    ])
    | doc m%"
    Options for the `flake8-type-checking` plugin.
    "%
    | optional,
  flake8-unused-arguments
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.Flake8UnusedArgumentsOptions,
      predicates.isType 'Null
    ])
    | doc m%"
    Options for the `flake8-unused-arguments` plugin.
    "%
    | optional,
  force-exclude
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Whether to enforce `exclude` and `extend-exclude` patterns, even for paths that are passed to Ruff explicitly. Typically, Ruff will lint any paths passed in directly, even if they would typically be excluded. Setting `force-exclude = true` will cause Ruff to respect these exclusions unequivocally.
    
    This is useful for [`pre-commit`](https://pre-commit.com/), which explicitly passes all changed files to the [`ruff-pre-commit`](https://github.com/astral-sh/ruff-pre-commit) plugin, regardless of whether they're marked as excluded by Ruff's own settings.
    "%
    | optional,
  format
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.FormatOptions, predicates.isType 'Null ])
    | doc m%"
    Options to configure code formatting.
    "%
    | optional,
  ignore
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf definitions.predicate.RuleSelector
    ])
    | doc m%"
    A list of rule codes or prefixes to ignore. Prefixes can specify exact rules (like `F841`), entire categories (like `F`), or anything in between.
    
    When breaking ties between enabled and disabled rules (via `select` and `ignore`, respectively), more specific prefixes override less specific prefixes.
    "%
    | optional,
  ignore-init-module-imports
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Avoid automatically removing unused imports in `__init__.py` files. Such imports will still be flagged, but with a dedicated message suggesting that the import is either added to the module's `__all__` symbol, or re-exported with a redundant alias (e.g., `import os as os`).
    "%
    | optional,
  include
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A list of file patterns to include when linting.
    
    Inclusion are based on globs, and should be single-path patterns, like `*.pyw`, to include any file with the `.pyw` extension. `pyproject.toml` is included here not for configuration but because we lint whether e.g. the `[project]` matches the schema.
    
    For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
    "%
    | optional,
  isort
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.IsortOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `isort` plugin.
    "%
    | optional,
  line-length
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.LineLength, predicates.isType 'Null ])
    | doc m%"
    The line length to use when enforcing long-lines violations (like `E501`). Must be greater than `0` and less than or equal to `320`.
    "%
    | optional,
  lint
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.LintOptions, predicates.isType 'Null ])
    | optional,
  logger-objects
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A list of objects that should be treated equivalently to a `logging.Logger` object.
    
    This is useful for ensuring proper diagnostics (e.g., to identify `logging` deprecations and other best-practices) for projects that re-export a `logging.Logger` object from a common module.
    
    For example, if you have a module `logging_setup.py` with the following contents: ```python import logging
    
    logger = logging.getLogger(__name__) ```
    
    Adding `"logging_setup.logger"` to `logger-objects` will ensure that `logging_setup.logger` is treated as a `logging.Logger` object when imported from other modules (e.g., `from logging_setup import logger`).
    "%
    | optional,
  mccabe
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.McCabeOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `mccabe` plugin.
    "%
    | optional,
  namespace-packages
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Mark the specified directories as namespace packages. For the purpose of module resolution, Ruff will treat those directories as if they contained an `__init__.py` file.
    "%
    | optional,
  output-format
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.SerializationFormat, predicates.isType 'Null ])
    | doc m%"
    The style in which violation messages should be formatted: `"text"` (default), `"grouped"` (group messages by file), `"json"` (machine-readable), `"junit"` (machine-readable XML), `"github"` (GitHub Actions annotations), `"gitlab"` (GitLab CI code quality report), `"pylint"` (Pylint text format) or `"azure"` (Azure Pipeline logging commands).
    "%
    | optional,
  pep8-naming
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Pep8NamingOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `pep8-naming` plugin.
    "%
    | optional,
  per-file-ignores
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType 'Record, predicates.isType 'Null ],
      predicates.records.record {  } {  } true
      (predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf definitions.predicate.RuleSelector
      ])
    ])
    | doc m%"
    A list of mappings from file pattern to rule codes or prefixes to exclude, when considering any matching files.
    "%
    | optional,
  preview
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Whether to enable preview mode. When preview mode is enabled, Ruff will use unstable rules and fixes.
    "%
    | optional,
  pycodestyle
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.PycodestyleOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `pycodestyle` plugin.
    "%
    | optional,
  pydocstyle
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.PydocstyleOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `pydocstyle` plugin.
    "%
    | optional,
  pyflakes
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.PyflakesOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `pyflakes` plugin.
    "%
    | optional,
  pylint
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.PylintOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `pylint` plugin.
    "%
    | optional,
  pyupgrade
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.PyUpgradeOptions, predicates.isType 'Null ])
    | doc m%"
    Options for the `pyupgrade` plugin.
    "%
    | optional,
  required-version
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Version, predicates.isType 'Null ])
    | doc m%"
    Require a specific version of Ruff to be running (useful for unifying results across many environments, e.g., with a `pyproject.toml` file).
    "%
    | optional,
  respect-gitignore
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Whether to automatically exclude files that are ignored by `.ignore`, `.gitignore`, `.git/info/exclude`, and global `gitignore` files. Enabled by default.
    "%
    | optional,
  select
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf definitions.predicate.RuleSelector
    ])
    | doc m%"
    A list of rule codes or prefixes to enable. Prefixes can specify exact rules (like `F841`), entire categories (like `F`), or anything in between.
    
    When breaking ties between enabled and disabled rules (via `select` and `ignore`, respectively), more specific prefixes override less specific prefixes.
    "%
    | optional,
  show-fixes
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Whether to show an enumeration of all fixed lint violations (overridden by the `--show-fixes` command-line flag).
    "%
    | optional,
  show-source
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Whether to show source code snippets when reporting lint violations (overridden by the `--show-source` command-line flag).
    "%
    | optional,
  src
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    The directories to consider when resolving first- vs. third-party imports.
    
    As an example: given a Python package structure like:
    
    ```text my_project ├── pyproject.toml └── src └── my_package ├── __init__.py ├── foo.py └── bar.py ```
    
    The `./src` directory should be included in the `src` option (e.g., `src = ["src"]`), such that when resolving imports, `my_package.foo` is considered a first-party import.
    
    When omitted, the `src` directory will typically default to the directory containing the nearest `pyproject.toml`, `ruff.toml`, or `.ruff.toml` file (the "project root"), unless a configuration file is explicitly provided (e.g., via the `--config` command-line flag).
    
    This field supports globs. For example, if you have a series of Python packages in a `python_modules` directory, `src = ["python_modules/*"]` would expand to incorporate all of the packages in that directory. User home directory and environment variables will also be expanded.
    "%
    | optional,
  tab-size
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.TabSize, predicates.isType 'Null ])
    | doc m%"
    The tabulation size to calculate line length.
    "%
    | optional,
  target-version
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.PythonVersion, predicates.isType 'Null ])
    | doc m%"
    The minimum Python version to target, e.g., when considering automatic code upgrades, like rewriting type annotations. Ruff will not propose changes using features that are not available in the given version.
    
    For example, to represent supporting Python >=3.10 or ==3.10 specify `target-version = "py310"`.
    
    If omitted, and Ruff is configured via a `pyproject.toml` file, the target version will be inferred from its `project.requires-python` field (e.g., `requires-python = ">=3.8"`). If Ruff is configured via `ruff.toml` or `.ruff.toml`, no such inference will be performed.
    "%
    | optional,
  task-tags
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A list of task tags to recognize (e.g., "TODO", "FIXME", "XXX").
    
    Comments starting with these tags will be ignored by commented-out code detection (`ERA`), and skipped by line-length rules (`E501`) if `ignore-overlong-task-comments` is set to `true`.
    "%
    | optional,
  typing-modules
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A list of modules whose exports should be treated equivalently to members of the `typing` module.
    
    This is useful for ensuring proper type annotation inference for projects that re-export `typing` and `typing_extensions` members from a compatibility module. If omitted, any members imported from modules apart from `typing` and `typing_extensions` will be treated as ordinary Python objects.
    "%
    | optional,
  unfixable
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array", predicates.isType 'Null ],
      predicates.arrays.arrayOf definitions.predicate.RuleSelector
    ])
    | doc m%"
    A list of rule codes or prefixes to consider non-fixable.
    "%
    | optional,
  unsafe-fixes
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Enable application of unsafe fixes.
    "%
    | optional,
}