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
          abstract
            | doc m%"
            Mark contribution as abstract. Such contributions serve only as super contributions for other contributions.
            "%
            = Bool,
          base-contribution
            | doc m%"
            The base for any contributions.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.base-contribution,
          context = predicates.contract_from_predicate
              definitions.predicate.context,
          context-config
            | doc m%"
            Provide configuration for a specified Web Types context. This allows to contribute additional Web Types for example if a particular library is present in the project.
            "%
            = {
                disable-when
                  | definitions.contract.disablement-rules
                  | optional,
                enable-when | definitions.contract.enablement-rules | optional,
                kind
                  | String
                  | doc m%"
                  Context kind. Only a single context of the particular kind will be enabled. An example of context kind is framework, which has dedicated support in Web Types.
                  "%,
              },
          contexts-config
            | doc m%"
            Provide configuration for Web Types contexts. This allows to contribute additional Web Types for example if a particular library is present in the project.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.contexts-config,
          css
            | doc m%"
            Contains contributions to CSS namespace. It's property names represent symbol kinds, its property values contain list of contributions of particular kind. There are6 predefined kinds, which integrate directly with IDE - properties, classes, functions, pseudo-elements, pseudo-classes and parts.
            "%
            = predicates.contract_from_predicate definitions.predicate.css,
          css-contributions-host = predicates.contract_from_predicate
              definitions.predicate.css-contributions-host,
          css-generic-item = predicates.contract_from_predicate
              definitions.predicate.css-generic-item,
          css-property = predicates.contract_from_predicate
              definitions.predicate.css-property,
          css-pseudo-class = predicates.contract_from_predicate
              definitions.predicate.css-pseudo-class,
          css-pseudo-element = predicates.contract_from_predicate
              definitions.predicate.css-pseudo-element,
          "default" = String,
          deprecated
            | doc m%"
            Specifies whether the symbol is deprecated. Deprecated symbol usage is discouraged, but still supported. Value can be a boolean or a string message with explanation and migration information.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.deprecated,
          deprecated-description-markup
            | doc m%"
            Deprecated, use top-level property.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.deprecated-description-markup,
          deprecated-html-attribute-vue-argument
            | doc m%"
            Deprecated vue-specific property - contribute Vue directives to /contributions/html/vue-directives
            "%
            = predicates.contract_from_predicate
              definitions.predicate.deprecated-html-attribute-vue-argument,
          deprecated-html-attribute-vue-modifier = {
                description | definitions.contract.description | optional,
                doc-url | definitions.contract.doc-url | optional,
                name | definitions.contract.name,
                pattern | definitions.contract.name-pattern-root | optional,
              },
          deprecated-since
            | doc m%"
            Version in which this symbol was first deprecated.
            "%
            = String,
          deprecated-types-syntax
            | doc m%"
            Deprecated, use top-level js-types-syntax property.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.deprecated-types-syntax,
          description
            | doc m%"
            Short description to be rendered in documentation popup. It will be rendered according to description-markup setting.
            "%
            = String,
          description-markup
            | doc m%"
            Markup language in which descriptions are formatted.
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| 'none, 'markdown, 'html |] ],
          description-sections
            | doc m%"
            Custom sections to be shown below description in the documentation popup.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.description-sections,
          disablement-rules
            | doc m%"
            Specify rules for disabling web framework support. These rules take precedence over enable-when rules. They allow to turn off framework support in case of some conflicts between frameworks priority.
            "%
            = {
                file-extensions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Extensions of files, which should have the framework support disabled
                  "%
                  | optional,
                file-name-patterns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.pattern
                  ])
                  | doc m%"
                  RegExp patterns to match file names, which should have the framework support disabled
                  "%
                  | optional,
              },
          doc-url
            | doc m%"
            Link to online documentation.
            "%
            = String,
          enablement-rules
            | doc m%"
            Specify rules for enabling web framework support. Only one framework can be enabled in a particular file. If you need your contributions to be enabled in all files, regardless of the context, do not specify the framework.
            "%
            = {
                file-extensions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Extensions of files, which should have the framework support enabled. Use this to support custom file extensions like '.vue' or '.svelte'. Never specify generic extensions like '.html', '.js' or '.ts'. If you need your contributions to be present in every file don't specify the framework at all
                  "%
                  | optional,
                file-name-patterns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.pattern
                  ])
                  | doc m%"
                  RegExp patterns to match file names, which should have the framework support enabled. Use carefully as broken pattern may even freeze IDE.
                  "%
                  | optional,
                ide-libraries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Global JavaScript libraries names enabled within the IDE, which enable framework support in the whole project
                  "%
                  | optional,
                node-packages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Node.js package names, which enable framework support within the folder containing the package.json.
                  "%
                  | optional,
                project-tool-executables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of tool executables (without extension), which presence should be checked in the project. In case of Node projects, such tools will be searched in node_modules/.bin/
                  "%
                  | optional,
                script-url-patterns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.pattern
                  ])
                  | doc m%"
                  RegExps to match script URLs, which enable framework support within a particular HTML.
                  "%
                  | optional,
              },
          exclusive-contributions
            | doc m%"
            Specify list of contribution kinds qualified with a namespace, for which during reference resolution this will be the final contribution host. E.g. if a special HTML element does not accept standard attributes, add:
            "exclusive-contributions": ["/html/attributes"].
            "%
            = predicates.contract_from_predicate
              definitions.predicate.exclusive-contributions,
          experimental
            | doc m%"
            Specifies whether the symbol is experimental. Value can be a boolean or a string message with explanation. Experimental symbols should be used with caution as the API might change.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.experimental,
          extends = definitions.contract.reference,
          extension
            | doc m%"
            Mark contribution as an extension. Such contributions do not define a new contribution on their own, but can provide additional properties or contributions to existing contributions.
            "%
            = Bool,
          framework-config
            | doc m%"
            Provide configuration for the specified web framework. This is an advanced feature, which is used to provide support for templating frameworks like Angular, Vue, Svelte, etc.
            "%
            = {
                canonical-names
                  | definitions.contract.name-conversion-rules-single
                  | doc m%"
                  In many frameworks symbols can have multiple versions of a name. Specify canonical name conversion rule for names of particular symbol kinds against which comparisons will be made. Format of the 'canonical-names' property names is '{namespace}/{symbol kind}'. By default symbol names in HTML namespace are converted to lower-case, and in CSS and JS namespaces are left as-is. In case of name patterns, rules are applied to each part of the pattern separately, so even if the symbol with pattern is in HTML namespace, references to JS events will be case-sensitive.
                  "%
                  | optional,
                disable-when
                  | definitions.contract.disablement-rules
                  | optional,
                enable-when | definitions.contract.enablement-rules | optional,
                match-names
                  | definitions.contract.name-conversion-rules-multiple
                  | doc m%"
                  Provide an array of name conversions, in which particular symbol kinds should be matched against canonical names of symbols. By default symbol names are converted using canonical-names rule.
                  "%
                  | optional,
                name-variants
                  | definitions.contract.name-conversion-rules-multiple
                  | doc m%"
                  Provide an array of name conversions, in which particular symbol kinds should be proposed in auto completion. Format of the 'name-variants' property names is '{namespace}/{symbol kind}'. All symbol kinds are by default provided as-is.
                  "%
                  | optional,
              },
          generic-contribution
            | doc m%"
            A generic contribution. All contributions are of this type, except for HTML attributes and elements, as well as predefined CSS contribution kinds.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.generic-contribution,
          generic-css-contribution = predicates.contract_from_predicate
              definitions.predicate.generic-css-contribution,
          generic-css-contribution-or-property =
            predicates.contract_from_predicate
              definitions.predicate.generic-css-contribution-or-property,
          generic-css-contributions = predicates.contract_from_predicate
              definitions.predicate.generic-css-contributions,
          generic-html-contribution = predicates.contract_from_predicate
              definitions.predicate.generic-html-contribution,
          generic-html-contribution-or-property =
            predicates.contract_from_predicate
              definitions.predicate.generic-html-contribution-or-property,
          generic-html-contributions = predicates.contract_from_predicate
              definitions.predicate.generic-html-contributions,
          generic-js-contribution = predicates.contract_from_predicate
              definitions.predicate.generic-js-contribution,
          generic-js-contribution-or-property =
            predicates.contract_from_predicate
              definitions.predicate.generic-js-contribution-or-property,
          generic-js-contributions = predicates.contract_from_predicate
              definitions.predicate.generic-js-contributions,
          html
            | doc m%"
            Contains contributions to HTML namespace. It's property names represent symbol kinds, its property values contain list of contributions of particular kind. There are 2 predefined kinds, which integrate directly with IDE - HTML elements and HTML attributes. There are also 2 deprecated kinds: tags (which is equivalent to 'elements') and 'events' (which was moved to JS namespace)
            "%
            = predicates.contract_from_predicate definitions.predicate.html,
          html-attribute = predicates.contract_from_predicate
              definitions.predicate.html-attribute,
          html-attribute-value = {
                "default" | String | optional,
                kind
                  | std.enum.TagOrString
                  | [| 'expression, 'plain, 'no-value |]
                  | optional,
                required | Bool | optional,
                type | definitions.contract.html-value-type | optional,
              },
          html-contributions-host = predicates.contract_from_predicate
              definitions.predicate.html-contributions-host,
          html-element = predicates.contract_from_predicate
              definitions.predicate.html-element,
          html-value-type = predicates.contract_from_predicate
              definitions.predicate.html-value-type,
          icon
            | doc m%"
            Relative path to the icon representing the symbol or actual SVG of the icon.
            "%
            = String,
          js
            | doc m%"
            Contains contributions to JS namespace. It's property names represent symbol kinds, its property values contain list of contributions of particular kind. There are 2 predefined kinds, which integrate directly with IDE - properties and events.
            "%
            = predicates.contract_from_predicate definitions.predicate.js,
          js-contributions-host = predicates.contract_from_predicate
              definitions.predicate.js-contributions-host,
          js-global
            | doc m%"
            Contains contributions to JS namespace. It's property names represent symbol kinds, its property values contain list of contributions of particular kind. There are 2 predefined kinds, which integrate directly with IDE - properties and events, but only events can be contributed globally.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.js-global,
          js-property = predicates.contract_from_predicate
              definitions.predicate.js-property,
          js-symbol = predicates.contract_from_predicate
              definitions.predicate.js-symbol,
          js-types-syntax
            | doc m%"
            Language in which JavaScript objects types are specified.
            "%
            = std.contract.Sequence [ std.enum.TagOrString, [| 'typescript |] ],
          list-reference
            | doc m%"
            A reference to an element in Web-Types model.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.list-reference,
          name = String,
          name-conversion-rules-multiple = predicates.contract_from_predicate
              definitions.predicate.name-conversion-rules-multiple,
          name-conversion-rules-single = predicates.contract_from_predicate
              definitions.predicate.name-conversion-rules-single,
          name-converter = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'snake_case,
                  'kebab-case,
                  'UPPERCASE,
                  'lowercase,
                  'camelCase,
                  'PascalCase,
                  'as-is
                |]
              ],
          name-converters = predicates.contract_from_predicate
              definitions.predicate.name-converters,
          name-pattern = predicates.contract_from_predicate
              definitions.predicate.name-pattern,
          name-pattern-root = predicates.contract_from_predicate
              definitions.predicate.name-pattern-root,
          name-pattern-template = predicates.contract_from_predicate
              definitions.predicate.name-pattern-template,
          obsolete
            | doc m%"
            Specifies whether the symbol is obsolete. Obsolete symbols are no longer supported. Value can be a boolean or a string message with explanation and migration information.
            "%
            = predicates.contract_from_predicate definitions.predicate.obsolete,
          obsolete-since
            | doc m%"
            Version in which this symbol was first made obsolete.
            "%
            = String,
          pattern
            | doc m%"
            A RegEx pattern to match whole content. Syntax should work with at least ECMA, Java and Python implementations.
            "%
            = predicates.contract_from_predicate definitions.predicate.pattern,
          "priority" = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'highest, 'high, 'normal, 'low, 'lowest |]
              ],
          proximity = std.number.Integer,
          reference
            | doc m%"
            A reference to an element in Web-Types model.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.reference,
          reference-name-conversion
            | doc m%"
            Override global name conversion rules for matching symbols under the path.
            "%
            = {
                canonical-names
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.name-converter,
                    definitions.predicate.name-conversion-rules-single
                  ])
                  | doc m%"
                  Override global canonical name conversion rule against which comparisons are made for the referenced symbols. When only rule name is specified, it applies to the symbols of the same kind as the last segment of the referenced path. Otherwise format of the property names is '{namespace}/{symbol kind}'. Supported by JetBrains IDEs since 2022.1.
                  "%
                  | optional,
                match-names
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.name-converters,
                    definitions.predicate.name-conversion-rules-multiple
                  ])
                  | doc m%"
                  Override global rules, by which referenced symbols should be matched against their canonical names. When only rule names are specified, they applies to the symbols of the same kind as the last segment of the referenced path. Otherwise format of the property names is '{namespace}/{symbol kind}'. Supported by JetBrains IDEs since 2022.1.
                  "%
                  | optional,
                name-variants
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.name-converters,
                    definitions.predicate.name-conversion-rules-multiple
                  ])
                  | doc m%"
                  Override global rules, by which referenced symbol names should be proposed in auto completion. When only rule names are specified, they applies to the symbols of the same kind as the last segment of the referenced path. Otherwise format of the property names is '{namespace}/{symbol kind}'. Supported by JetBrains IDEs since 2022.1.
                  "%
                  | optional,
                ..
              },
          reference-with-props = {
                filter | String | optional,
                includeAbstract | Bool | optional,
                includeVirtual | Bool | optional,
                name-conversion
                  | definitions.contract.reference-name-conversion
                  | doc m%"
                  Override global name conversion rules for matching symbols under the path.
                  "%
                  | optional,
                path | String,
                ..
              },
          required = Bool,
          since
            | doc m%"
            Version since this symbol is available.
            "%
            = String,
          source
            | doc m%"
            Allows to specify the source of the entity. For Vue.js component this may be for instance a class.
            "%
            = predicates.contract_from_predicate definitions.predicate.source,
          type = predicates.contract_from_predicate definitions.predicate.type,
          type-list
            | doc m%"
            Specify type according to selected language for type syntax. The type can be specified by a string expression, an object with list of imports and an expression, or an array of possible types.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.type-list,
          type-reference = {
                module
                  | String
                  | doc m%"
                  Name of module, which exports the type. May be omitted, in which case it's assumed to be the name of the library.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the symbol to import
                  "%,
              },
          typed-contribution
            | doc m%"
            The base for any contribution, which can possibly have a JS type.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.typed-contribution,
          virtual
            | doc m%"
            Mark contribution as virtual. Virtual contributions can be filtered out if needed in references. A virtual contribution meaning may differ by framework or kind contexts, but usually means something synthetic or something, which gets erased in the runtime by the framework. E.g. Vue or Angular attribute bindings are virtual. 
            "%
            = Bool,
        },
    predicate = {
          abstract
            | doc m%"
            Mark contribution as abstract. Such contributions serve only as super contributions for other contributions.
            "%
            = predicates.isType '"Bool",
          base-contribution
            | doc m%"
            The base for any contributions.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  abstract = definitions.predicate.abstract,
                  css = definitions.predicate.css,
                  deprecated = definitions.predicate.deprecated,
                  deprecated-since = definitions.predicate.deprecated-since,
                  description = definitions.predicate.description,
                  description-sections =
                    definitions.predicate.description-sections,
                  doc-url = definitions.predicate.doc-url,
                  exclusive-contributions =
                    definitions.predicate.exclusive-contributions,
                  experimental = definitions.predicate.experimental,
                  extends = definitions.predicate.extends,
                  extension = definitions.predicate.extension,
                  html = definitions.predicate.html,
                  icon = definitions.predicate.icon,
                  js = definitions.predicate.js,
                  name = definitions.predicate.name,
                  obsolete = definitions.predicate.obsolete,
                  obsolete-since = definitions.predicate.obsolete-since,
                  pattern = definitions.predicate.name-pattern-root,
                  "priority" = definitions.predicate."priority",
                  proximity = definitions.predicate.proximity,
                  since = definitions.predicate.since,
                  source = definitions.predicate.source,
                  virtual = definitions.predicate.virtual,
                }
                {  }
                true
                predicates.always
              ],
          context = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "kind", "name" ],
                  predicates.records.record
                  {
                    kind = predicates.isType '"String",
                    name = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "anyOf" ],
                  predicates.records.record
                  {
                    anyOf = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.context
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "allOf" ],
                  predicates.records.record
                  {
                    allOf = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.context
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "not" ],
                  predicates.records.record
                  { not = definitions.predicate.context, }
                  {  }
                  false
                  predicates.never
                ]
              ],
          context-config
            | doc m%"
            Provide configuration for a specified Web Types context. This allows to contribute additional Web Types for example if a particular library is present in the project.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kind" ],
                predicates.records.record
                {
                  disable-when = definitions.predicate.disablement-rules,
                  enable-when = definitions.predicate.enablement-rules,
                  kind = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          contexts-config
            | doc m%"
            Provide configuration for Web Types contexts. This allows to contribute additional Web Types for example if a particular library is present in the project.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                definitions.predicate.context-config
              ],
          css
            | doc m%"
            Contains contributions to CSS namespace. It's property names represent symbol kinds, its property values contain list of contributions of particular kind. There are6 predefined kinds, which integrate directly with IDE - properties, classes, functions, pseudo-elements, pseudo-classes and parts.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                definitions.predicate.css-contributions-host
              ],
          css-contributions-host = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  classes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.css-generic-item
                      ],
                  functions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.css-generic-item
                      ],
                  parts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.css-generic-item
                      ],
                  properties = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.css-property
                      ],
                  pseudo-classes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.css-pseudo-class
                      ],
                  pseudo-elements = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.css-pseudo-element
                      ],
                }
                {
                  "^(?!pattern$).*$" =
                    definitions.predicate.generic-css-contributions,
                }
                true
                predicates.always
              ],
          css-generic-item = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.base-contribution,
                  definitions.predicate.css-contributions-host
                ]
              ],
          css-property = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.base-contribution,
                  definitions.predicate.css-contributions-host
                ],
                predicates.records.record
                {
                  values = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          css-pseudo-class = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.base-contribution,
                  definitions.predicate.css-contributions-host
                ],
                predicates.records.record
                { arguments = predicates.isType '"Bool", }
                {  }
                true
                predicates.always
              ],
          css-pseudo-element = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.base-contribution,
                  definitions.predicate.css-contributions-host
                ],
                predicates.records.record
                { arguments = predicates.isType '"Bool", }
                {  }
                true
                predicates.always
              ],
          "default" = predicates.isType '"String",
          deprecated
            | doc m%"
            Specifies whether the symbol is deprecated. Deprecated symbol usage is discouraged, but still supported. Value can be a boolean or a string message with explanation and migration information.
            "%
            = predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
          deprecated-description-markup
            | doc m%"
            Deprecated, use top-level property.
            "%
            = predicates.oneOf [ definitions.predicate.description-markup ],
          deprecated-html-attribute-vue-argument
            | doc m%"
            Deprecated vue-specific property - contribute Vue directives to /contributions/html/vue-directives
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  description = definitions.predicate.description,
                  doc-url = definitions.predicate.doc-url,
                  pattern = definitions.predicate.name-pattern-root,
                  required = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          deprecated-html-attribute-vue-modifier = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  description = definitions.predicate.description,
                  doc-url = definitions.predicate.doc-url,
                  name = definitions.predicate.name,
                  pattern = definitions.predicate.name-pattern-root,
                }
                {  }
                false
                predicates.never
              ],
          deprecated-since
            | doc m%"
            Version in which this symbol was first deprecated.
            "%
            = predicates.isType '"String",
          deprecated-types-syntax
            | doc m%"
            Deprecated, use top-level js-types-syntax property.
            "%
            = predicates.oneOf [ definitions.predicate.js-types-syntax ],
          description
            | doc m%"
            Short description to be rendered in documentation popup. It will be rendered according to description-markup setting.
            "%
            = predicates.isType '"String",
          description-markup
            | doc m%"
            Markup language in which descriptions are formatted.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "html", "markdown", "none" ]
              ],
          description-sections
            | doc m%"
            Custom sections to be shown below description in the documentation popup.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          disablement-rules
            | doc m%"
            Specify rules for disabling web framework support. These rules take precedence over enable-when rules. They allow to turn off framework support in case of some conflicts between frameworks priority.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  file-extensions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  file-name-patterns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.pattern
                      ],
                }
                {  }
                false
                predicates.never
              ],
          doc-url
            | doc m%"
            Link to online documentation.
            "%
            = predicates.isType '"String",
          enablement-rules
            | doc m%"
            Specify rules for enabling web framework support. Only one framework can be enabled in a particular file. If you need your contributions to be enabled in all files, regardless of the context, do not specify the framework.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  file-extensions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  file-name-patterns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.pattern
                      ],
                  ide-libraries = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  node-packages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  project-tool-executables = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  script-url-patterns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.pattern
                      ],
                }
                {  }
                false
                predicates.never
              ],
          exclusive-contributions
            | doc m%"
            Specify list of contribution kinds qualified with a namespace, for which during reference resolution this will be the final contribution host. E.g. if a special HTML element does not accept standard attributes, add:
            "exclusive-contributions": ["/html/attributes"].
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "/[^/\\n\\r]+/[^/\\n\\r]+"
                ])
              ],
          experimental
            | doc m%"
            Specifies whether the symbol is experimental. Value can be a boolean or a string message with explanation. Experimental symbols should be used with caution as the API might change.
            "%
            = predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
          extends = definitions.predicate.reference,
          extension
            | doc m%"
            Mark contribution as an extension. Such contributions do not define a new contribution on their own, but can provide additional properties or contributions to existing contributions.
            "%
            = predicates.isType '"Bool",
          framework-config
            | doc m%"
            Provide configuration for the specified web framework. This is an advanced feature, which is used to provide support for templating frameworks like Angular, Vue, Svelte, etc.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  canonical-names =
                    definitions.predicate.name-conversion-rules-single,
                  disable-when = definitions.predicate.disablement-rules,
                  enable-when = definitions.predicate.enablement-rules,
                  match-names =
                    definitions.predicate.name-conversion-rules-multiple,
                  name-variants =
                    definitions.predicate.name-conversion-rules-multiple,
                }
                {  }
                false
                predicates.never
              ],
          generic-contribution
            | doc m%"
            A generic contribution. All contributions are of this type, except for HTML attributes and elements, as well as predefined CSS contribution kinds.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                definitions.predicate.typed-contribution,
                predicates.records.record
                {
                  attribute-value = definitions.predicate.html-attribute-value,
                  "default" = definitions.predicate."default",
                  required = definitions.predicate.required,
                }
                {  }
                true
                predicates.always
              ],
          generic-css-contribution = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.generic-contribution,
                  definitions.predicate.css-contributions-host
                ]
              ],
          generic-css-contribution-or-property = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.isType '"Number",
                predicates.isType '"Bool",
                definitions.predicate.generic-css-contribution
              ],
          generic-css-contributions = predicates.oneOf
              [
                definitions.predicate.generic-css-contribution-or-property,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.generic-css-contribution-or-property
                ]
              ],
          generic-html-contribution = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.generic-contribution,
                  definitions.predicate.html-contributions-host
                ]
              ],
          generic-html-contribution-or-property = predicates.oneOf
              [
                definitions.predicate.generic-html-contribution,
                predicates.isType '"String",
                predicates.isType '"Number",
                predicates.isType '"Bool"
              ],
          generic-html-contributions = predicates.oneOf
              [
                definitions.predicate.generic-html-contribution-or-property,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.generic-html-contribution-or-property
                ]
              ],
          generic-js-contribution = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.generic-contribution,
                  definitions.predicate.js-contributions-host
                ]
              ],
          generic-js-contribution-or-property = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.isType '"Number",
                predicates.isType '"Bool",
                definitions.predicate.generic-js-contribution
              ],
          generic-js-contributions = predicates.oneOf
              [
                definitions.predicate.generic-js-contribution-or-property,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.generic-js-contribution-or-property
                ]
              ],
          html
            | doc m%"
            Contains contributions to HTML namespace. It's property names represent symbol kinds, its property values contain list of contributions of particular kind. There are 2 predefined kinds, which integrate directly with IDE - HTML elements and HTML attributes. There are also 2 deprecated kinds: tags (which is equivalent to 'elements') and 'events' (which was moved to JS namespace)
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                definitions.predicate.html-contributions-host,
                predicates.records.record
                {
                  description-markup =
                    definitions.predicate.deprecated-description-markup,
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.html-element
                      ],
                  types-syntax = definitions.predicate.deprecated-types-syntax,
                }
                {  }
                true
                predicates.always
              ],
          html-attribute = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.base-contribution,
                  definitions.predicate.html-contributions-host
                ],
                predicates.records.record
                {
                  "default" = predicates.isType '"String",
                  required = definitions.predicate.required,
                  value = definitions.predicate.html-attribute-value,
                  vue-argument =
                    definitions.predicate.deprecated-html-attribute-vue-argument,
                  vue-modifiers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.deprecated-html-attribute-vue-modifier
                      ],
                }
                {  }
                true
                predicates.always
              ],
          html-attribute-value = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "default" = predicates.isType '"String",
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "no-value", "plain", "expression" ]
                      ],
                  required = predicates.isType '"Bool",
                  type = definitions.predicate.html-value-type,
                }
                {  }
                false
                predicates.never
              ],
          html-contributions-host = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  attributes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.html-attribute
                      ],
                  elements = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.html-element
                      ],
                  events = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.generic-html-contribution
                      ],
                }
                {
                  "^(?!pattern$).*$" =
                    definitions.predicate.generic-html-contributions,
                }
                true
                predicates.always
              ],
          html-element = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.base-contribution,
                  definitions.predicate.html-contributions-host
                ]
              ],
          html-value-type = predicates.oneOf
              [
                predicates.isType '"String",
                definitions.predicate.type-reference,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.type
                ]
              ],
          icon
            | doc m%"
            Relative path to the icon representing the symbol or actual SVG of the icon.
            "%
            = predicates.isType '"String",
          js
            | doc m%"
            Contains contributions to JS namespace. It's property names represent symbol kinds, its property values contain list of contributions of particular kind. There are 2 predefined kinds, which integrate directly with IDE - properties and events.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                definitions.predicate.js-contributions-host
              ],
          js-contributions-host = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  events = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.generic-js-contribution
                      ],
                  properties = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.js-property
                      ],
                  symbols = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.js-symbol
                      ],
                }
                {
                  "^(?!pattern$).*$" =
                    definitions.predicate.generic-js-contributions,
                }
                true
                predicates.always
              ],
          js-global
            | doc m%"
            Contains contributions to JS namespace. It's property names represent symbol kinds, its property values contain list of contributions of particular kind. There are 2 predefined kinds, which integrate directly with IDE - properties and events, but only events can be contributed globally.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  events = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.generic-js-contribution
                      ],
                  symbols = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.js-symbol
                      ],
                }
                {
                  "^(?!pattern$).*$" =
                    definitions.predicate.generic-js-contributions,
                }
                true
                predicates.always
              ],
          js-property = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.base-contribution,
                  definitions.predicate.js-contributions-host
                ],
                predicates.records.record
                { read-only = predicates.isType '"Bool", }
                {  }
                true
                predicates.always
              ],
          js-symbol = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.base-contribution,
                  definitions.predicate.js-contributions-host
                ],
                predicates.records.record
                {
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Variable",
                          "Function",
                          "Namespace",
                          "Class",
                          "Interface",
                          "Enum",
                          "Alias",
                          "Module"
                        ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          js-types-syntax
            | doc m%"
            Language in which JavaScript objects types are specified.
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.enum [ "typescript" ] ],
          list-reference
            | doc m%"
            A reference to an element in Web-Types model.
            "%
            = predicates.oneOf
              [
                definitions.predicate.reference,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.reference
                ]
              ],
          name = predicates.isType '"String",
          name-conversion-rules-multiple = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^/[^/\\n\\r]+/[^/\\n\\r]+$" =
                    definitions.predicate.name-converters,
                }
                false
                predicates.never
              ],
          name-conversion-rules-single = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^/[^/\\n\\r]+/[^/\\n\\r]+$" =
                    definitions.predicate.name-converter,
                }
                false
                predicates.never
              ],
          name-converter = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "as-is",
                  "PascalCase",
                  "camelCase",
                  "lowercase",
                  "UPPERCASE",
                  "kebab-case",
                  "snake_case"
                ]
              ],
          name-converters = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.name-converter
              ],
          name-pattern = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      delegate = definitions.predicate.reference,
                      deprecated = definitions.predicate.deprecated,
                      items = definitions.predicate.list-reference,
                      or = definitions.predicate.name-pattern-template,
                      "priority" = definitions.predicate."priority",
                      proximity = definitions.predicate.proximity,
                      repeat = predicates.isType '"Bool",
                      required = definitions.predicate.required,
                      template = definitions.predicate.name-pattern-template,
                      unique = predicates.isType '"Bool",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "regex" ],
                    predicates.records.record
                    {
                      case-sensitive = predicates.isType '"Bool",
                      regex = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ]
              ],
          name-pattern-root = predicates.oneOf
              [
                definitions.predicate.name-pattern,
                predicates.isType '"String"
              ],
          name-pattern-template = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.oneOf
                [
                  predicates.isType '"String",
                  definitions.predicate.name-pattern-template,
                  definitions.predicate.name-pattern
                ]),
                predicates.arrays.minItems 1
              ],
          obsolete
            | doc m%"
            Specifies whether the symbol is obsolete. Obsolete symbols are no longer supported. Value can be a boolean or a string message with explanation and migration information.
            "%
            = predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
          obsolete-since
            | doc m%"
            Version in which this symbol was first made obsolete.
            "%
            = predicates.isType '"String",
          pattern
            | doc m%"
            A RegEx pattern to match whole content. Syntax should work with at least ECMA, Java and Python implementations.
            "%
            = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    case-sensitive = predicates.isType '"Bool",
                    regex = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          "priority" = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "lowest", "low", "normal", "high", "highest" ]
              ],
          proximity = predicates.isType 'Integer,
          reference
            | doc m%"
            A reference to an element in Web-Types model.
            "%
            = predicates.oneOf
              [
                definitions.predicate.reference-with-props,
                predicates.isType '"String"
              ],
          reference-name-conversion
            | doc m%"
            Override global name conversion rules for matching symbols under the path.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  canonical-names = predicates.oneOf
                      [
                        definitions.predicate.name-converter,
                        definitions.predicate.name-conversion-rules-single
                      ],
                  match-names = predicates.oneOf
                      [
                        definitions.predicate.name-converters,
                        definitions.predicate.name-conversion-rules-multiple
                      ],
                  name-variants = predicates.oneOf
                      [
                        definitions.predicate.name-converters,
                        definitions.predicate.name-conversion-rules-multiple
                      ],
                }
                {  }
                true
                predicates.always
              ],
          reference-with-props = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  filter = predicates.isType '"String",
                  includeAbstract = predicates.isType '"Bool",
                  includeVirtual = predicates.isType '"Bool",
                  name-conversion =
                    definitions.predicate.reference-name-conversion,
                  path = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          required = predicates.isType '"Bool",
          since
            | doc m%"
            Version since this symbol is available.
            "%
            = predicates.isType '"String",
          source
            | doc m%"
            Allows to specify the source of the entity. For Vue.js component this may be for instance a class.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "file", "offset" ],
                    predicates.records.record
                    {
                      file = predicates.isType '"String",
                      offset = predicates.isType 'Integer,
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "symbol" ],
                    predicates.records.record
                    {
                      module = predicates.isType '"String",
                      symbol = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ]
              ],
          type = predicates.oneOf
              [
                definitions.predicate.type-reference,
                predicates.isType '"String"
              ],
          type-list
            | doc m%"
            Specify type according to selected language for type syntax. The type can be specified by a string expression, an object with list of imports and an expression, or an array of possible types.
            "%
            = predicates.oneOf
              [
                definitions.predicate.type,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.type
                ]
              ],
          type-reference = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  module = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          typed-contribution
            | doc m%"
            The base for any contribution, which can possibly have a JS type.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                definitions.predicate.base-contribution,
                predicates.records.record
                { type = definitions.predicate.type-list, }
                {  }
                true
                predicates.always
              ],
          virtual
            | doc m%"
            Mark contribution as virtual. Virtual contributions can be filtered out if needed in references. A virtual contribution meaning may differ by framework or kind contexts, but usually means something synthetic or something, which gets erased in the runtime by the framework. E.g. Vue or Angular attribute bindings are virtual. 
            "%
            = predicates.isType '"Bool",
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.required [ "name", "version" ],
  predicates.records.record
  {
    "$schema" = predicates.isType '"String",
    context = definitions.predicate.context,
    contexts-config = definitions.predicate.contexts-config,
    contributions = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            css = definitions.predicate.css,
            html = definitions.predicate.html,
            js = definitions.predicate.js-global,
          }
          {  }
          false
          predicates.never
        ],
    default-icon = definitions.predicate.icon,
    description-markup = definitions.predicate.description-markup,
    framework = predicates.isType '"String",
    framework-config = definitions.predicate.framework-config,
    js-types-syntax = definitions.predicate.js-types-syntax,
    name = predicates.isType '"String",
    version = predicates.isType '"String",
  }
  {  }
  false
  predicates.never
])