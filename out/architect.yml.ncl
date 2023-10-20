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
          BuildSpec
            | doc m%"
            An object containing the details necessary for Architect to build the service via Docker. Whenever a service that specifies a build field is registered with Architect, the CLI will trigger a docker build and replace the build field with a resolvable image.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BuildSpec,
          ComponentInterfaceSpec
            | doc m%"
            Component Interfaces are the primary means by which components advertise their resolvable addresses to others. Interfaces are the only means by which other components can communicate with your component.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ComponentInterfaceSpec,
          ComponentSpec
            | doc m%"
            The top level object of the `architect.yml`; defines a deployable Architect Component.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ComponentSpec,
          DatabaseSpec
            | doc m%"
            Component databases let you quickly spin up a database for your service
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DatabaseSpec,
          DependencySpec
            | doc m%"
            An empty object that optionally supports specifying a tag for backwards compatibility.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DependencySpec,
          DeploySpec
            | doc m%"
            Configuration that dictates the deploy overrides.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DeploySpec,
          IngressSpec
            | doc m%"
            An ingress exposes an interface to external network traffic through an architect-deployed gateway.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.IngressSpec,
          IngressTlsSpec
            | doc m%"
            Configuration for custom certificate.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.IngressTlsSpec,
          KubernetesDeploySpec
            | doc m%"
            Configuration that dictates the kubernetes deploy overrides.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.KubernetesDeploySpec,
          LivenessProbeSpec
            | doc m%"
            Configuration for service health checks. Architect uses health checks are used for load balancing and rolling updates.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.LivenessProbeSpec,
          OutputDefinitionSpec
            | doc m%"
            Components can define output fields that can be used to share configuration with consuming components.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.OutputDefinitionSpec,
          ScalingMetricsSpec
            | doc m%"
            Scaling metrics define the upper bound of resource consumption before spinning up an additional replica.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ScalingMetricsSpec,
          ScalingSpec
            | doc m%"
            Configuration that dictates the scaling behavior of a service.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ScalingSpec,
          SecretDefinitionSpec
            | doc m%"
            Components can define configurable secrets that can be used to enrich the contained services with environment-specific information (i.e. environment variables).
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SecretDefinitionSpec,
          ServiceInterfaceSpec
            | doc m%"
            A service interface exposes service functionality over the network to other services within the same component. If you would like to expose services on the network to external components, see the ComponentInterfaceSpec
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ServiceInterfaceSpec,
          ServiceSpec
            | doc m%"
            A runtimes (e.g. daemons, servers, etc.). Each service is independently deployable and scalable. Services are 1:1 with a docker image.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ServiceSpec,
          TaskSpec
            | doc m%"
            A Task represents a recurring and/or exiting runtime (e.g. crons, schedulers, triggered jobs). Each task will run on its specified schedule and/or be triggerable via the Architect CLI. Tasks are 1:1 with a docker image.
            "%
            = predicates.contract_from_predicate definitions.predicate.TaskSpec,
          VolumeSpec
            | doc m%"
            Architect can mount volumes onto your services and tasks to store data that should be shared between running containers or that should persist beyond the lifetime of a container.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.VolumeSpec,
          _DebugBuildSpec
            | doc m%"
            An object containing the details necessary for Architect to build the service via Docker. Whenever a service that specifies a build field is registered with Architect, the CLI will trigger a docker build and replace the build field with a resolvable image.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugBuildSpec,
          _DebugComponentInterfaceSpec
            | doc m%"
            Component Interfaces are the primary means by which components advertise their resolvable addresses to others. Interfaces are the only means by which other components can communicate with your component.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugComponentInterfaceSpec,
          _DebugComponentSpec
            | doc m%"
            The top level object of the `architect.yml`; defines a deployable Architect Component.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugComponentSpec,
          _DebugDatabaseSpec
            | doc m%"
            Component databases let you quickly spin up a database for your service
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugDatabaseSpec,
          _DebugDependencySpec
            | doc m%"
            An empty object that optionally supports specifying a tag for backwards compatibility.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugDependencySpec,
          _DebugDeploySpec
            | doc m%"
            Configuration that dictates the deploy overrides.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugDeploySpec,
          _DebugIngressSpec
            | doc m%"
            An ingress exposes an interface to external network traffic through an architect-deployed gateway.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugIngressSpec,
          _DebugIngressTlsSpec
            | doc m%"
            Configuration for custom certificate.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugIngressTlsSpec,
          _DebugKubernetesDeploySpec
            | doc m%"
            Configuration that dictates the kubernetes deploy overrides.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugKubernetesDeploySpec,
          _DebugLivenessProbeSpec
            | doc m%"
            Configuration for service health checks. Architect uses health checks are used for load balancing and rolling updates.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugLivenessProbeSpec,
          _DebugOutputDefinitionSpec
            | doc m%"
            Components can define output fields that can be used to share configuration with consuming components.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugOutputDefinitionSpec,
          _DebugScalingMetricsSpec
            | doc m%"
            Scaling metrics define the upper bound of resource consumption before spinning up an additional replica.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugScalingMetricsSpec,
          _DebugScalingSpec
            | doc m%"
            Configuration that dictates the scaling behavior of a service.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugScalingSpec,
          _DebugSecretDefinitionSpec
            | doc m%"
            Components can define configurable secrets that can be used to enrich the contained services with environment-specific information (i.e. environment variables).
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugSecretDefinitionSpec,
          _DebugServiceInterfaceSpec
            | doc m%"
            A service interface exposes service functionality over the network to other services within the same component. If you would like to expose services on the network to external components, see the ComponentInterfaceSpec
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugServiceInterfaceSpec,
          _DebugServiceSpec
            | doc m%"
            A runtimes (e.g. daemons, servers, etc.). Each service is independently deployable and scalable. Services are 1:1 with a docker image.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugServiceSpec,
          _DebugTaskSpec
            | doc m%"
            A Task represents a recurring and/or exiting runtime (e.g. crons, schedulers, triggered jobs). Each task will run on its specified schedule and/or be triggerable via the Architect CLI. Tasks are 1:1 with a docker image.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugTaskSpec,
          _DebugVolumeSpec
            | doc m%"
            Architect can mount volumes onto your services and tasks to store data that should be shared between running containers or that should persist beyond the lifetime of a container.
            "%
            = predicates.contract_from_predicate
              definitions.predicate._DebugVolumeSpec,
        },
    predicate = {
          BuildSpec
            | doc m%"
            An object containing the details necessary for Architect to build the service via Docker. Whenever a service that specifies a build field is registered with Architect, the CLI will trigger a docker build and replace the build field with a resolvable image.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.not
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "buildpack", "dockerfile" ],
                  predicates.records.record {  } {  } true predicates.always
                ]),
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[a-zA-Z0-9_]+$" = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType 'Null
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  buildpack = predicates.isType '"Bool",
                  context = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  dockerfile = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  target = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.not
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "buildpack", "dockerfile" ],
                          predicates.records.record {  } {  } true
                          predicates.always
                        ]),
                        predicates.records.record
                        {
                          args = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                              [
                                                predicates.isType '"String",
                                                predicates.isType 'Null
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          buildpack = predicates.isType '"Bool",
                          context = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          dockerfile = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          target = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          ComponentInterfaceSpec
            | doc m%"
            Component Interfaces are the primary means by which components advertise their resolvable addresses to others. Interfaces are the only means by which other components can communicate with your component.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "url" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  host = predicates.isType '"String",
                  ingress = definitions.predicate.IngressSpec,
                  password = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  port = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  protocol = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  sticky = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  url = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  username = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "url" ],
                        predicates.records.record
                        {
                          description = predicates.isType '"String",
                          host = predicates.isType '"String",
                          ingress = definitions.predicate.IngressSpec,
                          password = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          port = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          protocol = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          sticky = predicates.anyOf
                              [
                                predicates.isType '"Bool",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          url = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          username = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          ComponentSpec
            | doc m%"
            The top level object of the `architect.yml`; defines a deployable Architect Component.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  artifact_image = predicates.isType '"String",
                  author = predicates.isType '"String",
                  databases = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                            definitions.predicate.DatabaseSpec,
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    definitions.predicate.DatabaseSpec,
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  dependencies = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?:(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)\\/)?(?<component_name>(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-))(?:@(?<instance_name>[\\w][\\w\\.-]{0,127}))?$" =
                            predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "^[\\w][\\w\\.-]{0,127}$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ],
                                definitions.predicate.DependencySpec
                              ],
                        }
                        false
                        predicates.never
                      ],
                  description = predicates.isType '"String",
                  homepage = predicates.isType '"String",
                  interfaces = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                            predicates.anyOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.ComponentInterfaceSpec
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.ComponentInterfaceSpec
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  keywords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?:(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)\\/)?(?<component_name>(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-))(?:@(?<instance_name>[\\w][\\w\\.-]{0,127}))?$"
                      ],
                  outputs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType '"Bool",
                                definitions.predicate.OutputDefinitionSpec,
                                predicates.isType 'Null
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType '"Number",
                                        predicates.isType '"Bool",
                                        definitions.predicate.OutputDefinitionSpec,
                                        predicates.isType 'Null
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  secrets = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType '"Bool",
                                definitions.predicate.SecretDefinitionSpec,
                                predicates.isType 'Null
                              ],
                        }
                        false
                        predicates.never
                      ],
                  services = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                            definitions.predicate.ServiceSpec,
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    definitions.predicate.ServiceSpec,
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  tasks = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                            definitions.predicate.TaskSpec,
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    definitions.predicate.TaskSpec,
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "name" ],
                        predicates.records.record
                        {
                          artifact_image = predicates.isType '"String",
                          author = predicates.isType '"String",
                          databases = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    definitions.predicate.DatabaseSpec,
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                            definitions.predicate.DatabaseSpec,
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          dependencies = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?:(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)\\/)?(?<component_name>(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-))(?:@(?<instance_name>[\\w][\\w\\.-]{0,127}))?$" =
                                    predicates.anyOf
                                      [
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "^[\\w][\\w\\.-]{0,127}$"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "\\${{\\s*(.*?)\\s*}}"
                                        ],
                                        definitions.predicate.DependencySpec
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          description = predicates.isType '"String",
                          homepage = predicates.isType '"String",
                          interfaces = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.ComponentInterfaceSpec
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                            predicates.anyOf
                                              [
                                                predicates.isType '"String",
                                                definitions.predicate.ComponentInterfaceSpec
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          keywords = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          name = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.pattern
                                "^(?:(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)\\/)?(?<component_name>(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-))(?:@(?<instance_name>[\\w][\\w\\.-]{0,127}))?$"
                              ],
                          outputs = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType '"Number",
                                        predicates.isType '"Bool",
                                        definitions.predicate.OutputDefinitionSpec,
                                        predicates.isType 'Null
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                                              [
                                                predicates.isType '"String",
                                                predicates.isType '"Number",
                                                predicates.isType '"Bool",
                                                definitions.predicate.OutputDefinitionSpec,
                                                predicates.isType 'Null
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          secrets = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType '"Number",
                                        predicates.isType '"Bool",
                                        definitions.predicate.SecretDefinitionSpec,
                                        predicates.isType 'Null
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          services = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    definitions.predicate.ServiceSpec,
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                            definitions.predicate.ServiceSpec,
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          tasks = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    definitions.predicate.TaskSpec,
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                            definitions.predicate.TaskSpec,
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          DatabaseSpec
            | doc m%"
            Component databases let you quickly spin up a database for your service
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  connection_string = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  description = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "postgres:10",
                              "postgres:11",
                              "postgres:12",
                              "postgres:13",
                              "postgres:14",
                              "postgres:15",
                              "mysql:5",
                              "mysql:6",
                              "mysql:7",
                              "mysql:8",
                              "mariadb:10"
                            ]
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                          ]
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "type" ],
                        predicates.records.record
                        {
                          connection_string = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType 'Null,
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          description = predicates.isType '"String",
                          type = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.anyOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.enum
                                    [
                                      "postgres:10",
                                      "postgres:11",
                                      "postgres:12",
                                      "postgres:13",
                                      "postgres:14",
                                      "postgres:15",
                                      "mysql:5",
                                      "mysql:6",
                                      "mysql:7",
                                      "mysql:8",
                                      "mariadb:10"
                                    ]
                                  ],
                                  predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.strings.pattern
                                    "\\${{\\s*(.*?)\\s*}}"
                                  ]
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          DependencySpec
            | doc m%"
            An empty object that optionally supports specifying a tag for backwards compatibility.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  tag = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^[\\w][\\w\\.-]{0,127}$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tag = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "^[\\w][\\w\\.-]{0,127}$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          DeploySpec
            | doc m%"
            Configuration that dictates the deploy overrides.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kubernetes" ],
                predicates.records.record
                { kubernetes = definitions.predicate.KubernetesDeploySpec, }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "kubernetes" ],
                        predicates.records.record
                        {
                          kubernetes =
                            definitions.predicate.KubernetesDeploySpec,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          IngressSpec
            | doc m%"
            An ingress exposes an interface to external network traffic through an architect-deployed gateway.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  ip_whitelist = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.pattern
                              "\\${{\\s*secrets\\.[\\w-]+\\s*}}"
                            ]
                          ])
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "\\${{\\s*(.*?)\\s*}}|(?:\\d{1,3}\\.){3}\\d{1,3}(?:\\/\\d\\d?)?,?"
                        ]
                      ],
                  path = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^\\/.*$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  private = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  subdomain = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^([A-Za-z0-9](?:[A-Za-z0-9\\-]{0,61}[A-Za-z0-9])|[^\\W\\D\\s\\t\\n\\r\\/]+|[\\@\\*]?)$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  tls = definitions.predicate.IngressTlsSpec,
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          enabled = predicates.isType '"Bool",
                          ip_whitelist = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.anyOf
                                  [
                                    predicates.isType '"String",
                                    predicates.allOf
                                    [
                                      predicates.isType '"String",
                                      predicates.strings.pattern
                                      "\\${{\\s*secrets\\.[\\w-]+\\s*}}"
                                    ]
                                  ])
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}|(?:\\d{1,3}\\.){3}\\d{1,3}(?:\\/\\d\\d?)?,?"
                                ]
                              ],
                          path = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern "^\\/.*$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          private = predicates.anyOf
                              [
                                predicates.isType '"Bool",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          subdomain = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "^([A-Za-z0-9](?:[A-Za-z0-9\\-]{0,61}[A-Za-z0-9])|[^\\W\\D\\s\\t\\n\\r\\/]+|[\\@\\*]?)$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          tls = definitions.predicate.IngressTlsSpec,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          IngressTlsSpec
            | doc m%"
            Configuration for custom certificate.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "crt", "key" ],
                predicates.records.record
                {
                  ca = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  crt = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                          ]
                        ]
                      ],
                  key = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                          ]
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "crt", "key" ],
                        predicates.records.record
                        {
                          ca = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          crt = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.strings.pattern
                                    "\\${{\\s*(.*?)\\s*}}"
                                  ]
                                ]
                              ],
                          key = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.strings.pattern
                                    "\\${{\\s*(.*?)\\s*}}"
                                  ]
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          KubernetesDeploySpec
            | doc m%"
            Configuration that dictates the kubernetes deploy overrides.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "deployment" ],
                predicates.records.record { deployment = predicates.always, }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "deployment" ],
                        predicates.records.record
                        { deployment = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          LivenessProbeSpec
            | doc m%"
            Configuration for service health checks. Architect uses health checks are used for load balancing and rolling updates.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "command" ],
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "path", "port" ],
                      predicates.records.record {  } {  } true predicates.always
                    ]
                  ],
                  predicates.not
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "command", "port" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]),
                  predicates.not
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "command", "path" ],
                    predicates.records.record {  } {  } true predicates.always
                  ])
                ],
                predicates.records.record
                {
                  command = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  failure_threshold = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  initial_delay = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  interval = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  path = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^\\/.*$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  port = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  success_threshold = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  timeout = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.allOf
                        [
                          predicates.oneOf
                          [
                            predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "command" ],
                              predicates.records.record {  } {  } true
                              predicates.always
                            ],
                            predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "path", "port" ],
                              predicates.records.record {  } {  } true
                              predicates.always
                            ]
                          ],
                          predicates.not
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "command", "port" ],
                            predicates.records.record {  } {  } true
                            predicates.always
                          ]),
                          predicates.not
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "command", "path" ],
                            predicates.records.record {  } {  } true
                            predicates.always
                          ])
                        ],
                        predicates.records.record
                        {
                          command = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                                predicates.isType '"String"
                              ],
                          failure_threshold = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          initial_delay = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          interval = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          path = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern "^\\/.*$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          port = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          success_threshold = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          timeout = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          OutputDefinitionSpec
            | doc m%"
            Components can define output fields that can be used to share configuration with consuming components.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "value" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  value = predicates.always,
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "value" ],
                        predicates.records.record
                        {
                          description = predicates.isType '"String",
                          value = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          ScalingMetricsSpec
            | doc m%"
            Scaling metrics define the upper bound of resource consumption before spinning up an additional replica.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "cpu" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "memory" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  cpu = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.maximum 100,
                          predicates.numbers.minimum 0
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  memory = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.maximum 100,
                          predicates.numbers.minimum 0
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "cpu" ],
                            predicates.records.record {  } {  } true
                            predicates.always
                          ],
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "memory" ],
                            predicates.records.record {  } {  } true
                            predicates.always
                          ]
                        ],
                        predicates.records.record
                        {
                          cpu = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.maximum 100,
                                  predicates.numbers.minimum 0
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          memory = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.maximum 100,
                                  predicates.numbers.minimum 0
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          ScalingSpec
            | doc m%"
            Configuration that dictates the scaling behavior of a service.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "max_replicas", "metrics", "min_replicas" ],
                predicates.records.record
                {
                  max_replicas = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  metrics = definitions.predicate.ScalingMetricsSpec,
                  min_replicas = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [ "max_replicas", "metrics", "min_replicas" ],
                        predicates.records.record
                        {
                          max_replicas = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.minimum 0
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          metrics = definitions.predicate.ScalingMetricsSpec,
                          min_replicas = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.minimum 0
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          SecretDefinitionSpec
            | doc m%"
            Components can define configurable secrets that can be used to enrich the contained services with environment-specific information (i.e. environment variables).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "default" = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Array",
                          predicates.isType '"Bool",
                          predicates.isType '"Number",
                          predicates.isType 'Record,
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  description = predicates.isType '"String",
                  required = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ServiceInterfaceSpec
            | doc m%"
            A service interface exposes service functionality over the network to other services within the same component. If you would like to expose services on the network to external components, see the ComponentInterfaceSpec
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "port" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "url" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.required [ "port" ],
                predicates.records.record
                {
                  description = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  host = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType 'Null,
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  ingress = definitions.predicate.IngressSpec,
                  password = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType 'Null,
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  path = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^\\/.*$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  port = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  protocol = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  sticky = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  url = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  username = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType 'Null,
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "port" ],
                            predicates.records.record {  } {  } true
                            predicates.always
                          ],
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "url" ],
                            predicates.records.record {  } {  } true
                            predicates.always
                          ]
                        ],
                        predicates.records.required [ "port" ],
                        predicates.records.record
                        {
                          description = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          host = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Null,
                                  predicates.isType '"String"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          ingress = definitions.predicate.IngressSpec,
                          password = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Null,
                                  predicates.isType '"String"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          path = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern "^\\/.*$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          port = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          protocol = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          sticky = predicates.anyOf
                              [
                                predicates.isType '"Bool",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          url = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          username = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Null,
                                  predicates.isType '"String"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          ServiceSpec
            | doc m%"
            A runtimes (e.g. daemons, servers, etc.). Each service is independently deployable and scalable. Services are 1:1 with a docker image.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.not
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "build", "image" ],
                  predicates.records.record {  } {  } true predicates.always
                ]),
                predicates.records.record
                {
                  build = definitions.predicate.BuildSpec,
                  command = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  cpu = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  debug = definitions.predicate._DebugServiceSpec,
                  depends_on = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  deploy = definitions.predicate.DeploySpec,
                  description = predicates.isType '"String",
                  enabled = predicates.isType '"Bool",
                  entrypoint = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  environment = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[a-zA-Z0-9_]+$" = predicates.anyOf
                              [
                                predicates.isType '"Array",
                                predicates.isType '"Bool",
                                predicates.isType 'Null,
                                predicates.isType '"Number",
                                predicates.isType '"String"
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.isType '"Bool",
                                        predicates.isType 'Null,
                                        predicates.isType '"Number",
                                        predicates.isType '"String"
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  image = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  interfaces = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                            predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  definitions.predicate.ServiceInterfaceSpec,
                                  predicates.isType '"Number"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    predicates.anyOf
                                      [
                                        predicates.anyOf
                                        [
                                          definitions.predicate.ServiceInterfaceSpec,
                                          predicates.isType '"Number"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "\\${{\\s*(.*?)\\s*}}"
                                        ]
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                            predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                                    predicates.anyOf
                                      [
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "\\${{\\s*(.*?)\\s*}}"
                                        ]
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  language = predicates.isType '"String",
                  liveness_probe = definitions.predicate.LivenessProbeSpec,
                  memory = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  replicas = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  reserved_name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$"
                      ],
                  scaling = definitions.predicate.ScalingSpec,
                  termination_grace_period = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  volumes = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                            predicates.anyOf
                              [
                                definitions.predicate.VolumeSpec,
                                predicates.isType '"String"
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    predicates.anyOf
                                      [
                                        definitions.predicate.VolumeSpec,
                                        predicates.isType '"String"
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.not
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "build", "image" ],
                          predicates.records.record {  } {  } true
                          predicates.always
                        ]),
                        predicates.records.record
                        {
                          build = definitions.predicate.BuildSpec,
                          command = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                                  predicates.isType '"String"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          cpu = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          debug = definitions.predicate._DebugServiceSpec,
                          depends_on = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          deploy = definitions.predicate.DeploySpec,
                          description = predicates.isType '"String",
                          enabled = predicates.isType '"Bool",
                          entrypoint = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                                  predicates.isType '"String"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          environment = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.isType '"Bool",
                                        predicates.isType 'Null,
                                        predicates.isType '"Number",
                                        predicates.isType '"String"
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                              [
                                                predicates.isType '"Array",
                                                predicates.isType '"Bool",
                                                predicates.isType 'Null,
                                                predicates.isType '"Number",
                                                predicates.isType '"String"
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          image = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          interfaces = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    predicates.anyOf
                                      [
                                        predicates.anyOf
                                        [
                                          definitions.predicate.ServiceInterfaceSpec,
                                          predicates.isType '"Number"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "\\${{\\s*(.*?)\\s*}}"
                                        ]
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                            predicates.anyOf
                                              [
                                                predicates.anyOf
                                                [
                                                  definitions.predicate.ServiceInterfaceSpec,
                                                  predicates.isType '"Number"
                                                ],
                                                predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.pattern
                                                  "\\${{\\s*(.*?)\\s*}}"
                                                ]
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          labels = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                                    predicates.anyOf
                                      [
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "\\${{\\s*(.*?)\\s*}}"
                                        ]
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                                            predicates.anyOf
                                              [
                                                predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.pattern
                                                  "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                                ],
                                                predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.pattern
                                                  "\\${{\\s*(.*?)\\s*}}"
                                                ]
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          language = predicates.isType '"String",
                          liveness_probe =
                            definitions.predicate.LivenessProbeSpec,
                          memory = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          replicas = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.minimum 0
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          reserved_name = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.pattern
                                "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$"
                              ],
                          scaling = definitions.predicate.ScalingSpec,
                          termination_grace_period = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          volumes = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    predicates.anyOf
                                      [
                                        definitions.predicate.VolumeSpec,
                                        predicates.isType '"String"
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                            predicates.anyOf
                                              [
                                                definitions.predicate.VolumeSpec,
                                                predicates.isType '"String"
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          TaskSpec
            | doc m%"
            A Task represents a recurring and/or exiting runtime (e.g. crons, schedulers, triggered jobs). Each task will run on its specified schedule and/or be triggerable via the Architect CLI. Tasks are 1:1 with a docker image.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.not
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "build", "image" ],
                  predicates.records.record {  } {  } true predicates.always
                ]),
                predicates.records.record
                {
                  build = definitions.predicate.BuildSpec,
                  command = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  cpu = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  debug = definitions.predicate._DebugTaskSpec,
                  depends_on = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  description = predicates.isType '"String",
                  entrypoint = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  environment = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[a-zA-Z0-9_]+$" = predicates.anyOf
                              [
                                predicates.isType '"Array",
                                predicates.isType '"Bool",
                                predicates.isType 'Null,
                                predicates.isType '"Number",
                                predicates.isType '"String"
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.isType '"Bool",
                                        predicates.isType 'Null,
                                        predicates.isType '"Number",
                                        predicates.isType '"String"
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  image = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                            predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                                    predicates.anyOf
                                      [
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "\\${{\\s*(.*?)\\s*}}"
                                        ]
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  language = predicates.isType '"String",
                  memory = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  reserved_name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$"
                      ],
                  schedule = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.not
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "build", "image" ],
                          predicates.records.record {  } {  } true
                          predicates.always
                        ]),
                        predicates.records.record
                        {
                          build = definitions.predicate.BuildSpec,
                          command = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                                  predicates.isType '"String"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          cpu = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          debug = definitions.predicate._DebugTaskSpec,
                          depends_on = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          description = predicates.isType '"String",
                          entrypoint = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                                  predicates.isType '"String"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          environment = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.isType '"Bool",
                                        predicates.isType 'Null,
                                        predicates.isType '"Number",
                                        predicates.isType '"String"
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                              [
                                                predicates.isType '"Array",
                                                predicates.isType '"Bool",
                                                predicates.isType 'Null,
                                                predicates.isType '"Number",
                                                predicates.isType '"String"
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          image = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          labels = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                                    predicates.anyOf
                                      [
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "\\${{\\s*(.*?)\\s*}}"
                                        ]
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                                            predicates.anyOf
                                              [
                                                predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.pattern
                                                  "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                                ],
                                                predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.pattern
                                                  "\\${{\\s*(.*?)\\s*}}"
                                                ]
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          language = predicates.isType '"String",
                          memory = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          reserved_name = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.pattern
                                "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$"
                              ],
                          schedule = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          VolumeSpec
            | doc m%"
            Architect can mount volumes onto your services and tasks to store data that should be shared between running containers or that should persist beyond the lifetime of a container.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.not
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "host_path", "key" ],
                  predicates.records.record {  } {  } true predicates.always
                ]),
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  host_path = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  key = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  mount_path = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  readonly = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.not
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "host_path", "key" ],
                          predicates.records.record {  } {  } true
                          predicates.always
                        ]),
                        predicates.records.record
                        {
                          description = predicates.isType '"String",
                          host_path = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          key = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          mount_path = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          readonly = predicates.anyOf
                              [
                                predicates.isType '"Bool",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugBuildSpec
            | doc m%"
            An object containing the details necessary for Architect to build the service via Docker. Whenever a service that specifies a build field is registered with Architect, the CLI will trigger a docker build and replace the build field with a resolvable image.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.not
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "buildpack", "dockerfile" ],
                  predicates.records.record {  } {  } true predicates.always
                ]),
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[a-zA-Z0-9_]+$" = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType 'Null
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  buildpack = predicates.isType '"Bool",
                  context = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  dockerfile = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  target = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.not
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "buildpack", "dockerfile" ],
                          predicates.records.record {  } {  } true
                          predicates.always
                        ]),
                        predicates.records.record
                        {
                          args = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                              [
                                                predicates.isType '"String",
                                                predicates.isType 'Null
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          buildpack = predicates.isType '"Bool",
                          context = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          dockerfile = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          target = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugComponentInterfaceSpec
            | doc m%"
            Component Interfaces are the primary means by which components advertise their resolvable addresses to others. Interfaces are the only means by which other components can communicate with your component.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  host = predicates.isType '"String",
                  ingress = definitions.predicate._DebugIngressSpec,
                  password = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  port = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  protocol = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  sticky = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  url = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  username = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          description = predicates.isType '"String",
                          host = predicates.isType '"String",
                          ingress = definitions.predicate._DebugIngressSpec,
                          password = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          port = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          protocol = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          sticky = predicates.anyOf
                              [
                                predicates.isType '"Bool",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          url = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          username = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugComponentSpec
            | doc m%"
            The top level object of the `architect.yml`; defines a deployable Architect Component.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifact_image = predicates.isType '"String",
                  author = predicates.isType '"String",
                  databases = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                            definitions.predicate._DebugDatabaseSpec,
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    definitions.predicate._DebugDatabaseSpec,
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  dependencies = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?:(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)\\/)?(?<component_name>(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-))(?:@(?<instance_name>[\\w][\\w\\.-]{0,127}))?$" =
                            predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "^[\\w][\\w\\.-]{0,127}$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ],
                                definitions.predicate._DebugDependencySpec
                              ],
                        }
                        false
                        predicates.never
                      ],
                  description = predicates.isType '"String",
                  homepage = predicates.isType '"String",
                  interfaces = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                            predicates.anyOf
                              [
                                predicates.isType '"String",
                                definitions.predicate._DebugComponentInterfaceSpec
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate._DebugComponentInterfaceSpec
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  keywords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?:(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)\\/)?(?<component_name>(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-))(?:@(?<instance_name>[\\w][\\w\\.-]{0,127}))?$"
                      ],
                  outputs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType '"Bool",
                                definitions.predicate._DebugOutputDefinitionSpec,
                                predicates.isType 'Null
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType '"Number",
                                        predicates.isType '"Bool",
                                        definitions.predicate._DebugOutputDefinitionSpec,
                                        predicates.isType 'Null
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  secrets = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType '"Bool",
                                definitions.predicate._DebugSecretDefinitionSpec,
                                predicates.isType 'Null
                              ],
                        }
                        false
                        predicates.never
                      ],
                  services = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                            definitions.predicate._DebugServiceSpec,
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    definitions.predicate._DebugServiceSpec,
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  tasks = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                            definitions.predicate._DebugTaskSpec,
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    definitions.predicate._DebugTaskSpec,
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          artifact_image = predicates.isType '"String",
                          author = predicates.isType '"String",
                          databases = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    definitions.predicate._DebugDatabaseSpec,
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                            definitions.predicate._DebugDatabaseSpec,
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          dependencies = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?:(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)\\/)?(?<component_name>(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-))(?:@(?<instance_name>[\\w][\\w\\.-]{0,127}))?$" =
                                    predicates.anyOf
                                      [
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "^[\\w][\\w\\.-]{0,127}$"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "\\${{\\s*(.*?)\\s*}}"
                                        ],
                                        definitions.predicate._DebugDependencySpec
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          description = predicates.isType '"String",
                          homepage = predicates.isType '"String",
                          interfaces = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate._DebugComponentInterfaceSpec
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                            predicates.anyOf
                                              [
                                                predicates.isType '"String",
                                                definitions.predicate._DebugComponentInterfaceSpec
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          keywords = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          name = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.pattern
                                "^(?:(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)\\/)?(?<component_name>(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-))(?:@(?<instance_name>[\\w][\\w\\.-]{0,127}))?$"
                              ],
                          outputs = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType '"Number",
                                        predicates.isType '"Bool",
                                        definitions.predicate._DebugOutputDefinitionSpec,
                                        predicates.isType 'Null
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                                              [
                                                predicates.isType '"String",
                                                predicates.isType '"Number",
                                                predicates.isType '"Bool",
                                                definitions.predicate._DebugOutputDefinitionSpec,
                                                predicates.isType 'Null
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          secrets = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType '"Number",
                                        predicates.isType '"Bool",
                                        definitions.predicate._DebugSecretDefinitionSpec,
                                        predicates.isType 'Null
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          services = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    definitions.predicate._DebugServiceSpec,
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                            definitions.predicate._DebugServiceSpec,
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          tasks = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    definitions.predicate._DebugTaskSpec,
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                            definitions.predicate._DebugTaskSpec,
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugDatabaseSpec
            | doc m%"
            Component databases let you quickly spin up a database for your service
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  connection_string = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  description = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "postgres:10",
                              "postgres:11",
                              "postgres:12",
                              "postgres:13",
                              "postgres:14",
                              "postgres:15",
                              "mysql:5",
                              "mysql:6",
                              "mysql:7",
                              "mysql:8",
                              "mariadb:10"
                            ]
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                          ]
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          connection_string = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType 'Null,
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          description = predicates.isType '"String",
                          type = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.anyOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.enum
                                    [
                                      "postgres:10",
                                      "postgres:11",
                                      "postgres:12",
                                      "postgres:13",
                                      "postgres:14",
                                      "postgres:15",
                                      "mysql:5",
                                      "mysql:6",
                                      "mysql:7",
                                      "mysql:8",
                                      "mariadb:10"
                                    ]
                                  ],
                                  predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.strings.pattern
                                    "\\${{\\s*(.*?)\\s*}}"
                                  ]
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugDependencySpec
            | doc m%"
            An empty object that optionally supports specifying a tag for backwards compatibility.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  tag = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^[\\w][\\w\\.-]{0,127}$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tag = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "^[\\w][\\w\\.-]{0,127}$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugDeploySpec
            | doc m%"
            Configuration that dictates the deploy overrides.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  kubernetes = definitions.predicate._DebugKubernetesDeploySpec,
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          kubernetes =
                            definitions.predicate._DebugKubernetesDeploySpec,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugIngressSpec
            | doc m%"
            An ingress exposes an interface to external network traffic through an architect-deployed gateway.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  ip_whitelist = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.pattern
                              "\\${{\\s*secrets\\.[\\w-]+\\s*}}"
                            ]
                          ])
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "\\${{\\s*(.*?)\\s*}}|(?:\\d{1,3}\\.){3}\\d{1,3}(?:\\/\\d\\d?)?,?"
                        ]
                      ],
                  path = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^\\/.*$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  private = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  subdomain = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^([A-Za-z0-9](?:[A-Za-z0-9\\-]{0,61}[A-Za-z0-9])|[^\\W\\D\\s\\t\\n\\r\\/]+|[\\@\\*]?)$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  tls = definitions.predicate._DebugIngressTlsSpec,
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          enabled = predicates.isType '"Bool",
                          ip_whitelist = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.anyOf
                                  [
                                    predicates.isType '"String",
                                    predicates.allOf
                                    [
                                      predicates.isType '"String",
                                      predicates.strings.pattern
                                      "\\${{\\s*secrets\\.[\\w-]+\\s*}}"
                                    ]
                                  ])
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}|(?:\\d{1,3}\\.){3}\\d{1,3}(?:\\/\\d\\d?)?,?"
                                ]
                              ],
                          path = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern "^\\/.*$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          private = predicates.anyOf
                              [
                                predicates.isType '"Bool",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          subdomain = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "^([A-Za-z0-9](?:[A-Za-z0-9\\-]{0,61}[A-Za-z0-9])|[^\\W\\D\\s\\t\\n\\r\\/]+|[\\@\\*]?)$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          tls = definitions.predicate._DebugIngressTlsSpec,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugIngressTlsSpec
            | doc m%"
            Configuration for custom certificate.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ca = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  crt = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                          ]
                        ]
                      ],
                  key = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                          ]
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          ca = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          crt = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.strings.pattern
                                    "\\${{\\s*(.*?)\\s*}}"
                                  ]
                                ]
                              ],
                          key = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.strings.pattern
                                    "\\${{\\s*(.*?)\\s*}}"
                                  ]
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugKubernetesDeploySpec
            | doc m%"
            Configuration that dictates the kubernetes deploy overrides.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record { deployment = predicates.always, }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { deployment = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugLivenessProbeSpec
            | doc m%"
            Configuration for service health checks. Architect uses health checks are used for load balancing and rolling updates.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  command = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  failure_threshold = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  initial_delay = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  interval = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  path = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^\\/.*$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  port = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  success_threshold = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  timeout = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          command = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                                predicates.isType '"String"
                              ],
                          failure_threshold = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          initial_delay = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          interval = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          path = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern "^\\/.*$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          port = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          success_threshold = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          timeout = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugOutputDefinitionSpec
            | doc m%"
            Components can define output fields that can be used to share configuration with consuming components.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  value = predicates.always,
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          description = predicates.isType '"String",
                          value = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugScalingMetricsSpec
            | doc m%"
            Scaling metrics define the upper bound of resource consumption before spinning up an additional replica.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cpu = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.maximum 100,
                          predicates.numbers.minimum 0
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  memory = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.maximum 100,
                          predicates.numbers.minimum 0
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          cpu = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.maximum 100,
                                  predicates.numbers.minimum 0
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          memory = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.maximum 100,
                                  predicates.numbers.minimum 0
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugScalingSpec
            | doc m%"
            Configuration that dictates the scaling behavior of a service.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  max_replicas = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  metrics = definitions.predicate._DebugScalingMetricsSpec,
                  min_replicas = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          max_replicas = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.minimum 0
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          metrics =
                            definitions.predicate._DebugScalingMetricsSpec,
                          min_replicas = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.minimum 0
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugSecretDefinitionSpec
            | doc m%"
            Components can define configurable secrets that can be used to enrich the contained services with environment-specific information (i.e. environment variables).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "default" = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Array",
                          predicates.isType '"Bool",
                          predicates.isType '"Number",
                          predicates.isType 'Record,
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  description = predicates.isType '"String",
                  required = predicates.isType '"Bool",
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          "default" = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType '"Array",
                                  predicates.isType '"Bool",
                                  predicates.isType '"Number",
                                  predicates.isType 'Record,
                                  predicates.isType '"String",
                                  predicates.isType 'Null
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          description = predicates.isType '"String",
                          required = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugServiceInterfaceSpec
            | doc m%"
            A service interface exposes service functionality over the network to other services within the same component. If you would like to expose services on the network to external components, see the ComponentInterfaceSpec
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  description = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  host = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType 'Null,
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  ingress = definitions.predicate._DebugIngressSpec,
                  password = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType 'Null,
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  path = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^\\/.*$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  port = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  protocol = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  sticky = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  url = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  username = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType 'Null,
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          description = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          host = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Null,
                                  predicates.isType '"String"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          ingress = definitions.predicate._DebugIngressSpec,
                          password = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Null,
                                  predicates.isType '"String"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          path = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern "^\\/.*$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          port = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          protocol = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          sticky = predicates.anyOf
                              [
                                predicates.isType '"Bool",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          url = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          username = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Null,
                                  predicates.isType '"String"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugServiceSpec
            | doc m%"
            A runtimes (e.g. daemons, servers, etc.). Each service is independently deployable and scalable. Services are 1:1 with a docker image.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.not
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "build", "image" ],
                  predicates.records.record {  } {  } true predicates.always
                ]),
                predicates.records.record
                {
                  build = definitions.predicate._DebugBuildSpec,
                  command = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  cpu = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  depends_on = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  deploy = definitions.predicate._DebugDeploySpec,
                  description = predicates.isType '"String",
                  enabled = predicates.isType '"Bool",
                  entrypoint = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  environment = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[a-zA-Z0-9_]+$" = predicates.anyOf
                              [
                                predicates.isType '"Array",
                                predicates.isType '"Bool",
                                predicates.isType 'Null,
                                predicates.isType '"Number",
                                predicates.isType '"String"
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.isType '"Bool",
                                        predicates.isType 'Null,
                                        predicates.isType '"Number",
                                        predicates.isType '"String"
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  image = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  interfaces = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                            predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  definitions.predicate._DebugServiceInterfaceSpec,
                                  predicates.isType '"Number"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    predicates.anyOf
                                      [
                                        predicates.anyOf
                                        [
                                          definitions.predicate._DebugServiceInterfaceSpec,
                                          predicates.isType '"Number"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "\\${{\\s*(.*?)\\s*}}"
                                        ]
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                            predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                                    predicates.anyOf
                                      [
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "\\${{\\s*(.*?)\\s*}}"
                                        ]
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  language = predicates.isType '"String",
                  liveness_probe =
                    definitions.predicate._DebugLivenessProbeSpec,
                  memory = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  replicas = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  reserved_name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$"
                      ],
                  scaling = definitions.predicate._DebugScalingSpec,
                  termination_grace_period = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  volumes = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                            predicates.anyOf
                              [
                                definitions.predicate._DebugVolumeSpec,
                                predicates.isType '"String"
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    predicates.anyOf
                                      [
                                        definitions.predicate._DebugVolumeSpec,
                                        predicates.isType '"String"
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.not
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "build", "image" ],
                          predicates.records.record {  } {  } true
                          predicates.always
                        ]),
                        predicates.records.record
                        {
                          build = definitions.predicate._DebugBuildSpec,
                          command = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                                  predicates.isType '"String"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          cpu = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          depends_on = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          deploy = definitions.predicate._DebugDeploySpec,
                          description = predicates.isType '"String",
                          enabled = predicates.isType '"Bool",
                          entrypoint = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                                  predicates.isType '"String"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          environment = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.isType '"Bool",
                                        predicates.isType 'Null,
                                        predicates.isType '"Number",
                                        predicates.isType '"String"
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                              [
                                                predicates.isType '"Array",
                                                predicates.isType '"Bool",
                                                predicates.isType 'Null,
                                                predicates.isType '"Number",
                                                predicates.isType '"String"
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          image = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          interfaces = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    predicates.anyOf
                                      [
                                        predicates.anyOf
                                        [
                                          definitions.predicate._DebugServiceInterfaceSpec,
                                          predicates.isType '"Number"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "\\${{\\s*(.*?)\\s*}}"
                                        ]
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                            predicates.anyOf
                                              [
                                                predicates.anyOf
                                                [
                                                  definitions.predicate._DebugServiceInterfaceSpec,
                                                  predicates.isType '"Number"
                                                ],
                                                predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.pattern
                                                  "\\${{\\s*(.*?)\\s*}}"
                                                ]
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          labels = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                                    predicates.anyOf
                                      [
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "\\${{\\s*(.*?)\\s*}}"
                                        ]
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                                            predicates.anyOf
                                              [
                                                predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.pattern
                                                  "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                                ],
                                                predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.pattern
                                                  "\\${{\\s*(.*?)\\s*}}"
                                                ]
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          language = predicates.isType '"String",
                          liveness_probe =
                            definitions.predicate._DebugLivenessProbeSpec,
                          memory = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          replicas = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.minimum 0
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          reserved_name = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.pattern
                                "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$"
                              ],
                          scaling = definitions.predicate._DebugScalingSpec,
                          termination_grace_period = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          volumes = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                    predicates.anyOf
                                      [
                                        definitions.predicate._DebugVolumeSpec,
                                        predicates.isType '"String"
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                                            predicates.anyOf
                                              [
                                                definitions.predicate._DebugVolumeSpec,
                                                predicates.isType '"String"
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugTaskSpec
            | doc m%"
            A Task represents a recurring and/or exiting runtime (e.g. crons, schedulers, triggered jobs). Each task will run on its specified schedule and/or be triggerable via the Architect CLI. Tasks are 1:1 with a docker image.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.not
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "build", "image" ],
                  predicates.records.record {  } {  } true predicates.always
                ]),
                predicates.records.record
                {
                  build = definitions.predicate._DebugBuildSpec,
                  command = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  cpu = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  depends_on = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  description = predicates.isType '"String",
                  entrypoint = predicates.anyOf
                      [
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  environment = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[a-zA-Z0-9_]+$" = predicates.anyOf
                              [
                                predicates.isType '"Array",
                                predicates.isType '"Bool",
                                predicates.isType 'Null,
                                predicates.isType '"Number",
                                predicates.isType '"String"
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.isType '"Bool",
                                        predicates.isType 'Null,
                                        predicates.isType '"Number",
                                        predicates.isType '"String"
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  image = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                            predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                                    predicates.anyOf
                                      [
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "\\${{\\s*(.*?)\\s*}}"
                                        ]
                                      ],
                                }
                                false
                                predicates.never
                              ],
                        }
                        false
                        predicates.never
                      ],
                  language = predicates.isType '"String",
                  memory = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  reserved_name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$"
                      ],
                  schedule = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.not
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "build", "image" ],
                          predicates.records.record {  } {  } true
                          predicates.always
                        ]),
                        predicates.records.record
                        {
                          build = definitions.predicate._DebugBuildSpec,
                          command = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                                  predicates.isType '"String"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          cpu = predicates.anyOf
                              [
                                predicates.isType '"Number",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          depends_on = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          description = predicates.isType '"String",
                          entrypoint = predicates.anyOf
                              [
                                predicates.anyOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                                  predicates.isType '"String"
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          environment = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.isType '"Bool",
                                        predicates.isType 'Null,
                                        predicates.isType '"Number",
                                        predicates.isType '"String"
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^[a-zA-Z0-9_]+$" = predicates.anyOf
                                              [
                                                predicates.isType '"Array",
                                                predicates.isType '"Bool",
                                                predicates.isType 'Null,
                                                predicates.isType '"Number",
                                                predicates.isType '"String"
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          image = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          labels = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                                    predicates.anyOf
                                      [
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "\\${{\\s*(.*?)\\s*}}"
                                        ]
                                      ],
                                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  }
                                        {
                                          "^(?=(.{1,63}/)?.{1,63}$)((([a-z0-9][-a-z0-9_.]*)?[a-z0-9])?/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" =
                                            predicates.anyOf
                                              [
                                                predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.pattern
                                                  "^(?=.{1,63})(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                                                ],
                                                predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.pattern
                                                  "\\${{\\s*(.*?)\\s*}}"
                                                ]
                                              ],
                                        }
                                        false
                                        predicates.never
                                      ],
                                }
                                false
                                predicates.never
                              ],
                          language = predicates.isType '"String",
                          memory = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          reserved_name = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.pattern
                                "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$"
                              ],
                          schedule = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          _DebugVolumeSpec
            | doc m%"
            Architect can mount volumes onto your services and tasks to store data that should be shared between running containers or that should persist beyond the lifetime of a container.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.not
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "host_path", "key" ],
                  predicates.records.record {  } {  } true predicates.always
                ]),
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  host_path = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  key = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  mount_path = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                  readonly = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                        ]
                      ],
                }
                {
                  "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.not
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "host_path", "key" ],
                          predicates.records.record {  } {  } true
                          predicates.always
                        ]),
                        predicates.records.record
                        {
                          description = predicates.isType '"String",
                          host_path = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          key = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          mount_path = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                          readonly = predicates.anyOf
                              [
                                predicates.isType '"Bool",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "\\${{\\s*(.*?)\\s*}}"
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
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
  predicates.records.required [ "name" ],
  predicates.records.record
  {
    artifact_image = predicates.isType '"String",
    author = predicates.isType '"String",
    databases = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
              definitions.predicate.DatabaseSpec,
            "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                      definitions.predicate.DatabaseSpec,
                  }
                  false
                  predicates.never
                ],
          }
          false
          predicates.never
        ],
    dependencies = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "^(?:(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)\\/)?(?<component_name>(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-))(?:@(?<instance_name>[\\w][\\w\\.-]{0,127}))?$" =
              predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^[\\w][\\w\\.-]{0,127}$"
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                  ],
                  definitions.predicate.DependencySpec
                ],
          }
          false
          predicates.never
        ],
    description = predicates.isType '"String",
    homepage = predicates.isType '"String",
    interfaces = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" = predicates.anyOf
                [
                  predicates.isType '"String",
                  definitions.predicate.ComponentInterfaceSpec
                ],
            "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                      predicates.anyOf
                        [
                          predicates.isType '"String",
                          definitions.predicate.ComponentInterfaceSpec
                        ],
                  }
                  false
                  predicates.never
                ],
          }
          false
          predicates.never
        ],
    keywords = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    name = predicates.allOf
        [
          predicates.isType '"String",
          predicates.strings.pattern
          "^(?:(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)\\/)?(?<component_name>(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-))(?:@(?<instance_name>[\\w][\\w\\.-]{0,127}))?$"
        ],
    outputs = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                [
                  predicates.isType '"String",
                  predicates.isType '"Number",
                  predicates.isType '"Bool",
                  definitions.predicate.OutputDefinitionSpec,
                  predicates.isType 'Null
                ],
            "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number",
                          predicates.isType '"Bool",
                          definitions.predicate.OutputDefinitionSpec,
                          predicates.isType 'Null
                        ],
                  }
                  false
                  predicates.never
                ],
          }
          false
          predicates.never
        ],
    secrets = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                [
                  predicates.isType '"String",
                  predicates.isType '"Number",
                  predicates.isType '"Bool",
                  definitions.predicate.SecretDefinitionSpec,
                  predicates.isType 'Null
                ],
          }
          false
          predicates.never
        ],
    services = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
              definitions.predicate.ServiceSpec,
            "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                      definitions.predicate.ServiceSpec,
                  }
                  false
                  predicates.never
                ],
          }
          false
          predicates.never
        ],
    tasks = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
              definitions.predicate.TaskSpec,
            "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                      definitions.predicate.TaskSpec,
                  }
                  false
                  predicates.never
                ],
          }
          false
          predicates.never
        ],
  }
  {
    "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "name" ],
          predicates.records.record
          {
            artifact_image = predicates.isType '"String",
            author = predicates.isType '"String",
            databases = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                      definitions.predicate.DatabaseSpec,
                    "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          {
                            "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                              definitions.predicate.DatabaseSpec,
                          }
                          false
                          predicates.never
                        ],
                  }
                  false
                  predicates.never
                ],
            dependencies = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^(?:(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)\\/)?(?<component_name>(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-))(?:@(?<instance_name>[\\w][\\w\\.-]{0,127}))?$" =
                      predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "^[\\w][\\w\\.-]{0,127}$"
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "\\${{\\s*(.*?)\\s*}}"
                          ],
                          definitions.predicate.DependencySpec
                        ],
                  }
                  false
                  predicates.never
                ],
            description = predicates.isType '"String",
            homepage = predicates.isType '"String",
            interfaces = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                      predicates.anyOf
                        [
                          predicates.isType '"String",
                          definitions.predicate.ComponentInterfaceSpec
                        ],
                    "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          {
                            "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                              predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  definitions.predicate.ComponentInterfaceSpec
                                ],
                          }
                          false
                          predicates.never
                        ],
                  }
                  false
                  predicates.never
                ],
            keywords = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            name = predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern
                  "^(?:(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)\\/)?(?<component_name>(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-))(?:@(?<instance_name>[\\w][\\w\\.-]{0,127}))?$"
                ],
            outputs = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number",
                          predicates.isType '"Bool",
                          definitions.predicate.OutputDefinitionSpec,
                          predicates.isType 'Null
                        ],
                    "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          {
                            "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.isType '"Number",
                                  predicates.isType '"Bool",
                                  definitions.predicate.OutputDefinitionSpec,
                                  predicates.isType 'Null
                                ],
                          }
                          false
                          predicates.never
                        ],
                  }
                  false
                  predicates.never
                ],
            secrets = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number",
                          predicates.isType '"Bool",
                          definitions.predicate.SecretDefinitionSpec,
                          predicates.isType 'Null
                        ],
                  }
                  false
                  predicates.never
                ],
            services = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                      definitions.predicate.ServiceSpec,
                    "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          {
                            "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                              definitions.predicate.ServiceSpec,
                          }
                          false
                          predicates.never
                        ],
                  }
                  false
                  predicates.never
                ],
            tasks = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                      definitions.predicate.TaskSpec,
                    "^\\${{\\s*if(.*?)\\s*}}$" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          {
                            "^(?!-)(?!.{0,32}--)[a-z0-9-]{1,32}(?<!-)$" =
                              definitions.predicate.TaskSpec,
                          }
                          false
                          predicates.never
                        ],
                  }
                  false
                  predicates.never
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