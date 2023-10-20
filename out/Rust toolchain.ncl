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
  predicates.records.required [ "toolchain" ],
  predicates.records.record
  {
    toolchain = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.oneOf
          [
            predicates.not
            (predicates.allOf
            [
              predicates.records.required [ "path" ],
              predicates.records.record { path = predicates.isType '"String", }
              {  }
              true
              predicates.always
            ]),
            predicates.allOf
            [
              predicates.records.required [ "path" ],
              predicates.records.record {  } {  } true predicates.always
            ]
          ],
          predicates.records.minProperties 1,
          predicates.records.record
          {
            channel = predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern
                  "^(?:stable|beta|nightly|\\d+(?:\\.\\d+){1,2})(?:-\\d{4}(?:-\\d{2}){2})?(?:-\\D[^-]*(?:(?:-(?:[^-]+)){1,3}))?$"
                ],
            components = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum
                    [
                      "rustc",
                      "cargo",
                      "rustfmt",
                      "rust-std",
                      "rust-docs",
                      "rls",
                      "clippy",
                      "miri",
                      "rust-src",
                      "rust",
                      "rust-analysis",
                      "llvm-tools",
                      "rustc-docs",
                      "rustc-dev",
                      "rust-analyzer",
                      "reproducible-artifacts",
                      "rust-docs-json"
                    ]
                  ])
                ],
            path = predicates.isType '"String",
            profile = predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "minimal", "default", "complete" ]
                ],
            targets = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum
                    [
                      "aarch64-unknown-linux-gnu",
                      "i686-pc-windows-gnu",
                      "i686-pc-windows-msvc",
                      "i686-unknown-linux-gnu",
                      "x86_64-apple-darwin",
                      "x86_64-pc-windows-gnu",
                      "x86_64-pc-windows-msvc",
                      "x86_64-unknown-linux-gnu",
                      "aarch64-apple-darwin",
                      "aarch64-pc-windows-msvc",
                      "aarch64-unknown-linux-musl",
                      "arm-unknown-linux-gnueabi",
                      "arm-unknown-linux-gnueabihf",
                      "armv7-unknown-linux-gnueabihf",
                      "loongarch64-unknown-linux-gnu",
                      "mips-unknown-linux-gnu",
                      "mips64-unknown-linux-gnuabi64",
                      "mips64el-unknown-linux-gnuabi64",
                      "mipsel-unknown-linux-gnu",
                      "powerpc-unknown-linux-gnu",
                      "powerpc64-unknown-linux-gnu",
                      "powerpc64le-unknown-linux-gnu",
                      "riscv64gc-unknown-linux-gnu",
                      "s390x-unknown-linux-gnu",
                      "x86_64-unknown-freebsd",
                      "x86_64-unknown-illumos",
                      "x86_64-unknown-linux-musl",
                      "x86_64-unknown-netbsd",
                      "aarch64-apple-ios",
                      "aarch64-apple-ios-sim",
                      "aarch64-fuchsia",
                      "aarch64-unknown-fuchsia",
                      "aarch64-linux-android",
                      "aarch64-unknown-none-softfloat",
                      "aarch64-unknown-none",
                      "aarch64-unknown-uefi",
                      "arm-linux-androideabi",
                      "arm-unknown-linux-musleabi",
                      "arm-unknown-linux-musleabihf",
                      "armebv7r-none-eabi",
                      "armebv7r-none-eabihf",
                      "armv5te-unknown-linux-gnueabi",
                      "armv5te-unknown-linux-musleabi",
                      "armv7-linux-androideabi",
                      "armv7-unknown-linux-gnueabi",
                      "armv7-unknown-linux-musleabi",
                      "armv7-unknown-linux-musleabihf",
                      "armv7a-none-eabi",
                      "armv7r-none-eabi",
                      "armv7r-none-eabihf",
                      "asmjs-unknown-emscripten",
                      "i586-pc-windows-msvc",
                      "i586-unknown-linux-gnu",
                      "i586-unknown-linux-musl",
                      "i686-linux-android",
                      "i686-unknown-freebsd",
                      "i686-unknown-linux-musl",
                      "i686-unknown-uefi",
                      "mips-unknown-linux-musl",
                      "mips64-unknown-linux-muslabi64",
                      "mips64el-unknown-linux-muslabi64",
                      "mipsel-unknown-linux-musl",
                      "nvptx64-nvidia-cuda",
                      "riscv32i-unknown-none-elf",
                      "riscv32imac-unknown-none-elf",
                      "riscv32imc-unknown-none-elf",
                      "riscv64gc-unknown-none-elf",
                      "riscv64imac-unknown-none-elf",
                      "sparc64-unknown-linux-gnu",
                      "sparcv9-sun-solaris",
                      "thumbv6m-none-eabi",
                      "thumbv7em-none-eabi",
                      "thumbv7em-none-eabihf",
                      "thumbv7m-none-eabi",
                      "thumbv7neon-linux-androideabi",
                      "thumbv7neon-unknown-linux-gnueabihf",
                      "thumbv8m.base-none-eabi",
                      "thumbv8m.main-none-eabi",
                      "thumbv8m.main-none-eabihf",
                      "wasm32-unknown-emscripten",
                      "wasm32-unknown-unknown",
                      "wasm32-wasi",
                      "wasm32-wasi-preview1-threads",
                      "x86_64-apple-ios",
                      "x86_64-fortanix-unknown-sgx",
                      "x86_64-fuchsia",
                      "x86_64-unknown-fuchsia",
                      "x86_64-linux-android",
                      "x86_64-pc-solaris",
                      "x86_64-unknown-linux-gnux32",
                      "x86_64-unknown-none",
                      "x86_64-unknown-redox",
                      "x86_64-unknown-uefi",
                      "aarch64-apple-ios-macabi",
                      "aarch64-apple-tvos",
                      "aarch64-apple-watchos-sim",
                      "aarch64-kmc-solid_asp3",
                      "aarch64-nintendo-switch-freestanding",
                      "aarch64-pc-windows-gnullvm",
                      "aarch64-unknown-linux-ohos",
                      "aarch64-unknown-teeos",
                      "aarch64-unknown-nto-qnx710",
                      "aarch64-unknown-freebsd",
                      "aarch64-unknown-hermit",
                      "aarch64-unknown-linux-gnu_ilp32",
                      "aarch64-unknown-netbsd",
                      "aarch64-unknown-openbsd",
                      "aarch64-unknown-redox",
                      "aarch64-uwp-windows-msvc",
                      "aarch64-wrs-vxworks",
                      "aarch64_be-unknown-linux-gnu_ilp32",
                      "aarch64_be-unknown-linux-gnu",
                      "aarch64_be-unknown-netbsd",
                      "arm64_32-apple-watchos",
                      "armeb-unknown-linux-gnueabi",
                      "armv4t-none-eabi",
                      "armv4t-unknown-linux-gnueabi",
                      "armv5te-none-eabi",
                      "armv5te-unknown-linux-uclibceabi",
                      "armv6-unknown-freebsd",
                      "armv6-unknown-netbsd-eabihf",
                      "armv6k-nintendo-3ds",
                      "armv7-apple-ios",
                      "armv7-sony-vita-newlibeabihf",
                      "armv7-unknown-linux-ohos",
                      "armv7-unknown-linux-uclibceabi",
                      "armv7-unknown-linux-uclibceabihf",
                      "armv7-unknown-freebsd",
                      "armv7-unknown-netbsd-eabihf",
                      "armv7-wrs-vxworks-eabihf",
                      "armv7a-kmc-solid_asp3-eabi",
                      "armv7a-kmc-solid_asp3-eabihf",
                      "armv7a-none-eabihf",
                      "armv7k-apple-watchos",
                      "armv7s-apple-ios",
                      "avr-unknown-gnu-atmega328",
                      "bpfeb-unknown-none",
                      "bpfel-unknown-none",
                      "csky-unknown-linux-gnuabiv2",
                      "hexagon-unknown-linux-musl",
                      "i386-apple-ios",
                      "i586-pc-nto-qnx700",
                      "i686-apple-darwin",
                      "i686-pc-windows-gnullvm",
                      "i686-unknown-haiku",
                      "i686-unknown-hurd-gnu",
                      "i686-unknown-netbsd",
                      "i686-unknown-openbsd",
                      "i686-uwp-windows-gnu",
                      "i686-uwp-windows-msvc",
                      "i686-wrs-vxworks",
                      "loongarch64-unknown-none",
                      "loongarch64-unknown-none-softfloat",
                      "m68k-unknown-linux-gnu",
                      "mips-unknown-linux-uclibc",
                      "mips64-openwrt-linux-musl",
                      "mipsel-sony-psp",
                      "mipsel-sony-psx",
                      "mipsel-unknown-linux-uclibc",
                      "mipsel-unknown-none",
                      "mipsisa32r6-unknown-linux-gnu",
                      "mipsisa32r6el-unknown-linux-gnu",
                      "mipsisa64r6-unknown-linux-gnuabi64",
                      "mipsisa64r6el-unknown-linux-gnuabi64",
                      "msp430-none-elf",
                      "powerpc-unknown-linux-gnuspe",
                      "powerpc-unknown-linux-musl",
                      "powerpc-unknown-netbsd",
                      "powerpc-unknown-openbsd",
                      "powerpc-wrs-vxworks-spe",
                      "powerpc-wrs-vxworks",
                      "powerpc64-unknown-freebsd",
                      "powerpc64le-unknown-freebsd",
                      "powerpc-unknown-freebsd",
                      "powerpc64-unknown-linux-musl",
                      "powerpc64-wrs-vxworks",
                      "powerpc64le-unknown-linux-musl",
                      "powerpc64-unknown-openbsd",
                      "powerpc64-ibm-aix",
                      "riscv32gc-unknown-linux-gnu",
                      "riscv32gc-unknown-linux-musl",
                      "riscv32im-unknown-none-elf",
                      "riscv32imac-unknown-xous-elf",
                      "riscv32imc-esp-espidf",
                      "riscv32imac-esp-espidf",
                      "riscv64gc-unknown-hermit",
                      "riscv64gc-unknown-freebsd",
                      "riscv64gc-unknown-fuchsia",
                      "riscv64gc-unknown-linux-musl",
                      "riscv64gc-unknown-netbsd",
                      "riscv64gc-unknown-openbsd",
                      "riscv64-linux-android",
                      "s390x-unknown-linux-musl",
                      "sparc-unknown-linux-gnu",
                      "sparc-unknown-none-elf",
                      "sparc64-unknown-netbsd",
                      "sparc64-unknown-openbsd",
                      "thumbv4t-none-eabi",
                      "thumbv5te-none-eabi",
                      "thumbv7a-pc-windows-msvc",
                      "thumbv7a-uwp-windows-msvc",
                      "thumbv7neon-unknown-linux-musleabihf",
                      "wasm64-unknown-unknown",
                      "x86_64-apple-ios-macabi",
                      "x86_64-apple-tvos",
                      "x86_64-apple-watchos-sim",
                      "x86_64-pc-nto-qnx710",
                      "x86_64-pc-windows-gnullvm",
                      "x86_64-sun-solaris",
                      "x86_64-unikraft-linux-musl",
                      "x86_64-unknown-dragonfly",
                      "x86_64-unknown-haiku",
                      "x86_64-unknown-hermit",
                      "x86_64-unknown-l4re-uclibc",
                      "x86_64-unknown-linux-ohos",
                      "x86_64-unknown-openbsd",
                      "x86_64-uwp-windows-gnu",
                      "x86_64-uwp-windows-msvc",
                      "x86_64-wrs-vxworks",
                      "x86_64h-apple-darwin"
                    ]
                  ])
                ],
          }
          {  }
          true
          predicates.always,
          predicates.records.dependencies
          {
            channel = predicates.not
                (predicates.allOf
                [
                  predicates.records.required [ "path" ],
                  predicates.records.record
                  { path = predicates.isType '"String", }
                  {  }
                  true
                  predicates.always
                ]),
            path = predicates.not
                (predicates.allOf
                [
                  predicates.records.required [ "channel" ],
                  predicates.records.record
                  { channel = predicates.isType '"String", }
                  {  }
                  true
                  predicates.always
                ]),
            profile = predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "channel" ],
                    predicates.records.record
                    { channel = predicates.isType '"String", }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "components" ],
                    predicates.records.record
                    { components = predicates.isType '"Array", }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "targets" ],
                    predicates.records.record
                    { targets = predicates.isType '"Array", }
                    {  }
                    true
                    predicates.always
                  ]
                ],
          }
        ],
  }
  {  }
  true
  predicates.always
])