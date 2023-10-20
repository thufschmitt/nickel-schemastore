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
          AppConf = predicates.contract_from_predicate
              definitions.predicate.AppConf,
          AppRedactions = predicates.contract_from_predicate
              definitions.predicate.AppRedactions,
          AuthTestPath = predicates.contract_from_predicate
              definitions.predicate.AuthTestPath,
          Authentication = predicates.contract_from_predicate
              definitions.predicate.Authentication,
          AuthenticationScript = predicates.contract_from_predicate
              definitions.predicate.AuthenticationScript,
          CookieAuthorization = predicates.contract_from_predicate
              definitions.predicate.CookieAuthorization,
          CredentialsEntry = predicates.contract_from_predicate
              definitions.predicate.CredentialsEntry,
          CustomDiscovery = predicates.contract_from_predicate
              definitions.predicate.CustomDiscovery,
          CustomVariable = predicates.contract_from_predicate
              definitions.predicate.CustomVariable,
          EnabledRPCParam = predicates.contract_from_predicate
              definitions.predicate.EnabledRPCParam,
          ExternalCredentials = predicates.contract_from_predicate
              definitions.predicate.ExternalCredentials,
          GraphQLConf = predicates.contract_from_predicate
              definitions.predicate.GraphQLConf,
          GraphQLCustomVariable = predicates.contract_from_predicate
              definitions.predicate.GraphQLCustomVariable,
          GraphQLExcludeOperationParam = predicates.contract_from_predicate
              definitions.predicate.GraphQLExcludeOperationParam,
          GrpcConf = predicates.contract_from_predicate
              definitions.predicate.GrpcConf,
          HawkAddOnConf = predicates.contract_from_predicate
              definitions.predicate.HawkAddOnConf,
          HawkConf = predicates.contract_from_predicate
              definitions.predicate.HawkConf,
          HawkscanConf = predicates.contract_from_predicate
              definitions.predicate.HawkscanConf,
          InjectableParam = predicates.contract_from_predicate
              definitions.predicate.InjectableParam,
          InputVectorParams = predicates.contract_from_predicate
              definitions.predicate.InputVectorParams,
          NameValParam = predicates.contract_from_predicate
              definitions.predicate.NameValParam,
          OpenApiConf = predicates.contract_from_predicate
              definitions.predicate.OpenApiConf,
          OpenApiCustomVariable = predicates.contract_from_predicate
              definitions.predicate.OpenApiCustomVariable,
          ParametersEntry = predicates.contract_from_predicate
              definitions.predicate.ParametersEntry,
          PostmanConfig = predicates.contract_from_predicate
              definitions.predicate.PostmanConfig,
          Proxy = predicates.contract_from_predicate
              definitions.predicate.Proxy,
          ProxyCredentials = predicates.contract_from_predicate
              definitions.predicate.ProxyCredentials,
          Replacer = predicates.contract_from_predicate
              definitions.predicate.Replacer,
          ReplacerRules = predicates.contract_from_predicate
              definitions.predicate.ReplacerRules,
          RequestHeadersEntry = predicates.contract_from_predicate
              definitions.predicate.RequestHeadersEntry,
          ScanConf = predicates.contract_from_predicate
              definitions.predicate.ScanConf,
          Script = predicates.contract_from_predicate
              definitions.predicate.Script,
          SessionScript = predicates.contract_from_predicate
              definitions.predicate.SessionScript,
          SoapConf = predicates.contract_from_predicate
              definitions.predicate.SoapConf,
          Spider = predicates.contract_from_predicate
              definitions.predicate.Spider,
          Tag = predicates.contract_from_predicate definitions.predicate.Tag,
          TokenAuthorization = predicates.contract_from_predicate
              definitions.predicate.TokenAuthorization,
          TokenExtraction = predicates.contract_from_predicate
              definitions.predicate.TokenExtraction,
          UsernamePasswordCredentials = predicates.contract_from_predicate
              definitions.predicate.UsernamePasswordCredentials,
          WaitForAppTarget = predicates.contract_from_predicate
              definitions.predicate.WaitForAppTarget,
        },
    predicate = {
          AppConf = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "authentication" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.not
                  (predicates.allOf
                  [
                    predicates.records.required [ "authentication" ],
                    predicates.records.record {  } {  } true predicates.always
                  ])
                ],
                predicates.records.required [ "applicationId", "env", "host" ],
                predicates.records.record
                {
                  antiCsrfParam = predicates.isType '"String",
                  applicationId = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "\\b[0-9a-f]{8}\\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\\b[0-9a-f]{12}\\b"
                      ],
                  authentication = definitions.predicate.Authentication,
                  autoInputVectors = predicates.isType '"Bool",
                  autoPolicy = predicates.isType '"Bool",
                  env = predicates.isType '"String",
                  excludePaths = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  graphqlConf = definitions.predicate.GraphQLConf,
                  grpcConf = definitions.predicate.GrpcConf,
                  host = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "(?:(?:https?|ftp|file):\\/\\/|www\\.|ftp\\.)(?:\\([-\\w\\d+&@#\\/%=~_|$?!:,.]*\\)|[-\\w\\d+&@#\\/%=~_|$?!:,.])*(?:\\([-\\w\\d+&@#\\/%=~_|$?!:,.]*\\)|[\\w\\d+&@#\\/%=~_|$])"
                      ],
                  includePaths = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  inputVectors = definitions.predicate.InputVectorParams,
                  openApiConf = definitions.predicate.OpenApiConf,
                  redact = definitions.predicate.AppRedactions,
                  sessionTokens = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  soapConf = definitions.predicate.SoapConf,
                  waitForAppTarget = definitions.predicate.WaitForAppTarget,
                }
                {  }
                false
                predicates.never
              ],
          AppRedactions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  headers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  values = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          AuthTestPath = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "success" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "fail" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  fail = predicates.isType '"String",
                  path = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^\\/(([A-z0-9\\-\\%]+\\/)*[A-z0-9\\-\\%]+$)?"
                      ],
                  requestBody = predicates.isType '"String",
                  requestHeaders = definitions.predicate.RequestHeadersEntry,
                  requestMethod = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "GET", "POST", "PUT" ]
                      ],
                  success = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "HEADER", "BODY" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Authentication = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.records.required [ "usernamePassword" ],
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.allOf
                    [
                      predicates.records.required [ "external" ],
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.allOf
                    [
                      predicates.records.required [ "script" ],
                      predicates.records.record {  } {  } true predicates.always
                    ]
                  ],
                  predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.records.required [ "cookieAuthorization" ],
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.allOf
                    [
                      predicates.records.required [ "tokenAuthorization" ],
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.allOf
                    [
                      predicates.records.required [ "sessionScript" ],
                      predicates.records.record {  } {  } true predicates.always
                    ]
                  ]
                ],
                predicates.records.required
                [ "loggedInIndicator", "loggedOutIndicator", "testPath" ],
                predicates.records.record
                {
                  cookieAuthorization =
                    definitions.predicate.CookieAuthorization,
                  external = definitions.predicate.ExternalCredentials,
                  loggedInIndicator = predicates.isType '"String",
                  loggedOutIndicator = predicates.isType '"String",
                  script = definitions.predicate.AuthenticationScript,
                  sessionScript = definitions.predicate.SessionScript,
                  testPath = definitions.predicate.AuthTestPath,
                  tokenAuthorization = definitions.predicate.TokenAuthorization,
                  tokenExtraction = definitions.predicate.TokenExtraction,
                  usernamePassword =
                    definitions.predicate.UsernamePasswordCredentials,
                }
                {  }
                true
                predicates.always
              ],
          AuthenticationScript = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  credentials = definitions.predicate.CredentialsEntry,
                  name = predicates.isType '"String",
                  parameters = definitions.predicate.ParametersEntry,
                }
                {  }
                true
                predicates.always
              ],
          CookieAuthorization = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cookieNames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          CredentialsEntry = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          CustomDiscovery = predicates.isType 'Record,
          CustomVariable = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  field = predicates.isType '"String",
                  values = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          EnabledRPCParam = predicates.isType 'Record,
          ExternalCredentials = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "TOKEN", "COOKIE" ]
                      ],
                  values = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.NameValParam
                      ],
                }
                {  }
                true
                predicates.always
              ],
          GraphQLConf = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  customVariables = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.GraphQLCustomVariable
                      ],
                  enabled = predicates.isType '"Bool",
                  excludeOperations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.GraphQLExcludeOperationParam
                      ],
                  fakerEnabled = predicates.isType '"Bool",
                  filePath = predicates.isType '"String",
                  maxDepth = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String"
                        ],
                        predicates.numbers.maximum 50,
                        predicates.numbers.exclusiveMinimum 0,
                        predicates.strings.pattern "^([0-9][0-9]+|[1-9]|0)$"
                      ],
                  operation = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ALL", "QUERY", "MUTATION" ]
                      ],
                  requestMethod = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "POST", "GET" ]
                      ],
                  schemaPath = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^\\/(([A-z0-9\\-\\%]+\\/)*[A-z0-9\\-\\%]+$)?"
                      ],
                  uriMaxLength = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String"
                        ],
                        predicates.numbers.minimum 0,
                        predicates.strings.pattern "^([0-9][0-9]+|[1-9]|0)$"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          GraphQLCustomVariable = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  field = predicates.isType '"String",
                  operationName = predicates.isType '"String",
                  operationType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ALL", "QUERY", "MUTATION" ]
                      ],
                  values = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          GraphQLExcludeOperationParam = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ALL", "QUERY", "MUTATION" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          GrpcConf = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  customVariables = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.CustomVariable
                      ],
                  filePath = predicates.isType '"String",
                  path = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          HawkAddOnConf = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  replacer = definitions.predicate.Replacer,
                  scripts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Script
                      ],
                }
                {  }
                false
                predicates.never
              ],
          HawkConf = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  config = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^([a-zA-Z0-9]*\\.)*([a-zA-Z_$0-9])+=.*$"
                        ])
                      ],
                  failureThreshold = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "\\b(?:high|medium|low|HIGH|MEDIUM|LOW)\\b"
                      ],
                  outboundProxy = definitions.predicate.Proxy,
                  scan = definitions.predicate.ScanConf,
                  spider = definitions.predicate.Spider,
                  startupTimeoutMinutes = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.exclusiveMinimum 0
                      ],
                }
                {  }
                false
                predicates.never
              ],
          HawkscanConf = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "app" ],
                predicates.records.record
                {
                  app = definitions.predicate.AppConf,
                  hawk = definitions.predicate.HawkConf,
                  hawkAddOn = definitions.predicate.HawkAddOnConf,
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Tag
                      ],
                }
                {  }
                false
                predicates.never
              ],
          InjectableParam = predicates.isType 'Record,
          InputVectorParams = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabledRpcParam = definitions.predicate.EnabledRPCParam,
                  injectableParam = definitions.predicate.InjectableParam,
                }
                {  }
                true
                predicates.always
              ],
          NameValParam = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  val = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          OpenApiConf = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  customVariables = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.OpenApiCustomVariable
                      ],
                  fakerEnabled = predicates.isType '"Bool",
                  filePath = predicates.isType '"String",
                  includeAllMethods = predicates.isType '"Bool",
                  includedMethods = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "POST",
                            "PUT",
                            "DELETE",
                            "GET",
                            "OPTIONS",
                            "PATCH",
                            "HEAD"
                          ]
                        ])
                      ],
                  inline = predicates.isType '"String",
                  maxAliasesForCollections = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String"
                        ],
                        predicates.numbers.minimum 0,
                        predicates.strings.pattern "^([0-9][0-9]+|[1-9]|0)$"
                      ],
                  path = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^\\/(([A-z0-9\\-\\%]+\\/)*[A-z0-9\\-\\%]+$)?"
                      ],
                  strict = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          OpenApiCustomVariable = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  field = predicates.isType '"String",
                  path = predicates.isType '"String",
                  requestMethods = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "POST",
                            "PUT",
                            "DELETE",
                            "GET",
                            "OPTIONS",
                            "PATCH",
                            "HEAD"
                          ]
                        ])
                      ],
                  values = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          ParametersEntry = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          PostmanConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apikey = predicates.isType '"String",
                  collectionUID = predicates.isType '"String",
                  filePath = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Proxy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  credentials = definitions.predicate.ProxyCredentials,
                  host = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          ProxyCredentials = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  password = predicates.isType '"String",
                  realm = predicates.isType '"String",
                  scheme = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Replacer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  rules = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ReplacerRules
                      ],
                }
                {  }
                true
                predicates.always
              ],
          ReplacerRules = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "matchString", "replacement" ],
                predicates.records.record
                {
                  initiators = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "PROXY",
                            "ACTIVE_SCANNER",
                            "SPIDER",
                            "FUZZER",
                            "AUTHENTICATION",
                            "MANUAL_REQUEST",
                            "CHECK_FOR_UPDATES",
                            "BEAN_SHELL",
                            "ACCESS_CONTROL_SCANNER",
                            "AJAX_SPIDER",
                            "FORCED_BROWSE",
                            "TOKEN_GENERATOR",
                            "WEB_SOCKET",
                            "AUTHENTICATION_HELPER"
                          ]
                        ])
                      ],
                  isRegex = predicates.isType '"Bool",
                  matchString = predicates.isType '"String",
                  replaceOnly = predicates.isType '"Bool",
                  replacement = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          RequestHeadersEntry = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          ScanConf = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  concurrentRequests = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String"
                        ],
                        predicates.numbers.exclusiveMinimum 0,
                        predicates.strings.pattern "^([0-9][0-9]+|[1-9])$"
                      ],
                  includedPlugins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  maxDurationMinutes = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String"
                        ],
                        predicates.numbers.minimum 0,
                        predicates.strings.pattern "^([0-9][0-9]+|[1-9]|0)$"
                      ],
                  maxRuleDurationMinutes = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String"
                        ],
                        predicates.numbers.minimum 0,
                        predicates.strings.pattern "^([0-9][0-9]+|[1-9]|0)$"
                      ],
                  policyName = predicates.isType '"String",
                  requestDelayMillis = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String"
                        ],
                        predicates.numbers.minimum 0,
                        predicates.strings.pattern "^([0-9][0-9]+|[1-9]|0)$"
                      ],
                  throttlePassiveBacklog = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String"
                        ],
                        predicates.numbers.exclusiveMinimum 0,
                        predicates.strings.pattern "^([0-9][0-9]+|[1-9])$"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Script = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "language" ],
                predicates.records.record
                {
                  id = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String"
                      ],
                  language = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "KOTLIN", "JAVASCRIPT" ]
                      ],
                  name = predicates.isType '"String",
                  path = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "active",
                          "authentication",
                          "httpsender",
                          "passive",
                          "proxy",
                          "standalone",
                          "targeted",
                          "session"
                        ]
                      ],
                  vars = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.NameValParam
                      ],
                }
                {  }
                true
                predicates.always
              ],
          SessionScript = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  parameters = definitions.predicate.ParametersEntry,
                }
                {  }
                true
                predicates.always
              ],
          SoapConf = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  filePath = predicates.isType '"String",
                  path = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^\\/(([A-z0-9\\-\\%]+\\/)*[A-z0-9\\-\\%]+$)?"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Spider = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ajax = predicates.isType '"Bool",
                  ajaxBrowser = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "FIREFOX_HEADLESS",
                          "CHROME_HEADLESS",
                          "FIREFOX",
                          "CHROME"
                        ]
                      ],
                  base = predicates.isType '"Bool",
                  custom = definitions.predicate.CustomDiscovery,
                  maxDurationMinutes = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  postmanConfig = definitions.predicate.PostmanConfig,
                  seedPaths = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Tag = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.maxLength 128,
                        predicates.strings.minLength 1,
                        predicates.strings.pattern "^[a-zA-Z0-9_-]+$"
                      ],
                  value = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.maxLength 512,
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          TokenAuthorization = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "value" ],
                predicates.records.record
                {
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "HEADER", "QUERY_PARAM" ]
                      ],
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          TokenExtraction = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "value" ],
                predicates.records.record
                {
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "TOKEN_PATH", "HEADER_NAME" ]
                      ],
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          UsernamePasswordCredentials = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "loginPath",
                  "passwordField",
                  "scanPassword",
                  "scanUsername",
                  "usernameField"
                ],
                predicates.records.record
                {
                  loginPagePath = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^\\/(([A-z0-9\\-\\%]+\\/)*[A-z0-9\\-\\%]+$)?"
                      ],
                  loginPath = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^\\/(([A-z0-9\\-\\%]+\\/)*[A-z0-9\\-\\%]+$)?"
                      ],
                  otherParams = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.NameValParam
                      ],
                  passwordField = predicates.isType '"String",
                  realm = predicates.isType '"String",
                  scanPassword = predicates.isType '"String",
                  scanUsername = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "FORM", "JSON", "HTTP" ]
                      ],
                  usernameField = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          WaitForAppTarget = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "pollDelay", "waitTimeoutMillis" ],
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  pollDelay = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String"
                        ],
                        predicates.numbers.minimum 50,
                        predicates.strings.pattern "^([0-9][0-9]+|[1-9]|0)$"
                      ],
                  requestBody = predicates.isType '"String",
                  requestMethod = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "GET", "POST", "PUT" ]
                      ],
                  waitTimeoutMillis = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String"
                        ],
                        predicates.numbers.minimum 0,
                        predicates.strings.pattern "^([0-9][0-9]+|[1-9]|0)$"
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
  predicates.records.record
  {
    app = predicates.allOf
        [ predicates.isType 'Record, definitions.predicate.AppConf ],
    hawk = predicates.allOf
        [ predicates.isType 'Record, definitions.predicate.HawkConf ],
    hawkAddOn = predicates.allOf
        [ predicates.isType 'Record, definitions.predicate.HawkAddOnConf ],
    tags = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.Tag
        ],
  }
  {  }
  true
  predicates.always
])