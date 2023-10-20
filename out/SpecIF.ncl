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
          SpecifAlternativeId
            | doc m%"
            A list of pointers to resources resp. statements which have been merged to this one.
            "%
            = {
                id
                  | definitions.contract.SpecifId
                  | doc m%"
                  A string with a valid identifier of a model-element
                  "%,
                project
                  | definitions.contract.SpecifId
                  | doc m%"
                  A string with a valid project identifier in case the identifier is not globally unique.
                  "%
                  | optional,
                revision
                  | definitions.contract.SpecifRevision
                  | doc m%"
                  If missing, the latest revision is implied.
                  "%
                  | optional,
              },
          SpecifAlternativeIds
            | doc m%"
            The list of consolidated items to be used in case a consolidated item shall be updated.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SpecifAlternativeIds,
          SpecifCreatedBy
            | doc m%"
            The creator of the SpecIF data-set (file). If specified, at least an e-mail address must be given.
            "%
            = {
                email | String,
                familyName | String | optional,
                givenName | String | optional,
                org | definitions.contract.SpecifOrg | optional,
                ..
              },
          SpecifDataType = predicates.contract_from_predicate
              definitions.predicate.SpecifDataType,
          SpecifDateTime
            | doc m%"
            An ISO-8601 dateTime string. For reduced accuracy, any number of values may be dropped, but only from right to left.
            "%
            = String,
          SpecifEnumeratedValue = {
                id | definitions.contract.SpecifId,
                value | definitions.contract.SpecifValue,
                ..
              },
          SpecifEnumeratedValues
            | doc m%"
            Enumerated values for the given dataType. If 'multiple' is true 0..n options may be selected, otherwise exactly one must be selected.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SpecifEnumeratedValues,
          SpecifFile = {
                changedAt | definitions.contract.SpecifDateTime,
                changedBy | String | optional,
                description
                  | definitions.contract.SpecifMultiLanguageText
                  | optional,
                id | definitions.contract.SpecifId,
                replaces | definitions.contract.SpecifReplaces | optional,
                revision | definitions.contract.SpecifRevision | optional,
                title
                  | String
                  | doc m%"
                  The file's name.
                  "%,
                type
                  | String
                  | doc m%"
                  The file's media type (formerly MIME-type) according to https://www.iana.org/assignments/media-types/media-types.xhtml.
                  "%,
                url
                  | String
                  | doc m%"
                  An absolute or relative URL to the file; will be of format 'uri-reference' in future. If missing, the title applies.
                  "%
                  | optional,
                ..
              },
          SpecifIcon
            | doc m%"
            A symbol for display as a prefix to titles; applicable to all instances of the class. Is usually a XML-encoded UTF-8 symbol, can be an URL or dataURL.
            "%
            = String,
          SpecifId
            | doc m%"
            A globally unique identifier.
            "%
            = predicates.contract_from_predicate definitions.predicate.SpecifId,
          SpecifInstantiation
            | doc m%"
            Indicates whether an instance of the class is created automatically, manually or both. All is allowed, if the property is omitted. The class is abstract and cannot be instantiated, if the property list is present, but empty.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SpecifInstantiation,
          SpecifKey
            | doc m%"
            A key for a particular revision of an identifiable item, e.g. of a resource. A key consists of a globally unique identifier and a revision. No or an undefined revision means the latest revision of the identified item.
            "%
            = {
                id | definitions.contract.SpecifId,
                revision
                  | definitions.contract.SpecifRevision
                  | doc m%"
                  If missing, the latest revision is implied.
                  "%
                  | optional,
              },
          SpecifKeys
            | doc m%"
            A list of keys referencing items such as propertyClasses, resourceClasses or statementClasses; any list must have >0 entries including those of any parent element.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SpecifKeys,
          SpecifMultiLanguageText
            | doc m%"
            A list of items with text and language properties. If the information is be provided in multiple languages, the language must be specified for proper selection; it is however not required by the schema to avoid a lot of overhead in most cases with a single language.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SpecifMultiLanguageText,
          SpecifNode = {
                changedAt | definitions.contract.SpecifDateTime,
                changedBy | String | optional,
                description
                  | definitions.contract.SpecifMultiLanguageText
                  | optional,
                id | definitions.contract.SpecifId,
                nodes
                  | definitions.contract.SpecifNodes
                  | doc m%"
                  The next hierarchy level.
                  "%
                  | optional,
                replaces | definitions.contract.SpecifReplaces | optional,
                resource
                  | definitions.contract.SpecifKey
                  | doc m%"
                  The pointer to the resource to be displayed at this position.
                  "%,
                revision | definitions.contract.SpecifRevision | optional,
                title
                  | definitions.contract.SpecifMultiLanguageText
                  | doc m%"
                  The node's label; if missing, the value of the referenced resource's title property is applied.
                  "%
                  | optional,
                ..
              },
          SpecifNodes
            | doc m%"
            A list of pointers to resources; may be nested forming a tree, i.e. a hierarchy of pointers.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SpecifNodes,
          SpecifOrg = { organizationName | String, .. },
          SpecifProperties
            | doc m%"
            A list of properties of a resource or statement; the number of properties including any parent's properties must be >0.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SpecifProperties,
          SpecifProperty = {
                class
                  | definitions.contract.SpecifKey
                  | doc m%"
                  Must be a member of 'propertyClasses'. In addition, it must be listed in the propertyClasses of the respective resource's or statement's (or any of it's parent's) class.
                  "%,
                values | definitions.contract.SpecifValues,
                ..
              },
          SpecifPropertyClass = {
                changedAt | definitions.contract.SpecifDateTime,
                changedBy | String | optional,
                dataType
                  | definitions.contract.SpecifKey
                  | doc m%"
                  Must be a member of dataTypes.
                  "%,
                description
                  | definitions.contract.SpecifMultiLanguageText
                  | optional,
                format
                  | definitions.contract.SpecifTextFormat
                  | doc m%"
                  The default format of a property's text value. Is superseded by a text value's format attribute.
                  "%
                  | optional,
                id | definitions.contract.SpecifId,
                multiple
                  | Bool
                  | doc m%"
                  Optional use by all propertyClasses. Indicates whether multiple values can be given. If omitted, the 'multiple' property of the dataType applies; by default the value is 'false'.
                  "%
                  | optional,
                replaces | definitions.contract.SpecifReplaces | optional,
                revision | definitions.contract.SpecifRevision | optional,
                title | definitions.contract.SpecifText,
                unit
                  | String
                  | doc m%"
                  The unit of a property's numeric value; preferrably an SI unit symbol such as 'm^3/kg' (Système international (d'unités)) or a currency symbol.
                  "%
                  | optional,
                values
                  | definitions.contract.SpecifValues
                  | doc m%"
                  An optional list of default values in case the instantiated resource's or statement's property is missing.
                  "%
                  | optional,
              },
          SpecifReplaces
            | doc m%"
            For change and configuration management; the first revision has 0 entries, a simple modification has 1 entry and the result of a merge has 2 entries.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SpecifReplaces,
          SpecifResource = {
                alternativeIds
                  | definitions.contract.SpecifAlternativeIds
                  | optional,
                changedAt | definitions.contract.SpecifDateTime,
                changedBy | String | optional,
                class
                  | definitions.contract.SpecifKey
                  | doc m%"
                  Must be a member of resourceClasses.
                  "%,
                id | definitions.contract.SpecifId,
                language
                  | String
                  | doc m%"
                  An IETF language tag such as 'en', 'en-US, 'fr' or 'de' showing the used language of the resource. Is superseded by a property's language value.
                  "%
                  | optional,
                properties | definitions.contract.SpecifProperties,
                replaces | definitions.contract.SpecifReplaces | optional,
                revision | definitions.contract.SpecifRevision | optional,
                ..
              },
          SpecifResourceClass = {
                changedAt | definitions.contract.SpecifDateTime,
                changedBy | String | optional,
                description
                  | definitions.contract.SpecifMultiLanguageText
                  | optional,
                extends
                  | definitions.contract.SpecifKey
                  | doc m%"
                  Must be a member of resourceClasses.
                  "%
                  | optional,
                icon | definitions.contract.SpecifIcon | optional,
                id | definitions.contract.SpecifId,
                instantiation
                  | definitions.contract.SpecifInstantiation
                  | optional,
                isHeading | Bool | optional,
                propertyClasses
                  | definitions.contract.SpecifKeys
                  | doc m%"
                  A list of keys referencing propertyClasses; a base resourceClass must have at least one propertyClass, whereas an extending class may have none.
                  "%,
                replaces | definitions.contract.SpecifReplaces | optional,
                revision | definitions.contract.SpecifRevision | optional,
                title | definitions.contract.SpecifText,
              },
          SpecifRevision
            | doc m%"
            A globally unique revision tag with one or multiple blocks with alphanumeric characters separated by a special character [.:,;/-]. Sequential as well as branching/merging notations are possible.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SpecifRevision,
          SpecifRights = { title | String, url | String, .. },
          SpecifStatement = {
                alternativeIds
                  | definitions.contract.SpecifAlternativeIds
                  | optional,
                changedAt | definitions.contract.SpecifDateTime,
                changedBy | String | optional,
                class
                  | definitions.contract.SpecifKey
                  | doc m%"
                  Must be a member of statementClasses.
                  "%,
                id | definitions.contract.SpecifId,
                language
                  | String
                  | doc m%"
                  An IETF language tag such as 'en', 'en-US, 'fr' or 'de' showing the used language of the statement. Is superseded by a property's language value.
                  "%
                  | optional,
                object
                  | definitions.contract.SpecifKey
                  | doc m%"
                  Must be a member of resources or statements.
                  "%,
                properties
                  | definitions.contract.SpecifProperties
                  | doc m%"
                  If there is no title property, the statementClass' title applies.
                  "%
                  | optional,
                replaces | definitions.contract.SpecifReplaces | optional,
                revision | definitions.contract.SpecifRevision | optional,
                subject
                  | definitions.contract.SpecifKey
                  | doc m%"
                  Must be a member of resources or statements.
                  "%,
                ..
              },
          SpecifStatementClass = {
                changedAt | definitions.contract.SpecifDateTime,
                changedBy | String | optional,
                description
                  | definitions.contract.SpecifMultiLanguageText
                  | optional,
                extends
                  | definitions.contract.SpecifKey
                  | doc m%"
                  Must be a member of statementClasses.
                  "%
                  | optional,
                icon | definitions.contract.SpecifIcon | optional,
                id | definitions.contract.SpecifId,
                instantiation
                  | definitions.contract.SpecifInstantiation
                  | optional,
                isUndirected
                  | Bool
                  | doc m%"
                  Indicates that an instance's subject and object are equivalent and can be exchanged without change in meaning.
                  "%
                  | optional,
                objectClasses
                  | definitions.contract.SpecifKeys
                  | doc m%"
                  A list of keys referencing eligible resource and statement classes for a statement's object; if missing, all resource or statement classes are eligible.
                  "%
                  | optional,
                propertyClasses
                  | definitions.contract.SpecifKeys
                  | doc m%"
                  A list of keys referencing propertyClasses; a statementClass may exist without propertyClasses.
                  "%
                  | optional,
                replaces | definitions.contract.SpecifReplaces | optional,
                revision | definitions.contract.SpecifRevision | optional,
                subjectClasses
                  | definitions.contract.SpecifKeys
                  | doc m%"
                  A list of keys referencing eligible resource and statement classes for a statement's subject; if missing, all resource or statement classes are eligible.
                  "%
                  | optional,
                title | definitions.contract.SpecifText,
              },
          SpecifText
            | doc m%"
            A good class name indicates it's role. The use of a vocabulary-term is recommended, which in turn can be translated to any natural or domain language.
            "%
            = String,
          SpecifTextFormat = std.contract.Sequence
              [ std.enum.TagOrString, [| 'xhtml, 'plain |] ],
          SpecifValue = predicates.contract_from_predicate
              definitions.predicate.SpecifValue,
          SpecifValues
            | doc m%"
            If 'multiple' of the propertyClass is undefined or false, the array must contain one item. If the value is unknown, omit the whole property. By default, the class' value applies.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SpecifValues,
        },
    predicate = {
          SpecifAlternativeId
            | doc m%"
            A list of pointers to resources resp. statements which have been merged to this one.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  id = definitions.predicate.SpecifId,
                  project = definitions.predicate.SpecifId,
                  revision = definitions.predicate.SpecifRevision,
                }
                {  }
                false
                predicates.never
              ],
          SpecifAlternativeIds
            | doc m%"
            The list of consolidated items to be used in case a consolidated item shall be updated.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.SpecifAlternativeId,
                predicates.arrays.uniqueItems
              ],
          SpecifCreatedBy
            | doc m%"
            The creator of the SpecIF data-set (file). If specified, at least an e-mail address must be given.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "email" ],
                predicates.records.record
                {
                  email = predicates.isType '"String",
                  familyName = predicates.isType '"String",
                  givenName = predicates.isType '"String",
                  org = definitions.predicate.SpecifOrg,
                }
                {  }
                true
                predicates.always
              ],
          SpecifDataType = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "changedAt", "id", "title", "type" ],
                  predicates.records.record
                  {
                    changedAt = definitions.predicate.SpecifDateTime,
                    changedBy = predicates.isType '"String",
                    description = definitions.predicate.SpecifMultiLanguageText,
                    id = definitions.predicate.SpecifId,
                    replaces = definitions.predicate.SpecifReplaces,
                    revision = definitions.predicate.SpecifRevision,
                    title = definitions.predicate.SpecifText,
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "xs:boolean" ]
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "changedAt", "id", "title", "type" ],
                  predicates.records.record
                  {
                    changedAt = definitions.predicate.SpecifDateTime,
                    changedBy = predicates.isType '"String",
                    description = definitions.predicate.SpecifMultiLanguageText,
                    enumeration = definitions.predicate.SpecifEnumeratedValues,
                    id = definitions.predicate.SpecifId,
                    multiple = predicates.isType '"Bool",
                    replaces = definitions.predicate.SpecifReplaces,
                    revision = definitions.predicate.SpecifRevision,
                    title = definitions.predicate.SpecifText,
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "xs:dateTime", "xs:duration", "xs:anyURI" ]
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "changedAt", "id", "title", "type" ],
                  predicates.records.record
                  {
                    changedAt = definitions.predicate.SpecifDateTime,
                    changedBy = predicates.isType '"String",
                    description = definitions.predicate.SpecifMultiLanguageText,
                    enumeration = definitions.predicate.SpecifEnumeratedValues,
                    id = definitions.predicate.SpecifId,
                    maxInclusive = predicates.isType '"Number",
                    minInclusive = predicates.isType '"Number",
                    multiple = predicates.isType '"Bool",
                    replaces = definitions.predicate.SpecifReplaces,
                    revision = definitions.predicate.SpecifRevision,
                    title = definitions.predicate.SpecifText,
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "xs:integer" ]
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "changedAt", "id", "title", "type" ],
                  predicates.records.record
                  {
                    changedAt = definitions.predicate.SpecifDateTime,
                    changedBy = predicates.isType '"String",
                    description = definitions.predicate.SpecifMultiLanguageText,
                    enumeration = definitions.predicate.SpecifEnumeratedValues,
                    fractionDigits = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 1
                        ],
                    id = definitions.predicate.SpecifId,
                    maxInclusive = predicates.isType '"Number",
                    minInclusive = predicates.isType '"Number",
                    multiple = predicates.isType '"Bool",
                    replaces = definitions.predicate.SpecifReplaces,
                    revision = definitions.predicate.SpecifRevision,
                    title = definitions.predicate.SpecifText,
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "xs:double" ]
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "changedAt", "id", "title", "type" ],
                  predicates.records.record
                  {
                    changedAt = definitions.predicate.SpecifDateTime,
                    changedBy = predicates.isType '"String",
                    description = definitions.predicate.SpecifMultiLanguageText,
                    enumeration = definitions.predicate.SpecifEnumeratedValues,
                    id = definitions.predicate.SpecifId,
                    maxLength = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ],
                    multiple = predicates.isType '"Bool",
                    replaces = definitions.predicate.SpecifReplaces,
                    revision = definitions.predicate.SpecifRevision,
                    title = definitions.predicate.SpecifText,
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "xs:string" ]
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          SpecifDateTime
            | doc m%"
            An ISO-8601 dateTime string. For reduced accuracy, any number of values may be dropped, but only from right to left.
            "%
            = predicates.isType '"String",
          SpecifEnumeratedValue = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id", "value" ],
                predicates.records.record
                {
                  id = definitions.predicate.SpecifId,
                  value = definitions.predicate.SpecifValue,
                }
                {  }
                true
                predicates.always
              ],
          SpecifEnumeratedValues
            | doc m%"
            Enumerated values for the given dataType. If 'multiple' is true 0..n options may be selected, otherwise exactly one must be selected.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.SpecifEnumeratedValue,
                predicates.arrays.uniqueItems
              ],
          SpecifFile = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "changedAt", "id", "title", "type" ],
                predicates.records.record
                {
                  changedAt = definitions.predicate.SpecifDateTime,
                  changedBy = predicates.isType '"String",
                  description = definitions.predicate.SpecifMultiLanguageText,
                  id = definitions.predicate.SpecifId,
                  replaces = definitions.predicate.SpecifReplaces,
                  revision = definitions.predicate.SpecifRevision,
                  title = predicates.isType '"String",
                  type = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          SpecifIcon
            | doc m%"
            A symbol for display as a prefix to titles; applicable to all instances of the class. Is usually a XML-encoded UTF-8 symbol, can be an URL or dataURL.
            "%
            = predicates.isType '"String",
          SpecifId
            | doc m%"
            A globally unique identifier.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[_a-zA-Z]{1}[_a-zA-Z0-9.-]*$"
              ],
          SpecifInstantiation
            | doc m%"
            Indicates whether an instance of the class is created automatically, manually or both. All is allowed, if the property is omitted. The class is abstract and cannot be instantiated, if the property list is present, but empty.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "auto", "user" ]
                ]),
                predicates.arrays.uniqueItems
              ],
          SpecifKey
            | doc m%"
            A key for a particular revision of an identifiable item, e.g. of a resource. A key consists of a globally unique identifier and a revision. No or an undefined revision means the latest revision of the identified item.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  id = definitions.predicate.SpecifId,
                  revision = definitions.predicate.SpecifRevision,
                }
                {  }
                false
                predicates.never
              ],
          SpecifKeys
            | doc m%"
            A list of keys referencing items such as propertyClasses, resourceClasses or statementClasses; any list must have >0 entries including those of any parent element.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.SpecifKey,
                predicates.arrays.uniqueItems
              ],
          SpecifMultiLanguageText
            | doc m%"
            A list of items with text and language properties. If the information is be provided in multiple languages, the language must be specified for proper selection; it is however not required by the schema to avoid a lot of overhead in most cases with a single language.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "text" ],
                  predicates.records.record
                  {
                    format = definitions.predicate.SpecifTextFormat,
                    language = predicates.isType '"String",
                    text = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ]),
                predicates.arrays.uniqueItems
              ],
          SpecifNode = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "changedAt", "id", "resource" ],
                predicates.records.record
                {
                  changedAt = definitions.predicate.SpecifDateTime,
                  changedBy = predicates.isType '"String",
                  description = definitions.predicate.SpecifMultiLanguageText,
                  id = definitions.predicate.SpecifId,
                  nodes = definitions.predicate.SpecifNodes,
                  replaces = definitions.predicate.SpecifReplaces,
                  resource = definitions.predicate.SpecifKey,
                  revision = definitions.predicate.SpecifRevision,
                  title = definitions.predicate.SpecifMultiLanguageText,
                }
                {  }
                true
                predicates.always
              ],
          SpecifNodes
            | doc m%"
            A list of pointers to resources; may be nested forming a tree, i.e. a hierarchy of pointers.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.SpecifNode,
                predicates.arrays.uniqueItems
              ],
          SpecifOrg = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "organizationName" ],
                predicates.records.record
                { organizationName = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          SpecifProperties
            | doc m%"
            A list of properties of a resource or statement; the number of properties including any parent's properties must be >0.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.SpecifProperty,
                predicates.arrays.uniqueItems
              ],
          SpecifProperty = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "class", "values" ],
                predicates.records.record
                {
                  class = definitions.predicate.SpecifKey,
                  values = definitions.predicate.SpecifValues,
                }
                {  }
                true
                predicates.always
              ],
          SpecifPropertyClass = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "changedAt", "dataType", "id", "title" ],
                predicates.records.record
                {
                  changedAt = definitions.predicate.SpecifDateTime,
                  changedBy = predicates.isType '"String",
                  dataType = definitions.predicate.SpecifKey,
                  description = definitions.predicate.SpecifMultiLanguageText,
                  format = definitions.predicate.SpecifTextFormat,
                  id = definitions.predicate.SpecifId,
                  multiple = predicates.isType '"Bool",
                  replaces = definitions.predicate.SpecifReplaces,
                  revision = definitions.predicate.SpecifRevision,
                  title = definitions.predicate.SpecifText,
                  unit = predicates.isType '"String",
                  values = definitions.predicate.SpecifValues,
                }
                {  }
                false
                predicates.never
              ],
          SpecifReplaces
            | doc m%"
            For change and configuration management; the first revision has 0 entries, a simple modification has 1 entry and the result of a merge has 2 entries.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.SpecifRevision,
                predicates.arrays.maxItems 2,
                predicates.arrays.uniqueItems
              ],
          SpecifResource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "changedAt", "class", "id", "properties" ],
                predicates.records.record
                {
                  alternativeIds = definitions.predicate.SpecifAlternativeIds,
                  changedAt = definitions.predicate.SpecifDateTime,
                  changedBy = predicates.isType '"String",
                  class = definitions.predicate.SpecifKey,
                  id = definitions.predicate.SpecifId,
                  language = predicates.isType '"String",
                  properties = definitions.predicate.SpecifProperties,
                  replaces = definitions.predicate.SpecifReplaces,
                  revision = definitions.predicate.SpecifRevision,
                }
                {  }
                true
                predicates.always
              ],
          SpecifResourceClass = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "changedAt", "id", "propertyClasses", "title" ],
                predicates.records.record
                {
                  changedAt = definitions.predicate.SpecifDateTime,
                  changedBy = predicates.isType '"String",
                  description = definitions.predicate.SpecifMultiLanguageText,
                  extends = definitions.predicate.SpecifKey,
                  icon = definitions.predicate.SpecifIcon,
                  id = definitions.predicate.SpecifId,
                  instantiation = definitions.predicate.SpecifInstantiation,
                  isHeading = predicates.isType '"Bool",
                  propertyClasses = definitions.predicate.SpecifKeys,
                  replaces = definitions.predicate.SpecifReplaces,
                  revision = definitions.predicate.SpecifRevision,
                  title = definitions.predicate.SpecifText,
                }
                {  }
                false
                predicates.never
              ],
          SpecifRevision
            | doc m%"
            A globally unique revision tag with one or multiple blocks with alphanumeric characters separated by a special character [.:,;/-]. Sequential as well as branching/merging notations are possible.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^(?:[0-9a-zA-Z]+[.:,;/-])*[0-9a-zA-Z]+$"
              ],
          SpecifRights = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "title", "url" ],
                predicates.records.record
                {
                  title = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          SpecifStatement = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "changedAt", "class", "id", "object", "subject" ],
                predicates.records.record
                {
                  alternativeIds = definitions.predicate.SpecifAlternativeIds,
                  changedAt = definitions.predicate.SpecifDateTime,
                  changedBy = predicates.isType '"String",
                  class = definitions.predicate.SpecifKey,
                  id = definitions.predicate.SpecifId,
                  language = predicates.isType '"String",
                  object = definitions.predicate.SpecifKey,
                  properties = definitions.predicate.SpecifProperties,
                  replaces = definitions.predicate.SpecifReplaces,
                  revision = definitions.predicate.SpecifRevision,
                  subject = definitions.predicate.SpecifKey,
                }
                {  }
                true
                predicates.always
              ],
          SpecifStatementClass = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "changedAt", "id", "title" ],
                predicates.records.record
                {
                  changedAt = definitions.predicate.SpecifDateTime,
                  changedBy = predicates.isType '"String",
                  description = definitions.predicate.SpecifMultiLanguageText,
                  extends = definitions.predicate.SpecifKey,
                  icon = definitions.predicate.SpecifIcon,
                  id = definitions.predicate.SpecifId,
                  instantiation = definitions.predicate.SpecifInstantiation,
                  isUndirected = predicates.isType '"Bool",
                  objectClasses = definitions.predicate.SpecifKeys,
                  propertyClasses = definitions.predicate.SpecifKeys,
                  replaces = definitions.predicate.SpecifReplaces,
                  revision = definitions.predicate.SpecifRevision,
                  subjectClasses = definitions.predicate.SpecifKeys,
                  title = definitions.predicate.SpecifText,
                }
                {  }
                false
                predicates.never
              ],
          SpecifText
            | doc m%"
            A good class name indicates it's role. The use of a vocabulary-term is recommended, which in turn can be translated to any natural or domain language.
            "%
            = predicates.isType '"String",
          SpecifTextFormat = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "plain", "xhtml" ]
              ],
          SpecifValue = predicates.oneOf
              [
                predicates.isType '"String",
                definitions.predicate.SpecifMultiLanguageText
              ],
          SpecifValues
            | doc m%"
            If 'multiple' of the propertyClass is undefined or false, the array must contain one item. If the value is unknown, omit the whole property. By default, the class' value applies.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.SpecifValue,
                predicates.arrays.minItems 1,
                predicates.arrays.uniqueItems
              ],
        },
  }
