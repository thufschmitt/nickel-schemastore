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
          branches
            | doc m%"
            Only include commits based on their target branch. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#branches
            "%
            = predicates.contract_from_predicate definitions.predicate.branches,
          clone
            | doc m%"
            Configures the clone step. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#clone
            "%
            = { git | { image | String | optional, .. } | optional, },
          constraint_list = predicates.contract_from_predicate
              definitions.predicate.constraint_list,
          event_enum = predicates.contract_from_predicate
              definitions.predicate.event_enum,
          labels
            | doc m%"
            Configures the labels used for the agent selection. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#clone
            "%
            = predicates.contract_from_predicate definitions.predicate.labels,
          matrix
            | doc m%"
            Execute pipeline for each matrix combination. Read more: https://woodpecker-ci.org/docs/usage/matrix-pipelines
            "%
            = predicates.contract_from_predicate definitions.predicate.matrix,
          pipeline_when
            | doc m%"
            Whole pipelines can be skipped based on conditions. Read more: https://woodpecker-ci.org/docs/next/usage/pipeline-syntax#when---global-pipeline-conditions
            "%
            = predicates.contract_from_predicate
              definitions.predicate.pipeline_when,
          pipeline_when_condition = {
                branch
                  | definitions.contract.constraint_list
                  | doc m%"
                  Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#branch
                  "%
                  | optional,
                cron
                  | definitions.contract.constraint_list
                  | doc m%"
                  filter cron by title. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#cron
                  "%
                  | optional,
                environment
                  | definitions.contract.constraint_list
                  | doc m%"
                  Execute a step only for a specific environment. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#environment
                  "%
                  | optional,
                evaluate
                  | String
                  | doc m%"
                  Execute a step only if the expression evaluates to true. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#evaluate
                  "%
                  | optional,
                event
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.strings.minLength 1,
                      predicates.arrays.arrayOf definitions.predicate.event_enum
                    ],
                    definitions.predicate.event_enum
                  ])
                  | doc m%"
                  Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#event
                  "%
                  | optional,
                instance
                  | definitions.contract.constraint_list
                  | doc m%"
                  Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#instance
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
                    ],
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        exclude = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                        ignore_message = predicates.isType '"String",
                        include = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ]
                  ])
                  | doc m%"
                  Execute a step only on commit with certain files added/removed/modified. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#path
                  "%
                  | optional,
                platform
                  | definitions.contract.constraint_list
                  | doc m%"
                  Execute a step only on a specific platform. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#platform
                  "%
                  | optional,
                ref
                  | String
                  | doc m%"
                  Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#ref
                  "%
                  | optional,
                repo
                  | definitions.contract.constraint_list
                  | doc m%"
                  Execute a step only on a specific repository. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#repo
                  "%
                  | optional,
              },
          platform
            | doc m%"
            Configures the platform the pipeline will be executed on. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#platform
            "%
            = predicates.contract_from_predicate definitions.predicate.platform,
          service
            | doc m%"
            Read more: https://woodpecker-ci.org/docs/usage/services
            "%
            = predicates.contract_from_predicate definitions.predicate.service,
          services
            | doc m%"
            Read more: https://woodpecker-ci.org/docs/usage/services
            "%
            = predicates.contract_from_predicate definitions.predicate.services,
          step
            | doc m%"
            Every step of your pipeline executes arbitrary commands inside a specified docker container. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#steps
            "%
            = {
                backend_options
                  | definitions.contract.step_backend_options
                  | optional,
                commands | definitions.contract.step_commands | optional,
                detach
                  | Bool
                  | doc m%"
                  Detach a step to run in background until pipeline finishes. Read more: https://woodpecker-ci.org/docs/usage/services#detachment
                  "%
                  | optional,
                directory | definitions.contract.step_directory | optional,
                environment | definitions.contract.step_environment | optional,
                failure
                  | std.enum.TagOrString
                  | [| 'ignore, 'fail |]
                  | doc m%"
                  How to handle the failure of this step. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#failure
                  "%
                  | optional,
                group
                  | String
                  | doc m%"
                  Execute multiple steps with the same group key in parallel. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#step-group---parallel-execution
                  "%
                  | optional,
                image | definitions.contract.step_image,
                pull | definitions.contract.step_pull | optional,
                secrets | definitions.contract.step_secrets | optional,
                settings | definitions.contract.step_settings | optional,
                volumes | definitions.contract.step_volumes | optional,
                when | definitions.contract.step_when | optional,
              },
          step_backend_kubernetes
            | doc m%"
            Advanced options for the kubernetes agent backends
            "%
            = {
                resources
                  | definitions.contract.step_backend_kubernetes_resources
                  | optional,
                ..
              },
          step_backend_kubernetes_resources
            | doc m%"
            Resources for the kubernetes backend. Read more: https://woodpecker-ci.org/docs/administration/backends/kubernetes
            "%
            = {
                limits
                  | definitions.contract.step_kubernetes_resources_object
                  | optional,
                requests
                  | definitions.contract.step_kubernetes_resources_object
                  | optional,
                ..
              },
          step_backend_kubernetes_service_account
            | doc m%"
            serviceAccountName to be use by job. Read more: https://woodpecker-ci.org/docs/administration/backends/kubernetes
            "%
            = {
                limits
                  | definitions.contract.step_kubernetes_service_account_object
                  | optional,
                requests
                  | definitions.contract.step_kubernetes_service_account_object
                  | optional,
                ..
              },
          step_backend_options
            | doc m%"
            Advanced options for the different agent backends
            "%
            = {
                kubernetes
                  | definitions.contract.step_backend_kubernetes_resources
                  | optional,
                ..
              },
          step_commands
            | doc m%"
            Commands of every pipeline step are executed serially as if you would enter them into your local shell. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#commands
            "%
            = predicates.contract_from_predicate
              definitions.predicate.step_commands,
          step_directory
            | doc m%"
            Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#directory
            "%
            = String,
          step_environment
            | doc m%"
            Pass environment variables to a pipeline step. Read more: https://woodpecker-ci.org/docs/usage/environment
            "%
            = predicates.contract_from_predicate
              definitions.predicate.step_environment,
          step_image
            | doc m%"
            Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#image
            "%
            = String,
          step_kubernetes_resources_object
            | doc m%"
            A list of kubernetes resource mappings
            "%
            = predicates.contract_from_predicate
              definitions.predicate.step_kubernetes_resources_object,
          step_kubernetes_service_account_object
            | doc m%"
            A list of kubernetes resource mappings
            "%
            = predicates.contract_from_predicate
              definitions.predicate.step_kubernetes_service_account_object,
          step_list
            | doc m%"
            The steps section defines a list of steps which will be executed serially, in the order in which they are defined. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax
            "%
            = predicates.contract_from_predicate
              definitions.predicate.step_list,
          step_pull
            | doc m%"
            Always pull the latest image on pipeline execution Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#image
            "%
            = Bool,
          step_secrets
            | doc m%"
            Pass secrets to a pipeline step at runtime. Read more: https://woodpecker-ci.org/docs/usage/secrets
            "%
            = predicates.contract_from_predicate
              definitions.predicate.step_secrets,
          step_settings
            | doc m%"
            Change the settings of your plugin. Read more: https://woodpecker-ci.org/docs/usage/plugins/plugins
            "%
            = predicates.contract_from_predicate
              definitions.predicate.step_settings,
          step_volumes
            | doc m%"
            Mount files or folders from the host machine into your step container. Read more: https://woodpecker-ci.org/docs/usage/volumes
            "%
            = predicates.contract_from_predicate
              definitions.predicate.step_volumes,
          step_when
            | doc m%"
            Steps can be skipped based on conditions. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#when---conditional-execution
            "%
            = predicates.contract_from_predicate
              definitions.predicate.step_when,
          step_when_condition = {
                branch
                  | definitions.contract.constraint_list
                  | doc m%"
                  Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#branch
                  "%
                  | optional,
                cron
                  | definitions.contract.constraint_list
                  | doc m%"
                  filter cron by title. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#cron
                  "%
                  | optional,
                environment
                  | definitions.contract.constraint_list
                  | doc m%"
                  Execute a step only for a specific environment. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#environment
                  "%
                  | optional,
                evaluate
                  | String
                  | doc m%"
                  Execute a step only if the expression evaluates to true. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#evaluate
                  "%
                  | optional,
                event
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.strings.minLength 1,
                      predicates.arrays.arrayOf definitions.predicate.event_enum
                    ],
                    definitions.predicate.event_enum
                  ])
                  | doc m%"
                  Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#event
                  "%
                  | optional,
                instance
                  | definitions.contract.constraint_list
                  | doc m%"
                  Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#instance
                  "%
                  | optional,
                matrix
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.anyOf
                    [
                      predicates.isType '"Bool",
                      predicates.isType '"String",
                      predicates.isType '"Number"
                    ])
                  ])
                  | doc m%"
                  Read more: https://woodpecker-ci.org/docs/usage/matrix-pipelines
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
                    ],
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        exclude = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                        ignore_message = predicates.isType '"String",
                        include = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ]
                  ])
                  | doc m%"
                  Execute a step only on commit with certain files added/removed/modified. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#path
                  "%
                  | optional,
                platform
                  | definitions.contract.constraint_list
                  | doc m%"
                  Execute a step only on a specific platform. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#platform
                  "%
                  | optional,
                ref
                  | String
                  | doc m%"
                  Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#ref
                  "%
                  | optional,
                repo
                  | definitions.contract.constraint_list
                  | doc m%"
                  Execute a step only on a specific repository. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#repo
                  "%
                  | optional,
                status
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.strings.minLength 1,
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "success", "failure" ]
                      ])
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "success", "failure" ]
                    ]
                  ])
                  | doc m%"
                  Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#status
                  "%
                  | optional,
              },
          workspace
            | doc m%"
            Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#workspace
            "%
            = {  .. },
        },
    predicate = {
          branches
            | doc m%"
            Only include commits based on their target branch. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#branches
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String"),
                  predicates.records.minProperties 1,
                  predicates.records.record {  } {  } true predicates.always
                ],
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    exclude = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.strings.minLength 1,
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                          predicates.isType '"String"
                        ],
                    include = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.strings.minLength 1,
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                          predicates.isType '"String"
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          clone
            | doc m%"
            Configures the clone step. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#clone
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  git = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { image = predicates.isType '"String", }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          constraint_list = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.strings.minLength 1,
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    exclude = predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.strings.minLength 1,
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ]
                        ],
                    include = predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.strings.minLength 1,
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
          event_enum = predicates.enum
              [ "push", "pull_request", "tag", "deployment", "cron", "manual" ],
          labels
            | doc m%"
            Configures the labels used for the agent selection. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#clone
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.anyOf
                [
                  predicates.isType '"Bool",
                  predicates.isType '"String",
                  predicates.isType '"Number"
                ])
              ],
          matrix
            | doc m%"
            Execute pipeline for each matrix combination. Read more: https://woodpecker-ci.org/docs/usage/matrix-pipelines
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  include = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.strings.minLength 1,
                        predicates.arrays.arrayOf (predicates.isType 'Record)
                      ],
                }
                {  }
                true
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.strings.minLength 1,
                  predicates.arrays.arrayOf
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    predicates.isType '"String",
                    predicates.isType '"Number"
                  ])
                ])
              ],
          pipeline_when
            | doc m%"
            Whole pipelines can be skipped based on conditions. Read more: https://woodpecker-ci.org/docs/next/usage/pipeline-syntax#when---global-pipeline-conditions
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.strings.minLength 1,
                  predicates.arrays.arrayOf
                  definitions.predicate.pipeline_when_condition
                ],
                definitions.predicate.pipeline_when_condition
              ],
          pipeline_when_condition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  branch = definitions.predicate.constraint_list,
                  cron = definitions.predicate.constraint_list,
                  environment = definitions.predicate.constraint_list,
                  evaluate = predicates.isType '"String",
                  event = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.strings.minLength 1,
                          predicates.arrays.arrayOf
                          definitions.predicate.event_enum
                        ],
                        definitions.predicate.event_enum
                      ],
                  instance = definitions.predicate.constraint_list,
                  path = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            exclude = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            ignore_message = predicates.isType '"String",
                            include = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ],
                  platform = definitions.predicate.constraint_list,
                  ref = predicates.isType '"String",
                  repo = definitions.predicate.constraint_list,
                }
                {  }
                false
                predicates.never
              ],
          platform
            | doc m%"
            Configures the platform the pipeline will be executed on. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#platform
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.records.record {  } {  } false predicates.never
              ],
          service
            | doc m%"
            Read more: https://woodpecker-ci.org/docs/usage/services
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.minProperties 1,
                predicates.records.required [ "image" ],
                predicates.records.record
                {
                  commands = definitions.predicate.step_commands,
                  environment = definitions.predicate.step_environment,
                  image = definitions.predicate.step_image,
                  ports = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.strings.minLength 1,
                        predicates.arrays.arrayOf
                        (predicates.oneOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String"
                        ])
                      ],
                  pull = definitions.predicate.step_pull,
                  secrets = definitions.predicate.step_secrets,
                  settings = definitions.predicate.step_settings,
                  volumes = definitions.predicate.step_volumes,
                  when = definitions.predicate.step_when,
                }
                {  }
                false
                predicates.never
              ],
          services
            | doc m%"
            Read more: https://woodpecker-ci.org/docs/usage/services
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.minProperties 1,
                predicates.records.record {  } {  } true
                definitions.predicate.service
              ],
          step
            | doc m%"
            Every step of your pipeline executes arbitrary commands inside a specified docker container. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#steps
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image" ],
                predicates.records.record
                {
                  backend_options = definitions.predicate.step_backend_options,
                  commands = definitions.predicate.step_commands,
                  detach = predicates.isType '"Bool",
                  directory = definitions.predicate.step_directory,
                  environment = definitions.predicate.step_environment,
                  failure = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "fail", "ignore" ]
                      ],
                  group = predicates.isType '"String",
                  image = definitions.predicate.step_image,
                  pull = definitions.predicate.step_pull,
                  secrets = definitions.predicate.step_secrets,
                  settings = definitions.predicate.step_settings,
                  volumes = definitions.predicate.step_volumes,
                  when = definitions.predicate.step_when,
                }
                {  }
                false
                predicates.never
              ],
          step_backend_kubernetes
            | doc m%"
            Advanced options for the kubernetes agent backends
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  resources =
                    definitions.predicate.step_backend_kubernetes_resources,
                }
                {  }
                true
                predicates.always
              ],
          step_backend_kubernetes_resources
            | doc m%"
            Resources for the kubernetes backend. Read more: https://woodpecker-ci.org/docs/administration/backends/kubernetes
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  limits =
                    definitions.predicate.step_kubernetes_resources_object,
                  requests =
                    definitions.predicate.step_kubernetes_resources_object,
                }
                {  }
                true
                predicates.always
              ],
          step_backend_kubernetes_service_account
            | doc m%"
            serviceAccountName to be use by job. Read more: https://woodpecker-ci.org/docs/administration/backends/kubernetes
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  limits =
                    definitions.predicate.step_kubernetes_service_account_object,
                  requests =
                    definitions.predicate.step_kubernetes_service_account_object,
                }
                {  }
                true
                predicates.always
              ],
          step_backend_options
            | doc m%"
            Advanced options for the different agent backends
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  kubernetes =
                    definitions.predicate.step_backend_kubernetes_resources,
                }
                {  }
                true
                predicates.always
              ],
          step_commands
            | doc m%"
            Commands of every pipeline step are executed serially as if you would enter them into your local shell. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#commands
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.strings.minLength 1,
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.isType '"String"
              ],
          step_directory
            | doc m%"
            Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#directory
            "%
            = predicates.isType '"String",
          step_environment
            | doc m%"
            Pass environment variables to a pipeline step. Read more: https://woodpecker-ci.org/docs/usage/environment
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.strings.minLength 1,
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    predicates.isType '"String",
                    predicates.isType '"Number"
                  ])
                ]
              ],
          step_image
            | doc m%"
            Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#image
            "%
            = predicates.isType '"String",
          step_kubernetes_resources_object
            | doc m%"
            A list of kubernetes resource mappings
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          step_kubernetes_service_account_object
            | doc m%"
            A list of kubernetes resource mappings
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          step_list
            | doc m%"
            The steps section defines a list of steps which will be executed serially, in the order in which they are defined. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.minProperties 1,
                  predicates.records.record {  } {  } true
                  definitions.predicate.step
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.strings.minLength 1,
                  predicates.arrays.arrayOf definitions.predicate.step
                ]
              ],
          step_pull
            | doc m%"
            Always pull the latest image on pipeline execution Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#image
            "%
            = predicates.isType '"Bool",
          step_secrets
            | doc m%"
            Pass secrets to a pipeline step at runtime. Read more: https://woodpecker-ci.org/docs/usage/secrets
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.strings.minLength 1,
                predicates.arrays.arrayOf
                (predicates.oneOf
                [
                  predicates.isType '"String",
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "source", "target" ],
                    predicates.records.record
                    {
                      source = predicates.isType '"String",
                      target = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always
                  ]
                ])
              ],
          step_settings
            | doc m%"
            Change the settings of your plugin. Read more: https://woodpecker-ci.org/docs/usage/plugins/plugins
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.anyOf
                [
                  predicates.isType '"Bool",
                  predicates.isType '"String",
                  predicates.isType '"Number",
                  predicates.isType '"Array",
                  predicates.isType 'Record
                ])
              ],
          step_volumes
            | doc m%"
            Mount files or folders from the host machine into your step container. Read more: https://woodpecker-ci.org/docs/usage/volumes
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.strings.minLength 1,
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          step_when
            | doc m%"
            Steps can be skipped based on conditions. Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#when---conditional-execution
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.strings.minLength 1,
                  predicates.arrays.arrayOf
                  definitions.predicate.step_when_condition
                ],
                definitions.predicate.step_when_condition
              ],
          step_when_condition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  branch = definitions.predicate.constraint_list,
                  cron = definitions.predicate.constraint_list,
                  environment = definitions.predicate.constraint_list,
                  evaluate = predicates.isType '"String",
                  event = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.strings.minLength 1,
                          predicates.arrays.arrayOf
                          definitions.predicate.event_enum
                        ],
                        definitions.predicate.event_enum
                      ],
                  instance = definitions.predicate.constraint_list,
                  matrix = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"String",
                          predicates.isType '"Number"
                        ])
                      ],
                  path = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            exclude = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            ignore_message = predicates.isType '"String",
                            include = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ],
                  platform = definitions.predicate.constraint_list,
                  ref = predicates.isType '"String",
                  repo = definitions.predicate.constraint_list,
                  status = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.strings.minLength 1,
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "success", "failure" ]
                          ])
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "success", "failure" ]
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          workspace
            | doc m%"
            Read more: https://woodpecker-ci.org/docs/usage/pipeline-syntax#workspace
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true predicates.always
              ],
        },
  }
in

{
  "$schema" | String | optional,
  branches | definitions.contract.branches | optional,
  clone | definitions.contract.clone | optional,
  depends_on
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.strings.minLength 1,
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  labels | definitions.contract.labels | optional,
  matrix | definitions.contract.matrix | optional,
  pipeline
    | definitions.contract.step_list
    | doc m%"
    depricated, use steps
    "%
    | optional,
  platform | definitions.contract.platform | optional,
  runs_on
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.strings.minLength 1,
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  services | definitions.contract.services | optional,
  skip_clone | Bool | optional,
  steps | definitions.contract.step_list,
  variables
    | predicates.contract_from_predicate predicates.always
    | doc m%"
    Use yaml aliases to define variables. Read more: https://woodpecker-ci.org/docs/usage/advanced-yaml-syntax
    "%
    | optional,
  when | definitions.contract.pipeline_when | optional,
  workspace | definitions.contract.workspace | optional,
}