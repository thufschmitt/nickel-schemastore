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
          Metadata = {
                clone
                  | Bool
                  | doc m%"
                  Enables injecting the default clone process.
                  Reference: https://go-vela.github.io/docs/reference/yaml/metadata/#the-clone-tag
                  "%
                  | optional,
                environment
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Controls which containers processes can have global env injected.
                  Reference: https://go-vela.github.io/docs/reference/yaml/metadata/#the-environment-tag
                  "%
                  | optional,
                render_inline
                  | Bool
                  | doc m%"
                  Enables inline compiling for the pipeline templates.
                  Reference: https://go-vela.github.io/docs/reference/yaml/metadata/#the-render-inline-tag
                  "%
                  | optional,
                template
                  | Bool
                  | doc m%"
                  Enables compiling the pipeline as a template.
                  Reference: https://go-vela.github.io/docs/reference/yaml/metadata/#the-template-tag
                  "%
                  | optional,
              },
          Origin = {
                environment
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  }
                      { ".*" = predicates.isType '"String", }
                      false
                      predicates.never
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.records.record {  } {  } false predicates.never
                    ]
                  ])
                  | doc m%"
                  Variables to inject into the container environment.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-environment-tag
                  "%
                  | optional,
                image
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Docker image to use to create the ephemeral container.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-image-tag
                  "%,
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Unique name for the secret origin.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-name-tag
                  "%,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.records.record {  } {  } true
                          predicates.always,
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Extra configuration variables for the secret plugin.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-parameters-tag
                  "%
                  | optional,
                pull
                  | std.enum.TagOrString
                  | [| 'never, 'on_start, 'not_present, 'always |]
                  | doc m%"
                  Declaration to configure if and when the Docker image is pulled.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-pull-tag
                  "%
                  | optional,
                ruleset
                  | predicates.contract_from_predicate
                  definitions.predicate.Ruleset
                  | doc m%"
                  Conditions to limit the execution of the container.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-ruleset-tag
                  "%
                  | optional,
                secrets
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.records.record {  } {  } false
                        predicates.never
                      ])
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.StepSecret
                    ]
                  ])
                  | doc m%"
                  Secrets to inject that are necessary to retrieve the secrets.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-secrets-tag
                  "%
                  | optional,
              },
          Rules = {
                branch
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  Limits the execution of a step to matching build branches.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-ruleset-tag
                  "%
                  | optional,
                comment
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  Limits the execution of a step to matching a pull request comment.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-ruleset-tag
                  "%
                  | optional,
                event
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum
                      [
                        "comment",
                        "comment:created",
                        "comment:edited",
                        "deployment",
                        "pull_request",
                        "pull_request:edited",
                        "pull_request:opened",
                        "pull_request:synchronize",
                        "push",
                        "tag"
                      ]
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "comment",
                          "comment:created",
                          "comment:edited",
                          "deployment",
                          "pull_request",
                          "pull_request:edited",
                          "pull_request:opened",
                          "pull_request:synchronize",
                          "push",
                          "tag"
                        ]
                      ])
                    ]
                  ])
                  | doc m%"
                  Limits the execution of a step to matching build events.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-ruleset-tag
                  "%
                  | optional,
                path
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  Limits the execution of a step to matching files changed in a repository.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-ruleset-tag
                  "%
                  | optional,
                repo
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  Limits the execution of a step to matching repos.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-ruleset-tag
                  "%
                  | optional,
                status
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "failure", "success" ]
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "failure", "success" ]
                      ])
                    ]
                  ])
                  | doc m%"
                  Limits the execution of a step to matching build statuses.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-ruleset-tag
                  "%
                  | optional,
                tag
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  Limits the execution of a step to matching build tag references.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-ruleset-tag
                  "%
                  | optional,
                target
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  Limits the execution of a step to matching build deployment targets.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-ruleset-tag
                  "%
                  | optional,
              },
          Ruleset = predicates.contract_from_predicate
              definitions.predicate.Ruleset,
          Secret = {
                engine
                  | std.enum.TagOrString
                  | [| 'vault, 'native |]
                  | doc m%"
                  Name of storage backend to fetch secret from.
                  Reference: https://go-vela.github.io/docs/reference/yaml/secrets/#the-engine-tag
                  "%
                  | optional,
                key
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Path to secret to fetch from storage backend.
                  Reference: https://go-vela.github.io/docs/reference/yaml/secrets/#the-key-tag
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Name of secret to reference in the pipeline.
                  Reference: https://go-vela.github.io/docs/reference/yaml/secrets/#the-name-tag
                  "%,
                origin
                  | predicates.contract_from_predicate
                  definitions.predicate.Origin
                  | doc m%"
                  Declaration to pull secrets from non-internal secret providers.
                  Reference: https://go-vela.github.io/docs/reference/yaml/secrets/#the-origin-tag
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'shared, 'org, 'repo |]
                  | doc m%"
                  Type of secret to fetch from storage backend.
                  Reference: https://go-vela.github.io/docs/reference/yaml/secrets/#the-type-tag
                  "%
                  | optional,
              },
          Service = {
                entrypoint
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  Commands to execute inside the container.
                  Reference: https://go-vela.github.io/docs/reference/yaml/services/#the-entrypoint-tag
                  "%
                  | optional,
                environment
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  }
                      { ".*" = predicates.isType '"String", }
                      false
                      predicates.never
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.records.record {  } {  } false predicates.never
                    ]
                  ])
                  | doc m%"
                  Variables to inject into the container environment.
                  Reference: https://go-vela.github.io/docs/reference/yaml/services/#the-environment-tag
                  "%
                  | optional,
                image
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Docker image used to create ephemeral container.
                  Reference: https://go-vela.github.io/docs/reference/yaml/services/#the-image-tag
                  "%,
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Unique identifier for the container in the pipeline.
                  Reference: https://go-vela.github.io/docs/reference/yaml/services/#the-name-tag
                  "%,
                ports
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  List of ports to map for the container in the pipeline.
                  Reference: https://go-vela.github.io/docs/reference/yaml/services/#the-ports-tag
                  "%
                  | optional,
                pull
                  | std.enum.TagOrString
                  | [| 'never, 'on_start, 'not_present, 'always |]
                  | doc m%"
                  Declaration to configure if and when the Docker image is pulled.
                  Reference: https://go-vela.github.io/docs/reference/yaml/services/#the-pul-tag
                  "%
                  | optional,
                ulimits
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Ulimit
                  ])
                  | doc m%"
                  Set the user limits for the container.
                  Reference: https://go-vela.github.io/docs/reference/yaml/services/#the-ulimits-tag
                  "%
                  | optional,
                user
                  | String
                  | doc m%"
                  Set the user for the container.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-user-tag
                  "%
                  | optional,
              },
          Stage = {
                environment
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  }
                      { ".*" = predicates.isType '"String", }
                      false
                      predicates.never
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.records.record {  } {  } false predicates.never
                    ]
                  ])
                  | doc m%"
                  Provide environment variables injected into the container environment.
                  Reference: https://go-vela.github.io/docs/reference/yaml/stages/#the-environment-tag
                  "%
                  | optional,
                independent
                  | Bool
                  | doc m%"
                  Stage will continue executing if other stage fails
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Unique identifier for the stage in the pipeline.
                  Reference: https://go-vela.github.io/docs/reference/yaml/stages/#the-name-tag
                  "%
                  | optional,
                needs
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  Stages that must complete before starting the current one.
                  Reference: https://go-vela.github.io/docs/reference/yaml/stages/#the-needs-tag
                  "%
                  | optional,
                steps
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Step
                  ])
                  | doc m%"
                  Sequential execution instructions for the stage.
                  Reference: https://go-vela.github.io/docs/reference/yaml/stages/#the-steps-tag
                  "%,
              },
          Step = predicates.contract_from_predicate definitions.predicate.Step,
          StepSecret = {
                source | String | optional,
                target | String | optional,
              },
          StepTemplate = {
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Unique identifier for the template.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-template-tag
                  "%,
                vars
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.records.record {  } {  } true
                          predicates.always,
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Variables injected into the template.
                  Reference: https://go-vela.github.io/docs/reference/yaml/steps/#the-template-tag
                  "%
                  | optional,
              },
          Template = {
                format
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ "starlark", "golang", "go" ],
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  language used within the template file 
                  Reference: https://go-vela.github.io/docs/reference/yaml/templates/#the-format-tag
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Unique identifier for the template.
                  Reference: https://go-vela.github.io/docs/reference/yaml/templates/#the-name-tag
                  "%,
                source
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Path to template in remote system.
                  Reference: https://go-vela.github.io/docs/reference/yaml/templates/#the-source-tag
                  "%,
                type
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Type of template provided from the remote system.
                  Reference: https://go-vela.github.io/docs/reference/yaml/templates/#the-type-tag
                  "%
                  | optional,
                vars
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.records.record {  } {  } true
                          predicates.always,
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Variables injected into the template.
                  Reference: https://go-vela.github.io/docs/reference/yaml/templates/#the-variables-tag
                  "%
                  | optional,
              },
          Ulimit = predicates.contract_from_predicate
              definitions.predicate.Ulimit,
          Volume = predicates.contract_from_predicate
              definitions.predicate.Volume,
          Worker = {
                flavor
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Flavor identifier for worker.
                  Reference: https://go-vela.github.io/docs/reference/yaml/worker/#the-flavor-tag
                  "%
                  | optional,
                platform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Platform identifier for the worker.
                  Reference: https://go-vela.github.io/docs/reference/yaml/worker/#the-platform-tag
                  "%
                  | optional,
              },
        },
    predicate = {
          Metadata = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clone = predicates.isType '"Bool",
                  environment = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  render_inline = predicates.isType '"Bool",
                  template = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          Origin = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image", "name" ],
                predicates.records.record
                {
                  environment = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          { ".*" = predicates.isType '"String", }
                          false
                          predicates.never
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.records.record {  } {  } false
                          predicates.never
                        ]
                      ],
                  image = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  parameters = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.records.record {  } {  } true
                              predicates.always,
                        }
                        true
                        predicates.always
                      ],
                  pull = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "always", "not_present", "on_start", "never" ]
                      ],
                  ruleset = definitions.predicate.Ruleset,
                  secrets = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.records.record {  } {  } false
                            predicates.never
                          ])
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.StepSecret
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Rules = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  branch = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  comment = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  event = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "comment",
                            "comment:created",
                            "comment:edited",
                            "deployment",
                            "pull_request",
                            "pull_request:edited",
                            "pull_request:opened",
                            "pull_request:synchronize",
                            "push",
                            "tag"
                          ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "comment",
                              "comment:created",
                              "comment:edited",
                              "deployment",
                              "pull_request",
                              "pull_request:edited",
                              "pull_request:opened",
                              "pull_request:synchronize",
                              "push",
                              "tag"
                            ]
                          ])
                        ]
                      ],
                  path = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  repo = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  status = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "failure", "success" ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "failure", "success" ]
                          ])
                        ]
                      ],
                  tag = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  target = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Ruleset = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    continue = predicates.isType '"Bool",
                    "if" = definitions.predicate.Rules,
                    matcher = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "filepath", "regexp" ]
                        ],
                    operator = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "or", "and" ]
                        ],
                    unless = definitions.predicate.Rules,
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
                    branch = predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ]
                        ],
                    comment = predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ]
                        ],
                    continue = predicates.isType '"Bool",
                    event = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "comment",
                              "comment:created",
                              "comment:edited",
                              "deployment",
                              "pull_request",
                              "pull_request:edited",
                              "pull_request:opened",
                              "pull_request:synchronize",
                              "push",
                              "tag"
                            ]
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum
                              [
                                "comment",
                                "comment:created",
                                "comment:edited",
                                "deployment",
                                "pull_request",
                                "pull_request:edited",
                                "pull_request:opened",
                                "pull_request:synchronize",
                                "push",
                                "tag"
                              ]
                            ])
                          ]
                        ],
                    matcher = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "filepath", "regexp" ]
                        ],
                    operator = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "or", "and" ]
                        ],
                    path = predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ]
                        ],
                    repo = predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ]
                        ],
                    status = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "failure", "success" ]
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum [ "failure", "success" ]
                            ])
                          ]
                        ],
                    tag = predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ]
                        ],
                    target = predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ]
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          Secret = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  engine = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "native", "vault" ]
                      ],
                  key = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  origin = definitions.predicate.Origin,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "repo", "org", "shared" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Service = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image", "name" ],
                predicates.records.record
                {
                  entrypoint = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  environment = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          { ".*" = predicates.isType '"String", }
                          false
                          predicates.never
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.records.record {  } {  } false
                          predicates.never
                        ]
                      ],
                  image = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  ports = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  pull = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "always", "not_present", "on_start", "never" ]
                      ],
                  ulimits = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Ulimit
                      ],
                  user = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Stage = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "steps" ],
                predicates.records.record
                {
                  environment = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          { ".*" = predicates.isType '"String", }
                          false
                          predicates.never
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.records.record {  } {  } false
                          predicates.never
                        ]
                      ],
                  independent = predicates.isType '"Bool",
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  needs = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  steps = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Step
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Step = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "template" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "image" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  commands = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  detach = predicates.isType '"Bool",
                  entrypoint = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  environment = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          { ".*" = predicates.isType '"String", }
                          false
                          predicates.never
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.records.record {  } {  } false
                          predicates.never
                        ]
                      ],
                  image = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  parameters = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.records.record {  } {  } true
                              predicates.always,
                        }
                        true
                        predicates.always
                      ],
                  privileged = predicates.isType '"Bool",
                  pull = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "always", "not_present", "on_start", "never" ]
                      ],
                  ruleset = definitions.predicate.Ruleset,
                  secrets = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.records.record {  } {  } false
                            predicates.never
                          ])
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.StepSecret
                        ]
                      ],
                  template = definitions.predicate.StepTemplate,
                  ulimits = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Ulimit
                      ],
                  user = predicates.isType '"String",
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Volume
                      ],
                }
                {  }
                false
                predicates.never
              ],
          StepSecret = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  source = predicates.isType '"String",
                  target = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          StepTemplate = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  vars = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.records.record {  } {  } true
                              predicates.always,
                        }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Template = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "source" ],
                predicates.records.record
                {
                  format = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "starlark", "golang", "go" ],
                        predicates.strings.minLength 1
                      ],
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  source = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  vars = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.records.record {  } {  } true
                              predicates.always,
                        }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Ulimit = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "[a-z]+=[0-9]+:[0-9]+",
                  predicates.records.record {  } {  } false predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    hard = predicates.isType 'Integer,
                    name = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    soft = predicates.isType 'Integer,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          Volume = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "[a-z\\/]+:[a-z\\/]+:[row]+",
                  predicates.records.record {  } {  } false predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "destination", "source" ],
                  predicates.records.record
                  {
                    access_mode = predicates.isType '"String",
                    destination = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    source = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          Worker = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  flavor = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  platform = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
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
  predicates.oneOf
  [
    predicates.allOf
    [
      predicates.records.required [ "stages" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "steps" ],
      predicates.records.record {  } {  } true predicates.always
    ]
  ],
  predicates.records.required [ "version" ],
  predicates.records.record
  {
    environment = predicates.oneOf
        [
          predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record {  }
            { ".*" = predicates.isType '"String", }
            false
            predicates.never
          ],
          predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.arrayOf (predicates.isType '"String"),
            predicates.records.record {  } {  } false predicates.never
          ]
        ],
    metadata = definitions.predicate.Metadata,
    secrets = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.Secret
        ],
    services = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.Service
        ],
    stages = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } { ".*" = definitions.predicate.Stage, }
          false
          predicates.never
        ],
    steps = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.Step
        ],
    templates = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.Template
        ],
    version = predicates.allOf
        [ predicates.isType '"String", predicates.strings.minLength 1 ],
    worker = definitions.predicate.Worker,
  }
  {  }
  true
  predicates.always
])