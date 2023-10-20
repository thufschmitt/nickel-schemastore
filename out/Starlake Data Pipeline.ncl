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
          AccessControlEntry
            | doc m%"
            Column level security policy to apply to the attribute.
            "%
            = {
                grants
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  user / groups / service accounts to which this security level is applied.
                  ex : user:me@mycompany.com,group:group@mycompany.com,serviceAccount:mysa@google-accounts.com
                  "%,
                role
                  | String
                  | doc m%"
                  This role to give to the granted users
                  "%,
                ..
              },
          AccessPolicies = {
                apply
                  | Bool
                  | doc m%"
                  Should access policies be enforced ?
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  GCP Project id. Required if apply is true.
                  "%
                  | optional,
                location
                  | String
                  | doc m%"
                  GCP project location. Required if apply is true.
                  "%
                  | optional,
                taxonomy
                  | String
                  | doc m%"
                  Taxonomy name. Required if apply is true.
                  "%
                  | optional,
                ..
              },
          Application = {
                accessPolicies
                  | definitions.contract.AccessPolicies
                  | doc m%"
                  Access policies configuration
                  "%
                  | optional,
                analyze
                  | Bool
                  | doc m%"
                  Should we analyze the result and generate HIVE statistics ? (useful for Spark / Databricks) 
                  "%
                  | optional,
                archive
                  | Bool
                  | doc m%"
                  Should ingested files be archived after ingestion ?
                  "%
                  | optional,
                area
                  | definitions.contract.Area
                  | doc m%"
                  pending, accepted ... areas configuration
                  "%
                  | optional,
                audit | definitions.contract.Audit | optional,
                connectionRef
                  | String
                  | doc m%"
                  Default connection to use when loading / transforming data
                  "%
                  | optional,
                connections
                  | definitions.contract.MapConnection
                  | doc m%"
                  Connection configurations
                  "%
                  | optional,
                csvOutput
                  | Bool
                  | doc m%"
                  output files in CSV format ? Default is false
                  "%
                  | optional,
                csvOutputExt
                  | String
                  | doc m%"
                  CSV file extension when csvOutput is true. Default is .csv
                  "%
                  | optional,
                dags
                  | String
                  | doc m%"
                  DAG generation config folder. metadata/dags by default
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  Default target database (projectId in GCP). May be also set using the SL_DATABASE environment variable
                  "%
                  | optional,
                datasets
                  | String
                  | doc m%"
                  When using filesystem storage, default path to store the datasets
                  "%
                  | optional,
                defaultAuditWriteFormat
                  | String
                  | doc m%"
                  Default write format in Spark for audit records. parquet is the default
                  "%
                  | optional,
                defaultFormat
                  | String
                  | doc m%"
                  Default write format in Spark. parquet is the default
                  "%
                  | optional,
                defaultRejectedWriteFormat
                  | String
                  | doc m%"
                  Default write format in Spark for rejected records. parquet is the default
                  "%
                  | optional,
                dsvOptions
                  | definitions.contract.MapString
                  | doc m%"
                  DSV ingestion extra options
                  "%
                  | optional,
                emptyIsNull
                  | Bool
                  | doc m%"
                  Should empty strings be considered as null values ?
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  Default environment to use. May be also set using the SL_ENV environment variable
                  "%
                  | optional,
                expectations
                  | definitions.contract.ExpectationsConfig
                  | doc m%"
                  Expectations configuration
                  "%
                  | optional,
                forceDomainPattern
                  | String
                  | doc m%"
                  reserved
                  "%
                  | optional,
                forceJobPattern
                  | String
                  | doc m%"
                  reserved
                  "%
                  | optional,
                forceTablePattern
                  | String
                  | doc m%"
                  reserved
                  "%
                  | optional,
                forceTaskPattern
                  | String
                  | doc m%"
                  reserved
                  "%
                  | optional,
                forceViewPattern
                  | String
                  | doc m%"
                  reserved
                  "%
                  | optional,
                grouped
                  | Bool
                  | doc m%"
                  Should we load of the files to be stored in the same table in a single task or one by one ?
                  "%
                  | optional,
                groupedMax
                  | std.number.Integer
                  | doc m%"
                  Maximum number of files to be stored in the same table in a single task
                  "%
                  | optional,
                hadoop
                  | definitions.contract.MapString
                  | doc m%"
                  Hadoop configuration if applicable
                  "%
                  | optional,
                hive
                  | Bool
                  | doc m%"
                  Should we create the table in Hive ? (useful for Spark / Databricks) 
                  "%
                  | optional,
                internal
                  | definitions.contract.Internal
                  | doc m%"
                  Internal configuration
                  "%
                  | optional,
                jdbcEngines
                  | definitions.contract.MapJdbcEngine
                  | doc m%"
                  JDBC engine configurations
                  "%
                  | optional,
                loadStrategyClass
                  | std.enum.TagOrString
                  | [|
                    '"ai.starlake.job.load.IngestionTimeStrategy",
                    '"ai.starlake.job.load.IngestionNameStrategy"
                  |]
                  | doc m%"
                  In what order should the files for a same table be loaded ? By time (default) or by or name ?
                  "%
                  | optional,
                loader
                  | String
                  | doc m%"
                  Default loader to use when none is specified in the schema. Valid values are 'spark' or 'native'. Default is 'spark'
                  "%
                  | optional,
                lock | definitions.contract.Lock | optional,
                maxParCopy
                  | std.number.Integer
                  | doc m%"
                  
                  "%
                  | optional,
                maxParTask
                  | std.number.Integer
                  | doc m%"
                  How many job to run simultaneously in dev mode (experimental)
                  "%
                  | optional,
                mergeForceDistinct
                  | Bool
                  | doc m%"
                  Should we force a distinct on the merge ?
                  "%
                  | optional,
                mergeOptimizePartitionWrite
                  | Bool
                  | doc m%"
                  Should we optimize the partition write on the merge ?
                  "%
                  | optional,
                metadata
                  | String
                  | doc m%"
                  default metadata folder name. May be also set using the SL_METADATA environment variable
                  "%
                  | optional,
                metrics | definitions.contract.Metrics | optional,
                privacy
                  | definitions.contract.Privacy
                  | doc m%"
                  Privacy algorithms
                  "%
                  | optional,
                privacyOnly
                  | Bool
                  | doc m%"
                  Only generate privacy tasks. Reserved for internal use
                  "%
                  | optional,
                rejectAllOnError
                  | String
                  | doc m%"
                  Should we reject all records when an error occurs ? Default is false
                  "%
                  | optional,
                rejectMaxRecords
                  | std.number.Integer
                  | doc m%"
                  Maximum number of records to reject when an error occurs. Default is 100
                  "%
                  | optional,
                root
                  | String
                  | doc m%"
                  Root folder for the application. May be also set using the SL_ROOT environment variable
                  "%
                  | optional,
                rowValidatorClass
                  | String
                  | doc m%"
                  
                  "%
                  | optional,
                schedulePresets
                  | definitions.contract.MapString
                  | doc m%"
                  Default connection to use when loading / transforming data
                  "%
                  | optional,
                scheduling
                  | definitions.contract.JobScheduling
                  | doc m%"
                  Spark Job scheduling configuration
                  "%
                  | optional,
                sessionDurationServe
                  | std.number.Integer
                  | doc m%"
                  reserved
                  "%
                  | optional,
                sinkReplayToFile
                  | Bool
                  | doc m%"
                  Should invalid records be stored in a replay file ?
                  "%
                  | optional,
                sqlParameterPattern
                  | String
                  | doc m%"
                  Pattern to use to replace parameters in SQL queries in addition to the jinja syntax {{param}}. Default is ${param}
                  "%
                  | optional,
                tenant
                  | String
                  | doc m%"
                  reserved
                  "%
                  | optional,
                treeValidatorClass
                  | String
                  | doc m%"
                  
                  "%
                  | optional,
                udfs
                  | String
                  | doc m%"
                  Coma separated list of UDF to register in Spark jobs. May be also set using the SL_UDFS environment variable
                  "%
                  | optional,
                useLocalFileSystem
                  | String
                  | doc m%"
                  reserved
                  "%
                  | optional,
                validateOnLoad
                  | Bool
                  | doc m%"
                  Validate the YAML file when loading it. If set to true fails on any error
                  "%
                  | optional,
                ..
              },
          Area = {
                accepted
                  | String
                  | doc m%"
                  When filesystem storage is used, successfully ingested stored in this this folder in parquet format or any format set by the SL_DEFAULT_WRITE_FORMAT env property.
                  "%
                  | optional,
                archive
                  | String
                  | doc m%"
                  Files that have been ingested are moved to this folder if SL_ARCHIVE is set to true.
                  "%
                  | optional,
                business
                  | String
                  | doc m%"
                  
                  "%
                  | optional,
                hiveDatabase
                  | String
                  | doc m%"
                  
                  "%
                  | optional,
                ingesting
                  | String
                  | doc m%"
                  Files that are being ingested are moved to this folder.
                  "%
                  | optional,
                pending
                  | String
                  | doc m%"
                  Files recognized by the extensions property are moved to this folder for ingestion by the "import" command.
                  "%
                  | optional,
                rejected
                  | String
                  | doc m%"
                  When filesystem storage is used, rejected records are stored in this folder in parquet format or any format set by the SL_DEFAULT_WRITE_FORMAT env property.
                  "%
                  | optional,
                replay
                  | String
                  | doc m%"
                  Invalid records are stored in this folder in source format when SL_SINK_REPLAY_TO_FILE is set to true.
                  "%
                  | optional,
                unresolved
                  | String
                  | doc m%"
                  Files that cannot be ingested (do not match by any table pattern) are moved to this folder.
                  "%
                  | optional,
                ..
              },
          Attribute = {
                accessPolicy
                  | String
                  | doc m%"
                  Policy tag to assign to this attribute. Used for column level security
                  "%
                  | optional,
                array
                  | Bool
                  | doc m%"
                  Is it an array ?
                  "%
                  | optional,
                attributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Attribute
                  ])
                  | doc m%"
                  List of sub-attributes (valid for JSON and XML files only)
                  "%
                  | optional,
                comment
                  | String
                  | doc m%"
                  free text for attribute description
                  "%
                  | optional,
                "default"
                  | String
                  | doc m%"
                  Default value for this attribute when it is not present.
                  "%
                  | optional,
                foreignKey
                  | String
                  | doc m%"
                  If this attribute is a foreign key, reference to [domain.]table[.attribute]
                  "%
                  | optional,
                ignore
                  | Bool
                  | doc m%"
                  Should this attribute be ignored on ingestion. Default to false
                  "%
                  | optional,
                metricType
                  | String
                  | doc m%"
                  If present, what kind of stat should be computed for this field
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Attribute name as defined in the source dataset and as received in the file
                  "%,
                position | definitions.contract.Position | optional,
                privacy
                  | String
                  | doc m%"
                  Should this attribute be applied a privacy transformation at ingestion time
                  "%
                  | optional,
                rename
                  | String
                  | doc m%"
                  If present, the attribute is renamed with this name
                  "%
                  | optional,
                required
                  | Bool
                  | doc m%"
                  Should this attribute always be present in the source
                  "%
                  | optional,
                script
                  | String
                  | doc m%"
                  Scripted field : SQL request on renamed column
                  "%
                  | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Tags associated with this attribute
                  "%
                  | optional,
                trim | definitions.contract.Trim | optional,
                type
                  | String
                  | doc m%"
                  semantic type of the attribute
                  "%,
                ..
              },
          AttributeDesc = {
                accessPolicy
                  | String
                  | doc m%"
                  Access policy to apply to this column
                  "%
                  | optional,
                comment
                  | String
                  | doc m%"
                  Column description
                  "%,
                name
                  | String
                  | doc m%"
                  Column name
                  "%,
                ..
              },
          Audit = {
                active
                  | Bool
                  | doc m%"
                  Output table description
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  Dataset Name in output Area (Will be the Table name in Hive & BigQuery)
                  "%
                  | optional,
                domain | String | optional,
                maxErrors
                  | String
                  | doc m%"
                  Output domain in output Area (Will be the Database name in Hive or Dataset in BigQuery)
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Main SQL request to execute (do not forget to prefix table names with the database name to avoid conflicts)
                  "%
                  | optional,
                sink
                  | definitions.contract.Sink
                  | doc m%"
                  Output Database (refer to a project id in BigQuery). Default to SL_DATABASE env var if set.
                  "%
                  | optional,
                ..
              },
          AutoJobDesc = {
                comment
                  | String
                  | doc m%"
                  Optional description.
                  "%
                  | optional,
                "default"
                  | definitions.contract.AutoTaskDesc
                  | doc m%"
                  Default task properties to apply to all tasks defined in tasks section and in included files
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Optional name. If not specified, the name of the file without the extension is used.
                  "%
                  | optional,
                tasks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.AutoTaskDesc
                  ])
                  | optional,
                ..
              },
          AutoTaskDesc = {
                acl
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.AccessControlEntry
                  ])
                  | doc m%"
                  Map of rolename -> List[Users].
                  "%
                  | optional,
                attributesDesc
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.AttributeDesc
                  ])
                  | doc m%"
                  Attributes comments and access policies
                  "%
                  | optional,
                comment
                  | String
                  | doc m%"
                  Output table description
                  "%
                  | optional,
                dagRef
                  | String
                  | doc m%"
                  Cron expression to use for this domain/table
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  Output Database (refer to a project id in BigQuery). Default to SL_DATABASE env var if set.
                  "%
                  | optional,
                domain
                  | String
                  | doc m%"
                  Output domain in output Area (Will be the Database name in Hive or Dataset in BigQuery)
                  "%
                  | optional,
                expectations
                  | definitions.contract.MapString
                  | doc m%"
                  Expectations to check after Load / Transform has succeeded
                  "%
                  | optional,
                freshness
                  | definitions.contract.Freshness
                  | doc m%"
                  Configure freshness checks on the output table
                  "%
                  | optional,
                "merge" | definitions.contract.MergeOptions | optional,
                partition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of columns used for partitioning the output.
                  "%
                  | optional,
                postsql
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of SQL requests to executed after the main SQL request is run
                  "%
                  | optional,
                presql
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of SQL requests to executed before the main SQL request is run
                  "%
                  | optional,
                python
                  | String
                  | doc m%"
                  Python script URI to execute instead of the SQL request
                  "%
                  | optional,
                rls
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.RowLevelSecurity
                  ])
                  | optional,
                schedule
                  | String
                  | doc m%"
                  Cron expression to use for this task
                  "%
                  | optional,
                sink | definitions.contract.Sink | optional,
                sql
                  | String
                  | doc m%"
                  Main SQL request to execute (do not forget to prefix table names with the database name to avoid conflicts)
                  "%
                  | optional,
                table
                  | String
                  | doc m%"
                  Dataset Name in output Area (Will be the Table name in Hive & BigQuery)
                  "%
                  | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Set of string to attach to the output table
                  "%
                  | optional,
                write | definitions.contract.WriteMode | optional,
                ..
              },
          Connection
            | doc m%"
            Connection properties to a datawarehouse.
            "%
            = {
                options
                  | definitions.contract.MapString
                  | doc m%"
                  Connection options
                  "%
                  | optional,
                sparkFormat
                  | String
                  | doc m%"
                  Set only if you want to use the Spark engine
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  aka jdbc, bigquery, snowflake, redshift ...
                  "%,
                ..
              },
          DagGenerationConfig
            | doc m%"
            Dag configuration.
            "%
            = {
                comment
                  | String
                  | doc m%"
                  Dag config description
                  "%
                  | optional,
                filnename
                  | String
                  | doc m%"
                  {schedule}, {domain}, {table} in the file name are used for DAG generation purposes
                  "%
                  | optional,
                options
                  | definitions.contract.MapString
                  | doc m%"
                  DAG generation options
                  "%
                  | optional,
                template
                  | String
                  | doc m%"
                  Dag template to use for this config. Usually a .py.j2 file
                  "%
                  | optional,
                ..
              },
          Domain
            | doc m%"
            A schema in JDBC database or a folder in HDFS or a dataset in BigQuery.
            "%
            = {
                comment
                  | String
                  | doc m%"
                  Domain Description (free text)
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  Output Database (refer to a project id in BigQuery). Default to SL_DATABASE env var if set.
                  "%
                  | optional,
                metadata | definitions.contract.Metadata | optional,
                name
                  | String
                  | doc m%"
                  Domain name. Make sure you use a name that may be used as a folder name on the target storage.
                                     - When using HDFS or Cloud Storage,  files once ingested are stored in a sub-directory named after the domain name.
                                     - When used with BigQuery, files are ingested and sorted in tables under a dataset named after the domain name.
                  "%
                  | optional,
                rename
                  | String
                  | doc m%"
                  If present, the attribute is renamed with this name
                  "%
                  | optional,
                tables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Table
                  ])
                  | doc m%"
                  List of schemas for each dataset in this domain.
                  A domain usually contains multiple schemas. Each schema defining how the contents of the input file should be parsed.
                  See Schema for more details.
                  "%
                  | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Set of string to attach to this domain
                  "%
                  | optional,
                ..
              },
          ExpectationItem
            | doc m%"
            Expectation
            "%
            = {
                expect
                  | String
                  | doc m%"
                  What outcome is expected
                  "%,
                query
                  | String
                  | doc m%"
                  SQL query to execute
                  "%,
                ..
              },
          ExpectationsConfig = {
                active
                  | Bool
                  | doc m%"
                  should expectations be executed ?
                  "%
                  | optional,
                failOnError
                  | Bool
                  | doc m%"
                  should load / transform fail on expectation error ?
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  When using filesystem storage, the path to the expectations file
                  "%
                  | optional,
                ..
              },
          External = {
                database
                  | String
                  | doc m%"
                  Database name of Project id in BigQuery
                  "%
                  | optional,
                external
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ExternalDomain
                  ])
                  | doc m%"
                  List of domains to scan
                  "%
                  | optional,
                ..
              },
          ExternalDomain = {
                name
                  | String
                  | doc m%"
                  Schema in JDBC Database / Snowflake / Redshift or Dataset in BigQuery
                  "%
                  | optional,
                tables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Tables to scan in this domain
                  "%
                  | optional,
                ..
              },
          Format
            | doc m%"
            DSV by default. Supported file formats are :\n- DSV : Delimiter-separated values file. Delimiter value is specified in the "separator" field.\n- POSITION : FIXED format file where values are located at an exact position in each line.\n- SIMPLE_JSON : For optimisation purpose, we differentiate JSON with top level values from JSON\n  with deep level fields. SIMPLE_JSON are JSON files with top level fields only.\n- JSON :  Deep JSON file. Use only when your json documents contain sub-documents, otherwise prefer to\n  use SIMPLE_JSON since it is much faster.\n- XML : XML files
            "%
            = predicates.contract_from_predicate definitions.predicate.Format,
          Freshness = {
                error
                  | String
                  | doc m%"
                  How old may be teh data before an error is raised. Use syntax like '3 day' or '2 hour' or '30 minute'
                  "%
                  | optional,
                warn
                  | String
                  | doc m%"
                  How old may be teh data before a warning is raised. Use syntax like '3 day' or '2 hour' or '30 minute'
                  "%
                  | optional,
                ..
              },
          IndexMapping = predicates.contract_from_predicate
              definitions.predicate.IndexMapping,
          Internal
            | doc m%"
            configure Spark internal options
            "%
            = {
                cacheStorageLevel
                  | String
                  | doc m%"
                  How the RDD are cached. Default is MEMORY_AND_DISK_SER.
                  Available options are (https://spark.apache.org/docs/latest/api/java/index.html?org/apache/spark/storage/StorageLevel.html):
                  - MEMORY_ONLY
                  - MEMORY_AND_DISK
                  - MEMORY_ONLY_SER
                  - MEMORY_AND_DISK_SER
                  - DISK_ONLY
                  - OFF_HEAP
                  "%
                  | optional,
                intermediateBigqueryFormat
                  | String
                  | doc m%"
                  May be parquet or ORC. Default is parquet. Used for BigQuery intermediate storage. Use ORC for for JSON files to keep the original data structure.
                  https://stackoverflow.com/questions/53674838/spark-writing-parquet-arraystring-converts-to-a-different-datatype-when-loadin
                  "%
                  | optional,
                substituteVars
                  | Bool
                  | doc m%"
                  Internal use. Do not modify.
                  "%
                  | optional,
                temporaryGcsBucket
                  | String
                  | doc m%"
                  The GCS bucket that temporarily holds the data before it is loaded to BigQuery.
                  "%
                  | optional,
                ..
              },
          JDBCSchema = {
                catalog
                  | String
                  | doc m%"
                  Optional catalog name in the source database
                  "%
                  | optional,
                columnRemarks | String | optional,
                connectionOptions | String | optional,
                fetchSize | std.number.Integer | optional,
                fullExport | Bool | optional,
                numPartitions | std.number.Integer | optional,
                numericTrim | definitions.contract.Trim | optional,
                partitionColumn | String | optional,
                pattern | String | optional,
                schema
                  | String
                  | doc m%"
                  Database schema where source tables are located
                  "%
                  | optional,
                stringPartitionFunc | String | optional,
                tableRemarks | String | optional,
                tableTypes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  One or many of the predefined table types
                  "%
                  | optional,
                tables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.JDBCTable
                  ])
                  | doc m%"
                  List of tables to extract
                  "%
                  | optional,
                template
                  | String
                  | doc m%"
                  Metadata to use for the generated YAML file.
                  "%
                  | optional,
                write | definitions.contract.WriteMode | optional,
                ..
              },
          JDBCSchemas = {
                connection
                  | definitions.contract.MapString
                  | doc m%"
                  JDBC connection options: url, user, password ...
                  "%
                  | optional,
                connectionRef
                  | String
                  | doc m%"
                  Connection name as defined in the connections section of the application.conf file
                  "%
                  | optional,
                "default" | definitions.contract.JDBCSchema | optional,
                fetchSize | std.number.Integer | optional,
                jdbcSchemas
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.JDBCSchema
                  ])
                  | doc m%"
                  List database connections to use to extract the data
                  "%
                  | optional,
                ..
              },
          JDBCTable = {
                columns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of columns to extract. All columns by default.
                  "%
                  | optional,
                connectionOptions | String | optional,
                fetchSize | std.number.Integer | optional,
                fullExport | Bool | optional,
                name
                  | String
                  | doc m%"
                  table name. Set to '*' to extract all tables
                  "%,
                numPartitions | std.number.Integer | optional,
                partitionColumn | String | optional,
                ..
              },
          JdbcEngine
            | doc m%"
            Jdbc engine
            "%
            = {
                tables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.MapTableDdl
                  ])
                  | doc m%"
                  List of all SQL create statements used to create audit tables for this JDBC engine.
                  Tables are created only if the execution of the pingSQL statement fails
                  "%
                  | optional,
                ..
              },
          JobScheduling = {
                file
                  | String
                  | doc m%"
                  Scheduler filename in the metadata folder. If not set, defaults to fairscheduler.xml.
                  "%
                  | optional,
                maxJobs
                  | std.number.Integer
                  | doc m%"
                  Max number of Spark jobs to run in parallel, default is 1
                  "%
                  | optional,
                mode
                  | String
                  | doc m%"
                  This can be FIFO or FAIR, to control whether jobs within the pool queue up behind each other (the default) or share the pool’s resources fairly.
                  "%
                  | optional,
                poolName
                  | String
                  | doc m%"
                  Pool name to use for Spark jobs, default is 'default'
                  "%
                  | optional,
                ..
              },
          Lock = {
                path
                  | String
                  | doc m%"
                  Name of the lock
                  "%
                  | optional,
                pollTime
                  | String
                  | doc m%"
                  Name of the lock
                  "%
                  | optional,
                refreshTime
                  | String
                  | doc m%"
                  Name of the lock
                  "%
                  | optional,
                timeout
                  | std.number.Integer
                  | doc m%"
                  Name of the lock
                  "%
                  | optional,
                ..
              },
          MapArrayOfString = predicates.contract_from_predicate
              definitions.predicate.MapArrayOfString,
          MapConnection
            | doc m%"
            Map of connections
            "%
            = predicates.contract_from_predicate
              definitions.predicate.MapConnection,
          MapExpectationItem
            | doc m%"
            Map of connections
            "%
            = predicates.contract_from_predicate
              definitions.predicate.MapExpectationItem,
          MapJdbcEngine
            | doc m%"
            Map of jdbc engines
            "%
            = predicates.contract_from_predicate
              definitions.predicate.MapJdbcEngine,
          MapString
            | doc m%"
            Map of string
            "%
            = predicates.contract_from_predicate
              definitions.predicate.MapString,
          MapTableDdl
            | doc m%"
            Map of table ddl
            "%
            = predicates.contract_from_predicate
              definitions.predicate.MapTableDdl,
          MergeOptions = {
                key
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  list of attributes to join an existing and incoming dataset. Use renamed columns if any here.
                  "%,
                queryFilter
                  | String
                  | doc m%"
                  Useful when you want to merge only on a subset of the existing partitions, thus improving performance and reducing costs.
                  You may use here:
                  - Any SQL condition
                  - latest which will be translated to the last existing partition
                  - column in last(10) which will apply the merge on the last 10 partitions of your dataset.
                   last and latest assume that your table is partitioned by day.
                  "%
                  | optional,
                timestamp
                  | String
                  | doc m%"
                  Timestamp column used to identify last version, if not specified currently ingested row is considered the last
                  "%
                  | optional,
                ..
              },
          Metadata = {
                ack
                  | String
                  | doc m%"
                  Ack extension used for each file. ".ack" if not specified.
                  Files are moved to the pending folder only once a file with the same name as the source file and with this extension is present.
                  To move a file without requiring an ack file to be present, set explicitly this property to the empty string value "".
                  "%
                  | optional,
                array
                  | Bool
                  | doc m%"
                  Is the json stored as a single object array ? false by default. This means that by default we have on json document per line.
                  "%
                  | optional,
                dagRef
                  | String
                  | doc m%"
                  Cron expression to use for this domain/table
                  "%
                  | optional,
                directory
                  | String
                  | doc m%"
                  Folder on the local filesystem where incoming files are stored.
                   Typically, this folder will be scanned periodically to move the dataset to the cluster for ingestion.
                                       Files located in this folder are moved to the pending folder for ingestion by the "import" command.
                  "%
                  | optional,
                emptyIsNull
                  | Bool
                  | doc m%"
                  Treat empty columns as null in DSV files. Default to false
                  "%
                  | optional,
                encoding
                  | String
                  | doc m%"
                  UTF-8 if not specified.
                  "%
                  | optional,
                escape
                  | String
                  | doc m%"
                  escaping char '\' by default
                  "%
                  | optional,
                extensions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  recognized filename extensions. json, csv, dsv, psv are recognized by default.
                  Only files with these extensions will be moved to the pending folder.
                  "%
                  | optional,
                format | definitions.contract.Format | optional,
                freshness
                  | definitions.contract.Freshness
                  | doc m%"
                  Configure freshness checks on this dataset
                  "%
                  | optional,
                ignore
                  | String
                  | doc m%"
                  Pattern to ignore or UDF to apply to ignore some lines
                  "%
                  | optional,
                loader
                  | String
                  | doc m%"
                  Loader to use, 'spark' or 'native'. Default to 'spark' of SL_LOADER env variable is set to 'native'
                  "%
                  | optional,
                multiline
                  | Bool
                  | doc m%"
                  are json objects on a single line or multiple line ? Single by default.  false means single. false also means faster
                  "%
                  | optional,
                nullValue
                  | String
                  | doc m%"
                  Treat a specific input string as a null value indicator
                  "%
                  | optional,
                options
                  | definitions.contract.MapString
                  | doc m%"
                  Options to add to the spark reader
                  "%
                  | optional,
                partition | definitions.contract.Partition | optional,
                quote
                  | String
                  | doc m%"
                  The String quote char, '"' by default
                  "%
                  | optional,
                schedule
                  | String
                  | doc m%"
                  Cron expression to use for this domain/table
                  "%
                  | optional,
                separator
                  | String
                  | doc m%"
                  the values delimiter,  ';' by default value may be a multichar string starting from Spark3
                  "%
                  | optional,
                sink | definitions.contract.Sink | optional,
                withHeader
                  | Bool
                  | doc m%"
                  does the dataset has a header ? true bu default
                  "%
                  | optional,
                write
                  | definitions.contract.WriteMode
                  | doc m%"
                  Write mode, APPEND by default
                  "%
                  | optional,
                xml
                  | definitions.contract.MapString
                  | doc m%"
                  com.databricks.spark.xml options to use (eq. rowTag)
                  "%
                  | optional,
                ..
              },
          Metrics = {
                active
                  | Bool
                  | doc m%"
                  Should metrics be computed ?
                  "%
                  | optional,
                discreteMaxCardinality
                  | std.number.Integer
                  | doc m%"
                  Max number of unique values accepted for a discrete column. Default is 10
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  When using filesystem storage, the path to the metrics file
                  "%
                  | optional,
                ..
              },
          Partition
            | doc m%"
            Partition columns, no partitioning by default
            "%
            = {
                attributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                sampling
                  | Number
                  | doc m%"
                  0.0 means no sampling, > 0  && < 1 means sample dataset, >=1 absolute number of partitions. Used exclusively on Hadoop like warehouses
                  "%
                  | optional,
                ..
              },
          Position
            | doc m%"
            First and last char positions of an attribute in a fixed length record
            "%
            = {
                first
                  | Number
                  | doc m%"
                  Zero based position of the first character for this attribute
                  "%,
                last
                  | Number
                  | doc m%"
                  Zero based position of the last character to include in this attribute
                  "%,
                ..
              },
          PrimitiveType
            | doc m%"
            Default types defined in starlake. User defined types may also be defined in the types/types.sl.yml file
            "%
            = predicates.contract_from_predicate
              definitions.predicate.PrimitiveType,
          Privacy = {
                options
                  | definitions.contract.MapString
                  | doc m%"
                  Privacy strategies. The following default strategies are defined by default:
                  - none: Leave the data as is
                  - hide: replace the data with an empty string
                  - hideX("s", n): replace the string with n occurrences of the string 's'
                  - md5: Redact the data using the MD5 algorithm
                  - sha1: Redact the data using the SHA1 algorithm
                  - sha256: Redact the data using the SHA256 algorithm
                   - sha512: Redact the data using the SHA512 algorithm
                  - initials: keep only the first char of each word in the data
                  "%
                  | optional,
                ..
              },
          Ref
            | doc m%"
            Describe how to resolve a reference in a transform task
            "%
            = {
                input
                  | definitions.contract.RefInput
                  | doc m%"
                  The input table to resolve
                  "%,
                output
                  | definitions.contract.RefOutput
                  | doc m%"
                  The output table resolved with the domain and database
                  "%,
                ..
              },
          RefInput
            | doc m%"
            Input for ref object
            "%
            = {
                database
                  | String
                  | doc m%"
                  Database pattern to match, none if any database
                  "%
                  | optional,
                domain
                  | String
                  | doc m%"
                  Domain pattern to match, none if any domain match
                  "%
                  | optional,
                table
                  | String
                  | doc m%"
                  Table pattern to match
                  "%,
                ..
              },
          RefOutput
            | doc m%"
            Output for ref object
            "%
            = {
                database
                  | String
                  | doc m%"
                  
                  "%,
                domain
                  | String
                  | doc m%"
                  
                  "%,
                table
                  | String
                  | doc m%"
                  
                  "%,
                ..
              },
          Refs = predicates.contract_from_predicate definitions.predicate.Refs,
          RowLevelSecurity
            | doc m%"
            Row level security policy to apply to the output data.
            "%
            = {
                description
                  | String
                  | doc m%"
                  Description for this access policy
                  "%
                  | optional,
                grants
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  user / groups / service accounts to which this security level is applied.
                  ex : user:me@mycompany.com,group:group@mycompany.com,serviceAccount:mysa@google-accounts.com
                  "%,
                name
                  | String
                  | doc m%"
                  This Row Level Security unique name
                  "%,
                predicate
                  | String
                  | doc m%"
                  The condition that goes to the WHERE clause and limit the visible rows.
                  "%
                  | optional,
                ..
              },
          Sink = {
                clustering
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  FS or BQ: List of attributes to use for clustering
                  "%
                  | optional,
                coalesce
                  | Bool
                  | doc m%"
                  When outputting files, should we coalesce it to a single file. Useful when CSV is the output format.
                  "%
                  | optional,
                connectionRef
                  | String
                  | doc m%"
                  JDBC: Connection String
                  "%
                  | optional,
                days
                  | Number
                  | doc m%"
                  BQ: Number of days before this table is set as expired and deleted. Never by default.
                  "%
                  | optional,
                dynamicPartitionOverwrite
                  | Bool
                  | doc m%"
                  When outputting files, should we overwrite existing partitions ?
                  "%
                  | optional,
                enableRefresh
                  | Bool
                  | doc m%"
                  BQ: Enable automatic refresh of materialized view ? false by default.
                  "%
                  | optional,
                extension
                  | String
                  | doc m%"
                  FS: File extension
                  "%
                  | optional,
                format
                  | String
                  | doc m%"
                  FS: File format
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  ES: Attribute to use as id of the document. Generated by Elasticsearch if not specified.
                  "%
                  | optional,
                location
                  | String
                  | doc m%"
                  BQ: Database location (EU, US, ...)
                  "%
                  | optional,
                materializedView
                  | Bool
                  | doc m%"
                  BQ: Should we materialize as a table or as a view when saving the results ? false by default.
                  "%
                  | optional,
                options
                  | definitions.contract.MapString
                  | doc m%"
                  spark  options to use
                  "%
                  | optional,
                partition
                  | definitions.contract.Partition
                  | doc m%"
                  FS or BQ: List of partition attributes
                  "%
                  | optional,
                refreshIntervalMs
                  | Number
                  | doc m%"
                  BQ: Refresh interval in milliseconds. Default to BigQuery default value
                  "%
                  | optional,
                requirePartitionFilter
                  | Bool
                  | doc m%"
                  BQ: Should be require a partition filter on every request ? No by default.
                  "%
                  | optional,
                timestamp
                  | String
                  | doc m%"
                  ES or BQ: The timestamp column to use for table partitioning if any. No partitioning by default\nES:Timestamp field format as expected by Elasticsearch ("{beginTs|yyyy.MM.dd}" for example).
                  "%
                  | optional,
                ..
              },
          Table = {
                acl
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.AccessControlEntry
                  ])
                  | doc m%"
                  Map of rolename -> List[Users].
                  "%
                  | optional,
                attributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Attribute
                  ])
                  | doc m%"
                  Attributes parsing rules.
                  "%
                  | optional,
                comment
                  | String
                  | doc m%"
                  free text
                  "%
                  | optional,
                expectations
                  | definitions.contract.MapString
                  | doc m%"
                  Expectations to check after Load / Transform has succeeded
                  "%
                  | optional,
                filter
                  | String
                  | doc m%"
                  remove all records that do not match this condition
                  "%
                  | optional,
                "merge" | definitions.contract.MergeOptions | optional,
                metadata
                  | definitions.contract.Metadata
                  | doc m%"
                  Dataset metadata
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Schema name, must be unique among all the schemas belonging to the same domain.
                    *                     Will become the hive table name On Premise or BigQuery Table name on GCP.
                  "%,
                pattern
                  | String
                  | doc m%"
                  filename pattern to which this schema must be applied.
                    *                     This instructs the framework to use this schema to parse any file with a filename that match this pattern.
                  "%,
                patternSample
                  | String
                  | doc m%"
                  Sample of filename matching this schema
                  "%
                  | optional,
                postsql
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Reserved for future use.
                  "%
                  | optional,
                presql
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Reserved for future use.
                  "%
                  | optional,
                primaryKey
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of columns that make up the primary key
                  "%
                  | optional,
                rename
                  | String
                  | doc m%"
                  If present, the table is renamed with this name. Useful when use in conjunction with the 'extract' module
                  "%
                  | optional,
                rls
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.RowLevelSecurity
                  ])
                  | doc m%"
                   Row level security on this schema.
                  "%
                  | optional,
                sample
                  | String
                  | doc m%"
                  Store here a couple of records illustrating the table data.
                  "%
                  | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Set of string to attach to this Schema
                  "%
                  | optional,
                ..
              },
          TableDdl
            | doc m%"
            DDL used to create a table
            "%
            = {
                createSql
                  | String
                  | doc m%"
                  SQL CREATE DDL statement
                  "%,
                pingSql
                  | String
                  | doc m%"
                  How to test if the table exist.
                  Use the following statement by default: 'select count(*) from tableName where 1=0'
                  "%
                  | optional,
                ..
              },
          TableType
            | doc m%"
            Table types supported by the Extract module
            "%
            = predicates.contract_from_predicate
              definitions.predicate.TableType,
          Trim
            | doc m%"
            How to trim the input string
            "%
            = predicates.contract_from_predicate definitions.predicate.Trim,
          Type
            | doc m%"
            Custom type definition. Custom types are defined in the types/types.sl.yml file
            "%
            = {
                comment
                  | String
                  | doc m%"
                  Describes this type
                  "%
                  | optional,
                ddlMapping
                  | definitions.contract.MapString
                  | doc m%"
                  Configure here the type mapping for each datawarehouse.\nWill be used when inferring DDL from schema.
                  "%
                  | optional,
                indexMapping
                  | String
                  | doc m%"
                  How this type is indexed in your datawarehouse
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  unique id for this type
                  "%,
                pattern
                  | String
                  | doc m%"
                  Regex used to validate the input field
                  "%,
                primitiveType
                  | definitions.contract.PrimitiveType
                  | doc m%"
                  To what primitive type should this type be mapped.
                   This is the memory representation of the type, When saving, this primitive type is mapped to the database specific type  
                  "%,
                sample
                  | String
                  | doc m%"
                  This field makes sure that the pattern matches the value you want to match. This will be checked on startup
                  "%
                  | optional,
                zone
                  | String
                  | doc m%"
                  useful when parsing specific string:
                   - double: To parse a french decimal (comma as decimal separator) set it to fr_FR locale.
                  - decimal: to set the precision and scale of this number, '38,9' by default.
                  - 
                  "%
                  | optional,
                ..
              },
          UserType
            | doc m%"
            User types defined in starlake. Used as a prefix in row level and column level security policies
            "%
            = predicates.contract_from_predicate definitions.predicate.UserType,
          WriteMode
            | doc m%"
            How the data is written to the target datawarehouse. Default is APPEND
            "%
            = predicates.contract_from_predicate
              definitions.predicate.WriteMode,
        },
    predicate = {
          AccessControlEntry
            | doc m%"
            Column level security policy to apply to the attribute.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "grants", "role" ],
                predicates.records.record
                {
                  grants = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  role = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          AccessPolicies = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apply = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  location = predicates.isType '"String",
                  taxonomy = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Application = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessPolicies = definitions.predicate.AccessPolicies,
                  analyze = predicates.isType '"Bool",
                  archive = predicates.isType '"Bool",
                  area = definitions.predicate.Area,
                  audit = definitions.predicate.Audit,
                  connectionRef = predicates.isType '"String",
                  connections = definitions.predicate.MapConnection,
                  csvOutput = predicates.isType '"Bool",
                  csvOutputExt = predicates.isType '"String",
                  dags = predicates.isType '"String",
                  database = predicates.isType '"String",
                  datasets = predicates.isType '"String",
                  defaultAuditWriteFormat = predicates.isType '"String",
                  defaultFormat = predicates.isType '"String",
                  defaultRejectedWriteFormat = predicates.isType '"String",
                  dsvOptions = definitions.predicate.MapString,
                  emptyIsNull = predicates.isType '"Bool",
                  env = predicates.isType '"String",
                  expectations = definitions.predicate.ExpectationsConfig,
                  forceDomainPattern = predicates.isType '"String",
                  forceJobPattern = predicates.isType '"String",
                  forceTablePattern = predicates.isType '"String",
                  forceTaskPattern = predicates.isType '"String",
                  forceViewPattern = predicates.isType '"String",
                  grouped = predicates.isType '"Bool",
                  groupedMax = predicates.isType 'Integer,
                  hadoop = definitions.predicate.MapString,
                  hive = predicates.isType '"Bool",
                  internal = definitions.predicate.Internal,
                  jdbcEngines = definitions.predicate.MapJdbcEngine,
                  loadStrategyClass = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "ai.starlake.job.load.IngestionNameStrategy",
                          "ai.starlake.job.load.IngestionTimeStrategy"
                        ]
                      ],
                  loader = predicates.isType '"String",
                  lock = definitions.predicate.Lock,
                  maxParCopy = predicates.isType 'Integer,
                  maxParTask = predicates.isType 'Integer,
                  mergeForceDistinct = predicates.isType '"Bool",
                  mergeOptimizePartitionWrite = predicates.isType '"Bool",
                  metadata = predicates.isType '"String",
                  metrics = definitions.predicate.Metrics,
                  privacy = definitions.predicate.Privacy,
                  privacyOnly = predicates.isType '"Bool",
                  rejectAllOnError = predicates.isType '"String",
                  rejectMaxRecords = predicates.isType 'Integer,
                  root = predicates.isType '"String",
                  rowValidatorClass = predicates.isType '"String",
                  schedulePresets = definitions.predicate.MapString,
                  scheduling = definitions.predicate.JobScheduling,
                  sessionDurationServe = predicates.isType 'Integer,
                  sinkReplayToFile = predicates.isType '"Bool",
                  sqlParameterPattern = predicates.isType '"String",
                  tenant = predicates.isType '"String",
                  treeValidatorClass = predicates.isType '"String",
                  udfs = predicates.isType '"String",
                  useLocalFileSystem = predicates.isType '"String",
                  validateOnLoad = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          Area = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accepted = predicates.isType '"String",
                  archive = predicates.isType '"String",
                  business = predicates.isType '"String",
                  hiveDatabase = predicates.isType '"String",
                  ingesting = predicates.isType '"String",
                  pending = predicates.isType '"String",
                  rejected = predicates.isType '"String",
                  replay = predicates.isType '"String",
                  unresolved = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Attribute = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "type" ],
                predicates.records.record
                {
                  accessPolicy = predicates.isType '"String",
                  array = predicates.isType '"Bool",
                  attributes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Attribute
                      ],
                  comment = predicates.isType '"String",
                  "default" = predicates.isType '"String",
                  foreignKey = predicates.isType '"String",
                  ignore = predicates.isType '"Bool",
                  metricType = predicates.isType '"String",
                  name = predicates.isType '"String",
                  position = definitions.predicate.Position,
                  privacy = predicates.isType '"String",
                  rename = predicates.isType '"String",
                  required = predicates.isType '"Bool",
                  script = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  trim = definitions.predicate.Trim,
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          AttributeDesc = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "comment", "name" ],
                predicates.records.record
                {
                  accessPolicy = predicates.isType '"String",
                  comment = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Audit = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  domain = predicates.isType '"String",
                  maxErrors = predicates.isType '"String",
                  path = predicates.isType '"String",
                  sink = definitions.predicate.Sink,
                }
                {  }
                true
                predicates.always
              ],
          AutoJobDesc = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  comment = predicates.isType '"String",
                  "default" = definitions.predicate.AutoTaskDesc,
                  name = predicates.isType '"String",
                  tasks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.AutoTaskDesc
                      ],
                }
                {  }
                true
                predicates.always
              ],
          AutoTaskDesc = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  acl = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.AccessControlEntry
                      ],
                  attributesDesc = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.AttributeDesc
                      ],
                  comment = predicates.isType '"String",
                  dagRef = predicates.isType '"String",
                  database = predicates.isType '"String",
                  domain = predicates.isType '"String",
                  expectations = definitions.predicate.MapString,
                  freshness = definitions.predicate.Freshness,
                  "merge" = definitions.predicate.MergeOptions,
                  partition = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  postsql = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  presql = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  python = predicates.isType '"String",
                  rls = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.RowLevelSecurity
                      ],
                  schedule = predicates.isType '"String",
                  sink = definitions.predicate.Sink,
                  sql = predicates.isType '"String",
                  table = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  write = definitions.predicate.WriteMode,
                }
                {  }
                true
                predicates.always
              ],
          Connection
            | doc m%"
            Connection properties to a datawarehouse.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  options = definitions.predicate.MapString,
                  sparkFormat = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          DagGenerationConfig
            | doc m%"
            Dag configuration.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  comment = predicates.isType '"String",
                  filnename = predicates.isType '"String",
                  options = definitions.predicate.MapString,
                  template = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Domain
            | doc m%"
            A schema in JDBC database or a folder in HDFS or a dataset in BigQuery.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  comment = predicates.isType '"String",
                  database = predicates.isType '"String",
                  metadata = definitions.predicate.Metadata,
                  name = predicates.isType '"String",
                  rename = predicates.isType '"String",
                  tables = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Table
                      ],
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          ExpectationItem
            | doc m%"
            Expectation
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "expect", "query" ],
                predicates.records.record
                {
                  expect = predicates.isType '"String",
                  query = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          ExpectationsConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = predicates.isType '"Bool",
                  failOnError = predicates.isType '"Bool",
                  path = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          External = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  database = predicates.isType '"String",
                  external = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ExternalDomain
                      ],
                }
                {  }
                true
                predicates.always
              ],
          ExternalDomain = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  tables = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Format
            | doc m%"
            DSV by default. Supported file formats are :\n- DSV : Delimiter-separated values file. Delimiter value is specified in the "separator" field.\n- POSITION : FIXED format file where values are located at an exact position in each line.\n- SIMPLE_JSON : For optimisation purpose, we differentiate JSON with top level values from JSON\n  with deep level fields. SIMPLE_JSON are JSON files with top level fields only.\n- JSON :  Deep JSON file. Use only when your json documents contain sub-documents, otherwise prefer to\n  use SIMPLE_JSON since it is much faster.\n- XML : XML files
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.oneOf
                [
                  predicates.const "DSV",
                  predicates.const "POSITION",
                  predicates.const "JSON",
                  predicates.const "ARRAY_JSON",
                  predicates.const "SIMPLE_JSON",
                  predicates.const "XML"
                ]
              ],
          Freshness = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  error = predicates.isType '"String",
                  warn = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          IndexMapping = predicates.allOf
              [
                predicates.isType '"String",
                predicates.oneOf
                [
                  predicates.const "text",
                  predicates.const "keyword",
                  predicates.const "long",
                  predicates.const "integer",
                  predicates.const "short",
                  predicates.const "byte",
                  predicates.const "double",
                  predicates.const "float",
                  predicates.const "half_float",
                  predicates.const "scaled_float",
                  predicates.const "date",
                  predicates.const "boolean",
                  predicates.const "binary",
                  predicates.const "integer_rang",
                  predicates.const "float_range",
                  predicates.const "long_range",
                  predicates.const "double_range",
                  predicates.const "date_range",
                  predicates.const "geo_point",
                  predicates.const "geo_shape",
                  predicates.const "ip",
                  predicates.const "completion",
                  predicates.const "token_count",
                  predicates.const "object",
                  predicates.const "array"
                ]
              ],
          Internal
            | doc m%"
            configure Spark internal options
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cacheStorageLevel = predicates.isType '"String",
                  intermediateBigqueryFormat = predicates.isType '"String",
                  substituteVars = predicates.isType '"Bool",
                  temporaryGcsBucket = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          JDBCSchema = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  catalog = predicates.isType '"String",
                  columnRemarks = predicates.isType '"String",
                  connectionOptions = predicates.isType '"String",
                  fetchSize = predicates.isType 'Integer,
                  fullExport = predicates.isType '"Bool",
                  numPartitions = predicates.isType 'Integer,
                  numericTrim = definitions.predicate.Trim,
                  partitionColumn = predicates.isType '"String",
                  pattern = predicates.isType '"String",
                  schema = predicates.isType '"String",
                  stringPartitionFunc = predicates.isType '"String",
                  tableRemarks = predicates.isType '"String",
                  tableTypes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  tables = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.JDBCTable
                      ],
                  template = predicates.isType '"String",
                  write = definitions.predicate.WriteMode,
                }
                {  }
                true
                predicates.always
              ],
          JDBCSchemas = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  connection = definitions.predicate.MapString,
                  connectionRef = predicates.isType '"String",
                  "default" = definitions.predicate.JDBCSchema,
                  fetchSize = predicates.isType 'Integer,
                  jdbcSchemas = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.JDBCSchema
                      ],
                }
                {  }
                true
                predicates.always
              ],
          JDBCTable = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  columns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  connectionOptions = predicates.isType '"String",
                  fetchSize = predicates.isType 'Integer,
                  fullExport = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  numPartitions = predicates.isType 'Integer,
                  partitionColumn = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          JdbcEngine
            | doc m%"
            Jdbc engine
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  tables = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.MapTableDdl
                      ],
                }
                {  }
                true
                predicates.always
              ],
          JobScheduling = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  file = predicates.isType '"String",
                  maxJobs = predicates.isType 'Integer,
                  mode = predicates.isType '"String",
                  poolName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Lock = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  pollTime = predicates.isType '"String",
                  refreshTime = predicates.isType '"String",
                  timeout = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          MapArrayOfString = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ])
              ],
          MapConnection
            | doc m%"
            Map of connections
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                definitions.predicate.Connection
              ],
          MapExpectationItem
            | doc m%"
            Map of connections
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                definitions.predicate.ExpectationItem
              ],
          MapJdbcEngine
            | doc m%"
            Map of jdbc engines
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                definitions.predicate.JdbcEngine
              ],
          MapString
            | doc m%"
            Map of string
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          MapTableDdl
            | doc m%"
            Map of table ddl
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                definitions.predicate.TableDdl
              ],
          MergeOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key" ],
                predicates.records.record
                {
                  key = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  queryFilter = predicates.isType '"String",
                  timestamp = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Metadata = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ack = predicates.isType '"String",
                  array = predicates.isType '"Bool",
                  dagRef = predicates.isType '"String",
                  directory = predicates.isType '"String",
                  emptyIsNull = predicates.isType '"Bool",
                  encoding = predicates.isType '"String",
                  escape = predicates.isType '"String",
                  extensions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  format = definitions.predicate.Format,
                  freshness = definitions.predicate.Freshness,
                  ignore = predicates.isType '"String",
                  loader = predicates.isType '"String",
                  multiline = predicates.isType '"Bool",
                  nullValue = predicates.isType '"String",
                  options = definitions.predicate.MapString,
                  partition = definitions.predicate.Partition,
                  quote = predicates.isType '"String",
                  schedule = predicates.isType '"String",
                  separator = predicates.isType '"String",
                  sink = definitions.predicate.Sink,
                  withHeader = predicates.isType '"Bool",
                  write = definitions.predicate.WriteMode,
                  xml = definitions.predicate.MapString,
                }
                {  }
                true
                predicates.always
              ],
          Metrics = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = predicates.isType '"Bool",
                  discreteMaxCardinality = predicates.isType 'Integer,
                  path = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Partition
            | doc m%"
            Partition columns, no partitioning by default
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  attributes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  sampling = predicates.isType '"Number",
                }
                {  }
                true
                predicates.always
              ],
          Position
            | doc m%"
            First and last char positions of an attribute in a fixed length record
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "first", "last" ],
                predicates.records.record
                {
                  first = predicates.isType '"Number",
                  last = predicates.isType '"Number",
                }
                {  }
                true
                predicates.always
              ],
          PrimitiveType
            | doc m%"
            Default types defined in starlake. User defined types may also be defined in the types/types.sl.yml file
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.oneOf
                [
                  predicates.const "string",
                  predicates.const "long",
                  predicates.const "int",
                  predicates.const "short",
                  predicates.const "double",
                  predicates.const "boolean",
                  predicates.const "byte",
                  predicates.const "date",
                  predicates.const "basic_iso_date",
                  predicates.const "iso_local_date",
                  predicates.const "iso_offset_date",
                  predicates.const "iso_date",
                  predicates.const "iso_local_date_time",
                  predicates.const "iso_offset_date_time",
                  predicates.const "iso_zoned_date_time",
                  predicates.const "iso_date_time",
                  predicates.const "iso_ordinal_date",
                  predicates.const "iso_week_date",
                  predicates.const "iso_instant",
                  predicates.const "rfc_1123_date_time",
                  predicates.const "timestamp",
                  predicates.const "decimal",
                  predicates.const "struct"
                ]
              ],
          Privacy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { options = definitions.predicate.MapString, }
                {  }
                true
                predicates.always
              ],
          Ref
            | doc m%"
            Describe how to resolve a reference in a transform task
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "input", "output" ],
                predicates.records.record
                {
                  input = definitions.predicate.RefInput,
                  output = definitions.predicate.RefOutput,
                }
                {  }
                true
                predicates.always
              ],
          RefInput
            | doc m%"
            Input for ref object
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "table" ],
                predicates.records.record
                {
                  database = predicates.isType '"String",
                  domain = predicates.isType '"String",
                  table = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          RefOutput
            | doc m%"
            Output for ref object
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "database", "domain", "table" ],
                predicates.records.record
                {
                  database = predicates.isType '"String",
                  domain = predicates.isType '"String",
                  table = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Refs = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.Ref
              ],
          RowLevelSecurity
            | doc m%"
            Row level security policy to apply to the output data.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "grants", "name" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  grants = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                  predicate = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Sink = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clustering = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  coalesce = predicates.isType '"Bool",
                  connectionRef = predicates.isType '"String",
                  days = predicates.isType '"Number",
                  dynamicPartitionOverwrite = predicates.isType '"Bool",
                  enableRefresh = predicates.isType '"Bool",
                  extension = predicates.isType '"String",
                  format = predicates.isType '"String",
                  id = predicates.isType '"String",
                  location = predicates.isType '"String",
                  materializedView = predicates.isType '"Bool",
                  options = definitions.predicate.MapString,
                  partition = definitions.predicate.Partition,
                  refreshIntervalMs = predicates.isType '"Number",
                  requirePartitionFilter = predicates.isType '"Bool",
                  timestamp = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Table = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "pattern" ],
                predicates.records.record
                {
                  acl = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.AccessControlEntry
                      ],
                  attributes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Attribute
                      ],
                  comment = predicates.isType '"String",
                  expectations = definitions.predicate.MapString,
                  filter = predicates.isType '"String",
                  "merge" = definitions.predicate.MergeOptions,
                  metadata = definitions.predicate.Metadata,
                  name = predicates.isType '"String",
                  pattern = predicates.isType '"String",
                  patternSample = predicates.isType '"String",
                  postsql = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  presql = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  primaryKey = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  rename = predicates.isType '"String",
                  rls = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.RowLevelSecurity
                      ],
                  sample = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          TableDdl
            | doc m%"
            DDL used to create a table
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "createSql" ],
                predicates.records.record
                {
                  createSql = predicates.isType '"String",
                  pingSql = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          TableType
            | doc m%"
            Table types supported by the Extract module
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.oneOf
                [
                  predicates.const "TABLE",
                  predicates.const "VIEW",
                  predicates.const "SYSTEM TABLE",
                  predicates.const "GLOBAL TEMPORARY",
                  predicates.const "LOCAL TEMPORARY",
                  predicates.const "ALIAS",
                  predicates.const "SYNONYM"
                ]
              ],
          Trim
            | doc m%"
            How to trim the input string
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.oneOf
                [
                  predicates.const "LEFT",
                  predicates.const "RIGHT",
                  predicates.const "BOTH",
                  predicates.const "NONE"
                ]
              ],
          Type
            | doc m%"
            Custom type definition. Custom types are defined in the types/types.sl.yml file
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "name", "pattern", "primitiveType" ],
                predicates.records.record
                {
                  comment = predicates.isType '"String",
                  ddlMapping = definitions.predicate.MapString,
                  indexMapping = predicates.isType '"String",
                  name = predicates.isType '"String",
                  pattern = predicates.isType '"String",
                  primitiveType = definitions.predicate.PrimitiveType,
                  sample = predicates.isType '"String",
                  zone = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          UserType
            | doc m%"
            User types defined in starlake. Used as a prefix in row level and column level security policies
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.oneOf
                [
                  predicates.const "SA",
                  predicates.const "USER",
                  predicates.const "GROUP"
                ]
              ],
          WriteMode
            | doc m%"
            How the data is written to the target datawarehouse. Default is APPEND
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.oneOf
                [
                  predicates.const "OVERWRITE",
                  predicates.const "APPEND",
                  predicates.const "ERROR_IF_EXISTS",
                  predicates.const "IGNORE"
                ]
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.oneOf
  [
    predicates.allOf
    [
      predicates.records.required [ "extract" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "load" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "transform" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "expectations" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "env" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "types" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "tables" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "table" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "task" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "connections" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "external" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "application" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "refs" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "dag" ],
      predicates.records.record {  } {  } true predicates.always
    ]
  ],
  predicates.records.record
  {
    application = definitions.predicate.Application,
    dag = definitions.predicate.DagGenerationConfig,
    env = definitions.predicate.MapString,
    expectations = definitions.predicate.MapExpectationItem,
    external = definitions.predicate.External,
    extract = definitions.predicate.JDBCSchemas,
    load = definitions.predicate.Domain,
    refs = definitions.predicate.Refs,
    table = definitions.predicate.Table,
    task = definitions.predicate.AutoTaskDesc,
    transform = definitions.predicate.AutoJobDesc,
    types = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.Type
        ],
  }
  {  }
  true
  predicates.always
])