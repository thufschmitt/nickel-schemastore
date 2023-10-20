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
          clearTextReporterOptions = {
                allowColor
                  | Bool
                  | doc m%"
                  Indicates whether or not to use color coding in output.
                  "%
                  | optional,
                allowEmojis
                  | Bool
                  | doc m%"
                  Enable emojis in your clear text report (experimental).
                  "%
                  | optional,
                logTests
                  | Bool
                  | doc m%"
                  Indicates whether or not to log which tests were executed for a given mutant.
                  "%
                  | optional,
                maxTestsToLog
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  Indicates the maximum amount of test to log when `logTests` is enabled
                  "%
                  | optional,
                reportMutants
                  | Bool
                  | doc m%"
                  Indicates whether or not to log all mutants.
                  "%
                  | optional,
                reportScoreTable
                  | Bool
                  | doc m%"
                  Indicates whether or not to log score table.
                  "%
                  | optional,
                reportTests
                  | Bool
                  | doc m%"
                  Indicates whether or not to log all tests.
                  "%
                  | optional,
                ..
              },
          commandRunnerOptions = {
                command
                  | String
                  | doc m%"
                  The command to test each mutant. For example "npm run mocha". Defaults to "npm test".
                  "%
                  | optional,
                ..
              },
          coverageAnalysis = std.contract.Sequence
              [ std.enum.TagOrString, [| 'perTest, 'all, 'off |] ],
          dashboardOptions = {
                baseUrl
                  | String
                  | doc m%"
                  Indicates the base url of the stryker dashboard.
                  "%
                  | optional,
                module
                  | String
                  | doc m%"
                  Indicates which module to use if the "dashboard" reporter is enabled.
                  "%
                  | optional,
                project
                  | String
                  | doc m%"
                  Indicates which project to use if the "dashboard" reporter is enabled.
                  "%
                  | optional,
                reportType
                  | definitions.contract.reportType
                  | doc m%"
                  Indicates wether to send a full report (inc. source code and mutant results) or only the mutation score.
                  "%
                  | optional,
                version
                  | String
                  | doc m%"
                  Indicates which version to use if the "dashboard" reporter is enabled.
                  "%
                  | optional,
              },
          eventRecorderOptions = {
                baseDir
                  | String
                  | doc m%"
                  The base dir to write the events to
                  "%
                  | optional,
              },
          htmlReporterOptions = {
                fileName
                  | String
                  | doc m%"
                  The `fileName` of the html report.
                  "%
                  | optional,
              },
          jsonReporterOptions = {
                fileName
                  | String
                  | doc m%"
                  The relative filename for the json report.
                  "%
                  | optional,
              },
          logLevel = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'trace, 'debug, 'info, 'warn, 'error, 'fatal, 'off |]
              ],
          mutationScoreThresholds = {
                break
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType 'Null, definitions.predicate.percentage ])
                  | optional,
                high | definitions.contract.percentage | optional,
                low | definitions.contract.percentage | optional,
              },
          mutatorDescriptor = {
                excludedMutations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                plugins
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ])
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Override the default babel plugins Stryker uses to parse your JavaScript files. The default list of plugins is extensive and normally doesn't need overriding. Stryker also loads your babel plugins by default (if you have them). If Stryker's default babel plugins conflicts with your plugins, try to override this list with an empty array.
                  "%
                  | optional,
              },
          percentage = predicates.contract_from_predicate
              definitions.predicate.percentage,
          reportType = std.contract.Sequence
              [ std.enum.TagOrString, [| 'mutationScore, 'full |] ],
          warningOptions = {
                preprocessorErrors
                  | Bool
                  | doc m%"
                  decide whether or not to log warnings when a preprocessor error occurs. For example, when the disabling of type errors fails.
                  "%
                  | optional,
                slow
                  | Bool
                  | doc m%"
                  decide whether or not to log warnings when Stryker detects a slow part of mutation that can be sped up by changing some configuration. For example using `--ignoreStatic`.
                  "%
                  | optional,
                unknownOptions
                  | Bool
                  | doc m%"
                  decide whether or not to log warnings when additional stryker options are configured
                  "%
                  | optional,
                unserializableOptions
                  | Bool
                  | doc m%"
                  decide whether or not to log warnings when a configuration options are unserializable. For example, using a `/regex/` or `function` in your configuration options.
                  "%
                  | optional,
                ..
              },
        },
    predicate = {
          clearTextReporterOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allowColor = predicates.isType '"Bool",
                  allowEmojis = predicates.isType '"Bool",
                  logTests = predicates.isType '"Bool",
                  maxTestsToLog = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  reportMutants = predicates.isType '"Bool",
                  reportScoreTable = predicates.isType '"Bool",
                  reportTests = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          commandRunnerOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { command = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          coverageAnalysis = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "off", "all", "perTest" ]
              ],
          dashboardOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  baseUrl = predicates.isType '"String",
                  module = predicates.isType '"String",
                  project = predicates.isType '"String",
                  reportType = definitions.predicate.reportType,
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          eventRecorderOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { baseDir = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          htmlReporterOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { fileName = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          jsonReporterOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { fileName = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          logLevel = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "off", "fatal", "error", "warn", "info", "debug", "trace" ]
              ],
          mutationScoreThresholds = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  break = predicates.oneOf
                      [
                        predicates.isType 'Null,
                        definitions.predicate.percentage
                      ],
                  high = definitions.predicate.percentage,
                  low = definitions.predicate.percentage,
                }
                {  }
                false
                predicates.never
              ],
          mutatorDescriptor = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  excludedMutations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  plugins = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Array"
                          ])
                        ],
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          percentage = predicates.allOf
              [
                predicates.isType '"Number",
                predicates.numbers.maximum 100,
                predicates.numbers.minimum 0
              ],
          reportType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "full", "mutationScore" ]
              ],
          warningOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  preprocessorErrors = predicates.isType '"Bool",
                  slow = predicates.isType '"Bool",
                  unknownOptions = predicates.isType '"Bool",
                  unserializableOptions = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

