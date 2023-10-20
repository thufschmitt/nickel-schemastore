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
          Capabilities
            | doc m%"
            List of appx or msix installer capabilities
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Capabilities,
          Channel
            | doc m%"
            The distribution channel
            "%
            = predicates.contract_from_predicate definitions.predicate.Channel,
          Commands
            | doc m%"
            List of commands or aliases to run the package
            "%
            = predicates.contract_from_predicate definitions.predicate.Commands,
          Dependencies = predicates.contract_from_predicate
              definitions.predicate.Dependencies,
          FileExtensions
            | doc m%"
            List of file extensions the package could support
            "%
            = predicates.contract_from_predicate
              definitions.predicate.FileExtensions,
          InstallModes
            | doc m%"
            List of supported installer modes
            "%
            = predicates.contract_from_predicate
              definitions.predicate.InstallModes,
          Installer = {
                Architecture
                  | std.enum.TagOrString
                  | [| 'neutral, 'arm64, 'arm, 'x64, 'x86 |]
                  | doc m%"
                  The installer target architecture
                  "%,
                Capabilities | definitions.contract.Capabilities | optional,
                Commands | definitions.contract.Commands | optional,
                Dependencies | definitions.contract.Dependencies | optional,
                FileExtensions | definitions.contract.FileExtensions | optional,
                InstallModes | definitions.contract.InstallModes | optional,
                InstallerLocale | definitions.contract.Locale | optional,
                InstallerSha256
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^[A-Fa-f0-9]{64}$"
                  ])
                  | doc m%"
                  Sha256 is required. Sha256 of the installer
                  "%,
                InstallerSuccessCodes
                  | definitions.contract.InstallerSuccessCodes
                  | optional,
                InstallerSwitches
                  | definitions.contract.InstallerSwitches
                  | optional,
                InstallerType | definitions.contract.InstallerType | optional,
                InstallerUrl
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^([Hh][Tt][Tt][Pp][Ss]?)://.+$"
                  ])
                  | doc m%"
                  The installer Url
                  "%,
                MinimumOSVersion
                  | definitions.contract.MinimumOSVersion
                  | optional,
                PackageFamilyName
                  | definitions.contract.PackageFamilyName
                  | optional,
                Platform | definitions.contract.Platform | optional,
                ProductCode | definitions.contract.ProductCode | optional,
                Protocols | definitions.contract.Protocols | optional,
                RestrictedCapabilities
                  | definitions.contract.RestrictedCapabilities
                  | optional,
                Scope | definitions.contract.Scope | optional,
                SignatureSha256
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                    predicates.strings.pattern "^[A-Fa-f0-9]{64}$"
                  ])
                  | doc m%"
                  SignatureSha256 is recommended for appx or msix. It is the sha256 of signature file inside appx or msix. Could be used during streaming install if applicable
                  "%
                  | optional,
                UpgradeBehavior
                  | definitions.contract.UpgradeBehavior
                  | optional,
                ..
              },
          InstallerSuccessCodes
            | doc m%"
            List of additional non-zero installer success exit codes other than known default values by winget
            "%
            = predicates.contract_from_predicate
              definitions.predicate.InstallerSuccessCodes,
          InstallerSwitches = {
                Custom
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                    predicates.strings.maxLength 2048,
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Custom switches will be passed directly to the installer by winget
                  "%
                  | optional,
                InstallLocation
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                    predicates.strings.maxLength 512,
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  InstallLocation is the value passed to the installer for custom install location. <INSTALLPATH> token can be included in the switch value so that winget will replace the token with user provided path
                  "%
                  | optional,
                Interactive
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                    predicates.strings.maxLength 512,
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Interactive is the value that should be passed to the installer when user chooses an interactive install
                  "%
                  | optional,
                Log
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                    predicates.strings.maxLength 512,
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Log is the value passed to the installer for custom log file path. <LOGPATH> token can be included in the switch value so that winget will replace the token with user provided path
                  "%
                  | optional,
                Silent
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                    predicates.strings.maxLength 512,
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Silent is the value that should be passed to the installer when user chooses a silent or quiet install
                  "%
                  | optional,
                SilentWithProgress
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                    predicates.strings.maxLength 512,
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  SilentWithProgress is the value that should be passed to the installer when user chooses a non-interactive install
                  "%
                  | optional,
                Upgrade
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                    predicates.strings.maxLength 512,
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Upgrade is the value that should be passed to the installer when user chooses an upgrade
                  "%
                  | optional,
                ..
              },
          InstallerType
            | doc m%"
            Enumeration of supported installer types
            "%
            = predicates.contract_from_predicate
              definitions.predicate.InstallerType,
          Locale
            | doc m%"
            The package meta-data locale
            "%
            = predicates.contract_from_predicate definitions.predicate.Locale,
          MinimumOSVersion
            | doc m%"
            The installer minimum operating system version
            "%
            = predicates.contract_from_predicate
              definitions.predicate.MinimumOSVersion,
          PackageFamilyName
            | doc m%"
            PackageFamilyName for appx or msix installer. Could be used for correlation of packages across sources
            "%
            = predicates.contract_from_predicate
              definitions.predicate.PackageFamilyName,
          PackageIdentifier
            | doc m%"
            The package unique identifier
            "%
            = predicates.contract_from_predicate
              definitions.predicate.PackageIdentifier,
          PackageVersion
            | doc m%"
            The package version
            "%
            = predicates.contract_from_predicate
              definitions.predicate.PackageVersion,
          Platform
            | doc m%"
            The installer supported operating system
            "%
            = predicates.contract_from_predicate definitions.predicate.Platform,
          ProductCode
            | doc m%"
            ProductCode could be used for correlation of packages across sources
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ProductCode,
          Protocols
            | doc m%"
            List of protocols the package provides a handler for
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Protocols,
          RestrictedCapabilities
            | doc m%"
            List of appx or msix installer restricted capabilities
            "%
            = predicates.contract_from_predicate
              definitions.predicate.RestrictedCapabilities,
          Scope
            | doc m%"
            Scope indicates if the installer is per user or per machine
            "%
            = predicates.contract_from_predicate definitions.predicate.Scope,
          UpgradeBehavior
            | doc m%"
            The upgrade method
            "%
            = predicates.contract_from_predicate
              definitions.predicate.UpgradeBehavior,
        },
    predicate = {
          Capabilities
            | doc m%"
            List of appx or msix installer capabilities
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.maxLength 40,
                  predicates.strings.minLength 1
                ]),
                predicates.arrays.maxItems 1000,
                predicates.arrays.uniqueItems
              ],
          Channel
            | doc m%"
            The distribution channel
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"String", predicates.isType 'Null ],
                predicates.strings.maxLength 16,
                predicates.strings.minLength 1
              ],
          Commands
            | doc m%"
            List of commands or aliases to run the package
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.maxLength 40,
                  predicates.strings.minLength 1
                ]),
                predicates.arrays.maxItems 16,
                predicates.arrays.uniqueItems
              ],
          Dependencies = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record
                {
                  ExternalDependencies = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.maxLength 128,
                          predicates.strings.minLength 1
                        ]),
                        predicates.arrays.maxItems 16,
                        predicates.arrays.uniqueItems
                      ],
                  PackageDependencies = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "PackageIdentifier" ],
                          predicates.records.record
                          {
                            MinimumVersion =
                              definitions.predicate.PackageVersion,
                            PackageIdentifier =
                              definitions.predicate.PackageIdentifier,
                          }
                          {  }
                          true
                          predicates.always
                        ]),
                        predicates.arrays.maxItems 16,
                        predicates.arrays.uniqueItems
                      ],
                  WindowsFeatures = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.maxLength 128,
                          predicates.strings.minLength 1
                        ]),
                        predicates.arrays.maxItems 16,
                        predicates.arrays.uniqueItems
                      ],
                  WindowsLibraries = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.maxLength 128,
                          predicates.strings.minLength 1
                        ]),
                        predicates.arrays.maxItems 16,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                true
                predicates.always
              ],
          FileExtensions
            | doc m%"
            List of file extensions the package could support
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.maxLength 40,
                  predicates.strings.pattern
                  "^[^\\\\/:\\*\\?\"<>\\|\\x01-\\x1f]+$"
                ]),
                predicates.arrays.maxItems 256,
                predicates.arrays.uniqueItems
              ],
          InstallModes
            | doc m%"
            List of supported installer modes
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum
                  [ "interactive", "silent", "silentWithProgress" ]
                ]),
                predicates.arrays.maxItems 3,
                predicates.arrays.uniqueItems
              ],
          Installer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "Architecture", "InstallerSha256", "InstallerUrl" ],
                predicates.records.record
                {
                  Architecture = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "x86", "x64", "arm", "arm64", "neutral" ]
                      ],
                  Capabilities = definitions.predicate.Capabilities,
                  Commands = definitions.predicate.Commands,
                  Dependencies = definitions.predicate.Dependencies,
                  FileExtensions = definitions.predicate.FileExtensions,
                  InstallModes = definitions.predicate.InstallModes,
                  InstallerLocale = definitions.predicate.Locale,
                  InstallerSha256 = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^[A-Fa-f0-9]{64}$"
                      ],
                  InstallerSuccessCodes =
                    definitions.predicate.InstallerSuccessCodes,
                  InstallerSwitches = definitions.predicate.InstallerSwitches,
                  InstallerType = definitions.predicate.InstallerType,
                  InstallerUrl = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^([Hh][Tt][Tt][Pp][Ss]?)://.+$"
                      ],
                  MinimumOSVersion = definitions.predicate.MinimumOSVersion,
                  PackageFamilyName = definitions.predicate.PackageFamilyName,
                  Platform = definitions.predicate.Platform,
                  ProductCode = definitions.predicate.ProductCode,
                  Protocols = definitions.predicate.Protocols,
                  RestrictedCapabilities =
                    definitions.predicate.RestrictedCapabilities,
                  Scope = definitions.predicate.Scope,
                  SignatureSha256 = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.strings.pattern "^[A-Fa-f0-9]{64}$"
                      ],
                  UpgradeBehavior = definitions.predicate.UpgradeBehavior,
                }
                {  }
                true
                predicates.always
              ],
          InstallerSuccessCodes
            | doc m%"
            List of additional non-zero installer success exit codes other than known default values by winget
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Integer,
                  predicates.not (predicates.enum [ 0 ])
                ]),
                predicates.arrays.maxItems 16,
                predicates.arrays.uniqueItems
              ],
          InstallerSwitches = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  Custom = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.strings.maxLength 2048,
                        predicates.strings.minLength 1
                      ],
                  InstallLocation = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.strings.maxLength 512,
                        predicates.strings.minLength 1
                      ],
                  Interactive = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.strings.maxLength 512,
                        predicates.strings.minLength 1
                      ],
                  Log = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.strings.maxLength 512,
                        predicates.strings.minLength 1
                      ],
                  Silent = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.strings.maxLength 512,
                        predicates.strings.minLength 1
                      ],
                  SilentWithProgress = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.strings.maxLength 512,
                        predicates.strings.minLength 1
                      ],
                  Upgrade = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.strings.maxLength 512,
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                true
                predicates.always
              ],
          InstallerType
            | doc m%"
            Enumeration of supported installer types
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"String", predicates.isType 'Null ],
                predicates.enum
                [
                  "msix",
                  "msi",
                  "appx",
                  "exe",
                  "zip",
                  "inno",
                  "nullsoft",
                  "wix",
                  "burn",
                  "pwa"
                ]
              ],
          Locale
            | doc m%"
            The package meta-data locale
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"String", predicates.isType 'Null ],
                predicates.strings.maxLength 20,
                predicates.strings.minLength 1
              ],
          MinimumOSVersion
            | doc m%"
            The installer minimum operating system version
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"String", predicates.isType 'Null ],
                predicates.strings.pattern
                "^(0|[1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])(\\.(0|[1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])){0,3}$"
              ],
          PackageFamilyName
            | doc m%"
            PackageFamilyName for appx or msix installer. Could be used for correlation of packages across sources
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"String", predicates.isType 'Null ],
                predicates.strings.maxLength 255,
                predicates.strings.pattern
                "^[A-Za-z0-9][-\\.A-Za-z0-9]+_[A-Za-z0-9]{13}$"
              ],
          PackageIdentifier
            | doc m%"
            The package unique identifier
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 128,
                predicates.strings.pattern
                "^[^\\.\\s\\\\/:\\*\\?\"<>\\|\\x01-\\x1f]{1,32}(\\.[^\\.\\s\\\\/:\\*\\?\"<>\\|\\x01-\\x1f]{1,32}){1,3}$"
              ],
          PackageVersion
            | doc m%"
            The package version
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 128,
                predicates.strings.pattern
                "^[^\\\\/:\\*\\?\"<>\\|\\x01-\\x1f]+$"
              ],
          Platform
            | doc m%"
            The installer supported operating system
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "Windows.Desktop", "Windows.Universal" ]
                ]),
                predicates.arrays.maxItems 2,
                predicates.arrays.uniqueItems
              ],
          ProductCode
            | doc m%"
            ProductCode could be used for correlation of packages across sources
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"String", predicates.isType 'Null ],
                predicates.strings.maxLength 255,
                predicates.strings.minLength 1
              ],
          Protocols
            | doc m%"
            List of protocols the package provides a handler for
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.maxLength 2048,
                  predicates.strings.pattern "^[a-z][-a-z0-9\\.\\+]*$"
                ]),
                predicates.arrays.maxItems 16,
                predicates.arrays.uniqueItems
              ],
          RestrictedCapabilities
            | doc m%"
            List of appx or msix installer restricted capabilities
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.maxLength 40,
                  predicates.strings.minLength 1
                ]),
                predicates.arrays.maxItems 1000,
                predicates.arrays.uniqueItems
              ],
          Scope
            | doc m%"
            Scope indicates if the installer is per user or per machine
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"String", predicates.isType 'Null ],
                predicates.enum [ "user", "machine" ]
              ],
          UpgradeBehavior
            | doc m%"
            The upgrade method
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"String", predicates.isType 'Null ],
                predicates.enum [ "install", "uninstallPrevious" ]
              ],
        },
  }
