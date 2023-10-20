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
          azureFunction = {
                args
                  | String
                  | doc m%"
                  Command-line arguments to use when launching.
                  "%
                  | optional,
                azureFunction
                  | String
                  | doc m%"
                  The directory path to the azure function.
                  "%,
                bindings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.binding
                  ])
                  | doc m%"
                  The bindings provided by the service.
                  "%
                  | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.env-var
                  ])
                  | doc m%"
                  Environment variables to use when launching.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The service name. Must be unique per-application.
                  "%,
                pathToFunc
                  | String
                  | doc m%"
                  Optional path to the function host to be used when launching functions. Can point to either func.dll or the binary.
                  "%
                  | optional,
                replicas
                  | std.number.Integer
                  | doc m%"
                  Number of service replicas to create.
                  "%
                  | optional,
                ..
              },
          binding = {
                autoAssignPort
                  | Bool
                  | doc m%"
                  Whether to auto-assign a port value.
                  "%
                  | optional,
                connectionString
                  | String
                  | doc m%"
                  The connection string.
                  "%
                  | optional,
                containerPort
                  | std.number.Integer
                  | doc m%"
                  The port used when running inside a container.
                  "%
                  | optional,
                host
                  | String
                  | doc m%"
                  The hostname for the binding.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The binding name.
                  "%
                  | optional,
                port
                  | std.number.Integer
                  | doc m%"
                  The binding port.
                  "%
                  | optional,
                protocol
                  | String
                  | doc m%"
                  The protocol used by the binding
                  "%
                  | optional,
              },
          build-property = {
                name
                  | String
                  | doc m%"
                  Build property name.
                  "%,
                value
                  | String
                  | doc m%"
                  Build property name.
                  "%,
              },
          dockerFile = {
                args
                  | String
                  | doc m%"
                  Command-line arguments to use when launching.
                  "%
                  | optional,
                bindings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.binding
                  ])
                  | doc m%"
                  The bindings provided by the service.
                  "%
                  | optional,
                dockerFile
                  | String
                  | doc m%"
                  The Dockerfile to use.
                  "%,
                dockerFileArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType 'Record)
                  ])
                  | doc m%"
                  Build arguments to use when building the image.
                  "%
                  | optional,
                dockerFileContext
                  | String
                  | doc m%"
                  The Dockerfile context to run docker build on.
                  "%
                  | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.env-var
                  ])
                  | doc m%"
                  Environment variables to use when launching.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The service name. Must be unique per-application.
                  "%,
                replicas
                  | std.number.Integer
                  | doc m%"
                  Number of service replicas to create.
                  "%
                  | optional,
                volumes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.volume
                  ])
                  | doc m%"
                  Volumes to mount to the container.
                  "%
                  | optional,
                ..
              },
          env-var = {
                name
                  | String
                  | doc m%"
                  Environment variable name.
                  "%,
                value
                  | String
                  | doc m%"
                  Environment variable value.
                  "%,
              },
          executable = {
                args
                  | String
                  | doc m%"
                  Command-line arguments to use when launching.
                  "%
                  | optional,
                bindings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.binding
                  ])
                  | doc m%"
                  The bindings provided by the service.
                  "%
                  | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.env-var
                  ])
                  | doc m%"
                  Environment variables to use when launching.
                  "%
                  | optional,
                executable
                  | String
                  | doc m%"
                  The file path (or file name if on the system path) of an executable.
                  "%,
                name
                  | String
                  | doc m%"
                  The service name. Must be unique per-application.
                  "%,
                replicas
                  | std.number.Integer
                  | doc m%"
                  Number of service replicas to create.
                  "%
                  | optional,
                workingDirectory
                  | String
                  | doc m%"
                  The working directory to use when launching.
                  "%
                  | optional,
                ..
              },
          extension = {
                name
                  | String
                  | doc m%"
                  Extension name.
                  "%,
                ..
              },
          external = predicates.contract_from_predicate
              definitions.predicate.external,
          image = {
                args
                  | String
                  | doc m%"
                  Command-line arguments to use when launching.
                  "%
                  | optional,
                bindings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.binding
                  ])
                  | doc m%"
                  The bindings provided by the service.
                  "%
                  | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.env-var
                  ])
                  | doc m%"
                  Environment variables to use when launching.
                  "%
                  | optional,
                image
                  | String
                  | doc m%"
                  The name of a Docker image.
                  "%,
                name
                  | String
                  | doc m%"
                  The service name. Must be unique per-application.
                  "%,
                replicas
                  | std.number.Integer
                  | doc m%"
                  Number of service replicas to create.
                  "%
                  | optional,
                volumes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.volume
                  ])
                  | doc m%"
                  Volumes to mount to the container.
                  "%
                  | optional,
                ..
              },
          include = predicates.contract_from_predicate
              definitions.predicate.include,
          ingress = {
                bindings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ingress-binding
                  ])
                  | doc m%"
                  Bindings for the ingress in local development.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The ingress name.
                  "%
                  | optional,
                rules
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.ingress-rule
                  ])
                  | doc m%"
                  Rules for ingress routing.
                  "%
                  | optional,
                ..
              },
          ingress-binding = {
                ip
                  | String
                  | doc m%"
                  The ip address the ingress listens on.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The binding name.
                  "%
                  | optional,
                port
                  | std.number.Integer
                  | doc m%"
                  The binding port.
                  "%
                  | optional,
                protocol
                  | String
                  | doc m%"
                  The protocol used by the binding
                  "%
                  | optional,
                ..
              },
          ingress-rule = {
                host
                  | String
                  | doc m%"
                  The hostname to match.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  The path prefix to match.
                  "%
                  | optional,
                preservePath
                  | Bool
                  | doc m%"
                  Whether to keep the path that was originally present or not after a prefix match.
                  "%
                  | optional,
                service
                  | String
                  | doc m%"
                  The service to route traffic when the rule matches.
                  "%,
                ..
              },
          project = {
                args
                  | String
                  | doc m%"
                  Command-line arguments to use when launching.
                  "%
                  | optional,
                bindings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.binding
                  ])
                  | doc m%"
                  The bindings provided by the service.
                  "%
                  | optional,
                build
                  | Bool
                  | doc m%"
                  Whether to build the project.
                  "%
                  | optional,
                buildProperties
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.build-property
                  ])
                  | doc m%"
                  Build properties to use when launching or building a project.
                  "%
                  | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.env-var
                  ])
                  | doc m%"
                  Environment variables to use when launching.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The service name. Must be unique per-application.
                  "%,
                project
                  | String
                  | doc m%"
                  The relative path to a .NET project file.
                  "%,
                replicas
                  | std.number.Integer
                  | doc m%"
                  Number of service replicas to create.
                  "%
                  | optional,
                ..
              },
          repository = predicates.contract_from_predicate
              definitions.predicate.repository,
          volume = {
                name
                  | String
                  | doc m%"
                  A named volume.
                  "%
                  | optional,
                source
                  | String
                  | doc m%"
                  The local path.
                  "%
                  | optional,
                target
                  | String
                  | doc m%"
                  The destination path within the container.
                  "%,
              },
        },
    predicate = {
          azureFunction = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "azureFunction", "name" ],
                predicates.records.record
                {
                  args = predicates.isType '"String",
                  azureFunction = predicates.isType '"String",
                  bindings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.binding
                      ],
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.env-var
                      ],
                  name = predicates.isType '"String",
                  pathToFunc = predicates.isType '"String",
                  replicas = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          binding = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  autoAssignPort = predicates.isType '"Bool",
                  connectionString = predicates.isType '"String",
                  containerPort = predicates.isType 'Integer,
                  host = predicates.isType '"String",
                  name = predicates.isType '"String",
                  port = predicates.isType 'Integer,
                  protocol = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          build-property = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "value" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          dockerFile = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "dockerFile", "name" ],
                predicates.records.record
                {
                  args = predicates.isType '"String",
                  bindings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.binding
                      ],
                  dockerFile = predicates.isType '"String",
                  dockerFileArgs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType 'Record)
                      ],
                  dockerFileContext = predicates.isType '"String",
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.env-var
                      ],
                  name = predicates.isType '"String",
                  replicas = predicates.isType 'Integer,
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.volume
                      ],
                }
                {  }
                true
                predicates.always
              ],
          env-var = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "value" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          executable = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "executable", "name" ],
                predicates.records.record
                {
                  args = predicates.isType '"String",
                  bindings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.binding
                      ],
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.env-var
                      ],
                  executable = predicates.isType '"String",
                  name = predicates.isType '"String",
                  replicas = predicates.isType 'Integer,
                  workingDirectory = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          extension = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                { name = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          external = predicates.records.record
              {
                bindings = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.binding
                    ],
                external = predicates.allOf
                    [ predicates.isType '"Bool", predicates.const true ],
                name = predicates.isType '"String",
              }
              {  }
              false
              predicates.never,
          image = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image", "name" ],
                predicates.records.record
                {
                  args = predicates.isType '"String",
                  bindings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.binding
                      ],
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.env-var
                      ],
                  image = predicates.isType '"String",
                  name = predicates.isType '"String",
                  replicas = predicates.isType 'Integer,
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.volume
                      ],
                }
                {  }
                true
                predicates.always
              ],
          include = predicates.allOf
              [
                predicates.records.required [ "include", "name" ],
                predicates.records.record
                {
                  include = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          ingress = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bindings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ingress-binding
                      ],
                  name = predicates.isType '"String",
                  rules = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ingress-rule
                      ],
                }
                {  }
                true
                predicates.always
              ],
          ingress-binding = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ip = predicates.isType '"String",
                  name = predicates.isType '"String",
                  port = predicates.isType 'Integer,
                  protocol = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          ingress-rule = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "service" ],
                predicates.records.record
                {
                  host = predicates.isType '"String",
                  path = predicates.isType '"String",
                  preservePath = predicates.isType '"Bool",
                  service = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          project = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "project" ],
                predicates.records.record
                {
                  args = predicates.isType '"String",
                  bindings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.binding
                      ],
                  build = predicates.isType '"Bool",
                  buildProperties = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.build-property
                      ],
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.env-var
                      ],
                  name = predicates.isType '"String",
                  project = predicates.isType '"String",
                  replicas = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          repository = predicates.allOf
              [
                predicates.records.required [ "name", "repository" ],
                predicates.records.record
                {
                  cloneDirectory = predicates.isType '"String",
                  name = predicates.isType '"String",
                  repository = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          volume = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "target" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  source = predicates.isType '"String",
                  target = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

{
  containerEngine
    | std.enum.TagOrString
    | [| 'podman, 'docker |]
    | doc m%"
    Container engine.
    "%
    | optional,
  dashboardPort
    | std.number.Integer
    | doc m%"
    Configure the dashboard port used for `tye run`. Can be overridden using the `--port` CLI argument, and falls back to port 8000 if free, or a random port if 8000 is in use.
    "%
    | optional,
  extensions
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.extension
    ])
    | doc m%"
    Extensions to be added to tye.
    "%
    | optional,
  ingress
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.ingress,
      predicates.arrays.minItems 1
    ])
    | doc m%"
    The application's ingresses.
    "%
    | optional,
  name
    | String
    | doc m%"
    The application name.
    "%
    | optional,
  namespace
    | String
    | doc m%"
    The Kubernetes namespace to use.
    "%
    | optional,
  network
    | String
    | doc m%"
    The Docker network to use.
    "%
    | optional,
  registry
    | String
    | doc m%"
    Dockerhub username or hostname of remote registry. Used for tagging images.
    "%
    | optional,
  services
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.oneOf
        [
          definitions.predicate.executable,
          definitions.predicate.external,
          definitions.predicate.azureFunction,
          definitions.predicate.image,
          definitions.predicate.dockerFile,
          definitions.predicate.project,
          definitions.predicate.repository,
          definitions.predicate.include
        ]
      ]),
      predicates.arrays.minItems 1
    ])
    | doc m%"
    The application's services.
    "%,
  solution
    | String
    | doc m%"
    Indicates the solution file (.sln) or filter (.slnf) to use when building project-based services in watch mode. If omitted, those services will be built individually. Specifying the solution [filter] can help reduce repeated builds of shared libraries when in watch mode.
    "%
    | optional,
  ..
}