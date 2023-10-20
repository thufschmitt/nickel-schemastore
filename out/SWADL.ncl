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
          active
            | doc m%"
            If false, the room is not active anymore.
            "%
            = predicates.contract_from_predicate definitions.predicate.active,
          activity-completed-event = {
                activity-completed
                  | predicates.contract_from_predicate
                  definitions.predicate.activity-completed-event-inner
                  | doc m%"
                  Generated when the given activity is completed. Note this is not a Datafeed real-time event.
                  "%,
                "if"
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^\\$\\{.*\\}$"
                  ])
                  | optional,
                ..
              },
          activity-completed-event-inner = {
                activity-id
                  | definitions.contract.id
                  | doc m%"
                  The completed (without errors) activity triggering this event.
                  "%,
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                  ])
                  | doc m%"
                  Event's identifier, should be unique across workflow. As it can be used as a variable identifier only alphanumerical characters are allowed.
                  "%
                  | optional,
                ..
              },
          activity-expired-event = {
                activity-expired
                  | definitions.contract.activity-expired-event-inner
                  | doc m%"
                  Generated when the given activity event timeout has expired. Note this is not a Datafeed real-time event.
                  "%,
                ..
              },
          activity-expired-event-inner = {
                activity-id
                  | definitions.contract.id
                  | doc m%"
                  The expiring activity triggering this event.
                  "%,
                ..
              },
          activity-failed-event = {
                activity-failed
                  | definitions.contract.activity-failed-event-inner
                  | doc m%"
                  Generated when the given activity has failed. Note this is not a Datafeed real-time event.
                  "%,
                ..
              },
          activity-failed-event-inner = {
                activity-id
                  | definitions.contract.id
                  | doc m%"
                  The failing activity triggering this event.
                  "%,
                ..
              },
          add-group-member-inner = {
                group-id | definitions.contract.group-id,
                members
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.oneOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.group-member,
                        predicates.arrays.uniqueItems
                      ],
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1,
                        predicates.strings.pattern "^\\$\\{.*\\}$"
                      ],
                      predicates.enum [ "${variables.VARIABLE_NAME}" ]
                    ]
                  ])
                  | optional,
                ..
              },
          add-room-member-inner = {
                obo
                  | definitions.contract.obo-inner
                  | doc m%"
                  Defines whether the activity will be executed on behalf of a user and the user on whose behalf the call will be made
                  "%
                  | optional,
                stream-id
                  | definitions.contract.stream-id-inner
                  | doc m%"
                  Stream id where to add user(s).
                  "%,
                user-ids
                  | definitions.contract.user-ids-inner
                  | doc m%"
                  User ids to add to the room.
                  "%,
                ..
              },
          all-of-event = {
                all-of
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.form-replied-event,
                      definitions.predicate.activity-completed-event,
                      definitions.predicate.activity-failed-event,
                      definitions.predicate.message-received-event,
                      definitions.predicate.request-received-event,
                      definitions.predicate.message-suppressed-event,
                      definitions.predicate.post-shared-event,
                      definitions.predicate.im-created-event,
                      definitions.predicate.room-created-event,
                      definitions.predicate.room-updated-event,
                      definitions.predicate.room-deactivated-event,
                      definitions.predicate.room-reactivated-event,
                      definitions.predicate.room-member-promoted-to-owner-event,
                      definitions.predicate.room-member-demoted-from-owner-event,
                      definitions.predicate.user-joined-room-event,
                      definitions.predicate.user-left-room-event,
                      definitions.predicate.user-requested-join-room-event,
                      definitions.predicate.connection-requested-event,
                      definitions.predicate.connection-accepted-event,
                      definitions.predicate.timer-fired-event
                    ])
                  ])
                  | doc m%"
                  Used to receive all listed events.
                  "%,
                ..
              },
          at = predicates.contract_from_predicate definitions.predicate.at,
          attachment = predicates.contract_from_predicate
              definitions.predicate.attachment,
          attachment-file = {
                content-path
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.enum [ "${variables.VARIABLE_NAME}" ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]
                  ])
                  | doc m%"
                  Path to the file to be attached to the message. The path is relative to the workflows folder.
                  "%,
                ..
              },
          attachment-message = {
                attachment-id
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.enum [ "${variables.VARIABLE_NAME}" ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]
                  ])
                  | doc m%"
                  Attachment id to forward. If not set, all attachments in the provided message are forwarded. Both url safe and base64 encoded urls are accepted.
                  "%
                  | optional,
                message-id
                  | definitions.contract.message-id-inner
                  | doc m%"
                  Message id having the attachment to forward. Both url safe and base64 encoded urls are accepted.
                  "%,
                ..
              },
          basic-activity-inner
            | doc m%"
            Inner property having common properties for every activity.
            "%
            = {
                "else"
                  | {  .. }
                  | doc m%"
                  Default execution of the activity when if conditions are used for previous activities.
                  "%
                  | optional,
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                  ])
                  | doc m%"
                  Activity's identifier, should be unique across workflow. As it can be used as a variable identifier only alphanumerical characters are allowed.
                  "%,
                "if"
                  | String
                  | doc m%"
                  Conditional execution of the activity based on a boolean expression.
                  "%
                  | optional,
                on | definitions.contract.on | optional,
                ..
              },
          business
            | doc m%"
            Business information
            "%
            = {
                asset-classes
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Equities",
                          "Cash Equities",
                          "Securities Lending",
                          "Fixed Income",
                          "Government Bonds",
                          "Prime Brokerage",
                          "Commodities",
                          "Municipal Bonds",
                          "Currencies",
                          "Corporate Bonds"
                        ]
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | doc m%"
                  The user's asset classes (one or more).
                  "%
                  | optional,
                company-name
                  | String
                  | doc m%"
                  The user's company name.
                  If not specified, it is set with the default company name.
                  "%
                  | optional,
                department
                  | String
                  | doc m%"
                  The user's department.
                  "%
                  | optional,
                division
                  | String
                  | doc m%"
                  The user's division.
                  "%
                  | optional,
                functions
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Collateral",
                          "Confirmation",
                          "Trade Processing",
                          "Pre-Matching",
                          "Margin",
                          "Matching",
                          "Claims Processing",
                          "Middle Office",
                          "Liquidity Management",
                          "Allocation",
                          "Trade Management",
                          "Regulatory Outreach",
                          "Settlements",
                          "Post Trade Management"
                        ]
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | doc m%"
                  The user's job functions (one or more).
                  "%
                  | optional,
                industries
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Healthcare",
                          "Consumer Non-Cyclicals",
                          "Transportation",
                          "Technology",
                          "Real Estate",
                          "Basic Materials",
                          "Financials",
                          "Energy & Utilities",
                          "Conglomerates",
                          "Consumer Cyclicals",
                          "Services"
                        ]
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | doc m%"
                  The user's job industries (one or more).
                  "%
                  | optional,
                instruments
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "Securities", "Fixed Income", "Equities" ]
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | doc m%"
                  The user's instruments (one or more).
                  "%
                  | optional,
                job-function
                  | std.enum.TagOrString
                  | [|
                    'Trader,
                    'Strategist,
                    'Sales,
                    '"Research Analyst",
                    '"Project Manager",
                    '"Portfolio Manager",
                    'Economist,
                    'Director,
                    'Developer,
                    '"Corporate Access",
                    '"Business Development Executive",
                    'Other,
                    'Analyst
                  |]
                  | doc m%"
                  The user's job function.
                  "%
                  | optional,
                location
                  | String
                  | doc m%"
                  The user's location.
                  "%
                  | optional,
                market-coverages
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "EMEA", "NA", "APAC", "LATAM" ]
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | doc m%"
                  The user's market coverage (one or more).
                  "%
                  | optional,
                responsibilities
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "BAU", "Escalation" ]
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | doc m%"
                  The user's responsibilities (one or more).
                  "%
                  | optional,
                title
                  | String
                  | doc m%"
                  The user's title.
                  "%
                  | optional,
              },
          connection-accepted-event = {
                connection-accepted
                  | predicates.contract_from_predicate
                  definitions.predicate.connection-accepted-event-inner
                  | doc m%"
                  Generated when a connection request is accepted, either sent by the workflow bot and accepted by another user or sent by another user and accepted by the workflow bot.
                  "%,
                ..
              },
          connection-accepted-event-inner = {  .. },
          connection-inner = {
                obo
                  | definitions.contract.obo-inner
                  | doc m%"
                  Defines whether the activity will be executed on behalf of a user and the user on whose behalf the call will be made
                  "%
                  | optional,
                user-id | definitions.contract.user-id,
                ..
              },
          connection-requested-event = {
                connection-requested
                  | predicates.contract_from_predicate
                  definitions.predicate.connection-requested-event-inner
                  | doc m%"
                  Generated when a connection request is sent, either by the workflow bot to another user or to the workflow bot by another user.
                  "%,
                ..
              },
          connection-requested-event-inner = {  .. },
          content-inner
            | doc m%"
            The content of the message in MessageML format. Must contain at least one space. In case the content is a form, this latter's id should be the same as the activity one.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.content-inner,
          copy-protected
            | doc m%"
            If true, users cannot copy content from this room.
            Note: Once this value is set to true for a room, it is read-only and can’t be updated.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.copy-protected,
          create-group-inner = {
                members
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.oneOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.group-member,
                        predicates.arrays.uniqueItems
                      ],
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1,
                        predicates.strings.pattern "^\\$\\{.*\\}$"
                      ],
                      predicates.enum [ "${variables.VARIABLE_NAME}" ]
                    ]
                  ])
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Group's name.
                  "%
                  | optional,
                owner
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    definitions.predicate.group-owner
                  ])
                  | optional,
                profile | definitions.contract.group-profile | optional,
                referrer
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Symphony, referring company name, referring channel partner name.
                  "%
                  | optional,
                sub-type
                  | std.enum.TagOrString
                  | [| 'CHANNEL, 'COMMUNITY |]
                  | doc m%"
                  The type of the company new groupType.
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Group type identifier (for instance SDL).
                  "%
                  | optional,
                ..
              },
          create-room-inner = predicates.contract_from_predicate
              definitions.predicate.create-room-inner,
          create-system-user-inner = {
                business
                  | definitions.contract.business
                  | doc m%"
                  User's business information.
                  "%
                  | optional,
                display-name
                  | definitions.contract.name
                  | doc m%"
                  User's display name.
                  "%
                  | optional,
                email
                  | definitions.contract.email
                  | doc m%"
                  Email address, must be unique
                  "%
                  | optional,
                entitlements
                  | definitions.contract.entitlements-inner
                  | doc m%"
                  User entitlements.
                  "%
                  | optional,
                keys
                  | {
                    current | definitions.contract.key-inner | optional,
                    previous | definitions.contract.key-inner | optional,
                    ..
                  }
                  | doc m%"
                  For SYSTEM users, to set up the RSA keys for authentication.
                  "%
                  | optional,
                roles
                  | predicates.contract_from_predicate
                  definitions.predicate.roles-inner
                  | doc m%"
                  The roles object consists of the following possibilities:
                  For end-user accounts: INDIVIDUAL, ADMINISTRATOR, SUPER_ADMINISTRATOR, L1_SUPPORT, L2_SUPPORT, COMPLIANCE_OFFICER, SUPER_COMPLIANCE_OFFICER
                  For service accounts: INDIVIDUAL, USER_PROVISIONING, SCOPE_MANAGEMENT, CONTENT_MANAGEMENT, MALWARE_SCAN_MANAGER, MALWARE_SCAN_STATE_USER, AUDIT_TRAIL_MANAGEMENT
                  "%
                  | optional,
                status
                  | std.enum.TagOrString
                  | [| 'DISABLED, 'ENABLED |]
                  | doc m%"
                  User status: ENABLED or DISABLED.
                  "%
                  | optional,
                username
                  | definitions.contract.name
                  | doc m%"
                  User's username.
                  "%
                  | optional,
                ..
              },
          create-user-inner = {
                business
                  | definitions.contract.business
                  | doc m%"
                  User's business information.
                  "%
                  | optional,
                contact
                  | {
                    mobile-phone-number
                      | definitions.contract.phoneNumber
                      | doc m%"
                      User's mobile phone number.
                      "%
                      | optional,
                    sms-number
                      | definitions.contract.phoneNumber
                      | doc m%"
                      User's sms phone number.
                      "%
                      | optional,
                    two-factor-auth-number
                      | definitions.contract.phoneNumber
                      | doc m%"
                      User's two factor auth number.
                      "%
                      | optional,
                    work-phone-number
                      | definitions.contract.phoneNumber
                      | doc m%"
                      User's work phone number.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Contact information
                  "%
                  | optional,
                display-name
                  | definitions.contract.name
                  | doc m%"
                  User's display name.
                  "%
                  | optional,
                email
                  | definitions.contract.email
                  | doc m%"
                  Email address, must be unique.
                  "%
                  | optional,
                entitlements
                  | definitions.contract.entitlements-inner
                  | doc m%"
                  User entitlements.
                  "%
                  | optional,
                firstname
                  | definitions.contract.name
                  | doc m%"
                  User's first name.
                  "%
                  | optional,
                lastname
                  | definitions.contract.name
                  | doc m%"
                  User's last name.
                  "%
                  | optional,
                password
                  | {
                    hashed-km-password
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ])
                      | doc m%"
                      A base64-encoded string. The hashed password to be used for authenticating to the key manager.
                      "%
                      | optional,
                    hashed-km-salt
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ])
                      | doc m%"
                      A base64-encoded string. The salt used for hashing the khPassword.
                      "%
                      | optional,
                    hashed-password
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ])
                      | doc m%"
                      A base64-encoded string. The hashed password. This is the hashed version of the password the user would use to login.
                      "%,
                    hashed-salt
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ])
                      | doc m%"
                      A base64-encoded string. The salt used for hashing the hPassword.
                      "%,
                  }
                  | doc m%"
                  User's password. The password object is optional for end-user accounts (NORMAL). For example, if your organization utilizes SSO, you may not want to specify the password.
                  "%
                  | optional,
                recommended-language
                  | String
                  | doc m%"
                  The recommended language. As an ISO 639-1 code.
                  "%
                  | optional,
                roles
                  | predicates.contract_from_predicate
                  definitions.predicate.roles-inner
                  | doc m%"
                  The roles object consists of the following possibilities:
                  For end-user accounts: INDIVIDUAL, ADMINISTRATOR, SUPER_ADMINISTRATOR, L1_SUPPORT, L2_SUPPORT, COMPLIANCE_OFFICER, SUPER_COMPLIANCE_OFFICER
                  For service accounts: INDIVIDUAL, USER_PROVISIONING, SCOPE_MANAGEMENT, CONTENT_MANAGEMENT, MALWARE_SCAN_MANAGER, MALWARE_SCAN_STATE_USER, AUDIT_TRAIL_MANAGEMENT
                  "%
                  | optional,
                status
                  | std.enum.TagOrString
                  | [| 'DISABLED, 'ENABLED |]
                  | doc m%"
                  User status: ENABLED or DISABLED.
                  "%
                  | optional,
                username
                  | definitions.contract.name
                  | doc m%"
                  Unique identifier for the user.
                  "%
                  | optional,
                ..
              },
          cross-pod
            | doc m%"
            If true, this room is a cross-pod room.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.cross-pod,
          demote-room-owner-inner = {
                obo
                  | definitions.contract.obo-inner
                  | doc m%"
                  Defines whether the activity will be executed on behalf of a user and the user on whose behalf the call will be made
                  "%
                  | optional,
                stream-id
                  | definitions.contract.stream-id-inner
                  | doc m%"
                  Stream id where to demote user.
                  "%,
                user-ids
                  | definitions.contract.user-ids-inner
                  | doc m%"
                  User ids to demote in the room.
                  "%,
                ..
              },
          discoverable
            | doc m%"
            If true, this chat room (name, description and messages) non-participants can search for this room. If false, only participants can search for this room.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.discoverable,
          email
            | doc m%"
            Email address, must be unique
            "%
            = predicates.contract_from_predicate definitions.predicate.email,
          entitlements-inner
            | doc m%"
            Feature entitlements to configure for the user.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.entitlements-inner,
          execute-request-inner = {
                body
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType 'Record ])
                  | optional,
                encode-query-params
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  If enabled, the query parameters will be encoded in application/x-www-form-urlencoded
                  "%
                  | optional,
                headers
                  | {  .. }
                  | doc m%"
                  HTTP request headers
                  "%
                  | optional,
                method
                  | std.enum.TagOrString
                  | [| 'OPTIONS, 'HEAD, 'PATCH, 'DELETE, 'PUT, 'POST, 'GET |]
                  | doc m%"
                  HTTP method to perform
                  "%
                  | optional,
                url
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Contains the host and the path to be targeted
                  "%,
                ..
              },
          execute-script-inner = {
                script
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Script to execute (only Groovy is supported)
                  "%,
                ..
              },
          form-replied-event = {
                form-replied
                  | predicates.contract_from_predicate
                  definitions.predicate.form-replied-event-inner
                  | doc m%"
                  Generated when a user replies to a bot message that contains an interactive form with UX components such as text fields, radio buttons, checkboxes, person selectors and more.
                  "%,
                ..
              },
          form-replied-event-inner = {
                exclusive
                  | Bool
                  | doc m%"
                  True if only one reply is expected to the form. Default is false
                  "%
                  | optional,
                form-id
                  | String
                  | doc m%"
                  Form's id. The id should be the same as activity's one that sent the form.
                  "%,
                ..
              },
          get-attachment-inner = {
                attachment-id | definitions.contract.single-attachment,
                message-id | definitions.contract.message-id-inner,
                ..
              },
          get-connections-inner = {
                obo
                  | definitions.contract.obo-inner
                  | doc m%"
                  Defines whether the activity will be executed on behalf of a user and the user on whose behalf the call will be made
                  "%
                  | optional,
                status
                  | std.enum.TagOrString
                  | [|
                    'ALL,
                    'REJECTED,
                    'ACCEPTED,
                    'PENDING_OUTGOING,
                    'PENDING_INCOMING
                  |]
                  | optional,
                user-ids
                  | definitions.contract.user-ids-inner
                  | doc m%"
                  List of user ids that this activity results will be restricted to their connections.
                  "%
                  | optional,
                ..
              },
          get-group-inner = { group-id | definitions.contract.group-id, .. },
          get-groups-inner = {
                after
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Cursor that points to the end of the current page of data. If not present, the current page is the last page.
                  "%
                  | optional,
                before
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  NOT SUPPORTED YET, currently ignored. Cursor that points to the start of the current page of data. If not present, the current page is the first page.
                  "%
                  | optional,
                limit
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Integer ],
                    predicates.numbers.minimum 0,
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Numbers of items to return.
                  "%
                  | optional,
                sort-order
                  | std.enum.TagOrString
                  | [| 'DESC, 'ASC |]
                  | optional,
                status
                  | std.enum.TagOrString
                  | [| 'DELETED, 'ACTIVE |]
                  | doc m%"
                  Filter by status, active or deleted. If not specified both are returned.
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Group type id.
                  "%,
                ..
              },
          get-message-inner = predicates.contract_from_predicate
              definitions.predicate.get-message-inner,
          get-messages-inner = {
                limit | definitions.contract.limit | optional,
                since
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.enum [ "${variables.VARIABLE_NAME}" ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]
                  ])
                  | doc m%"
                  Date, in ISO 8601 format, of the earliest possible data of the first message returned.
                  "%,
                skip | definitions.contract.skip | optional,
                stream-id
                  | definitions.contract.stream-id-inner
                  | doc m%"
                  Stream identifier.
                  "%,
                ..
              },
          get-room-inner = predicates.contract_from_predicate
              definitions.predicate.get-room-inner,
          get-room-members-inner = predicates.contract_from_predicate
              definitions.predicate.get-room-members-inner,
          get-rooms-inner = predicates.contract_from_predicate
              definitions.predicate.get-rooms-inner,
          get-stream-inner = predicates.contract_from_predicate
              definitions.predicate.get-stream-inner,
          get-stream-members-inner = predicates.contract_from_predicate
              definitions.predicate.get-stream-members-inner,
          get-streams-inner = predicates.contract_from_predicate
              definitions.predicate.get-streams-inner,
          get-user-inner = { user-id | definitions.contract.user-id, .. },
          get-user-streams-inner = predicates.contract_from_predicate
              definitions.predicate.get-user-streams-inner,
          get-users-inner = predicates.contract_from_predicate
              definitions.predicate.get-users-inner,
          group-id
            | doc m%"
            Group's unique identifier.
            "%
            = predicates.contract_from_predicate definitions.predicate.group-id,
          group-member = {
                tenant-id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Integer ],
                    predicates.numbers.minimum 0,
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Member's tenant id.
                  "%,
                user-id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Integer ],
                    predicates.numbers.minimum 0,
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Member's user id.
                  "%,
                ..
              },
          group-owner = {
                id
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Integer
                      ],
                      predicates.strings.minLength 1
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | doc m%"
                  Owner id if the owner type is tenant (podId) or user (userId), otherwise null.
                  "%,
                type
                  | std.enum.TagOrString
                  | [| 'USER, 'PLATFORM, 'TENANT |]
                  | doc m%"
                  Owner type. Only TENANT supported now.
                  "%,
                ..
              },
          group-profile = {
                asset-classes
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Equities",
                          "Cash Equities",
                          "Securities Lending",
                          "Fixed Income",
                          "Government Bonds",
                          "Prime Brokerage",
                          "Commodities",
                          "Municipal Bonds",
                          "Currencies",
                          "Corporate Bonds"
                        ]
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | doc m%"
                  The group's asset classes (one or more).
                  "%
                  | optional,
                company-name
                  | String
                  | doc m%"
                  The company name is expected to be the same as group company owner.
                  "%
                  | optional,
                display-name
                  | String
                  | doc m%"
                  The display name in Directory, it is expected to be the same as group name.
                  "%,
                email | String | optional,
                functions
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Collateral",
                          "Confirmation",
                          "Trade Processing",
                          "Pre-Matching",
                          "Margin",
                          "Matching",
                          "Claims Processing",
                          "Middle Office",
                          "Liquidity Management",
                          "Allocation",
                          "Trade Management",
                          "Regulatory Outreach",
                          "Settlements",
                          "Post Trade Management"
                        ]
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | doc m%"
                  The group's job functions (one or more).
                  "%
                  | optional,
                implicit-connection
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    definitions.predicate.tenants-users-list
                  ])
                  | optional,
                industries
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Healthcare",
                          "Consumer Non-Cyclicals",
                          "Transportation",
                          "Technology",
                          "Real Estate",
                          "Basic Materials",
                          "Financials",
                          "Energy & Utilities",
                          "Conglomerates",
                          "Consumer Cyclicals",
                          "Services"
                        ]
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | doc m%"
                  The group's job industries (one or more).
                  "%
                  | optional,
                instruments
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "Securities", "Fixed Income", "Equities" ]
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | doc m%"
                  The group's instruments (one or more).
                  "%
                  | optional,
                interaction-transfer
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    definitions.predicate.tenants-users-list
                  ])
                  | optional,
                job
                  | {
                    city | String | optional,
                    department | String | optional,
                    division | String | optional,
                    phone | String | optional,
                    role | String | optional,
                    title | String | optional,
                    ..
                  }
                  | optional,
                market-coverages
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "EMEA", "NA", "APAC", "LATAM" ]
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | doc m%"
                  The group's market coverage (one or more).
                  "%
                  | optional,
                mobile | String | optional,
                responsibilities
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "BAU", "Escalation" ]
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | doc m%"
                  The group's responsibilities (one or more).
                  "%
                  | optional,
                visibility-restriction
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    definitions.predicate.tenants-users-list
                  ])
                  | optional,
                ..
              },
          id = predicates.contract_from_predicate definitions.predicate.id,
          im-created-event = {
                im-created
                  | predicates.contract_from_predicate
                  definitions.predicate.im-created-event-inner
                  | doc m%"
                  Generated when an IM or MIM is created with the workflow bot as a member, initiated either by the workflow bot or another user.
                  "%,
                ..
              },
          im-created-event-inner = {  .. },
          key-inner = {
                action
                  | std.enum.TagOrString
                  | [| 'REVOKE, 'EXTEND, 'SAVE |]
                  | doc m%"
                  A string indicating the action to be performed on the user's RSA.
                  
                  The following actions can be performed on the user's active RSA key:
                  SAVE
                  REVOKE.
                  
                  The following actions can be performed onto the user's rotated RSA key:
                  REVOKE
                  EXTEND.
                  "%
                  | optional,
                expiration
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  An ISO 8601 timestamp containing the RSA key expiration date. This value is only set for rotated keys.
                  "%
                  | optional,
                key
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  A string containing the user's RSA public key. The key must be 4096 bits. Only PKCS8 format is allowed.
                  "%
                  | optional,
              },
          keywords
            | doc m%"
            A list of key-value pairs, describing additional properties of the room.
            "%
            = predicates.contract_from_predicate definitions.predicate.keywords,
          limit
            | doc m%"
            Maximum number of elements to be returned - used for pagination.
            "%
            = predicates.contract_from_predicate definitions.predicate.limit,
          members-can-invite
            | doc m%"
            If true, any chat room participant can add new participants. If false, only owners can add new participants.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.members-can-invite,
          message-id-inner
            | doc m%"
            Message identifier. Both safe url and Base64 encoded urls are accepted.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.message-id-inner,
          message-received-event = {
                message-received
                  | predicates.contract_from_predicate
                  definitions.predicate.message-received-event-inner
                  | doc m%"
                  Generated when a message is sent in an IM, MIM, or chatroom of which the workflow bot is a member, including messages sent by the user him/herself.
                  "%,
                ..
              },
          message-received-event-inner = {
                content
                  | String
                  | doc m%"
                  Message content to listen to.
                  "%
                  | optional,
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                  ])
                  | doc m%"
                  Event's identifier, should be unique across workflow. As it can be used as a variable identifier only alphanumerical characters are allowed.
                  "%
                  | optional,
                requires-bot-mention
                  | Bool
                  | doc m%"
                  If true, the event is only triggered if the bot is mentioned.
                  "%
                  | optional,
              },
          message-suppressed-event = {
                message-suppressed
                  | predicates.contract_from_predicate
                  definitions.predicate.message-suppressed-event-inner
                  | doc m%"
                  Generated when messages are suppressed.
                  "%,
                ..
              },
          message-suppressed-event-inner = {  .. },
          multilateral-room
            | doc m%"
            If true, this is a multilateral room where users belonging to more than 2 companies can be found.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.multilateral-room,
          name = predicates.contract_from_predicate definitions.predicate.name,
          obo-inner
            | doc m%"
            Defines whether the activity will be executed on behalf of a user and the user on whose behalf the call will be made.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.obo-inner,
          on
            | doc m%"
            Events that can trigger the activity execution.
            "%
            = predicates.contract_from_predicate definitions.predicate.on,
          one-of-event = {
                one-of
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.oneOf
                    [
                      definitions.predicate.form-replied-event,
                      definitions.predicate.activity-expired-event,
                      definitions.predicate.activity-completed-event,
                      definitions.predicate.activity-failed-event,
                      definitions.predicate.message-received-event,
                      definitions.predicate.request-received-event,
                      definitions.predicate.message-suppressed-event,
                      definitions.predicate.post-shared-event,
                      definitions.predicate.im-created-event,
                      definitions.predicate.room-created-event,
                      definitions.predicate.room-updated-event,
                      definitions.predicate.room-deactivated-event,
                      definitions.predicate.room-reactivated-event,
                      definitions.predicate.room-member-promoted-to-owner-event,
                      definitions.predicate.room-member-demoted-from-owner-event,
                      definitions.predicate.user-joined-room-event,
                      definitions.predicate.user-left-room-event,
                      definitions.predicate.user-requested-join-room-event,
                      definitions.predicate.connection-requested-event,
                      definitions.predicate.connection-accepted-event,
                      definitions.predicate.timer-fired-event
                    ])
                  ])
                  | doc m%"
                  Used to receive at least one of the listed events.
                  "%,
                ..
              },
          phoneNumber
            | doc m%"
            The user's work phone number.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.phoneNumber,
          pin-message-inner = {
                message-id | definitions.contract.message-id-inner,
                obo
                  | definitions.contract.obo-inner
                  | doc m%"
                  Defines whether the activity will be executed on behalf of a user and the user on whose behalf the call will be made
                  "%
                  | optional,
                ..
              },
          post-shared-event = {
                post-shared
                  | predicates.contract_from_predicate
                  definitions.predicate.post-shared-event-inner
                  | doc m%"
                  Generated when either the workflow bot shares a wall post written by another user or another user shares a wall post written by the workflow bot.
                  "%,
                ..
              },
          post-shared-event-inner = {  .. },
          promote-room-owner-inner = {
                obo
                  | definitions.contract.obo-inner
                  | doc m%"
                  Defines whether the activity will be executed on behalf of a user and the user on whose behalf the call will be made
                  "%
                  | optional,
                stream-id
                  | definitions.contract.stream-id-inner
                  | doc m%"
                  Stream id where to promote user.
                  "%,
                user-ids
                  | definitions.contract.user-ids-inner
                  | doc m%"
                  User ids to promote in the room.
                  "%,
                ..
              },
          public
            | doc m%"
            If true, this is a public chatroom. If false, a private chatroom.
            Note: Once this value is set for a room, it is read-only and can’t be updated.
            "%
            = predicates.contract_from_predicate definitions.predicate.public,
          read-only
            | doc m%"
            If true, only stream owners can send messages.
            Note: Once this value is set for a room, it is read-only and can’t be updated.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.read-only,
          remove-room-member-inner = {
                obo
                  | definitions.contract.obo-inner
                  | doc m%"
                  Defines whether the activity will be executed on behalf of a user and the user on whose behalf the call will be made
                  "%
                  | optional,
                stream-id
                  | definitions.contract.stream-id-inner
                  | doc m%"
                  Stream id where to remove user(s).
                  "%,
                user-ids
                  | definitions.contract.user-ids-inner
                  | doc m%"
                  User ids to remove from the room.
                  "%,
                ..
              },
          repeat = predicates.contract_from_predicate
              definitions.predicate.repeat,
          request-received-event = predicates.contract_from_predicate
              definitions.predicate.request-received-event,
          request-received-event-inner = {
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                  ])
                  | doc m%"
                  Event's identifier, should be unique across workflow. As it can be used as a variable identifier only alphanumerical characters are allowed.
                  "%
                  | optional,
                token
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Token to authorize incoming http requests.
                  "%,
              },
          roles-inner
            | doc m%"
            The roles object consists of the following possibilities:
            For end-user accounts: INDIVIDUAL, ADMINISTRATOR, SUPER_ADMINISTRATOR, L1_SUPPORT, L2_SUPPORT, COMPLIANCE_OFFICER, SUPER_COMPLIANCE_OFFICER
            For service accounts: INDIVIDUAL, USER_PROVISIONING, SCOPE_MANAGEMENT, CONTENT_MANAGEMENT, MALWARE_SCAN_MANAGER, MALWARE_SCAN_STATE_USER, AUDIT_TRAIL_MANAGEMENT
            "%
            = predicates.contract_from_predicate
              definitions.predicate.roles-inner,
          room-created-event = {
                room-created
                  | predicates.contract_from_predicate
                  definitions.predicate.room-created-event-inner
                  | doc m%"
                  Generated when a room is created by the workflow bot.
                  "%,
                ..
              },
          room-created-event-inner = {  .. },
          room-deactivated-event = {
                room-deactivated
                  | predicates.contract_from_predicate
                  definitions.predicate.room-deactivated-event-inner
                  | doc m%"
                  Generated when a room of which the workflow bot is a member is deactivated, including rooms deactivated by the user him/herself.
                  "%,
                ..
              },
          room-deactivated-event-inner = {  .. },
          room-description = predicates.contract_from_predicate
              definitions.predicate.room-description,
          room-member-demoted-from-owner-event = {
                room-member-demoted-from-owner
                  | predicates.contract_from_predicate
                  definitions.predicate.room-member-demoted-from-owner-event-inner
                  | doc m%"
                  Generated when a user is demoted from an owner to a participant of a room of which the workflow bot is a member, including when the user himself is demoted to a participant or demotes another user.
                  "%,
                ..
              },
          room-member-demoted-from-owner-event-inner = {  .. },
          room-member-promoted-to-owner-event = {
                room-member-promoted-to-owner
                  | predicates.contract_from_predicate
                  definitions.predicate.room-member-promoted-to-owner-event-inner
                  | doc m%"
                  Generated when a user is promoted from a participant to an owner of a room of which the workflow bot is a member, including when the user himself is promoted to an owner or promotes another user.
                  "%,
                ..
              },
          room-member-promoted-to-owner-event-inner = {
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                  ])
                  | doc m%"
                  Event's identifier, should be unique across workflow. As it can be used as a variable identifier only alphanumerical characters are allowed.
                  "%
                  | optional,
                ..
              },
          room-name = predicates.contract_from_predicate
              definitions.predicate.room-name,
          room-reactivated-event = {
                room-reactivated
                  | predicates.contract_from_predicate
                  definitions.predicate.room-reactivated-event-inner
                  | doc m%"
                  Generated when a room of which the workflow bot is a member is reactivated, including rooms reactivated by the user him/herself.
                  "%,
                ..
              },
          room-reactivated-event-inner = {  .. },
          room-updated-event = {
                room-updated
                  | predicates.contract_from_predicate
                  definitions.predicate.room-updated-event-inner
                  | doc m%"
                  Generated when a room of which the workflow bot is a member is updated, including rooms updated by the user him/herself.
                  "%,
                ..
              },
          room-updated-event-inner = {  .. },
          search-user-inner = {
                active
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  If true, it searches for active users only. If false, it searches for inactive users only. If not set, it searches for all users regardless of their status.
                  "%
                  | optional,
                local
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  If true then a local DB search will be performed and only local pod users will be returned. If absent or false then a directory search will be performed and users from other pods who are visible to the calling user will also be returned.
                  "%
                  | optional,
                ..
              },
          send-message-inner = {
                attachments
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.attachment
                  ])
                  | doc m%"
                  One or more attachments to be sent along with the message.
                  "%
                  | optional,
                content | definitions.contract.content-inner,
                data
                  | String
                  | doc m%"
                  Message data, which is a Json string and sent along with message.
                  "%
                  | optional,
                obo
                  | definitions.contract.obo-inner
                  | doc m%"
                  Defines whether the activity will be executed on behalf of a user and the user on whose behalf the call will be made
                  "%
                  | optional,
                to
                  | definitions.contract.to
                  | doc m%"
                  The recipient (conversation, IM, MIM or chatroom) in which the message should be posted.
                  "%
                  | optional,
                ..
              },
          single-attachment = predicates.contract_from_predicate
              definitions.predicate.single-attachment,
          skip
            | doc m%"
            Number of elements to be skipped during return - used for pagination.
            "%
            = predicates.contract_from_predicate definitions.predicate.skip,
          stream-id
            | doc m%"
            Stream id to sent the message to.
            "%
            = { stream-id | definitions.contract.stream-id-inner, .. },
          stream-id-inner
            | doc m%"
            Stream identifier. Both safe url and Base64 encoded urls are accepted.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.stream-id-inner,
          stream-ids
            | doc m%"
            Stream ids to sent the message to (blast message).
            "%
            = {
                stream-ids
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.strings.minLength 1,
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ]),
                ..
              },
          sub-type = std.contract.Sequence
              [ std.enum.TagOrString, [| 'EMAIL |] ],
          tenants-users-list = {
                tenant-ids
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Integer
                        ],
                        predicates.numbers.minimum 0,
                        predicates.strings.minLength 1
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | optional,
                user-ids
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Integer
                        ],
                        predicates.numbers.minimum 0,
                        predicates.strings.minLength 1
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | optional,
                ..
              },
          timer-fired-event = {
                timer-fired
                  | predicates.contract_from_predicate
                  definitions.predicate.timer-fired-event-inner
                  | doc m%"
                  Timer based event. It is either triggered at a given point in time using the keyword "at" or repeated using the keyword "repeat". Note this is not a Datafeed real-time event.
                  "%,
              },
          timer-fired-event-inner = predicates.contract_from_predicate
              definitions.predicate.timer-fired-event-inner,
          to = predicates.contract_from_predicate definitions.predicate.to,
          unpin-message-inner = {
                obo
                  | definitions.contract.obo-inner
                  | doc m%"
                  Defines whether the activity will be executed on behalf of a user and the user on whose behalf the call will be made
                  "%
                  | optional,
                stream-id | definitions.contract.stream-id-inner,
                ..
              },
          update-group-inner = {
                e-tag
                  | String
                  | doc m%"
                  Required to update group fields except the image-path.
                  "%
                  | optional,
                group-id | definitions.contract.group-id,
                image-path
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.enum [ "${variables.VARIABLE_NAME}" ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]
                  ])
                  | doc m%"
                  Path to the file to be uploaded as the group's avatar. The path is relative to the workflows folder.
                  "%
                  | optional,
                status
                  | std.enum.TagOrString
                  | [| 'DELETED, 'ACTIVE |]
                  | doc m%"
                  Status flag to distinguish between active and deleted objects. Required to update group fields except the image-path.
                  "%
                  | optional,
                ..
              },
          update-message-inner = {
                content | definitions.contract.content-inner,
                message-id | definitions.contract.message-id-inner,
                silent
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  If enabled, the new updated message is marked as read, otherwise is unread
                  "%
                  | optional,
                ..
              },
          update-room-inner = {
                active | definitions.contract.active | optional,
                copy-protected | definitions.contract.copy-protected | optional,
                cross-pod | definitions.contract.cross-pod | optional,
                discoverable | definitions.contract.discoverable | optional,
                keywords | definitions.contract.keywords | optional,
                members-can-invite
                  | definitions.contract.members-can-invite
                  | optional,
                multilateral-room
                  | definitions.contract.multilateral-room
                  | optional,
                obo
                  | definitions.contract.obo-inner
                  | doc m%"
                  Defines whether the activity will be executed on behalf of a user and the user on whose behalf the call will be made
                  "%
                  | optional,
                public | definitions.contract.public | optional,
                read-only | definitions.contract.read-only | optional,
                room-description
                  | definitions.contract.room-description
                  | optional,
                room-name | definitions.contract.room-name | optional,
                stream-id
                  | definitions.contract.stream-id-inner
                  | doc m%"
                  Stream's id to update.
                  "%,
                view-history | definitions.contract.view-history | optional,
                ..
              },
          user-id
            | doc m%"
            User id.
            "%
            = predicates.contract_from_predicate definitions.predicate.user-id,
          user-ids
            | doc m%"
            List of user ids.
            "%
            = { user-ids | definitions.contract.user-ids-inner, .. },
          user-ids-inner
            | doc m%"
            User identifiers list.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.user-ids-inner,
          user-joined-room-event = {
                user-joined-room
                  | predicates.contract_from_predicate
                  definitions.predicate.user-joined-room-event-inner
                  | doc m%"
                  Generated when a new user joins or is added to a room of which the workflow bot is a member, including when the user himself joins or is added to a room.
                  "%,
                ..
              },
          user-joined-room-event-inner = {
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                  ])
                  | doc m%"
                  Event's identifier, should be unique across workflow. As it can be used as a variable identifier only alphanumerical characters are allowed.
                  "%
                  | optional,
                ..
              },
          user-left-room-event = {
                user-left-room
                  | predicates.contract_from_predicate
                  definitions.predicate.user-left-room-event-inner
                  | doc m%"
                  Generated when a user leaves or is removed from a room of which the workflow bot is a member, including when the user himself leaves or is removed from a room.
                  "%,
                ..
              },
          user-left-room-event-inner = {
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                  ])
                  | doc m%"
                  Event's identifier, should be unique across workflow. As it can be used as a variable identifier only alphanumerical characters are allowed.
                  "%
                  | optional,
                ..
              },
          user-requested-join-room-event = {
                user-requested-join-room
                  | predicates.contract_from_predicate
                  definitions.predicate.user-requested-join-room-event-inner
                  | doc m%"
                  Generated when a user requests to join a room. Only the user who requested to join the room and the owners of that room will receive this event on their datafeeds.
                  "%,
                ..
              },
          user-requested-join-room-event-inner = {  .. },
          user-role-inner = {
                roles | definitions.contract.roles-inner,
                user-ids
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Integer
                        ],
                        predicates.strings.minLength 1
                      ]),
                      predicates.arrays.minItems 1,
                      predicates.arrays.uniqueItems
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{.*\\}$"
                    ],
                    predicates.enum [ "${variables.VARIABLE_NAME}" ]
                  ])
                  | doc m%"
                  Users to add or remove roles from.
                  "%,
                ..
              },
          view-history
            | doc m%"
            If true, new members can view the room chat history of the room.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.view-history,
        },
    predicate = {
          active
            | doc m%"
            If false, the room is not active anymore.
            "%
            = predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
          activity-completed-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "activity-completed" ],
                predicates.records.record
                {
                  activity-completed =
                    definitions.predicate.activity-completed-event-inner,
                  "if" = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^\\$\\{.*\\}$"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          activity-completed-event-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "activity-id" ],
                predicates.records.record
                {
                  activity-id = definitions.predicate.id,
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          activity-expired-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "activity-expired" ],
                predicates.records.record
                {
                  activity-expired =
                    definitions.predicate.activity-expired-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          activity-expired-event-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "activity-id" ],
                predicates.records.record
                { activity-id = definitions.predicate.id, }
                {  }
                true
                predicates.always
              ],
          activity-failed-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "activity-failed" ],
                predicates.records.record
                {
                  activity-failed =
                    definitions.predicate.activity-failed-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          activity-failed-event-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "activity-id" ],
                predicates.records.record
                { activity-id = definitions.predicate.id, }
                {  }
                true
                predicates.always
              ],
          add-group-member-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "group-id" ],
                predicates.records.record
                {
                  group-id = definitions.predicate.group-id,
                  members = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            definitions.predicate.group-member,
                            predicates.arrays.uniqueItems
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1,
                            predicates.strings.pattern "^\\$\\{.*\\}$"
                          ],
                          predicates.enum [ "${variables.VARIABLE_NAME}" ]
                        ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          add-room-member-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "stream-id", "user-ids" ],
                predicates.records.record
                {
                  obo = definitions.predicate.obo-inner,
                  stream-id = definitions.predicate.stream-id-inner,
                  user-ids = definitions.predicate.user-ids-inner,
                }
                {  }
                true
                predicates.always
              ],
          all-of-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "all-of" ],
                predicates.records.record
                {
                  all-of = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.form-replied-event,
                          definitions.predicate.activity-completed-event,
                          definitions.predicate.activity-failed-event,
                          definitions.predicate.message-received-event,
                          definitions.predicate.request-received-event,
                          definitions.predicate.message-suppressed-event,
                          definitions.predicate.post-shared-event,
                          definitions.predicate.im-created-event,
                          definitions.predicate.room-created-event,
                          definitions.predicate.room-updated-event,
                          definitions.predicate.room-deactivated-event,
                          definitions.predicate.room-reactivated-event,
                          definitions.predicate.room-member-promoted-to-owner-event,
                          definitions.predicate.room-member-demoted-from-owner-event,
                          definitions.predicate.user-joined-room-event,
                          definitions.predicate.user-left-room-event,
                          definitions.predicate.user-requested-join-room-event,
                          definitions.predicate.connection-requested-event,
                          definitions.predicate.connection-accepted-event,
                          definitions.predicate.timer-fired-event
                        ])
                      ],
                }
                {  }
                true
                predicates.always
              ],
          at = predicates.allOf
              [
                predicates.records.required [ "at" ],
                predicates.records.record { at = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          attachment = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  definitions.predicate.attachment-message,
                  definitions.predicate.attachment-file
                ]
              ],
          attachment-file = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "content-path" ],
                predicates.records.record
                {
                  content-path = predicates.anyOf
                      [
                        predicates.enum [ "${variables.VARIABLE_NAME}" ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          attachment-message = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "message-id" ],
                predicates.records.record
                {
                  attachment-id = predicates.anyOf
                      [
                        predicates.enum [ "${variables.VARIABLE_NAME}" ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]
                      ],
                  message-id = definitions.predicate.message-id-inner,
                }
                {  }
                true
                predicates.always
              ],
          basic-activity-inner
            | doc m%"
            Inner property having common properties for every activity.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  "else" = predicates.isType 'Record,
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                      ],
                  "if" = predicates.isType '"String",
                  on = definitions.predicate.on,
                }
                {  }
                true
                predicates.always
              ],
          business
            | doc m%"
            Business information
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  asset-classes = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "Equities",
                              "Cash Equities",
                              "Securities Lending",
                              "Fixed Income",
                              "Government Bonds",
                              "Prime Brokerage",
                              "Commodities",
                              "Municipal Bonds",
                              "Currencies",
                              "Corporate Bonds"
                            ]
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  company-name = predicates.isType '"String",
                  department = predicates.isType '"String",
                  division = predicates.isType '"String",
                  functions = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "Collateral",
                              "Confirmation",
                              "Trade Processing",
                              "Pre-Matching",
                              "Margin",
                              "Matching",
                              "Claims Processing",
                              "Middle Office",
                              "Liquidity Management",
                              "Allocation",
                              "Trade Management",
                              "Regulatory Outreach",
                              "Settlements",
                              "Post Trade Management"
                            ]
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  industries = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "Healthcare",
                              "Consumer Non-Cyclicals",
                              "Transportation",
                              "Technology",
                              "Real Estate",
                              "Basic Materials",
                              "Financials",
                              "Energy & Utilities",
                              "Conglomerates",
                              "Consumer Cyclicals",
                              "Services"
                            ]
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  instruments = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [ "Securities", "Fixed Income", "Equities" ]
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  job-function = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Analyst",
                          "Other",
                          "Business Development Executive",
                          "Corporate Access",
                          "Developer",
                          "Director",
                          "Economist",
                          "Portfolio Manager",
                          "Project Manager",
                          "Research Analyst",
                          "Sales",
                          "Strategist",
                          "Trader"
                        ]
                      ],
                  location = predicates.isType '"String",
                  market-coverages = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "EMEA", "NA", "APAC", "LATAM" ]
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  responsibilities = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "BAU", "Escalation" ]
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  title = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          connection-accepted-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "connection-accepted" ],
                predicates.records.record
                {
                  connection-accepted =
                    definitions.predicate.connection-accepted-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          connection-accepted-event-inner = predicates.isType 'Record,
          connection-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "user-id" ],
                predicates.records.record
                {
                  obo = definitions.predicate.obo-inner,
                  user-id = definitions.predicate.user-id,
                }
                {  }
                true
                predicates.always
              ],
          connection-requested-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "connection-requested" ],
                predicates.records.record
                {
                  connection-requested =
                    definitions.predicate.connection-requested-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          connection-requested-event-inner = predicates.isType 'Record,
          content-inner
            | doc m%"
            The content of the message in MessageML format. Must contain at least one space. In case the content is a form, this latter's id should be the same as the activity one.
            "%
            = predicates.oneOf
              [
                predicates.enum
                [
                  "${variables.VARIABLE_NAME}",
                  "${text(ACTIVITY_ID.outputs.message.message)}",
                  "${event.args.NAME}",
                  "<mention uid='${ACTIVITY_ID.outputs.user.userSystemInfo.id}'/>",
                  "<mention uid='${event.initiator.user.userId}'/>"
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.records.required [ "template" ],
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.allOf
                    [
                      predicates.records.required [ "template-path" ],
                      predicates.records.record {  } {  } true predicates.always
                    ]
                  ],
                  predicates.records.record
                  {
                    template = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    template-path = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.allOf
                [ predicates.isType '"String", predicates.strings.minLength 0 ]
              ],
          copy-protected
            | doc m%"
            If true, users cannot copy content from this room.
            Note: Once this value is set to true for a room, it is read-only and can’t be updated.
            "%
            = predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
          create-group-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  members = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            definitions.predicate.group-member,
                            predicates.arrays.uniqueItems
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1,
                            predicates.strings.pattern "^\\$\\{.*\\}$"
                          ],
                          predicates.enum [ "${variables.VARIABLE_NAME}" ]
                        ]
                      ],
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  owner = predicates.allOf
                      [
                        predicates.isType 'Record,
                        definitions.predicate.group-owner
                      ],
                  profile = definitions.predicate.group-profile,
                  referrer = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  sub-type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "COMMUNITY", "CHANNEL" ]
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                true
                predicates.always
              ],
          create-room-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required
                    [ "room-description", "room-name" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "user-ids" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  copy-protected = definitions.predicate.copy-protected,
                  cross-pod = definitions.predicate.cross-pod,
                  discoverable = definitions.predicate.discoverable,
                  keywords = definitions.predicate.keywords,
                  members-can-invite = definitions.predicate.members-can-invite,
                  multilateral-room = definitions.predicate.multilateral-room,
                  obo = definitions.predicate.obo-inner,
                  public = definitions.predicate.public,
                  read-only = definitions.predicate.read-only,
                  room-description = definitions.predicate.room-description,
                  room-name = definitions.predicate.room-name,
                  sub-type = definitions.predicate.sub-type,
                  user-ids = definitions.predicate.user-ids-inner,
                  view-history = definitions.predicate.view-history,
                }
                {  }
                true
                predicates.always
              ],
          create-system-user-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  business = definitions.predicate.business,
                  display-name = definitions.predicate.name,
                  email = definitions.predicate.email,
                  entitlements = definitions.predicate.entitlements-inner,
                  keys = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          current = definitions.predicate.key-inner,
                          previous = definitions.predicate.key-inner,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  roles = definitions.predicate.roles-inner,
                  status = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ENABLED", "DISABLED" ]
                      ],
                  username = definitions.predicate.name,
                }
                {  }
                true
                predicates.always
              ],
          create-user-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  business = definitions.predicate.business,
                  contact = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          mobile-phone-number =
                            definitions.predicate.phoneNumber,
                          sms-number = definitions.predicate.phoneNumber,
                          two-factor-auth-number =
                            definitions.predicate.phoneNumber,
                          work-phone-number = definitions.predicate.phoneNumber,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  display-name = definitions.predicate.name,
                  email = definitions.predicate.email,
                  entitlements = definitions.predicate.entitlements-inner,
                  firstname = definitions.predicate.name,
                  lastname = definitions.predicate.name,
                  password = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [ "hashed-password", "hashed-salt" ],
                        predicates.records.record
                        {
                          hashed-km-password = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                          hashed-km-salt = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                          hashed-password = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                          hashed-salt = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  recommended-language = predicates.isType '"String",
                  roles = definitions.predicate.roles-inner,
                  status = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ENABLED", "DISABLED" ]
                      ],
                  username = definitions.predicate.name,
                }
                {  }
                true
                predicates.always
              ],
          cross-pod
            | doc m%"
            If true, this room is a cross-pod room.
            "%
            = predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
          demote-room-owner-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "stream-id", "user-ids" ],
                predicates.records.record
                {
                  obo = definitions.predicate.obo-inner,
                  stream-id = definitions.predicate.stream-id-inner,
                  user-ids = definitions.predicate.user-ids-inner,
                }
                {  }
                true
                predicates.always
              ],
          discoverable
            | doc m%"
            If true, this chat room (name, description and messages) non-participants can search for this room. If false, only participants can search for this room.
            "%
            = predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
          email
            | doc m%"
            Email address, must be unique
            "%
            = predicates.anyOf
              [
                predicates.enum
                [
                  "${variables.VARIABLE_NAME}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.emailAddress}"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern
                  "([$][{].+})|(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
                ]
              ],
          entitlements-inner
            | doc m%"
            Feature entitlements to configure for the user.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    canCreateDatahose = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canCreateMultiLateralRoom = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canCreatePublicRoom = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canCreatePushedSignals = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canIntegrateEmail = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canJoinMultiLateralRoom = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canManageSignalSubscription = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canProjectInternalScreenShare = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canProjectInternalScreenShareMobile = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canReadDatahose = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canShareFilesExternally = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canSuppressMessage = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canSwitchToClient20 = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canUpdateAvatar = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canUpdateRoomHistoryProperty = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canUseCompactMode = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canUseEncryptAPI = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canUseFirehose = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canUseInternalAudio = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canUseInternalAudioMobile = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canUseInternalVideo = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canUseInternalVideoMobile = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canViewInternalScreenShare = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    canViewInternalScreenShareMobile = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    delegatesEnabled = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    enableSwiftSearch = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    isExternalIMEnabled = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    isExternalRoomEnabled = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    mustBeRecorded = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    postReadEnabled = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    postWriteEnabled = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    sdaDevtoolsEnabled = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    sdaPermissionsFullScreen = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    sdaPermissionsGeoLocation = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    sdaPermissionsMedia = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    sdaPermissionsMidiSysex = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    sdaPermissionsNotifications = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    sdaPermissionsOpenExternalApp = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    sdaPermissionsPointerLock = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                    sendFilesEnabled = predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String"
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.allOf
                [ predicates.isType '"String", predicates.strings.minLength 1 ],
                predicates.enum [ "${variables.VARIABLE_NAME}" ]
              ],
          execute-request-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "url" ],
                predicates.records.record
                {
                  body = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                  encode-query-params = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  headers = predicates.isType 'Record,
                  method = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "GET",
                          "POST",
                          "PUT",
                          "DELETE",
                          "PATCH",
                          "HEAD",
                          "OPTIONS"
                        ]
                      ],
                  url = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                true
                predicates.always
              ],
          execute-script-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "script" ],
                predicates.records.record
                { script = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          form-replied-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "form-replied" ],
                predicates.records.record
                {
                  form-replied = definitions.predicate.form-replied-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          form-replied-event-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "form-id" ],
                predicates.records.record
                {
                  exclusive = predicates.isType '"Bool",
                  form-id = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          get-attachment-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "attachment-id", "message-id" ],
                predicates.records.record
                {
                  attachment-id = definitions.predicate.single-attachment,
                  message-id = definitions.predicate.message-id-inner,
                }
                {  }
                true
                predicates.always
              ],
          get-connections-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  obo = definitions.predicate.obo-inner,
                  status = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "PENDING_INCOMING",
                          "PENDING_OUTGOING",
                          "ACCEPTED",
                          "REJECTED",
                          "ALL"
                        ]
                      ],
                  user-ids = definitions.predicate.user-ids-inner,
                }
                {  }
                true
                predicates.always
              ],
          get-group-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "group-id" ],
                predicates.records.record
                { group-id = definitions.predicate.group-id, }
                {  }
                true
                predicates.always
              ],
          get-groups-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  after = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  before = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  limit = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Integer
                        ],
                        predicates.numbers.minimum 0,
                        predicates.strings.minLength 1
                      ],
                  sort-order = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ASC", "DESC" ]
                      ],
                  status = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ACTIVE", "DELETED" ]
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                true
                predicates.always
              ],
          get-message-inner = predicates.allOf
              [
                predicates.records.required [ "message-id" ],
                predicates.records.record
                { message-id = definitions.predicate.message-id-inner, }
                {  }
                true
                predicates.always
              ],
          get-messages-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "since", "stream-id" ],
                predicates.records.record
                {
                  limit = definitions.predicate.limit,
                  since = predicates.anyOf
                      [
                        predicates.enum [ "${variables.VARIABLE_NAME}" ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]
                      ],
                  skip = definitions.predicate.skip,
                  stream-id = definitions.predicate.stream-id-inner,
                }
                {  }
                true
                predicates.always
              ],
          get-room-inner = predicates.allOf
              [
                predicates.records.required [ "stream-id" ],
                predicates.records.record
                {
                  obo = definitions.predicate.obo-inner,
                  stream-id = definitions.predicate.stream-id-inner,
                }
                {  }
                true
                predicates.always
              ],
          get-room-members-inner = predicates.allOf
              [
                predicates.records.required [ "stream-id" ],
                predicates.records.record
                { stream-id = definitions.predicate.stream-id-inner, }
                {  }
                true
                predicates.always
              ],
          get-rooms-inner = predicates.allOf
              [
                predicates.records.required [ "query" ],
                predicates.records.record
                {
                  active = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  creator-id = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number"
                        ],
                        predicates.strings.minLength 1
                      ],
                  labels = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  limit = definitions.predicate.limit,
                  member-id = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number"
                        ],
                        predicates.strings.minLength 1
                      ],
                  obo = definitions.predicate.obo-inner,
                  owner-id = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number"
                        ],
                        predicates.strings.minLength 1
                      ],
                  private = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  query = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  skip = definitions.predicate.skip,
                  sort-order = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "BASIC", "RELEVANCE" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          get-stream-inner = predicates.allOf
              [
                predicates.records.required [ "stream-id" ],
                predicates.records.record
                {
                  obo = definitions.predicate.obo-inner,
                  stream-id = definitions.predicate.stream-id-inner,
                }
                {  }
                true
                predicates.always
              ],
          get-stream-members-inner = predicates.allOf
              [
                predicates.records.required [ "stream-id" ],
                predicates.records.record
                {
                  limit = definitions.predicate.limit,
                  skip = definitions.predicate.skip,
                  stream-id = definitions.predicate.stream-id-inner,
                }
                {  }
                true
                predicates.always
              ],
          get-streams-inner = predicates.records.record
              {
                end-date = predicates.isType '"String",
                limit = definitions.predicate.limit,
                origin = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "INTERNAL", "EXTERNAL" ]
                    ],
                privacy = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "PRIVATE", "PUBLIC" ]
                    ],
                scope = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "INTERNAL", "EXTERNAL" ]
                    ],
                skip = definitions.predicate.skip,
                start-date = predicates.isType '"String",
                status = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "ACTIVE", "INACTIVE" ]
                    ],
                types = predicates.oneOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "IM", "MIM", "ROOM" ]
                        ])
                      ],
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1,
                        predicates.strings.pattern "^\\$\\{.*\\}$"
                      ],
                      predicates.enum [ "${variables.VARIABLE_NAME}" ]
                    ],
              }
              {  }
              true
              predicates.always,
          get-user-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "user-id" ],
                predicates.records.record
                { user-id = definitions.predicate.user-id, }
                {  }
                true
                predicates.always
              ],
          get-user-streams-inner = predicates.allOf
              [
                predicates.records.record
                {
                  include-inactive-streams = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  limit = definitions.predicate.limit,
                  obo = definitions.predicate.obo-inner,
                  skip = definitions.predicate.skip,
                  types = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "IM", "MIM", "ROOM", "POST" ]
                          ])
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                }
                {  }
                true
                predicates.always,
                predicates.records.dependencies
                { limit = [ "skip" ], skip = [ "limit" ], }
              ],
          get-users-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "user-ids" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "emails" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "usernames" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  active = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  emails = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.strings.minLength 1,
                          predicates.arrays.arrayOf definitions.predicate.email
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  local = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  obo = definitions.predicate.obo-inner,
                  user-ids = definitions.predicate.user-ids-inner,
                  usernames = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.strings.minLength 1,
                          predicates.arrays.arrayOf definitions.predicate.name
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          group-id
            | doc m%"
            Group's unique identifier.
            "%
            = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Integer ],
                  predicates.strings.minLength 1
                ],
                predicates.enum [ "${variables.VARIABLE_NAME}" ]
              ],
          group-member = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tenant-id", "user-id" ],
                predicates.records.record
                {
                  tenant-id = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Integer
                        ],
                        predicates.numbers.minimum 0,
                        predicates.strings.minLength 1
                      ],
                  user-id = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Integer
                        ],
                        predicates.numbers.minimum 0,
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                true
                predicates.always
              ],
          group-owner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id", "type" ],
                predicates.records.record
                {
                  id = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType 'Integer
                          ],
                          predicates.strings.minLength 1
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "TENANT", "PLATFORM", "USER" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          group-profile = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "display-name" ],
                predicates.records.record
                {
                  asset-classes = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "Equities",
                              "Cash Equities",
                              "Securities Lending",
                              "Fixed Income",
                              "Government Bonds",
                              "Prime Brokerage",
                              "Commodities",
                              "Municipal Bonds",
                              "Currencies",
                              "Corporate Bonds"
                            ]
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  company-name = predicates.isType '"String",
                  display-name = predicates.isType '"String",
                  email = predicates.isType '"String",
                  functions = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "Collateral",
                              "Confirmation",
                              "Trade Processing",
                              "Pre-Matching",
                              "Margin",
                              "Matching",
                              "Claims Processing",
                              "Middle Office",
                              "Liquidity Management",
                              "Allocation",
                              "Trade Management",
                              "Regulatory Outreach",
                              "Settlements",
                              "Post Trade Management"
                            ]
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  implicit-connection = predicates.allOf
                      [
                        predicates.isType 'Record,
                        definitions.predicate.tenants-users-list
                      ],
                  industries = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "Healthcare",
                              "Consumer Non-Cyclicals",
                              "Transportation",
                              "Technology",
                              "Real Estate",
                              "Basic Materials",
                              "Financials",
                              "Energy & Utilities",
                              "Conglomerates",
                              "Consumer Cyclicals",
                              "Services"
                            ]
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  instruments = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [ "Securities", "Fixed Income", "Equities" ]
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  interaction-transfer = predicates.allOf
                      [
                        predicates.isType 'Record,
                        definitions.predicate.tenants-users-list
                      ],
                  job = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          city = predicates.isType '"String",
                          department = predicates.isType '"String",
                          division = predicates.isType '"String",
                          phone = predicates.isType '"String",
                          role = predicates.isType '"String",
                          title = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  market-coverages = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "EMEA", "NA", "APAC", "LATAM" ]
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  mobile = predicates.isType '"String",
                  responsibilities = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "BAU", "Escalation" ]
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  visibility-restriction = predicates.allOf
                      [
                        predicates.isType 'Record,
                        definitions.predicate.tenants-users-list
                      ],
                }
                {  }
                true
                predicates.always
              ],
          id = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          im-created-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "im-created" ],
                predicates.records.record
                { im-created = definitions.predicate.im-created-event-inner, }
                {  }
                true
                predicates.always
              ],
          im-created-event-inner = predicates.isType 'Record,
          key-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  action = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "SAVE", "EXTEND", "REVOKE" ]
                      ],
                  expiration = predicates.allOf
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
                false
                predicates.never
              ],
          keywords
            | doc m%"
            A list of key-value pairs, describing additional properties of the room.
            "%
            = predicates.oneOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [ predicates.isType '"String", predicates.strings.minLength 1 ],
                predicates.enum [ "${variables.VARIABLE_NAME}" ]
              ],
          limit
            | doc m%"
            Maximum number of elements to be returned - used for pagination.
            "%
            = predicates.anyOf
              [
                predicates.enum [ "${variables.VARIABLE_NAME}" ],
                predicates.allOf
                [
                  predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType '"String" ],
                  predicates.numbers.maximum 1000,
                  predicates.numbers.minimum 1
                ]
              ],
          members-can-invite
            | doc m%"
            If true, any chat room participant can add new participants. If false, only owners can add new participants.
            "%
            = predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
          message-id-inner
            | doc m%"
            Message identifier. Both safe url and Base64 encoded urls are accepted.
            "%
            = predicates.anyOf
              [
                predicates.enum
                [
                  "${variables.VARIABLE_NAME}",
                  "${ACTIVITY_ID.outputs.msgId}",
                  "${ACTIVITY_ID.outputs.message.messageId}",
                  "${ACTIVITY_ID.outputs.message.initialMessageId}"
                ],
                definitions.predicate.id
              ],
          message-received-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "message-received" ],
                predicates.records.record
                {
                  message-received =
                    definitions.predicate.message-received-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          message-received-event-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  content = predicates.isType '"String",
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                      ],
                  requires-bot-mention = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          message-suppressed-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "message-suppressed" ],
                predicates.records.record
                {
                  message-suppressed =
                    definitions.predicate.message-suppressed-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          message-suppressed-event-inner = predicates.isType 'Record,
          multilateral-room
            | doc m%"
            If true, this is a multilateral room where users belonging to more than 2 companies can be found.
            "%
            = predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
          name = predicates.anyOf
              [
                predicates.enum
                [
                  "${variables.VARIABLE_NAME}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.firstName}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.lastName}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.userName}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.displayName}"
                ],
                predicates.allOf
                [ predicates.isType '"String", predicates.strings.minLength 1 ]
              ],
          obo-inner
            | doc m%"
            Defines whether the activity will be executed on behalf of a user and the user on whose behalf the call will be made.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "user-id" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "username" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  user-id = definitions.predicate.user-id,
                  username = definitions.predicate.name,
                }
                {  }
                true
                predicates.always
              ],
          on
            | doc m%"
            Events that can trigger the activity execution.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      timeout = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern
                            "^P(?!$)(\\d+(?:\\.\\d+)?Y)?(\\d+(?:\\.\\d+)?M)?(\\d+(?:\\.\\d+)?W)?(\\d+(?:\\.\\d+)?D)?(T(?=\\d)(\\d+(?:\\.\\d+)?H)?(\\d+(?:\\.\\d+)?M)?(\\d+(?:\\.\\d+)?S)?)?$"
                          ],
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.oneOf
                  [
                    definitions.predicate.form-replied-event,
                    definitions.predicate.activity-expired-event,
                    definitions.predicate.activity-completed-event,
                    definitions.predicate.activity-failed-event,
                    definitions.predicate.message-received-event,
                    definitions.predicate.request-received-event,
                    definitions.predicate.message-suppressed-event,
                    definitions.predicate.post-shared-event,
                    definitions.predicate.im-created-event,
                    definitions.predicate.room-created-event,
                    definitions.predicate.room-updated-event,
                    definitions.predicate.room-deactivated-event,
                    definitions.predicate.room-reactivated-event,
                    definitions.predicate.room-member-promoted-to-owner-event,
                    definitions.predicate.room-member-demoted-from-owner-event,
                    definitions.predicate.user-joined-room-event,
                    definitions.predicate.user-left-room-event,
                    definitions.predicate.user-requested-join-room-event,
                    definitions.predicate.connection-requested-event,
                    definitions.predicate.connection-accepted-event,
                    definitions.predicate.timer-fired-event,
                    definitions.predicate.one-of-event,
                    definitions.predicate.all-of-event
                  ]
                ]
              ],
          one-of-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "one-of" ],
                predicates.records.record
                {
                  one-of = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.oneOf
                        [
                          definitions.predicate.form-replied-event,
                          definitions.predicate.activity-expired-event,
                          definitions.predicate.activity-completed-event,
                          definitions.predicate.activity-failed-event,
                          definitions.predicate.message-received-event,
                          definitions.predicate.request-received-event,
                          definitions.predicate.message-suppressed-event,
                          definitions.predicate.post-shared-event,
                          definitions.predicate.im-created-event,
                          definitions.predicate.room-created-event,
                          definitions.predicate.room-updated-event,
                          definitions.predicate.room-deactivated-event,
                          definitions.predicate.room-reactivated-event,
                          definitions.predicate.room-member-promoted-to-owner-event,
                          definitions.predicate.room-member-demoted-from-owner-event,
                          definitions.predicate.user-joined-room-event,
                          definitions.predicate.user-left-room-event,
                          definitions.predicate.user-requested-join-room-event,
                          definitions.predicate.connection-requested-event,
                          definitions.predicate.connection-accepted-event,
                          definitions.predicate.timer-fired-event
                        ])
                      ],
                }
                {  }
                true
                predicates.always
              ],
          phoneNumber
            | doc m%"
            The user's work phone number.
            "%
            = predicates.anyOf
              [
                predicates.enum
                [
                  "${variables.VARIABLE_NAME}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.workPhoneNumber}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.mobilePhoneNumber}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.twoFactorAuthPhone}"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^[0-9]*$|^\\+[0-9]*$"
                ]
              ],
          pin-message-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "message-id" ],
                predicates.records.record
                {
                  message-id = definitions.predicate.message-id-inner,
                  obo = definitions.predicate.obo-inner,
                }
                {  }
                true
                predicates.always
              ],
          post-shared-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "post-shared" ],
                predicates.records.record
                { post-shared = definitions.predicate.post-shared-event-inner, }
                {  }
                true
                predicates.always
              ],
          post-shared-event-inner = predicates.isType 'Record,
          promote-room-owner-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "stream-id", "user-ids" ],
                predicates.records.record
                {
                  obo = definitions.predicate.obo-inner,
                  stream-id = definitions.predicate.stream-id-inner,
                  user-ids = definitions.predicate.user-ids-inner,
                }
                {  }
                true
                predicates.always
              ],
          public
            | doc m%"
            If true, this is a public chatroom. If false, a private chatroom.
            Note: Once this value is set for a room, it is read-only and can’t be updated.
            "%
            = predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
          read-only
            | doc m%"
            If true, only stream owners can send messages.
            Note: Once this value is set for a room, it is read-only and can’t be updated.
            "%
            = predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
          remove-room-member-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "stream-id", "user-ids" ],
                predicates.records.record
                {
                  obo = definitions.predicate.obo-inner,
                  stream-id = definitions.predicate.stream-id-inner,
                  user-ids = definitions.predicate.user-ids-inner,
                }
                {  }
                true
                predicates.always
              ],
          repeat = predicates.allOf
              [
                predicates.records.required [ "repeat" ],
                predicates.records.record
                { repeat = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          request-received-event = predicates.allOf
              [
                predicates.records.required [ "request-received" ],
                predicates.records.record
                {
                  request-received =
                    definitions.predicate.request-received-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          request-received-event-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "token" ],
                predicates.records.record
                {
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                      ],
                  token = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          roles-inner
            | doc m%"
            The roles object consists of the following possibilities:
            For end-user accounts: INDIVIDUAL, ADMINISTRATOR, SUPER_ADMINISTRATOR, L1_SUPPORT, L2_SUPPORT, COMPLIANCE_OFFICER, SUPER_COMPLIANCE_OFFICER
            For service accounts: INDIVIDUAL, USER_PROVISIONING, SCOPE_MANAGEMENT, CONTENT_MANAGEMENT, MALWARE_SCAN_MANAGER, MALWARE_SCAN_STATE_USER, AUDIT_TRAIL_MANAGEMENT
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum
                    [
                      "INDIVIDUAL",
                      "ADMINISTRATOR",
                      "SUPER_ADMINISTRATOR",
                      "L1_SUPPORT",
                      "L2_SUPPORT",
                      "COMPLIANCE_OFFICER",
                      "SUPER_COMPLIANCE_OFFICER",
                      "USER_PROVISIONING",
                      "SCOPE_MANAGEMENT",
                      "CONTENT_MANAGEMENT",
                      "MALWARE_SCAN_MANAGER",
                      "MALWARE_SCAN_STATE_USER",
                      "AUDIT_TRAIL_MANAGEMENT",
                      "AGENT",
                      "CONTENT_EXPORT_SERVICE",
                      "SYMPHONY_ADMIN",
                      "KEY_MANAGER",
                      "EF_POLICY_MANAGEMENT",
                      "CEP_VISIBILITY_GROUP_MANAGEMENT"
                    ]
                  ]),
                  predicates.arrays.uniqueItems
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.minLength 1,
                  predicates.strings.pattern "^\\$\\{.*\\}$"
                ],
                predicates.enum [ "${variables.VARIABLE_NAME}" ]
              ],
          room-created-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "room-created" ],
                predicates.records.record
                {
                  room-created = definitions.predicate.room-created-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          room-created-event-inner = predicates.isType 'Record,
          room-deactivated-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "room-deactivated" ],
                predicates.records.record
                {
                  room-deactivated =
                    definitions.predicate.room-deactivated-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          room-deactivated-event-inner = predicates.isType 'Record,
          room-description = predicates.anyOf
              [
                predicates.enum
                [
                  "${ACTIVITY_ID.outputs.room.roomAttributes.description}",
                  "${variables.VARIABLE_NAME}"
                ],
                predicates.isType '"String"
              ],
          room-member-demoted-from-owner-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "room-member-demoted-from-owner" ],
                predicates.records.record
                {
                  room-member-demoted-from-owner =
                    definitions.predicate.room-member-demoted-from-owner-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          room-member-demoted-from-owner-event-inner = predicates.isType
              'Record,
          room-member-promoted-to-owner-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "room-member-promoted-to-owner" ],
                predicates.records.record
                {
                  room-member-promoted-to-owner =
                    definitions.predicate.room-member-promoted-to-owner-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          room-member-promoted-to-owner-event-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          room-name = predicates.anyOf
              [
                predicates.enum
                [
                  "${ACTIVITY_ID.outputs.room.roomAttributes.name}",
                  "${ACTIVITY_ID.outputs.stream.roomAttributes.name}",
                  "${variables.VARIABLE_NAME}"
                ],
                predicates.allOf
                [ predicates.isType '"String", predicates.strings.maxLength 50 ]
              ],
          room-reactivated-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "room-reactivated" ],
                predicates.records.record
                {
                  room-reactivated =
                    definitions.predicate.room-reactivated-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          room-reactivated-event-inner = predicates.isType 'Record,
          room-updated-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "room-updated" ],
                predicates.records.record
                {
                  room-updated = definitions.predicate.room-updated-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          room-updated-event-inner = predicates.isType 'Record,
          search-user-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  local = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          send-message-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "content" ],
                predicates.records.record
                {
                  attachments = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.attachment
                      ],
                  content = definitions.predicate.content-inner,
                  data = predicates.isType '"String",
                  obo = definitions.predicate.obo-inner,
                  to = definitions.predicate.to,
                }
                {  }
                true
                predicates.always
              ],
          single-attachment = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          skip
            | doc m%"
            Number of elements to be skipped during return - used for pagination.
            "%
            = predicates.anyOf
              [
                predicates.enum [ "${variables.VARIABLE_NAME}" ],
                predicates.allOf
                [
                  predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType '"String" ],
                  predicates.numbers.minimum 0
                ]
              ],
          stream-id
            | doc m%"
            Stream id to sent the message to.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "stream-id" ],
                predicates.records.record
                { stream-id = definitions.predicate.stream-id-inner, }
                {  }
                true
                predicates.always
              ],
          stream-id-inner
            | doc m%"
            Stream identifier. Both safe url and Base64 encoded urls are accepted.
            "%
            = predicates.anyOf
              [
                predicates.enum
                [
                  "${event.source.message.stream.streamId}",
                  "${variables.VARIABLE_NAME}",
                  "${ACTIVITY_ID.outputs.roomId}",
                  "${ACTIVITY_ID.outputs.stream.id}"
                ],
                definitions.predicate.id
              ],
          stream-ids
            | doc m%"
            Stream ids to sent the message to (blast message).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "stream-ids" ],
                predicates.records.record
                {
                  stream-ids = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.strings.minLength 1,
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          sub-type = predicates.allOf
              [ predicates.isType '"String", predicates.enum [ "EMAIL" ] ],
          tenants-users-list = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  tenant-ids = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Integer
                            ],
                            predicates.numbers.minimum 0,
                            predicates.strings.minLength 1
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                  user-ids = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Integer
                            ],
                            predicates.numbers.minimum 0,
                            predicates.strings.minLength 1
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          timer-fired-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "timer-fired" ],
                predicates.records.record
                { timer-fired = definitions.predicate.timer-fired-event-inner, }
                {  }
                false
                predicates.never
              ],
          timer-fired-event-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [ definitions.predicate.repeat, definitions.predicate.at ]
              ],
          to = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  definitions.predicate.stream-id,
                  definitions.predicate.stream-ids,
                  definitions.predicate.user-ids
                ]
              ],
          unpin-message-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "stream-id" ],
                predicates.records.record
                {
                  obo = definitions.predicate.obo-inner,
                  stream-id = definitions.predicate.stream-id-inner,
                }
                {  }
                true
                predicates.always
              ],
          update-group-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "group-id" ],
                predicates.records.record
                {
                  e-tag = predicates.isType '"String",
                  group-id = definitions.predicate.group-id,
                  image-path = predicates.anyOf
                      [
                        predicates.enum [ "${variables.VARIABLE_NAME}" ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]
                      ],
                  status = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ACTIVE", "DELETED" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          update-message-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "content", "message-id" ],
                predicates.records.record
                {
                  content = definitions.predicate.content-inner,
                  message-id = definitions.predicate.message-id-inner,
                  silent = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          update-room-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "stream-id" ],
                predicates.records.record
                {
                  active = definitions.predicate.active,
                  copy-protected = definitions.predicate.copy-protected,
                  cross-pod = definitions.predicate.cross-pod,
                  discoverable = definitions.predicate.discoverable,
                  keywords = definitions.predicate.keywords,
                  members-can-invite = definitions.predicate.members-can-invite,
                  multilateral-room = definitions.predicate.multilateral-room,
                  obo = definitions.predicate.obo-inner,
                  public = definitions.predicate.public,
                  read-only = definitions.predicate.read-only,
                  room-description = definitions.predicate.room-description,
                  room-name = definitions.predicate.room-name,
                  stream-id = definitions.predicate.stream-id-inner,
                  view-history = definitions.predicate.view-history,
                }
                {  }
                true
                predicates.always
              ],
          user-id
            | doc m%"
            User id.
            "%
            = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Integer ],
                  predicates.strings.minLength 1
                ],
                predicates.enum
                [
                  "${ACTIVITY_ID.outputs.user.userSystemInfo.id}",
                  "${event.initiator.user.userId}",
                  "${event.source.fromUser.userId}",
                  "${event.source.toUser.userId}"
                ]
              ],
          user-ids
            | doc m%"
            List of user ids.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "user-ids" ],
                predicates.records.record
                { user-ids = definitions.predicate.user-ids-inner, }
                {  }
                true
                predicates.always
              ],
          user-ids-inner
            | doc m%"
            User identifiers list.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.strings.minLength 1,
                  predicates.arrays.arrayOf definitions.predicate.user-id,
                  predicates.arrays.uniqueItems
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.minLength 1,
                  predicates.strings.pattern "^\\$\\{.*\\}$"
                ],
                predicates.enum [ "${variables.VARIABLE_NAME}" ]
              ],
          user-joined-room-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "user-joined-room" ],
                predicates.records.record
                {
                  user-joined-room =
                    definitions.predicate.user-joined-room-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          user-joined-room-event-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          user-left-room-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "user-left-room" ],
                predicates.records.record
                {
                  user-left-room =
                    definitions.predicate.user-left-room-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          user-left-room-event-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          user-requested-join-room-event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "user-requested-join-room" ],
                predicates.records.record
                {
                  user-requested-join-room =
                    definitions.predicate.user-requested-join-room-event-inner,
                }
                {  }
                true
                predicates.always
              ],
          user-requested-join-room-event-inner = predicates.isType 'Record,
          user-role-inner = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "roles", "user-ids" ],
                predicates.records.record
                {
                  roles = definitions.predicate.roles-inner,
                  user-ids = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Integer
                            ],
                            predicates.strings.minLength 1
                          ]),
                          predicates.arrays.minItems 1,
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{.*\\}$"
                        ],
                        predicates.enum [ "${variables.VARIABLE_NAME}" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          view-history
            | doc m%"
            If true, new members can view the room chat history of the room.
            "%
            = predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
        },
  }
