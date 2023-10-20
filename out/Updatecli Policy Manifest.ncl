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
{
  actions
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.oneOf
      [
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            kind = predicates.enum [ "github/pullrequest" ],
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    automerge = predicates.isType '"Bool",
                    description = predicates.isType '"String",
                    draft = predicates.isType '"Bool",
                    labels = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    maintainercannotmodify = predicates.isType '"Bool",
                    mergemethod = predicates.isType '"String",
                    parent = predicates.isType '"Bool",
                    title = predicates.isType '"String",
                    usetitleforautomerge = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ],
            title = predicates.isType '"String",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            kind = predicates.enum [ "gitea/pullrequest" ],
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    body = predicates.isType '"String",
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    sourcebranch = predicates.isType '"String",
                    targetbranch = predicates.isType '"String",
                    title = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            title = predicates.isType '"String",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            kind = predicates.enum [ "stash/pullrequest" ],
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    body = predicates.isType '"String",
                    owner = predicates.isType '"String",
                    password = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    sourcebranch = predicates.isType '"String",
                    targetbranch = predicates.isType '"String",
                    title = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            title = predicates.isType '"String",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            kind = predicates.enum [ "gitlab/mergerequest" ],
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    body = predicates.isType '"String",
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    sourcebranch = predicates.isType '"String",
                    targetbranch = predicates.isType '"String",
                    title = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            title = predicates.isType '"String",
          }
          {  }
          false
          predicates.never
        ]
      ])
    ])
    | doc m%"
    "actions" defines the list of action configurations which need to be managed.
    
    		examples:
    		---
    		actions:
    			default:
    				kind: github/pullrequest
    				scmid: default
    				spec:
    					automerge: true
    					labels:
    						- "dependencies"
    		---
    "%
    | optional,
  autodiscovery
    | {
      actionid
        | String
        | doc m%"
        actionid is a unique identifier used to retrieve the action configuration from the configuration file.
        "%
        | optional,
      crawlers
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            cargo = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    ignore = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { path = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    only = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { path = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    registries = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              auth = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      headerformat = predicates.isType
                                          '"String",
                                      token = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ],
                              rootdir = predicates.isType '"String",
                              scmid = predicates.isType '"String",
                              url = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    rootdir = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            dockercompose = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    auths = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              password = predicates.isType '"String",
                              token = predicates.isType '"String",
                              username = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    filematch = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    ignore = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              archs = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                              images = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                              path = predicates.isType '"String",
                              services = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    only = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              archs = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                              images = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                              path = predicates.isType '"String",
                              services = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    rootdir = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            dockerfile = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    auths = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              password = predicates.isType '"String",
                              token = predicates.isType '"String",
                              username = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    filematch = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    ignore = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              archs = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                              images = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                              path = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    only = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              archs = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                              images = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                              path = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    rootdir = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            "golang/gomod" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    ignore = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              goversion = predicates.isType '"String",
                              modules = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record {  } {  } true
                                    (predicates.isType '"String")
                                  ],
                              path = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    only = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              goversion = predicates.isType '"String",
                              modules = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record {  } {  } true
                                    (predicates.isType '"String")
                                  ],
                              path = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    rootdir = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            helm = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    auths = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              password = predicates.isType '"String",
                              token = predicates.isType '"String",
                              username = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    ignore = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { path = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    ignorechartdependency = predicates.isType '"Bool",
                    ignorecontainer = predicates.isType '"Bool",
                    only = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { path = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    rootdir = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    versionincrement = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            helmfile = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    auths = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              password = predicates.isType '"String",
                              token = predicates.isType '"String",
                              username = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    ignore = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { path = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    only = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { path = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    rootdir = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            maven = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    ignore = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { path = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    only = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { path = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    rootdir = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            npm = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    ignore = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { path = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    only = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { path = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    rootdir = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            "rancher/fleet" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    ignore = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { path = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    only = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { path = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    rootdir = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            terraform = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    ignore = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              path = predicates.isType '"String",
                              providers = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record {  } {  } true
                                    (predicates.isType '"String")
                                  ],
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    only = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              path = predicates.isType '"String",
                              providers = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record {  } {  } true
                                    (predicates.isType '"String")
                                  ],
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    rootdir = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
          true
          predicates.always
        ])
        | doc m%"
        Crawlers defines a map of crawler configuration where the key represent the crawler type
        "%
        | optional,
      groupby
        | String
        | doc m%"
        groupby specifies how to group pipeline. The Accepted is one of "all", "individual". Default is "all"
        
        		default:
        			all
        "%
        | optional,
      pullrequestid
        | String
        | doc m%"
        !Deprecated in favor of `actionid`
        "%
        | optional,
      scmid
        | String
        | doc m%"
        scmid is a unique identifier used to retrieve the scm configuration from the configuration file.
        "%
        | optional,
    }
    | doc m%"
    "autodiscovery" defines the configuration to automatically discover new versions update.
    
    		example:
    		---
    		autodiscovery:
    			scmid: default
    			actionid:  default
    			groupby: all
    			crawlers:
    				golang/gomod:
    					versionfilter:
    					kind: semver
    					pattern: patch
    		---
    "%
    | optional,
  conditions
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.oneOf
      [
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "stash/tag" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    owner = predicates.isType '"String",
                    password = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "gitea/tag" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "gitlab/tag" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository" ],
                  predicates.records.record
                  {
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "hcl" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    path = predicates.isType '"String",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "jenkins" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    release = predicates.isType '"String",
                    version = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "dockerdigest" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    architecture = predicates.isType '"String",
                    digest = predicates.isType '"String",
                    hidetag = predicates.isType '"Bool",
                    image = predicates.isType '"String",
                    password = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    username = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "githubrelease" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "owner", "repository", "token" ],
                  predicates.records.record
                  {
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    typefilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            draft = predicates.isType '"Bool",
                            latest = predicates.isType '"Bool",
                            prerelease = predicates.isType '"Bool",
                            release = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "yaml" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    key = predicates.isType '"String",
                    keyonly = predicates.isType '"Bool",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "cargopackage" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "package" ],
                  predicates.records.record
                  {
                    package = predicates.isType '"String",
                    registry = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            auth = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    headerformat = predicates.isType '"String",
                                    token = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            rootdir = predicates.isType '"String",
                            scmid = predicates.isType '"String",
                            url = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "dockerfile" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    instruction = predicates.always,
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "shell" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "command" ],
                  predicates.records.record
                  {
                    changedif = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              kind = predicates.enum [ "console/output" ],
                              spec = predicates.always,
                            }
                            {  }
                            false
                            predicates.never
                          ],
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              kind = predicates.enum [ "exitcode" ],
                              spec = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required
                                    [ "failure", "success", "warning" ],
                                    predicates.records.record
                                    {
                                      failure = predicates.isType 'Integer,
                                      success = predicates.isType 'Integer,
                                      warning = predicates.isType 'Integer,
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
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              kind = predicates.enum [ "file/checksum" ],
                              spec = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "files" ],
                                    predicates.records.record
                                    {
                                      files = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.isType '"String")
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
                          ]
                        ],
                    command = predicates.isType '"String",
                    environments = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "name" ],
                            predicates.records.record
                            {
                              name = predicates.isType '"String",
                              value = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    shell = predicates.isType '"String",
                    workdir = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "toml" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    createmissingkey = predicates.isType '"Bool",
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    key = predicates.isType '"String",
                    query = predicates.isType '"String",
                    value = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "xml" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    path = predicates.isType '"String",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "file" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    content = predicates.isType '"String",
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    forcecreate = predicates.isType '"Bool",
                    line = predicates.isType 'Integer,
                    matchpattern = predicates.isType '"String",
                    replacepattern = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "golang" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "golang/module" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "module" ],
                  predicates.records.record
                  {
                    module = predicates.isType '"String",
                    proxy = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "json" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    key = predicates.isType '"String",
                    query = predicates.isType '"String",
                    value = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "terraform/provider" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    provider = predicates.isType '"String",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "terraform/registry" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    hostname = predicates.isType '"String",
                    name = predicates.isType '"String",
                    namespace = predicates.isType '"String",
                    rawstring = predicates.isType '"String",
                    targetsystem = predicates.isType '"String",
                    type = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "aws/ami" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    accesskey = predicates.isType '"String",
                    dryrun = predicates.isType '"Bool",
                    endpoint = predicates.isType '"String",
                    filters = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              name = predicates.isType '"String",
                              values = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    region = predicates.isType '"String",
                    secretkey = predicates.isType '"String",
                    sortby = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "gitlab/branch" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository" ],
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "npm" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    name = predicates.isType '"String",
                    npmrcpath = predicates.isType '"String",
                    registrytoken = predicates.isType '"String",
                    url = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "terraform/lock" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    provider = predicates.isType '"String",
                    skipconstraints = predicates.isType '"Bool",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "gittag" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    key = predicates.isType '"String",
                    message = predicates.isType '"String",
                    path = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "gitbranch" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    path = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "gitea/release" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    commitish = predicates.isType '"String",
                    description = predicates.isType '"String",
                    draft = predicates.isType '"Bool",
                    owner = predicates.isType '"String",
                    prerelease = predicates.isType '"Bool",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    title = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "golang/gomod" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    indirect = predicates.isType '"Bool",
                    module = predicates.isType '"String",
                    version = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "helmchart" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    appversion = predicates.isType '"Bool",
                    file = predicates.isType '"String",
                    key = predicates.isType '"String",
                    name = predicates.isType '"String",
                    password = predicates.isType '"String",
                    skippackaging = predicates.isType '"Bool",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    value = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    versionincrement = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "stash/branch" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    owner = predicates.isType '"String",
                    password = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "csv" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    comma = predicates.isType 'Integer,
                    comment = predicates.isType 'Integer,
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    key = predicates.isType '"String",
                    query = predicates.isType '"String",
                    value = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "gitea/branch" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "maven" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    artifactid = predicates.isType '"String",
                    groupid = predicates.isType '"String",
                    repositories = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    repository = predicates.isType '"String",
                    url = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "terraform/file" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    path = predicates.isType '"String",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "dockerimage" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    architecture = predicates.isType '"String",
                    architectures = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    image = predicates.isType '"String",
                    password = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    tagfilter = predicates.isType '"String",
                    token = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            failwhen = predicates.isType '"Bool",
            kind = predicates.enum [ "gitlab/release" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository" ],
                  predicates.records.record
                  {
                    commitish = predicates.isType '"String",
                    description = predicates.isType '"String",
                    draft = predicates.isType '"Bool",
                    owner = predicates.isType '"String",
                    prerelease = predicates.isType '"Bool",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    title = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ]
      ])
    ])
    | doc m%"
    "conditions" defines the list of Updatecli condition definition.
    
    		example:
    		---
    		conditions:
    			container:
    				name: Check if Updatecli container image for tag "v0.63.0" exists
    				kind: dockerimage
    				spec:
    					image: "updatecli/updatecli:latest"
    					tag: "v0.63.0"
    		---
    "%
    | optional,
  name
    | String
    | doc m%"
    "name" defines a pipeline name
    
    		example:
    			* "name: 'deps: update nodejs version to latest stable'"
    
    		remark:
    			* using a short sentence describing the pipeline is a good way to name your pipeline.
    			* using conventional commits convention is a good way to name your pipeline.
    			* "name" is often used a default values for other configuration such as pullrequest title.
    			* "name" shouldn't contain any dynamic information such as source output.
    "%,
  pipelineid
    | String
    | doc m%"
    "pipelineid" allows to identify a full pipeline run.
    
    		example:
    			* "pipelineid: nodejs/dependencies"
    			* "pipelineid: gomod/github.com/updatecli/updatecli"
    			* "pipelineid: autodiscovery/gomodules/minor"
    
    		remark:
    			* "pipelineid" is used to generate uniq branch name for target update relying on scm configuration.
    			* The same "pipelineid" may be used by different Updatecli manifest" to ensure they are updated in the same workflow including pullrequest.
    "%,
  scms
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.oneOf
      [
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            disabled = predicates.isType '"Bool",
            kind = predicates.enum [ "gitlab" ],
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository" ],
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    commitmessage = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            body = predicates.isType '"String",
                            footers = predicates.isType '"String",
                            hidecredit = predicates.isType '"Bool",
                            scope = predicates.isType '"String",
                            title = predicates.isType '"String",
                            type = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    directory = predicates.isType '"String",
                    email = predicates.isType '"String",
                    "force" = predicates.isType '"Bool",
                    gpg = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            passphrase = predicates.isType '"String",
                            signingkey = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    user = predicates.isType '"String",
                    username = predicates.isType '"String",
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
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            disabled = predicates.isType '"Bool",
            kind = predicates.enum [ "stash" ],
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    commitmessage = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            body = predicates.isType '"String",
                            footers = predicates.isType '"String",
                            hidecredit = predicates.isType '"Bool",
                            scope = predicates.isType '"String",
                            title = predicates.isType '"String",
                            type = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    directory = predicates.isType '"String",
                    email = predicates.isType '"String",
                    "force" = predicates.isType '"Bool",
                    gpg = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            passphrase = predicates.isType '"String",
                            signingkey = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    owner = predicates.isType '"String",
                    password = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    user = predicates.isType '"String",
                    username = predicates.isType '"String",
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
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            disabled = predicates.isType '"Bool",
            kind = predicates.enum [ "git" ],
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "url" ],
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    commitmessage = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            body = predicates.isType '"String",
                            footers = predicates.isType '"String",
                            hidecredit = predicates.isType '"Bool",
                            scope = predicates.isType '"String",
                            title = predicates.isType '"String",
                            type = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    directory = predicates.isType '"String",
                    email = predicates.isType '"String",
                    "force" = predicates.isType '"Bool",
                    gpg = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            passphrase = predicates.isType '"String",
                            signingkey = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    password = predicates.isType '"String",
                    url = predicates.isType '"String",
                    user = predicates.isType '"String",
                    username = predicates.isType '"String",
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
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            disabled = predicates.isType '"Bool",
            kind = predicates.enum [ "gitea" ],
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    commitmessage = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            body = predicates.isType '"String",
                            footers = predicates.isType '"String",
                            hidecredit = predicates.isType '"Bool",
                            scope = predicates.isType '"String",
                            title = predicates.isType '"String",
                            type = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    directory = predicates.isType '"String",
                    email = predicates.isType '"String",
                    "force" = predicates.isType '"Bool",
                    gpg = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            passphrase = predicates.isType '"String",
                            signingkey = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    user = predicates.isType '"String",
                    username = predicates.isType '"String",
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
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            disabled = predicates.isType '"Bool",
            kind = predicates.enum [ "github" ],
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "owner", "repository", "token" ],
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    commitmessage = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            body = predicates.isType '"String",
                            footers = predicates.isType '"String",
                            hidecredit = predicates.isType '"Bool",
                            scope = predicates.isType '"String",
                            title = predicates.isType '"String",
                            type = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    directory = predicates.isType '"String",
                    email = predicates.isType '"String",
                    "force" = predicates.isType '"Bool",
                    gpg = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            passphrase = predicates.isType '"String",
                            signingkey = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    user = predicates.isType '"String",
                    username = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
          }
          {  }
          false
          predicates.never
        ]
      ])
    ])
    | doc m%"
    "scms" defines the list of repository configuration used to fetch content from.
    
    		examples:
    		---
    		scms:
    			default:
    				kind: github
    				spec:
    					owner: "updatecli"
    					repository: "updatecli"
    					token: "${{ env "GITHUB_TOKEN" }}"
    					branch: "main"
    		---
    "%
    | optional,
  sources
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.oneOf
      [
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "gitlab/branch" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository" ],
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "aws/ami" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    accesskey = predicates.isType '"String",
                    dryrun = predicates.isType '"Bool",
                    endpoint = predicates.isType '"String",
                    filters = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              name = predicates.isType '"String",
                              values = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    region = predicates.isType '"String",
                    secretkey = predicates.isType '"String",
                    sortby = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "gittag" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    key = predicates.isType '"String",
                    message = predicates.isType '"String",
                    path = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "file" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    content = predicates.isType '"String",
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    forcecreate = predicates.isType '"Bool",
                    line = predicates.isType 'Integer,
                    matchpattern = predicates.isType '"String",
                    replacepattern = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "gitlab/release" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository" ],
                  predicates.records.record
                  {
                    commitish = predicates.isType '"String",
                    description = predicates.isType '"String",
                    draft = predicates.isType '"Bool",
                    owner = predicates.isType '"String",
                    prerelease = predicates.isType '"Bool",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    title = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "xml" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    path = predicates.isType '"String",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "cargopackage" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "package" ],
                  predicates.records.record
                  {
                    package = predicates.isType '"String",
                    registry = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            auth = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    headerformat = predicates.isType '"String",
                                    token = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            rootdir = predicates.isType '"String",
                            scmid = predicates.isType '"String",
                            url = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "dockerdigest" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    architecture = predicates.isType '"String",
                    digest = predicates.isType '"String",
                    hidetag = predicates.isType '"Bool",
                    image = predicates.isType '"String",
                    password = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    username = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "gitea/branch" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "gitea/release" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    commitish = predicates.isType '"String",
                    description = predicates.isType '"String",
                    draft = predicates.isType '"Bool",
                    owner = predicates.isType '"String",
                    prerelease = predicates.isType '"Bool",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    title = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "terraform/file" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    path = predicates.isType '"String",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "toml" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    createmissingkey = predicates.isType '"Bool",
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    key = predicates.isType '"String",
                    query = predicates.isType '"String",
                    value = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "dockerfile" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    instruction = predicates.always,
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "gitbranch" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    path = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "stash/branch" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    owner = predicates.isType '"String",
                    password = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "terraform/registry" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    hostname = predicates.isType '"String",
                    name = predicates.isType '"String",
                    namespace = predicates.isType '"String",
                    rawstring = predicates.isType '"String",
                    targetsystem = predicates.isType '"String",
                    type = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "yaml" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    key = predicates.isType '"String",
                    keyonly = predicates.isType '"Bool",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "golang/module" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "module" ],
                  predicates.records.record
                  {
                    module = predicates.isType '"String",
                    proxy = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "npm" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    name = predicates.isType '"String",
                    npmrcpath = predicates.isType '"String",
                    registrytoken = predicates.isType '"String",
                    url = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "hcl" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    path = predicates.isType '"String",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "jenkins" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    release = predicates.isType '"String",
                    version = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "gitea/tag" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "golang/gomod" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    indirect = predicates.isType '"Bool",
                    module = predicates.isType '"String",
                    version = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "githubrelease" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "owner", "repository", "token" ],
                  predicates.records.record
                  {
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    typefilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            draft = predicates.isType '"Bool",
                            latest = predicates.isType '"Bool",
                            prerelease = predicates.isType '"Bool",
                            release = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "golang" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "helmchart" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    appversion = predicates.isType '"Bool",
                    file = predicates.isType '"String",
                    key = predicates.isType '"String",
                    name = predicates.isType '"String",
                    password = predicates.isType '"String",
                    skippackaging = predicates.isType '"Bool",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    value = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    versionincrement = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "stash/tag" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    owner = predicates.isType '"String",
                    password = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "csv" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    comma = predicates.isType 'Integer,
                    comment = predicates.isType 'Integer,
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    key = predicates.isType '"String",
                    query = predicates.isType '"String",
                    value = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "gitlab/tag" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository" ],
                  predicates.records.record
                  {
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "dockerimage" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    architecture = predicates.isType '"String",
                    architectures = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    image = predicates.isType '"String",
                    password = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    tagfilter = predicates.isType '"String",
                    token = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "json" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    key = predicates.isType '"String",
                    query = predicates.isType '"String",
                    value = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "terraform/lock" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    provider = predicates.isType '"String",
                    skipconstraints = predicates.isType '"Bool",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "terraform/provider" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    provider = predicates.isType '"String",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "maven" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    artifactid = predicates.isType '"String",
                    groupid = predicates.isType '"String",
                    repositories = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    repository = predicates.isType '"String",
                    url = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            kind = predicates.enum [ "shell" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "command" ],
                  predicates.records.record
                  {
                    changedif = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              kind = predicates.enum [ "console/output" ],
                              spec = predicates.always,
                            }
                            {  }
                            false
                            predicates.never
                          ],
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              kind = predicates.enum [ "exitcode" ],
                              spec = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required
                                    [ "failure", "success", "warning" ],
                                    predicates.records.record
                                    {
                                      failure = predicates.isType 'Integer,
                                      success = predicates.isType 'Integer,
                                      warning = predicates.isType 'Integer,
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
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              kind = predicates.enum [ "file/checksum" ],
                              spec = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "files" ],
                                    predicates.records.record
                                    {
                                      files = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.isType '"String")
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
                          ]
                        ],
                    command = predicates.isType '"String",
                    environments = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "name" ],
                            predicates.records.record
                            {
                              name = predicates.isType '"String",
                              value = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    shell = predicates.isType '"String",
                    workdir = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ]
      ])
    ])
    | doc m%"
    "sources" defines the list of Updatecli source definition.
    
    		example:
    		---
    		sources:
    			# Source to retrieve the latest version of nodejs
    			nodejs:
    				name: Get latest nodejs version
    				kind: json
    				spec:
    					file: https://nodejs.org/dist/index.json
    					key: .(lts!=false).version
    		---
    "%
    | optional,
  targets
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.oneOf
      [
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "gitea/branch" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "gitlab/branch" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository" ],
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "toml" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    createmissingkey = predicates.isType '"Bool",
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    key = predicates.isType '"String",
                    query = predicates.isType '"String",
                    value = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "dockerdigest" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    architecture = predicates.isType '"String",
                    digest = predicates.isType '"String",
                    hidetag = predicates.isType '"Bool",
                    image = predicates.isType '"String",
                    password = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    username = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "gitea/tag" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "gitlab/tag" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository" ],
                  predicates.records.record
                  {
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "shell" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "command" ],
                  predicates.records.record
                  {
                    changedif = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              kind = predicates.enum [ "console/output" ],
                              spec = predicates.always,
                            }
                            {  }
                            false
                            predicates.never
                          ],
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              kind = predicates.enum [ "exitcode" ],
                              spec = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required
                                    [ "failure", "success", "warning" ],
                                    predicates.records.record
                                    {
                                      failure = predicates.isType 'Integer,
                                      success = predicates.isType 'Integer,
                                      warning = predicates.isType 'Integer,
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
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              kind = predicates.enum [ "file/checksum" ],
                              spec = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "files" ],
                                    predicates.records.record
                                    {
                                      files = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.isType '"String")
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
                          ]
                        ],
                    command = predicates.isType '"String",
                    environments = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "name" ],
                            predicates.records.record
                            {
                              name = predicates.isType '"String",
                              value = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    shell = predicates.isType '"String",
                    workdir = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "terraform/lock" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    provider = predicates.isType '"String",
                    skipconstraints = predicates.isType '"Bool",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "cargopackage" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "package" ],
                  predicates.records.record
                  {
                    package = predicates.isType '"String",
                    registry = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            auth = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    headerformat = predicates.isType '"String",
                                    token = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            rootdir = predicates.isType '"String",
                            scmid = predicates.isType '"String",
                            url = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "golang/module" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "module" ],
                  predicates.records.record
                  {
                    module = predicates.isType '"String",
                    proxy = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "jenkins" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    release = predicates.isType '"String",
                    version = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "stash/branch" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    owner = predicates.isType '"String",
                    password = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "aws/ami" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    accesskey = predicates.isType '"String",
                    dryrun = predicates.isType '"Bool",
                    endpoint = predicates.isType '"String",
                    filters = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              name = predicates.isType '"String",
                              values = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    region = predicates.isType '"String",
                    secretkey = predicates.isType '"String",
                    sortby = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "xml" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    path = predicates.isType '"String",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "csv" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    comma = predicates.isType 'Integer,
                    comment = predicates.isType 'Integer,
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    key = predicates.isType '"String",
                    query = predicates.isType '"String",
                    value = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "dockerimage" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    architecture = predicates.isType '"String",
                    architectures = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    image = predicates.isType '"String",
                    password = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    tagfilter = predicates.isType '"String",
                    token = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "file" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    content = predicates.isType '"String",
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    forcecreate = predicates.isType '"Bool",
                    line = predicates.isType 'Integer,
                    matchpattern = predicates.isType '"String",
                    replacepattern = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "gitea/release" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    commitish = predicates.isType '"String",
                    description = predicates.isType '"String",
                    draft = predicates.isType '"Bool",
                    owner = predicates.isType '"String",
                    prerelease = predicates.isType '"Bool",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    title = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "gitlab/release" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository" ],
                  predicates.records.record
                  {
                    commitish = predicates.isType '"String",
                    description = predicates.isType '"String",
                    draft = predicates.isType '"Bool",
                    owner = predicates.isType '"String",
                    prerelease = predicates.isType '"Bool",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    title = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "hcl" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    path = predicates.isType '"String",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "terraform/registry" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    hostname = predicates.isType '"String",
                    name = predicates.isType '"String",
                    namespace = predicates.isType '"String",
                    rawstring = predicates.isType '"String",
                    targetsystem = predicates.isType '"String",
                    type = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "githubrelease" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "owner", "repository", "token" ],
                  predicates.records.record
                  {
                    owner = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    typefilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            draft = predicates.isType '"Bool",
                            latest = predicates.isType '"Bool",
                            prerelease = predicates.isType '"Bool",
                            release = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "golang/gomod" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    indirect = predicates.isType '"Bool",
                    module = predicates.isType '"String",
                    version = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "helmchart" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    appversion = predicates.isType '"Bool",
                    file = predicates.isType '"String",
                    key = predicates.isType '"String",
                    name = predicates.isType '"String",
                    password = predicates.isType '"String",
                    skippackaging = predicates.isType '"Bool",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    value = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    versionincrement = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "maven" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    artifactid = predicates.isType '"String",
                    groupid = predicates.isType '"String",
                    repositories = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    repository = predicates.isType '"String",
                    url = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "npm" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    name = predicates.isType '"String",
                    npmrcpath = predicates.isType '"String",
                    registrytoken = predicates.isType '"String",
                    url = predicates.isType '"String",
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "terraform/file" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    path = predicates.isType '"String",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "gittag" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    key = predicates.isType '"String",
                    message = predicates.isType '"String",
                    path = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "gitbranch" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    branch = predicates.isType '"String",
                    path = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "golang" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    version = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "stash/tag" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "owner", "repository", "url" ],
                  predicates.records.record
                  {
                    owner = predicates.isType '"String",
                    password = predicates.isType '"String",
                    repository = predicates.isType '"String",
                    tag = predicates.isType '"String",
                    token = predicates.isType '"String",
                    url = predicates.isType '"String",
                    username = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "terraform/provider" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    provider = predicates.isType '"String",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "yaml" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    key = predicates.isType '"String",
                    keyonly = predicates.isType '"Bool",
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "dockerfile" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    instruction = predicates.always,
                    value = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "kind" ],
          predicates.records.record
          {
            dependson = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            disablesourceinput = predicates.isType '"Bool",
            kind = predicates.enum [ "json" ],
            name = predicates.isType '"String",
            scmid = predicates.isType '"String",
            sourceid = predicates.isType '"String",
            spec = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    file = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    key = predicates.isType '"String",
                    query = predicates.isType '"String",
                    value = predicates.isType '"String",
                    versionfilter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            pattern = predicates.isType '"String",
                            strict = predicates.isType '"Bool",
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
            transformers = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      addprefix = predicates.isType '"String",
                      addsuffix = predicates.isType '"String",
                      find = predicates.isType '"String",
                      findsubmatch = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "pattern" ],
                            predicates.records.record
                            {
                              captureindex = predicates.isType 'Integer,
                              pattern = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacer = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "from", "to" ],
                            predicates.records.record
                            {
                              from = predicates.isType '"String",
                              to = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      replacers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "from", "to" ],
                              predicates.records.record
                              {
                                from = predicates.isType '"String",
                                to = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      semverinc = predicates.isType '"String",
                      trimprefix = predicates.isType '"String",
                      trimsuffix = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          false
          predicates.never
        ]
      ])
    ])
    | doc m%"
    "targets" defines the list of Updatecli target definition.
    
    		example:
    		---
    		targets:
    		  	default:
    		     	name: 'ci: update Golangci-lint version to {{ source "default" }}'
    		     	kind: yaml
    		     	spec:
    		         	file: .github/workflows/go.yaml
    		         	key: $.jobs.build.steps[2].with.version
    		     	scmid: default
    		     	sourceid: default
    		---
    "%
    | optional,
  version
    | String
    | doc m%"
    "version" defines the minimum Updatecli version compatible with the manifest
    "%
    | optional,
}