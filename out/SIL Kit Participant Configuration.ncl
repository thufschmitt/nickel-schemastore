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
          Description
            | doc m%"
            Free text commenting on or summarizing this configuration. Optional
            "%
            = String,
          FlexrayClusterParameters = {
                gColdstartAttempts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 31,
                    predicates.numbers.minimum 2
                  ])
                  | doc m%"
                  Number of attempts for a cold start before giving up (range 2-31)
                  "%
                  | optional,
                gCycleCountMax
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 63,
                    predicates.numbers.minimum 7
                  ])
                  | doc m%"
                  Max cycle count value in a given cluster (range 7-63, must be an odd integer)
                  "%
                  | optional,
                gListenNoise
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 16,
                    predicates.numbers.minimum 2
                  ])
                  | doc m%"
                  Upper limit for the startup listen timeout and wakeup listen timeout in the presence of noise; Used as a multiplier of pdListenTimeout (range 2 - 16)
                  "%
                  | optional,
                gMacroPerCycle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 16000,
                    predicates.numbers.minimum 8
                  ])
                  | doc m%"
                  Number of macroticks per cycle (range 8 - 16000)
                  "%
                  | optional,
                gMaxWithoutClockCorrectionFatal
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 15,
                    predicates.numbers.minimum 1
                  ])
                  | doc m%"
                  Threshold used for testing the vClockCorrectionFailed counter (range 1 - 15)
                  "%
                  | optional,
                gMaxWithoutClockCorrectionPassive
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 15,
                    predicates.numbers.minimum 1
                  ])
                  | doc m%"
                  Threshold used for testing the vClockCorrectionFailed counter (range 1 - 15)
                  "%
                  | optional,
                gNumberOfMiniSlots
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 7988,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Number of mini slots (range 0 - 7988)
                  "%
                  | optional,
                gNumberOfStaticSlots
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 1023,
                    predicates.numbers.minimum 2
                  ])
                  | doc m%"
                  Number of static slots in a cycle (range 2 - 1023)
                  "%
                  | optional,
                gPayloadLengthStatic
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 127,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Length of the payload of a static frame in 16-Bits words (range 0 - 127)
                  "%
                  | optional,
                gSyncFrameIDCountMax
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 15,
                    predicates.numbers.minimum 2
                  ])
                  | doc m%"
                  Maximum number of distinct sync frame identifiers present in a given cluster (range 2 - 15)
                  "%
                  | optional,
                gdActionPointOffset
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 63,
                    predicates.numbers.minimum 1
                  ])
                  | doc m%"
                  Time offset for a static slot in macroticks (range 1 - 63)
                  "%
                  | optional,
                gdDynamicSlotIdlePhase
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 2,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Duration of the idle phase within a dynamic slot in gdMiniSlots (range 0 - 2)
                  "%
                  | optional,
                gdMiniSlot
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 63,
                    predicates.numbers.minimum 2
                  ])
                  | doc m%"
                  Duration of a mini slot in macroticks (2 - 63)
                  "%
                  | optional,
                gdMiniSlotActionPointOffset
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 31,
                    predicates.numbers.minimum 1
                  ])
                  | doc m%"
                  Time offset for a mini slot in macroticks (range 1- 31)
                  "%
                  | optional,
                gdStaticSlot
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 664,
                    predicates.numbers.minimum 3
                  ])
                  | doc m%"
                  Duration of a static slot in macroticks (range 3 - 664)
                  "%
                  | optional,
                gdSymbolWindow
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 162,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Duration of the symbol window in macroticks (range 0 - 162)
                  "%
                  | optional,
                gdSymbolWindowActionPointOffset
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 63,
                    predicates.numbers.minimum 1
                  ])
                  | doc m%"
                  Time offset for a static symbol windows in macroticks (range 1 - 63)
                  "%
                  | optional,
                gdTSSTransmitter
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 15,
                    predicates.numbers.minimum 1
                  ])
                  | doc m%"
                  Duration of TSS (Transmission Start Sequence) in gdBits (range 1 - 15)
                  "%
                  | optional,
                gdWakeupTxActive
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 60,
                    predicates.numbers.minimum 15
                  ])
                  | doc m%"
                  Duration of LOW Phase of a wakeup symbol in gdBit (range 15 - 60)
                  "%
                  | optional,
                gdWakeupTxIdle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 180,
                    predicates.numbers.minimum 45
                  ])
                  | doc m%"
                  Duration of the idle of a wakeup symbol in gdBit (45 - 180)
                  "%
                  | optional,
                ..
              },
          FlexrayController = {
                ClusterParameters
                  | definitions.contract.FlexrayClusterParameters
                  | optional,
                Name | definitions.contract.Name,
                Network | definitions.contract.Network | optional,
                NodeParameters
                  | definitions.contract.FlexrayNodeParameters
                  | optional,
                Replay | definitions.contract.Replay | optional,
                TxBufferConfigurations
                  | definitions.contract.FlexrayTxBufferConfigurations
                  | optional,
                UseTraceSinks | definitions.contract.UseTraceSinks | optional,
              },
          FlexrayControllers
            | doc m%"
            Reconfigures the FlexrayControllers of the participant
            "%
            = predicates.contract_from_predicate
              definitions.predicate.FlexrayControllers,
          FlexrayNodeParameters = {
                pAllowHaltDueToClock
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Controls the transition to halt state due to clock synchronization errors. (values 0, 1)
                  "%
                  | optional,
                pAllowPassiveToActive
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 31,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Required number of consecutive even / odd cycle pairs for normal passive to normal active (range 0 - 31)
                  "%
                  | optional,
                pChannels
                  | std.enum.TagOrString
                  | [| 'None, 'AB, 'B, 'A |]
                  | doc m%"
                  Channel(s) to which the controller is connected
                  "%
                  | optional,
                pClusterDriftDamping
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 10,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Cluster drift damping factor for rate correction in microticks (range 0 - 10)
                  "%
                  | optional,
                pKeySlotId
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 1023,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Slot ID of the key slot (range 0 - 1023; value 0 means that there is no key slot)
                  "%
                  | optional,
                pKeySlotOnlyEnabled
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Shall the node enter key slot only mode after startup. (values 0, 1) (AUTOSAR pSingleSlotEnabled)
                  "%
                  | optional,
                pKeySlotUsedForStartup
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Key slot is used for startup (values 0, 1)
                  "%
                  | optional,
                pKeySlotUsedForSync
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Key slot is used for sync (values 0, 1)
                  "%
                  | optional,
                pLatestTx
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 7988,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Last mini slot which can be transmitted (range 0 - 7988)
                  "%
                  | optional,
                pMacroInitialOffsetA
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 68,
                    predicates.numbers.minimum 2
                  ])
                  | doc m%"
                  Initial startup offset for frame reference point on channel A (range 2 - 68 macroticks)
                  "%
                  | optional,
                pMacroInitialOffsetB
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 68,
                    predicates.numbers.minimum 2
                  ])
                  | doc m%"
                  Initial startup offset for frame reference point on channel B (range 2 - 68 macroticks)
                  "%
                  | optional,
                pMicroInitialOffsetA
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 239,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Offset between secondary time reference and MT boundary (range 0 - 239 microticks)
                  "%
                  | optional,
                pMicroInitialOffsetB
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 239,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Offset between secondary time reference and MT boundary (range 0 - 239 microticks)
                  "%
                  | optional,
                pMicroPerCycle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 1280000,
                    predicates.numbers.minimum 960
                  ])
                  | doc m%"
                  Nominal number of microticks in the communication cycle (range 960 - 1280000)
                  "%
                  | optional,
                pOffsetCorrectionOut
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 16082,
                    predicates.numbers.minimum 15
                  ])
                  | doc m%"
                  Maximum permissible offset correction value (range 15 - 16082 microticks)
                  "%
                  | optional,
                pOffsetCorrectionStart
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 15999,
                    predicates.numbers.minimum 7
                  ])
                  | doc m%"
                  Start of the offset correction phase within the NIT, (7 - 15999 macroticks)
                  "%
                  | optional,
                pRateCorrectionOut
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 3846,
                    predicates.numbers.minimum 3
                  ])
                  | doc m%"
                  Maximum permissible rate correction value (range 3 - 3846 microticks)
                  "%
                  | optional,
                pSamplesPerMicrotick
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 2,
                    predicates.numbers.minimum 1
                  ])
                  | doc m%"
                  Number of samples per microtick (values 1, 2)
                  "%
                  | optional,
                pWakeupChannel
                  | std.enum.TagOrString
                  | [| 'B, 'A |]
                  | doc m%"
                  Channel used by the node to send a wakeup pattern
                  "%
                  | optional,
                pWakeupPattern
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 63,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Number of repetitions of the wakeup symbol (range 0 - 63, value 0 or 1 prevents sending of WUP)
                  "%
                  | optional,
                pdAcceptedStartupRange
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 2743,
                    predicates.numbers.minimum 29
                  ])
                  | doc m%"
                  Allowed deviation for startup frames during integration in microticks (range 29 - 2743)
                  "%
                  | optional,
                pdListenTimeout
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 2567692,
                    predicates.numbers.minimum 1926
                  ])
                  | doc m%"
                  Duration of listen phase in microticks (range 1926 - 2567692)
                  "%
                  | optional,
                pdMicrotick
                  | std.enum.TagOrString
                  | [| '"50ns", '"25ns", '"12.5ns" |]
                  | doc m%"
                  Duration of a FlexRay microtick
                  "%
                  | optional,
                ..
              },
          FlexrayTxBufferConfigurations = predicates.contract_from_predicate
              definitions.predicate.FlexrayTxBufferConfigurations,
          Logging
            | doc m%"
            Configures the properties of the SIL Kit Logging Service
            "%
            = {
                FlushLevel
                  | std.enum.TagOrString
                  | [| 'Off, 'Trace, 'Debug, 'Info, 'Warn, 'Error, 'Critical |]
                  | optional,
                LogFromRemotes
                  | Bool
                  | doc m%"
                  Enables receiving of remote log messages from other participants
                  "%
                  | optional,
                Sinks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "Type" ],
                      predicates.records.record
                      {
                        Level = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum
                              [
                                "Critical",
                                "Error",
                                "Warn",
                                "Info",
                                "Debug",
                                "Trace",
                                "Off"
                              ]
                            ],
                        LogName = predicates.isType '"String",
                        Type = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum [ "Remote", "File", "Stdout" ]
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ]),
              },
          Name
            | doc m%"
            Name of the endpoint
            "%
            = String,
          Network
            | doc m%"
            Name of the network. Optional; Defaults to the endpoint name
            "%
            = String,
          Replay = {
                Direction
                  | std.enum.TagOrString
                  | [| 'Both, 'Receive, 'Send |]
                  | doc m%"
                  Filter messages to use from the trace source by their direction. May be Send, Receive or Both
                  "%
                  | optional,
                MdfChannel
                  | {
                    ChannelName
                      | String
                      | doc m%"
                      Name of an MDF channel in the trace source
                      "%
                      | optional,
                    ChannelPath
                      | String
                      | doc m%"
                      Path of an MDF channel's source information object
                      "%
                      | optional,
                    ChannelSource
                      | String
                      | doc m%"
                      Name of an MDF channel's source information object
                      "%
                      | optional,
                    GroupName
                      | String
                      | doc m%"
                      Name of an MDF channel group
                      "%
                      | optional,
                    GroupPath
                      | String
                      | doc m%"
                      Path of an MDF channel group's source information object
                      "%
                      | optional,
                    GroupSource
                      | String
                      | doc m%"
                      Name of an MDF channel group's source information object
                      "%
                      | optional,
                    ..
                  }
                  | optional,
                UseTraceSource
                  | String
                  | doc m%"
                  Name of a trace source used as a simulation message source for this controller
                  "%
                  | optional,
                ..
              },
          RpcFunctionName
            | doc m%"
            Name of the RPC function called by RpcClients on RpcServers
            "%
            = String,
          Topic
            | doc m%"
            Name of the communication channel between DataPublisher and DataSubscribers
            "%
            = String,
          UseTraceSinks
            | doc m%"
            Names of trace sinks to use
            "%
            = Array Dyn,
        },
    predicate = {
          Description
            | doc m%"
            Free text commenting on or summarizing this configuration. Optional
            "%
            = predicates.isType '"String",
          FlexrayClusterParameters = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  gColdstartAttempts = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 31,
                        predicates.numbers.minimum 2
                      ],
                  gCycleCountMax = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 63,
                        predicates.numbers.minimum 7
                      ],
                  gListenNoise = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 16,
                        predicates.numbers.minimum 2
                      ],
                  gMacroPerCycle = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 16000,
                        predicates.numbers.minimum 8
                      ],
                  gMaxWithoutClockCorrectionFatal = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 15,
                        predicates.numbers.minimum 1
                      ],
                  gMaxWithoutClockCorrectionPassive = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 15,
                        predicates.numbers.minimum 1
                      ],
                  gNumberOfMiniSlots = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 7988,
                        predicates.numbers.minimum 0
                      ],
                  gNumberOfStaticSlots = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 1023,
                        predicates.numbers.minimum 2
                      ],
                  gPayloadLengthStatic = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 127,
                        predicates.numbers.minimum 0
                      ],
                  gSyncFrameIDCountMax = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 15,
                        predicates.numbers.minimum 2
                      ],
                  gdActionPointOffset = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 63,
                        predicates.numbers.minimum 1
                      ],
                  gdDynamicSlotIdlePhase = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 2,
                        predicates.numbers.minimum 0
                      ],
                  gdMiniSlot = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 63,
                        predicates.numbers.minimum 2
                      ],
                  gdMiniSlotActionPointOffset = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 31,
                        predicates.numbers.minimum 1
                      ],
                  gdStaticSlot = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 664,
                        predicates.numbers.minimum 3
                      ],
                  gdSymbolWindow = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 162,
                        predicates.numbers.minimum 0
                      ],
                  gdSymbolWindowActionPointOffset = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 63,
                        predicates.numbers.minimum 1
                      ],
                  gdTSSTransmitter = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 15,
                        predicates.numbers.minimum 1
                      ],
                  gdWakeupTxActive = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 60,
                        predicates.numbers.minimum 15
                      ],
                  gdWakeupTxIdle = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 180,
                        predicates.numbers.minimum 45
                      ],
                }
                {  }
                true
                predicates.always
              ],
          FlexrayController = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "Name" ],
                predicates.records.record
                {
                  ClusterParameters =
                    definitions.predicate.FlexrayClusterParameters,
                  Name = definitions.predicate.Name,
                  Network = definitions.predicate.Network,
                  NodeParameters = definitions.predicate.FlexrayNodeParameters,
                  Replay = definitions.predicate.Replay,
                  TxBufferConfigurations =
                    definitions.predicate.FlexrayTxBufferConfigurations,
                  UseTraceSinks = definitions.predicate.UseTraceSinks,
                }
                {  }
                false
                predicates.never
              ],
          FlexrayControllers
            | doc m%"
            Reconfigures the FlexrayControllers of the participant
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.FlexrayController
              ],
          FlexrayNodeParameters = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  pAllowHaltDueToClock = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  pAllowPassiveToActive = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 31,
                        predicates.numbers.minimum 0
                      ],
                  pChannels = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "A", "B", "AB", "None" ]
                      ],
                  pClusterDriftDamping = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 10,
                        predicates.numbers.minimum 0
                      ],
                  pKeySlotId = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 1023,
                        predicates.numbers.minimum 0
                      ],
                  pKeySlotOnlyEnabled = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  pKeySlotUsedForStartup = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  pKeySlotUsedForSync = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  pLatestTx = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 7988,
                        predicates.numbers.minimum 0
                      ],
                  pMacroInitialOffsetA = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 68,
                        predicates.numbers.minimum 2
                      ],
                  pMacroInitialOffsetB = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 68,
                        predicates.numbers.minimum 2
                      ],
                  pMicroInitialOffsetA = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 239,
                        predicates.numbers.minimum 0
                      ],
                  pMicroInitialOffsetB = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 239,
                        predicates.numbers.minimum 0
                      ],
                  pMicroPerCycle = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 1280000,
                        predicates.numbers.minimum 960
                      ],
                  pOffsetCorrectionOut = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 16082,
                        predicates.numbers.minimum 15
                      ],
                  pOffsetCorrectionStart = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 15999,
                        predicates.numbers.minimum 7
                      ],
                  pRateCorrectionOut = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 3846,
                        predicates.numbers.minimum 3
                      ],
                  pSamplesPerMicrotick = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 2,
                        predicates.numbers.minimum 1
                      ],
                  pWakeupChannel = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "A", "B" ]
                      ],
                  pWakeupPattern = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 63,
                        predicates.numbers.minimum 0
                      ],
                  pdAcceptedStartupRange = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 2743,
                        predicates.numbers.minimum 29
                      ],
                  pdListenTimeout = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 2567692,
                        predicates.numbers.minimum 1926
                      ],
                  pdMicrotick = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "12.5ns", "25ns", "50ns" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          FlexrayTxBufferConfigurations = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    PPindicator = predicates.isType '"Bool",
                    channels = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "A", "B", "AB", "None" ]
                        ],
                    headerCrc = predicates.isType 'Integer,
                    offset = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.maximum 63,
                          predicates.numbers.minimum 0
                        ],
                    repetition = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.maximum 64,
                          predicates.numbers.minimum 0
                        ],
                    slotId = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.maximum 65535,
                          predicates.numbers.minimum 0
                        ],
                    transmissionMode = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "SingleShot", "Continuous" ]
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          Logging
            | doc m%"
            Configures the properties of the SIL Kit Logging Service
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "Sinks" ],
                predicates.records.record
                {
                  FlushLevel = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Critical",
                          "Error",
                          "Warn",
                          "Info",
                          "Debug",
                          "Trace",
                          "Off"
                        ]
                      ],
                  LogFromRemotes = predicates.isType '"Bool",
                  Sinks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "Type" ],
                          predicates.records.record
                          {
                            Level = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum
                                  [
                                    "Critical",
                                    "Error",
                                    "Warn",
                                    "Info",
                                    "Debug",
                                    "Trace",
                                    "Off"
                                  ]
                                ],
                            LogName = predicates.isType '"String",
                            Type = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "Remote", "File", "Stdout" ]
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Name
            | doc m%"
            Name of the endpoint
            "%
            = predicates.isType '"String",
          Network
            | doc m%"
            Name of the network. Optional; Defaults to the endpoint name
            "%
            = predicates.isType '"String",
          Replay = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  Direction = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Send", "Receive", "Both" ]
                      ],
                  MdfChannel = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          ChannelName = predicates.isType '"String",
                          ChannelPath = predicates.isType '"String",
                          ChannelSource = predicates.isType '"String",
                          GroupName = predicates.isType '"String",
                          GroupPath = predicates.isType '"String",
                          GroupSource = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  UseTraceSource = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          RpcFunctionName
            | doc m%"
            Name of the RPC function called by RpcClients on RpcServers
            "%
            = predicates.isType '"String",
          Topic
            | doc m%"
            Name of the communication channel between DataPublisher and DataSubscribers
            "%
            = predicates.isType '"String",
          UseTraceSinks
            | doc m%"
            Names of trace sinks to use
            "%
            = predicates.isType '"Array",
        },
  }
