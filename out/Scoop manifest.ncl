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
          architecture = {
                bin
                  | definitions.contract.stringOrArrayOfStringsOrAnArrayOfArrayOfStrings
                  | optional,
                checkver | definitions.contract.checkver | optional,
                env_add_path
                  | definitions.contract.stringOrArrayOfStrings
                  | optional,
                env_set | {  .. } | optional,
                extract_dir
                  | definitions.contract.stringOrArrayOfStrings
                  | optional,
                hash | definitions.contract.hash | optional,
                installer | definitions.contract.installer | optional,
                msi
                  | definitions.contract.stringOrArrayOfStrings
                  | doc m%"
                  Deprecated
                  "%
                  | optional,
                post_install
                  | definitions.contract.stringOrArrayOfStrings
                  | optional,
                post_uninstall
                  | definitions.contract.stringOrArrayOfStrings
                  | optional,
                pre_install
                  | definitions.contract.stringOrArrayOfStrings
                  | optional,
                pre_uninstall
                  | definitions.contract.stringOrArrayOfStrings
                  | optional,
                shortcuts | definitions.contract.shortcutsArray | optional,
                uninstaller | definitions.contract.uninstaller | optional,
                url | definitions.contract.uriOrArrayOfUris | optional,
              },
          arrayOfArrayOfStrings = predicates.contract_from_predicate
              definitions.predicate.arrayOfArrayOfStrings,
          autoupdate = {
                architecture
                  | {
                    "32bit" | definitions.contract.autoupdateArch | optional,
                    "64bit" | definitions.contract.autoupdateArch | optional,
                    arm64 | definitions.contract.autoupdateArch | optional,
                  }
                  | optional,
                bin
                  | definitions.contract.stringOrArrayOfStringsOrAnArrayOfArrayOfStrings
                  | optional,
                env_add_path
                  | definitions.contract.stringOrArrayOfStrings
                  | optional,
                env_set | {  .. } | optional,
                extract_dir
                  | definitions.contract.stringOrArrayOfStrings
                  | optional,
                hash
                  | definitions.contract.hashExtractionOrArrayOfHashExtractions
                  | optional,
                installer | { file | String | optional, } | optional,
                license | definitions.contract.license | optional,
                notes | definitions.contract.stringOrArrayOfStrings | optional,
                persist
                  | definitions.contract.stringOrArrayOfStringsOrAnArrayOfArrayOfStrings
                  | optional,
                psmodule | { name | String | optional, } | optional,
                shortcuts | definitions.contract.shortcutsArray | optional,
                url
                  | definitions.contract.autoupdateUriOrArrayOfAutoupdateUris
                  | optional,
              },
          autoupdateArch = {
                bin
                  | definitions.contract.stringOrArrayOfStringsOrAnArrayOfArrayOfStrings
                  | optional,
                env_add_path
                  | definitions.contract.stringOrArrayOfStrings
                  | optional,
                env_set | {  .. } | optional,
                extract_dir
                  | definitions.contract.stringOrArrayOfStrings
                  | optional,
                hash
                  | definitions.contract.hashExtractionOrArrayOfHashExtractions
                  | optional,
                installer | { file | String | optional, } | optional,
                shortcuts | definitions.contract.shortcutsArray | optional,
                url
                  | definitions.contract.autoupdateUriOrArrayOfAutoupdateUris
                  | optional,
              },
          autoupdateUriOrArrayOfAutoupdateUris =
            predicates.contract_from_predicate
              definitions.predicate.autoupdateUriOrArrayOfAutoupdateUris,
          checkver = predicates.contract_from_predicate
              definitions.predicate.checkver,
          hash = predicates.contract_from_predicate definitions.predicate.hash,
          hashExtraction = {
                find
                  | String
                  | doc m%"
                  Same as 'regex'
                  "%
                  | optional,
                jp
                  | definitions.contract.jsonPathPattern
                  | doc m%"
                  Same as 'jsonpath'
                  "%
                  | optional,
                jsonpath | definitions.contract.jsonPathPattern | optional,
                mode
                  | predicates.contract_from_predicate
                  (predicates.enum
                  [
                    "download",
                    "extract",
                    "json",
                    "xpath",
                    "rdf",
                    "metalink",
                    "fosshub",
                    "sourceforge"
                  ])
                  | optional,
                regex | String | optional,
                type
                  | predicates.contract_from_predicate
                  (predicates.enum [ "md5", "sha1", "sha256", "sha512" ])
                  | doc m%"
                  Deprecated, hash type is determined automatically
                  "%
                  | optional,
                url
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern
                      "^(\\$url|\\$baseurl).[\\w\\d]+$"
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern "^.*(\\$url|\\$baseurl).*$"
                    ]
                  ])
                  | optional,
                xpath | String | optional,
              },
          hashExtractionOrArrayOfHashExtractions =
            predicates.contract_from_predicate
              definitions.predicate.hashExtractionOrArrayOfHashExtractions,
          hashPattern = predicates.contract_from_predicate
              definitions.predicate.hashPattern,
          installer = {
                _comment
                  | String
                  | doc m%"
                  Undocumented: only used in scoop-extras/oraclejdk* and scoop-extras/appengine-go
                  "%
                  | optional,
                args | definitions.contract.stringOrArrayOfStrings | optional,
                file | String | optional,
                keep | Bool | optional,
                script | definitions.contract.stringOrArrayOfStrings | optional,
              },
          jsonPathPattern = predicates.contract_from_predicate
              definitions.predicate.jsonPathPattern,
          license = predicates.contract_from_predicate
              definitions.predicate.license,
          licenseIdentifiers
            | doc m%"
            License identifier based on SPDX License List https://spdx.org/licenses/
            "%
            = String,
          shortcutsArray = predicates.contract_from_predicate
              definitions.predicate.shortcutsArray,
          stringOrArrayOfStrings = predicates.contract_from_predicate
              definitions.predicate.stringOrArrayOfStrings,
          stringOrArrayOfStringsOrAnArrayOfArrayOfStrings =
            predicates.contract_from_predicate
              definitions.predicate.stringOrArrayOfStringsOrAnArrayOfArrayOfStrings,
          uninstaller = predicates.contract_from_predicate
              definitions.predicate.uninstaller,
          uriOrArrayOfUris = predicates.contract_from_predicate
              definitions.predicate.uriOrArrayOfUris,
        },
    predicate = {
          architecture = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bin =
                    definitions.predicate.stringOrArrayOfStringsOrAnArrayOfArrayOfStrings,
                  checkver = definitions.predicate.checkver,
                  env_add_path = definitions.predicate.stringOrArrayOfStrings,
                  env_set = predicates.isType 'Record,
                  extract_dir = definitions.predicate.stringOrArrayOfStrings,
                  hash = definitions.predicate.hash,
                  installer = definitions.predicate.installer,
                  msi = definitions.predicate.stringOrArrayOfStrings,
                  post_install = definitions.predicate.stringOrArrayOfStrings,
                  post_uninstall = definitions.predicate.stringOrArrayOfStrings,
                  pre_install = definitions.predicate.stringOrArrayOfStrings,
                  pre_uninstall = definitions.predicate.stringOrArrayOfStrings,
                  shortcuts = definitions.predicate.shortcutsArray,
                  uninstaller = definitions.predicate.uninstaller,
                  url = definitions.predicate.uriOrArrayOfUris,
                }
                {  }
                false
                predicates.never
              ],
          arrayOfArrayOfStrings = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String"),
                  predicates.arrays.minItems 1
                ]),
                predicates.arrays.minItems 1
              ],
          autoupdate = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  architecture = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          "32bit" = definitions.predicate.autoupdateArch,
                          "64bit" = definitions.predicate.autoupdateArch,
                          arm64 = definitions.predicate.autoupdateArch,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  bin =
                    definitions.predicate.stringOrArrayOfStringsOrAnArrayOfArrayOfStrings,
                  env_add_path = definitions.predicate.stringOrArrayOfStrings,
                  env_set = predicates.isType 'Record,
                  extract_dir = definitions.predicate.stringOrArrayOfStrings,
                  hash =
                    definitions.predicate.hashExtractionOrArrayOfHashExtractions,
                  installer = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { file = predicates.isType '"String", }
                        {  }
                        false
                        predicates.never
                      ],
                  license = definitions.predicate.license,
                  notes = definitions.predicate.stringOrArrayOfStrings,
                  persist =
                    definitions.predicate.stringOrArrayOfStringsOrAnArrayOfArrayOfStrings,
                  psmodule = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { name = predicates.isType '"String", }
                        {  }
                        false
                        predicates.never
                      ],
                  shortcuts = definitions.predicate.shortcutsArray,
                  url =
                    definitions.predicate.autoupdateUriOrArrayOfAutoupdateUris,
                }
                {  }
                false
                predicates.never
              ],
          autoupdateArch = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bin =
                    definitions.predicate.stringOrArrayOfStringsOrAnArrayOfArrayOfStrings,
                  env_add_path = definitions.predicate.stringOrArrayOfStrings,
                  env_set = predicates.isType 'Record,
                  extract_dir = definitions.predicate.stringOrArrayOfStrings,
                  hash =
                    definitions.predicate.hashExtractionOrArrayOfHashExtractions,
                  installer = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { file = predicates.isType '"String", }
                        {  }
                        false
                        predicates.never
                      ],
                  shortcuts = definitions.predicate.shortcutsArray,
                  url =
                    definitions.predicate.autoupdateUriOrArrayOfAutoupdateUris,
                }
                {  }
                false
                predicates.never
              ],
          autoupdateUriOrArrayOfAutoupdateUris = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String"),
                  predicates.arrays.minItems 1,
                  predicates.arrays.uniqueItems
                ]
              ],
          checkver = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    github = predicates.isType '"String",
                    jp = definitions.predicate.jsonPathPattern,
                    jsonpath = definitions.predicate.jsonPathPattern,
                    re = predicates.isType '"String",
                    regex = predicates.isType '"String",
                    replace = predicates.isType '"String",
                    reverse = predicates.isType '"Bool",
                    script = definitions.predicate.stringOrArrayOfStrings,
                    sourceforge = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              path = predicates.isType '"String",
                              project = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ]
                        ],
                    url = predicates.isType '"String",
                    useragent = predicates.isType '"String",
                    xpath = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          hash = predicates.anyOf
              [
                definitions.predicate.hashPattern,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.hashPattern,
                  predicates.arrays.minItems 1,
                  predicates.arrays.uniqueItems
                ]
              ],
          hashExtraction = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  find = predicates.isType '"String",
                  jp = definitions.predicate.jsonPathPattern,
                  jsonpath = definitions.predicate.jsonPathPattern,
                  mode = predicates.enum
                      [
                        "download",
                        "extract",
                        "json",
                        "xpath",
                        "rdf",
                        "metalink",
                        "fosshub",
                        "sourceforge"
                      ],
                  regex = predicates.isType '"String",
                  type = predicates.enum [ "md5", "sha1", "sha256", "sha512" ],
                  url = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^(\\$url|\\$baseurl).[\\w\\d]+$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^.*(\\$url|\\$baseurl).*$"
                        ]
                      ],
                  xpath = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          hashExtractionOrArrayOfHashExtractions = predicates.anyOf
              [
                definitions.predicate.hashExtraction,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.hashExtraction,
                  predicates.arrays.minItems 1
                ]
              ],
          hashPattern = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^([a-fA-F0-9]{64}|(sha1|sha256|sha512|md5):([a-fA-F0-9]{32}|[a-fA-F0-9]{40}|[a-fA-F0-9]{64}|[a-fA-F0-9]{128}))$"
              ],
          installer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  _comment = predicates.isType '"String",
                  args = definitions.predicate.stringOrArrayOfStrings,
                  file = predicates.isType '"String",
                  keep = predicates.isType '"Bool",
                  script = definitions.predicate.stringOrArrayOfStrings,
                }
                {  }
                false
                predicates.never
              ],
          jsonPathPattern = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^\\$[.\\[].*$"
              ],
          license = predicates.anyOf
              [
                definitions.predicate.licenseIdentifiers,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "identifier" ],
                  predicates.records.record
                  {
                    identifier = definitions.predicate.licenseIdentifiers,
                    url = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          licenseIdentifiers
            | doc m%"
            License identifier based on SPDX License List https://spdx.org/licenses/
            "%
            = predicates.isType '"String",
          shortcutsArray = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String"),
                  predicates.arrays.maxItems 4,
                  predicates.arrays.minItems 2
                ]),
                predicates.arrays.minItems 1
              ],
          stringOrArrayOfStrings = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String"),
                  predicates.arrays.minItems 1
                ]
              ],
          stringOrArrayOfStringsOrAnArrayOfArrayOfStrings = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.stringOrArrayOfStrings,
                  predicates.arrays.minItems 1
                ]
              ],
          uninstaller = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "file" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "script" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  args = definitions.predicate.stringOrArrayOfStrings,
                  file = predicates.isType '"String",
                  script = definitions.predicate.stringOrArrayOfStrings,
                }
                {  }
                true
                predicates.always
              ],
          uriOrArrayOfUris = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.not (predicates.strings.pattern "(\\$)")
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.not (predicates.strings.pattern "(\\$)")
                  ]),
                  predicates.arrays.minItems 1,
                  predicates.arrays.uniqueItems
                ]
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.ifThenElse
  (predicates.records.record
  {
    architecture = predicates.records.record
        {
          "32bit" = predicates.records.record { url = predicates.never, } {  }
              true
              predicates.always,
          "64bit" = predicates.records.record { url = predicates.never, } {  }
              true
              predicates.always,
          arm64 = predicates.records.record { url = predicates.never, } {  }
              true
              predicates.always,
        }
        {  }
        true
        predicates.always,
  }
  {  }
  true
  predicates.always)
  (predicates.allOf
  [
    predicates.records.required [ "url" ],
    predicates.records.record {  } {  } true predicates.always
  ])
  predicates.always,
  predicates.records.required [ "homepage", "license", "version" ],
  predicates.records.record
  {
    "##" = definitions.predicate.stringOrArrayOfStrings,
    "$schema" = predicates.isType '"String",
    _comment = definitions.predicate.stringOrArrayOfStrings,
    architecture = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            "32bit" = definitions.predicate.architecture,
            "64bit" = definitions.predicate.architecture,
            arm64 = definitions.predicate.architecture,
          }
          {  }
          false
          predicates.never
        ],
    autoupdate = definitions.predicate.autoupdate,
    bin = definitions.predicate.stringOrArrayOfStringsOrAnArrayOfArrayOfStrings,
    checkver = definitions.predicate.checkver,
    cookie = predicates.isType 'Record,
    depends = definitions.predicate.stringOrArrayOfStrings,
    description = predicates.isType '"String",
    env_add_path = definitions.predicate.stringOrArrayOfStrings,
    env_set = predicates.isType 'Record,
    extract_dir = definitions.predicate.stringOrArrayOfStrings,
    extract_to = definitions.predicate.stringOrArrayOfStrings,
    hash = definitions.predicate.hash,
    homepage = predicates.isType '"String",
    innosetup = predicates.isType '"Bool",
    installer = definitions.predicate.installer,
    license = definitions.predicate.license,
    msi = definitions.predicate.stringOrArrayOfStrings,
    notes = definitions.predicate.stringOrArrayOfStrings,
    persist =
      definitions.predicate.stringOrArrayOfStringsOrAnArrayOfArrayOfStrings,
    post_install = definitions.predicate.stringOrArrayOfStrings,
    post_uninstall = definitions.predicate.stringOrArrayOfStrings,
    pre_install = definitions.predicate.stringOrArrayOfStrings,
    pre_uninstall = definitions.predicate.stringOrArrayOfStrings,
    psmodule = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record { name = predicates.isType '"String", } {  }
          false
          predicates.never
        ],
    shortcuts = definitions.predicate.shortcutsArray,
    suggest = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          { "^(.*)$" = definitions.predicate.stringOrArrayOfStrings, }
          false
          predicates.never
        ],
    uninstaller = definitions.predicate.uninstaller,
    url = definitions.predicate.uriOrArrayOfUris,
    version = predicates.allOf
        [
          predicates.isType '"String",
          predicates.strings.pattern "^[\\w\\.\\-+_]+$"
        ],
  }
  {  }
  false
  predicates.never
])