in

{
  activities
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.strings.minLength 1,
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.maxProperties 1,
        predicates.records.minProperties 1,
        predicates.records.record
        {
          accept-connection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.connection-inner
                ]
              ],
          add-group-member = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.add-group-member-inner
                ]
              ],
          add-room-member = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.add-room-member-inner
              ],
          add-user-role = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.user-role-inner
              ],
          create-connection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.connection-inner
                ]
              ],
          create-group = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.create-group-inner
                ],
                predicates.records.required
                [ "members", "name", "owner", "profile" ],
                predicates.records.record {  } {  } true predicates.always
              ],
          create-room = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.create-room-inner
              ],
          create-system-user = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                predicates.allOf
                [
                  predicates.records.required
                  [ "display-name", "email", "username" ],
                  predicates.records.record {  } {  } true predicates.always,
                  definitions.predicate.create-system-user-inner
                ]
              ],
          create-user = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                predicates.allOf
                [
                  predicates.records.required
                  [
                    "display-name",
                    "email",
                    "firstname",
                    "lastname",
                    "username"
                  ],
                  predicates.records.record {  } {  } true predicates.always,
                  definitions.predicate.create-user-inner
                ]
              ],
          debug = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "object" ],
                predicates.records.record
                {
                  "else" = predicates.isType 'Record,
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                      ],
                  "if" = predicates.isType '"String",
                  object = predicates.anyOf
                      [
                        predicates.isType 'Record,
                        predicates.isType '"String"
                      ],
                  on = definitions.predicate.on,
                }
                {  }
                true
                predicates.always
              ],
          demote-room-owner = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.demote-room-owner-inner
              ],
          execute-request = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.execute-request-inner
              ],
          execute-script = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.execute-script-inner
              ],
          get-attachment = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.get-attachment-inner
              ],
          get-connection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.connection-inner
                ]
              ],
          get-connections = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.get-connections-inner
                ]
              ],
          get-group = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.get-group-inner
                ]
              ],
          get-groups = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.get-groups-inner
                ]
              ],
          get-message = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.get-message-inner
                ]
              ],
          get-messages = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.get-messages-inner
                ]
              ],
          get-room = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.get-room-inner
                ]
              ],
          get-room-members = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.get-room-members-inner
                ]
              ],
          get-rooms = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.get-rooms-inner
                ]
              ],
          get-stream = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.get-stream-inner
                ]
              ],
          get-stream-members = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.get-stream-members-inner
                ]
              ],
          get-streams = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.get-streams-inner
                ]
              ],
          get-user = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.get-user-inner
                ]
              ],
          get-user-streams = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.get-user-streams-inner
                ]
              ],
          get-users = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.get-users-inner
                ]
              ],
          pin-message = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.pin-message-inner
              ],
          promote-room-owner = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.promote-room-owner-inner
              ],
          reject-connection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.connection-inner
                ]
              ],
          remove-connection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.connection-inner
                ]
              ],
          remove-room-member = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.remove-room-member-inner
              ],
          remove-user-role = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.user-role-inner
              ],
          send-message = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.send-message-inner
              ],
          unpin-message = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.unpin-message-inner
              ],
          update-group = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.basic-activity-inner,
                  definitions.predicate.create-group-inner,
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    definitions.predicate.update-group-inner
                  ]
                ]
              ],
          update-message = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.update-message-inner
              ],
          update-room = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.update-room-inner
              ],
          update-system-user = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.create-system-user-inner,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "user-id" ],
                  predicates.records.record
                  { user-id = definitions.predicate.user-id, }
                  {  }
                  true
                  predicates.always
                ]
              ],
          update-user = predicates.allOf
              [
                definitions.predicate.basic-activity-inner,
                definitions.predicate.create-user-inner,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "user-id" ],
                  predicates.records.record
                  { user-id = definitions.predicate.user-id, }
                  {  }
                  true
                  predicates.always
                ]
              ],
        }
        {
          "^(?!create-room|update-room|add-room-member|remove-room-member|promote-room-owner|demote-room-owner|send-message|update-message|pin-message|unpin-message|debug|execute-script|execute-request|create-user|create-system-user|create-connection|update-user|update-system-user|add-user-role|remove-user-role|remove-connection|reject-connection|accept-connection|get-user|get-users|get-stream|get-room|get-message|get-connection|get-stream-members|get-room-members|get-user-streams|get-streams|get-rooms|get-messages|get-connections)([a-z0-9-]+)$" =
            definitions.predicate.basic-activity-inner,
        }
        false
        predicates.never
      ])
    ])
    | doc m%"
    A list of activities to be executed by the workflow. By default the execution is sequential but complex logic can be orchestrated with if/else conditions as well as on/activity-completed events.
    "%,
  id
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"String",
      predicates.strings.maxLength 100,
      predicates.strings.pattern "^[a-zA-Z]+[a-zA-Z0-9][^ ]*$"
    ])
    | doc m%"
    Workflow's id should start with a letter. It is optional. If no id is provided, the workflow filename is used. Otherwise, it will be generated. The id will appear in logs and audit trails.
    "%,
  properties
    | {
      publish
        | predicates.contract_from_predicate
        (predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType '"String" ])
        | doc m%"
        Should the workflow be published or not, true publish, false otherwise
        "%
        | optional,
      ..
    }
    | doc m%"
    Some metadata about the workflow
    "%
    | optional,
  variables
    | {  .. }
    | doc m%"
    Variables are accessible and editable within the entire workflow. A map of key: value entries is expected.
    "%
    | optional,
}