in

{
  Capabilities | definitions.contract.Capabilities | optional,
  Channel | definitions.contract.Channel | optional,
  Commands | definitions.contract.Commands | optional,
  Dependencies | definitions.contract.Dependencies | optional,
  FileExtensions | definitions.contract.FileExtensions | optional,
  InstallModes | definitions.contract.InstallModes | optional,
  InstallerLocale | definitions.contract.Locale | optional,
  InstallerSuccessCodes | definitions.contract.InstallerSuccessCodes | optional,
  InstallerSwitches | definitions.contract.InstallerSwitches | optional,
  InstallerType | definitions.contract.InstallerType | optional,
  Installers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.Installer,
      predicates.arrays.maxItems 128,
      predicates.arrays.minItems 1
    ]),
  ManifestType
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.const "installer" ])
    | doc m%"
    The manifest type
    "%,
  ManifestVersion
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"String",
      predicates.strings.pattern
      "^(0|[1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])(\\.(0|[1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])){2}$"
    ])
    | doc m%"
    The manifest syntax version
    "%,
  MinimumOSVersion | definitions.contract.MinimumOSVersion | optional,
  PackageFamilyName | definitions.contract.PackageFamilyName | optional,
  PackageIdentifier | definitions.contract.PackageIdentifier,
  PackageVersion | definitions.contract.PackageVersion,
  Platform | definitions.contract.Platform | optional,
  ProductCode | definitions.contract.ProductCode | optional,
  Protocols | definitions.contract.Protocols | optional,
  RestrictedCapabilities
    | definitions.contract.RestrictedCapabilities
    | optional,
  Scope | definitions.contract.Scope | optional,
  UpgradeBehavior | definitions.contract.UpgradeBehavior | optional,
  ..
}