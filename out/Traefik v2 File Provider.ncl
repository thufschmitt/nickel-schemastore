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
          addPrefixMiddleware
            | doc m%"
            The AddPrefix middleware updates the URL Path of the request before forwarding it.
            "%
            = {
                prefix
                  | String
                  | doc m%"
                  prefix is the string to add before the current path in the requested URL. It should include the leading slash (/).
                  "%
                  | optional,
              },
          basicAuthMiddleware
            | doc m%"
            The BasicAuth middleware is a quick way to restrict access to your services to known users. If both users and usersFile are provided, the two are merged. The contents of usersFile have precedence over the values in users.
            "%
            = {
                headerField
                  | String
                  | doc m%"
                  You can define a header field to store the authenticated user using the headerField option.
                  "%
                  | optional,
                realm
                  | String
                  | doc m%"
                  You can customize the realm for the authentication with the realm option. The default value is traefik.
                  "%
                  | optional,
                removeHeader
                  | Bool
                  | doc m%"
                  Set the removeHeader option to true to remove the authorization header before forwarding the request to your service. (Default value is false.)
                  "%
                  | optional,
                users
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The users option is an array of authorized users. Each user will be declared using the `name:hashed-password` format.
                  "%
                  | optional,
                usersFile
                  | String
                  | doc m%"
                  The usersFile option is the path to an external file that contains the authorized users for the middleware.
                  
                  The file content is a list of `name:hashed-password`.
                  "%
                  | optional,
                ..
              },
          bufferingMiddleware
            | doc m%"
            The Buffering middleware gives you control on how you want to read the requests before sending them to services.
            
            With Buffering, Traefik reads the entire request into memory (possibly buffering large requests into disk), and rejects requests that are over a specified limit.
            
            This can help services deal with large data (multipart/form-data for example), and can minimize time spent sending data to a service.
            "%
            = {
                maxRequestBodyBytes
                  | std.number.Integer
                  | doc m%"
                  With the maxRequestBodyBytes option, you can configure the maximum allowed body size for the request (in Bytes).
                  
                  If the request exceeds the allowed size, it is not forwarded to the service and the client gets a 413 (Request Entity Too Large) response.
                  "%
                  | optional,
                maxResponseBodyBytes
                  | std.number.Integer
                  | doc m%"
                  With the maxResponseBodyBytes option, you can configure the maximum allowed response size from the service (in Bytes).
                  
                  If the response exceeds the allowed size, it is not forwarded to the client. The client gets a 413 (Request Entity Too Large) response instead.
                  "%
                  | optional,
                memRequestBodyBytes
                  | std.number.Integer
                  | doc m%"
                  You can configure a threshold (in Bytes) from which the request will be buffered on disk instead of in memory with the memRequestBodyBytes option.
                  "%
                  | optional,
                memResponseBodyBytes
                  | std.number.Integer
                  | doc m%"
                  You can configure a threshold (in Bytes) from which the response will be buffered on disk instead of in memory with the memResponseBodyBytes option.
                  "%
                  | optional,
                retryExpression
                  | String
                  | doc m%"
                  You can have the Buffering middleware replay the request with the help of the retryExpression option.
                  "%
                  | optional,
              },
          chainMiddleware
            | doc m%"
            The Chain middleware enables you to define reusable combinations of other pieces of middleware. It makes reusing the same groups easier.
            "%
            = {
                middlewares
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.minItems 1
                  ])
                  | optional,
              },
          circuitBreakerMiddleware
            | doc m%"
            The circuit breaker protects your system from stacking requests to unhealthy services (resulting in cascading failures).
            
            When your system is healthy, the circuit is closed (normal operations). When your system becomes unhealthy, the circuit becomes open and the requests are no longer forwarded (but handled by a fallback mechanism).
            
            To assess if your system is healthy, the circuit breaker constantly monitors the services.
            "%
            = {
                checkPeriod
                  | String
                  | doc m%"
                  The interval between successive checks of the circuit breaker condition (when in standby state)
                  "%
                  | optional,
                expression
                  | String
                  | doc m%"
                  You can specify an expression that, once matched, will trigger the circuit breaker (and apply the fallback mechanism instead of calling your services).
                  "%
                  | optional,
                fallbackDuration
                  | String
                  | doc m%"
                  The duration for which the circuit breaker will wait before trying to recover (from a tripped state).
                  "%
                  | optional,
                recoveryDuration
                  | String
                  | doc m%"
                  The duration for which the circuit breaker will try to recover (as soon as it is in recovering state).
                  "%
                  | optional,
              },
          compressMiddleware
            | doc m%"
            The Compress middleware enables the gzip compression.
            "%
            = {
                excludedContentTypes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  excludedContentTypes specifies a list of content types to compare the Content-Type header of the incoming requests to before compressing.
                  
                  The requests with content types defined in excludedContentTypes are not compressed.
                  
                  Content types are compared in a case-insensitive, whitespace-ignored manner.
                  "%
                  | optional,
                minResponseBodyBytes
                  | std.number.Integer
                  | doc m%"
                  specifies the minimum amount of bytes a response body must have to be compressed.
                  "%
                  | optional,
              },
          contentTypeMiddleware
            | doc m%"
            The Content-Type middleware - or rather its unique autoDetect option - specifies whether to let the Content-Type header, if it has not been set by the backend, be automatically set to a value derived from the contents of the response.
            
            As a proxy, the default behavior should be to leave the header alone, regardless of what the backend did with it. However, the historic default was to always auto-detect and set the header if it was nil, and it is going to be kept that way in order to support users currently relying on it. This middleware exists to enable the correct behavior until at least the default one can be changed in a future version.
            "%
            = {
                autoDetect
                  | Bool
                  | doc m%"
                  autoDetect specifies whether to let the Content-Type header, if it has not been set by the backend, be automatically set to a value derived from the contents of the response.
                  "%
                  | optional,
              },
          digestAuthMiddleware
            | doc m%"
            The DigestAuth middleware is a quick way to restrict access to your services to known users. If both users and usersFile are provided, the two are merged. The contents of usersFile have precedence over the values in users.
            "%
            = {
                headerField
                  | String
                  | doc m%"
                  You can customize the header field for the authenticated user using the headerField option.
                  "%
                  | optional,
                realm
                  | String
                  | doc m%"
                  You can customize the realm for the authentication with the realm option. The default value is traefik.
                  "%
                  | optional,
                removeHeader
                  | Bool
                  | doc m%"
                  Set the removeHeader option to true to remove the authorization header before forwarding the request to your service. (Default value is false.)
                  "%
                  | optional,
                users
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The users option is an array of authorized users. Each user will be declared using the `name:realm:encoded-password` format.
                  "%
                  | optional,
                usersFile
                  | String
                  | doc m%"
                  The usersFile option is the path to an external file that contains the authorized users for the middleware.
                  
                  The file content is a list of `name:realm:encoded-password`.
                  "%
                  | optional,
              },
          errorsMiddleware
            | doc m%"
            The ErrorPage middleware returns a custom page in lieu of the default, according to configured ranges of HTTP Status codes. The error page itself is not hosted by Traefik.
            "%
            = {
                query
                  | String
                  | doc m%"
                  The URL for the error page (hosted by service). You can use {status} in the query, that will be replaced by the received status code.
                  "%
                  | optional,
                service
                  | String
                  | doc m%"
                  The service that will serve the new requested error page.
                  "%
                  | optional,
                status
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The status that will trigger the error page.
                  
                  The status code ranges are inclusive (500-599 will trigger with every code between 500 and 599, 500 and 599 included). You can define either a status code like 500 or ranges with a syntax like 500-599.
                  "%
                  | optional,
              },
          forwardAuthMiddleware
            | doc m%"
            The ForwardAuth middleware delegate the authentication to an external service. If the service response code is 2XX, access is granted and the original request is performed. Otherwise, the response from the authentication server is returned.
            "%
            = {
                address
                  | String
                  | doc m%"
                  The address option defines the authentication server address.
                  "%
                  | optional,
                authRequestHeaders
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The authRequestHeaders option is the list of the headers to copy from the request to the authentication server.
                  "%
                  | optional,
                authResponseHeaders
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The authResponseHeaders option is the list of the headers to copy from the authentication server to the request.
                  "%
                  | optional,
                authResponseHeadersRegex
                  | String
                  | doc m%"
                  The authResponseHeadersRegex option is the regex to match headers to copy from the authentication server response and set on forwarded request, after stripping all headers that match the regex.
                  "%
                  | optional,
                tls
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      ca = predicates.isType '"String",
                      caOptional = predicates.isType '"Bool",
                      cert = predicates.isType '"String",
                      insecureSkipVerify = predicates.isType '"Bool",
                      key = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always,
                    predicates.records.dependencies { caOptional = [ "ca" ], }
                  ])
                  | doc m%"
                  The tls option is the TLS configuration from Traefik to the authentication server.
                  "%
                  | optional,
                trustForwardHeader
                  | Bool
                  | doc m%"
                  Set the trustForwardHeader option to true to trust all the existing X-Forwarded-* headers.
                  "%
                  | optional,
              },
          headersMiddleware
            | doc m%"
            The Headers middleware can manage the requests/responses headers.
            "%
            = {
                accessControlAllowCredentials
                  | Bool
                  | doc m%"
                  The accessControlAllowCredentials indicates whether the request can include user credentials.
                  "%
                  | optional,
                accessControlAllowHeaders
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The accessControlAllowHeaders indicates which header field names can be used as part of the request.
                  "%
                  | optional,
                accessControlAllowMethods
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The accessControlAllowMethods indicates which methods can be used during requests.
                  "%
                  | optional,
                accessControlAllowOriginList
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The accessControlAllowOriginList indicates whether a resource can be shared by returning different values.
                  
                  A wildcard origin * can also be configured, and will match all requests. If this value is set by a backend server, it will be overwritten by Traefik
                  
                  This value can contain a list of allowed origins.
                  "%
                  | optional,
                accessControlAllowOriginListRegex
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The accessControlAllowOriginListRegex option is the counterpart of the accessControlAllowOriginList option with regular expressions instead of origin values.
                  "%
                  | optional,
                accessControlExposeHeaders
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The accessControlExposeHeaders indicates which headers are safe to expose to the api of a CORS API specification.
                  "%
                  | optional,
                accessControlMaxAge
                  | std.number.Integer
                  | doc m%"
                  The accessControlMaxAge indicates how long (in seconds) a preflight request can be cached.
                  "%
                  | optional,
                addVaryHeader
                  | Bool
                  | doc m%"
                  The addVaryHeader is used in conjunction with accessControlAllowOriginList to determine whether the vary header should be added or modified to demonstrate that server responses can differ based on the value of the origin header.
                  "%
                  | optional,
                allowedHosts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The allowedHosts option lists fully qualified domain names that are allowed.
                  "%
                  | optional,
                browserXssFilter
                  | Bool
                  | doc m%"
                  Set browserXssFilter to true to add the X-XSS-Protection header with the value 1; mode=block.
                  "%
                  | optional,
                contentSecurityPolicy
                  | String
                  | doc m%"
                  The contentSecurityPolicy option allows the Content-Security-Policy header value to be set with a custom value.
                  "%
                  | optional,
                contentTypeNosniff
                  | Bool
                  | doc m%"
                  Set contentTypeNosniff to true to add the X-Content-Type-Options header with the value nosniff.
                  "%
                  | optional,
                customBrowserXSSValue
                  | String
                  | doc m%"
                  The customBrowserXssValue option allows the X-XSS-Protection header value to be set with a custom value. This overrides the BrowserXssFilter option.
                  "%
                  | optional,
                customFrameOptionsValue
                  | String
                  | doc m%"
                  The customFrameOptionsValue allows the X-Frame-Options header value to be set with a custom value. This overrides the FrameDeny option.
                  "%
                  | optional,
                customRequestHeaders
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  The customRequestHeaders option lists the Header names and values to apply to the request.
                  "%
                  | optional,
                customResponseHeaders
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  The customResponseHeaders option lists the Header names and values to apply to the response.
                  "%
                  | optional,
                featurePolicy
                  | String
                  | doc m%"
                  The featurePolicy allows sites to control browser features.
                  "%
                  | optional,
                forceSTSHeader
                  | Bool
                  | doc m%"
                  Set forceSTSHeader to true, to add the STS header even when the connection is HTTP.
                  "%
                  | optional,
                frameDeny
                  | Bool
                  | doc m%"
                  Set frameDeny to true to add the X-Frame-Options header with the value of DENY.
                  "%
                  | optional,
                hostsProxyHeaders
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The hostsProxyHeaders option is a set of header keys that may hold a proxied hostname value for the request.
                  "%
                  | optional,
                isDevelopment
                  | Bool
                  | doc m%"
                  Set isDevelopment to true when developing. The AllowedHosts, SSL, and STS options can cause some unwanted effects. Usually testing happens on http, not https, and on localhost, not your production domain.
                  If you would like your development environment to mimic production with complete Host blocking, SSL redirects, and STS headers, leave this as false.
                  "%
                  | optional,
                permissionsPolicy
                  | String
                  | doc m%"
                  The permissionsPolicy allows sites to control browser features.
                  "%
                  | optional,
                publicKey
                  | String
                  | doc m%"
                  The publicKey implements HPKP to prevent MITM attacks with forged certificates.
                  "%
                  | optional,
                referrerPolicy
                  | String
                  | doc m%"
                  The referrerPolicy allows sites to control when browsers will pass the Referer header to other sites.
                  "%
                  | optional,
                sslForceHost
                  | Bool
                  | doc m%"
                  Set sslForceHost to true and set SSLHost to forced requests to use SSLHost even the ones that are already using SSL.
                  "%
                  | optional,
                sslHost
                  | String
                  | doc m%"
                  The sslHost option is the host name that is used to redirect http requests to https.
                  "%
                  | optional,
                sslProxyHeaders
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  The sslProxyHeaders option is set of header keys with associated values that would indicate a valid https request. Useful when using other proxies with header like: "X-Forwarded-Proto": "https".
                  "%
                  | optional,
                sslRedirect
                  | Bool
                  | doc m%"
                  The sslRedirect is set to true, then only allow https requests.
                  "%
                  | optional,
                sslTemporaryRedirect
                  | Bool
                  | doc m%"
                  Set the sslTemporaryRedirect to true to force an SSL redirection using a 302 (instead of a 301).
                  "%
                  | optional,
                stsIncludeSubdomains
                  | Bool
                  | doc m%"
                  The stsIncludeSubdomains is set to true, the includeSubDomains directive will be appended to the Strict-Transport-Security header.
                  "%
                  | optional,
                stsPreload
                  | Bool
                  | doc m%"
                  Set stsPreload to true to have the preload flag appended to the Strict-Transport-Security header.
                  "%
                  | optional,
                stsSeconds
                  | std.number.Integer
                  | doc m%"
                  The stsSeconds is the max-age of the Strict-Transport-Security header. If set to 0, would NOT include the header.
                  "%
                  | optional,
              },
          httpFailoverService = {
                fallback | String | optional,
                healthCheck | {  .. } | optional,
                service | String | optional,
              },
          httpLoadBalancerService
            | doc m%"
            The load balancers are able to load balance the requests between multiple instances of your programs.
            
            Each service has a load-balancer, even if there is only one server to forward traffic to.
            "%
            = {
                healthCheck
                  | {
                    followRedirects
                      | Bool
                      | doc m%"
                      Defines whether redirects should be followed during the health check calls (default: true).
                      "%
                      | optional,
                    headers
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ])
                      | doc m%"
                      Defines custom headers to be sent to the health check endpoint.
                      "%
                      | optional,
                    hostname
                      | String
                      | doc m%"
                      If defined, will apply Host header hostname to the health check request.
                      "%
                      | optional,
                    interval
                      | String
                      | doc m%"
                      Defines the frequency of the health check calls. Interval is to be given in a format understood by `time.ParseDuration`. The interval must be greater than the timeout. If configuration doesn't reflect this, the interval will be set to timeout + 1 second.
                      "%
                      | optional,
                    method
                      | String
                      | doc m%"
                      If defined, will apply this Method for the health check request.
                      "%
                      | optional,
                    path
                      | String
                      | doc m%"
                      path is appended to the server URL to set the health check endpoint.
                      "%
                      | optional,
                    port
                      | std.number.Integer
                      | doc m%"
                      If defined, will replace the server URL port for the health check endpoint.
                      "%
                      | optional,
                    scheme
                      | String
                      | doc m%"
                      If defined, will replace the server URL scheme for the health check endpoint
                      "%
                      | optional,
                    timeout
                      | String
                      | doc m%"
                      Defines the maximum duration Traefik will wait for a health check request before considering the server failed (unhealthy). Timeout is to be given in a format understood by `time.ParseDuration`.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Configure health check to remove unhealthy servers from the load balancing rotation. Traefik will consider your servers healthy as long as they return status codes between 2XX and 3XX to the health check requests (carried out every interval). Traefik keeps monitoring the health of unhealthy servers. If a server has recovered (returning 2xx -> 3xx responses again), it will be added back to the load balancer rotation pool.
                  "%
                  | optional,
                passHostHeader
                  | Bool
                  | doc m%"
                  The passHostHeader allows to forward client Host header to server. By default, passHostHeader is true.
                  "%
                  | optional,
                responseForwarding
                  | {
                    flushInterval
                      | String
                      | doc m%"
                      Specifies the interval in between flushes to the client while copying the response body. It is a duration in milliseconds, defaulting to 100. A negative value means to flush immediately after each write to the client. The flushInterval is ignored when ReverseProxy recognizes a response as a streaming response; for such responses, writes are flushed to the client immediately.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Defines how Traefik forwards the response from the backend server to the client.
                  "%
                  | optional,
                servers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "url" ],
                      predicates.records.record
                      { url = predicates.isType '"String", }
                      {  }
                      true
                      predicates.always
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Servers declare a single instance of your program.
                  "%,
                serversTransport | String | optional,
                sticky
                  | {
                    cookie
                      | {
                        httpOnly | Bool | optional,
                        name
                          | String
                          | doc m%"
                          The default cookie name is an abbreviation of a sha1 (ex: _1d52e).
                          "%
                          | optional,
                        sameSite
                          | String
                          | doc m%"
                          Can be none, lax, strict or empty.
                          "%
                          | optional,
                        secure | Bool | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | doc m%"
                  When sticky sessions are enabled, a cookie is set on the initial request and response to let the client know which server handles the first response. On subsequent requests, to keep the session alive with the same server, the client should resend the same cookie.
                  "%
                  | optional,
              },
          httpMiddleware = predicates.contract_from_predicate
              definitions.predicate.httpMiddleware,
          httpMirroringService
            | doc m%"
            The mirroring is able to mirror requests sent to a service to other services. Please note that by default the whole request is buffered in memory while it is being mirrored. See the maxBodySize option for how to modify this behaviour.
            "%
            = {
                healthCheck | {  .. } | optional,
                maxBodySize
                  | std.number.Integer
                  | doc m%"
                  maxBodySize is the maximum size allowed for the body of the request. If the body is larger, the request is not mirrored. Default value is -1, which means unlimited size.
                  "%
                  | optional,
                mirrors
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
                        percent = predicates.allOf
                            [
                              predicates.isType '"Number",
                              predicates.numbers.maximum 100,
                              predicates.numbers.minimum 0
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ])
                  | optional,
                service | String | optional,
              },
          httpRouter
            | doc m%"
            A router is in charge of connecting incoming requests to the services that can handle them. In the process, routers may use pieces of middleware to update the request, or act before forwarding the request to the service.
            "%
            = {
                entryPoints
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  If not specified, HTTP routers will accept requests from all defined entry points. If you want to limit the router scope to a set of entry points, set the entryPoints option.
                  "%
                  | optional,
                middlewares
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  You can attach a list of middlewares to each HTTP router. The middlewares will take effect only if the rule matches, and before forwarding the request to the service. Middlewares are applied in the same order as their declaration in router.
                  "%
                  | optional,
                "priority"
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  To avoid path overlap, routes are sorted, by default, in descending order using rules length. The priority is directly equal to the length of the rule, and so the longest length has the highest priority. A value of 0 for the priority is ignored: priority = 0 means that the default rules length sorting is used.
                  "%
                  | optional,
                rule
                  | String
                  | doc m%"
                  Rules are a set of matchers configured with values, that determine if a particular request matches specific criteria. If the rule is verified, the router becomes active, calls middlewares, and then forwards the request to the service.
                  "%,
                service
                  | String
                  | doc m%"
                  Each request must eventually be handled by a service, which is why each router definition should include a service target, which is basically where the request will be passed along to. HTTP routers can only target HTTP services (not TCP services).
                  "%,
                tls
                  | {
                    certResolver
                      | String
                      | doc m%"
                      If certResolver is defined, Traefik will try to generate certificates based on routers Host & HostSNI rules.
                      "%
                      | optional,
                    domains
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
                            main = predicates.isType '"String",
                            sans = predicates.allOf
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
                      ])
                      | doc m%"
                      You can set SANs (alternative domains) for each main domain. Every domain must have A/AAAA records pointing to Traefik. Each domain & SAN will lead to a certificate request.
                      "%
                      | optional,
                    options
                      | String
                      | doc m%"
                      The options field enables fine-grained control of the TLS parameters. It refers to a TLS Options and will be applied only if a Host rule is defined.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  When a TLS section is specified, it instructs Traefik that the current router is dedicated to HTTPS requests only (and that the router should ignore HTTP (non TLS) requests). Traefik will terminate the SSL connections (meaning that it will send decrypted data to the services). If you need to define the same route for both HTTP and HTTPS requests, you will need to define two different routers: one with the tls section, one without.
                  "%
                  | optional,
              },
          httpService
            | doc m%"
            The Services are responsible for configuring how to reach the actual services that will eventually handle the incoming requests.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.httpService,
          httpWeightedService
            | doc m%"
            The WRR is able to load balance the requests between multiple services based on weights.
            
            This strategy is only available to load balance between services and not between servers.
            "%
            = {
                healthCheck | {  .. } | optional,
                services
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
                        weight = predicates.isType '"Number",
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ])
                  | optional,
                sticky
                  | {
                    cookie
                      | {
                        httpOnly | Bool | optional,
                        name
                          | String
                          | doc m%"
                          The default cookie name is an abbreviation of a sha1 (ex: _1d52e).
                          "%
                          | optional,
                        sameSite
                          | String
                          | doc m%"
                          Can be none, lax, strict or empty.
                          "%
                          | optional,
                        secure | Bool | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | doc m%"
                  When sticky sessions are enabled, a cookie is set on the initial request and response to let the client know which server handles the first response. On subsequent requests, to keep the session alive with the same server, the client should resend the same cookie.
                  "%
                  | optional,
              },
          inFlightReqMiddleware
            | doc m%"
            To proactively prevent services from being overwhelmed with high load, a limit on the number of simultaneous in-flight requests can be applied.
            "%
            = {
                amount
                  | std.number.Integer
                  | doc m%"
                  The amount option defines the maximum amount of allowed simultaneous in-flight request. The middleware will return an HTTP 429 Too Many Requests if there are already amount requests in progress (based on the same sourceCriterion strategy).
                  "%
                  | optional,
                sourceCriterion
                  | definitions.contract.sourceCriterion
                  | optional,
              },
          ipStrategy
            | doc m%"
            The ipStrategy option defines parameters that set how Traefik will determine the client IP.
            "%
            = {
                depth
                  | std.number.Integer
                  | doc m%"
                  The depth option tells Traefik to use the X-Forwarded-For header and take the IP located at the depth position (starting from the right). If depth is greater than the total number of IPs in X-Forwarded-For, then the client IP will be empty. depth is ignored if its value is lesser than or equal to 0.
                  "%
                  | optional,
                excludedIPs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  excludedIPs tells Traefik to scan the X-Forwarded-For header and pick the first IP not in the list. If depth is specified, excludedIPs is ignored.
                  "%
                  | optional,
              },
          ipWhiteListMiddleware
            | doc m%"
            IPWhitelist accepts / refuses requests based on the client IP.
            "%
            = {
                ipStrategy | definitions.contract.ipStrategy | optional,
                sourceRange
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The sourceRange option sets the allowed IPs (or ranges of allowed IPs by using CIDR notation).
                  "%
                  | optional,
              },
          passTLSClientCertMiddleware
            | doc m%"
            PassTLSClientCert adds in header the selected data from the passed client tls certificate.
            "%
            = {
                info
                  | {
                    issuer
                      | {
                        commonName
                          | Bool
                          | doc m%"
                          Set the commonName option to true to add the commonName information into the issuer.
                          "%
                          | optional,
                        country
                          | Bool
                          | doc m%"
                          Set the country option to true to add the country information into the issuer.
                          "%
                          | optional,
                        domainComponent
                          | Bool
                          | doc m%"
                          Set the domainComponent option to true to add the domainComponent information into the issuer.
                          "%
                          | optional,
                        locality
                          | Bool
                          | doc m%"
                          Set the locality option to true to add the locality information into the issuer.
                          "%
                          | optional,
                        organization
                          | Bool
                          | doc m%"
                          Set the organization option to true to add the organization information into the issuer.
                          "%
                          | optional,
                        province
                          | Bool
                          | doc m%"
                          Set the province option to true to add the province information into the issuer.
                          "%
                          | optional,
                        serialNumber
                          | Bool
                          | doc m%"
                          Set the serialNumber option to true to add the serialNumber information into the issuer.
                          "%
                          | optional,
                        ..
                      }
                      | doc m%"
                      The issuer select the specific client certificate issuer details you want to add to the X-Forwarded-Tls-Client-Cert-Info header.
                      "%
                      | optional,
                    notAfter
                      | Bool
                      | doc m%"
                      Set the notAfter option to true to add the Not After information from the Validity part.
                      "%
                      | optional,
                    notBefore
                      | Bool
                      | doc m%"
                      Set the notBefore option to true to add the Not Before information from the Validity part.
                      "%
                      | optional,
                    sans
                      | Bool
                      | doc m%"
                      Set the sans option to true to add the Subject Alternative Name information from the Subject Alternative Name part.
                      "%
                      | optional,
                    subject
                      | {
                        commonName
                          | Bool
                          | doc m%"
                          Set the commonName option to true to add the commonName information into the subject.
                          "%
                          | optional,
                        country
                          | Bool
                          | doc m%"
                          Set the country option to true to add the country information into the subject.
                          "%
                          | optional,
                        domainComponent
                          | Bool
                          | doc m%"
                          Set the domainComponent option to true to add the domainComponent information into the subject.
                          "%
                          | optional,
                        locality
                          | Bool
                          | doc m%"
                          Set the locality option to true to add the locality information into the subject.
                          "%
                          | optional,
                        organization
                          | Bool
                          | doc m%"
                          Set the organization option to true to add the organization information into the subject.
                          "%
                          | optional,
                        province
                          | Bool
                          | doc m%"
                          Set the province option to true to add the province information into the subject.
                          "%
                          | optional,
                        serialNumber
                          | Bool
                          | doc m%"
                          Set the serialNumber option to true to add the serialNumber information into the subject.
                          "%
                          | optional,
                        ..
                      }
                      | doc m%"
                      The subject select the specific client certificate subject details you want to add to the X-Forwarded-Tls-Client-Cert-Info header.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  The info option select the specific client certificate details you want to add to the X-Forwarded-Tls-Client-Cert-Info header. The value of the header will be an escaped concatenation of all the selected certificate details.
                  "%
                  | optional,
                pem
                  | Bool
                  | doc m%"
                  The pem option sets the X-Forwarded-Tls-Client-Cert header with the escape certificate.
                  "%
                  | optional,
              },
          pluginMiddleware
            | doc m%"
            Some plugins will need to be configured by adding a dynamic configuration.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.pluginMiddleware,
          rateLimitMiddleware
            | doc m%"
            The RateLimit middleware ensures that services will receive a fair number of requests, and allows one to define what fair is.
            "%
            = {
                average
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | doc m%"
                  average is the maximum rate, by default in requests by second, allowed for the given source.
                  
                  It defaults to 0, which means no rate limiting.
                  
                  The rate is actually defined by dividing average by period. So for a rate below 1 req/s, one needs to define a period larger than a second.
                  "%
                  | optional,
                burst
                  | Number
                  | doc m%"
                  burst is the maximum number of requests allowed to go through in the same arbitrarily small period of time.
                  
                  It defaults to 1.
                  "%
                  | optional,
                period
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | doc m%"
                  period, in combination with average, defines the actual maximum rate.
                  
                  It defaults to 1 second.
                  "%
                  | optional,
                sourceCriterion
                  | definitions.contract.sourceCriterion
                  | optional,
              },
          redirectRegexMiddleware
            | doc m%"
            RegexRedirect redirect a request from an url to another with regex matching and replacement.
            "%
            = {
                permanent
                  | Bool
                  | doc m%"
                  Set the permanent option to true to apply a permanent redirection.
                  "%
                  | optional,
                regex
                  | String
                  | doc m%"
                  The regex option is the regular expression to match and capture elements from the request URL.
                  "%
                  | optional,
                replacement
                  | String
                  | doc m%"
                  The replacement option defines how to modify the URL to have the new target URL. Care should be taken when defining replacement expand variables: $1x is equivalent to ${1x}, not ${1}x (see Regexp.Expand), so use ${1} syntax.
                  "%
                  | optional,
              },
          redirectSchemeMiddleware
            | doc m%"
            RedirectScheme redirect request from a scheme to another.
            "%
            = {
                permanent
                  | Bool
                  | doc m%"
                  Set the permanent option to true to apply a permanent redirection.
                  "%
                  | optional,
                port
                  | String
                  | doc m%"
                  The port option defines the port of the new url. Port in this configuration is a string, not a numeric value.
                  "%
                  | optional,
                scheme
                  | String
                  | doc m%"
                  The scheme option defines the scheme of the new url.
                  "%
                  | optional,
              },
          replacePathMiddleware
            | doc m%"
            Replace the path of the request url. It will replace the actual path by the specified one and will store the original path in a X-Replaced-Path header.
            "%
            = {
                path
                  | String
                  | doc m%"
                  The path option defines the path to use as replacement in the request url.
                  "%
                  | optional,
              },
          replacePathRegexMiddleware
            | doc m%"
            The ReplaceRegex replace a path from an url to another with regex matching and replacement. It will replace the actual path by the specified one and store the original path in a X-Replaced-Path header.
            "%
            = {
                regex
                  | String
                  | doc m%"
                  The regex option is the regular expression to match and capture the path from the request URL.
                  "%
                  | optional,
                replacement
                  | String
                  | doc m%"
                  The replacement option defines how to modify the path to have the new target path. Care should be taken when defining replacement expand variables: $1x is equivalent to ${1x}, not ${1}x (see Regexp.Expand), so use ${1} syntax.
                  "%
                  | optional,
              },
          retryMiddleware
            | doc m%"
            The Retry middleware is in charge of reissuing a request a given number of times to a backend server if that server does not reply. To be clear, as soon as the server answers, the middleware stops retrying, regardless of the response status.
            "%
            = {
                attempts
                  | std.number.Integer
                  | doc m%"
                  The attempts option defines how many times the request should be retried.
                  "%,
                initialInterval
                  | String
                  | doc m%"
                  The initialInterval option defines the first wait time in the exponential backoff series.
                  "%
                  | optional,
              },
          sourceCriterion
            | doc m%"
            SourceCriterion defines what criterion is used to group requests as originating from a common source. The precedence order is ipStrategy, then requestHeaderName, then requestHost. If none are set, the default is to use the requestHost.
            "%
            = {
                ipStrategy | definitions.contract.ipStrategy | optional,
                requestHeaderName
                  | String
                  | doc m%"
                  Requests having the same value for the given header are grouped as coming from the same source.
                  "%
                  | optional,
                requestHost
                  | Bool
                  | doc m%"
                  Whether to consider the request host as the source.
                  "%
                  | optional,
              },
          stripPrefixMiddleware
            | doc m%"
            Remove the specified prefixes from the URL path. It will strip the matching path prefix and will store the matching path prefix in a X-Forwarded-Prefix header.
            "%
            = {
                forceSlash
                  | Bool
                  | doc m%"
                  The forceSlash option makes sure that the resulting stripped path is not the empty string, by replacing it with / when necessary.
                  
                  This option was added to keep the initial (non-intuitive) behavior of this middleware, in order to avoid introducing a breaking change.
                  
                  It's recommended to explicitly set forceSlash to false.
                  "%
                  | optional,
                prefixes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The prefixes option defines the prefixes to strip from the request URL
                  "%
                  | optional,
              },
          stripPrefixRegexMiddleware
            | doc m%"
            Remove the matching prefixes from the URL path. It will strip the matching path prefix and will store the matching path prefix in a X-Forwarded-Prefix header.
            "%
            = {
                regex
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The regex option is the regular expression to match the path prefix from the request URL.
                  "%
                  | optional,
              },
          tcpLoadBalancerService = {
                proxyProtocol
                  | { version | std.number.Integer | optional, .. }
                  | optional,
                servers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "address" ],
                      predicates.records.record
                      { address = predicates.isType '"String", }
                      {  }
                      true
                      predicates.always
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Servers declare a single instance of your program.
                  "%,
                terminationDelay
                  | Number
                  | doc m%"
                  As a proxy between a client and a server, it can happen that either side (e.g. client side) decides to terminate its writing capability on the connection (i.e. issuance of a FIN packet). The proxy needs to propagate that intent to the other side, and so when that happens, it also does the same on its connection with the other side (e.g. backend side).
                  
                  However, if for some reason (bad implementation, or malicious intent) the other side does not eventually do the same as well, the connection would stay half-open, which would lock resources for however long.
                  
                  To that end, as soon as the proxy enters this termination sequence, it sets a deadline on fully terminating the connections on both sides.
                  
                  The termination delay controls that deadline. It is a duration in milliseconds, defaulting to 100. A negative value means an infinite deadline (i.e. the connection is never fully terminated by the proxy itself).
                  "%
                  | optional,
              },
          tcpRouter
            | doc m%"
            If both HTTP routers and TCP routers listen to the same entry points, the TCP routers will apply before the HTTP routers. If no matching route is found for the TCP routers, then the HTTP routers will take over.
            "%
            = {
                entryPoints
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  If not specified, TCP routers will accept requests from all defined entry points. If you want to limit the router scope to a set of entry points, set the entry points option.
                  "%
                  | optional,
                middlewares
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                "priority"
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  To avoid path overlap, routes are sorted, by default, in descending order using rules length. The priority is directly equal to the length of the rule, and so the longest length has the highest priority. A value of 0 for the priority is ignored: priority = 0 means that the default rules length sorting is used.
                  "%
                  | optional,
                rule
                  | String
                  | doc m%"
                  It is important to note that the Server Name Indication is an extension of the TLS protocol. Hence, only TLS routers will be able to specify a domain name with that rule. However, non-TLS routers will have to explicitly use that rule with * (every domain) to state that every non-TLS request will be handled by the router.
                  "%,
                service
                  | String
                  | doc m%"
                  You must attach a TCP service per TCP router. Services are the target for the router. TCP routers can only target TCP services (not HTTP services).
                  "%,
                tls
                  | {
                    certResolver
                      | String
                      | doc m%"
                      If certResolver is defined, Traefik will try to generate certificates based on routers Host & HostSNI rules.
                      "%
                      | optional,
                    domains
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
                            main = predicates.isType '"String",
                            sans = predicates.allOf
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
                      ])
                      | doc m%"
                      You can set SANs (alternative domains) for each main domain. Every domain must have A/AAAA records pointing to Traefik. Each domain & SAN will lead to a certificate request.
                      "%
                      | optional,
                    options
                      | String
                      | doc m%"
                      The options field enables fine-grained control of the TLS parameters. It refers to a TLS Options and will be applied only if a Host rule is defined.
                      "%
                      | optional,
                    passthrough
                      | Bool
                      | doc m%"
                      A TLS router will terminate the TLS connection by default. However, the passthrough option can be specified to set whether the requests should be forwarded "as is", keeping all data encrypted.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  When a TLS section is specified, it instructs Traefik that the current router is dedicated to TLS requests only (and that the router should ignore non-TLS requests).
                  
                  By default, a router with a TLS section will terminate the TLS connections, meaning that it will send decrypted data to the services.
                  "%
                  | optional,
              },
          tcpService = predicates.contract_from_predicate
              definitions.predicate.tcpService,
          tcpWeightedService = {
                services
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "name", "weight" ],
                      predicates.records.record
                      {
                        name = predicates.isType '"String",
                        weight = predicates.isType '"Number",
                      }
                      {  }
                      false
                      predicates.never
                    ]),
                    predicates.arrays.minItems 1
                  ]),
              },
          udpLoadBalancerService
            | doc m%"
            The servers load balancer is in charge of balancing the requests between the servers of the same service.
            "%
            = {
                servers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "address" ],
                      predicates.records.record
                      { address = predicates.isType '"String", }
                      {  }
                      true
                      predicates.always
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  The servers field defines all the servers that are part of this load-balancing group, i.e. each address (IP:Port) on which an instance of the service's program is deployed.
                  "%,
              },
          udpRouter = {
                entryPoints
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  If not specified, UDP routers will accept packets from all defined (UDP) entry points. If one wants to limit the router scope to a set of entry points, one should set the entry points option.
                  "%
                  | optional,
                service
                  | String
                  | doc m%"
                  There must be one (and only one) UDP service referenced per UDP router. Services are the target for the router.
                  "%,
              },
          udpService = predicates.contract_from_predicate
              definitions.predicate.udpService,
          udpWeightedService = {
                services
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "name", "weight" ],
                      predicates.records.record
                      {
                        name = predicates.isType '"String",
                        weight = predicates.isType '"Number",
                      }
                      {  }
                      false
                      predicates.never
                    ]),
                    predicates.arrays.minItems 1
                  ]),
              },
        },
    predicate = {
          addPrefixMiddleware
            | doc m%"
            The AddPrefix middleware updates the URL Path of the request before forwarding it.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { prefix = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          basicAuthMiddleware
            | doc m%"
            The BasicAuth middleware is a quick way to restrict access to your services to known users. If both users and usersFile are provided, the two are merged. The contents of usersFile have precedence over the values in users.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  headerField = predicates.isType '"String",
                  realm = predicates.isType '"String",
                  removeHeader = predicates.isType '"Bool",
                  users = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  usersFile = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          bufferingMiddleware
            | doc m%"
            The Buffering middleware gives you control on how you want to read the requests before sending them to services.
            
            With Buffering, Traefik reads the entire request into memory (possibly buffering large requests into disk), and rejects requests that are over a specified limit.
            
            This can help services deal with large data (multipart/form-data for example), and can minimize time spent sending data to a service.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  maxRequestBodyBytes = predicates.isType 'Integer,
                  maxResponseBodyBytes = predicates.isType 'Integer,
                  memRequestBodyBytes = predicates.isType 'Integer,
                  memResponseBodyBytes = predicates.isType 'Integer,
                  retryExpression = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          chainMiddleware
            | doc m%"
            The Chain middleware enables you to define reusable combinations of other pieces of middleware. It makes reusing the same groups easier.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  middlewares = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          circuitBreakerMiddleware
            | doc m%"
            The circuit breaker protects your system from stacking requests to unhealthy services (resulting in cascading failures).
            
            When your system is healthy, the circuit is closed (normal operations). When your system becomes unhealthy, the circuit becomes open and the requests are no longer forwarded (but handled by a fallback mechanism).
            
            To assess if your system is healthy, the circuit breaker constantly monitors the services.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  checkPeriod = predicates.isType '"String",
                  expression = predicates.isType '"String",
                  fallbackDuration = predicates.isType '"String",
                  recoveryDuration = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          compressMiddleware
            | doc m%"
            The Compress middleware enables the gzip compression.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  excludedContentTypes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  minResponseBodyBytes = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          contentTypeMiddleware
            | doc m%"
            The Content-Type middleware - or rather its unique autoDetect option - specifies whether to let the Content-Type header, if it has not been set by the backend, be automatically set to a value derived from the contents of the response.
            
            As a proxy, the default behavior should be to leave the header alone, regardless of what the backend did with it. However, the historic default was to always auto-detect and set the header if it was nil, and it is going to be kept that way in order to support users currently relying on it. This middleware exists to enable the correct behavior until at least the default one can be changed in a future version.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { autoDetect = predicates.isType '"Bool", }
                {  }
                false
                predicates.never
              ],
          digestAuthMiddleware
            | doc m%"
            The DigestAuth middleware is a quick way to restrict access to your services to known users. If both users and usersFile are provided, the two are merged. The contents of usersFile have precedence over the values in users.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  headerField = predicates.isType '"String",
                  realm = predicates.isType '"String",
                  removeHeader = predicates.isType '"Bool",
                  users = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  usersFile = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          errorsMiddleware
            | doc m%"
            The ErrorPage middleware returns a custom page in lieu of the default, according to configured ranges of HTTP Status codes. The error page itself is not hosted by Traefik.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  query = predicates.isType '"String",
                  service = predicates.isType '"String",
                  status = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          forwardAuthMiddleware
            | doc m%"
            The ForwardAuth middleware delegate the authentication to an external service. If the service response code is 2XX, access is granted and the original request is performed. Otherwise, the response from the authentication server is returned.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  address = predicates.isType '"String",
                  authRequestHeaders = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  authResponseHeaders = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  authResponseHeadersRegex = predicates.isType '"String",
                  tls = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          ca = predicates.isType '"String",
                          caOptional = predicates.isType '"Bool",
                          cert = predicates.isType '"String",
                          insecureSkipVerify = predicates.isType '"Bool",
                          key = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always,
                        predicates.records.dependencies
                        { caOptional = [ "ca" ], }
                      ],
                  trustForwardHeader = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          headersMiddleware
            | doc m%"
            The Headers middleware can manage the requests/responses headers.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessControlAllowCredentials = predicates.isType '"Bool",
                  accessControlAllowHeaders = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  accessControlAllowMethods = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  accessControlAllowOriginList = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  accessControlAllowOriginListRegex = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  accessControlExposeHeaders = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  accessControlMaxAge = predicates.isType 'Integer,
                  addVaryHeader = predicates.isType '"Bool",
                  allowedHosts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  browserXssFilter = predicates.isType '"Bool",
                  contentSecurityPolicy = predicates.isType '"String",
                  contentTypeNosniff = predicates.isType '"Bool",
                  customBrowserXSSValue = predicates.isType '"String",
                  customFrameOptionsValue = predicates.isType '"String",
                  customRequestHeaders = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  customResponseHeaders = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  featurePolicy = predicates.isType '"String",
                  forceSTSHeader = predicates.isType '"Bool",
                  frameDeny = predicates.isType '"Bool",
                  hostsProxyHeaders = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  isDevelopment = predicates.isType '"Bool",
                  permissionsPolicy = predicates.isType '"String",
                  publicKey = predicates.isType '"String",
                  referrerPolicy = predicates.isType '"String",
                  sslForceHost = predicates.isType '"Bool",
                  sslHost = predicates.isType '"String",
                  sslProxyHeaders = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  sslRedirect = predicates.isType '"Bool",
                  sslTemporaryRedirect = predicates.isType '"Bool",
                  stsIncludeSubdomains = predicates.isType '"Bool",
                  stsPreload = predicates.isType '"Bool",
                  stsSeconds = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          httpFailoverService = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fallback = predicates.isType '"String",
                  healthCheck = predicates.isType 'Record,
                  service = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          httpLoadBalancerService
            | doc m%"
            The load balancers are able to load balance the requests between multiple instances of your programs.
            
            Each service has a load-balancer, even if there is only one server to forward traffic to.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "servers" ],
                predicates.records.record
                {
                  healthCheck = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          followRedirects = predicates.isType '"Bool",
                          headers = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  } {  } true
                                (predicates.isType '"String")
                              ],
                          hostname = predicates.isType '"String",
                          interval = predicates.isType '"String",
                          method = predicates.isType '"String",
                          path = predicates.isType '"String",
                          port = predicates.isType 'Integer,
                          scheme = predicates.isType '"String",
                          timeout = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  passHostHeader = predicates.isType '"Bool",
                  responseForwarding = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { flushInterval = predicates.isType '"String", }
                        {  }
                        true
                        predicates.always
                      ],
                  servers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "url" ],
                          predicates.records.record
                          { url = predicates.isType '"String", }
                          {  }
                          true
                          predicates.always
                        ]),
                        predicates.arrays.minItems 1
                      ],
                  serversTransport = predicates.isType '"String",
                  sticky = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          cookie = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  httpOnly = predicates.isType '"Bool",
                                  name = predicates.isType '"String",
                                  sameSite = predicates.isType '"String",
                                  secure = predicates.isType '"Bool",
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          httpMiddleware = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.records.record
                  { addPrefix = definitions.predicate.addPrefixMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { basicAuth = definitions.predicate.basicAuthMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { buffering = definitions.predicate.bufferingMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { chain = definitions.predicate.chainMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    circuitBreaker =
                      definitions.predicate.circuitBreakerMiddleware,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { compress = definitions.predicate.compressMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { contentType = definitions.predicate.contentTypeMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { digestAuth = definitions.predicate.digestAuthMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { errors = definitions.predicate.errorsMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { forwardAuth = definitions.predicate.forwardAuthMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { headers = definitions.predicate.headersMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { ipWhiteList = definitions.predicate.ipWhiteListMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { inFlightReq = definitions.predicate.inFlightReqMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    passTLSClientCert =
                      definitions.predicate.passTLSClientCertMiddleware,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { plugin = definitions.predicate.pluginMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { rateLimit = definitions.predicate.rateLimitMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    redirectRegex =
                      definitions.predicate.redirectRegexMiddleware,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    redirectScheme =
                      definitions.predicate.redirectSchemeMiddleware,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { replacePath = definitions.predicate.replacePathMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    replacePathRegex =
                      definitions.predicate.replacePathRegexMiddleware,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { retry = definitions.predicate.retryMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { stripPrefix = definitions.predicate.stripPrefixMiddleware, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    stripPrefixRegex =
                      definitions.predicate.stripPrefixRegexMiddleware,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          httpMirroringService
            | doc m%"
            The mirroring is able to mirror requests sent to a service to other services. Please note that by default the whole request is buffered in memory while it is being mirrored. See the maxBodySize option for how to modify this behaviour.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  healthCheck = predicates.isType 'Record,
                  maxBodySize = predicates.isType 'Integer,
                  mirrors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            name = predicates.isType '"String",
                            percent = predicates.allOf
                                [
                                  predicates.isType '"Number",
                                  predicates.numbers.maximum 100,
                                  predicates.numbers.minimum 0
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ])
                      ],
                  service = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          httpRouter
            | doc m%"
            A router is in charge of connecting incoming requests to the services that can handle them. In the process, routers may use pieces of middleware to update the request, or act before forwarding the request to the service.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "rule", "service" ],
                predicates.records.record
                {
                  entryPoints = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  middlewares = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  "priority" = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  rule = predicates.isType '"String",
                  service = predicates.isType '"String",
                  tls = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          certResolver = predicates.isType '"String",
                          domains = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    main = predicates.isType '"String",
                                    sans = predicates.allOf
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
                          options = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          httpService
            | doc m%"
            The Services are responsible for configuring how to reach the actual services that will eventually handle the incoming requests.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    loadBalancer =
                      definitions.predicate.httpLoadBalancerService,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { weighted = definitions.predicate.httpWeightedService, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { mirroring = definitions.predicate.httpMirroringService, }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { failover = definitions.predicate.httpFailoverService, }
                  {  }
                  false
                  predicates.never
                ]
              ],
          httpWeightedService
            | doc m%"
            The WRR is able to load balance the requests between multiple services based on weights.
            
            This strategy is only available to load balance between services and not between servers.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  healthCheck = predicates.isType 'Record,
                  services = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            name = predicates.isType '"String",
                            weight = predicates.isType '"Number",
                          }
                          {  }
                          true
                          predicates.always
                        ])
                      ],
                  sticky = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          cookie = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  httpOnly = predicates.isType '"Bool",
                                  name = predicates.isType '"String",
                                  sameSite = predicates.isType '"String",
                                  secure = predicates.isType '"Bool",
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          inFlightReqMiddleware
            | doc m%"
            To proactively prevent services from being overwhelmed with high load, a limit on the number of simultaneous in-flight requests can be applied.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  amount = predicates.isType 'Integer,
                  sourceCriterion = definitions.predicate.sourceCriterion,
                }
                {  }
                false
                predicates.never
              ],
          ipStrategy
            | doc m%"
            The ipStrategy option defines parameters that set how Traefik will determine the client IP.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  depth = predicates.isType 'Integer,
                  excludedIPs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ipWhiteListMiddleware
            | doc m%"
            IPWhitelist accepts / refuses requests based on the client IP.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ipStrategy = definitions.predicate.ipStrategy,
                  sourceRange = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          passTLSClientCertMiddleware
            | doc m%"
            PassTLSClientCert adds in header the selected data from the passed client tls certificate.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  info = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          issuer = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  commonName = predicates.isType '"Bool",
                                  country = predicates.isType '"Bool",
                                  domainComponent = predicates.isType '"Bool",
                                  locality = predicates.isType '"Bool",
                                  organization = predicates.isType '"Bool",
                                  province = predicates.isType '"Bool",
                                  serialNumber = predicates.isType '"Bool",
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          notAfter = predicates.isType '"Bool",
                          notBefore = predicates.isType '"Bool",
                          sans = predicates.isType '"Bool",
                          subject = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  commonName = predicates.isType '"Bool",
                                  country = predicates.isType '"Bool",
                                  domainComponent = predicates.isType '"Bool",
                                  locality = predicates.isType '"Bool",
                                  organization = predicates.isType '"Bool",
                                  province = predicates.isType '"Bool",
                                  serialNumber = predicates.isType '"Bool",
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  pem = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          pluginMiddleware
            | doc m%"
            Some plugins will need to be configured by adding a dynamic configuration.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType 'Record)
              ],
          rateLimitMiddleware
            | doc m%"
            The RateLimit middleware ensures that services will receive a fair number of requests, and allows one to define what fair is.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  average = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  burst = predicates.isType '"Number",
                  period = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  sourceCriterion = definitions.predicate.sourceCriterion,
                }
                {  }
                false
                predicates.never
              ],
          redirectRegexMiddleware
            | doc m%"
            RegexRedirect redirect a request from an url to another with regex matching and replacement.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  permanent = predicates.isType '"Bool",
                  regex = predicates.isType '"String",
                  replacement = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          redirectSchemeMiddleware
            | doc m%"
            RedirectScheme redirect request from a scheme to another.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  permanent = predicates.isType '"Bool",
                  port = predicates.isType '"String",
                  scheme = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          replacePathMiddleware
            | doc m%"
            Replace the path of the request url. It will replace the actual path by the specified one and will store the original path in a X-Replaced-Path header.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { path = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          replacePathRegexMiddleware
            | doc m%"
            The ReplaceRegex replace a path from an url to another with regex matching and replacement. It will replace the actual path by the specified one and store the original path in a X-Replaced-Path header.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  regex = predicates.isType '"String",
                  replacement = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          retryMiddleware
            | doc m%"
            The Retry middleware is in charge of reissuing a request a given number of times to a backend server if that server does not reply. To be clear, as soon as the server answers, the middleware stops retrying, regardless of the response status.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "attempts" ],
                predicates.records.record
                {
                  attempts = predicates.isType 'Integer,
                  initialInterval = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          sourceCriterion
            | doc m%"
            SourceCriterion defines what criterion is used to group requests as originating from a common source. The precedence order is ipStrategy, then requestHeaderName, then requestHost. If none are set, the default is to use the requestHost.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ipStrategy = definitions.predicate.ipStrategy,
                  requestHeaderName = predicates.isType '"String",
                  requestHost = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          stripPrefixMiddleware
            | doc m%"
            Remove the specified prefixes from the URL path. It will strip the matching path prefix and will store the matching path prefix in a X-Forwarded-Prefix header.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  forceSlash = predicates.isType '"Bool",
                  prefixes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          stripPrefixRegexMiddleware
            | doc m%"
            Remove the matching prefixes from the URL path. It will strip the matching path prefix and will store the matching path prefix in a X-Forwarded-Prefix header.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  regex = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          tcpLoadBalancerService = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "servers" ],
                predicates.records.record
                {
                  proxyProtocol = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { version = predicates.isType 'Integer, }
                        {  }
                        true
                        predicates.always
                      ],
                  servers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "address" ],
                          predicates.records.record
                          { address = predicates.isType '"String", }
                          {  }
                          true
                          predicates.always
                        ]),
                        predicates.arrays.minItems 1
                      ],
                  terminationDelay = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          tcpRouter
            | doc m%"
            If both HTTP routers and TCP routers listen to the same entry points, the TCP routers will apply before the HTTP routers. If no matching route is found for the TCP routers, then the HTTP routers will take over.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "rule", "service" ],
                predicates.records.record
                {
                  entryPoints = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  middlewares = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  "priority" = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  rule = predicates.isType '"String",
                  service = predicates.isType '"String",
                  tls = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          certResolver = predicates.isType '"String",
                          domains = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    main = predicates.isType '"String",
                                    sans = predicates.allOf
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
                          options = predicates.isType '"String",
                          passthrough = predicates.isType '"Bool",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          tcpService = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    loadBalancer = definitions.predicate.tcpLoadBalancerService,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { weighted = definitions.predicate.tcpWeightedService, }
                  {  }
                  false
                  predicates.never
                ]
              ],
          tcpWeightedService = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "services" ],
                predicates.records.record
                {
                  services = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "name", "weight" ],
                          predicates.records.record
                          {
                            name = predicates.isType '"String",
                            weight = predicates.isType '"Number",
                          }
                          {  }
                          false
                          predicates.never
                        ]),
                        predicates.arrays.minItems 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          udpLoadBalancerService
            | doc m%"
            The servers load balancer is in charge of balancing the requests between the servers of the same service.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "servers" ],
                predicates.records.record
                {
                  servers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "address" ],
                          predicates.records.record
                          { address = predicates.isType '"String", }
                          {  }
                          true
                          predicates.always
                        ]),
                        predicates.arrays.minItems 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          udpRouter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "service" ],
                predicates.records.record
                {
                  entryPoints = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  service = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          udpService = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    loadBalancer = definitions.predicate.udpLoadBalancerService,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { weighted = definitions.predicate.udpWeightedService, }
                  {  }
                  false
                  predicates.never
                ]
              ],
          udpWeightedService = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "services" ],
                predicates.records.record
                {
                  services = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "name", "weight" ],
                          predicates.records.record
                          {
                            name = predicates.isType '"String",
                            weight = predicates.isType '"Number",
                          }
                          {  }
                          false
                          predicates.never
                        ]),
                        predicates.arrays.minItems 1
                      ],
                }
                {  }
                false
                predicates.never
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
    http = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            middlewares = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true
                  definitions.predicate.httpMiddleware
                ],
            routers = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true
                  definitions.predicate.httpRouter
                ],
            services = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true
                  definitions.predicate.httpService
                ],
          }
          {  }
          true
          predicates.always
        ],
    tcp = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            routers = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true
                  definitions.predicate.tcpRouter
                ],
            services = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true
                  definitions.predicate.tcpService
                ],
          }
          {  }
          true
          predicates.always
        ],
    tls = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            certificates = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      certFile = predicates.isType '"String",
                      keyFile = predicates.isType '"String",
                      stores = predicates.allOf
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
            options = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "[a-zA-Z0-9-_]+" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            cipherSuites = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            clientAuth = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    caFiles = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.isType '"String")
                                        ],
                                    clientAuthType = predicates.isType
                                        '"String",
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            curvePreferences = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            maxVersion = predicates.isType '"String",
                            minVersion = predicates.isType '"String",
                            preferServerCipherSuites = predicates.isType
                                '"Bool",
                            sniStrict = predicates.isType '"Bool",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                  }
                  false
                  predicates.never
                ],
            stores = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "[a-zA-Z0-9-_]+" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            defaultCertificate = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    certFile = predicates.isType '"String",
                                    keyFile = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            defaultGeneratedCert = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    domain = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            main = predicates.isType '"String",
                                            sans = predicates.allOf
                                                [
                                                  predicates.isType '"Array",
                                                  predicates.arrays.arrayOf
                                                  (predicates.isType '"String")
                                                ],
                                          }
                                          {  }
                                          true
                                          predicates.always
                                        ],
                                    resolver = predicates.isType '"String",
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
                  }
                  true
                  predicates.always
                ],
          }
          {  }
          false
          predicates.never
        ],
    udp = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            routers = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true
                  definitions.predicate.udpRouter
                ],
            services = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true
                  definitions.predicate.udpService
                ],
          }
          {  }
          false
          predicates.never
        ],
  }
  {  }
  false
  predicates.never
])