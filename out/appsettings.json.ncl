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
          ElmahIo = predicates.contract_from_predicate
              definitions.predicate.ElmahIo,
          NLog
            | doc m%"
            NLog configuration
            "%
            = {
                autoReload
                  | Bool
                  | doc m%"
                  Automatically reload the NLog configuration when notified that appsettings.json file has changed.
                  "%
                  | optional,
                autoShutdown
                  | Bool
                  | doc m%"
                  Automatically call `LogFactory.Shutdown` on AppDomain.Unload or AppDomain.ProcessExit
                  "%
                  | optional,
                extensions
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
                        assembly = predicates.isType '"String",
                        assemblyFile = predicates.isType '"String",
                        prefix = predicates.isType '"String",
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ])
                  | doc m%"
                  Load NLog extension packages for additional targets and layouts
                  "%
                  | optional,
                globalThreshold
                  | std.enum.TagOrString
                  | [| 'Off, 'Fatal, 'Error, 'Warn, 'Info, 'Debug, 'Trace |]
                  | doc m%"
                  Log events below this threshold are not logged.
                  "%
                  | optional,
                internalLogFile
                  | String
                  | doc m%"
                  Write internal log to the specified filepath
                  "%
                  | optional,
                internalLogLevel
                  | std.enum.TagOrString
                  | [| 'Off, 'Fatal, 'Error, 'Warn, 'Info, 'Debug, 'Trace |]
                  | doc m%"
                  The minimal log level for the internal logger.
                  "%
                  | optional,
                internalLogToConsole
                  | Bool
                  | doc m%"
                  Write internal log to a console
                  "%
                  | optional,
                internalLogToConsoleError
                  | Bool
                  | doc m%"
                  Write internal log to a console with error stream
                  "%
                  | optional,
                rules
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.NLogRulesItem
                    ],
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.propertyNames
                      (predicates.strings.pattern "^[0-9]+$"),
                      predicates.records.record {  }
                      { ".*" = definitions.predicate.NLogRulesItem, }
                      true
                      predicates.always
                    ]
                  ])
                  | optional,
                targetDefaultWrapper
                  | {
                    type
                      | String
                      | doc m%"
                      
                      "%,
                    ..
                  }
                  | doc m%"
                  Wrap all defined targets with this custom target wrapper.
                  "%
                  | optional,
                targets
                  | {
                    async
                      | Bool
                      | doc m%"
                      Wrap all defined targets using AsyncWrapper with OverflowAction=Discard for better performance.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  
                  "%
                  | optional,
                throwConfigExceptions
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Throws an exception when there is a config error? If not set, then throwExceptions will be used for this setting.
                  "%
                  | optional,
                throwExceptions
                  | Bool
                  | doc m%"
                  Throws an exception when there is an error. For unit testing only and advanced troubleshooting.
                  "%
                  | optional,
                variables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.propertyNames
                    (predicates.strings.pattern "^[A-Za-z0-9_.-]+$"),
                    predicates.records.record {  }
                    {
                      ".*" = predicates.anyOf
                          [
                            predicates.isType '"Number",
                            predicates.isType '"String",
                            predicates.isType '"Bool"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Key-value pair of variables
                  "%
                  | optional,
                ..
              },
          NLogRulesItem
            | doc m%"
            Redirect LogEvents from matching Logger objects to specified targets
            "%
            = {
                enabled
                  | Bool
                  | doc m%"
                  
                  "%
                  | optional,
                filterDefaultAction
                  | std.enum.TagOrString
                  | [| 'IgnoreFinal, 'LogFinal, 'Ignore, 'Log, 'Neutral |]
                  | doc m%"
                  Default action if none of the filters match.
                  "%
                  | optional,
                filters
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "type" ],
                        predicates.records.record
                        {
                          action = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "Neutral",
                                  "Log",
                                  "Ignore",
                                  "LogFinal",
                                  "IgnoreFinal"
                                ]
                              ],
                          type = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ])
                    ],
                    predicates.isType 'Record
                  ])
                  | optional,
                final
                  | Bool
                  | doc m%"
                  Ignore further rules if this one matches.
                  "%
                  | optional,
                finalMinLevel
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum
                      [ "Trace", "Debug", "Info", "Warn", "Error", "Fatal" ]
                    ],
                    predicates.isType '"String"
                  ])
                  | optional,
                level
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum
                      [ "Trace", "Debug", "Info", "Warn", "Error", "Fatal" ]
                    ],
                    predicates.isType '"String"
                  ])
                  | optional,
                levels
                  | String
                  | doc m%"
                  Comma separated list of levels that this rule matches.
                  "%
                  | optional,
                logger
                  | String
                  | doc m%"
                  Match Logger objects based on their Logger-name. Can use wildcard characters ('*' or '?').
                  "%,
                maxLevel
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum
                      [ "Trace", "Debug", "Info", "Warn", "Error", "Fatal" ]
                    ],
                    predicates.isType '"String"
                  ])
                  | optional,
                minLevel
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum
                      [ "Trace", "Debug", "Info", "Warn", "Error", "Fatal" ]
                    ],
                    predicates.isType '"String"
                  ])
                  | optional,
                ruleName
                  | String
                  | doc m%"
                  Rule identifier to allow rule lookup with Configuration.FindRuleByName and Configuration.RemoveRuleByName.
                  "%
                  | optional,
                writeTo
                  | String
                  | doc m%"
                  Name or names of a target - separated by comma. Remove this property for sending events to the blackhole.
                  "%
                  | optional,
                ..
              },
          allowedHosts
            | doc m%"
            ASP.NET Core host filtering middleware configuration. Allowed hosts is a semicolon-delimited list of host names without port numbers. Requests without a matching host name will be refused. Host names may be prefixed with a '*.' wildcard, or use '*' to allow all hosts.
            "%
            = String,
          cdn
            | doc m%"
            Definitions for WebEssentials.AspNetCore.CdnTagHelpers
            "%
            = {
                prefetch
                  | Bool
                  | doc m%"
                  If true, injects a <link rel='dns-prefetch'> tag that speeds up DNS resolution to the CDN.
                  "%
                  | optional,
                url
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^((//|https?://).+|)$"
                  ])
                  | doc m%"
                  An absolute URL used as a prefix for static resources
                  "%
                  | optional,
                ..
              },
          certificate
            | doc m%"
            Certificate configuration.
            "%
            = {
                AllowInvalid
                  | Bool
                  | doc m%"
                  A value indicating whether or not to load certificates that are considered invalid. Defaults to false.
                  "%
                  | optional,
                KeyPath
                  | String
                  | doc m%"
                  The certificate key file path. Available in .NET 5 and later.
                  "%
                  | optional,
                Location
                  | std.enum.TagOrString
                  | [| 'CurrentUser, 'LocalMachine |]
                  | doc m%"
                  The certificate store location. Defaults to 'CurrentUser'.
                  "%
                  | optional,
                Password
                  | String
                  | doc m%"
                  The certificate password used to access the private key.
                  "%
                  | optional,
                Path
                  | String
                  | doc m%"
                  The certificate file path. If a file path is specified then the certificate will be loaded from the file system.
                  "%
                  | optional,
                Store
                  | String
                  | doc m%"
                  The certificate store name. Defaults to 'My'.
                  "%
                  | optional,
                Subject
                  | String
                  | doc m%"
                  The certificate subject. If a subject is specified then the certificate will be loaded from the certificate store.
                  "%
                  | optional,
                ..
              },
          clientCertificateMode
            | doc m%"
            Specifies the client certificate requirements for a HTTPS connection. Defaults to 'NoCertificate'. Available in .NET 5 and later.
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'RequireCertificate, 'AllowCertificate, 'NoCertificate |]
              ],
          connectionStrings
            | doc m%"
            Connection string configuration. Get connection strings with the IConfiguration.GetConnectionString(string) extension method.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.connectionStrings,
          kestrel
            | doc m%"
            ASP.NET Core Kestrel server configuration.
            "%
            = {
                Certificates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.certificate
                  ])
                  | doc m%"
                  Certificates that Kestrel uses with HTTPS endpoints. Each certificate has a name specified by its JSON property name. The 'Default' certificate is used by HTTPS endpoints that haven't specified a certificate.
                  "%
                  | optional,
                EndpointDefaults
                  | {
                    ClientCertificateMode
                      | definitions.contract.clientCertificateMode
                      | optional,
                    Protocols | definitions.contract.protocols | optional,
                    SslProtocols | definitions.contract.sslProtocols | optional,
                    ..
                  }
                  | doc m%"
                  Default configuration applied to all endpoints. Named endpoint specific configuration overrides defaults.
                  "%
                  | optional,
                Endpoints
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "Url" ],
                      predicates.records.record
                      {
                        Certificate = definitions.predicate.certificate,
                        ClientCertificateMode =
                          definitions.predicate.clientCertificateMode,
                        Protocols = definitions.predicate.protocols,
                        Sni = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record {  } {  } true
                              (predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  Certificate =
                                    definitions.predicate.certificate,
                                  ClientCertificateMode =
                                    definitions.predicate.clientCertificateMode,
                                  Protocols = definitions.predicate.protocols,
                                  SslProtocols =
                                    definitions.predicate.sslProtocols,
                                }
                                {  }
                                true
                                predicates.always
                              ])
                            ],
                        SslProtocols = definitions.predicate.sslProtocols,
                        Url = predicates.isType '"String",
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ])
                  | doc m%"
                  Endpoints that Kestrel listens to for network requests. Each endpoint has a name specified by its JSON property name.
                  "%
                  | optional,
                ..
              },
          logLevel
            | doc m%"
            Log level configurations used when creating logs. Only logs that exceeds its matching log level will be enabled. Each log level configuration has a category specified by its JSON property name. For more information about configuring log levels, see https://docs.microsoft.com/aspnet/core/fundamentals/logging/#configure-logging.
            "%
            = predicates.contract_from_predicate definitions.predicate.logLevel,
          logLevelThreshold
            | doc m%"
            Log level threshold.
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'None,
                  'Critical,
                  'Error,
                  'Warning,
                  'Information,
                  'Debug,
                  'Trace
                |]
              ],
          logging
            | doc m%"
            Configuration for Microsoft.Extensions.Logging.
            "%
            = predicates.contract_from_predicate definitions.predicate.logging,
          protocols
            | doc m%"
            The protocols enabled on the endpoint.
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'Http1AndHttp2AndHttp3,
                  'Http3,
                  'Http1AndHttp2,
                  'Http2,
                  'Http1,
                  'None
                |]
              ],
          pwa = predicates.contract_from_predicate definitions.predicate.pwa,
          sslProtocols
            | doc m%"
            Specifies allowable SSL protocols. Defaults to 'None' which allows the operating system to choose the best protocol to use, and to block protocols that are not secure. Unless your app has a specific reason not to, you should use this default. Available in .NET 5 and later.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.sslProtocols,
          webOptimizer
            | doc m%"
            Settings for WebOptimizer.Core
            "%
            = {
                enableCaching
                  | Bool
                  | doc m%"
                  Determines if the "cache-control" HTTP headers should be set and if conditional GET (304) requests should be supported. This could be helpful to disable while in development mode.
                  "%
                  | optional,
                enableTagHelperBundling
                  | Bool
                  | doc m%"
                  Determines if `<script>` and `<link>` elements should point to the bundled path or a reference per source file should be created. This is helpful to disable when in development mode.
                  "%
                  | optional,
                ..
              },
        },
    predicate = {
          ElmahIo = predicates.allOf
              [
                predicates.records.required [ "ApiKey", "LogId" ],
                predicates.records.record
                {
                  ApiKey = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^([0-9a-f]{32})|(#\\{.*\\}#?)$"
                      ],
                  Application = predicates.isType '"String",
                  HandledStatusCodesToLog = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType 'Integer)
                      ],
                  HeartbeatId = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^([0-9a-f]{32})|(#\\{.*\\}#?)$"
                      ],
                  LogId = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})|(#\\{.*\\}#?)$"
                      ],
                  TreatLoggingAsBreadcrumbs = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          NLog
            | doc m%"
            NLog configuration
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  autoReload = predicates.isType '"Bool",
                  autoShutdown = predicates.isType '"Bool",
                  extensions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            assembly = predicates.isType '"String",
                            assemblyFile = predicates.isType '"String",
                            prefix = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ])
                      ],
                  globalThreshold = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Trace",
                          "Debug",
                          "Info",
                          "Warn",
                          "Error",
                          "Fatal",
                          "Off"
                        ]
                      ],
                  internalLogFile = predicates.isType '"String",
                  internalLogLevel = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Trace",
                          "Debug",
                          "Info",
                          "Warn",
                          "Error",
                          "Fatal",
                          "Off"
                        ]
                      ],
                  internalLogToConsole = predicates.isType '"Bool",
                  internalLogToConsoleError = predicates.isType '"Bool",
                  rules = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.NLogRulesItem
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.propertyNames
                          (predicates.strings.pattern "^[0-9]+$"),
                          predicates.records.record {  }
                          { ".*" = definitions.predicate.NLogRulesItem, }
                          true
                          predicates.always
                        ]
                      ],
                  targetDefaultWrapper = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "type" ],
                        predicates.records.record
                        { type = predicates.isType '"String", }
                        {  }
                        true
                        predicates.always
                      ],
                  targets = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { async = predicates.isType '"Bool", }
                        {  }
                        true
                        predicates.always
                      ],
                  throwConfigExceptions = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  throwExceptions = predicates.isType '"Bool",
                  variables = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.propertyNames
                        (predicates.strings.pattern "^[A-Za-z0-9_.-]+$"),
                        predicates.records.record {  }
                        {
                          ".*" = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.isType '"String",
                                predicates.isType '"Bool"
                              ],
                        }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          NLogRulesItem
            | doc m%"
            Redirect LogEvents from matching Logger objects to specified targets
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "logger" ],
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  filterDefaultAction = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Neutral",
                          "Log",
                          "Ignore",
                          "LogFinal",
                          "IgnoreFinal"
                        ]
                      ],
                  filters = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "type" ],
                            predicates.records.record
                            {
                              action = predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.enum
                                    [
                                      "Neutral",
                                      "Log",
                                      "Ignore",
                                      "LogFinal",
                                      "IgnoreFinal"
                                    ]
                                  ],
                              type = predicates.isType '"String",
                            }
                            {  }
                            true
                            predicates.always
                          ])
                        ],
                        predicates.isType 'Record
                      ],
                  final = predicates.isType '"Bool",
                  finalMinLevel = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "Trace", "Debug", "Info", "Warn", "Error", "Fatal" ]
                        ],
                        predicates.isType '"String"
                      ],
                  level = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "Trace", "Debug", "Info", "Warn", "Error", "Fatal" ]
                        ],
                        predicates.isType '"String"
                      ],
                  levels = predicates.isType '"String",
                  logger = predicates.isType '"String",
                  maxLevel = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "Trace", "Debug", "Info", "Warn", "Error", "Fatal" ]
                        ],
                        predicates.isType '"String"
                      ],
                  minLevel = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "Trace", "Debug", "Info", "Warn", "Error", "Fatal" ]
                        ],
                        predicates.isType '"String"
                      ],
                  ruleName = predicates.isType '"String",
                  writeTo = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          allowedHosts
            | doc m%"
            ASP.NET Core host filtering middleware configuration. Allowed hosts is a semicolon-delimited list of host names without port numbers. Requests without a matching host name will be refused. Host names may be prefixed with a '*.' wildcard, or use '*' to allow all hosts.
            "%
            = predicates.isType '"String",
          cdn
            | doc m%"
            Definitions for WebEssentials.AspNetCore.CdnTagHelpers
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  prefetch = predicates.isType '"Bool",
                  url = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^((//|https?://).+|)$"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          certificate
            | doc m%"
            Certificate configuration.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  AllowInvalid = predicates.isType '"Bool",
                  KeyPath = predicates.isType '"String",
                  Location = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "LocalMachine", "CurrentUser" ]
                      ],
                  Password = predicates.isType '"String",
                  Path = predicates.isType '"String",
                  Store = predicates.isType '"String",
                  Subject = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          clientCertificateMode
            | doc m%"
            Specifies the client certificate requirements for a HTTPS connection. Defaults to 'NoCertificate'. Available in .NET 5 and later.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "NoCertificate", "AllowCertificate", "RequireCertificate" ]
              ],
          connectionStrings
            | doc m%"
            Connection string configuration. Get connection strings with the IConfiguration.GetConnectionString(string) extension method.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          kestrel
            | doc m%"
            ASP.NET Core Kestrel server configuration.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  Certificates = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.certificate
                      ],
                  EndpointDefaults = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          ClientCertificateMode =
                            definitions.predicate.clientCertificateMode,
                          Protocols = definitions.predicate.protocols,
                          SslProtocols = definitions.predicate.sslProtocols,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  Endpoints = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "Url" ],
                          predicates.records.record
                          {
                            Certificate = definitions.predicate.certificate,
                            ClientCertificateMode =
                              definitions.predicate.clientCertificateMode,
                            Protocols = definitions.predicate.protocols,
                            Sni = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record {  } {  } true
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      Certificate =
                                        definitions.predicate.certificate,
                                      ClientCertificateMode =
                                        definitions.predicate.clientCertificateMode,
                                      Protocols =
                                        definitions.predicate.protocols,
                                      SslProtocols =
                                        definitions.predicate.sslProtocols,
                                    }
                                    {  }
                                    true
                                    predicates.always
                                  ])
                                ],
                            SslProtocols = definitions.predicate.sslProtocols,
                            Url = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ])
                      ],
                }
                {  }
                true
                predicates.always
              ],
          logLevel
            | doc m%"
            Log level configurations used when creating logs. Only logs that exceeds its matching log level will be enabled. Each log level configuration has a category specified by its JSON property name. For more information about configuring log levels, see https://docs.microsoft.com/aspnet/core/fundamentals/logging/#configure-logging.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                definitions.predicate.logLevelThreshold
              ],
          logLevelThreshold
            | doc m%"
            Log level threshold.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "Trace",
                  "Debug",
                  "Information",
                  "Warning",
                  "Error",
                  "Critical",
                  "None"
                ]
              ],
          logging
            | doc m%"
            Configuration for Microsoft.Extensions.Logging.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  Console = predicates.records.record
                      {
                        FormatterName = predicates.isType '"String",
                        FormatterOptions = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                IncludeScopes = predicates.isType '"Bool",
                                TimestampFormat = predicates.isType '"String",
                                UseUtcTimestamp = predicates.isType '"Bool",
                              }
                              {  }
                              true
                              predicates.always
                            ],
                        LogLevel = definitions.predicate.logLevel,
                        LogToStandardErrorThreshold =
                          definitions.predicate.logLevelThreshold,
                      }
                      {  }
                      true
                      predicates.always,
                  Debug = predicates.records.record
                      { LogLevel = definitions.predicate.logLevel, }
                      {  }
                      true
                      predicates.always,
                  ElmahIo = predicates.records.record
                      { LogLevel = definitions.predicate.logLevel, }
                      {  }
                      true
                      predicates.always,
                  ElmahIoBreadcrumbs = predicates.records.record
                      { LogLevel = definitions.predicate.logLevel, }
                      {  }
                      true
                      predicates.always,
                  EventLog = predicates.records.record
                      { LogLevel = definitions.predicate.logLevel, }
                      {  }
                      true
                      predicates.always,
                  EventSource = predicates.records.record
                      { LogLevel = definitions.predicate.logLevel, }
                      {  }
                      true
                      predicates.always,
                  LogLevel = definitions.predicate.logLevel,
                }
                {  }
                true
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  { LogLevel = definitions.predicate.logLevel, }
                  {  }
                  true
                  predicates.always
                ])
              ],
          protocols
            | doc m%"
            The protocols enabled on the endpoint.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "None",
                  "Http1",
                  "Http2",
                  "Http1AndHttp2",
                  "Http3",
                  "Http1AndHttp2AndHttp3"
                ]
              ],
          pwa = predicates.records.record
              {
                cacheId = predicates.isType '"String",
                offlineRoute = predicates.isType '"String",
                registerServiceWorker = predicates.isType '"Bool",
                registerWebmanifest = predicates.isType '"Bool",
                routesToPreCache = predicates.isType '"String",
                strategy = predicates.enum
                    [
                      "cacheFirst",
                      "cacheFirstSafe",
                      "minimal",
                      "networkFirst"
                    ],
              }
              {  }
              true
              predicates.always,
          sslProtocols
            | doc m%"
            Specifies allowable SSL protocols. Defaults to 'None' which allows the operating system to choose the best protocol to use, and to block protocols that are not secure. Unless your app has a specific reason not to, you should use this default. Available in .NET 5 and later.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "None", "Tls", "Tls11", "Tls12", "Tls13" ]
                ])
              ],
          webOptimizer
            | doc m%"
            Settings for WebOptimizer.Core
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enableCaching = predicates.isType '"Bool",
                  enableTagHelperBundling = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
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
    AllowedHosts = definitions.predicate.allowedHosts,
    ConnectionStrings = definitions.predicate.connectionStrings,
    Kestrel = definitions.predicate.kestrel,
    Logging = definitions.predicate.logging,
  }
  {
    "^(ElmahIo|Elmahio|elmahIo|elmahio)$" = definitions.predicate.ElmahIo,
    "^(cdn|Cdn)$" = definitions.predicate.cdn,
    "^(nlog|Nlog|NLog)$" = definitions.predicate.NLog,
    "^(pwa|PWA|Pwa)$" = definitions.predicate.pwa,
    "^WebOptimizer$" = definitions.predicate.webOptimizer,
    "^webOptimizer$" = definitions.predicate.webOptimizer,
    "^weboptimizer$" = definitions.predicate.webOptimizer,
  }
  true
  predicates.always
])