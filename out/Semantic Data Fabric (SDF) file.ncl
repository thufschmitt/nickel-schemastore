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
          AccessControlPath = {
                access
                  | predicates.contract_from_predicate
                  definitions.predicate.Grant
                  | doc m%"
                  Grant access
                  "%,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A description of this access control rule
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of check (default filestem of path)
                  "%,
                path
                  | String
                  | doc m%"
                  A filepath to a policy authored in .sql
                  "%,
                time
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.SystemTime, predicates.isType 'Null ])
                  | optional,
              },
          AccessMethod = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'catalog-schema-table-name,
                  'schema-table-name,
                  'table-name,
                  'scan
                |]
              ],
          Cardinality = std.contract.Sequence
              [ std.enum.TagOrString, [| 'zero-or-more, 'one, 'zero-or-one |] ],
          Catalog
            | doc m%"
            External Catalogs used to get metadata about tables
            "%
            = {
                name
                  | String
                  | doc m%"
                  The name of the catalog [e.g.: database]
                  "%,
                type
                  | predicates.contract_from_predicate
                  definitions.predicate.CatalogType
                  | doc m%"
                  The type of the catalog [e.g.: hive]
                  "%,
              },
          CatalogType = std.contract.Sequence
              [ std.enum.TagOrString, [| 'glue |] ],
          Classifier
            | doc m%"
            A classifier defines the labels that can be attached to columns or a table.
            "%
            = {
                cardinality
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Cardinality,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  cardinality of the classifier: zero-or-one, one or zero-or-many
                  "%
                  | optional,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A description of this classifier type
                  "%
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.Label
                  ])
                  | doc m%"
                  Named classifier labels
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the classifier type
                  "%,
                propagate
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  does the classifier propagate from scope to scope or is it a one scope marker
                  "%
                  | optional,
                scope
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Scope, predicates.isType 'Null ])
                  | doc m%"
                  scope of the classifier: table or column
                  "%
                  | optional,
                source-locations
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.FilePath, predicates.isType 'Null ])
                  | doc m%"
                  Classifier defined by these set of .sdf files
                  "%
                  | optional,
              },
          CodeAssertion = std.contract.Sequence
              [ std.enum.TagOrString, [| 'not-exists, 'exists |] ],
          CodeCheckPath = {
                assert
                  | predicates.contract_from_predicate
                  definitions.predicate.CodeAssertion
                  | doc m%"
                  Assertion
                  "%,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A description of this assertion
                  "%
                  | optional,
                dialect
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Dialect, predicates.isType 'Null ])
                  | doc m%"
                  dialect
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Name of check (default filestem of path)
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  A filepath
                  "%,
              },
          CodeReportPath = {
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A description of this report
                  "%
                  | optional,
                dialect
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Dialect, predicates.isType 'Null ])
                  | doc m%"
                  dialect
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of check (default filestem of path)
                  "%,
                path
                  | String
                  | doc m%"
                  A filepath
                  "%,
              },
          Column = {
                classifiers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of classifier references
                  "%
                  | optional,
                datatype
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The type of this column
                  "%
                  | optional,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A description of this column
                  "%
                  | optional,
                lineage
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Lineage, predicates.isType 'Null ])
                  | doc m%"
                  Lineage, a tagged array of column references
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the column
                  "%,
                nullable
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  The type of this column
                  "%
                  | optional,
                reclassify
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.Reclassify
                  ])
                  | doc m%"
                  Array of reclassify instructions for changing the attached classifier labels
                  "%
                  | optional,
              },
          CompressionType
            | doc m%"
            Compress table data using these methods
            "%
            = predicates.contract_from_predicate
              definitions.predicate.CompressionType,
          Config
            | doc m%"
            A configuration with section name and properties
            "%
            = {
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A description of this configuration section
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the configuration section
                  "%,
                properties
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
              },
          Dialect = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'redshift, 'bigquery, 'presto, 'sdf |]
              ],
          Example = {
                input
                  | String
                  | doc m%"
                  The sql string corresponding to the input of this example
                  "%,
                output
                  | String
                  | doc m%"
                  The output corresponding to running the input string
                  "%,
              },
          FileFormat
            | doc m%"
            Store table data in these formats
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| 'json, 'csv, 'parquet |] ],
          FilePath
            | doc m%"
            All file path should either be relative to the workspace, or absolute for an object store like AWS s3://
            "%
            = {
                path
                  | String
                  | doc m%"
                  A filepath
                  "%,
                time
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.SystemTime, predicates.isType 'Null ])
                  | doc m%"
                  Last modified of the file
                  "%
                  | optional,
              },
          Function
            | doc m%"
            A function block defines the signature for user defined
            "%
            = {
                binds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.TypeBound
                  ])
                  | doc m%"
                  The generic type bounds
                  "%
                  | optional,
                cross-link
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  cross-link - link to existing documentation, for example: https://prestodb.io/docs/current/functions/datetime.html#truncation-function
                  "%
                  | optional,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A description of this function
                  "%
                  | optional,
                dialect
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Dialect, predicates.isType 'Null ])
                  | doc m%"
                  The dialect that provides this function
                  "%
                  | optional,
                examples
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.Example
                  ])
                  | doc m%"
                  example - Example use of the function (tuple with input/output)
                  "%
                  | optional,
                implemented-by
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FunctionImplSpec,
                    predicates.isType 'Null
                  ])
                  | optional,
                kind
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FunctionKind,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The function kind
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the function [syntax: [[catalog.]schema].function]
                  "%,
                optional-parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    definitions.predicate.OptionalParameter
                  ])
                  | doc m%"
                  The arguments of this function
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.Parameter
                  ])
                  | doc m%"
                  The arguments of this function
                  "%
                  | optional,
                reclassify
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.Reclassify
                  ])
                  | doc m%"
                  Array of reclassify instructions for changing the attached classifier labels
                  "%
                  | optional,
                returns
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Parameter, predicates.isType 'Null ])
                  | doc m%"
                  The results of this function (can be a tuple)
                  "%
                  | optional,
                section
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The generic type bounds
                  "%
                  | optional,
                source-locations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.FilePath
                  ])
                  | doc m%"
                  Function defined by these set of .sdf files
                  "%
                  | optional,
                variadic
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Variadic, predicates.isType 'Null ])
                  | doc m%"
                  Arbitrary number of arguments of an common type out of a list of valid types
                  "%
                  | optional,
                volatility
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Volatility, predicates.isType 'Null ])
                  | doc m%"
                  volatility - The volatility of the function.
                  "%
                  | optional,
              },
          FunctionImplSpec = std.contract.Sequence
              [ std.enum.TagOrString, [| 'sql, 'builtin |] ],
          FunctionKind = std.contract.Sequence
              [ std.enum.TagOrString, [| 'window, 'aggregate, 'scalar |] ],
          Grant = std.contract.Sequence
              [ std.enum.TagOrString, [| 'allow, 'deny |] ],
          IncludePath
            | doc m%"
            All file path should either be relative to the workspace, or absolute for an object store like AWS s3:// Note that an [IncludePath] specifies a catalog and schema scope for unqualified names (in effect for both creating and querying tables). See [IncludePath::default_catalog] and [IncludePath::default_schema].
            "%
            = {
                access-with
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.AccessMethod,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Last modified of the file
                  "%
                  | optional,
                default-catalog
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Defines a default catalog for unqualified names. If not set, defaults to the [Workspace] catalog.
                  "%
                  | optional,
                default-schema
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Defines a default schema for unqualified names. If not set, defaults to the [Workspace] schema.
                  "%
                  | optional,
                dialect
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Dialect, predicates.isType 'Null ])
                  | doc m%"
                  The dialect of the included files. If not set, defaults to the [Workspace] dialect.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  A filepath
                  "%,
                time
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.SystemTime, predicates.isType 'Null ])
                  | doc m%"
                  Last modified of the file
                  "%
                  | optional,
              },
          Label
            | doc m%"
            A classifier element is a scoped classifier label (e.g. the element PII belongs to the classifier scope data)
            "%
            = {
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A description of this classifier element
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the label, use "*" to allow arbitrary strings as labels
                  "%,
              },
          Lineage = {
                apply
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  These functions were used to produce the output column
                  "%
                  | optional,
                copy
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The output column is computed by copying these upstream columns
                  "%
                  | optional,
                modify
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The output column is computed by transforming these upstream columns
                  "%
                  | optional,
                scan
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  These upstream columns are indirectly used to produce the output (e.g. in WHERE or GROUP BY)
                  "%
                  | optional,
              },
          Materialization = predicates.contract_from_predicate
              definitions.predicate.Materialization,
          OptionalParameter
            | doc m%"
            A function parameter
            "%
            = {
                classifier
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of classifier references
                  "%
                  | optional,
                constant
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The required constant value of this parameter
                  "%
                  | optional,
                datatype
                  | String
                  | doc m%"
                  The datatype of this parameter
                  "%,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A description of this parameter
                  "%
                  | optional,
                identifiers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The parameter may appear as identifier, without quote
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the parameter
                  "%,
              },
          Parameter
            | doc m%"
            A function parameter
            "%
            = {
                classifier
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of classifier references
                  "%
                  | optional,
                constant
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The required constant value of this parameter
                  "%
                  | optional,
                datatype
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The datatype of this parameter
                  "%
                  | optional,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A description of this parameter
                  "%
                  | optional,
                identifiers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The parameter may appear as identifier, without quote
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The name of the parameter
                  "%
                  | optional,
                nullable
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  The nullability of this column
                  "%
                  | optional,
              },
          Partition
            | doc m%"
            A partition is a table column, used to describe to which partition this row belongs to
            "%
            = {
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A description of the partition column
                  "%
                  | optional,
                format
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The format of the partition column [use strftime format for date/time] See (guide)[https://docs.sdf.com/guide/schedules]
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the partition column
                  "%,
              },
          Plugin
            | doc m%"
            A function block defines the signature for user defined
            "%
            = {
                dockerfile
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Path to the dockerfile of the plugin [e.g.: dockerfile]
                  "%
                  | optional,
                image-uri
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Image URI of the plugin [e.g.: docker.io/sdf/pyspark:latest]
                  "%
                  | optional,
                includes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.IncludePath
                  ])
                  | doc m%"
                  An array of directories and filenames containing files processed by this plugin
                  "%,
                keep-alive
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Whether to keep the plugin container alive after execution
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the plugin [e.g.: pyspark]
                  "%,
              },
          Profile
            | doc m%"
            Profiles provide a way to override the fields of a workspace, i.e. if a profile has set field X, then the workspace field X will be overridden by the profile field X.
            "%
            = {
                access-control
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    definitions.predicate.AccessControlPath
                  ])
                  | doc m%"
                  An array of attribute based access control queries over the information schema, current user and current job, that will be run on sdf build and sdf deploy
                  "%
                  | optional,
                code-checks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    definitions.predicate.CodeCheckPath
                  ])
                  | doc m%"
                  An array of queries over the information schema that will be run on sdf describe and sdf deploy
                  "%
                  | optional,
                code-reports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    definitions.predicate.CodeReportPath
                  ])
                  | doc m%"
                  An array of queries over the information schema that will be run on sdf describe and sdf deploy
                  "%
                  | optional,
                default-catalog
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Defines a default catalog [If not set, defaults to the directory of the workspace]
                  "%
                  | optional,
                default-schema
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Defines a default schema [If not set, defaults to 'pub']
                  "%
                  | optional,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A description of this workspace
                  "%
                  | optional,
                dialect
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Dialect, predicates.isType 'Null ])
                  | doc m%"
                  The default dialect of this workspace. If not set, defaults to sdf dialect
                  "%
                  | optional,
                excludes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.FilePath
                  ])
                  | doc m%"
                  An array of directories and filenames to be skipped when resolving includes
                  "%
                  | optional,
                includes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.IncludePath
                  ])
                  | doc m%"
                  An array of directories and filenames containing .sql and .sdf.yml files
                  "%
                  | optional,
                name | String,
                references
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    definitions.predicate.WorkspacePath
                  ])
                  | doc m%"
                  An array of paths to other workspaces, i.e. .sql and .yml files
                  "%
                  | optional,
                remote-location
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The default output object store location, e.g. 's3://bucket/key/' where key is optional
                  "%
                  | optional,
                resources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.FilePath
                  ])
                  | doc m%"
                  An array of paths to directories and files, which will be copied to the SDF service on deployment
                  "%
                  | optional,
                source-locations
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.FilePath, predicates.isType 'Null ])
                  | doc m%"
                  Workspace defined by these set of files
                  "%
                  | optional,
                variables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.Variable
                  ])
                  | doc m%"
                  An array of named values for setting SQL variables from your environment Ex. -dt: dt, used in SQL as @dt
                  "%
                  | optional,
              },
          Reclassify = {
                from
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Expected source classifier
                  "%
                  | optional,
                to
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Target classifier
                  "%
                  | optional,
              },
          Scope = std.contract.Sequence
              [ std.enum.TagOrString, [| 'table, 'column |] ],
          SystemTime = {
                nanos_since_epoch
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ]),
                secs_since_epoch
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ]),
                ..
              },
          Table
            | doc m%"
            A tables is either defined by given data (also called external table) or defined via a query.
            "%
            = {
                classifiers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of classifier references
                  "%
                  | optional,
                columns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.Column
                  ])
                  | doc m%"
                  The columns of the schema: name, type, metadata
                  "%
                  | optional,
                compression
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.CompressionType,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Json or CSV data is compressed with this method [only for external tables]
                  "%
                  | optional,
                delimiter
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  CSV data is separated by this delimiter [only for external tables]
                  "%
                  | optional,
                dependencies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  ALl table dependencies (syntax: catalog.schema.table)
                  "%
                  | optional,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | optional,
                dialect
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Dialect, predicates.isType 'Null ])
                  | doc m%"
                  An array of sql file names [Typically inferred]
                  "%
                  | optional,
                file-format
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.FileFormat, predicates.isType 'Null ])
                  | doc m%"
                  Store table in this format [only for external tables]
                  "%
                  | optional,
                insert-into
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Store data under this catalog.schema.table instead of the original name
                  "%
                  | optional,
                lineage
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Lineage, predicates.isType 'Null ])
                  | doc m%"
                  Lineage, a tagged array of column references
                  "%
                  | optional,
                location
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Data is at this location
                  "%
                  | optional,
                materialization
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Materialization,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The materialization scheme of this table
                  "%
                  | optional,
                name | String,
                partitioned-by
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.Partition
                  ])
                  | doc m%"
                  The partitioning format of the table
                  "%
                  | optional,
                reclassify
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.Reclassify
                  ])
                  | doc m%"
                  Array of reclassify instructions for changing the attached classifier labels
                  "%
                  | optional,
                schedule
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The schedule of the table [expressed as cron]
                  "%
                  | optional,
                source-locations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.FilePath
                  ])
                  | doc m%"
                  Table is defined by these .sql and/or .sdf files
                  "%
                  | optional,
                starting
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The first date of the table [expressed by prefixes of RFC 33]
                  "%
                  | optional,
                with-header
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  CSV data has a header [only for external tables]
                  "%
                  | optional,
              },
          TypeBound = {
                datatypes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                type-variable | String,
              },
          Variable
            | doc m%"
            SQL queries can be parameterized via variables of type varchar. A variable definition binds the variable to the provided value.
            "%
            = {
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the variable
                  "%,
                value
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The value of this variable (using sql/yaml literals)
                  "%
                  | optional,
              },
          Variadic
            | doc m%"
            Arbitrary number of arguments of an common type out of a list of valid types
            "%
            = predicates.contract_from_predicate definitions.predicate.Variadic,
          Volatility
            | doc m%"
            A function's volatility, which defines the functions eligibility for certain optimizations
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Volatility,
          Workspace
            | doc m%"
            A workspace is a collection of one or more catalogs, schemas, tables, and resources, called workspace members, that are managed together.
            "%
            = {
                access-control
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    definitions.predicate.AccessControlPath
                  ])
                  | doc m%"
                  An array of attribute based access control queries over the information schema, current user and current job, that will be run on sdf build and sdf deploy
                  "%
                  | optional,
                code-checks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    definitions.predicate.CodeCheckPath
                  ])
                  | doc m%"
                  An array of queries over the information schema that will be run on sdf describe and sdf deploy
                  "%
                  | optional,
                code-reports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    definitions.predicate.CodeReportPath
                  ])
                  | doc m%"
                  An array of queries over the information schema that will be run on sdf describe and sdf deploy
                  "%
                  | optional,
                default-catalog
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Defines a default catalog [If not set, defaults to the directory of the workspace]
                  "%
                  | optional,
                default-profile
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Defines the default profile [if not set, defaults to 'dbg']
                  "%
                  | optional,
                default-schema
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Defines a default schema [If not set, defaults to 'pub']
                  "%
                  | optional,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A description of this workspace
                  "%
                  | optional,
                dialect
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Dialect, predicates.isType 'Null ])
                  | doc m%"
                  The dialect of this workspace. If not set, defaults to sdf dialect
                  "%
                  | optional,
                edition
                  | String
                  | doc m%"
                  The SDF edition, should always be 1 (for now)
                  "%,
                excludes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.FilePath
                  ])
                  | doc m%"
                  An array of directories and filenames to be skipped when resolving includes
                  "%
                  | optional,
                includes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.IncludePath
                  ])
                  | doc m%"
                  An array of directories and filenames containing .sql and .sdf.yml files
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of this workspace (defaults to the workspace directory name if not given) Name must be set for deployment.
                  "%,
                references
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    definitions.predicate.WorkspacePath
                  ])
                  | doc m%"
                  An array of paths to other workspaces, i.e. .sql and .yml files
                  "%
                  | optional,
                remote-location
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The default output object store location, e.g. 's3://bucket/key/' where key is optional
                  "%
                  | optional,
                repository
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The URL of the workspace source repository [defaults to 'none' if no repository is given]
                  "%
                  | optional,
                resources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.FilePath
                  ])
                  | doc m%"
                  An array of paths to directories and files, which will be copied to the SDF service on deployment
                  "%
                  | optional,
                source-locations
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.FilePath, predicates.isType 'Null ])
                  | doc m%"
                  Workspace defined by these set of files
                  "%
                  | optional,
                variables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf definitions.predicate.Variable
                  ])
                  | doc m%"
                  An array of named values for setting SQL variables from your environment Ex. -dt: dt, used in SQL as @dt
                  "%
                  | optional,
              },
          WorkspacePath = {
                branch
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  the Git branch (choose only one of the fields: rev, branch, tag)
                  "%
                  | optional,
                git
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The Git repo
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  The relative path from this workspace to the referenced workspace, for a Git repo, from the root of the depot to the workspace
                  "%,
                profile
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The chosen workspace profile (none means default)
                  "%
                  | optional,
                rev
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  the Git revision (choose only one of the fields: rev, branch, tag)
                  "%
                  | optional,
                tag
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  the Git tag (choose only one of the fields: rev, branch, tag)
                  "%
                  | optional,
              },
        },
    predicate = {
          AccessControlPath = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "access", "name", "path" ],
                predicates.records.record
                {
                  access = definitions.predicate.Grant,
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  name = predicates.isType '"String",
                  path = predicates.isType '"String",
                  time = predicates.anyOf
                      [
                        definitions.predicate.SystemTime,
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          AccessMethod = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "scan",
                  "table-name",
                  "schema-table-name",
                  "catalog-schema-table-name"
                ]
              ],
          Cardinality = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "zero-or-one", "one", "zero-or-more" ]
              ],
          Catalog
            | doc m%"
            External Catalogs used to get metadata about tables
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "type" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  type = definitions.predicate.CatalogType,
                }
                {  }
                false
                predicates.never
              ],
          CatalogType = predicates.allOf
              [ predicates.isType '"String", predicates.enum [ "glue" ] ],
          Classifier
            | doc m%"
            A classifier defines the labels that can be attached to columns or a table.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  cardinality = predicates.anyOf
                      [
                        definitions.predicate.Cardinality,
                        predicates.isType 'Null
                      ],
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  labels = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf definitions.predicate.Label
                      ],
                  name = predicates.isType '"String",
                  propagate = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  scope = predicates.anyOf
                      [ definitions.predicate.Scope, predicates.isType 'Null ],
                  source-locations = predicates.anyOf
                      [
                        definitions.predicate.FilePath,
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          CodeAssertion = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "exists", "not-exists" ]
              ],
          CodeCheckPath = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "assert", "path" ],
                predicates.records.record
                {
                  assert = definitions.predicate.CodeAssertion,
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  dialect = predicates.anyOf
                      [
                        definitions.predicate.Dialect,
                        predicates.isType 'Null
                      ],
                  name = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CodeReportPath = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "path" ],
                predicates.records.record
                {
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  dialect = predicates.anyOf
                      [
                        definitions.predicate.Dialect,
                        predicates.isType 'Null
                      ],
                  name = predicates.isType '"String",
                  path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Column = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  classifiers = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  datatype = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  lineage = predicates.anyOf
                      [
                        definitions.predicate.Lineage,
                        predicates.isType 'Null
                      ],
                  name = predicates.isType '"String",
                  nullable = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  reclassify = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.Reclassify
                      ],
                }
                {  }
                false
                predicates.never
              ],
          CompressionType
            | doc m%"
            Compress table data using these methods
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "tar", "zstd" ]
                ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "bzip2" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "gzip" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "none" ] ]
              ],
          Config
            | doc m%"
            A configuration with section name and properties
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  name = predicates.isType '"String",
                  properties = predicates.allOf
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
          Dialect = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "sdf", "presto", "bigquery", "redshift" ]
              ],
          Example = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "input", "output" ],
                predicates.records.record
                {
                  input = predicates.isType '"String",
                  output = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FileFormat
            | doc m%"
            Store table data in these formats
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "parquet", "csv", "json" ]
              ],
          FilePath
            | doc m%"
            All file path should either be relative to the workspace, or absolute for an object store like AWS s3://
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  time = predicates.anyOf
                      [
                        definitions.predicate.SystemTime,
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Function
            | doc m%"
            A function block defines the signature for user defined
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  binds = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.TypeBound
                      ],
                  cross-link = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  dialect = predicates.anyOf
                      [
                        definitions.predicate.Dialect,
                        predicates.isType 'Null
                      ],
                  examples = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf definitions.predicate.Example
                      ],
                  implemented-by = predicates.anyOf
                      [
                        definitions.predicate.FunctionImplSpec,
                        predicates.isType 'Null
                      ],
                  kind = predicates.anyOf
                      [
                        definitions.predicate.FunctionKind,
                        predicates.isType 'Null
                      ],
                  name = predicates.isType '"String",
                  optional-parameters = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.OptionalParameter
                      ],
                  parameters = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.Parameter
                      ],
                  reclassify = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.Reclassify
                      ],
                  returns = predicates.anyOf
                      [
                        definitions.predicate.Parameter,
                        predicates.isType 'Null
                      ],
                  section = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  source-locations = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf definitions.predicate.FilePath
                      ],
                  variadic = predicates.anyOf
                      [
                        definitions.predicate.Variadic,
                        predicates.isType 'Null
                      ],
                  volatility = predicates.anyOf
                      [
                        definitions.predicate.Volatility,
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FunctionImplSpec = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "builtin", "sql" ]
              ],
          FunctionKind = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "scalar", "aggregate", "window" ]
              ],
          Grant = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "deny", "allow" ]
              ],
          IncludePath
            | doc m%"
            All file path should either be relative to the workspace, or absolute for an object store like AWS s3:// Note that an [IncludePath] specifies a catalog and schema scope for unqualified names (in effect for both creating and querying tables). See [IncludePath::default_catalog] and [IncludePath::default_schema].
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  access-with = predicates.anyOf
                      [
                        definitions.predicate.AccessMethod,
                        predicates.isType 'Null
                      ],
                  default-catalog = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  default-schema = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  dialect = predicates.anyOf
                      [
                        definitions.predicate.Dialect,
                        predicates.isType 'Null
                      ],
                  path = predicates.isType '"String",
                  time = predicates.anyOf
                      [
                        definitions.predicate.SystemTime,
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Label
            | doc m%"
            A classifier element is a scoped classifier label (e.g. the element PII belongs to the classifier scope data)
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Lineage = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apply = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  copy = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  modify = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  scan = predicates.allOf
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
          Materialization = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "cached" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "external" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "view" ] ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "ephemeral" ]
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "recursive" ]
                ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "system" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "catalog" ] ]
              ],
          OptionalParameter
            | doc m%"
            A function parameter
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "datatype", "name" ],
                predicates.records.record
                {
                  classifier = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  constant = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  datatype = predicates.isType '"String",
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  identifiers = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Parameter
            | doc m%"
            A function parameter
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  classifier = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  constant = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  datatype = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  identifiers = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  nullable = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          Partition
            | doc m%"
            A partition is a table column, used to describe to which partition this row belongs to
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  format = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Plugin
            | doc m%"
            A function block defines the signature for user defined
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "includes", "name" ],
                predicates.records.record
                {
                  dockerfile = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  image-uri = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  includes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.IncludePath
                      ],
                  keep-alive = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Profile
            | doc m%"
            Profiles provide a way to override the fields of a workspace, i.e. if a profile has set field X, then the workspace field X will be overridden by the profile field X.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  access-control = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.AccessControlPath
                      ],
                  code-checks = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.CodeCheckPath
                      ],
                  code-reports = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.CodeReportPath
                      ],
                  default-catalog = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  default-schema = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  dialect = predicates.anyOf
                      [
                        definitions.predicate.Dialect,
                        predicates.isType 'Null
                      ],
                  excludes = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf definitions.predicate.FilePath
                      ],
                  includes = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.IncludePath
                      ],
                  name = predicates.isType '"String",
                  references = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.WorkspacePath
                      ],
                  remote-location = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  resources = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf definitions.predicate.FilePath
                      ],
                  source-locations = predicates.anyOf
                      [
                        definitions.predicate.FilePath,
                        predicates.isType 'Null
                      ],
                  variables = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf definitions.predicate.Variable
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Reclassify = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  from = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  to = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          Scope = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "column", "table" ]
              ],
          SystemTime = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "nanos_since_epoch", "secs_since_epoch" ],
                predicates.records.record
                {
                  nanos_since_epoch = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  secs_since_epoch = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Table
            | doc m%"
            A tables is either defined by given data (also called external table) or defined via a query.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  classifiers = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  columns = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf definitions.predicate.Column
                      ],
                  compression = predicates.anyOf
                      [
                        definitions.predicate.CompressionType,
                        predicates.isType 'Null
                      ],
                  delimiter = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  dependencies = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  dialect = predicates.anyOf
                      [
                        definitions.predicate.Dialect,
                        predicates.isType 'Null
                      ],
                  file-format = predicates.anyOf
                      [
                        definitions.predicate.FileFormat,
                        predicates.isType 'Null
                      ],
                  insert-into = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  lineage = predicates.anyOf
                      [
                        definitions.predicate.Lineage,
                        predicates.isType 'Null
                      ],
                  location = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  materialization = predicates.anyOf
                      [
                        definitions.predicate.Materialization,
                        predicates.isType 'Null
                      ],
                  name = predicates.isType '"String",
                  partitioned-by = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.Partition
                      ],
                  reclassify = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.Reclassify
                      ],
                  schedule = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  source-locations = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf definitions.predicate.FilePath
                      ],
                  starting = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  with-header = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          TypeBound = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "datatypes", "type-variable" ],
                predicates.records.record
                {
                  datatypes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  type-variable = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Variable
            | doc m%"
            SQL queries can be parameterized via variables of type varchar. A variable definition binds the variable to the provided value.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  name = predicates.isType '"String",
                  value = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          Variadic
            | doc m%"
            Arbitrary number of arguments of an common type out of a list of valid types
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "uniform" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "even-odd" ] ]
              ],
          Volatility
            | doc m%"
            A function's volatility, which defines the functions eligibility for certain optimizations
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "pure" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "stable" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "volatile" ] ]
              ],
          Workspace
            | doc m%"
            A workspace is a collection of one or more catalogs, schemas, tables, and resources, called workspace members, that are managed together.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "edition", "name" ],
                predicates.records.record
                {
                  access-control = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.AccessControlPath
                      ],
                  code-checks = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.CodeCheckPath
                      ],
                  code-reports = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.CodeReportPath
                      ],
                  default-catalog = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  default-profile = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  default-schema = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  dialect = predicates.anyOf
                      [
                        definitions.predicate.Dialect,
                        predicates.isType 'Null
                      ],
                  edition = predicates.isType '"String",
                  excludes = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf definitions.predicate.FilePath
                      ],
                  includes = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.IncludePath
                      ],
                  name = predicates.isType '"String",
                  references = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.WorkspacePath
                      ],
                  remote-location = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  repository = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  resources = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf definitions.predicate.FilePath
                      ],
                  source-locations = predicates.anyOf
                      [
                        definitions.predicate.FilePath,
                        predicates.isType 'Null
                      ],
                  variables = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf definitions.predicate.Variable
                      ],
                }
                {  }
                false
                predicates.never
              ],
          WorkspacePath = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  branch = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  git = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  path = predicates.isType '"String",
                  profile = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  rev = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  tag = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

{
  catalog
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Catalog, predicates.isType 'Null ])
    | doc m%"
    A workspace definition
    "%
    | optional,
  classifier
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Classifier, predicates.isType 'Null ])
    | doc m%"
    A classifier definition
    "%
    | optional,
  config
    | predicates.contract_from_predicate
    (predicates.anyOf [ definitions.predicate.Config, predicates.isType 'Null ])
    | doc m%"
    A workspace definition
    "%
    | optional,
  function
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Function, predicates.isType 'Null ])
    | doc m%"
    A function definition
    "%
    | optional,
  plugin
    | predicates.contract_from_predicate
    (predicates.anyOf [ definitions.predicate.Plugin, predicates.isType 'Null ])
    | doc m%"
    A plugin definition
    "%
    | optional,
  profile
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Profile, predicates.isType 'Null ])
    | doc m%"
    A profile definition
    "%
    | optional,
  table
    | predicates.contract_from_predicate
    (predicates.anyOf [ definitions.predicate.Table, predicates.isType 'Null ])
    | doc m%"
    A table definition
    "%
    | optional,
  workspace
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.Workspace, predicates.isType 'Null ])
    | doc m%"
    A workspace definition
    "%
    | optional,
}