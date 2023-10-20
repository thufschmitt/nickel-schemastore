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
          admin_worker = {
                enable_admin_worker | Bool | optional,
                enable_notification_worker | Bool | optional,
                enable_queue_stats_worker | Bool | optional,
                poll_interval | std.number.Integer | optional,
                transports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          api = {
                access_token_ttl | String | optional,
                api_browser | definitions.contract.api_browser | optional,
                jwt_key | definitions.contract.jwt_key | optional,
                max_limit
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType 'Null ])
                  | optional,
                rate_limiter | definitions.contract.rate_limiter | optional,
                refresh_token_ttl | String | optional,
                store | definitions.contract.api_store | optional,
              },
          api_browser = { auth_required | Bool | optional, },
          api_store = {
                context_lifetime | String | optional,
                max_limit
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType 'Null ])
                  | optional,
              },
          auto_update = { enabled | Bool | optional, },
          cache = {
                cache_compression
                  | Bool
                  | doc m%"
                  Controls the cache compression before the storage
                  "%
                  | optional,
                invalidation
                  | definitions.contract.cache_invalidation
                  | optional,
                redis_prefix | String | optional,
                tagging | definitions.contract.cache_tags | optional,
              },
          cache_invalidation = {
                category_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                count | std.number.Integer | optional,
                country_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                country_state_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                currency_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                delay | std.number.Integer | optional,
                delay_options
                  | {
                    dsn | String | optional,
                    storage
                      | std.enum.TagOrString
                      | [| 'redis, 'cache |]
                      | optional,
                  }
                  | optional,
                http_cache
                  | definitions.contract.cache_invalidation_states
                  | optional,
                landing_page_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                language_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                navigation_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                payment_method_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                product_cross_selling_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                product_detail_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                product_listing_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                product_review_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                product_search_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                product_suggest_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                salutation_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                shipping_method_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
                sitemap_route
                  | definitions.contract.cache_invalidation_states
                  | optional,
              },
          cache_invalidation_states = predicates.contract_from_predicate
              definitions.predicate.cache_invalidation_states,
          cache_tags = {
                each_config
                  | Bool
                  | doc m%"
                  If enabled, each config will be cached with a unique tag. This allows to invalidate a single config. If disabled, the whole page will be invalidated on each config change.
                  "%
                  | optional,
                each_snippet
                  | Bool
                  | doc m%"
                  If enabled, each snippet will be cached with a unique tag. This allows to invalidate a single snippet. If disabled, the whole page will be invalidated on each snippet change.
                  "%
                  | optional,
                each_theme_config
                  | Bool
                  | doc m%"
                  If enabled, each theme config will be cached with a unique tag. This allows to invalidate a single theme config. If disabled, the whole page will be invalidated on each theme config change.
                  "%
                  | optional,
              },
          cart = {
                compress
                  | Bool
                  | doc m%"
                  All carts, which stored in redis, are compressed via gzcompress. This option is only available if redis is used.
                  "%
                  | optional,
                expire_days | std.number.Integer | optional,
                redis_url
                  | String
                  | doc m%"
                  The redis url to connect to. All carts will be saved in Redis instead of mysql
                  "%
                  | optional,
              },
          cdn = { strategy | String | optional, url | String | optional, },
          dal = {
                batch_size | std.number.Integer | optional,
                max_rule_prices | std.number.Integer | optional,
                versioning
                  | { expire_days | std.number.Integer | optional, }
                  | optional,
              },
          deployment = {
                blue_green | Bool | optional,
                cluster_setup | Bool | optional,
              },
          dompdf = { options | {  .. } | optional, },
          elasticsearch = {
                administration
                  | {
                    enabled
                      | Bool
                      | doc m%"
                      Admin Elasticsearch Enabled
                      "%
                      | optional,
                    hosts
                      | String
                      | doc m%"
                      Admin Elasticsearch Hosts
                      "%
                      | optional,
                    index_prefix
                      | String
                      | doc m%"
                      Admin Elasticsearch Index Prefix
                      "%
                      | optional,
                    refresh_indices
                      | Bool
                      | doc m%"
                      Admin Elasticsearch Refresh Indices
                      "%
                      | optional,
                  }
                  | optional,
                analysis | {  .. } | optional,
                dynamic_templates | Array Dyn | optional,
                enabled
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Enable Elasticsearch Searching
                  "%
                  | optional,
                hosts
                  | String
                  | doc m%"
                  Elasticsearch Hosts
                  "%
                  | optional,
                index_prefix
                  | String
                  | doc m%"
                  Elasticsearch Index Prefix
                  "%
                  | optional,
                index_settings
                  | {
                    "mapping.nested_fields.limit"
                      | std.number.Integer
                      | optional,
                    "mapping.nested_objects.limit"
                      | std.number.Integer
                      | optional,
                    "mapping.total_fields.limit"
                      | std.number.Integer
                      | optional,
                    number_of_replicas
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [ predicates.isType 'Integer, predicates.isType 'Null ])
                      | optional,
                    number_of_shards
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [ predicates.isType 'Integer, predicates.isType 'Null ])
                      | optional,
                    ..
                  }
                  | optional,
                indexing_batch_size
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Integer ])
                  | doc m%"
                  Elasticsearch Batch Size
                  "%
                  | optional,
                indexing_enabled
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Enable Elasticsearch Indexing
                  "%
                  | optional,
                product
                  | {
                    custom_fields_mapping
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ])
                      | optional,
                  }
                  | optional,
                ssl
                  | {
                    cert_key_path
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ])
                      | optional,
                    cert_path
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ])
                      | optional,
                    verify_server_cert | Bool | optional,
                  }
                  | optional,
                throw_exception
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Throw exception when Elasticsearch queries failing
                  "%
                  | optional,
              },
          file_system_type = predicates.contract_from_predicate
              definitions.predicate.file_system_type,
          filesystem = {
                allowed_extensions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                asset | definitions.contract.file_system_type | optional,
                private | definitions.contract.file_system_type | optional,
                private_allowed_extensions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                private_local_download_strategy
                  | std.enum.TagOrString
                  | [| 'x-accel, 'x-sendfile, 'php |]
                  | optional,
                public | definitions.contract.file_system_type | optional,
                sitemap | definitions.contract.file_system_type | optional,
                temp | definitions.contract.file_system_type | optional,
                theme | definitions.contract.file_system_type | optional,
              },
          html_sanitizer = {
                cache_dir | String | optional,
                cache_enabled | Bool | optional,
                enabled | Bool | optional,
                fields
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
                        name = predicates.isType '"String",
                        sets = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ])
                  | optional,
                sets
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
                        attributes = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                        custom_attributes = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  attributes = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.isType '"String")
                                      ],
                                  tags = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.isType '"String")
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ])
                            ],
                        name = predicates.isType '"String",
                        options = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType 'Record)
                            ],
                        tags = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ])
                  | optional,
              },
          increment = predicates.contract_from_predicate
              definitions.predicate.increment,
          increment_config = predicates.contract_from_predicate
              definitions.predicate.increment_config,
          jwt_key = {
                private_key_passphrase
                  | String
                  | doc m%"
                  Passphrase for the private key file.
                  "%
                  | optional,
                private_key_path
                  | String
                  | doc m%"
                  Path to the private key file.
                  "%
                  | optional,
                public_key_path
                  | String
                  | doc m%"
                  Path to the public key file.
                  "%
                  | optional,
              },
          logger = {
                error_code_log_levels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                exclude_events
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                exclude_exception
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                file_rotation_count | std.number.Integer | optional,
              },
          mail = { update_mail_variables_on_send | Bool | optional, },
          media = {
                enable_url_upload_feature | Bool | optional,
                enable_url_validation | Bool | optional,
                url_upload_max_size | String | optional,
              },
          number_range = {
                increment_storage
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "SQL", "Redis" ]
                    ],
                    predicates.isType '"String"
                  ])
                  | doc m%"
                  The storage engine used for the increments. Note that you need to configure a `redis_url` if you want to use the `Redis` storage.
                  "%
                  | optional,
                redis_url
                  | String
                  | doc m%"
                  The redis url to connect to. All number range states will be saved in Redis instead of sql
                  "%
                  | optional,
              },
          parameters = {  .. },
          profiler = {
                integrations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Symfony", "Datadog", "Tideways" ]
                      ],
                      predicates.isType '"String"
                    ]),
                    predicates.arrays.uniqueItems
                  ])
                  | optional,
              },
          rate_limiter = {
                cart_add_line_item_from
                  | definitions.contract.rate_limiter_config
                  | optional,
                contact_form
                  | definitions.contract.rate_limiter_config
                  | optional,
                guest_login
                  | definitions.contract.rate_limiter_config
                  | optional,
                login | definitions.contract.rate_limiter_config | optional,
                newsletter_form
                  | definitions.contract.rate_limiter_config
                  | optional,
                notification
                  | definitions.contract.rate_limiter_config
                  | optional,
                oauth | definitions.contract.rate_limiter_config | optional,
                reset_password
                  | definitions.contract.rate_limiter_config
                  | optional,
                user_recovery
                  | definitions.contract.rate_limiter_config
                  | optional,
                ..
              },
          rate_limiter_config = {
                enabled | Bool | optional,
                limits
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Record, predicates.isType '"Array" ])
                  | optional,
                policy | String | optional,
                reset | String | optional,
                ..
              },
          root = {
                elasticsearch | definitions.contract.elasticsearch | optional,
                parameters | definitions.contract.parameters | optional,
                shopware | definitions.contract.shopware | optional,
                storefront | definitions.contract.storefront | optional,
              },
          sales_channel_context = {
                expire_days | std.number.Integer | optional,
              },
          shopware = {
                admin_worker | definitions.contract.admin_worker | optional,
                api | definitions.contract.api | optional,
                auto_update | definitions.contract.auto_update | optional,
                cache | definitions.contract.cache | optional,
                cart | definitions.contract.cart | optional,
                cdn | definitions.contract.cdn | optional,
                dal | definitions.contract.dal | optional,
                deployment | definitions.contract.deployment | optional,
                dompdf | definitions.contract.dompdf | optional,
                filesystem | definitions.contract.filesystem | optional,
                html_sanitizer | definitions.contract.html_sanitizer | optional,
                increment | definitions.contract.increment | optional,
                logger | definitions.contract.logger | optional,
                mail | definitions.contract.mail | optional,
                media | definitions.contract.media | optional,
                number_range | definitions.contract.number_range | optional,
                profiler | definitions.contract.profiler | optional,
                sales_channel_context
                  | definitions.contract.sales_channel_context
                  | optional,
                sitemap | definitions.contract.sitemap | optional,
                stock | definitions.contract.stock | optional,
                store | definitions.contract.shopware_store | optional,
                twig | definitions.contract.twig | optional,
              },
          shopware_store = { frw | Bool | optional, },
          sitemap = {
                batchsize | std.number.Integer | optional,
                custom_urls
                  | predicates.contract_from_predicate (predicates.isType 'Null)
                  | optional,
                excluded_urls
                  | predicates.contract_from_predicate (predicates.isType 'Null)
                  | optional,
              },
          stock = { enable_stock_management | Bool | optional, },
          storefront = {
                http_cache
                  | {
                    ignored_url_parameters
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ])
                      | optional,
                    stale_if_error
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [ predicates.isType 'Integer, predicates.isType 'Null ])
                      | optional,
                    stale_while_revalidate
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [ predicates.isType 'Integer, predicates.isType 'Null ])
                      | optional,
                  }
                  | optional,
                reverse_proxy
                  | {
                    ban_headers
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ])
                      | optional,
                    ban_method | String | optional,
                    enabled | Bool | optional,
                    fastly
                      | {
                        api_key | String | optional,
                        enabled | Bool | optional,
                        instance_tag | String | optional,
                        service_id | String | optional,
                        soft_purge
                          | std.enum.TagOrString
                          | [| '"0", '"1" |]
                          | optional,
                      }
                      | optional,
                    hosts
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ])
                      | optional,
                    max_parallel_invalidations | std.number.Integer | optional,
                    purge_all
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Record, predicates.isType 'Null ],
                        predicates.records.record
                        {
                          ban_headers = predicates.anyOf
                              [
                                predicates.isType 'Record,
                                predicates.isType 'Null
                              ],
                          ban_method = predicates.isType '"String",
                          urls = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ])
                      | optional,
                    redis_url | String | optional,
                    use_varnish_xkey | Bool | optional,
                  }
                  | optional,
                theme
                  | {
                    available_theme_provider | String | optional,
                    config_loader_id | String | optional,
                    file_delete_delay
                      | std.number.Integer
                      | doc m%"
                      Delay in seconds until old theme files will be deleted after a new theme compile
                      "%
                      | optional,
                    theme_path_builder_id | String | optional,
                  }
                  | optional,
              },
          twig = {
                allowed_php_functions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | optional,
              },
        },
    predicate = {
          admin_worker = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enable_admin_worker = predicates.isType '"Bool",
                  enable_notification_worker = predicates.isType '"Bool",
                  enable_queue_stats_worker = predicates.isType '"Bool",
                  poll_interval = predicates.isType 'Integer,
                  transports = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          api = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  access_token_ttl = predicates.isType '"String",
                  api_browser = definitions.predicate.api_browser,
                  jwt_key = definitions.predicate.jwt_key,
                  max_limit = predicates.anyOf
                      [ predicates.isType 'Integer, predicates.isType 'Null ],
                  rate_limiter = definitions.predicate.rate_limiter,
                  refresh_token_ttl = predicates.isType '"String",
                  store = definitions.predicate.api_store,
                }
                {  }
                false
                predicates.never
              ],
          api_browser = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { auth_required = predicates.isType '"Bool", }
                {  }
                false
                predicates.never
              ],
          api_store = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  context_lifetime = predicates.isType '"String",
                  max_limit = predicates.anyOf
                      [ predicates.isType 'Integer, predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          auto_update = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { enabled = predicates.isType '"Bool", }
                {  }
                false
                predicates.never
              ],
          cache = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cache_compression = predicates.isType '"Bool",
                  invalidation = definitions.predicate.cache_invalidation,
                  redis_prefix = predicates.isType '"String",
                  tagging = definitions.predicate.cache_tags,
                }
                {  }
                false
                predicates.never
              ],
          cache_invalidation = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  category_route =
                    definitions.predicate.cache_invalidation_states,
                  count = predicates.isType 'Integer,
                  country_route =
                    definitions.predicate.cache_invalidation_states,
                  country_state_route =
                    definitions.predicate.cache_invalidation_states,
                  currency_route =
                    definitions.predicate.cache_invalidation_states,
                  delay = predicates.isType 'Integer,
                  delay_options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          dsn = predicates.isType '"String",
                          storage = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "cache", "redis" ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  http_cache = definitions.predicate.cache_invalidation_states,
                  landing_page_route =
                    definitions.predicate.cache_invalidation_states,
                  language_route =
                    definitions.predicate.cache_invalidation_states,
                  navigation_route =
                    definitions.predicate.cache_invalidation_states,
                  payment_method_route =
                    definitions.predicate.cache_invalidation_states,
                  product_cross_selling_route =
                    definitions.predicate.cache_invalidation_states,
                  product_detail_route =
                    definitions.predicate.cache_invalidation_states,
                  product_listing_route =
                    definitions.predicate.cache_invalidation_states,
                  product_review_route =
                    definitions.predicate.cache_invalidation_states,
                  product_search_route =
                    definitions.predicate.cache_invalidation_states,
                  product_suggest_route =
                    definitions.predicate.cache_invalidation_states,
                  salutation_route =
                    definitions.predicate.cache_invalidation_states,
                  shipping_method_route =
                    definitions.predicate.cache_invalidation_states,
                  sitemap_route =
                    definitions.predicate.cache_invalidation_states,
                }
                {  }
                false
                predicates.never
              ],
          cache_invalidation_states = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "logged-in", "cart-filled" ]
                ])
              ],
          cache_tags = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  each_config = predicates.isType '"Bool",
                  each_snippet = predicates.isType '"Bool",
                  each_theme_config = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          cart = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  compress = predicates.isType '"Bool",
                  expire_days = predicates.isType 'Integer,
                  redis_url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          cdn = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  strategy = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          dal = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  batch_size = predicates.isType 'Integer,
                  max_rule_prices = predicates.isType 'Integer,
                  versioning = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { expire_days = predicates.isType 'Integer, }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                false
                predicates.never
              ],
          deployment = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  blue_green = predicates.isType '"Bool",
                  cluster_setup = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          dompdf = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          elasticsearch = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  administration = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          enabled = predicates.isType '"Bool",
                          hosts = predicates.isType '"String",
                          index_prefix = predicates.isType '"String",
                          refresh_indices = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  analysis = predicates.isType 'Record,
                  dynamic_templates = predicates.isType '"Array",
                  enabled = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  hosts = predicates.isType '"String",
                  index_prefix = predicates.isType '"String",
                  index_settings = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          "mapping.nested_fields.limit" = predicates.isType
                              'Integer,
                          "mapping.nested_objects.limit" = predicates.isType
                              'Integer,
                          "mapping.total_fields.limit" = predicates.isType
                              'Integer,
                          number_of_replicas = predicates.anyOf
                              [
                                predicates.isType 'Integer,
                                predicates.isType 'Null
                              ],
                          number_of_shards = predicates.anyOf
                              [
                                predicates.isType 'Integer,
                                predicates.isType 'Null
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  indexing_batch_size = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Integer
                      ],
                  indexing_enabled = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  product = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          custom_fields_mapping = predicates.anyOf
                              [
                                predicates.isType 'Record,
                                predicates.isType 'Null
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  ssl = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          cert_key_path = predicates.anyOf
                              [
                                predicates.isType '"Bool",
                                predicates.isType '"String"
                              ],
                          cert_path = predicates.anyOf
                              [
                                predicates.isType '"Bool",
                                predicates.isType '"String"
                              ],
                          verify_server_cert = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  throw_exception = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          file_system_type = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record {  } {  } true predicates.always
              ],
          filesystem = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allowed_extensions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  asset = definitions.predicate.file_system_type,
                  private = definitions.predicate.file_system_type,
                  private_allowed_extensions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  private_local_download_strategy = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "php", "x-sendfile", "x-accel" ]
                      ],
                  public = definitions.predicate.file_system_type,
                  sitemap = definitions.predicate.file_system_type,
                  temp = definitions.predicate.file_system_type,
                  theme = definitions.predicate.file_system_type,
                }
                {  }
                false
                predicates.never
              ],
          html_sanitizer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cache_dir = predicates.isType '"String",
                  cache_enabled = predicates.isType '"Bool",
                  enabled = predicates.isType '"Bool",
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            name = predicates.isType '"String",
                            sets = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                  sets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            attributes = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            custom_attributes = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      attributes = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.isType '"String")
                                          ],
                                      tags = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.isType '"String")
                                          ],
                                    }
                                    {  }
                                    true
                                    predicates.always
                                  ])
                                ],
                            name = predicates.isType '"String",
                            options = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType 'Record)
                                ],
                            tags = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
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
          increment = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "message_queue", "user_activity" ],
                predicates.records.record {  }
                { "^.*$" = definitions.predicate.increment_config, }
                true
                predicates.always
              ],
          increment_config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.ifThenElse
                (predicates.records.record { type = predicates.const "redis", }
                {  }
                true
                predicates.always)
                (predicates.allOf
                [
                  predicates.records.required [ "config" ],
                  predicates.records.record
                  {
                    config = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "url" ],
                          predicates.records.record
                          { url = predicates.isType '"String", }
                          {  }
                          false
                          predicates.never
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
                predicates.always,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "mysql", "redis", "array" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          jwt_key = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  private_key_passphrase = predicates.isType '"String",
                  private_key_path = predicates.isType '"String",
                  public_key_path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          logger = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  error_code_log_levels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  exclude_events = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  exclude_exception = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  file_rotation_count = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          mail = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { update_mail_variables_on_send = predicates.isType '"Bool", }
                {  }
                false
                predicates.never
              ],
          media = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enable_url_upload_feature = predicates.isType '"Bool",
                  enable_url_validation = predicates.isType '"Bool",
                  url_upload_max_size = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          number_range = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  increment_storage = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "SQL", "Redis" ]
                        ],
                        predicates.isType '"String"
                      ],
                  redis_url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          parameters = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true predicates.always
              ],
          profiler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  integrations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "Symfony", "Datadog", "Tideways" ]
                          ],
                          predicates.isType '"String"
                        ]),
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          rate_limiter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cart_add_line_item_from =
                    definitions.predicate.rate_limiter_config,
                  contact_form = definitions.predicate.rate_limiter_config,
                  guest_login = definitions.predicate.rate_limiter_config,
                  login = definitions.predicate.rate_limiter_config,
                  newsletter_form = definitions.predicate.rate_limiter_config,
                  notification = definitions.predicate.rate_limiter_config,
                  oauth = definitions.predicate.rate_limiter_config,
                  reset_password = definitions.predicate.rate_limiter_config,
                  user_recovery = definitions.predicate.rate_limiter_config,
                }
                {  }
                true
                predicates.always
              ],
          rate_limiter_config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  limits = predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType '"Array" ],
                  policy = predicates.isType '"String",
                  reset = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          root = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  elasticsearch = definitions.predicate.elasticsearch,
                  parameters = definitions.predicate.parameters,
                  shopware = definitions.predicate.shopware,
                  storefront = definitions.predicate.storefront,
                }
                {  }
                false
                predicates.never
              ],
          sales_channel_context = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { expire_days = predicates.isType 'Integer, }
                {  }
                false
                predicates.never
              ],
          shopware = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  admin_worker = definitions.predicate.admin_worker,
                  api = definitions.predicate.api,
                  auto_update = definitions.predicate.auto_update,
                  cache = definitions.predicate.cache,
                  cart = definitions.predicate.cart,
                  cdn = definitions.predicate.cdn,
                  dal = definitions.predicate.dal,
                  deployment = definitions.predicate.deployment,
                  dompdf = definitions.predicate.dompdf,
                  filesystem = definitions.predicate.filesystem,
                  html_sanitizer = definitions.predicate.html_sanitizer,
                  increment = definitions.predicate.increment,
                  logger = definitions.predicate.logger,
                  mail = definitions.predicate.mail,
                  media = definitions.predicate.media,
                  number_range = definitions.predicate.number_range,
                  profiler = definitions.predicate.profiler,
                  sales_channel_context =
                    definitions.predicate.sales_channel_context,
                  sitemap = definitions.predicate.sitemap,
                  stock = definitions.predicate.stock,
                  store = definitions.predicate.shopware_store,
                  twig = definitions.predicate.twig,
                }
                {  }
                false
                predicates.never
              ],
          shopware_store = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record { frw = predicates.isType '"Bool", }
                {  }
                false
                predicates.never
              ],
          sitemap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  batchsize = predicates.isType 'Integer,
                  custom_urls = predicates.isType 'Null,
                  excluded_urls = predicates.isType 'Null,
                }
                {  }
                false
                predicates.never
              ],
          stock = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { enable_stock_management = predicates.isType '"Bool", }
                {  }
                false
                predicates.never
              ],
          storefront = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  http_cache = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          ignored_url_parameters = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          stale_if_error = predicates.anyOf
                              [
                                predicates.isType 'Integer,
                                predicates.isType 'Null
                              ],
                          stale_while_revalidate = predicates.anyOf
                              [
                                predicates.isType 'Integer,
                                predicates.isType 'Null
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  reverse_proxy = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          ban_headers = predicates.anyOf
                              [
                                predicates.isType 'Record,
                                predicates.isType 'Null
                              ],
                          ban_method = predicates.isType '"String",
                          enabled = predicates.isType '"Bool",
                          fastly = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  api_key = predicates.isType '"String",
                                  enabled = predicates.isType '"Bool",
                                  instance_tag = predicates.isType '"String",
                                  service_id = predicates.isType '"String",
                                  soft_purge = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum [ "1", "0" ]
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          hosts = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          max_parallel_invalidations = predicates.isType
                              'Integer,
                          purge_all = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Record,
                                  predicates.isType 'Null
                                ],
                                predicates.records.record
                                {
                                  ban_headers = predicates.anyOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.isType 'Null
                                      ],
                                  ban_method = predicates.isType '"String",
                                  urls = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.isType '"String")
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          redis_url = predicates.isType '"String",
                          use_varnish_xkey = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  theme = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          available_theme_provider = predicates.isType
                              '"String",
                          config_loader_id = predicates.isType '"String",
                          file_delete_delay = predicates.isType 'Integer,
                          theme_path_builder_id = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                false
                predicates.never
              ],
          twig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allowed_php_functions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

definitions.contract.root