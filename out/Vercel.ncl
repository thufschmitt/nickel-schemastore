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
  "$schema"
    | predicates.contract_from_predicate (predicates.isType '"String")
    | doc m%"
    Ignored. Can be set to get completions, validations and documentation in some editors.
    "%
    | optional,
  alias
    | predicates.contract_from_predicate
    (predicates.oneOf
    [
      predicates.isType '"String",
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.strings.maxLength 253,
        predicates.arrays.arrayOf
        (predicates.allOf
        [ predicates.isType '"String", predicates.strings.maxLength 253 ]),
        predicates.arrays.maxItems 50
      ]
    ])
    | doc m%"
    Aliases that will get assigned when the deployment is `READY` and the target is `production`. The client needs to make a `GET` request to its API to ensure the assignment
    "%
    | optional,
  build
    | {
      env
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.maxProperties 100,
          predicates.records.minProperties 0,
          predicates.records.record {  }
          {
            ".+" = predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.maxLength 65536,
                  predicates.strings.minLength 0
                ],
          }
          false
          predicates.never
        ])
        | doc m%"
        An object containing the deployment's environment variable names and values to be passed to Builds. Secrets can be referenced by prefixing the value with `@`
        "%
        | optional,
    }
    | doc m%"
    An object containing another object with information to be passed to the Build Process
    "%
    | optional,
  buildCommand
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"String", predicates.isType 'Null ],
      predicates.strings.maxLength 256
    ])
    | doc m%"
    The build command for this project. When `null` is used this value will be automatically detected
    "%
    | optional,
  builds
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "use" ],
        predicates.records.record
        {
          config = predicates.isType 'Record,
          src = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 4096,
                predicates.strings.minLength 1
              ],
          use = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 256,
                predicates.strings.minLength 3
              ],
        }
        {  }
        false
        predicates.never
      ]),
      predicates.arrays.maxItems 128,
      predicates.arrays.minItems 0
    ])
    | doc m%"
    A list of build descriptions whose src references valid source files.
    "%
    | optional,
  cleanUrls
    | Bool
    | doc m%"
    When set to `true`, all HTML files and Serverless Functions will have their extension removed. When visiting a path that ends with the extension, a 308 response will redirect the client to the extensionless path.
    "%
    | optional,
  crons
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "path", "schedule" ],
        predicates.records.record
        {
          path = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 512,
                predicates.strings.pattern "^/.*"
              ],
          schedule = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 256,
                predicates.strings.minLength 9
              ],
        }
        {  }
        true
        predicates.always
      ]),
      predicates.arrays.maxItems 20
    ])
    | doc m%"
    An array of cron jobs that should be created for production Deployments.
    "%
    | optional,
  devCommand
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"String", predicates.isType 'Null ],
      predicates.strings.maxLength 256
    ])
    | doc m%"
    The dev command for this project. When `null` is used this value will be automatically detected
    "%
    | optional,
  env
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.maxProperties 100,
      predicates.records.minProperties 0,
      predicates.records.record {  }
      {
        ".+" = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.maxLength 65536,
              predicates.strings.minLength 0
            ],
      }
      false
      predicates.never
    ])
    | doc m%"
    An object containing the deployment's environment variable names and values. Secrets can be referenced by prefixing the value with `@`
    "%
    | optional,
  framework
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ],
      predicates.enum
      [
        "blitzjs",
        "nextjs",
        "gatsby",
        "remix",
        "astro",
        "hexo",
        "eleventy",
        "docusaurus-2",
        "docusaurus",
        "preact",
        "solidstart",
        "dojo",
        "ember",
        "vue",
        "scully",
        "ionic-angular",
        "angular",
        "polymer",
        "svelte",
        "sveltekit",
        "sveltekit-1",
        "ionic-react",
        "create-react-app",
        "gridsome",
        "umijs",
        "sapper",
        "saber",
        "stencil",
        "nuxtjs",
        "redwoodjs",
        "hugo",
        "jekyll",
        "brunch",
        "middleman",
        "zola",
        "hydrogen",
        "vite",
        "vitepress",
        "vuepress",
        "parcel",
        "sanity",
        "storybook",
        null
      ]
    ])
    | doc m%"
    The framework that is being used for this project. When `null` is used no framework is selected
    "%
    | optional,
  functions
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.maxProperties 50,
      predicates.records.minProperties 1,
      predicates.records.record {  }
      {
        "^.{1,256}$" = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                excludeFiles = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.maxLength 256
                    ],
                includeFiles = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.maxLength 256
                    ],
                maxDuration = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.maximum 900,
                      predicates.numbers.minimum 1
                    ],
                memory = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.maximum 3008,
                      predicates.numbers.minimum 128
                    ],
                runtime = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.maxLength 256
                    ],
              }
              {  }
              false
              predicates.never
            ],
      }
      false
      predicates.never
    ])
    | doc m%"
    An object describing custom options for your Serverless Functions. Each key must be glob pattern that matches the paths of the Serverless Functions you would like to customize (like `api/*.js` or `api/test.js`).
    "%
    | optional,
  git
    | {
      deploymentEnabled
        | predicates.contract_from_predicate
        (predicates.oneOf
        [
          predicates.isType '"Bool",
          predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record {  } {  } true (predicates.isType '"Bool")
          ]
        ])
        | doc m%"
        Specifies the branches that will not trigger an auto-deployment when committing to them. Any non specified branch is `true` by default.
        "%
        | optional,
      ..
    }
    | optional,
  github
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record
      {
        autoAlias = predicates.isType '"Bool",
        autoJobCancelation = predicates.isType '"Bool",
        enabled = predicates.isType '"Bool",
        silent = predicates.isType '"Bool",
      }
      {  }
      true
      predicates.always
    ])
    | optional,
  headers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "headers", "source" ],
        predicates.records.record
        {
          has = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "type", "value" ],
                    predicates.records.record
                    {
                      type = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "host" ]
                          ],
                      value = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "key", "type" ],
                    predicates.records.record
                    {
                      key = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                      type = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "header", "cookie", "query" ]
                          ],
                      value = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ]),
                predicates.arrays.maxItems 16
              ],
          headers = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "key", "value" ],
                  predicates.records.record
                  {
                    key = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.maxLength 4096
                        ],
                    value = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.maxLength 4096
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ]),
                predicates.arrays.maxItems 1024
              ],
          missing = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "type", "value" ],
                    predicates.records.record
                    {
                      type = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "host" ]
                          ],
                      value = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "key", "type" ],
                    predicates.records.record
                    {
                      key = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                      type = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "header", "cookie", "query" ]
                          ],
                      value = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ]),
                predicates.arrays.maxItems 16
              ],
          source = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 4096
              ],
        }
        {  }
        false
        predicates.never
      ]),
      predicates.arrays.maxItems 1024
    ])
    | doc m%"
    A list of header definitions.
    "%
    | optional,
  ignoreCommand
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"String", predicates.isType 'Null ],
      predicates.strings.maxLength 256
    ])
    | optional,
  images
    | {
      contentDispositionType
        | predicates.contract_from_predicate
        (predicates.enum [ "inline", "attachment" ])
        | optional,
      contentSecurityPolicy
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"String",
          predicates.strings.maxLength 256,
          predicates.strings.minLength 1
        ])
        | optional,
      dangerouslyAllowSVG | Bool | optional,
      domains
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType '"String",
            predicates.strings.maxLength 256,
            predicates.strings.minLength 1
          ]),
          predicates.arrays.maxItems 50,
          predicates.arrays.minItems 0
        ])
        | optional,
      formats
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.enum
          [ "image/avif", "image/webp", "image/jpeg", "image/png" ]),
          predicates.arrays.maxItems 4,
          predicates.arrays.minItems 1
        ])
        | optional,
      minimumCacheTTL
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Integer,
          predicates.numbers.maximum 315360000,
          predicates.numbers.minimum 1
        ])
        | optional,
      remotePatterns
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "hostname" ],
            predicates.records.record
            {
              hostname = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.maxLength 256,
                    predicates.strings.minLength 1
                  ],
              pathname = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.maxLength 256,
                    predicates.strings.minLength 1
                  ],
              port = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.maxLength 5,
                    predicates.strings.minLength 1
                  ],
              protocol = predicates.enum [ "http", "https" ],
            }
            {  }
            false
            predicates.never
          ]),
          predicates.arrays.maxItems 50,
          predicates.arrays.minItems 0
        ])
        | optional,
      sizes
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"Number"),
          predicates.arrays.maxItems 50,
          predicates.arrays.minItems 1
        ]),
    }
    | optional,
  installCommand
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"String", predicates.isType 'Null ],
      predicates.strings.maxLength 256
    ])
    | doc m%"
    The install command for this project. When `null` is used this value will be automatically detected
    "%
    | optional,
  name
    | String
    | doc m%"
    A name for the deployment
    "%
    | optional,
  outputDirectory
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"String", predicates.isType 'Null ],
      predicates.strings.maxLength 256
    ])
    | doc m%"
    The output directory of the project. When `null` is used this value will be automatically detected
    "%
    | optional,
  public
    | Bool
    | doc m%"
    Whether a deployment's source and logs are available publicly
    "%
    | optional,
  redirects
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "destination", "source" ],
        predicates.records.record
        {
          destination = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 4096
              ],
          has = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "type", "value" ],
                    predicates.records.record
                    {
                      type = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "host" ]
                          ],
                      value = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "key", "type" ],
                    predicates.records.record
                    {
                      key = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                      type = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "header", "cookie", "query" ]
                          ],
                      value = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ]),
                predicates.arrays.maxItems 16
              ],
          missing = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "type", "value" ],
                    predicates.records.record
                    {
                      type = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "host" ]
                          ],
                      value = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "key", "type" ],
                    predicates.records.record
                    {
                      key = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                      type = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "header", "cookie", "query" ]
                          ],
                      value = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ]),
                predicates.arrays.maxItems 16
              ],
          permanent = predicates.isType '"Bool",
          source = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 4096
              ],
          statusCode = predicates.allOf
              [
                predicates.isType 'Integer,
                predicates.numbers.maximum 999,
                predicates.numbers.minimum 100
              ],
        }
        {  }
        false
        predicates.never
      ]),
      predicates.arrays.maxItems 1024
    ])
    | doc m%"
    A list of redirect definitions.
    "%
    | optional,
  regions
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [ predicates.isType '"String", predicates.strings.maxLength 256 ]),
      predicates.arrays.maxItems 1000,
      predicates.arrays.minItems 1
    ])
    | doc m%"
    An array of the regions the deployment's Serverless Functions should be deployed to
    "%
    | optional,
  rewrites
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "destination", "source" ],
        predicates.records.record
        {
          destination = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 4096
              ],
          has = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "type", "value" ],
                    predicates.records.record
                    {
                      type = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "host" ]
                          ],
                      value = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "key", "type" ],
                    predicates.records.record
                    {
                      key = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                      type = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "header", "cookie", "query" ]
                          ],
                      value = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ]),
                predicates.arrays.maxItems 16
              ],
          missing = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "type", "value" ],
                    predicates.records.record
                    {
                      type = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "host" ]
                          ],
                      value = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "key", "type" ],
                    predicates.records.record
                    {
                      key = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                      type = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "header", "cookie", "query" ]
                          ],
                      value = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 4096
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ]),
                predicates.arrays.maxItems 16
              ],
          source = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 4096
              ],
        }
        {  }
        false
        predicates.never
      ]),
      predicates.arrays.maxItems 1024
    ])
    | doc m%"
    A list of rewrite definitions.
    "%
    | optional,
  routes
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.anyOf
      [
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "src" ],
          predicates.records.record
          {
            caseSensitive = predicates.isType '"Bool",
            check = predicates.isType '"Bool",
            continue = predicates.isType '"Bool",
            dest = predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.maxLength 4096
                ],
            has = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "type", "value" ],
                      predicates.records.record
                      {
                        type = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum [ "host" ]
                            ],
                        value = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.maxLength 4096
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ],
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "key", "type" ],
                      predicates.records.record
                      {
                        key = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.maxLength 4096
                            ],
                        type = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum [ "header", "cookie", "query" ]
                            ],
                        value = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.maxLength 4096
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ]
                  ]),
                  predicates.arrays.maxItems 16
                ],
            headers = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.maxProperties 100,
                  predicates.records.minProperties 1,
                  predicates.records.record {  }
                  {
                    "^.{1,256}$" = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.maxLength 4096
                        ],
                  }
                  false
                  predicates.never
                ],
            important = predicates.isType '"Bool",
            isInternal = predicates.isType '"Bool",
            locale = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.minProperties 1,
                  predicates.records.record
                  {
                    cookie = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.maxLength 4096
                        ],
                    "default" = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.maxLength 4096
                        ],
                    path = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.maxLength 4096
                        ],
                    redirect = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.maxProperties 100,
                          predicates.records.minProperties 1,
                          predicates.records.record {  }
                          {
                            "^.{1,256}$" = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.maxLength 4096
                                ],
                          }
                          false
                          predicates.never
                        ],
                    value = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.maxLength 4096
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
            methods = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.maxLength 32
                  ]),
                  predicates.arrays.maxItems 10
                ],
            middleware = predicates.isType '"Number",
            middlewarePath = predicates.isType '"String",
            middlewareRawSrc = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            missing = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "type", "value" ],
                      predicates.records.record
                      {
                        type = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum [ "host" ]
                            ],
                        value = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.maxLength 4096
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ],
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "key", "type" ],
                      predicates.records.record
                      {
                        key = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.maxLength 4096
                            ],
                        type = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum [ "header", "cookie", "query" ]
                            ],
                        value = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.maxLength 4096
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ]
                  ]),
                  predicates.arrays.maxItems 16
                ],
            override = predicates.isType '"Bool",
            src = predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.maxLength 4096
                ],
            status = predicates.allOf
                [
                  predicates.isType 'Integer,
                  predicates.numbers.maximum 999,
                  predicates.numbers.minimum 100
                ],
            user = predicates.isType '"Bool",
          }
          {  }
          false
          predicates.never
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "handle" ],
          predicates.records.record
          {
            handle = predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum
                  [
                    "error",
                    "filesystem",
                    "hit",
                    "miss",
                    "resource",
                    "rewrite"
                  ],
                  predicates.strings.maxLength 32
                ],
          }
          {  }
          false
          predicates.never
        ]
      ]),
      predicates.arrays.maxItems 1024
    ])
    | doc m%"
    A list of routes objects used to rewrite paths to point towards other internal or external paths
    "%
    | optional,
  scope
    | predicates.contract_from_predicate (predicates.isType '"String")
    | doc m%"
    This property determines the scope (user or team) under which the project will be deployed by Vercel CLI.
    "%
    | optional,
  trailingSlash
    | Bool
    | doc m%"
    When `false`, visiting a path that ends with a forward slash will respond with a `308` status code and redirect to the path without the trailing slash.
    "%
    | optional,
  version
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Integer,
      predicates.numbers.maximum 2,
      predicates.numbers.minimum 2
    ])
    | optional,
  wildcard
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "domain", "value" ],
        predicates.records.record
        {
          domain = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 255,
                predicates.strings.minLength 1
              ],
          value = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 1024,
                predicates.strings.minLength 0
              ],
        }
        {  }
        false
        predicates.never
      ]),
      predicates.arrays.maxItems 25,
      predicates.arrays.minItems 1
    ])
    | optional,
}