in

{
  "$schema"
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"String",
      predicates.strings.pattern
      "^https?:\\/\\/(specif\\.de\\/v1\\.1\\/schema|json\\.schemastore\\.org\\/specif-1\\.1)\\.json$"
    ])
    | doc m%"
    An absolute URL pointing to this SpecIF schema. Supports both specif.de and schemastore.org.
    "%,
  createdAt | definitions.contract.SpecifDateTime | optional,
  createdBy | definitions.contract.SpecifCreatedBy | optional,
  dataTypes
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.SpecifDataType,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    The base data types for use by property class definitions.
    "%,
  description
    | definitions.contract.SpecifMultiLanguageText
    | doc m%"
    The project's description; if missing, the first hierarchy node's description applies.
    "%
    | optional,
  files
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.SpecifFile,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    A list of files being referenced by a resource's or statement's property of dataType XHTML using an <object> tag. A file should have a media type as defined by IANA (see below).
    "%
    | optional,
  generator | String | optional,
  generatorVersion | String | optional,
  hierarchies
    | definitions.contract.SpecifNodes
    | doc m%"
    A list of hierarchies with pointers to resources; may be nested to build a tree, i.e. a hierarchy of pointers.
    "%,
  id | definitions.contract.SpecifId,
  isExtension
    | Bool
    | doc m%"
    Indicates that the project is not schema-compliant on its own; by default the value is 'false'. Of course, it is expected that once extended the project is schema-compliant.
    "%
    | optional,
  language
    | String
    | doc m%"
    An IETF language tag such as 'en', 'en-US, 'fr' or 'de' showing the used language of the project. Is superseded by a resource's, statement's or property's language value. By default, 'en' is assumed.
    "%
    | optional,
  propertyClasses
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.SpecifPropertyClass,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    Class definition of a property for resources or statements. Is a sub-element of the respective resourceClass or statementClass. If no revision or change information is specified, the respective values of the parent element apply.
    "%,
  resourceClasses
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.SpecifResourceClass,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    The class definitions for resources.
    "%,
  resources
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.SpecifResource,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    The resources such as diagrams, model elements or requirements.
    "%,
  revision | definitions.contract.SpecifRevision | optional,
  rights | definitions.contract.SpecifRights | optional,
  statementClasses
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.SpecifStatementClass,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    The class definitions for statements in subject-predicate-object statements, where subject and object are resources.
    "%,
  statements
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.SpecifStatement,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    Subject-predicate-Object statements, where subject and object are resources. In other terms, statements are directed relations between two resources building a semantic net.
    "%,
  title
    | definitions.contract.SpecifMultiLanguageText
    | doc m%"
    The project's name; if missing, the first hierarchy node's title applies.
    "%
    | optional,
  ..
}