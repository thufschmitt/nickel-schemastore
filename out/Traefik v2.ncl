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

let rec definitions = { contract = {  }, predicate = {  }, } in
predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.record
  {
    accessLog = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            bufferingSize = predicates.isType 'Integer,
            fields = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    defaultMode = predicates.isType '"String",
                    headers = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            defaultMode = predicates.isType '"String",
                            names = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record {  }
                                  {
                                    "[a-zA-Z0-9-_]+" = predicates.isType
                                        '"String",
                                  }
                                  true
                                  predicates.always
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    names = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          { "[a-zA-Z0-9-_]+" = predicates.isType '"String", }
                          true
                          predicates.always
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
            filePath = predicates.isType '"String",
            filters = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    minDuration = predicates.isType '"String",
                    retryAttempts = predicates.isType '"Bool",
                    statusCodes = predicates.allOf
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
            format = predicates.isType '"String",
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
            dashboard = predicates.isType '"Bool",
            debug = predicates.isType '"Bool",
            insecure = predicates.isType '"Bool",
          }
          {  }
          false
          predicates.never
        ],
    certificatesResolvers = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "[a-zA-Z0-9-_]+" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    acme = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            caServer = predicates.isType '"String",
                            certificatesDuration = predicates.isType 'Integer,
                            dnsChallenge = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    delayBeforeCheck = predicates.isType
                                        '"String",
                                    disablePropagationCheck = predicates.isType
                                        '"Bool",
                                    provider = predicates.isType '"String",
                                    resolvers = predicates.allOf
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
                            eab = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    hmacEncoded = predicates.isType '"String",
                                    kid = predicates.isType '"String",
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            email = predicates.isType '"String",
                            httpChallenge = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  { entryPoint = predicates.isType '"String", }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            keyType = predicates.isType '"String",
                            preferredChain = predicates.isType '"String",
                            storage = predicates.isType '"String",
                            tlsChallenge = predicates.isType 'Record,
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
          }
          true
          predicates.always
        ],
    entryPoints = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "[a-zA-Z0-9-_]+" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    address = predicates.isType '"String",
                    forwardedHeaders = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            insecure = predicates.isType '"Bool",
                            trustedIPs = predicates.allOf
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
                    http = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            middlewares = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            redirections = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    entryPoint = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            permanent = predicates.isType
                                                '"Bool",
                                            "priority" = predicates.isType
                                                'Integer,
                                            scheme = predicates.isType
                                                '"String",
                                            to = predicates.isType '"String",
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
                                              main = predicates.isType
                                                  '"String",
                                              sans = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
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
                          true
                          predicates.always
                        ],
                    http2 = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          { maxConcurrentStreams = predicates.isType 'Integer, }
                          {  }
                          true
                          predicates.always
                        ],
                    http3 = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          { advertisedPort = predicates.isType 'Integer, }
                          {  }
                          true
                          predicates.always
                        ],
                    proxyProtocol = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            insecure = predicates.isType '"Bool",
                            trustedIPs = predicates.allOf
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
                    transport = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            lifeCycle = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    graceTimeOut = predicates.isType '"String",
                                    requestAcceptGraceTimeout =
                                      predicates.isType '"String",
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            respondingTimeouts = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    idleTimeout = predicates.isType '"String",
                                    readTimeout = predicates.isType '"String",
                                    writeTimeout = predicates.isType '"String",
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
                    udp = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          { timeout = predicates.isType '"String", }
                          {  }
                          true
                          predicates.always
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
    experimental = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            http3 = predicates.isType '"Bool",
            hub = predicates.isType '"Bool",
            kubernetesGateway = predicates.isType '"Bool",
            localPlugins = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "[a-zA-Z0-9-_]+" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          { moduleName = predicates.isType '"String", }
                          {  }
                          false
                          predicates.never
                        ],
                  }
                  true
                  predicates.always
                ],
            plugins = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "[a-zA-Z0-9-_]+" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            moduleName = predicates.isType '"String",
                            version = predicates.isType '"String",
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
    global = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            checkNewVersion = predicates.isType '"Bool",
            sendAnonymousUsage = predicates.isType '"Bool",
          }
          {  }
          false
          predicates.never
        ],
    hostResolver = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            cnameFlattening = predicates.isType '"Bool",
            resolvConfig = predicates.isType '"String",
            resolvDepth = predicates.isType 'Integer,
          }
          {  }
          false
          predicates.never
        ],
    hub = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            tls = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    ca = predicates.isType '"String",
                    cert = predicates.isType '"String",
                    insecure = predicates.isType '"Bool",
                    key = predicates.isType '"String",
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
    log = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            filePath = predicates.isType '"String",
            format = predicates.isType '"String",
            level = predicates.isType '"String",
          }
          {  }
          false
          predicates.never
        ],
    metrics = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            datadog = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    addEntryPointsLabels = predicates.isType '"Bool",
                    addRoutersLabels = predicates.isType '"Bool",
                    addServicesLabels = predicates.isType '"Bool",
                    address = predicates.isType '"String",
                    prefix = predicates.isType '"String",
                    pushInterval = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            influxDB = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    addEntryPointsLabels = predicates.isType '"Bool",
                    addRoutersLabels = predicates.isType '"Bool",
                    addServicesLabels = predicates.isType '"Bool",
                    additionalLabels = predicates.isType 'Record,
                    address = predicates.isType '"String",
                    database = predicates.isType '"String",
                    password = predicates.isType '"String",
                    protocol = predicates.isType '"String",
                    pushInterval = predicates.isType '"String",
                    retentionPolicy = predicates.isType '"String",
                    username = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            influxDB2 = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    addEntryPointsLabels = predicates.isType '"Bool",
                    addRoutersLabels = predicates.isType '"Bool",
                    addServicesLabels = predicates.isType '"Bool",
                    additionalLabels = predicates.isType 'Record,
                    address = predicates.isType '"String",
                    bucket = predicates.isType '"String",
                    org = predicates.isType '"String",
                    pushInterval = predicates.isType '"String",
                    token = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            prometheus = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    addEntryPointsLabels = predicates.isType '"Bool",
                    addRoutersLabels = predicates.isType '"Bool",
                    addServicesLabels = predicates.isType '"Bool",
                    buckets = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"Number")
                        ],
                    entryPoint = predicates.isType '"String",
                    manualRouting = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ],
            statsD = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    addEntryPointsLabels = predicates.isType '"Bool",
                    addRoutersLabels = predicates.isType '"Bool",
                    addServicesLabels = predicates.isType '"Bool",
                    address = predicates.isType '"String",
                    prefix = predicates.isType '"String",
                    pushInterval = predicates.isType '"String",
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
    pilot = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            dashboard = predicates.isType '"Bool",
            token = predicates.isType '"String",
          }
          {  }
          false
          predicates.never
        ],
    ping = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            entryPoint = predicates.isType '"String",
            manualRouting = predicates.isType '"Bool",
            terminatingStatusCode = predicates.isType 'Integer,
          }
          {  }
          false
          predicates.never
        ],
    providers = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            consul = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    endpoints = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    namespace = predicates.isType '"String",
                    namespaces = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    rootKey = predicates.isType '"String",
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
                          false
                          predicates.never
                        ],
                    token = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            consulCatalog = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    cache = predicates.isType '"Bool",
                    connectAware = predicates.isType '"Bool",
                    connectByDefault = predicates.isType '"Bool",
                    constraints = predicates.isType '"String",
                    defaultRule = predicates.isType '"String",
                    endpoint = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            address = predicates.isType '"String",
                            datacenter = predicates.isType '"String",
                            endpointWaitTime = predicates.isType '"String",
                            httpAuth = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    password = predicates.isType '"String",
                                    username = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            scheme = predicates.isType '"String",
                            tls = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    ca = predicates.isType '"String",
                                    caOptional = predicates.isType '"Bool",
                                    cert = predicates.isType '"String",
                                    insecureSkipVerify = predicates.isType
                                        '"Bool",
                                    key = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            token = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    exposedByDefault = predicates.isType '"Bool",
                    namespace = predicates.isType '"String",
                    namespaces = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    prefix = predicates.isType '"String",
                    refreshInterval = predicates.isType '"String",
                    requireConsistent = predicates.isType '"Bool",
                    serviceName = predicates.isType '"String",
                    stale = predicates.isType '"Bool",
                    watch = predicates.isType '"Bool",
                  }
                  {  }
                  true
                  predicates.always
                ],
            docker = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    allowEmptyServices = predicates.isType '"Bool",
                    constraints = predicates.isType '"String",
                    defaultRule = predicates.isType '"String",
                    endpoint = predicates.isType '"String",
                    exposedByDefault = predicates.isType '"Bool",
                    httpClientTimeout = predicates.isType '"String",
                    network = predicates.isType '"String",
                    swarmMode = predicates.isType '"Bool",
                    swarmModeRefreshSeconds = predicates.isType '"String",
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
                          false
                          predicates.never
                        ],
                    useBindPortIP = predicates.isType '"Bool",
                    watch = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ],
            ecs = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    accessKeyID = predicates.isType '"String",
                    autoDiscoverClusters = predicates.isType '"Bool",
                    clusters = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    constraints = predicates.isType '"String",
                    defaultRule = predicates.isType '"String",
                    ecsAnywhere = predicates.isType '"Bool",
                    exposedByDefault = predicates.isType '"Bool",
                    refreshSeconds = predicates.isType 'Integer,
                    region = predicates.isType '"String",
                    secretAccessKey = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            etcd = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    endpoints = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    password = predicates.isType '"String",
                    rootKey = predicates.isType '"String",
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
                          false
                          predicates.never
                        ],
                    username = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            file = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    debugLogGeneratedTemplate = predicates.isType '"Bool",
                    directory = predicates.isType '"String",
                    filename = predicates.isType '"String",
                    watch = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ],
            http = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    endpoint = predicates.isType '"String",
                    pollInterval = predicates.isType '"String",
                    pollTimeout = predicates.isType '"String",
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
                          false
                          predicates.never
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
            kubernetesCRD = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    allowCrossNamespace = predicates.isType '"Bool",
                    allowEmptyServices = predicates.isType '"Bool",
                    allowExternalNameServices = predicates.isType '"Bool",
                    certAuthFilePath = predicates.isType '"String",
                    endpoint = predicates.isType '"String",
                    ingressClass = predicates.isType '"String",
                    labelSelector = predicates.isType '"String",
                    namespaces = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    throttleDuration = predicates.isType '"String",
                    token = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            kubernetesGateway = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    certAuthFilePath = predicates.isType '"String",
                    endpoint = predicates.isType '"String",
                    labelSelector = predicates.isType '"String",
                    namespaces = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    throttleDuration = predicates.isType '"String",
                    token = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            kubernetesIngress = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    allowEmptyServices = predicates.isType '"Bool",
                    allowExternalNameServices = predicates.isType '"Bool",
                    certAuthFilePath = predicates.isType '"String",
                    endpoint = predicates.isType '"String",
                    ingressClass = predicates.isType '"String",
                    ingressEndpoint = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            hostname = predicates.isType '"String",
                            ip = predicates.isType '"String",
                            publishedService = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    labelSelector = predicates.isType '"String",
                    namespaces = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    throttleDuration = predicates.isType '"String",
                    token = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            marathon = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    basic = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            httpBasicAuthUser = predicates.isType '"String",
                            httpBasicPassword = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    constraints = predicates.isType '"String",
                    dcosToken = predicates.isType '"String",
                    defaultRule = predicates.isType '"String",
                    dialerTimeout = predicates.isType '"String",
                    endpoint = predicates.isType '"String",
                    exposedByDefault = predicates.isType '"Bool",
                    forceTaskHostname = predicates.isType '"Bool",
                    keepAlive = predicates.isType '"String",
                    respectReadinessChecks = predicates.isType '"Bool",
                    responseHeaderTimeout = predicates.isType '"String",
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
                          false
                          predicates.never
                        ],
                    tlsHandshakeTimeout = predicates.isType '"String",
                    trace = predicates.isType '"Bool",
                    watch = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ],
            nomad = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    constraints = predicates.isType '"String",
                    defaultRule = predicates.isType '"String",
                    endpoint = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            address = predicates.isType '"String",
                            endpointWaitTime = predicates.isType '"String",
                            region = predicates.isType '"String",
                            tls = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    ca = predicates.isType '"String",
                                    caOptional = predicates.isType '"Bool",
                                    cert = predicates.isType '"String",
                                    insecureSkipVerify = predicates.isType
                                        '"Bool",
                                    key = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            token = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    exposedByDefault = predicates.isType '"Bool",
                    namespace = predicates.isType '"String",
                    prefix = predicates.isType '"String",
                    refreshInterval = predicates.isType '"String",
                    stale = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ],
            plugin = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  { "[a-zA-Z0-9-_]+" = predicates.isType 'Record, }
                  true
                  predicates.always
                ],
            providersThrottleDuration = predicates.isType '"String",
            rancher = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    constraints = predicates.isType '"String",
                    defaultRule = predicates.isType '"String",
                    enableServiceHealthFilter = predicates.isType '"Bool",
                    exposedByDefault = predicates.isType '"Bool",
                    intervalPoll = predicates.isType '"Bool",
                    prefix = predicates.isType '"String",
                    refreshSeconds = predicates.isType 'Integer,
                    watch = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ],
            redis = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    db = predicates.isType 'Integer,
                    endpoints = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    password = predicates.isType '"String",
                    rootKey = predicates.isType '"String",
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
                          false
                          predicates.never
                        ],
                    username = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            rest = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  { insecure = predicates.isType '"Bool", }
                  {  }
                  false
                  predicates.never
                ],
            zooKeeper = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    endpoints = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    password = predicates.isType '"String",
                    rootKey = predicates.isType '"String",
                    username = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
          }
          {  }
          true
          predicates.always
        ],
    serversTransport = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            forwardingTimeouts = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    dialTimeout = predicates.isType '"String",
                    idleConnTimeout = predicates.isType '"String",
                    responseHeaderTimeout = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            insecureSkipVerify = predicates.isType '"Bool",
            maxIdleConnsPerHost = predicates.isType 'Integer,
            rootCAs = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
          }
          {  }
          false
          predicates.never
        ],
    tracing = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            datadog = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    bagagePrefixHeaderName = predicates.isType '"String",
                    debug = predicates.isType '"Bool",
                    globalTag = predicates.isType '"String",
                    globalTags = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          { "[a-zA-Z0-9-_]+" = predicates.isType '"String", }
                          true
                          predicates.always
                        ],
                    localAgentHostPort = predicates.isType '"String",
                    parentIDHeaderName = predicates.isType '"String",
                    prioritySampling = predicates.isType '"Bool",
                    samplingPriorityHeaderName = predicates.isType '"String",
                    traceIDHeaderName = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            elastic = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    secretToken = predicates.isType '"String",
                    serverURL = predicates.isType '"String",
                    serviceEnvironment = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            haystack = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    baggagePrefixHeaderName = predicates.isType '"String",
                    globalTag = predicates.isType '"String",
                    localAgentHost = predicates.isType '"String",
                    localAgentPort = predicates.isType 'Integer,
                    parentIDHeaderName = predicates.isType '"String",
                    spanIDHeaderName = predicates.isType '"String",
                    traceIDHeaderName = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            instana = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    enableAutoProfile = predicates.isType '"Bool",
                    localAgentHost = predicates.isType '"String",
                    localAgentPort = predicates.isType 'Integer,
                    logLevel = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            jaeger = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    collector = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            endpoint = predicates.isType '"String",
                            password = predicates.isType '"String",
                            user = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    disableAttemptReconnecting = predicates.isType '"Bool",
                    gen128Bit = predicates.isType '"Bool",
                    localAgentHostPort = predicates.isType '"String",
                    propagation = predicates.isType '"String",
                    samplingParam = predicates.isType 'Integer,
                    samplingServerURL = predicates.isType '"String",
                    samplingType = predicates.isType '"String",
                    traceContextHeaderName = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            serviceName = predicates.isType '"String",
            spanNameLimit = predicates.isType 'Integer,
            zipkin = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    httpEndpoint = predicates.isType '"String",
                    id128Bit = predicates.isType '"Bool",
                    sameSpan = predicates.isType '"Bool",
                    sampleRate = predicates.isType 'Integer,
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
  {  }
  false
  predicates.never
])