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
            The 'CodeGeneration' object defines global properties that are used to drive the underlying entity-driven code generation.
            "%
            = {
                autoImplement
                  | std.enum.TagOrString
                  | [|
                    'None,
                    'HttpAgent,
                    'OData,
                    'Cosmos,
                    'EntityFramework,
                    'Database
                  |]
                  | doc m%"
                  Defaults to 'None'. Indicates that the implementation for the underlying 'Operations' will be auto-implemented using the selected data source (unless explicitly overridden). When selected some of the related attributes will also be required (as documented). Additionally, the 'AutoImplement' can be further specified/overridden per 'Operation'.
                  "%
                  | optional,
                cosmosName
                  | String
                  | doc m%"
                  Defaults to 'ICosmosDb'. This can be overridden within the 'Entity'(s).
                  "%
                  | optional,
                databaseName
                  | String
                  | doc m%"
                  Defaults to 'IDatabase'. This can be overridden within the 'Entity'(s).
                  "%
                  | optional,
                databaseProvider
                  | std.enum.TagOrString
                  | [| 'MySQL, 'SqlServer |]
                  | doc m%"
                  Defaults to 'SqlServer'. Enables specific database provider functionality/formatting/etc. where applicable.
                  "%
                  | optional,
                databaseSchema
                  | String
                  | doc m%"
                  Defaults to 'dbo'.
                  "%
                  | optional,
                entities
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Entity
                  ])
                  | optional,
                entityFrameworkName
                  | String
                  | doc m%"
                  Defaults to 'IEfDb'. This can be overridden within the 'Entity'(s).
                  "%
                  | optional,
                etagDefaultMapperConverter
                  | String
                  | doc m%"
                  Defaults to 'StringToBase64Converter'.
                  "%
                  | optional,
                etagJsonName
                  | std.enum.TagOrString
                  | [| 'ETAG, 'ETag, '_eTag, '_etag, 'eTag, 'etag |]
                  | doc m%"
                  Defaults to 'etag'. Note that the 'JsonName' can be set individually per property where required.
                  "%
                  | optional,
                eventActionFormat
                  | std.enum.TagOrString
                  | [| 'PastTense, 'None |]
                  | doc m%"
                  Defaults to 'None' (no formatting required, i.e. as-is)'.
                  "%
                  | optional,
                eventPublish
                  | std.enum.TagOrString
                  | [| 'Data, 'DataSvc, 'None |]
                  | doc m%"
                  Defaults to 'DataSvc'. Used to enable the sending of messages to the likes of EventHub, ServiceBus, SignalR, etc. This can be overridden within the 'Entity'(s).
                  "%
                  | optional,
                eventSourceKind
                  | std.enum.TagOrString
                  | [| 'RelativeOrAbsolute, 'Relative, 'Absolute, 'None |]
                  | doc m%"
                  Defaults to 'None' (being the event source is not updated).
                  "%
                  | optional,
                eventSourceRoot
                  | String
                  | doc m%"
                  The event source is only updated where an 'EventSourceKind' is not 'None'. This can be extended within the 'Entity'(s).
                  "%
                  | optional,
                eventSubjectRoot
                  | String
                  | doc m%"
                  Used to enable the sending of messages to the likes of EventHub, ServiceBus, SignalR, etc. This can be overridden within the 'Entity'(s).
                  "%
                  | optional,
                eventSubjectSeparator
                  | String
                  | doc m%"
                  Defaults to '.'. Used only where the subject is automatically inferred.
                  "%
                  | optional,
                eventTransaction
                  | Bool
                  | doc m%"
                  Usage will force a rollback of any underlying data transaction (where the provider supports TransactionScope) on failure, such as an 'EventPublish' error. This is by no means implying a Distributed Transaction (DTC) should be invoked; this is only intended for a single data source that supports a TransactionScope to guarantee reliable event publishing. Defaults to 'false'. This essentially defaults the 'Entity.EventTransaction' where not otherwise specified. This should only be used where 'EventPublish' is 'DataSvc' and a transactionally-aware data source is being used.
                  "%
                  | optional,
                grpc
                  | Bool
                  | doc m%"
                  gRPC support is an explicit opt-in model. Must be set to 'true' for any of the subordinate gRPC capabilities to be code-generated. Will require each 'Entity', and corresponding 'Property' and 'Operation' to be opted-in specifically.
                  "%
                  | optional,
                httpAgentName
                  | String
                  | doc m%"
                  Defaults to 'IHttpAgent'. This can be overridden within the 'Entity'(s).
                  "%
                  | optional,
                jsonSerializer
                  | std.enum.TagOrString
                  | [| 'Newtonsoft, 'SystemText |]
                  | doc m%"
                  Defaults to 'SystemText'. This can be overridden within the 'Entity'(s).
                  "%
                  | optional,
                managerCleanUp
                  | Bool
                  | doc m%"
                  This can be overridden within the 'Entity'(s) and 'Operation'(s).
                  "%
                  | optional,
                namespaceApi
                  | String
                  | doc m%"
                  Defaults to 'NamespaceBase' + '.' + 'ApiName' (runtime parameter). For example 'Beef.Demo.Api'.
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
                odataName
                  | String
                  | doc m%"
                  Defaults to 'IOData'. This can be overridden within the 'Entity'(s).
                  "%
                  | optional,
                pathApi
                  | String
                  | doc m%"
                  Defaults to 'PathBase' + '.' + 'ApiName' (runtime parameter). For example 'Beef.Demo.Api'.
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
                pathCommon
                  | String
                  | doc m%"
                  Defaults to 'PathBase' + '.Common' (literal). For example 'Beef.Demo.Common'.
                  "%
                  | optional,
                preprocessorDirectives | Bool | optional,
                refDataCodeDataName
                  | String
                  | doc m%"
                  Defaults to 'Code' (literal).
                  "%
                  | optional,
                refDataCommonNamespace
                  | String
                  | doc m%"
                  Defaults to 'Company' + '.' (literal) + AppName + '.Common.Entities' (literal).
                  "%
                  | optional,
                refDataDataCtorParams
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Each constructor parameter should be formatted as 'Type' + '^' + 'Name'; e.g. 'IConfiguration^Config'. Where the 'Name' portion is not specified it will be inferred. Where the 'Type' matches an already inferred value it will be ignored.
                  "%
                  | optional,
                refDataDefaultMapperConverter
                  | std.enum.TagOrString
                  | [|
                    '"ReferenceDataNullableGuidIdConverter<T>",
                    '"ReferenceDataNullableGuidIdConverter{T}",
                    'ReferenceDataNullableGuidIdConverter,
                    '"ReferenceDataGuidIdConverter<T>",
                    '"ReferenceDataGuidIdConverter{T}",
                    'ReferenceDataGuidIdConverter,
                    '"ReferenceDataNullableInt64IdConverter<T>",
                    '"ReferenceDataNullableInt64IdConverter{T}",
                    'ReferenceDataNullableInt64IdConverter,
                    '"ReferenceDataInt64IdConverter<T>",
                    '"ReferenceDataInt64IdConverter{T}",
                    'ReferenceDataInt64IdConverter,
                    '"ReferenceDataNullableInt32IdConverter<T>",
                    '"ReferenceDataNullableInt32IdConverter{T}",
                    'ReferenceDataNullableInt32IdConverter,
                    '"ReferenceDataInt32IdConverter<T>",
                    '"ReferenceDataInt32IdConverter{T}",
                    'ReferenceDataInt32IdConverter,
                    '"ReferenceDataIdConverter<T, Guid?>",
                    '"ReferenceDataIdConverter{T, Guid?}",
                    '"ReferenceDataIdConverter<T, Guid>",
                    '"ReferenceDataIdConverter{T, Guid}",
                    '"ReferenceDataIdConverter<T, long?>",
                    '"ReferenceDataIdConverter{T, long?}",
                    '"ReferenceDataIdConverter<T, long>",
                    '"ReferenceDataIdConverter{T, long}",
                    '"ReferenceDataIdConverter<T, int?>",
                    '"ReferenceDataIdConverter{T, int?}",
                    '"ReferenceDataIdConverter<T, int>",
                    '"ReferenceDataIdConverter{T, int}",
                    '"ReferenceDataCodeConverter<T>",
                    '"ReferenceDataCodeConverter{T}",
                    'ReferenceDataCodeConverter
                  |]
                  | doc m%"
                  Defaults to 'ReferenceDataCodeConverter<T>'. Where this value is suffixed by '<T>' or '{T}' this will automatically be set to the 'Type'.
                  "%
                  | optional,
                refDataETagDataName
                  | String
                  | doc m%"
                  Defaults to 'RowVersion' (literal).
                  "%
                  | optional,
                refDataIsActiveDataName
                  | String
                  | doc m%"
                  Defaults to 'IsActive' (literal).
                  "%
                  | optional,
                refDataNamespace
                  | String
                  | doc m%"
                  Defaults to 'Company' + '.' (literal) + AppName + '.Business.Entities' (literal).
                  "%
                  | optional,
                refDataSortOrderDataName
                  | String
                  | doc m%"
                  Defaults to 'SortOrder' (literal).
                  "%
                  | optional,
                refDataText
                  | Bool
                  | doc m%"
                  This is used where serializing within the Web API 'Controller' and the 'ExecutionContext.IsRefDataTextSerializationEnabled' is set to 'true' (which is automatically set where the url contains '$text=true'). This can be further configured on the 'Entity' and for each 'Property'.
                  "%
                  | optional,
                refDataTextDataName
                  | String
                  | doc m%"
                  Defaults to 'Text' (literal).
                  "%
                  | optional,
                refDataType
                  | std.enum.TagOrString
                  | [| 'string, 'Guid, 'long, 'int |]
                  | doc m%"
                  Required to identify an entity as being Reference Data. Specifies the underlying .NET Type used for the Reference Data identifier. Results in all underlying entities becoming Reference Data.
                  "%
                  | optional,
                refDataWebApiRoute | String | optional,
                usingNamespace1
                  | String
                  | doc m%"
                  Typically used where referening a 'Type' from a Namespace that is not generated by default.
                  "%
                  | optional,
                usingNamespace2
                  | String
                  | doc m%"
                  Typically used where referening a 'Type' from a Namespace that is not generated by default.
                  "%
                  | optional,
                usingNamespace3
                  | String
                  | doc m%"
                  Typically used where referening a 'Type' from a Namespace that is not generated by default.
                  "%
                  | optional,
                validationFramework
                  | std.enum.TagOrString
                  | [| 'FluentValidation, 'CoreEx |]
                  | doc m%"
                  Defaults to 'CoreEx' (literal). This can be overridden within the 'Entity'(s), 'Operation'(s) and 'Parameter'(s).
                  "%
                  | optional,
                webApiAuthorize
                  | String
                  | doc m%"
                  This can be overridden within the 'Entity'(s) and/or their corresponding 'Operation'(s).
                  "%
                  | optional,
                webApiAutoLocation
                  | Bool
                  | doc m%"
                  This will automatically set the 'Operation.WebApiLocation' for an 'Operation' named 'Create' where there is a corresponding named 'Get'. This can be overridden within the 'Entity'(s).
                  "%
                  | optional,
                webApiRoutePrefix
                  | String
                  | doc m%"
                  This is the base (prefix) 'URI' prepended to all entity and underlying 'Operation'(s).
                  "%
                  | optional,
                withResult
                  | Bool
                  | doc m%"
                  Defaults to 'true'. This can be overridden within the 'Entity'(s) and/or 'Operation'(s).
                  "%
                  | optional,
                ..
              },
          Const
            | doc m%"
            The 'Const' object is used to define a .NET (C#) constant value for an 'Entity'.
            "%
            = {
                name | String,
                text
                  | String
                  | doc m%"
                  By default the 'Text' will be the 'Name' reformatted as sentence casing. It will be formatted as: 'Represents a {text} constant value.' To create a '<see cref="XXX"/>' within use moustache shorthand (e.g. '{{Xxx}}').
                  "%
                  | optional,
                value
                  | String
                  | doc m%"
                  The code generation will ensure the value is delimited properly to output correctly formed (delimited) .NET (C#) code.
                  "%,
                ..
              },
          Entity
            | doc m%"
            The 'Entity' is used as the primary configuration for driving the entity-driven code generation.
            "%
            = {
                abstract | Bool | optional,
                argumentName
                  | String
                  | doc m%"
                  Overrides the 'Name' to be used for argument parameters. By default reformatted from 'Name'; e.g. 'FirstName' as 'firstName'.
                  "%
                  | optional,
                authRole
                  | String
                  | doc m%"
                  Used where not overridden specifically for an 'Operation'; i.e. acts as the default.
                  "%
                  | optional,
                autoImplement
                  | std.enum.TagOrString
                  | [|
                    'None,
                    'HttpAgent,
                    'OData,
                    'Cosmos,
                    'EntityFramework,
                    'Database
                  |]
                  | doc m%"
                  Defaults to 'CodeGeneration.AutoImplement' (where 'RefDataType' or 'EntityFrameworkModel' or 'CosmosModel' or 'HttpAgent' is not null; otherwise, 'None'. Indicates that the implementation for the underlying 'Operations' will be auto-implemented using the selected data source (unless explicitly overridden). When selected some of the related attributes will also be required (as documented). Additionally, the 'AutoImplement' can be further specified/overridden per 'Operation'.
                  "%
                  | optional,
                collection | Bool | optional,
                collectionInherits
                  | String
                  | doc m%"
                  Defaults to 'EntityBaseCollection' or 'EntityBaseKeyedCollection' depending on 'CollectionKeyed'. For Reference Data it will default to 'ReferenceDataCollectionBase'.
                  "%
                  | optional,
                collectionResult
                  | Bool
                  | doc m%"
                  Enables the likes of additional paging state to be stored with the underlying collection.
                  "%
                  | optional,
                collectionResultInherits
                  | String
                  | doc m%"
                  Defaults to 'EntityCollectionResult'.
                  "%
                  | optional,
                collectionType
                  | std.enum.TagOrString
                  | [| 'Dictionary, 'Keyed, 'Standard |]
                  | optional,
                constType
                  | std.enum.TagOrString
                  | [| 'string, 'Guid, 'long, 'int |]
                  | doc m%"
                  The .NET Type to be used for the 'const' values. Defaults to 'string'.
                  "%
                  | optional,
                consts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Const
                  ])
                  | optional,
                cosmosContainerId | String | optional,
                cosmosCustomMapper
                  | Bool
                  | doc m%"
                  Otherwise, by default, a 'Mapper' will be generated.
                  "%
                  | optional,
                cosmosMapperBase | String | optional,
                cosmosModel | String | optional,
                cosmosName
                  | String
                  | doc m%"
                  Defaults to the 'CodeGeneration.CosmosName' configuration property (its default value is 'ICosmosDb').
                  "%
                  | optional,
                cosmosPartitionKey
                  | String
                  | doc m%"
                  The value 'PartitionKey.None' can be specified. Literals will need to be quoted.
                  "%
                  | optional,
                cosmosValueContainer | Bool | optional,
                create | Bool | optional,
                crud | Bool | optional,
                dataCtor
                  | std.enum.TagOrString
                  | [| 'Protected, 'Private, 'Public |]
                  | doc m%"
                  Defaults to 'Public'.
                  "%
                  | optional,
                dataCtorParams
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Each constructor parameter should be formatted as 'Type' + '^' + 'Name'; e.g. 'IConfiguration^Config'. Where the 'Name' portion is not specified it will be inferred. Where the 'Type' matches an already inferred value it will be ignored.
                  "%
                  | optional,
                dataExtensions
                  | Bool
                  | doc m%"
                  This can be overridden using 'Operation.DataExtensions'.
                  "%
                  | optional,
                dataModel
                  | Bool
                  | doc m%"
                  The model will be generated with 'OmitEntityBase = true'. Any reference data properties will be defined using their 'RefDataType' intrinsic 'Type' versus their corresponding (actual) reference data 'Type'.
                  "%
                  | optional,
                dataSvcCaching
                  | Bool
                  | doc m%"
                  Defaults to 'true'.
                  "%
                  | optional,
                dataSvcCtor
                  | std.enum.TagOrString
                  | [| 'Protected, 'Private, 'Public |]
                  | doc m%"
                  Defaults to 'Public'.
                  "%
                  | optional,
                dataSvcCtorParams
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Each constructor parameter should be formatted as 'Type' + '^' + 'Name'; e.g. 'IConfiguration^Config'. Where the 'Name' portion is not specified it will be inferred. Where the 'Type' matches an already inferred value it will be ignored.
                  "%
                  | optional,
                dataSvcExtensions
                  | Bool
                  | doc m%"
                  This can be overridden using 'Operation.DataSvcExtensions'.
                  "%
                  | optional,
                databaseCustomerMapper
                  | Bool
                  | doc m%"
                  Otherwise, by default, a 'Mapper' will be generated.
                  "%
                  | optional,
                databaseMapperInheritsFrom | String | optional,
                databaseName
                  | String
                  | doc m%"
                  Defaults to the 'CodeGeneration.DatabaseName' configuration property (its default value is 'IDatabase').
                  "%
                  | optional,
                databaseSchema
                  | String
                  | doc m%"
                  Defaults to 'dbo'.
                  "%
                  | optional,
                delete | Bool | optional,
                entityFrameworkCustomMapper
                  | Bool
                  | doc m%"
                  Otherwise, by default, a 'Mapper' will be generated.
                  "%
                  | optional,
                entityFrameworkMapperBase | String | optional,
                entityFrameworkModel | String | optional,
                entityFrameworkName
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.EntityFrameworkName'.
                  "%
                  | optional,
                eventPublish
                  | std.enum.TagOrString
                  | [| 'Data, 'DataSvc, 'None |]
                  | doc m%"
                  Defaults to the 'CodeGeneration.EventPublish' configuration property (inherits) where not specified. Used to enable the sending of messages to the likes of EventGrid, Service Broker, SignalR, etc. This can be overridden within the 'Operation'(s).
                  "%
                  | optional,
                eventSource
                  | String
                  | doc m%"
                  Defaults to 'Name' (as lowercase) appended with the '/{$key}' placeholder. Note: when used in code-generation the 'CodeGeneration.EventSourceRoot' will be prepended where specified. To include the entity id/key include a '{$key}' placeholder ('Create', 'Update' or 'Delete' operation only); for example: 'person/{$key}'. This can be overridden for the 'Operation'.
                  "%
                  | optional,
                eventTransaction
                  | Bool
                  | doc m%"
                  Usage will force a rollback of any underlying data transaction (where the provider supports TransactionScope) on failure, such as an 'EventPublish' error. This is by no means implying a Distributed Transaction (DTC) should be invoked; this is only intended for a single data source that supports a TransactionScope to guarantee reliable event publishing. Defaults to 'CodeGeneration.EventTransaction'. This essentially defaults the 'Operation.DataSvcTransaction' where not otherwise specified. This should only be used where a transactionally-aware data source is being used.
                  "%
                  | optional,
                excludeAll
                  | Bool
                  | doc m%"
                  Is a shorthand means for setting all of the other 'Exclude*' properties (with the exception of 'ExcludeEntity') to exclude.
                  "%
                  | optional,
                excludeData
                  | std.enum.TagOrString
                  | [| 'RequiresMapper, 'Exclude, 'Include |]
                  | doc m%"
                  Defaults to 'Include' indicating _not_ to exlude. A value of 'Exclude' indicates to exclude all output; alternatively, 'RequiresMapper' indicates to at least output the corresponding 'Mapper' class.
                  "%
                  | optional,
                excludeDataSvc | Bool | optional,
                excludeEntity | Bool | optional,
                excludeGrpcAgent | Bool | optional,
                excludeIData | Bool | optional,
                excludeIDataSvc | Bool | optional,
                excludeIManager | Bool | optional,
                excludeManager | Bool | optional,
                excludeWebApi | Bool | optional,
                excludeWebApiAgent | Bool | optional,
                fileName
                  | String
                  | doc m%"
                  Overrides the Name as the code-generated file name.
                  "%
                  | optional,
                genericWithT | Bool | optional,
                get | Bool | optional,
                getAll | Bool | optional,
                grpc
                  | Bool
                  | doc m%"
                  gRPC support is an explicit opt-in model (see 'CodeGeneration.Grpc' configuration); therefore, each corresponding 'Property' and 'Operation' will also need to be opted-in specifically.
                  "%
                  | optional,
                httpAgentCode
                  | String
                  | doc m%"
                  Prepended to 'Operation.HttpAgentCode' where specified to enable standardized functionality.
                  "%
                  | optional,
                httpAgentMapperBase | String | optional,
                httpAgentModel
                  | String
                  | doc m%"
                  This can be overridden within the 'Operation'(s).
                  "%
                  | optional,
                httpAgentName
                  | String
                  | doc m%"
                  Defaults to 'CodeGeneration.HttpAgentName' configuration property (its default value is 'IHttpAgent').
                  "%
                  | optional,
                httpAgentReturnModel
                  | String
                  | doc m%"
                  This can be overridden within the 'Operation'(s).
                  "%
                  | optional,
                httpAgentRoutePrefix
                  | String
                  | doc m%"
                  This is the base (prefix) 'URI' for the HTTP Agent endpoint and can be further extended when defining the underlying 'Operation'(s).
                  "%
                  | optional,
                identifierGenerator | Bool | optional,
                implements | String | optional,
                implementsAutoInfer
                  | Bool
                  | doc m%"
                  Will attempt to infer the following: 'IIdentifier<Guid>', 'IIdentifier<int>', 'IIdentifier<long>', 'IIdentifier<string>', 'IETag' and 'IChangeLog'. Defaults to 'true'.
                  "%
                  | optional,
                inherits
                  | String
                  | doc m%"
                  Defaults to 'EntityBase' for a standard entity. For Reference Data it will default to 'ReferenceDataBaseEx<xxx>' depending on the corresponding 'RefDataType' value. See 'OmitEntityBase' if the desired outcome is to not inherit from any of the aforementioned base classes.
                  "%
                  | optional,
                internalOnly | Bool | optional,
                isInitialOverride
                  | Bool
                  | doc m%"
                  Set to either 'true' or 'false' to override as specified; otherwise, 'null' to check each property. Defaults to 'null'.
                  "%
                  | optional,
                jsonSerializer
                  | std.enum.TagOrString
                  | [| 'Newtonsoft, 'SystemText |]
                  | doc m%"
                  Defaults to the 'CodeGeneration.JsonSerializer' configuration property where specified; otherwise, 'SystemText'.
                  "%
                  | optional,
                managerCleanUp
                  | Bool
                  | doc m%"
                  This can be overridden within the 'CodeGeneration' and 'Operation'(s).
                  "%
                  | optional,
                managerCtor
                  | std.enum.TagOrString
                  | [| 'Protected, 'Private, 'Public |]
                  | doc m%"
                  Defaults to 'Public'.
                  "%
                  | optional,
                managerCtorParams
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Each constructor parameter should be formatted as 'Type' + '^' + 'Name'; e.g. 'IConfiguration^Config'. Where the 'Name' portion is not specified it will be inferred. Where the 'Type' matches an already inferred value it will be ignored.
                  "%
                  | optional,
                managerExtensions
                  | Bool
                  | doc m%"
                  This can be overridden using 'Operation.ManagerExtensions'.
                  "%
                  | optional,
                name | String,
                namespace
                  | String
                  | doc m%"
                  Appended to the end of the standard structure as follows: '{Company}.{AppName}.Business.Entities.{Namespace}'.
                  "%
                  | optional,
                odataCollectionName
                  | String
                  | doc m%"
                  The underlying 'Simple.OData.Client' will attempt to infer.
                  "%
                  | optional,
                odataCustomMapper
                  | Bool
                  | doc m%"
                  Otherwise, by default, a 'Mapper' will be generated.
                  "%
                  | optional,
                odataModel | String | optional,
                odataName
                  | String
                  | doc m%"
                  Defaults to the 'CodeGeneration.ODataName' configuration property (its default value is 'IOData').
                  "%
                  | optional,
                omitEntityBase
                  | Bool
                  | doc m%"
                  As such any of the 'EntityBase' related capabilites are not supported (are omitted from generation). The intention for this is more for the generation of simple internal entities.
                  "%
                  | optional,
                operations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Operation
                  ])
                  | optional,
                patch | Bool | optional,
                privateName
                  | String
                  | doc m%"
                  Overrides the 'Name' to be used for private fields. By default reformatted from 'Name'; e.g. 'FirstName' as '_firstName'.
                  "%
                  | optional,
                properties
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Property
                  ])
                  | optional,
                refDataCodeDataName
                  | String
                  | doc m%"
                  Defaults to 'Code' (literal).
                  "%
                  | optional,
                refDataETagDataName
                  | String
                  | doc m%"
                  Defaults to 'RowVersion' (literal).
                  "%
                  | optional,
                refDataIdDataName
                  | String
                  | doc m%"
                  Defaults to 'Name' + 'Id' (literal).
                  "%
                  | optional,
                refDataIsActiveDataName
                  | String
                  | doc m%"
                  Defaults to 'IsActive' (literal).
                  "%
                  | optional,
                refDataSortOrder
                  | std.enum.TagOrString
                  | [| 'Text, 'Code, 'Id, 'SortOrder |]
                  | doc m%"
                  Specifies the default sort order for the underlying Reference Data collection. Defaults to 'SortOrder'.
                  "%
                  | optional,
                refDataSortOrderDataName
                  | String
                  | doc m%"
                  Defaults to 'SortOrder' (literal).
                  "%
                  | optional,
                refDataStoredProcedureName
                  | String
                  | doc m%"
                  Defaults to 'sp' (literal) + 'Name' + 'GetAll' (literal).
                  "%
                  | optional,
                refDataText
                  | Bool
                  | doc m%"
                  This is used where serializing within the Web API'Controller' and the 'ExecutionContext.IsRefDataTextSerializationEnabled' is set to 'true' (which is automatically set where the url contains '$text=true'). Defaults from 'CodeGeneration.RefDataText'.
                  "%
                  | optional,
                refDataTextDataName
                  | String
                  | doc m%"
                  Defaults to 'Text' (literal).
                  "%
                  | optional,
                refDataType
                  | std.enum.TagOrString
                  | [| 'string, 'Guid, 'long, 'int |]
                  | doc m%"
                  Required to identify an entity as being Reference Data. Specifies the underlying .NET Type used for the Reference Data identifier.
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  Overrides the Name (as sentence text) for the summary comments. It will be formatted as: 'Represents the {Text} entity.'. To create a '<see cref="XXX"/>' within use moustache shorthand (e.g. {{Xxx}}).
                  "%
                  | optional,
                update | Bool | optional,
                validationFramework
                  | std.enum.TagOrString
                  | [| 'FluentValidation, 'CoreEx |]
                  | doc m%"
                  Defaults to 'CodeGeneration.ValidationFramework'. This can be overridden within the 'Operation'(s) and 'Parameter'(s).
                  "%
                  | optional,
                validator
                  | String
                  | doc m%"
                  Only used for defaulting the 'Create' and 'Update' operation types ('Operation.Type') where not specified explicitly.
                  "%
                  | optional,
                webApiAuthorize
                  | String
                  | doc m%"
                  Defaults to the 'CodeGeneration.WebApiAuthorize' configuration property (inherits) where not specified; can be overridden at the 'Operation' level also.
                  "%
                  | optional,
                webApiAutoLocation
                  | Bool
                  | doc m%"
                  This will automatically set the 'Operation.WebApiLocation' for an 'Operation' named 'Create' where there is a corresponding named 'Get'. This is defaulted from the 'CodeGen.WebApiAutoLocation'.
                  "%
                  | optional,
                webApiConcurrency
                  | Bool
                  | doc m%"
                  This provides an alternative where the underlying data source does not natively support optimistic concurrency (native support should always be leveraged as a priority). Where the 'Operation.Type' is 'Update' or 'Patch', the request ETag will be matched against the response for a corresponding 'Get' operation to verify no changes have been made prior to updating. For this to function correctly the .NET response Type for the 'Get' must be the same as that returned from the corresponding 'Create', 'Update' and 'Patch' (where applicable) as the generated ETag is a SHA256 hash of the resulting JSON. This defaults the 'Operation.WebApiConcurrency'.
                  "%
                  | optional,
                webApiCtor
                  | std.enum.TagOrString
                  | [| 'Protected, 'Private, 'Public |]
                  | doc m%"
                  Defaults to 'Public'.
                  "%
                  | optional,
                webApiCtorParams
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Each constructor parameter should be formatted as 'Type' + '^' + 'Name'; e.g. 'IConfiguration^Config'. Where the 'Name' portion is not specified it will be inferred. Where the 'Type' matches an already inferred value it will be ignored.
                  "%
                  | optional,
                webApiGetOperation
                  | String
                  | doc m%"
                  Defaults to 'Get'. Specify either just the method name (e.g. 'OperationName') or, interface and method name (e.g. 'IXxxManager.OperationName') to be invoked where in a different 'YyyManager.OperationName'.
                  "%
                  | optional,
                webApiRoutePrefix
                  | String
                  | doc m%"
                  This is the base (prefix) 'URI' for the entity and can be further extended when defining the underlying 'Operation'(s). The 'CodeGeneration.WebApiRoutePrefix' will be prepended where specified. Where 'RefDataType' is specified (indicating Reference Data entity) then this will automatically default to the pluralized 'Name' (as lowercase).
                  "%
                  | optional,
                withResult
                  | Bool
                  | doc m%"
                  Defaults to 'CodeGeneration.WithResult'. This can be overridden within the Operation'(s).
                  "%
                  | optional,
                ..
              },
          Operation
            | doc m%"
            The code generation for an 'Operation' is primarily driven by the 'Type' property. This encourages (enforces) a consistent implementation for the standardised **CRUD** (Create, Read, Update and Delete) actions, as well as supporting fully customised operations as required.
            "%
            = {
                authPermission | String | optional,
                authRole | String | optional,
                autoImplement
                  | std.enum.TagOrString
                  | [|
                    'None,
                    'HttpAgent,
                    'OData,
                    'Cosmos,
                    'EntityFramework,
                    'Database
                  |]
                  | doc m%"
                  Defaults to 'Entity.AutoImplement'. The corresponding 'Entity.AutoImplement' must be defined for this to be enacted. Auto-implementation is applicable for all 'Operation.Type' options with the exception of 'Custom'.
                  "%
                  | optional,
                cosmosContainerId
                  | String
                  | doc m%"
                  Overrides the 'Entity.CosmosContainerId'.
                  "%
                  | optional,
                cosmosModel
                  | String
                  | doc m%"
                  Overrides the 'Entity.CosmosModel'.
                  "%
                  | optional,
                cosmosPartitionKey
                  | String
                  | doc m%"
                  Overrides the 'Entity.CosmosPartitionKey'.
                  "%
                  | optional,
                dataEntityMapper
                  | String
                  | doc m%"
                  Used where the default generated 'Mapper' is not applicable.
                  "%
                  | optional,
                dataExtensions
                  | Bool
                  | doc m%"
                  Defaults to 'Entity.DataExtensions'.
                  "%
                  | optional,
                dataInvoker
                  | Bool
                  | doc m%"
                  Where 'Dataransaction' or 'EventPublish' is 'Data' then orchestration will default to 'true'.
                  "%
                  | optional,
                dataSvcCustom | Bool | optional,
                dataSvcExtensions
                  | Bool
                  | doc m%"
                  Defaults to 'Entity.ManagerExtensions'.
                  "%
                  | optional,
                dataSvcInvoker
                  | Bool
                  | doc m%"
                  Where 'DataSvcTransaction' or 'EventPublish' is 'DataSvc' then orchestration will default to 'true'.
                  "%
                  | optional,
                dataSvcTransaction | Bool | optional,
                dataTransaction
                  | Bool
                  | doc m%"
                  Where using an 'EventOutbox' this is ignored as it is implied through its usage.
                  "%
                  | optional,
                databaseStoredProc
                  | String
                  | doc m%"
                  Defaults to 'sp' + 'Entity.Name' + 'Operation.Name'; e.g. 'spPersonCreate'.
                  "%
                  | optional,
                entityFrameworkModel
                  | String
                  | doc m%"
                  Overrides the 'Entity.EntityFrameworkModel'.
                  "%
                  | optional,
                eventPublish
                  | std.enum.TagOrString
                  | [| 'Data, 'DataSvc, 'None |]
                  | doc m%"
                  Defaults to the 'Entity.EventPublish' configuration property (inherits) where not specified. Used to enable the sending of messages to the likes of EventGrid, Service Broker, SignalR, etc.
                  "%
                  | optional,
                eventSource
                  | String
                  | doc m%"
                  Defaults to 'Entity.EventSource'. Note: when used in code-generation the 'CodeGeneration.EventSourceRoot' will be prepended where specified. To include the entity id/key include a '{$key}' placeholder ('Create', 'Update' or 'Delete' operation only); for example: 'person/{$key}'. Otherwise, specify the C# string interpolation expression; for example: 'person/{r.Id}'.
                  "%
                  | optional,
                eventSubject
                  | String
                  | doc m%"
                  The event subject template defaults to '{AppName}.{Entity.Name}', plus each of the unique key placeholders comma separated; e.g. 'Domain.Entity.{id1},{id2}' (depending on whether 'Entity.EventSubjectFormat' is 'NameAndKey' or 'NameOnly'). The event action defaults to 'WebApiOperationType' or 'Operation.Type' where not specified. Multiple events can be raised by specifying more than one subject/action pair separated by a semicolon. E.g. 'Demo.Person.{id}:Create;Demo.Other.{id}:Update'.
                  "%
                  | optional,
                excludeAll
                  | Bool
                  | doc m%"
                  Is a shorthand means for setting all of the other 'Exclude*' properties to 'true'.
                  "%
                  | optional,
                excludeData | Bool | optional,
                excludeDataSvc | Bool | optional,
                excludeGrpcAgent | Bool | optional,
                excludeIData | Bool | optional,
                excludeIDataSvc | Bool | optional,
                excludeIManager | Bool | optional,
                excludeManager | Bool | optional,
                excludeWebApi | Bool | optional,
                excludeWebApiAgent | Bool | optional,
                grpc
                  | Bool
                  | doc m%"
                  gRPC support is an explicit opt-in model (see 'CodeGeneration.Grpc' configuration); therefore, each corresponding 'Entity', 'Property' and 'Operation' will also need to be opted-in specifically.
                  "%
                  | optional,
                httpAgentCode
                  | String
                  | doc m%"
                  Appended to 'Entity.HttpAgentCode' where specified to extend.
                  "%
                  | optional,
                httpAgentMethod
                  | std.enum.TagOrString
                  | [| 'HttpPatch, 'HttpDelete, 'HttpPut, 'HttpPost, 'HttpGet |]
                  | doc m%"
                  Defaults to 'Operation.WebApiMethod'.
                  "%
                  | optional,
                httpAgentModel
                  | String
                  | doc m%"
                  This can be overridden within the 'Operation'(s).
                  "%
                  | optional,
                httpAgentReturnModel
                  | String
                  | doc m%"
                  Defaults to 'Operation.HttpAgentModel' where the 'Operation.ReturnType' is equal to 'Entity.Name' (same type). This can be overridden within the 'Operation'(s).
                  "%
                  | optional,
                httpAgentRoute
                  | String
                  | doc m%"
                  This is appended to the 'Entity.HttpAgentRoutePrefix'.
                  "%
                  | optional,
                managerCleanUp
                  | Bool
                  | doc m%"
                  This can be overridden within the 'CodeGeneration' and 'Entity'.
                  "%
                  | optional,
                managerCustom | Bool | optional,
                managerExtensions
                  | Bool
                  | doc m%"
                  Defaults to 'Entity.ManagerExtensions'.
                  "%
                  | optional,
                managerOperationType
                  | std.enum.TagOrString
                  | [| 'Unspecified, 'Delete, 'Update, 'Read, 'Create |]
                  | doc m%"
                  The default will be inferred from the 'Operation.Type'; however, where the 'Operation.Type' is 'Custom' it will default to 'Unspecified'.
                  "%
                  | optional,
                managerTransaction | Bool | optional,
                name | String,
                odataCollectionName
                  | String
                  | doc m%"
                  Overriddes the 'Entity.ODataCollectionName'; otherwise, the underlying 'Simple.OData.Client' will attempt to infer.
                  "%
                  | optional,
                paging | Bool | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Parameter
                  ])
                  | optional,
                primaryKey
                  | Bool
                  | doc m%"
                  This simplifies the specification of these properties versus having to declare each specifically.
                  "%
                  | optional,
                privateName
                  | String
                  | doc m%"
                  Overrides the 'Name' to be used for private usage. By default reformatted from 'Name'; e.g. 'GetByArgs' as '_getByArgs'.
                  "%
                  | optional,
                returnText
                  | String
                  | doc m%"
                  A default will be created where not specified. To create a '<see cref="XXX"/>' within use moustache shorthand (e.g. {{Xxx}}).
                  "%
                  | optional,
                returnType
                  | String
                  | doc m%"
                  Defaults to the parent 'Entity.Name' where the 'Operation.Type' options are 'Get', 'GetColl', 'Create' or 'Update'; otherwise, defaults to 'void'.
                  "%
                  | optional,
                returnTypeNullable
                  | Bool
                  | doc m%"
                  This is only applicable for an 'Operation.Type' of 'Custom'. Will be inferred where the 'ReturnType' is denoted as nullable; i.e. suffixed by a '?'.
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  The 'Text' will be defaulted for all the 'Operation.Type' options with the exception of 'Custom'. To create a '<see cref="XXX"/>' within use moustache shorthand (e.g. {{Xxx}}).
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [|
                    'Custom,
                    'Delete,
                    'Patch,
                    'Update,
                    'Create,
                    'GetColl,
                    'Get
                  |]
                  | doc m%"
                  Defaults to 'Custom'.
                  "%
                  | optional,
                validationFramework
                  | std.enum.TagOrString
                  | [| 'FluentValidation, 'CoreEx |]
                  | doc m%"
                  Defaults to 'Entity.ValidationFramework'. This can be overridden within the 'Parameter'(s).
                  "%
                  | optional,
                validator
                  | String
                  | doc m%"
                  Defaults to the 'Entity.Validator' where not specified explicitly (where 'Operation.Type' options 'Create' or 'Update').
                  "%
                  | optional,
                valueType
                  | String
                  | doc m%"
                  Defaults to the parent 'Entity.Name' where the 'Operation.Type' options are 'Create' or 'Update'.
                  "%
                  | optional,
                webApiAlternateStatus
                  | std.enum.TagOrString
                  | [| 'NotFound, 'NoContent, 'Created, 'Accepted, 'OK |]
                  | doc m%"
                  The value defaults as follows: 'NotFound' for 'Operation.Type' value 'Get' and 'NoContent' for 'Operation.Type' value 'GetColl'; otherwise, 'null'.
                  "%
                  | optional,
                webApiAuthorize
                  | String
                  | doc m%"
                  Where not specified no attribute output will occur; it will then inherit as supported by .NET.
                  "%
                  | optional,
                webApiConcurrency
                  | Bool
                  | doc m%"
                  This provides an alternative where the underlying data source does not natively support optimistic concurrency (native support should always be leveraged as a priority). Where the 'Operation.Type' is 'Update' or 'Patch', the request ETag will be matched against the response for a corresponding 'Get' operation to verify no changes have been made prior to updating. For this to function correctly the .NET response Type for the 'Get' must be the same as that returned from the corresponding 'Create', 'Update' and 'Patch' (where applicable) as the generated ETag is a SHA256 hash of the resulting JSON. Defaults to 'Entity.WebApiConcurrency'.
                  "%
                  | optional,
                webApiGetOperation
                  | String
                  | doc m%"
                  Defaults to 'Get'. Specify either just the method name (e.g. 'OperationName') or, interface and method name (e.g. 'IXxxManager.OperationName') to be invoked where in a different 'YyyManager.OperationName'.
                  "%
                  | optional,
                webApiLocation
                  | String
                  | doc m%"
                  This uses similar formatting to the 'WebApiRoute'. The response value is accessed using 'r.' notation to access underlying properties; for example '{r.Id}' or 'person/{r.Id}'. The 'Entity.WebApiRoutePrefix' will be prepended automatically; however, to disable set the first character to '!', e.g. '!person/{r.Id}'. The URI can be inferred from another 'Operation' by using a lookup '^'; for example '^Get' indicates to infer from the named 'Get' operation (where only '^' is specified this is shorthand for '^Get' as this is the most common value). The Location URI will ensure the first character is a '/' so it acts a 'relative URL absolute path'.
                  "%
                  | optional,
                webApiMethod
                  | std.enum.TagOrString
                  | [| 'HttpDelete, 'HttpPut, 'HttpPost, 'HttpGet |]
                  | doc m%"
                  The value defaults as follows: 'HttpGet' for 'Operation.Type' value 'Get' or 'GetColl', 'HttpPost' for 'Operation.Type' value 'Create' or 'Custom', 'HttpPut' for 'Operation.Type' value 'Update', and 'HttpDelete' for 'Operation.Type' value 'Delete'. An 'Operation.Type' value 'Patch' can not be specified and will always default to 'HttpPatch'.
                  "%
                  | optional,
                webApiRoute | String | optional,
                webApiStatus
                  | std.enum.TagOrString
                  | [| 'NotFound, 'NoContent, 'Created, 'Accepted, 'OK |]
                  | doc m%"
                  The value defaults as follows: 'OK' for 'Operation.Type' value 'Get', 'GetColl', 'Update', 'Delete' or 'Custom', 'Created' for 'Operation.Type' value 'Create'.
                  "%
                  | optional,
                webApiUpdateOperation
                  | String
                  | doc m%"
                  Defaults to 'Update'. Specify either just the method name (e.g. 'OperationName') or, interface and method name (e.g. 'IXxxManager.OperationName') to be invoked where in a different 'YyyManager.OperationName'.
                  "%
                  | optional,
                withResult
                  | Bool
                  | doc m%"
                  Defaults to 'Entity.WilhResult'.
                  "%
                  | optional,
                ..
              },
          Parameter
            | doc m%"
            The 'Parameter' object defines an 'Operation' parameter and its charateristics.
            "%
            = {
                argumentName
                  | String
                  | doc m%"
                  Overrides the 'Name' to be used for argument parameters. By default reformatted from 'Name'; e.g. 'FirstName' as 'firstName'.
                  "%
                  | optional,
                dataConverter
                  | String
                  | doc m%"
                  A 'Converter' is used to convert a data source value to/from a .NET 'Type' where no standard data conversion can be applied. Where this value is suffixed by '<T>' or '{T}' this will automatically set 'Type'.
                  "%
                  | optional,
                "default"
                  | String
                  | doc m%"
                  Where the 'Type' is 'string' then the specified default value will need to be delimited. Any valid value assignment C# code can be used.
                  "%
                  | optional,
                grpcType | String | optional,
                isMandatory | Bool | optional,
                layerPassing
                  | std.enum.TagOrString
                  | [| 'ToManagerCollSet, 'ToManagerSet, 'All |]
                  | doc m%"
                  Defaults to 'All'. To further describe, 'All' passes the parameter through all layeys, 'ToManagerSet' only passes the parameter to the 'Manager' layer and overrides the same named property within the corresponding 'value' parameter, 'ToManagerCollSet' only passes the parameter to the 'Manager' layer and overrides the same named property within the corresponding 'value' collection parameter. Where using the 'PrimaryKey' option to automatically set 'Parameters', and the 'Operation.Type' is 'Create' or 'Update' it will default to 'ToManagerSet'.
                  "%
                  | optional,
                name | String,
                nullable | Bool | optional,
                privateName
                  | String
                  | doc m%"
                  Overrides the 'Name' to be used for private fields. By default reformatted from 'Name'; e.g. 'FirstName' as '_firstName'.
                  "%
                  | optional,
                property | String | optional,
                refDataList
                  | Bool
                  | doc m%"
                  This is required to enable a list of Reference Data values (as per 'RefDataType') to be passed as an argument for example.
                  "%
                  | optional,
                refDataType
                  | std.enum.TagOrString
                  | [| 'Guid, 'int, 'string |]
                  | doc m%"
                  Defaults to 'string' where not specified and the corresponding 'Type' starts with (prefix) 'RefDataNamespace.'.
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  By default the 'Text' will be the 'Name' reformatted as sentence casing.
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  Defaults to 'string'. To reference a Reference Data 'Type' always prefix with 'RefDataNamespace' (e.g. 'RefDataNamespace.Gender') or shortcut '^' (e.g. '^Gender'). This will ensure that the appropriate Reference Data 'using' statement is used. _Shortcut:_ Where the 'Type' starts with (prefix) 'RefDataNamespace.' or '^', and the correspondong 'RefDataType' attribute is not specified it will automatically default the 'RefDataType' to 'string.'
                  "%
                  | optional,
                validationFramework
                  | std.enum.TagOrString
                  | [| 'FluentValidation, 'CoreEx |]
                  | doc m%"
                  Defaults to 'Operation.ValidationFramework'.
                  "%
                  | optional,
                validator | String | optional,
                validatorCode | String | optional,
                webApiFrom
                  | std.enum.TagOrString
                  | [|
                    'FromEntityProperties,
                    'FromRoute,
                    'FromBody,
                    'FromQuery
                  |]
                  | doc m%"
                  Defaults to 'FromQuery'; unless the parameter 'Type' has also been defined as an 'Entity' within the code-gen config file then it will default to 'FromEntityProperties'. Specifies that the parameter will be declared with corresponding 'FromQueryAttribute', 'FromBodyAttribute' or 'FromRouteAttribute' for the Web API method. The 'FromEntityProperties' will declare all properties of the 'Entity' as query parameters.
                  "%
                  | optional,
                webApiText
                  | String
                  | doc m%"
                  By default the 'Text' will be the 'Name' reformatted as sentence casing.
                  "%
                  | optional,
                ..
              },
          Property
            | doc m%"
            The 'Property' object defines an 'Entity' property and its charateristics.
            "%
            = {
                annotation1 | String | optional,
                annotation2 | String | optional,
                annotation3 | String | optional,
                argumentName
                  | String
                  | doc m%"
                  Overrides the 'Name' to be used for argument parameters. By default reformatted from 'Name'; e.g. 'FirstName' as 'firstName'.
                  "%
                  | optional,
                autoCreate | Bool | optional,
                cosmosMapper
                  | std.enum.TagOrString
                  | [| 'Flatten, 'Map, 'Ignore, 'Set |]
                  | doc m%"
                  Defaults to 'Set'.
                  "%
                  | optional,
                dataAutoGenerated | Bool | optional,
                dataConverter
                  | String
                  | doc m%"
                  A 'Converter' is used to convert a data source value to/from a .NET 'Type' where no standard data conversion can be applied. Where this value is suffixed by '<T>' or '{T}' this will automatically set 'Type'.
                  "%
                  | optional,
                dataMapperIgnore
                  | Bool
                  | doc m%"
                  All properties are included by default.
                  "%
                  | optional,
                dataModelIgnore
                  | Bool
                  | doc m%"
                  All properties are included in the data model by default.
                  "%
                  | optional,
                dataModelSerializationIgnore
                  | Bool
                  | doc m%"
                  All properties are included in the data model by default.
                  "%
                  | optional,
                dataName
                  | String
                  | doc m%"
                  Defaults to the property 'Name'. Represents the column name for a 'Database', or the correspinding property name for the other options.
                  "%
                  | optional,
                dataOperationTypes
                  | std.enum.TagOrString
                  | [|
                    'Delete,
                    'Update,
                    'Create,
                    'Get,
                    'AnyExceptGet,
                    'AnyExceptUpdate,
                    'AnyExceptCreate,
                    'Any
                  |]
                  | doc m%"
                  Defaults to 'Any'.
                  "%
                  | optional,
                databaseDbType
                  | String
                  | doc m%"
                  Overrides the inferred database type; i.e. can specify 'Date' or 'DateTime2', for .NET Type 'System.DateTime'.
                  "%
                  | optional,
                databaseIgnore | Bool | optional,
                databaseMapper
                  | String
                  | doc m%"
                  A 'Mapper' is used to map a data source value to/from a .NET complex 'Type' (i.e. class with one or more properties).
                  "%
                  | optional,
                dateTimeTransform
                  | std.enum.TagOrString
                  | [|
                    'DateTimeUnspecified,
                    'DateTimeUtc,
                    'DateTimeLocal,
                    'DateOnly,
                    'None,
                    'UseDefault
                  |]
                  | doc m%"
                  Defaults to 'UseDefault'. This is only applied where the 'Type' is 'DateTime'.
                  "%
                  | optional,
                "default"
                  | String
                  | doc m%"
                  Where the 'Type' is 'string' then the specified default value will need to be delimited. Any valid value assignment C# code can be used.
                  "%
                  | optional,
                displayName
                  | String
                  | doc m%"
                  Defaults to the 'Name' as sentence case.
                  "%
                  | optional,
                entityFrameworkMapper
                  | std.enum.TagOrString
                  | [| 'Flatten, 'Map, 'Ignore, 'Set |]
                  | doc m%"
                  Defaults to 'Set'.
                  "%
                  | optional,
                grpcFieldNo | std.number.Integer | optional,
                grpcType | String | optional,
                httpAgentMapper
                  | std.enum.TagOrString
                  | [| 'Flatten, 'Map, 'Ignore, 'Set |]
                  | doc m%"
                  Defaults to 'Set'.
                  "%
                  | optional,
                immutable | Bool | optional,
                inherited | Bool | optional,
                internalOnly
                  | Bool
                  | doc m%"
                  In this instance the 'Property' will be excluded from the 'Common' entity declaration and 'Business' JSON serialization.
                  "%
                  | optional,
                isEntity
                  | Bool
                  | doc m%"
                  Will be inferred (default to 'true') where the 'Type' is 'ChangeLog' or the 'Type' is found as another 'Entity' within the code-generation configuration file.
                  "%
                  | optional,
                jsonDataModelName
                  | String
                  | doc m%"
                  Defaults to 'JsonName' where not specified.
                  "%
                  | optional,
                jsonName
                  | String
                  | doc m%"
                  Defaults to 'ArgumentName' where not specified (i.e. camelCase); however, where the property is 'ETag' it will default to the 'Config.ETagJsonName'.
                  "%
                  | optional,
                modelText
                  | String
                  | doc m%"
                  By default the 'ModelText' will be the 'Name' reformatted as sentence casing. Depending on whether the 'Type' is 'bool', will appear in one of the two generated sentences. Where not 'bool' it will be: Gets or sets a value indicating whether {text}.'. Otherwise, it will be: Gets or sets the {text}.'. To create a '<see cref="XXX"/>' within use moustache shorthand (e.g. {{Xxx}}).
                  "%
                  | optional,
                name | String,
                nullable | Bool | optional,
                odataMapper
                  | std.enum.TagOrString
                  | [| 'Skip, 'Ignore, 'Map |]
                  | doc m%"
                  Defaults to 'Map' which indicates the property will be explicitly mapped. A value of 'Ignore' will explicitly 'Ignore', whilst a value of 'Skip' will skip code-generated mapping altogether.
                  "%
                  | optional,
                partitionKey
                  | Bool
                  | doc m%"
                  This will implement 'IPartitionKey' for the generated entity.
                  "%
                  | optional,
                primaryKey
                  | Bool
                  | doc m%"
                  This is also used to simplify the parameter specification for an Entity Operation by inferrence.
                  "%
                  | optional,
                privateName
                  | String
                  | doc m%"
                  Overrides the 'Name' to be used for private fields. By default reformatted from 'Name'; e.g. 'FirstName' as '_firstName'.
                  "%
                  | optional,
                refDataList
                  | Bool
                  | doc m%"
                  This is required to enable a list of Reference Data values (as per 'RefDataType') to be passed as an argument for example.
                  "%
                  | optional,
                refDataMapping
                  | Bool
                  | doc m%"
                  Mapped properties are a special Reference Data property type that ensure value uniqueness; this allows the likes of additional to/from mappings to occur between systems where applicable.
                  "%
                  | optional,
                refDataText
                  | std.enum.TagOrString
                  | [| 'Never, 'Always, 'Optional |]
                  | doc m%"
                  This is used where serializing within the Web API 'Controller' and the 'ExecutionContext.IsRefDataTextSerializationEnabled' is set to 'true' (which is automatically set where the url contains '$text=true').'Optional' indicates when 'ExecutionContext.IsRefDataTextSerializationEnabled' is set to 'true' then a value is output, 'Always' indicates that the value is _always_ output, and 'Never' indicates that feature is turned off.
                  "%
                  | optional,
                refDataTextName | String | optional,
                refDataType
                  | std.enum.TagOrString
                  | [| 'Guid, 'int, 'string |]
                  | doc m%"
                  Defaults to 'string' (being the 'ReferenceDataBase.Code') where not specified and the corresponding 'Type' starts with (prefix) 'RefDataNamespace.' or '^'. Note: an 'Id' of type 'string' is currently not supported; the use of the 'Code' is the recommended approach.
                  "%
                  | optional,
                serializationAlwaysInclude | Bool | optional,
                serializationIgnore
                  | Bool
                  | doc m%"
                  All properties are serialized by default.
                  "%
                  | optional,
                stringCasing
                  | std.enum.TagOrString
                  | [| 'Title, 'Upper, 'Lower, 'None, 'UseDefault |]
                  | doc m%"
                  Defaults to 'UseDefault'. This is only applied where the 'Type' is 'string'.
                  "%
                  | optional,
                stringTransform
                  | std.enum.TagOrString
                  | [| 'EmptyToNull, 'NullToEmpty, 'None, 'UseDefault |]
                  | doc m%"
                  Defaults to 'UseDefault'. This is only applied where the 'Type' is 'string'.
                  "%
                  | optional,
                stringTrim
                  | std.enum.TagOrString
                  | [| 'Both, 'End, 'Start, 'None, 'UseDefault |]
                  | doc m%"
                  Defaults to 'UseDefault'. This is only applied where the 'Type' is 'string'.
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  By default the 'Text' will be the 'Name' reformatted as sentence casing. Depending on whether the 'Type' is 'bool', will appear in one of the two generated sentences. Where not 'bool' it will be: Gets or sets a value indicating whether {text}.'. Otherwise, it will be: Gets or sets the {text}.'. To create a '<see cref="XXX"/>' within use moustache shorthand (e.g. {{Xxx}}).
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  Defaults to 'string'. To reference a Reference Data 'Type' always prefix with 'RefDataNamespace' (e.g. 'RefDataNamespace.Gender') or shortcut '^' (e.g. '^Gender'). This will ensure that the appropriate Reference Data 'using' statement is used. _Shortcut:_ Where the 'Type' starts with (prefix) 'RefDataNamespace.' or '^', and the correspondong 'RefDataType' attribute is not specified it will automatically default the 'RefDataType' to 'string.'
                  "%
                  | optional,
                ..
              },
        },
    predicate = {
          CodeGeneration
            | doc m%"
            The 'CodeGeneration' object defines global properties that are used to drive the underlying entity-driven code generation.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  autoImplement = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Database",
                          "EntityFramework",
                          "Cosmos",
                          "OData",
                          "HttpAgent",
                          "None"
                        ]
                      ],
                  cosmosName = predicates.isType '"String",
                  databaseName = predicates.isType '"String",
                  databaseProvider = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "SqlServer", "MySQL" ]
                      ],
                  databaseSchema = predicates.isType '"String",
                  entities = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Entity
                      ],
                  entityFrameworkName = predicates.isType '"String",
                  etagDefaultMapperConverter = predicates.isType '"String",
                  etagJsonName = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "etag", "eTag", "_etag", "_eTag", "ETag", "ETAG" ]
                      ],
                  eventActionFormat = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "None", "PastTense" ]
                      ],
                  eventPublish = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "None", "DataSvc", "Data" ]
                      ],
                  eventSourceKind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "None", "Absolute", "Relative", "RelativeOrAbsolute" ]
                      ],
                  eventSourceRoot = predicates.isType '"String",
                  eventSubjectRoot = predicates.isType '"String",
                  eventSubjectSeparator = predicates.isType '"String",
                  eventTransaction = predicates.isType '"Bool",
                  grpc = predicates.isType '"Bool",
                  httpAgentName = predicates.isType '"String",
                  jsonSerializer = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "SystemText", "Newtonsoft" ]
                      ],
                  managerCleanUp = predicates.isType '"Bool",
                  namespaceApi = predicates.isType '"String",
                  namespaceBase = predicates.isType '"String",
                  namespaceBusiness = predicates.isType '"String",
                  namespaceCommon = predicates.isType '"String",
                  odataName = predicates.isType '"String",
                  pathApi = predicates.isType '"String",
                  pathBase = predicates.isType '"String",
                  pathBusiness = predicates.isType '"String",
                  pathCommon = predicates.isType '"String",
                  preprocessorDirectives = predicates.isType '"Bool",
                  refDataCodeDataName = predicates.isType '"String",
                  refDataCommonNamespace = predicates.isType '"String",
                  refDataDataCtorParams = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  refDataDefaultMapperConverter = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "ReferenceDataCodeConverter",
                          "ReferenceDataCodeConverter{T}",
                          "ReferenceDataCodeConverter<T>",
                          "ReferenceDataIdConverter{T, int}",
                          "ReferenceDataIdConverter<T, int>",
                          "ReferenceDataIdConverter{T, int?}",
                          "ReferenceDataIdConverter<T, int?>",
                          "ReferenceDataIdConverter{T, long}",
                          "ReferenceDataIdConverter<T, long>",
                          "ReferenceDataIdConverter{T, long?}",
                          "ReferenceDataIdConverter<T, long?>",
                          "ReferenceDataIdConverter{T, Guid}",
                          "ReferenceDataIdConverter<T, Guid>",
                          "ReferenceDataIdConverter{T, Guid?}",
                          "ReferenceDataIdConverter<T, Guid?>",
                          "ReferenceDataInt32IdConverter",
                          "ReferenceDataInt32IdConverter{T}",
                          "ReferenceDataInt32IdConverter<T>",
                          "ReferenceDataNullableInt32IdConverter",
                          "ReferenceDataNullableInt32IdConverter{T}",
                          "ReferenceDataNullableInt32IdConverter<T>",
                          "ReferenceDataInt64IdConverter",
                          "ReferenceDataInt64IdConverter{T}",
                          "ReferenceDataInt64IdConverter<T>",
                          "ReferenceDataNullableInt64IdConverter",
                          "ReferenceDataNullableInt64IdConverter{T}",
                          "ReferenceDataNullableInt64IdConverter<T>",
                          "ReferenceDataGuidIdConverter",
                          "ReferenceDataGuidIdConverter{T}",
                          "ReferenceDataGuidIdConverter<T>",
                          "ReferenceDataNullableGuidIdConverter",
                          "ReferenceDataNullableGuidIdConverter{T}",
                          "ReferenceDataNullableGuidIdConverter<T>"
                        ]
                      ],
                  refDataETagDataName = predicates.isType '"String",
                  refDataIsActiveDataName = predicates.isType '"String",
                  refDataNamespace = predicates.isType '"String",
                  refDataSortOrderDataName = predicates.isType '"String",
                  refDataText = predicates.isType '"Bool",
                  refDataTextDataName = predicates.isType '"String",
                  refDataType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "int", "long", "Guid", "string" ]
                      ],
                  refDataWebApiRoute = predicates.isType '"String",
                  usingNamespace1 = predicates.isType '"String",
                  usingNamespace2 = predicates.isType '"String",
                  usingNamespace3 = predicates.isType '"String",
                  validationFramework = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "CoreEx", "FluentValidation" ]
                      ],
                  webApiAuthorize = predicates.isType '"String",
                  webApiAutoLocation = predicates.isType '"Bool",
                  webApiRoutePrefix = predicates.isType '"String",
                  withResult = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          Const
            | doc m%"
            The 'Const' object is used to define a .NET (C#) constant value for an 'Entity'.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "value" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  text = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Entity
            | doc m%"
            The 'Entity' is used as the primary configuration for driving the entity-driven code generation.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  abstract = predicates.isType '"Bool",
                  argumentName = predicates.isType '"String",
                  authRole = predicates.isType '"String",
                  autoImplement = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Database",
                          "EntityFramework",
                          "Cosmos",
                          "OData",
                          "HttpAgent",
                          "None"
                        ]
                      ],
                  collection = predicates.isType '"Bool",
                  collectionInherits = predicates.isType '"String",
                  collectionResult = predicates.isType '"Bool",
                  collectionResultInherits = predicates.isType '"String",
                  collectionType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Standard", "Keyed", "Dictionary" ]
                      ],
                  constType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "int", "long", "Guid", "string" ]
                      ],
                  consts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Const
                      ],
                  cosmosContainerId = predicates.isType '"String",
                  cosmosCustomMapper = predicates.isType '"Bool",
                  cosmosMapperBase = predicates.isType '"String",
                  cosmosModel = predicates.isType '"String",
                  cosmosName = predicates.isType '"String",
                  cosmosPartitionKey = predicates.isType '"String",
                  cosmosValueContainer = predicates.isType '"Bool",
                  create = predicates.isType '"Bool",
                  crud = predicates.isType '"Bool",
                  dataCtor = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Public", "Private", "Protected" ]
                      ],
                  dataCtorParams = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  dataExtensions = predicates.isType '"Bool",
                  dataModel = predicates.isType '"Bool",
                  dataSvcCaching = predicates.isType '"Bool",
                  dataSvcCtor = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Public", "Private", "Protected" ]
                      ],
                  dataSvcCtorParams = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  dataSvcExtensions = predicates.isType '"Bool",
                  databaseCustomerMapper = predicates.isType '"Bool",
                  databaseMapperInheritsFrom = predicates.isType '"String",
                  databaseName = predicates.isType '"String",
                  databaseSchema = predicates.isType '"String",
                  delete = predicates.isType '"Bool",
                  entityFrameworkCustomMapper = predicates.isType '"Bool",
                  entityFrameworkMapperBase = predicates.isType '"String",
                  entityFrameworkModel = predicates.isType '"String",
                  entityFrameworkName = predicates.isType '"String",
                  eventPublish = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "None", "DataSvc", "Data" ]
                      ],
                  eventSource = predicates.isType '"String",
                  eventTransaction = predicates.isType '"Bool",
                  excludeAll = predicates.isType '"Bool",
                  excludeData = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "Include", "Exclude", "RequiresMapper" ]
                      ],
                  excludeDataSvc = predicates.isType '"Bool",
                  excludeEntity = predicates.isType '"Bool",
                  excludeGrpcAgent = predicates.isType '"Bool",
                  excludeIData = predicates.isType '"Bool",
                  excludeIDataSvc = predicates.isType '"Bool",
                  excludeIManager = predicates.isType '"Bool",
                  excludeManager = predicates.isType '"Bool",
                  excludeWebApi = predicates.isType '"Bool",
                  excludeWebApiAgent = predicates.isType '"Bool",
                  fileName = predicates.isType '"String",
                  genericWithT = predicates.isType '"Bool",
                  get = predicates.isType '"Bool",
                  getAll = predicates.isType '"Bool",
                  grpc = predicates.isType '"Bool",
                  httpAgentCode = predicates.isType '"String",
                  httpAgentMapperBase = predicates.isType '"String",
                  httpAgentModel = predicates.isType '"String",
                  httpAgentName = predicates.isType '"String",
                  httpAgentReturnModel = predicates.isType '"String",
                  httpAgentRoutePrefix = predicates.isType '"String",
                  identifierGenerator = predicates.isType '"Bool",
                  implements = predicates.isType '"String",
                  implementsAutoInfer = predicates.isType '"Bool",
                  inherits = predicates.isType '"String",
                  internalOnly = predicates.isType '"Bool",
                  isInitialOverride = predicates.isType '"Bool",
                  jsonSerializer = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "SystemText", "Newtonsoft" ]
                      ],
                  managerCleanUp = predicates.isType '"Bool",
                  managerCtor = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Public", "Private", "Protected" ]
                      ],
                  managerCtorParams = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  managerExtensions = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  odataCollectionName = predicates.isType '"String",
                  odataCustomMapper = predicates.isType '"Bool",
                  odataModel = predicates.isType '"String",
                  odataName = predicates.isType '"String",
                  omitEntityBase = predicates.isType '"Bool",
                  operations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Operation
                      ],
                  patch = predicates.isType '"Bool",
                  privateName = predicates.isType '"String",
                  properties = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Property
                      ],
                  refDataCodeDataName = predicates.isType '"String",
                  refDataETagDataName = predicates.isType '"String",
                  refDataIdDataName = predicates.isType '"String",
                  refDataIsActiveDataName = predicates.isType '"String",
                  refDataSortOrder = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "SortOrder", "Id", "Code", "Text" ]
                      ],
                  refDataSortOrderDataName = predicates.isType '"String",
                  refDataStoredProcedureName = predicates.isType '"String",
                  refDataText = predicates.isType '"Bool",
                  refDataTextDataName = predicates.isType '"String",
                  refDataType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "int", "long", "Guid", "string" ]
                      ],
                  text = predicates.isType '"String",
                  update = predicates.isType '"Bool",
                  validationFramework = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "CoreEx", "FluentValidation" ]
                      ],
                  validator = predicates.isType '"String",
                  webApiAuthorize = predicates.isType '"String",
                  webApiAutoLocation = predicates.isType '"Bool",
                  webApiConcurrency = predicates.isType '"Bool",
                  webApiCtor = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Public", "Private", "Protected" ]
                      ],
                  webApiCtorParams = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  webApiGetOperation = predicates.isType '"String",
                  webApiRoutePrefix = predicates.isType '"String",
                  withResult = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          Operation
            | doc m%"
            The code generation for an 'Operation' is primarily driven by the 'Type' property. This encourages (enforces) a consistent implementation for the standardised **CRUD** (Create, Read, Update and Delete) actions, as well as supporting fully customised operations as required.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  authPermission = predicates.isType '"String",
                  authRole = predicates.isType '"String",
                  autoImplement = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Database",
                          "EntityFramework",
                          "Cosmos",
                          "OData",
                          "HttpAgent",
                          "None"
                        ]
                      ],
                  cosmosContainerId = predicates.isType '"String",
                  cosmosModel = predicates.isType '"String",
                  cosmosPartitionKey = predicates.isType '"String",
                  dataEntityMapper = predicates.isType '"String",
                  dataExtensions = predicates.isType '"Bool",
                  dataInvoker = predicates.isType '"Bool",
                  dataSvcCustom = predicates.isType '"Bool",
                  dataSvcExtensions = predicates.isType '"Bool",
                  dataSvcInvoker = predicates.isType '"Bool",
                  dataSvcTransaction = predicates.isType '"Bool",
                  dataTransaction = predicates.isType '"Bool",
                  databaseStoredProc = predicates.isType '"String",
                  entityFrameworkModel = predicates.isType '"String",
                  eventPublish = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "None", "DataSvc", "Data" ]
                      ],
                  eventSource = predicates.isType '"String",
                  eventSubject = predicates.isType '"String",
                  excludeAll = predicates.isType '"Bool",
                  excludeData = predicates.isType '"Bool",
                  excludeDataSvc = predicates.isType '"Bool",
                  excludeGrpcAgent = predicates.isType '"Bool",
                  excludeIData = predicates.isType '"Bool",
                  excludeIDataSvc = predicates.isType '"Bool",
                  excludeIManager = predicates.isType '"Bool",
                  excludeManager = predicates.isType '"Bool",
                  excludeWebApi = predicates.isType '"Bool",
                  excludeWebApiAgent = predicates.isType '"Bool",
                  grpc = predicates.isType '"Bool",
                  httpAgentCode = predicates.isType '"String",
                  httpAgentMethod = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "HttpGet",
                          "HttpPost",
                          "HttpPut",
                          "HttpDelete",
                          "HttpPatch"
                        ]
                      ],
                  httpAgentModel = predicates.isType '"String",
                  httpAgentReturnModel = predicates.isType '"String",
                  httpAgentRoute = predicates.isType '"String",
                  managerCleanUp = predicates.isType '"Bool",
                  managerCustom = predicates.isType '"Bool",
                  managerExtensions = predicates.isType '"Bool",
                  managerOperationType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "Create", "Read", "Update", "Delete", "Unspecified" ]
                      ],
                  managerTransaction = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  odataCollectionName = predicates.isType '"String",
                  paging = predicates.isType '"Bool",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Parameter
                      ],
                  primaryKey = predicates.isType '"Bool",
                  privateName = predicates.isType '"String",
                  returnText = predicates.isType '"String",
                  returnType = predicates.isType '"String",
                  returnTypeNullable = predicates.isType '"Bool",
                  text = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Get",
                          "GetColl",
                          "Create",
                          "Update",
                          "Patch",
                          "Delete",
                          "Custom"
                        ]
                      ],
                  validationFramework = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "CoreEx", "FluentValidation" ]
                      ],
                  validator = predicates.isType '"String",
                  valueType = predicates.isType '"String",
                  webApiAlternateStatus = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "OK", "Accepted", "Created", "NoContent", "NotFound" ]
                      ],
                  webApiAuthorize = predicates.isType '"String",
                  webApiConcurrency = predicates.isType '"Bool",
                  webApiGetOperation = predicates.isType '"String",
                  webApiLocation = predicates.isType '"String",
                  webApiMethod = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "HttpGet", "HttpPost", "HttpPut", "HttpDelete" ]
                      ],
                  webApiRoute = predicates.isType '"String",
                  webApiStatus = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "OK", "Accepted", "Created", "NoContent", "NotFound" ]
                      ],
                  webApiUpdateOperation = predicates.isType '"String",
                  withResult = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          Parameter
            | doc m%"
            The 'Parameter' object defines an 'Operation' parameter and its charateristics.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  argumentName = predicates.isType '"String",
                  dataConverter = predicates.isType '"String",
                  "default" = predicates.isType '"String",
                  grpcType = predicates.isType '"String",
                  isMandatory = predicates.isType '"Bool",
                  layerPassing = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "All", "ToManagerSet", "ToManagerCollSet" ]
                      ],
                  name = predicates.isType '"String",
                  nullable = predicates.isType '"Bool",
                  privateName = predicates.isType '"String",
                  property = predicates.isType '"String",
                  refDataList = predicates.isType '"Bool",
                  refDataType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "string", "int", "Guid" ]
                      ],
                  text = predicates.isType '"String",
                  type = predicates.isType '"String",
                  validationFramework = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "CoreEx", "FluentValidation" ]
                      ],
                  validator = predicates.isType '"String",
                  validatorCode = predicates.isType '"String",
                  webApiFrom = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "FromQuery",
                          "FromBody",
                          "FromRoute",
                          "FromEntityProperties"
                        ]
                      ],
                  webApiText = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Property
            | doc m%"
            The 'Property' object defines an 'Entity' property and its charateristics.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  annotation1 = predicates.isType '"String",
                  annotation2 = predicates.isType '"String",
                  annotation3 = predicates.isType '"String",
                  argumentName = predicates.isType '"String",
                  autoCreate = predicates.isType '"Bool",
                  cosmosMapper = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Set", "Ignore", "Map", "Flatten" ]
                      ],
                  dataAutoGenerated = predicates.isType '"Bool",
                  dataConverter = predicates.isType '"String",
                  dataMapperIgnore = predicates.isType '"Bool",
                  dataModelIgnore = predicates.isType '"Bool",
                  dataModelSerializationIgnore = predicates.isType '"Bool",
                  dataName = predicates.isType '"String",
                  dataOperationTypes = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Any",
                          "AnyExceptCreate",
                          "AnyExceptUpdate",
                          "AnyExceptGet",
                          "Get",
                          "Create",
                          "Update",
                          "Delete"
                        ]
                      ],
                  databaseDbType = predicates.isType '"String",
                  databaseIgnore = predicates.isType '"Bool",
                  databaseMapper = predicates.isType '"String",
                  dateTimeTransform = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "UseDefault",
                          "None",
                          "DateOnly",
                          "DateTimeLocal",
                          "DateTimeUtc",
                          "DateTimeUnspecified"
                        ]
                      ],
                  "default" = predicates.isType '"String",
                  displayName = predicates.isType '"String",
                  entityFrameworkMapper = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Set", "Ignore", "Map", "Flatten" ]
                      ],
                  grpcFieldNo = predicates.isType 'Integer,
                  grpcType = predicates.isType '"String",
                  httpAgentMapper = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Set", "Ignore", "Map", "Flatten" ]
                      ],
                  immutable = predicates.isType '"Bool",
                  inherited = predicates.isType '"Bool",
                  internalOnly = predicates.isType '"Bool",
                  isEntity = predicates.isType '"Bool",
                  jsonDataModelName = predicates.isType '"String",
                  jsonName = predicates.isType '"String",
                  modelText = predicates.isType '"String",
                  name = predicates.isType '"String",
                  nullable = predicates.isType '"Bool",
                  odataMapper = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Map", "Ignore", "Skip" ]
                      ],
                  partitionKey = predicates.isType '"Bool",
                  primaryKey = predicates.isType '"Bool",
                  privateName = predicates.isType '"String",
                  refDataList = predicates.isType '"Bool",
                  refDataMapping = predicates.isType '"Bool",
                  refDataText = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Optional", "Always", "Never" ]
                      ],
                  refDataTextName = predicates.isType '"String",
                  refDataType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "string", "int", "Guid" ]
                      ],
                  serializationAlwaysInclude = predicates.isType '"Bool",
                  serializationIgnore = predicates.isType '"Bool",
                  stringCasing = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "UseDefault", "None", "Lower", "Upper", "Title" ]
                      ],
                  stringTransform = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "UseDefault", "None", "NullToEmpty", "EmptyToNull" ]
                      ],
                  stringTrim = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "UseDefault", "None", "Start", "End", "Both" ]
                      ],
                  text = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

predicates.contract_from_predicate definitions.predicate.CodeGeneration