{
  allowConsoleColors
    | Bool
    | doc m%"
    The 'allowConsoleColors' value indicates whether Stryker should use colors in console.
    "%
    | optional,
  allowEmpty
    | Bool
    | doc m%"
    Allows stryker to exit without any errors in cases where no tests are found
    "%
    | optional,
  appendPlugins
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A list of additional plugins you want Stryker to load (`require`) without overwriting the (default) `plugins`.
    "%
    | optional,
  buildCommand
    | String
    | doc m%"
    Configure a build command to run after mutating the code, but before mutants are tested. This is generally used to transpile your code before testing. Only configure this if your test runner doesn't take care of this already and you're not using just-in-time transpiler like `babel/register` or `ts-node`.
    "%
    | optional,
  checkerNodeArgs
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Configure arguments to be passed as exec arguments to the checker child process(es). For example, running Stryker with `--concurrency 1 --checkerNodeArgs --inspect-brk` will allow you to debug the checker child process. See `execArgv` of [`child_process.fork`](https://nodejs.org/api/child_process.html#child_process_child_process_fork_modulepath_args_options)
    "%
    | optional,
  checkers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Enable checker plugins here. A checker plugin will be invoked for each mutant before it is run in a test runner. It can check to see of a given mutant is valid, by for example validate that it won't result in a type error
    "%
    | optional,
  cleanTempDir
    | predicates.contract_from_predicate
    (predicates.enum [ "always", false, true ])
    | doc m%"
    Choose whether or not to clean the temp dir (which is ".stryker-tmp" inside the current working directory by default).
     - false: Never delete the temp dir;
     - true: Delete the tmp dir after a successful run;
     - "always": Always delete the temp dir, regardless of whether the run was successful.
    "%
    | optional,
  clearTextReporter
    | definitions.contract.clearTextReporterOptions
    | doc m%"
    The options for the clear text reporter.
    "%
    | optional,
  commandRunner
    | definitions.contract.commandRunnerOptions
    | doc m%"
    Options used by the command test runner. Note: these options will only be used when the command test runner is activated (this is the default)
    "%
    | optional,
  concurrency
    | Number
    | doc m%"
    Set the concurrency of workers. Stryker will always run checkers and test runners in parallel by creating worker processes (note, not `worker_threads`). This defaults to `n-1` where `n` is the number of logical CPU cores available on your machine, unless `n <= 4`, in that case it uses `n`. This is a sane default for most use cases.
    "%
    | optional,
  coverageAnalysis
    | definitions.contract.coverageAnalysis
    | doc m%"
    Indicates which coverage analysis strategy to use. During mutation testing, Stryker will try to only run the tests that cover a particular mutant.
    
    'perTest': Analyse coverage per test.
    'all': Analyse the coverage for the entire test suite.
    'off' (default): Don't use coverage analysis
    "%
    | optional,
  dashboard
    | definitions.contract.dashboardOptions
    | doc m%"
    The options for the dashboard reporter.
    "%
    | optional,
  disableBail
    | Bool
    | doc m%"
    Disables the default of bailing after first failing test. When true runs all tests covering a mutant. Useful when the subject under test is not completely isolated by mocks and you want to know which tests are killing the mutants. This will impact performance.
    "%
    | optional,
  disableTypeChecks
    | predicates.contract_from_predicate
    (predicates.oneOf
    [ predicates.isType '"Bool", predicates.isType '"String" ])
    | doc m%"
    Set to 'true' to disable type checking, or 'false' to enable it. For more control, configure a pattern that matches the files of which type checking has to be disabled. This is needed because Stryker will create (typescript) type errors when inserting the mutants in your code. Stryker disables type checking by inserting `// @ts-nocheck` atop those files and removing other `// @ts-xxx` directives (so they won't interfere with `@ts-nocheck`). The default setting allows these directives to be stripped from all JavaScript and friend files in `lib`, `src` and `test` directories.
    "%
    | optional,
  dryRunOnly
    | Bool
    | doc m%"
    Execute the initial test run only without doing actual mutation testing. Dry run only will still mutate your code before doing the dry run without those mutants being active, thus can be used to test that StrykerJS can run your test setup. This can be useful, for example, in CI pipelines.
    "%
    | optional,
  dryRunTimeoutMinutes
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
    | doc m%"
    Configure an absolute timeout for the initial test run. (It can take a while, therefore we use minutes as time unit.)
    "%
    | optional,
  eventReporter
    | definitions.contract.eventRecorderOptions
    | doc m%"
    The options for the event recorder reporter.
    "%
    | optional,
  fileLogLevel
    | definitions.contract.logLevel
    | doc m%"
    Set the log level that Stryker uses to write to the "stryker.log" file
    "%
    | optional,
  "force"
    | Bool
    | doc m%"
    Run all mutants, even if --incremental is provided and an incremental file exists. Can be used to force a rebuild of the incremental file.
    "%
    | optional,
  htmlReporter
    | definitions.contract.htmlReporterOptions
    | doc m%"
    The options for the html reporter
    "%
    | optional,
  ignorePatterns
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A comma separated list of patterns used for specifying which files need to be ignored. This should only be used in cases where you experience a slow Stryker startup, because too many (or too large) files are copied to the sandbox that are not needed to run the tests. For example, image or movie directories. Note: This option will have NO effect when using the `--inPlace` option. The directories `node_modules`, `.git` and some others are always ignored. Example: `--ignorePatterns dist`. These patterns are ALWAYS ignored: [`node_modules`, `.git`, `/reports`, `*.tsbuildinfo`, `/stryker.log`, `.stryker-tmp`]. Because Stryker always ignores these, you should rarely have to adjust the `ignorePatterns` setting at all. This is useful to speed up Stryker by ignoring big directories/files you might have in your repo that has nothing to do with your code. For example, 1.5GB of movie/image files. Specify the patterns to all files or directories that are not used to run your tests and thus should NOT be copied to the sandbox directory for mutation testing. Each patterns in this array should be a [glob pattern](#usage-of-globbing-expressions-on-options). If a glob pattern starts with `/`, the pattern is relative to the current working directory. For example, `/foo.js` matches to `foo.js` but not `subdir/foo.js`. However to SELECT specific files TO BE mutated, you better use `--mutate`.
    "%
    | optional,
  ignoreStatic
    | Bool
    | doc m%"
    Ignore static mutants. Static mutants are mutants which are only executed during the loading of a file. This means that Stryker has to reload the entire environment in order to test the mutant AND has to run all tests. Therefore, it might make sense to ignore static mutants.
    "%
    | optional,
  ignorers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Specify which ignore-plugins to use. With an ignore-plugin you can ignore mutants inside common code patterns that you don't want to test for some reason. For example, you can use this to ignore all `console.debug()` statements from being mutated.
    "%
    | optional,
  inPlace
    | Bool
    | doc m%"
    Determines whether or not Stryker should mutate your files in place. Note: mutating your files in place is generally not needed for mutation testing, unless you have a dependency in your project that is really dependent on the file locations (like "app-root-path" for example).
    
    When `true`, Stryker will override your files, but it will keep a copy of the originals in the temp directory (using `tempDirName`) and it will place the originals back after it is done. Also with `true` the `ignorePatterns` has no effect any more.
    
    When `false` (default) Stryker will work in the copy of your code inside the temp directory.
    "%
    | optional,
  incremental
    | Bool
    | doc m%"
    Enable 'incremental mode'. Stryker will store results in a file and use that file to speed up the next --incremental run
    "%
    | optional,
  incrementalFile
    | String
    | doc m%"
    Specify the file to use for incremental mode.
    "%
    | optional,
  jsonReporter
    | definitions.contract.jsonReporterOptions
    | doc m%"
    The options for the json reporter
    "%
    | optional,
  logLevel
    | definitions.contract.logLevel
    | doc m%"
    Set the log level that Stryker uses to write to the console.
    "%
    | optional,
  maxConcurrentTestRunners
    | Number
    | doc m%"
    [DEPRECATED please use "concurrency" instead]. Specifies the maximum number of concurrent test runners to spawn. Mutation testing is time consuming. By default, Stryker tries to make the most of your CPU's, by spawning as many test runners as you have CPU cores (`Number.MAX_SAFE_INTEGER`).
    "%
    | optional,
  maxTestRunnerReuse
    | Number
    | doc m%"
    Restart each test runner worker process after `n` runs. Not recommended unless you are experiencing memory leaks that you are unable to resolve. Configuring `0` here means infinite reuse.
    "%
    | optional,
  mutate
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    With `mutate` you configure the subset of files or just one specific file to be mutated. These should be your _production code files_, and definitely not your test files.
    (Whereas with `ignorePatterns` you prevent non-relevant files from being copied to the sandbox directory in the first place)
    The default will try to guess your production code files based on sane defaults. It reads like this:
    - Include all js-like files inside the `src` or `lib` dir
    - Except files inside `__tests__` directories and file names ending with `test` or `spec`.
    If the defaults are not sufficient for you, for example in a angular project you might want to
     **exclude** not only the `*.spec.ts` files but other files too, just like the default already does.
    It is possible to specify exactly which code blocks to mutate by means of a _mutation range_. This can be done postfixing your file with `:startLine[:startColumn]-endLine[:endColumn]`. Example: src/index.js:1:3-1:5
    "%
    | optional,
  mutator
    | definitions.contract.mutatorDescriptor
    | doc m%"
    Configure how Stryker mutates your code.
    "%
    | optional,
  packageManager
    | predicates.contract_from_predicate
    (predicates.enum [ "npm", "yarn", "pnpm" ])
    | doc m%"
    The package manager Stryker can use to install missing dependencies.
    "%
    | optional,
  plugins
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    With 'plugins', you can add additional Node modules for Stryker to load (or require). By default, all node_modules starting with @stryker-mutator/* will be loaded, so you would normally not need to specify this option. These modules should be installed right next to stryker. For a current list of plugins, you can consult 'npm' or 'stryker-mutator.io.'
    "%
    | optional,
  reporters
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    With reporters, you can set the reporters for stryker to use.
    "%
    | optional,
  symlinkNodeModules
    | Bool
    | doc m%"
    The 'symlinkNodeModules' value indicates whether Stryker should create a symbolic link to your current node_modules directory in the sandbox directories. This makes running your tests by Stryker behave more like your would run the tests yourself in your project directory. Only disable this setting if you really know what you are doing.
    "%
    | optional,
  tempDirName
    | String
    | doc m%"
    Choose a different temp dir that Stryker uses for mutation testing. This directory will contain copies of your source code during a mutation test run. It will be created if it not exists and is *entirely deleted* after a successful run, so change this with caution.
    "%
    | optional,
  testRunner
    | String
    | doc m%"
    With 'testRunner' you specify the test runner that Stryker uses to run your tests. The default value is command. The command runner runs a configurable bash/cmd command and bases the result on the exit code of that program (0 for success, otherwise failed). You can configure this command via the config file using the 'commandRunner: { command: 'npm run mocha' }'. It uses 'npm test' as the command by default.
    "%
    | optional,
  testRunnerNodeArgs
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Configure arguments to be passed as exec arguments to the test runner child process. For example, running Stryker with `--timeoutMS 9999999 --concurrency 1 --testRunnerNodeArgs --inspect-brk` will allow you to debug the test runner child process. See `execArgv` of [`child_process.fork`](https://nodejs.org/api/child_process.html#child_process_child_process_fork_modulepath_args_options)
    "%
    | optional,
  thresholds
    | definitions.contract.mutationScoreThresholds
    | doc m%"
    Specify the thresholds for mutation score.
    "%
    | optional,
  timeoutFactor
    | Number
    | doc m%"
    Configure the allowed timeout deviation relative to the time of a normal test run. Tweak this if you notice that mutants are prone to creating slower code, but not infinite loops (for that, use `timeoutMS`)
    "%
    | optional,
  timeoutMS
    | Number
    | doc m%"
    Configure an absolute timeout deviation. Tweak this if you run Stryker on a busy machine and you need to wait longer to make sure that the code indeed entered an infinite loop.
    "%
    | optional,
  tsconfigFile
    | String
    | doc m%"
    Configure the (root) tsconfig file for typescript projects. This will allow Stryker to rewrite the `extends` and `references` settings in this and related tsconfig files in your sandbox. Defaults to `tsconfig.json`. This setting is also used when you enable the `@stryker-mutator/typescript-checker plugin
    "%
    | optional,
  warnings
    | predicates.contract_from_predicate
    (predicates.oneOf
    [ predicates.isType '"Bool", definitions.predicate.warningOptions ])
    | doc m%"
    Enable or disable certain warnings
    "%
    | optional,
  ..
}