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
          analyzer_list = predicates.contract_from_predicate
              definitions.predicate.analyzer_list,
          architecture_group = {
                annotation | String | optional,
                exclude | definitions.contract.file_pattern_list | optional,
                include | definitions.contract.file_pattern_list,
                name | String,
              },
          architecture_group_list = predicates.contract_from_predicate
              definitions.predicate.architecture_group_list,
          branches = predicates.contract_from_predicate
              definitions.predicate.branches,
          component = predicates.contract_from_predicate
              definitions.predicate.component,
          component_list = predicates.contract_from_predicate
              definitions.predicate.component_list,
          dependency = {
                bidirectional | Bool | optional,
                count | std.number.Integer | optional,
                source | String,
                target | String,
                type | String | optional,
              },
          dependency_list = predicates.contract_from_predicate
              definitions.predicate.dependency_list,
          file_pattern_list = predicates.contract_from_predicate
              definitions.predicate.file_pattern_list,
          interval = std.contract.Sequence
              [ std.enum.TagOrString, [| 'month, 'week |] ],
          language = predicates.contract_from_predicate
              definitions.predicate.language,
          language_list = predicates.contract_from_predicate
              definitions.predicate.language_list,
          language_name = predicates.contract_from_predicate
              definitions.predicate.language_name,
          model = predicates.contract_from_predicate
              definitions.predicate.model,
          organization = predicates.contract_from_predicate
              definitions.predicate.organization,
          pattern_list = predicates.contract_from_predicate
              definitions.predicate.pattern_list,
          system = predicates.contract_from_predicate
              definitions.predicate.system,
          yyyymmdd = predicates.contract_from_predicate
              definitions.predicate.yyyymmdd,
        },
    predicate = {
          analyzer_list = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          architecture_group = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "include", "name" ],
                predicates.records.record
                {
                  annotation = predicates.isType '"String",
                  exclude = definitions.predicate.file_pattern_list,
                  include = definitions.predicate.file_pattern_list,
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          architecture_group_list = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.architecture_group
              ],
          branches = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[0-9a-zA-Z]+(,[0-9a-zA-Z]+)*$"
              ],
          component = predicates.anyOf
              [
                predicates.isType 'Null,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    exclude = definitions.predicate.file_pattern_list,
                    include = definitions.predicate.file_pattern_list,
                    override = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          component_list = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    exclude = definitions.predicate.file_pattern_list,
                    include = definitions.predicate.file_pattern_list,
                    name = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          dependency = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "source", "target" ],
                predicates.records.record
                {
                  bidirectional = predicates.isType '"Bool",
                  count = predicates.isType 'Integer,
                  source = predicates.isType '"String",
                  target = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          dependency_list = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.dependency
              ],
          file_pattern_list = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          interval = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "week", "month" ]
              ],
          language = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    generated = definitions.predicate.component,
                    name = definitions.predicate.language_name,
                    production = definitions.predicate.component,
                    test = definitions.predicate.component,
                  }
                  {  }
                  false
                  predicates.never
                ],
                definitions.predicate.language_name
              ],
          language_list = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.language,
                predicates.arrays.minItems 1
              ],
          language_name = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          model = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "20[0-9]{2}"
                ],
                predicates.allOf
                [
                  predicates.isType 'Integer,
                  predicates.numbers.exclusiveMaximum 2100,
                  predicates.numbers.minimum 2000
                ]
              ],
          organization = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[a-z0-9]{2,}$"
              ],
          pattern_list = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          system = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[a-z0-9]+(-[a-z0-9]+)*$"
              ],
          yyyymmdd = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "20\\d{2}-?\\d{2}-?\\d{2}"
                ],
                predicates.allOf
                [
                  predicates.isType 'Integer,
                  predicates.numbers.exclusiveMaximum 21000000,
                  predicates.numbers.minimum 20000000
                ]
              ],
        },
  }
in