in

{
  "$schema"
    | String
    | doc m%"
    The schema file
    "%
    | optional,
  CanControllers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "Name" ],
        predicates.records.record
        {
          Name = definitions.predicate.Name,
          Network = definitions.predicate.Network,
          Replay = definitions.predicate.Replay,
          UseTraceSinks = definitions.predicate.UseTraceSinks,
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Reconfigures the CanControllers of the participant
    "%
    | optional,
  DataPublishers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "Name" ],
        predicates.records.record
        {
          Name = definitions.predicate.Name,
          Topic = definitions.predicate.Topic,
          UseTraceSinks = definitions.predicate.UseTraceSinks,
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Reconfigures the DataPublishers of the participant
    "%
    | optional,
  DataSubscribers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "Name" ],
        predicates.records.record
        {
          Name = definitions.predicate.Name,
          Topic = definitions.predicate.Topic,
          UseTraceSinks = definitions.predicate.UseTraceSinks,
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Reconfigures the DataSubscribers of the participant
    "%
    | optional,
  Description | definitions.contract.Description | optional,
  EthernetControllers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "Name" ],
        predicates.records.record
        {
          Name = definitions.predicate.Name,
          Network = definitions.predicate.Network,
          Replay = definitions.predicate.Replay,
          UseTraceSinks = definitions.predicate.UseTraceSinks,
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Reconfigures the EthernetControllers of the participant
    "%
    | optional,
  Extensions
    | {
      SearchPathHints
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | optional,
    }
    | doc m%"
    Optional configuration for the extension loading mechanism
    "%
    | optional,
  FlexrayControllers | definitions.contract.FlexrayControllers | optional,
  HealthCheck
    | {
      HardResponseTimeout
        | std.number.Integer
        | doc m%"
        If a simulation step is not finished before this limit, the participant enters error state. Optional; Unit is in milliseconds
        "%
        | optional,
      SoftResponseTimeout
        | std.number.Integer
        | doc m%"
        If a simulation step is not finished before this limit, a warning is logged. Optional; Unit is in milliseconds
        "%
        | optional,
    }
    | doc m%"
    Node to configure properties to determine the health status of the simulation
    "%
    | optional,
  LinControllers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "Name" ],
        predicates.records.record
        {
          Name = definitions.predicate.Name,
          Network = definitions.predicate.Network,
          Replay = definitions.predicate.Replay,
          UseTraceSinks = definitions.predicate.UseTraceSinks,
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Reconfigures the LinControllers of the participant
    "%
    | optional,
  Logging | definitions.contract.Logging | optional,
  Middleware
    | {
      ConnectAttempts | std.number.Integer | optional,
      RegistryUri | String | optional,
      TcpNoDelay | Bool | optional,
      TcpQuickAck | Bool | optional,
      TcpReceiveBufferSize | std.number.Integer | optional,
      TcpSendBufferSize | std.number.Integer | optional,
    }
    | doc m%"
    Optional configuration of the SIL Kit middleware
    "%
    | optional,
  ParticipantName
    | String
    | doc m%"
    Name of the participant
    "%
    | optional,
  RpcClients
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "Name" ],
        predicates.records.record
        {
          FunctionName = definitions.predicate.RpcFunctionName,
          Name = definitions.predicate.Name,
          UseTraceSinks = definitions.predicate.UseTraceSinks,
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Reconfigures the RpcClients of the participant
    "%
    | optional,
  RpcServers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "Name" ],
        predicates.records.record
        {
          FunctionName = definitions.predicate.RpcFunctionName,
          Name = definitions.predicate.Name,
          UseTraceSinks = definitions.predicate.UseTraceSinks,
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Reconfigures the RpcServers of the participant
    "%
    | optional,
  Tracing
    | {
      TraceSinks
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              Name = predicates.isType '"String",
              OutputPath = predicates.isType '"String",
              Type = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ "PcapFile", "PcapPipe", "Mdf4File" ]
                  ],
            }
            {  }
            false
            predicates.never
          ])
        ])
        | optional,
      TraceSources
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              InputPath = predicates.isType '"String",
              Name = predicates.isType '"String",
              Type = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ "PcapFile", "PcapPipe", "Mdf4File" ]
                  ],
            }
            {  }
            false
            predicates.never
          ])
        ])
        | optional,
      ..
    }
    | doc m%"
    Configures the tracing service of the participant
    "%
    | optional,
  schemaVersion
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ predicates.isType 'Integer, predicates.isType '"String" ])
    | doc m%"
    Version of the schema used to validate this document
    "%
    | optional,
}