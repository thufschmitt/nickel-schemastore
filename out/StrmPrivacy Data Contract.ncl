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
          "google.protobuf.Timestamp" = String,
          "strmprivacy.api.entities.v1.DataContract" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.DataContract",
          "strmprivacy.api.entities.v1.DataContract.State" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.DataContract.State",
          "strmprivacy.api.entities.v1.DataContractMetadata" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.DataContractMetadata",
          "strmprivacy.api.entities.v1.DataContractRef" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.DataContractRef",
          "strmprivacy.api.entities.v1.FieldMetadata" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata",
          "strmprivacy.api.entities.v1.FieldMetadata.NullHandlingConfig" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata.NullHandlingConfig",
          "strmprivacy.api.entities.v1.FieldMetadata.NullHandlingConfig.NullHandlingType" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata.NullHandlingConfig.NullHandlingType",
          "strmprivacy.api.entities.v1.FieldMetadata.PersonalDataConfig" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata.PersonalDataConfig",
          "strmprivacy.api.entities.v1.Label" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.Label",
          "strmprivacy.api.entities.v1.Schema" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.Schema",
          "strmprivacy.api.entities.v1.Schema.SimpleSchemaDefinition"
            | doc m%"
            constraints: overall size < 100000 TBD
            "%
            = predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.Schema.SimpleSchemaDefinition",
          "strmprivacy.api.entities.v1.Schema.State" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.Schema.State",
          "strmprivacy.api.entities.v1.SchemaMetadata" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.SchemaMetadata",
          "strmprivacy.api.entities.v1.SchemaRef" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.SchemaRef",
          "strmprivacy.api.entities.v1.SchemaType" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.SchemaType",
          "strmprivacy.api.entities.v1.SimpleSchemaNode" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.SimpleSchemaNode",
          "strmprivacy.api.entities.v1.SimpleSchemaNodeType" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.SimpleSchemaNodeType",
          "strmprivacy.api.entities.v1.StatisticalDataType" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.StatisticalDataType",
          "strmprivacy.api.entities.v1.Validation" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.Validation",
        },
    predicate = {
          "google.protobuf.Timestamp" = predicates.isType '"String",
          "strmprivacy.api.entities.v1.DataContract" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  creatorExternalUserId =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/creator_external_user_id",
                  dataSubjectField =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/data_subject_field",
                  fieldMetadata =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/field_metadata",
                  id =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/id",
                  isPublic =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/is_public",
                  keyField =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/key_field",
                  metadata =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/metadata",
                  piiFields =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/pii_fields",
                  projectId =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/project_id",
                  ref =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/ref",
                  schema =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/schema",
                  state =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/state",
                  validations =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/validations",
                }
                {
                  "^creator_external_user_id$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/creator_external_user_id",
                  "^data_subject_field$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/data_subject_field",
                  "^field_metadata$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/field_metadata",
                  "^is_public$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/is_public",
                  "^key_field$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/key_field",
                  "^pii_fields$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/pii_fields",
                  "^project_id$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContract/definitions/project_id",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.DataContract.State" = predicates.enum
              [
                "STATE_UNSPECIFIED",
                0,
                "DRAFT",
                1,
                "IN_REVIEW",
                2,
                "ACTIVE",
                3,
                "ARCHIVED",
                4,
                "INCOMPLETE",
                5,
                "APPROVED",
                6
              ],
          "strmprivacy.api.entities.v1.DataContractMetadata" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  createTime =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContractMetadata/definitions/create_time",
                  description =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContractMetadata/definitions/description",
                  domains =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContractMetadata/definitions/domains",
                  industries =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContractMetadata/definitions/industries",
                  labels =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContractMetadata/definitions/labels",
                  title =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContractMetadata/definitions/title",
                }
                {
                  "^create_time$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContractMetadata/definitions/create_time",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.DataContractRef" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  handle =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContractRef/definitions/handle",
                  name =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContractRef/definitions/name",
                  version =
                    definitions.predicate."strmprivacy.api.entities.v1.DataContractRef/definitions/version",
                }
                {  }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.FieldMetadata" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fieldName =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata/definitions/field_name",
                  nullHandlingConfig =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata/definitions/null_handling_config",
                  ordinalValues =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata/definitions/ordinal_values",
                  personalDataConfig =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata/definitions/personal_data_config",
                  statisticalDataType =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata/definitions/statistical_data_type",
                }
                {
                  "^field_name$" =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata/definitions/field_name",
                  "^null_handling_config$" =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata/definitions/null_handling_config",
                  "^ordinal_values$" =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata/definitions/ordinal_values",
                  "^personal_data_config$" =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata/definitions/personal_data_config",
                  "^statistical_data_type$" =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata/definitions/statistical_data_type",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.FieldMetadata.NullHandlingConfig" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultValue =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata.NullHandlingConfig/definitions/default_value",
                  type =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata.NullHandlingConfig/definitions/type",
                }
                {
                  "^default_value$" =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata.NullHandlingConfig/definitions/default_value",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.FieldMetadata.NullHandlingConfig.NullHandlingType" =
            predicates.enum
              [
                "NULL_HANDLING_TYPE_UNSPECIFIED",
                0,
                "DROP_RECORD",
                1,
                "DEFAULT_VALUE",
                2
              ],
          "strmprivacy.api.entities.v1.FieldMetadata.PersonalDataConfig" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  gdprSpecialPersonalDataType =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata.PersonalDataConfig/definitions/gdpr_special_personal_data_type",
                  isPii =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata.PersonalDataConfig/definitions/is_pii",
                  isQuasiId =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata.PersonalDataConfig/definitions/is_quasi_id",
                  purposeLevel =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata.PersonalDataConfig/definitions/purpose_level",
                }
                {
                  "^gdpr_special_personal_data_type$" =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata.PersonalDataConfig/definitions/gdpr_special_personal_data_type",
                  "^is_pii$" =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata.PersonalDataConfig/definitions/is_pii",
                  "^is_quasi_id$" =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata.PersonalDataConfig/definitions/is_quasi_id",
                  "^purpose_level$" =
                    definitions.predicate."strmprivacy.api.entities.v1.FieldMetadata.PersonalDataConfig/definitions/purpose_level",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.Label" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  key =
                    definitions.predicate."strmprivacy.api.entities.v1.Label/definitions/key",
                  value =
                    definitions.predicate."strmprivacy.api.entities.v1.Label/definitions/value",
                }
                {  }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.Schema" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  definition =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema/definitions/definition",
                  fingerprint =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema/definitions/fingerprint",
                  id =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema/definitions/id",
                  isPublic =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema/definitions/is_public",
                  metadata =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema/definitions/metadata",
                  ref =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema/definitions/ref",
                  simpleSchema =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema/definitions/simple_schema",
                  state =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema/definitions/state",
                }
                {
                  "^is_public$" =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema/definitions/is_public",
                  "^simple_schema$" =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema/definitions/simple_schema",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.Schema.SimpleSchemaDefinition"
            | doc m%"
            constraints: overall size < 100000 TBD
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  avroName =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema.SimpleSchemaDefinition/definitions/avro_name",
                  "doc" =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema.SimpleSchemaDefinition/definitions/doc",
                  name =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema.SimpleSchemaDefinition/definitions/name",
                  namespace =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema.SimpleSchemaDefinition/definitions/namespace",
                  nodes =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema.SimpleSchemaDefinition/definitions/nodes",
                }
                {
                  "^avro_name$" =
                    definitions.predicate."strmprivacy.api.entities.v1.Schema.SimpleSchemaDefinition/definitions/avro_name",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.Schema.State" = predicates.enum
              [
                "STATE_UNSPECIFIED",
                0,
                "DRAFT",
                1,
                "ACTIVE",
                2,
                "ARCHIVED",
                3,
                "IN_REVIEW",
                4,
                "INCOMPLETE",
                5,
                "APPROVED",
                6
              ],
          "strmprivacy.api.entities.v1.SchemaMetadata" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  createTime =
                    definitions.predicate."strmprivacy.api.entities.v1.SchemaMetadata/definitions/create_time",
                  description =
                    definitions.predicate."strmprivacy.api.entities.v1.SchemaMetadata/definitions/description",
                  domains =
                    definitions.predicate."strmprivacy.api.entities.v1.SchemaMetadata/definitions/domains",
                  iconUri =
                    definitions.predicate."strmprivacy.api.entities.v1.SchemaMetadata/definitions/icon_uri",
                  industries =
                    definitions.predicate."strmprivacy.api.entities.v1.SchemaMetadata/definitions/industries",
                  labels =
                    definitions.predicate."strmprivacy.api.entities.v1.SchemaMetadata/definitions/labels",
                  title =
                    definitions.predicate."strmprivacy.api.entities.v1.SchemaMetadata/definitions/title",
                }
                {
                  "^create_time$" =
                    definitions.predicate."strmprivacy.api.entities.v1.SchemaMetadata/definitions/create_time",
                  "^icon_uri$" =
                    definitions.predicate."strmprivacy.api.entities.v1.SchemaMetadata/definitions/icon_uri",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.SchemaRef" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  handle =
                    definitions.predicate."strmprivacy.api.entities.v1.SchemaRef/definitions/handle",
                  name =
                    definitions.predicate."strmprivacy.api.entities.v1.SchemaRef/definitions/name",
                  schemaType =
                    definitions.predicate."strmprivacy.api.entities.v1.SchemaRef/definitions/schema_type",
                  version =
                    definitions.predicate."strmprivacy.api.entities.v1.SchemaRef/definitions/version",
                }
                {
                  "^schema_type$" =
                    definitions.predicate."strmprivacy.api.entities.v1.SchemaRef/definitions/schema_type",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.SchemaType" = predicates.enum
              [ "SCHEMA_TYPE_UNSPECIFIED", 0, "AVRO", 1, "JSONSCHEMA", 2 ],
          "strmprivacy.api.entities.v1.SimpleSchemaNode" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  avroName =
                    definitions.predicate."strmprivacy.api.entities.v1.SimpleSchemaNode/definitions/avro_name",
                  "doc" =
                    definitions.predicate."strmprivacy.api.entities.v1.SimpleSchemaNode/definitions/doc",
                  name =
                    definitions.predicate."strmprivacy.api.entities.v1.SimpleSchemaNode/definitions/name",
                  nodes =
                    definitions.predicate."strmprivacy.api.entities.v1.SimpleSchemaNode/definitions/nodes",
                  repeated =
                    definitions.predicate."strmprivacy.api.entities.v1.SimpleSchemaNode/definitions/repeated",
                  required =
                    definitions.predicate."strmprivacy.api.entities.v1.SimpleSchemaNode/definitions/required",
                  type =
                    definitions.predicate."strmprivacy.api.entities.v1.SimpleSchemaNode/definitions/type",
                }
                {
                  "^avro_name$" =
                    definitions.predicate."strmprivacy.api.entities.v1.SimpleSchemaNode/definitions/avro_name",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.SimpleSchemaNodeType" = predicates.enum
              [
                "SIMPLE_SCHEMA_NODE_TYPE_UNSPECIFIED",
                0,
                "STRING",
                1,
                "BOOLEAN",
                2,
                "FLOAT",
                3,
                "INTEGER",
                4,
                "LONG",
                5,
                "NODE",
                10
              ],
          "strmprivacy.api.entities.v1.StatisticalDataType" = predicates.enum
              [
                "STATISTICAL_DATA_TYPE_UNSPECIFIED",
                0,
                "NOMINAL",
                1,
                "ORDINAL",
                2,
                "NUMERICAL",
                3
              ],
          "strmprivacy.api.entities.v1.Validation" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  field =
                    definitions.predicate."strmprivacy.api.entities.v1.Validation/definitions/field",
                  type =
                    definitions.predicate."strmprivacy.api.entities.v1.Validation/definitions/type",
                  value =
                    definitions.predicate."strmprivacy.api.entities.v1.Validation/definitions/value",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

definitions.contract."strmprivacy.api.entities.v1.DataContract"