{
  alerts
    | {
      enabled
        | Bool
        | doc m%"
        When true, will send alert email notifications when noteworthy events happen.
        "%
        | optional,
      recipients
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        List of email addresses that should receive alerts.
        "%
        | optional,
    }
    | optional,
  architecture
    | {
      add_dependencies
        | definitions.contract.dependency_list
        | doc m%"
        List of manually added dependencies on top of the ones detected automatically by the analysis.
        "%
        | optional,
      branch
        | definitions.contract.branches
        | doc m%"
        Repository branch to use, comma-separated for multiple branches. Defaults to current branch.
        "%
        | optional,
      co_evolution
        | Bool
        | doc m%"
        Set to false to disable co-evolution detection, improves performance for huge systems.
        "%
        | optional,
      custom_components
        | Bool
        | doc m%"
        Overrides automatic component detection with components defined manually in scope file.
        "%
        | optional,
      disabled_metrics
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        List of metrics that should be removed from the analysis and set to N/A.
        "%
        | optional,
      duplication
        | Bool
        | doc m%"
        Set to false to disable duplication detection, improves performance for huge systems.
        "%
        | optional,
      enabled
        | Bool
        | doc m%"
        When true, architecture analysis will be triggered for each incoming upload.
        "%,
      exclude
        | definitions.contract.file_pattern_list
        | doc m%"
        List of exclude patterns that applies only to Architecture Quality, not globally.
        "%
        | optional,
      flatten_directories
        | definitions.contract.file_pattern_list
        | doc m%"
        List of directory names that should be flattened and not considered as components during the analysis.
        "%
        | optional,
      grouping
        | definitions.contract.architecture_group_list
        | doc m%"
        Annotate all top-level components matching the pattern, in order to divide them into logical groups.
        "%
        | optional,
      history
        | predicates.contract_from_predicate
        (predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType '"String" ])
        | doc m%"
        Deprecated, use 'history_enabled' instead.
        "%
        | optional,
      history_enabled
        | Bool
        | doc m%"
        Disables change history analysis when set to false.
        "%
        | optional,
      history_end
        | definitions.contract.yyyymmdd
        | doc m%"
        Repository history end date in the format 'yyyy-mm-dd', default is current date.
        "%
        | optional,
      history_filter_outliers
        | Bool
        | doc m%"
        Filters commits with an abnormally large amount of churn from the history analysis.
        "%
        | optional,
      history_interval
        | definitions.contract.interval
        | doc m%"
        Either 'week' (default) or ‘month’.
        "%
        | optional,
      history_period_months
        | std.number.Integer
        | doc m%"
        Period to use for repository history analysis, default is last 12 months.
        "%
        | optional,
      history_start
        | definitions.contract.yyyymmdd
        | doc m%"
        Repository history start date in the format 'yyyy-mm-dd', default is last year.
        "%
        | optional,
      merge_data_stores
        | Bool
        | doc m%"
        Default is false. When true, skips automated data store detection and assumes one monolithic data store.
        "%
        | optional,
      model
        | definitions.contract.model
        | doc m%"
        Version of the SIG Architecture Quality Model to use.
        "%
        | optional,
      remove_dependencies
        | definitions.contract.dependency_list
        | doc m%"
        List of dependencies that manually overrides the analysis and removes them from the results.
        "%
        | optional,
      rename
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true (predicates.isType '"String")
        ])
        | doc m%"
        Map of system elements for which to manually override the name.
        "%
        | optional,
      undesirable_dependencies
        | definitions.contract.dependency_list
        | doc m%"
        List of dependencies considered undesirable, and should therefore be highlighted in the visualization.
        "%
        | optional,
    }
    | optional,
  checkmarx
    | {
      enabled
        | Bool
        | doc m%"
        Indicates that this system should be scanned for vulnerabilities using Checkmarx.
        "%,
      id
        | predicates.contract_from_predicate
        (predicates.anyOf
        [ predicates.isType 'Integer, predicates.isType '"String" ])
        | doc m%"
        Unique ID to identify the Checkmarx project.
        "%,
      username
        | String
        | doc m%"
        Your Checkmarx username.
        "%
        | optional,
    }
    | optional,
  component_base_dirs | definitions.contract.file_pattern_list | optional,
  component_depth
    | std.number.Integer
    | doc m%"
    Directory depth that will be used to define components.
    "%
    | optional,
  components | definitions.contract.component_list | optional,
  default_excludes
    | Bool
    | doc m%"
    When true, excludes files and directories from the analysis scope based on common conventions.
    "%
    | optional,
  dependencychecker
    | {
      blacklist
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        Deprecated, use 'blocklist' instead.
        "%
        | optional,
      blocklist
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        List of patterns for library names that should not be sent to external services.
        "%
        | optional,
      enabled
        | Bool
        | doc m%"
        When this *or* the 'blocklist' option is provided, OSH analysis is performed for every upload.
        "%
        | optional,
      exclude
        | definitions.contract.file_pattern_list
        | doc m%"
        List of file/directory patterns that should be excluded from the Open Source Health analysis.
        "%
        | optional,
      transitive
        | Bool
        | doc m%"
        When true, transitive dependencies are also checked and included in the results.
        "%
        | optional,
    }
    | optional,
  exclude
    | definitions.contract.file_pattern_list
    | doc m%"
    List of file and directory patterns to manually exclude from the analysis.
    "%
    | optional,
  languages
    | definitions.contract.language_list
    | doc m%"
    A list of technologies that should be included as part of the analysis.
    "%,
  model
    | definitions.contract.model
    | doc m%"
    Version of the SIG quality model that should be used for the analysis.
    "%
    | optional,
  thirdpartyfindings
    | {
      disabled_analyzers
        | definitions.contract.analyzer_list
        | doc m%"
        List of third-party analyzers that should not be ran.
        "%
        | optional,
      enabled
        | Bool
        | doc m%"
        When true, third party findings analysis will be triggered for each incoming upload.
        "%,
      enabled_analyzers
        | definitions.contract.analyzer_list
        | doc m%"
        List of third-party analyzer names that should be ran even though they are disabled by default.
        "%
        | optional,
      exclude
        | definitions.contract.file_pattern_list
        | doc m%"
        List of file/directory patterns that should be excluded from the third party findings analysis.
        "%
        | optional,
      include
        | definitions.contract.file_pattern_list
        | doc m%"
        List of file/directory patterns that should be included in the third party findings analysis beyond the maintainability scope and production configuration files.
        "%
        | optional,
    }
    | optional,
  ..
}