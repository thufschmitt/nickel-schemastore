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
          CodeGeneration
            | doc m%"
            The 'CodeGeneration' object defines global properties that are used to drive the underlying database-driven code generation.
            "%
            = {
                autoDotNetRename
                  | std.enum.TagOrString
                  | [| 'SnakeKebabToPascalCase, 'PascalCase, 'None |]
                  | doc m%"
                  Defaults 'SnakeKebabToPascalCase' that will remove any underscores or hyphens separating each word and capitalize the first character of each; e.g. 'internal-customer_id' would be renamed as 'InternalCustomerId'. The 'PascalCase' option will capatilize the first character only.
                  "%
                  | optional,
                checkUserPermissionSql
                  | String
                  | doc m%"
                  Defaults to '[Sec].[spCheckUserHasPermission]'.
                  "%
                  | optional,
                columnNameCreatedBy
                  | String
                  | doc m%"
                  Defaults to 'CreatedBy'.
                  "%
                  | optional,
                columnNameCreatedDate
                  | String
                  | doc m%"
                  Defaults to 'CreatedDate'.
                  "%
                  | optional,
                columnNameDeletedBy
                  | String
                  | doc m%"
                  Defaults to 'UpdatedBy'.
                  "%
                  | optional,
                columnNameDeletedDate
                  | String
                  | doc m%"
                  Defaults to 'UpdatedDate'.
                  "%
                  | optional,
                columnNameIsDeleted
                  | String
                  | doc m%"
                  Defaults to 'IsDeleted'.
                  "%
                  | optional,
                columnNameOrgUnitId
                  | String
                  | doc m%"
                  Defaults to 'OrgUnitId'.
                  "%
                  | optional,
                columnNameRowVersion
                  | String
                  | doc m%"
                  Defaults to 'RowVersion'.
                  "%
                  | optional,
                columnNameTenantId
                  | String
                  | doc m%"
                  Defaults to 'TenantId'.
                  "%
                  | optional,
                columnNameUpdatedBy
                  | String
                  | doc m%"
                  Defaults to 'UpdatedBy'.
                  "%
                  | optional,
                columnNameUpdatedDate
                  | String
                  | doc m%"
                  Defaults to 'UpdatedDate'.
                  "%
                  | optional,
                efModel
                  | Bool
                  | doc m%"
                  This can be overridden within the 'Table'(s).
                  "%
                  | optional,
                getUserPermissionSql
                  | String
                  | doc m%"
                  Defaults to '[Sec].[fnGetUserHasPermission]'.
                  "%
                  | optional,
                namespaceBase
                  | String
                  | doc m%"
                  Defaults to 'Company' (runtime parameter) + '.' + 'AppName' (runtime parameter). For example 'Beef.Demo'.
                  "%
                  | optional,
                namespaceBusiness
                  | String
                  | doc m%"
                  Defaults to 'NamespaceBase' + '.Business' (literal). For example 'Beef.Demo.Business'.
                  "%
                  | optional,
                namespaceCommon
                  | String
                  | doc m%"
                  Defaults to 'NamespaceBase' + '.Common' (literal). For example 'Beef.Demo.Common'.
                  "%
                  | optional,
                namespaceOutbox
                  | String
                  | doc m%"
                  Defaults to 'NamespaceBusiness'.
                  "%
                  | optional,
                orgUnitImmutable
                  | Bool
                  | doc m%"
                  This is only applicable for stored procedures.
                  "%
                  | optional,
                orgUnitJoinSql
                  | String
                  | doc m%"
                  Defaults to '[Sec].[fnGetUserOrgUnits]()'.
                  "%
                  | optional,
                outbox
                  | Bool
                  | doc m%"
                  Defaults to 'false'.
                  "%
                  | optional,
                outboxDequeueStoredProcedure
                  | String
                  | doc m%"
                  Defaults to 'spEventOutboxDequeue' (literal).
                  "%
                  | optional,
                outboxEnqueueStoredProcedure
                  | String
                  | doc m%"
                  Defaults to 'spEventOutboxEnqueue' (literal).
                  "%
                  | optional,
                outboxSchema
                  | String
                  | doc m%"
                  Defaults to 'Outbox' (literal).
                  "%
                  | optional,
                outboxSchemaCreate
                  | Bool
                  | doc m%"
                  Defaults to 'true'.
                  "%
                  | optional,
                outboxTable
                  | String
                  | doc m%"
                  Defaults to 'EventOutbox' (literal).
                  "%
                  | optional,
                pathBase
                  | String
                  | doc m%"
                  Defaults to 'Company' (runtime parameter) + '.' + 'AppName' (runtime parameter). For example 'Beef.Demo'.
                  "%
                  | optional,
                pathBusiness
                  | String
                  | doc m%"
                  Defaults to 'PathBase' + '.Business' (literal). For example 'Beef.Demo.Business'.
                  "%
                  | optional,
                pathDatabaseMigrations
                  | String
                  | doc m%"
                  Defaults to 'PathBase' + '.Database/Migrations' (literal). For example 'Beef.Demo.Database/Migrations'.
                  "%
                  | optional,
                pathDatabaseSchema
                  | String
                  | doc m%"
                  Defaults to 'PathBase' + '.Database/Schema' (literal). For example 'Beef.Demo.Database/Schema'.
                  "%
                  | optional,
                preprocessorDirectives | Bool | optional,
                queries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Query
                  ])
                  | optional,
                schema
                  | String
                  | doc m%"
                  This is used as the default 'Schema' for all child objects.
                  "%
                  | optional,
                tables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Table
                  ])
                  | optional,
                ..
              },
          Execute
            | doc m%"
            The _Execute_ object enables additional TSQL statements to be embedded within the stored procedure.
            "%
            = {
                location
                  | std.enum.TagOrString
                  | [| 'After, 'Before |]
                  | doc m%"
                  Defaults to 'After'.
                  "%
                  | optional,
                statement | String,
                ..
              },
          OrderBy
            | doc m%"
            The 'OrderBy' object defines the query order. Only valid for 'StoredProcedure.Type' of 'GetAll'.
            "%
            = {
                name | String,
                order
                  | std.enum.TagOrString
                  | [| 'Descending, 'Ascending |]
                  | doc m%"
                  Defaults to 'Ascending'.
                  "%
                  | optional,
                ..
              },
          Parameter
            | doc m%"
            The 'Parameter' is used to define a stored procedure parameter and its charateristics. These are in addition to those that are automatically inferred (added) by the selected 'StoredProcedure.Type'.
            "%
            = {
                collection | Bool | optional,
                column
                  | String
                  | doc m%"
                  Defaults to 'Name'.
                  "%
                  | optional,
                name | String,
                nullable
                  | Bool
                  | doc m%"
                  Note that when the parameter value is 'NULL' it will not be included in the query.
                  "%
                  | optional,
                operator
                  | std.enum.TagOrString
                  | [| 'LIKE, 'GE, 'GT, 'LE, 'LT, 'NE, 'EQ |]
                  | doc m%"
                  Defaults to 'EQ'.
                  "%
                  | optional,
                sqlType | String | optional,
                treatColumnNullAs | Bool | optional,
                ..
              },
          Query
            | doc m%"
            The 'Query' object enables the definition of more complex multi-table queries ('Joins') that would primarily result in a database _View_. The primary table 'Name' for the query is required to be specified. Multiple queries can be specified for the same table(s). The 'IncludeColumns' and 'ExcludeColumns' provide a shorthand to include or exclude selected columns; with the 'AliasColumns' providing a means to rename where required (for example duplicate name). Additional 'Where' and 'Order' configuration can also be added as required.
            "%
            = {
                alias
                  | String
                  | doc m%"
                  Will automatically default where not specified.
                  "%
                  | optional,
                aliasColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Each alias value should be formatted as 'Column' + '^' + 'Alias'; e.g. 'PCODE^ProductCode'
                  "%
                  | optional,
                columnNameCreatedBy
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.CreatedBy'.
                  "%
                  | optional,
                columnNameCreatedDate
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.CreatedDate'.
                  "%
                  | optional,
                columnNameDeletedBy
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.UpdatedBy'.
                  "%
                  | optional,
                columnNameDeletedDate
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.UpdatedDate'.
                  "%
                  | optional,
                columnNameIsDeleted
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.IsDeleted'.
                  "%
                  | optional,
                columnNameOrgUnitId
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.OrgUnitId'.
                  "%
                  | optional,
                columnNameRowVersion
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.RowVersion'.
                  "%
                  | optional,
                columnNameTenantId
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.TenantId'.
                  "%
                  | optional,
                columnNameUpdatedBy
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.UpdatedBy'.
                  "%
                  | optional,
                columnNameUpdatedDate
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.UpdatedDate'.
                  "%
                  | optional,
                excludeColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where not specified this indicates no 'Columns' are to be excluded.
                  "%
                  | optional,
                includeColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where not specified this indicates that all 'Columns' are to be included.
                  "%
                  | optional,
                joins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.QueryJoin
                  ])
                  | optional,
                name | String,
                order
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.QueryOrder
                  ])
                  | optional,
                permission
                  | String
                  | doc m%"
                  The suffix is optional, and where not specified will default to '.READ'.
                  "%
                  | optional,
                schema
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.Schema'.
                  "%
                  | optional,
                view | Bool | optional,
                viewName
                  | String
                  | doc m%"
                  Defaults to 'vw' + 'Name'; e.g. 'vwTableName'.
                  "%
                  | optional,
                viewSchema
                  | String
                  | doc m%"
                  Defaults to 'Schema'.
                  "%
                  | optional,
                where
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.QueryWhere
                  ])
                  | optional,
                ..
              },
          QueryJoin
            | doc m%"
            The 'QueryJoin' object defines a join to another (or same) table within a query. The 'Type' defines the join type, such as inner join, etc. The 'IncludeColumns' and 'ExcludeColumns' provide a shorthand to include or exclude selected columns; with the 'AliasColumns' providing a means to rename where required (for example duplicate name).
            "%
            = {
                alias
                  | String
                  | doc m%"
                  Will automatically default where not specified.
                  "%
                  | optional,
                aliasColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Each alias value should be formatted as 'Column' + '^' + 'Alias'; e.g. 'PCODE^ProductCode'
                  "%
                  | optional,
                columnNameCreatedBy
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.CreatedBy'.
                  "%
                  | optional,
                columnNameCreatedDate
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.CreatedDate'.
                  "%
                  | optional,
                columnNameDeletedBy
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.UpdatedBy'.
                  "%
                  | optional,
                columnNameDeletedDate
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.UpdatedDate'.
                  "%
                  | optional,
                columnNameIsDeleted
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.IsDeleted'.
                  "%
                  | optional,
                columnNameOrgUnitId
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.OrgUnitId'.
                  "%
                  | optional,
                columnNameRowVersion
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.RowVersion'.
                  "%
                  | optional,
                columnNameTenantId
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.TenantId'.
                  "%
                  | optional,
                columnNameUpdatedBy
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.UpdatedBy'.
                  "%
                  | optional,
                columnNameUpdatedDate
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.UpdatedDate'.
                  "%
                  | optional,
                excludeColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where not specified this indicates no 'Columns' are to be excluded.
                  "%
                  | optional,
                includeColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where not specified this indicates that all 'Columns' are to be included.
                  "%
                  | optional,
                name | String,
                on
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.QueryJoinOn
                  ])
                  | optional,
                schema
                  | String
                  | doc m%"
                  Defaults to 'Table.Schema'; i.e. same schema.
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'Full, 'Right, 'Left, 'Inner |]
                  | doc m%"
                  Defaults to 'Inner'.
                  "%
                  | optional,
                ..
              },
          QueryJoinOn
            | doc m%"
            The 'QueryJoinOn' object defines the join on characteristics for a join within a query.
            "%
            = {
                name | String,
                toColumn
                  | String
                  | doc m%"
                  Defaults to 'Name'; i.e. assumes same name. See also 'ToSchema' and 'ToTable' as these all relate.
                  "%
                  | optional,
                toSchema
                  | String
                  | doc m%"
                  Defaults to 'Table.Schema'; i.e. same schema. See also 'ToTable' and 'ToColumn' as these all relate.
                  "%
                  | optional,
                toStatement | String | optional,
                toTable
                  | String
                  | doc m%"
                  Defaults to 'Table.Name'; i.e. primary table. See also 'ToSchema' and 'ToColumn' as these all relate.
                  "%
                  | optional,
                ..
              },
          QueryOrder
            | doc m%"
            The 'QueryOrder' object that defines the query order.
            "%
            = {
                name
                  | String
                  | doc m%"
                  See also 'Schema' and 'Table' as these all relate.
                  "%,
                order
                  | std.enum.TagOrString
                  | [| 'Descending, 'Ascending |]
                  | doc m%"
                  Defaults to 'Ascending'.
                  "%
                  | optional,
                schema
                  | String
                  | doc m%"
                  Defaults to 'Query.Schema'.
                  "%
                  | optional,
                table
                  | String
                  | doc m%"
                  Defaults to 'Table.Name'; i.e. primary table. See also 'Schema' and 'Column' as these all relate.
                  "%
                  | optional,
                ..
              },
          QueryWhere
            | doc m%"
            The 'QueryWhere' object defines an additional where 'Statement' to be added.
            "%
            = { statement | String, .. },
          Relationship
            | doc m%"
            The 'Relationship' object enables the definition of an entity framework (EF) model relationship.
            "%
            = {
                autoInclude
                  | Bool
                  | doc m%"
                  Defaults to 'false'.
                  "%
                  | optional,
                efModelName
                  | String
                  | doc m%"
                  Defaults to 'Name' using the 'CodeGeneration.AutoDotNetRename' option.
                  "%
                  | optional,
                foreignKeyColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                name | String,
                onDelete
                  | std.enum.TagOrString
                  | [|
                    'SetNull,
                    'Restrict,
                    'ClientSetNull,
                    'ClientNoAction,
                    'ClientCascade,
                    'Cascade,
                    'NoAction
                  |]
                  | doc m%"
                  Defaults to 'NoAction'. See https://learn.microsoft.com/en-us/dotnet/api/microsoft.entityframeworkcore.deletebehavior for more information.
                  "%
                  | optional,
                principalKeyColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                   Typically this is only used where referencing property(s) other than the primary key as the principal property(s).
                  "%
                  | optional,
                propertyName
                  | String
                  | doc m%"
                  Defaults to 'Name' using the 'CodeGeneration.AutoDotNetRename' option.
                  "%
                  | optional,
                schema
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.Schema'.
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'ManyToOne, 'OneToMany |]
                  | doc m%"
                  Defaults to 'OneToMany'.
                  "%
                  | optional,
                ..
              },
          StoredProcedure
            | doc m%"
            The code generation for an 'StoredProcedure' is primarily driven by the 'Type' property. This encourages (enforces) a consistent implementation for the standardised **CRUD** (Create, Read, Update and Delete) actions, as well as supporting 'Upsert', 'Merge' and ad-hoc queries as required.
            "%
            = {
                excludeColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where not specified this indicates no 'Columns' are to be excluded. Only filters the columns where 'Type' is 'Get', 'GetColl', 'Create', 'Update' or 'Upsert'.
                  "%
                  | optional,
                execute
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Execute
                  ])
                  | optional,
                includeColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where not specified this indicates that all 'Columns' are to be included. Only filters the columns where 'Type' is 'Get', 'GetColl', 'Create', 'Update' or 'Upsert'.
                  "%
                  | optional,
                intoTempTable
                  | Bool
                  | doc m%"
                  A 'Select * from #TempTable' is also performed (code-generated) where the stored procedure operation 'Type' is 'GetColl'.
                  "%
                  | optional,
                mergeOverrideIdentityColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  This is used to override the default behaviour of using the primary key column(s).
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  See 'StoredProcedureName' for the actual name used in the database.
                  "%,
                orderby
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.OrderBy
                  ])
                  | optional,
                orgUnitImmutable
                  | Bool
                  | doc m%"
                  Defaults to 'Table.OrgUnitImmutable'.
                  "%
                  | optional,
                paging
                  | Bool
                  | doc m%"
                  This only applies where the stored procedure operation 'Type' is 'GetColl'.
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Parameter
                  ])
                  | optional,
                permission | String | optional,
                reselectStatement
                  | String
                  | doc m%"
                  Defaults to '[{{Table.Schema}}].[sp{{Table.Name}}Get]' passing the primary key column(s).
                  "%
                  | optional,
                storedProcedureName
                  | String
                  | doc m%"
                  Defaults to 'sp' + 'Table.Name' + 'Name'; e.g. 'spTableName' or 'spPersonGet'.
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [|
                    'Merge,
                    'Delete,
                    'Upsert,
                    'Update,
                    'Create,
                    'GetColl,
                    'Get
                  |]
                  | doc m%"
                  Defaults to 'GetColl'.
                  "%
                  | optional,
                where
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Where
                  ])
                  | optional,
                withHints | String | optional,
                ..
              },
          Table
            | doc m%"
            The 'Table' object identifies an existing database 'Table' (or 'View') and defines its code-generation characteristics.
            "%
            = {
                alias
                  | String
                  | doc m%"
                  Will automatically default where not specified.
                  "%
                  | optional,
                aliasColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Each alias value should be formatted as 'Column' + '^' + 'Alias'; e.g. 'PCODE^ProductCode'.
                  "%
                  | optional,
                columnNameCreatedBy
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.CreatedBy'.
                  "%
                  | optional,
                columnNameCreatedDate
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.CreatedDate'.
                  "%
                  | optional,
                columnNameDeletedBy
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.UpdatedBy'.
                  "%
                  | optional,
                columnNameDeletedDate
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.UpdatedDate'.
                  "%
                  | optional,
                columnNameIsDeleted
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.IsDeleted'.
                  "%
                  | optional,
                columnNameOrgUnitId
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.OrgUnitId'.
                  "%
                  | optional,
                columnNameRowVersion
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.RowVersion'.
                  "%
                  | optional,
                columnNameTenantId
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.TenantId'.
                  "%
                  | optional,
                columnNameUpdatedBy
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.UpdatedBy'.
                  "%
                  | optional,
                columnNameUpdatedDate
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.UpdatedDate'.
                  "%
                  | optional,
                create | Bool | optional,
                delete | Bool | optional,
                efModel
                  | Bool
                  | doc m%"
                  Defaults to 'CodeGeneration.EfModel'.
                  "%
                  | optional,
                efModelName
                  | String
                  | doc m%"
                  Defaults to 'Name' applying the 'CodeGeneration.AutoDotNetRename'.
                  "%
                  | optional,
                excludeColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where not specified this indicates no 'Columns' are to be excluded.
                  "%
                  | optional,
                get | Bool | optional,
                getAll
                  | Bool
                  | doc m%"
                  The 'GetAllOrderBy' is used to specify the 'GetAll' query sort order.
                  "%
                  | optional,
                getAllOrderBy
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  This relates to the 'GetAll' selection.
                  "%
                  | optional,
                includeColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where not specified this indicates that all 'Columns' are to be included.
                  "%
                  | optional,
                "merge"
                  | Bool
                  | doc m%"
                  This will also require a 'Udt' (SQL User Defined Table) and 'Tvp' (.NET Table-Valued Parameter) to function.
                  "%
                  | optional,
                name | String,
                orgUnitImmutable
                  | Bool
                  | doc m%"
                  Defaults to 'CodeGeneration.OrgUnitImmutable'. This is only applicable for stored procedures.
                  "%
                  | optional,
                permission | String | optional,
                relationships
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Relationship
                  ])
                  | optional,
                schema
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.Schema'.
                  "%
                  | optional,
                storedProcedures
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.StoredProcedure
                  ])
                  | optional,
                tvp | String | optional,
                udt | Bool | optional,
                udtExcludeColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where not specified this indicates that no 'Columns' are to be excluded.
                  "%
                  | optional,
                update | Bool | optional,
                upsert | Bool | optional,
                ..
              },
          Where
            | doc m%"
            The 'Where' object defines an additional where 'Statement' to be added. This is in addition to those automatically added based on the 'StoredProcedure.Type'.
            "%
            = { statement | String, .. },
        },
    predicate = {
          CodeGeneration
            | doc m%"
            The 'CodeGeneration' object defines global properties that are used to drive the underlying database-driven code generation.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  autoDotNetRename = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "None", "PascalCase", "SnakeKebabToPascalCase" ]
                      ],
                  checkUserPermissionSql = predicates.isType '"String",
                  columnNameCreatedBy = predicates.isType '"String",
                  columnNameCreatedDate = predicates.isType '"String",
                  columnNameDeletedBy = predicates.isType '"String",
                  columnNameDeletedDate = predicates.isType '"String",
                  columnNameIsDeleted = predicates.isType '"String",
                  columnNameOrgUnitId = predicates.isType '"String",
                  columnNameRowVersion = predicates.isType '"String",
                  columnNameTenantId = predicates.isType '"String",
                  columnNameUpdatedBy = predicates.isType '"String",
                  columnNameUpdatedDate = predicates.isType '"String",
                  efModel = predicates.isType '"Bool",
                  getUserPermissionSql = predicates.isType '"String",
                  namespaceBase = predicates.isType '"String",
                  namespaceBusiness = predicates.isType '"String",
                  namespaceCommon = predicates.isType '"String",
                  namespaceOutbox = predicates.isType '"String",
                  orgUnitImmutable = predicates.isType '"Bool",
                  orgUnitJoinSql = predicates.isType '"String",
                  outbox = predicates.isType '"Bool",
                  outboxDequeueStoredProcedure = predicates.isType '"String",
                  outboxEnqueueStoredProcedure = predicates.isType '"String",
                  outboxSchema = predicates.isType '"String",
                  outboxSchemaCreate = predicates.isType '"Bool",
                  outboxTable = predicates.isType '"String",
                  pathBase = predicates.isType '"String",
                  pathBusiness = predicates.isType '"String",
                  pathDatabaseMigrations = predicates.isType '"String",
                  pathDatabaseSchema = predicates.isType '"String",
                  preprocessorDirectives = predicates.isType '"Bool",
                  queries = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Query
                      ],
                  schema = predicates.isType '"String",
                  tables = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Table
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Execute
            | doc m%"
            The _Execute_ object enables additional TSQL statements to be embedded within the stored procedure.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "statement" ],
                predicates.records.record
                {
                  location = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Before", "After" ]
                      ],
                  statement = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          OrderBy
            | doc m%"
            The 'OrderBy' object defines the query order. Only valid for 'StoredProcedure.Type' of 'GetAll'.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  order = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Ascending", "Descending" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Parameter
            | doc m%"
            The 'Parameter' is used to define a stored procedure parameter and its charateristics. These are in addition to those that are automatically inferred (added) by the selected 'StoredProcedure.Type'.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  collection = predicates.isType '"Bool",
                  column = predicates.isType '"String",
                  name = predicates.isType '"String",
                  nullable = predicates.isType '"Bool",
                  operator = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "EQ", "NE", "LT", "LE", "GT", "GE", "LIKE" ]
                      ],
                  sqlType = predicates.isType '"String",
                  treatColumnNullAs = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          Query
            | doc m%"
            The 'Query' object enables the definition of more complex multi-table queries ('Joins') that would primarily result in a database _View_. The primary table 'Name' for the query is required to be specified. Multiple queries can be specified for the same table(s). The 'IncludeColumns' and 'ExcludeColumns' provide a shorthand to include or exclude selected columns; with the 'AliasColumns' providing a means to rename where required (for example duplicate name). Additional 'Where' and 'Order' configuration can also be added as required.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  alias = predicates.isType '"String",
                  aliasColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  columnNameCreatedBy = predicates.isType '"String",
                  columnNameCreatedDate = predicates.isType '"String",
                  columnNameDeletedBy = predicates.isType '"String",
                  columnNameDeletedDate = predicates.isType '"String",
                  columnNameIsDeleted = predicates.isType '"String",
                  columnNameOrgUnitId = predicates.isType '"String",
                  columnNameRowVersion = predicates.isType '"String",
                  columnNameTenantId = predicates.isType '"String",
                  columnNameUpdatedBy = predicates.isType '"String",
                  columnNameUpdatedDate = predicates.isType '"String",
                  excludeColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  includeColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  joins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.QueryJoin
                      ],
                  name = predicates.isType '"String",
                  order = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.QueryOrder
                      ],
                  permission = predicates.isType '"String",
                  schema = predicates.isType '"String",
                  view = predicates.isType '"Bool",
                  viewName = predicates.isType '"String",
                  viewSchema = predicates.isType '"String",
                  where = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.QueryWhere
                      ],
                }
                {  }
                true
                predicates.always
              ],
          QueryJoin
            | doc m%"
            The 'QueryJoin' object defines a join to another (or same) table within a query. The 'Type' defines the join type, such as inner join, etc. The 'IncludeColumns' and 'ExcludeColumns' provide a shorthand to include or exclude selected columns; with the 'AliasColumns' providing a means to rename where required (for example duplicate name).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  alias = predicates.isType '"String",
                  aliasColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  columnNameCreatedBy = predicates.isType '"String",
                  columnNameCreatedDate = predicates.isType '"String",
                  columnNameDeletedBy = predicates.isType '"String",
                  columnNameDeletedDate = predicates.isType '"String",
                  columnNameIsDeleted = predicates.isType '"String",
                  columnNameOrgUnitId = predicates.isType '"String",
                  columnNameRowVersion = predicates.isType '"String",
                  columnNameTenantId = predicates.isType '"String",
                  columnNameUpdatedBy = predicates.isType '"String",
                  columnNameUpdatedDate = predicates.isType '"String",
                  excludeColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  includeColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                  on = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.QueryJoinOn
                      ],
                  schema = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Inner", "Left", "Right", "Full" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          QueryJoinOn
            | doc m%"
            The 'QueryJoinOn' object defines the join on characteristics for a join within a query.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  toColumn = predicates.isType '"String",
                  toSchema = predicates.isType '"String",
                  toStatement = predicates.isType '"String",
                  toTable = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          QueryOrder
            | doc m%"
            The 'QueryOrder' object that defines the query order.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  order = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Ascending", "Descending" ]
                      ],
                  schema = predicates.isType '"String",
                  table = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          QueryWhere
            | doc m%"
            The 'QueryWhere' object defines an additional where 'Statement' to be added.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "statement" ],
                predicates.records.record
                { statement = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          Relationship
            | doc m%"
            The 'Relationship' object enables the definition of an entity framework (EF) model relationship.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  autoInclude = predicates.isType '"Bool",
                  efModelName = predicates.isType '"String",
                  foreignKeyColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                  onDelete = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "NoAction",
                          "Cascade",
                          "ClientCascade",
                          "ClientNoAction",
                          "ClientSetNull",
                          "Restrict",
                          "SetNull"
                        ]
                      ],
                  principalKeyColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  propertyName = predicates.isType '"String",
                  schema = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "OneToMany", "ManyToOne" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          StoredProcedure
            | doc m%"
            The code generation for an 'StoredProcedure' is primarily driven by the 'Type' property. This encourages (enforces) a consistent implementation for the standardised **CRUD** (Create, Read, Update and Delete) actions, as well as supporting 'Upsert', 'Merge' and ad-hoc queries as required.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  excludeColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  execute = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Execute
                      ],
                  includeColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  intoTempTable = predicates.isType '"Bool",
                  mergeOverrideIdentityColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                  orderby = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.OrderBy
                      ],
                  orgUnitImmutable = predicates.isType '"Bool",
                  paging = predicates.isType '"Bool",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Parameter
                      ],
                  permission = predicates.isType '"String",
                  reselectStatement = predicates.isType '"String",
                  storedProcedureName = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Get",
                          "GetColl",
                          "Create",
                          "Update",
                          "Upsert",
                          "Delete",
                          "Merge"
                        ]
                      ],
                  where = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Where
                      ],
                  withHints = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Table
            | doc m%"
            The 'Table' object identifies an existing database 'Table' (or 'View') and defines its code-generation characteristics.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  alias = predicates.isType '"String",
                  aliasColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  columnNameCreatedBy = predicates.isType '"String",
                  columnNameCreatedDate = predicates.isType '"String",
                  columnNameDeletedBy = predicates.isType '"String",
                  columnNameDeletedDate = predicates.isType '"String",
                  columnNameIsDeleted = predicates.isType '"String",
                  columnNameOrgUnitId = predicates.isType '"String",
                  columnNameRowVersion = predicates.isType '"String",
                  columnNameTenantId = predicates.isType '"String",
                  columnNameUpdatedBy = predicates.isType '"String",
                  columnNameUpdatedDate = predicates.isType '"String",
                  create = predicates.isType '"Bool",
                  delete = predicates.isType '"Bool",
                  efModel = predicates.isType '"Bool",
                  efModelName = predicates.isType '"String",
                  excludeColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  get = predicates.isType '"Bool",
                  getAll = predicates.isType '"Bool",
                  getAllOrderBy = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  includeColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  "merge" = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  orgUnitImmutable = predicates.isType '"Bool",
                  permission = predicates.isType '"String",
                  relationships = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Relationship
                      ],
                  schema = predicates.isType '"String",
                  storedProcedures = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.StoredProcedure
                      ],
                  tvp = predicates.isType '"String",
                  udt = predicates.isType '"Bool",
                  udtExcludeColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  update = predicates.isType '"Bool",
                  upsert = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          Where
            | doc m%"
            The 'Where' object defines an additional where 'Statement' to be added. This is in addition to those automatically added based on the 'StoredProcedure.Type'.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "statement" ],
                predicates.records.record
                { statement = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
        },
  }
in

predicates.contract_from_predicate definitions.predicate.CodeGeneration