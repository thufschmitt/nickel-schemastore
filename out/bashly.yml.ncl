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
          args-property
            | doc m%"
            Arguments of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#args
            "%
            = predicates.contract_from_predicate
              definitions.predicate.args-property,
          argument
            | doc m%"
            A positional argument of the current script or sub-command
            https://bashly.dannyb.co/configuration/argument/
            "%
            = predicates.contract_from_predicate definitions.predicate.argument,
          catch-all-property
            | doc m%"
            Whether to allow additional arguments or flags for the current command
            https://bashly.dannyb.co/configuration/command/#catch_all
            "%
            = predicates.contract_from_predicate
              definitions.predicate.catch-all-property,
          command-property
            | doc m%"
            A command of the current application
            https://bashly.dannyb.co/configuration/command/#command
            "%
            = predicates.contract_from_predicate
              definitions.predicate.command-property,
          commands-property
            | doc m%"
            Subcommands of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#commands
            "%
            = predicates.contract_from_predicate
              definitions.predicate.commands-property,
          completions-property
            | doc m%"
            Completions of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#completions
            "%
            = predicates.contract_from_predicate
              definitions.predicate.completions-property,
          custom-properties = predicates.contract_from_predicate
              definitions.predicate.custom-properties,
          dependencies-command-property
            | doc m%"
            Dependencies of the current script or sub-command
            https://bashly.dannyb.co/configuration/dependency/#command
            "%
            = predicates.contract_from_predicate
              definitions.predicate.dependencies-command-property,
          dependencies-help-property
            | doc m%"
            A help for the current dependency
            https://bashly.dannyb.co/configuration/dependency/#help
            "%
            = predicates.contract_from_predicate
              definitions.predicate.dependencies-help-property,
          dependencies-property = predicates.contract_from_predicate
              definitions.predicate.dependencies-property,
          environment-variables-default-property
            | doc m%"
            A default value of the current environment variable
            https://bashly.dannyb.co/configuration/environment-variable/#default
            "%
            = String,
          environment-variables-help-property
            | doc m%"
            A description of the current environment variable
            https://bashly.dannyb.co/configuration/environment-variable/#help
            "%
            = predicates.contract_from_predicate
              definitions.predicate.environment-variables-help-property,
          environment-variables-name-property
            | doc m%"
            A name of the current environment variable
            https://bashly.dannyb.co/configuration/environment-variable/#name
            "%
            = predicates.contract_from_predicate
              definitions.predicate.environment-variables-name-property,
          environment-variables-private-property
            | doc m%"
            Whether the current environment variable is hidden from help
            https://bashly.dannyb.co/configuration/environment-variable/#private
            "%
            = Bool,
          environment-variables-property
            | doc m%"
            Environment variables of the current application
            https://bashly.dannyb.co/configuration/environment-variable/#environment-variable
            "%
            = predicates.contract_from_predicate
              definitions.predicate.environment-variables-property,
          environment-variables-required-property
            | doc m%"
            Whether the current environment variable is required
            https://bashly.dannyb.co/configuration/environment-variable/#required
            "%
            = Bool,
          examples-property = predicates.contract_from_predicate
              definitions.predicate.examples-property,
          filename-property
            | doc m%"
            A partial file path of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#filename
            "%
            = predicates.contract_from_predicate
              definitions.predicate.filename-property,
          filters-property
            | doc m%"
            Filters of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#filters
            "%
            = predicates.contract_from_predicate
              definitions.predicate.filters-property,
          flag
            | doc m%"
            A flag of the current script or sub-command
            https://bashly.dannyb.co/configuration/flag/
            "%
            = predicates.contract_from_predicate definitions.predicate.flag,
          flags-property
            | doc m%"
            Flags of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#flags
            "%
            = predicates.contract_from_predicate
              definitions.predicate.flags-property,
          footer-property
            | doc m%"
            A description footer for the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#footer
            "%
            = predicates.contract_from_predicate
              definitions.predicate.footer-property,
          function-property
            | doc m%"
            An internal function for the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#function
            "%
            = predicates.contract_from_predicate
              definitions.predicate.function-property,
          help-property
            | doc m%"
            A description of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#help
            "%
            = predicates.contract_from_predicate
              definitions.predicate.help-property,
          name-property
            | doc m%"
            A name of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#name
            "%
            = predicates.contract_from_predicate
              definitions.predicate.name-property,
          root-extensible-property
            | doc m%"
            Whether to delegate the current unknown command to an external executable
            https://bashly.dannyb.co/configuration/command/#extensible
            "%
            = predicates.contract_from_predicate
              definitions.predicate.root-extensible-property,
          root-version-property
            | doc m%"
            A version of the current script
            https://bashly.dannyb.co/configuration/command/#version
            "%
            = predicates.contract_from_predicate
              definitions.predicate.root-version-property,
          sub-command-alias-property = predicates.contract_from_predicate
              definitions.predicate.sub-command-alias-property,
          sub-command-default-property
            | doc m%"
            Whether to use the current command as a fallback when CLI used incorrectly
            https://bashly.dannyb.co/configuration/command/#default
            "%
            = predicates.contract_from_predicate
              definitions.predicate.sub-command-default-property,
          sub-command-expose-property
            | doc m%"
            Whether to expose the current sub-command if it has sub-commands
            https://bashly.dannyb.co/configuration/command/#expose
            "%
            = predicates.contract_from_predicate
              definitions.predicate.sub-command-expose-property,
          sub-command-group-property
            | doc m%"
            A group of the current sub-command
            https://bashly.dannyb.co/configuration/command/#group
            "%
            = predicates.contract_from_predicate
              definitions.predicate.sub-command-group-property,
          sub-command-import-property
            | doc m%"
            A file import for the current sub-command
            https://bashly.dannyb.co/configuration/command/#import
            "%
            = predicates.contract_from_predicate
              definitions.predicate.sub-command-import-property,
          sub-command-private-property
            | doc m%"
            Whether hide the current sub-command from help
            https://bashly.dannyb.co/configuration/command/#private
            "%
            = Bool,
        },
    predicate = {
          args-property
            | doc m%"
            Arguments of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#args
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.argument,
                predicates.arrays.minItems 1,
                predicates.arrays.uniqueItems
              ],
          argument
            | doc m%"
            A positional argument of the current script or sub-command
            https://bashly.dannyb.co/configuration/argument/
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  allowed = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.strings.minLength 1,
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]),
                        predicates.arrays.uniqueItems
                      ],
                  "default" = predicates.isType '"String",
                  help = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  repeatable = predicates.isType '"Bool",
                  required = predicates.isType '"Bool",
                  validate = predicates.isType '"String",
                }
                {  }
                false
                predicates.never,
                definitions.predicate.custom-properties
              ],
          catch-all-property
            | doc m%"
            Whether to allow additional arguments or flags for the current command
            https://bashly.dannyb.co/configuration/command/#catch_all
            "%
            = predicates.oneOf
              [
                predicates.isType '"Bool",
                predicates.allOf
                [ predicates.isType '"String", predicates.strings.minLength 1 ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    help = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    label = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    required = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          command-property
            | doc m%"
            A command of the current application
            https://bashly.dannyb.co/configuration/command/#command
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  alias = definitions.predicate.sub-command-alias-property,
                  args = definitions.predicate.args-property,
                  catch_all = definitions.predicate.catch-all-property,
                  commands = definitions.predicate.commands-property,
                  completions = definitions.predicate.completions-property,
                  "default" =
                    definitions.predicate.sub-command-default-property,
                  dependencies = definitions.predicate.dependencies-property,
                  environment_variables =
                    definitions.predicate.environment-variables-property,
                  examples = definitions.predicate.examples-property,
                  expose = definitions.predicate.sub-command-expose-property,
                  filename = definitions.predicate.filename-property,
                  filters = definitions.predicate.filters-property,
                  flags = definitions.predicate.flags-property,
                  footer = definitions.predicate.footer-property,
                  function = definitions.predicate.function-property,
                  group = definitions.predicate.sub-command-group-property,
                  help = definitions.predicate.help-property,
                  "import" = definitions.predicate.sub-command-import-property,
                  name = definitions.predicate.name-property,
                  private = definitions.predicate.sub-command-private-property,
                }
                {  }
                false
                predicates.never,
                definitions.predicate.custom-properties
              ],
          commands-property
            | doc m%"
            Subcommands of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#commands
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.command-property,
                predicates.arrays.uniqueItems
              ],
          completions-property
            | doc m%"
            Completions of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#completions
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.strings.minLength 1,
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.minLength 1
                ]),
                predicates.arrays.uniqueItems
              ],
          custom-properties = predicates.records.record {  }
              { "^x_." = predicates.always, }
              true
              predicates.always,
          dependencies-command-property
            | doc m%"
            Dependencies of the current script or sub-command
            https://bashly.dannyb.co/configuration/dependency/#command
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.minLength 1
                ]),
                predicates.arrays.minItems 1,
                predicates.arrays.uniqueItems
              ],
          dependencies-help-property
            | doc m%"
            A help for the current dependency
            https://bashly.dannyb.co/configuration/dependency/#help
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          dependencies-property = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.strings.minLength 1,
                  predicates.arrays.arrayOf
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType 'Null
                  ]),
                  predicates.arrays.uniqueItems
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "." = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                          predicates.isType 'Null,
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "command" ],
                            predicates.records.record
                            {
                              command =
                                definitions.predicate.dependencies-command-property,
                              help =
                                definitions.predicate.dependencies-help-property,
                            }
                            {  }
                            false
                            predicates.never
                          ]
                        ],
                  }
                  false
                  predicates.never
                ]
              ],
          environment-variables-default-property
            | doc m%"
            A default value of the current environment variable
            https://bashly.dannyb.co/configuration/environment-variable/#default
            "%
            = predicates.isType '"String",
          environment-variables-help-property
            | doc m%"
            A description of the current environment variable
            https://bashly.dannyb.co/configuration/environment-variable/#help
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          environment-variables-name-property
            | doc m%"
            A name of the current environment variable
            https://bashly.dannyb.co/configuration/environment-variable/#name
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          environment-variables-private-property
            | doc m%"
            Whether the current environment variable is hidden from help
            https://bashly.dannyb.co/configuration/environment-variable/#private
            "%
            = predicates.isType '"Bool",
          environment-variables-property
            | doc m%"
            Environment variables of the current application
            https://bashly.dannyb.co/configuration/environment-variable/#environment-variable
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.ifThenElse
                  (predicates.records.record
                  { required = predicates.const false, }
                  {  }
                  true
                  predicates.always)
                  (predicates.allOf
                  [
                    predicates.records.record
                    {
                      "default" =
                        definitions.predicate.environment-variables-default-property,
                      help =
                        definitions.predicate.environment-variables-help-property,
                      name =
                        definitions.predicate.environment-variables-name-property,
                      private =
                        definitions.predicate.environment-variables-private-property,
                      required =
                        definitions.predicate.environment-variables-required-property,
                    }
                    {  }
                    false
                    predicates.never,
                    definitions.predicate.custom-properties
                  ])
                  (predicates.allOf
                  [
                    predicates.records.record
                    {
                      help =
                        definitions.predicate.environment-variables-help-property,
                      name =
                        definitions.predicate.environment-variables-name-property,
                      private =
                        definitions.predicate.environment-variables-private-property,
                      required =
                        definitions.predicate.environment-variables-required-property,
                    }
                    {  }
                    false
                    predicates.never,
                    definitions.predicate.custom-properties
                  ]),
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    "default" =
                      definitions.predicate.environment-variables-default-property,
                    help =
                      definitions.predicate.environment-variables-help-property,
                    name =
                      definitions.predicate.environment-variables-name-property,
                    private =
                      definitions.predicate.environment-variables-private-property,
                    required =
                      definitions.predicate.environment-variables-required-property,
                  }
                  {  }
                  true
                  predicates.always
                ]),
                predicates.arrays.uniqueItems
              ],
          environment-variables-required-property
            | doc m%"
            Whether the current environment variable is required
            https://bashly.dannyb.co/configuration/environment-variable/#required
            "%
            = predicates.isType '"Bool",
          examples-property = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.strings.minLength 1 ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ]),
                  predicates.arrays.minItems 1,
                  predicates.arrays.uniqueItems
                ]
              ],
          filename-property
            | doc m%"
            A partial file path of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#filename
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          filters-property
            | doc m%"
            Filters of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#filters
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.minLength 1
                ]),
                predicates.arrays.minItems 1
              ],
          flag
            | doc m%"
            A flag of the current script or sub-command
            https://bashly.dannyb.co/configuration/flag/
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "long" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "short" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  allowed = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.strings.minLength 1,
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]),
                        predicates.arrays.uniqueItems
                      ],
                  arg = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  completions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.strings.minLength 1,
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]),
                        predicates.arrays.uniqueItems
                      ],
                  conflicts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.strings.minLength 1,
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]),
                        predicates.arrays.uniqueItems
                      ],
                  "default" = predicates.isType '"String",
                  help = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  long = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^--"
                      ],
                  private = predicates.isType '"Bool",
                  repeatable = predicates.isType '"Bool",
                  required = predicates.isType '"Bool",
                  short = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^-[^-]"
                      ],
                  validate = predicates.isType '"String",
                }
                {  }
                false
                predicates.never,
                definitions.predicate.custom-properties
              ],
          flags-property
            | doc m%"
            Flags of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#flags
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.flag,
                predicates.arrays.minItems 1,
                predicates.arrays.uniqueItems
              ],
          footer-property
            | doc m%"
            A description footer for the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#footer
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          function-property
            | doc m%"
            An internal function for the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#function
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          help-property
            | doc m%"
            A description of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#help
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          name-property
            | doc m%"
            A name of the current script or sub-command
            https://bashly.dannyb.co/configuration/command/#name
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          root-extensible-property
            | doc m%"
            Whether to delegate the current unknown command to an external executable
            https://bashly.dannyb.co/configuration/command/#extensible
            "%
            = predicates.oneOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
          root-version-property
            | doc m%"
            A version of the current script
            https://bashly.dannyb.co/configuration/command/#version
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          sub-command-alias-property = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.strings.minLength 1 ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ]),
                  predicates.arrays.minItems 1,
                  predicates.arrays.uniqueItems
                ]
              ],
          sub-command-default-property
            | doc m%"
            Whether to use the current command as a fallback when CLI used incorrectly
            https://bashly.dannyb.co/configuration/command/#default
            "%
            = predicates.oneOf
              [
                predicates.isType '"Bool",
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "force" ] ]
              ],
          sub-command-expose-property
            | doc m%"
            Whether to expose the current sub-command if it has sub-commands
            https://bashly.dannyb.co/configuration/command/#expose
            "%
            = predicates.oneOf
              [
                predicates.isType '"Bool",
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "always" ] ]
              ],
          sub-command-group-property
            | doc m%"
            A group of the current sub-command
            https://bashly.dannyb.co/configuration/command/#group
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          sub-command-import-property
            | doc m%"
            A file import for the current sub-command
            https://bashly.dannyb.co/configuration/command/#import
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          sub-command-private-property
            | doc m%"
            Whether hide the current sub-command from help
            https://bashly.dannyb.co/configuration/command/#private
            "%
            = predicates.isType '"Bool",
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.record
  {
    args = definitions.predicate.args-property,
    catch_all = definitions.predicate.catch-all-property,
    commands = definitions.predicate.commands-property,
    completions = definitions.predicate.completions-property,
    dependencies = definitions.predicate.dependencies-property,
    environment_variables =
      definitions.predicate.environment-variables-property,
    examples = definitions.predicate.examples-property,
    extensible = definitions.predicate.root-extensible-property,
    filename = definitions.predicate.filename-property,
    filters = definitions.predicate.filters-property,
    flags = definitions.predicate.flags-property,
    footer = definitions.predicate.footer-property,
    function = definitions.predicate.function-property,
    help = definitions.predicate.help-property,
    name = definitions.predicate.name-property,
    version = definitions.predicate.root-version-property,
  }
  {  }
  false
  predicates.never,
  definitions.predicate.custom-properties
])