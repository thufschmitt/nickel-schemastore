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
          "google.type.TimeZone"
            | doc m%"
            Represents a time zone from the
             [IANA Time Zone Database](https://www.iana.org/time-zones).
            "%
            = predicates.contract_from_predicate
              definitions.predicate."google.type.TimeZone",
          "strmprivacy.api.entities.v1.BatchJob"
            | doc m%"
            ********************************
            Batch Jobs
            Currently we only support:
            - CSV as DataFormat type
            - a clean database for every batch job
            - CSV files with a header row, because the header is needed to get the field names
            *******************************
            "%
            = predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.BatchJob",
          "strmprivacy.api.entities.v1.BatchJobRef" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.BatchJobRef",
          "strmprivacy.api.entities.v1.BatchJobState" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.BatchJobState",
          "strmprivacy.api.entities.v1.BatchJobStateType" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.BatchJobStateType",
          "strmprivacy.api.entities.v1.ConsentConfig" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.ConsentConfig",
          "strmprivacy.api.entities.v1.ConsentLevelExtractor" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.ConsentLevelExtractor",
          "strmprivacy.api.entities.v1.ConsentLevelType"
            | doc m%"
            Consent level is meant to interpret the consent-levels of an event for decryption purposes only.
            
            Cumulative means that the highest consent-level in an event must be greater than or equal to the single requested level
            for the decrypted stream.
            
            Granular means that the set of consent-levels in an event must enclose the set of requested event levels for the
            decrypted stream.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.ConsentLevelType",
          "strmprivacy.api.entities.v1.ConsentLevels" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.ConsentLevels",
          "strmprivacy.api.entities.v1.CsvConfig" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.CsvConfig",
          "strmprivacy.api.entities.v1.DataConnectorAndType" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.DataConnectorAndType",
          "strmprivacy.api.entities.v1.DataConnectorRef" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.DataConnectorRef",
          "strmprivacy.api.entities.v1.DataType" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.DataType",
          "strmprivacy.api.entities.v1.DatabaseConfig" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.DatabaseConfig",
          "strmprivacy.api.entities.v1.DerivedData" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.DerivedData",
          "strmprivacy.api.entities.v1.EncryptedData" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.EncryptedData",
          "strmprivacy.api.entities.v1.EncryptionConfig" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.EncryptionConfig",
          "strmprivacy.api.entities.v1.EncryptionKeysData" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.EncryptionKeysData",
          "strmprivacy.api.entities.v1.EventContractRef" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.EventContractRef",
          "strmprivacy.api.entities.v1.MaskedFields" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.MaskedFields",
          "strmprivacy.api.entities.v1.MaskedFields.PatternList" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.MaskedFields.PatternList",
          "strmprivacy.api.entities.v1.TimestampConfig" =
            predicates.contract_from_predicate
              definitions.predicate."strmprivacy.api.entities.v1.TimestampConfig",
        },
    predicate = {
          "google.protobuf.Timestamp" = predicates.isType '"String",
          "google.type.TimeZone"
            | doc m%"
            Represents a time zone from the
             [IANA Time Zone Database](https://www.iana.org/time-zones).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  id =
                    definitions.predicate."google.type.TimeZone/definitions/id",
                  version =
                    definitions.predicate."google.type.TimeZone/definitions/version",
                }
                {  }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.BatchJob"
            | doc m%"
            ********************************
            Batch Jobs
            Currently we only support:
            - CSV as DataFormat type
            - a clean database for every batch job
            - CSV files with a header row, because the header is needed to get the field names
            *******************************
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  consent =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/consent",
                  derivedData =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/derived_data",
                  encryptedData =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/encrypted_data",
                  encryption =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/encryption",
                  encryptionKeysData =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/encryption_keys_data",
                  eventContractRef =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/event_contract_ref",
                  policyId =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/policy_id",
                  ref =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/ref",
                  sourceData =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/source_data",
                  states =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/states",
                }
                {
                  "^derived_data$" =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/derived_data",
                  "^encrypted_data$" =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/encrypted_data",
                  "^encryption_keys_data$" =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/encryption_keys_data",
                  "^event_contract_ref$" =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/event_contract_ref",
                  "^policy_id$" =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/policy_id",
                  "^source_data$" =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJob/definitions/source_data",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.BatchJobRef" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  billingId =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJobRef/definitions/billing_id",
                  id =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJobRef/definitions/id",
                  projectId =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJobRef/definitions/project_id",
                }
                {
                  "^billing_id$" =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJobRef/definitions/billing_id",
                  "^project_id$" =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJobRef/definitions/project_id",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.BatchJobState" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  message =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJobState/definitions/message",
                  state =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJobState/definitions/state",
                  stateTime =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJobState/definitions/state_time",
                }
                {
                  "^state_time$" =
                    definitions.predicate."strmprivacy.api.entities.v1.BatchJobState/definitions/state_time",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.BatchJobStateType" = predicates.enum
              [
                "BATCH_JOB_STATE_TYPE_UNSPECIFIED",
                0,
                "PENDING",
                1,
                "STARTED",
                2,
                "ERROR_STARTING",
                3,
                "RUNNING",
                4,
                "FINISHED",
                5,
                "ERROR",
                6
              ],
          "strmprivacy.api.entities.v1.ConsentConfig" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  consentLevelExtractor =
                    definitions.predicate."strmprivacy.api.entities.v1.ConsentConfig/definitions/consent_level_extractor",
                  defaultConsentLevels =
                    definitions.predicate."strmprivacy.api.entities.v1.ConsentConfig/definitions/default_consent_levels",
                }
                {
                  "^consent_level_extractor$" =
                    definitions.predicate."strmprivacy.api.entities.v1.ConsentConfig/definitions/consent_level_extractor",
                  "^default_consent_levels$" =
                    definitions.predicate."strmprivacy.api.entities.v1.ConsentConfig/definitions/default_consent_levels",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.ConsentLevelExtractor" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  field =
                    definitions.predicate."strmprivacy.api.entities.v1.ConsentLevelExtractor/definitions/field",
                  fieldPatterns =
                    definitions.predicate."strmprivacy.api.entities.v1.ConsentLevelExtractor/definitions/field_patterns",
                }
                {
                  "^field_patterns$" =
                    definitions.predicate."strmprivacy.api.entities.v1.ConsentLevelExtractor/definitions/field_patterns",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.ConsentLevelType"
            | doc m%"
            Consent level is meant to interpret the consent-levels of an event for decryption purposes only.
            
            Cumulative means that the highest consent-level in an event must be greater than or equal to the single requested level
            for the decrypted stream.
            
            Granular means that the set of consent-levels in an event must enclose the set of requested event levels for the
            decrypted stream.
            "%
            = predicates.enum
              [
                "CONSENT_LEVEL_TYPE_UNSPECIFIED",
                0,
                "CUMULATIVE",
                1,
                "GRANULAR",
                2
              ],
          "strmprivacy.api.entities.v1.ConsentLevels" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  consentLevels =
                    definitions.predicate."strmprivacy.api.entities.v1.ConsentLevels/definitions/consent_levels",
                }
                {
                  "^consent_levels$" =
                    definitions.predicate."strmprivacy.api.entities.v1.ConsentLevels/definitions/consent_levels",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.CsvConfig" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  charset =
                    definitions.predicate."strmprivacy.api.entities.v1.CsvConfig/definitions/charset",
                }
                {  }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.DataConnectorAndType" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  dataConnectorRef =
                    definitions.predicate."strmprivacy.api.entities.v1.DataConnectorAndType/definitions/data_connector_ref",
                  dataType =
                    definitions.predicate."strmprivacy.api.entities.v1.DataConnectorAndType/definitions/data_type",
                  fileName =
                    definitions.predicate."strmprivacy.api.entities.v1.DataConnectorAndType/definitions/file_name",
                  pathPrefix =
                    definitions.predicate."strmprivacy.api.entities.v1.DataConnectorAndType/definitions/path_prefix",
                }
                {
                  "^data_connector_ref$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DataConnectorAndType/definitions/data_connector_ref",
                  "^data_type$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DataConnectorAndType/definitions/data_type",
                  "^file_name$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DataConnectorAndType/definitions/file_name",
                  "^path_prefix$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DataConnectorAndType/definitions/path_prefix",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.DataConnectorRef" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  billingId =
                    definitions.predicate."strmprivacy.api.entities.v1.DataConnectorRef/definitions/billing_id",
                  name =
                    definitions.predicate."strmprivacy.api.entities.v1.DataConnectorRef/definitions/name",
                  projectId =
                    definitions.predicate."strmprivacy.api.entities.v1.DataConnectorRef/definitions/project_id",
                }
                {
                  "^billing_id$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DataConnectorRef/definitions/billing_id",
                  "^project_id$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DataConnectorRef/definitions/project_id",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.DataType" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  csv =
                    definitions.predicate."strmprivacy.api.entities.v1.DataType/definitions/csv",
                  database =
                    definitions.predicate."strmprivacy.api.entities.v1.DataType/definitions/database",
                }
                {  }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.DatabaseConfig" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  columns =
                    definitions.predicate."strmprivacy.api.entities.v1.DatabaseConfig/definitions/columns",
                  schema =
                    definitions.predicate."strmprivacy.api.entities.v1.DatabaseConfig/definitions/schema",
                  table =
                    definitions.predicate."strmprivacy.api.entities.v1.DatabaseConfig/definitions/table",
                }
                {  }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.DerivedData" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  consentLevelType =
                    definitions.predicate."strmprivacy.api.entities.v1.DerivedData/definitions/consent_level_type",
                  consentLevels =
                    definitions.predicate."strmprivacy.api.entities.v1.DerivedData/definitions/consent_levels",
                  maskedFields =
                    definitions.predicate."strmprivacy.api.entities.v1.DerivedData/definitions/masked_fields",
                  target =
                    definitions.predicate."strmprivacy.api.entities.v1.DerivedData/definitions/target",
                }
                {
                  "^consent_level_type$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DerivedData/definitions/consent_level_type",
                  "^consent_levels$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DerivedData/definitions/consent_levels",
                  "^masked_fields$" =
                    definitions.predicate."strmprivacy.api.entities.v1.DerivedData/definitions/masked_fields",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.EncryptedData" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  target =
                    definitions.predicate."strmprivacy.api.entities.v1.EncryptedData/definitions/target",
                }
                {  }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.EncryptionConfig" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  batchJobGroupId =
                    definitions.predicate."strmprivacy.api.entities.v1.EncryptionConfig/definitions/batch_job_group_id",
                  timestampConfig =
                    definitions.predicate."strmprivacy.api.entities.v1.EncryptionConfig/definitions/timestamp_config",
                }
                {
                  "^batch_job_group_id$" =
                    definitions.predicate."strmprivacy.api.entities.v1.EncryptionConfig/definitions/batch_job_group_id",
                  "^timestamp_config$" =
                    definitions.predicate."strmprivacy.api.entities.v1.EncryptionConfig/definitions/timestamp_config",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.EncryptionKeysData" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  target =
                    definitions.predicate."strmprivacy.api.entities.v1.EncryptionKeysData/definitions/target",
                }
                {  }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.EventContractRef" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  handle =
                    definitions.predicate."strmprivacy.api.entities.v1.EventContractRef/definitions/handle",
                  name =
                    definitions.predicate."strmprivacy.api.entities.v1.EventContractRef/definitions/name",
                  version =
                    definitions.predicate."strmprivacy.api.entities.v1.EventContractRef/definitions/version",
                }
                {  }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.MaskedFields" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fieldPatterns =
                    definitions.predicate."strmprivacy.api.entities.v1.MaskedFields/definitions/field_patterns",
                  hashType =
                    definitions.predicate."strmprivacy.api.entities.v1.MaskedFields/definitions/hash_type",
                  seed =
                    definitions.predicate."strmprivacy.api.entities.v1.MaskedFields/definitions/seed",
                }
                {
                  "^field_patterns$" =
                    definitions.predicate."strmprivacy.api.entities.v1.MaskedFields/definitions/field_patterns",
                  "^hash_type$" =
                    definitions.predicate."strmprivacy.api.entities.v1.MaskedFields/definitions/hash_type",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.MaskedFields.PatternList" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fieldPatterns =
                    definitions.predicate."strmprivacy.api.entities.v1.MaskedFields.PatternList/definitions/field_patterns",
                }
                {
                  "^field_patterns$" =
                    definitions.predicate."strmprivacy.api.entities.v1.MaskedFields.PatternList/definitions/field_patterns",
                }
                true
                predicates.always
              ],
          "strmprivacy.api.entities.v1.TimestampConfig" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultTimeZone =
                    definitions.predicate."strmprivacy.api.entities.v1.TimestampConfig/definitions/default_time_zone",
                  field =
                    definitions.predicate."strmprivacy.api.entities.v1.TimestampConfig/definitions/field",
                  format =
                    definitions.predicate."strmprivacy.api.entities.v1.TimestampConfig/definitions/format",
                }
                {
                  "^default_time_zone$" =
                    definitions.predicate."strmprivacy.api.entities.v1.TimestampConfig/definitions/default_time_zone",
                }
                true
                predicates.always
              ],
        },
  }
in

definitions.contract."strmprivacy.api.entities.v1.BatchJob"