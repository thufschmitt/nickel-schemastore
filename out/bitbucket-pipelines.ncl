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
          awsImage
            | doc m%"
            A docker image hosted by AWS ECR
            "%
            = {
                aws
                  | {
                    access-key
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ])
                      | doc m%"
                      AWS Access Key
                      "%,
                    secret-key
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ])
                      | doc m%"
                      AWS Secret Key
                      "%,
                  }
                  | doc m%"
                  AWS credentials
                  "%,
                name | definitions.contract.simpleImage,
                run-as-user | definitions.contract.runAsUser | optional,
              },
          cache-key-files
            | doc m%"
            Checksum of these file paths will be used to generate the cache key
            "%
            = predicates.contract_from_predicate
              definitions.predicate.cache-key-files,
          caches
            | doc m%"
            Caching build dependencies and directories enables faster builds and reduces the number of consumed build minutes.
            
            Learn more about caches: https://support.atlassian.com/bitbucket-cloud/docs/cache-dependencies
            "%
            = predicates.contract_from_predicate definitions.predicate.caches,
          clone
            | doc m%"
            Contains settings for when we clone your repository into a container. Settings here include:
            
            * lfs - Support for Git lfs
            
            * depth - the depth of the Git clone.
            "%
            = {
                depth
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Integer,
                      predicates.numbers.minimum 1
                    ],
                    predicates.const "full"
                  ])
                  | doc m%"
                  Depth of Git clones for all pipelines (supported only for Git repositories)
                  "%
                  | optional,
                enabled
                  | Bool
                  | doc m%"
                  Enables cloning of the repository
                  "%
                  | optional,
                lfs
                  | Bool
                  | doc m%"
                  Enables the download of LFS files in the clone (supported only for Git repositories)
                  "%
                  | optional,
              },
          definitions
            | doc m%"
            Define resources used elsewhere in your pipeline configuration. 
            Resources can include:
            
            * services that run in separate Docker containers â€“ see https://confluence.atlassian.com/x/gC8kN
            
            * caches â€“ see https://confluence.atlassian.com/x/bA1hNQ#Cachingdependencies-custom-caches
            
            * YAML anchors - a way to define a chunk of your yaml for easy re-use - see https://confluence.atlassian.com/bitbucket/yaml-anchors-960154027.html
            "%
            = {
                caches | definitions.contract.caches | optional,
                pipelines
                  | definitions.contract.pipelinesUnderDefinitions
                  | optional,
                services | definitions.contract.services | optional,
                ..
              },
          image = predicates.contract_from_predicate
              definitions.predicate.image,
          imageWithCustomUser = {
                name | definitions.contract.simpleImage,
                run-as-user | definitions.contract.runAsUser | optional,
              },
          "import" = {
                "import"
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^[^:]+:[^:]+:[^:]+$"
                  ])
                  | doc m%"
                  The import needs to match the following format: {repo-slug|repo-uuid}:{tag|branch-name}:{pipeline-name}
                  "%
                  | optional,
              },
          max-time
            | doc m%"
            Maximum amount of minutes a step can execute
            "%
            = predicates.contract_from_predicate definitions.predicate.max-time,
          options
            | doc m%"
            Contains global settings that apply to all your pipelines. The main keyword you'd use here is max-time.
            "%
            = {
                docker
                  | Bool
                  | doc m%"
                  A flag to add Docker to all build steps in all pipelines
                  "%
                  | optional,
                max-time | definitions.contract.max-time | optional,
                size | definitions.contract.size | optional,
              },
          parallel
            | doc m%"
            Parallel steps enable you to build and test faster, by running a set of steps at the same time.
            
            The total number of build minutes used by a pipeline will not change if you make the steps parallel, but you'll be able to see the results sooner.
            
            There is a limit of 10 for the total number of steps you can run in a pipeline, regardless of whether they are running in parallel or serial.
            "%
            = predicates.contract_from_predicate definitions.predicate.parallel,
          pipe
            | doc m%"
            Pipes make complex tasks easier, by doing a lot of the work behind the scenes.
            This means you can just select which pipe you want to use, and supply the necessary variables.
            You can look at the repository for the pipe to see what commands it is running.
            
            Learn more about pipes: https://confluence.atlassian.com/bitbucket/pipes-958765631.html
            "%
            = {
                pipe
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Pipes make complex tasks easier, by doing a lot of the work behind the scenes.
                  This means you can just select which pipe you want to use, and supply the necessary variables.
                  You can look at the repository for the pipe to see what commands it is running.
                  
                  Learn more about pipes: https://confluence.atlassian.com/bitbucket/pipes-958765631.html
                  "%,
                variables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.minProperties 1,
                    predicates.records.record {  } {  } true
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ])
                  ])
                  | doc m%"
                  Environment variables passed to the pipe
                  "%
                  | optional,
              },
          pipelines
            | doc m%"
            The start of your pipelines definitions. Under this keyword you must define your build pipelines using at least one of the following:
            
              * default (for all branches that don't match any of the following)
              * branches (Git and Mercurial)
              * tags (Git)
              * bookmarks (Mercurial)
            "%
            = {
                bookmarks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.minProperties 1,
                    predicates.records.record {  } {  } true
                    (predicates.anyOf
                    [
                      definitions.predicate.steps,
                      definitions.predicate."import"
                    ])
                  ])
                  | doc m%"
                  Defines all bookmark-specific build pipelines. 
                  
                  The names or expressions in this section are matched against bookmarks in your Mercurial repository. 
                  
                  You can use glob patterns for handling the tag names.
                  "%
                  | optional,
                branches
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.minProperties 1,
                    predicates.records.record {  } {  } true
                    (predicates.anyOf
                    [
                      definitions.predicate.steps,
                      definitions.predicate."import"
                    ])
                  ])
                  | doc m%"
                  Defines a section for all branch-specific build pipelines. The names or expressions in this section are matched against:
                  
                    * branches in your Git repository
                    * named branches in your Mercurial repository
                  
                  You can use glob patterns for handling the branch names.
                  "%
                  | optional,
                custom
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.minProperties 1,
                    predicates.records.record {  } {  } true
                    (predicates.anyOf
                    [
                      definitions.predicate.stepsWithVariables,
                      definitions.predicate."import"
                    ])
                  ])
                  | doc m%"
                  Defines pipelines that can only be triggered manually or scheduled from the Bitbucket Cloud interface.
                  "%
                  | optional,
                "default"
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.steps,
                    definitions.predicate."import"
                  ])
                  | doc m%"
                  The default pipeline runs on every push to the repository, unless a branch-specific pipeline is defined. 
                  You can define a branch pipeline in the branches section.
                  
                  Note: The default pipeline doesn't run on tags or bookmarks.
                  "%
                  | optional,
                pull-requests
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.minProperties 1,
                    predicates.records.record {  } {  } true
                    (predicates.anyOf
                    [
                      definitions.predicate.steps,
                      definitions.predicate."import"
                    ])
                  ])
                  | doc m%"
                  A special pipeline which only runs on pull requests. Pull-requests has the same level of indentation as branches.
                  
                  This type of pipeline runs a little differently to other pipelines. When it's triggered, we'll merge the destination branch into your working branch before it runs. If the merge fails we will stop the pipeline.
                  "%
                  | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.minProperties 1,
                    predicates.records.record {  } {  } true
                    definitions.predicate.steps
                  ])
                  | doc m%"
                  Defines all tag-specific build pipelines. 
                  
                  The names or expressions in this section are matched against tags and annotated tags in your Git repository. 
                  
                  You can use glob patterns for handling the tag names.
                  "%
                  | optional,
              },
          pipelinesUnderDefinitions
            | doc m%"
            Defines pipelines that can be used under root level pipelines section.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.pipelinesUnderDefinitions,
          privateImage
            | doc m%"
            A docker image hosted in a private repository
            "%
            = {
                email
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Email to use to fetch the Docker image
                  "%
                  | optional,
                name | definitions.contract.simpleImage,
                password
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Password to use to fetch the Docker image
                  "%,
                run-as-user | definitions.contract.runAsUser | optional,
                username
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Username to use to fetch the Docker image
                  "%,
              },
          runAsUser
            | doc m%"
            Overrides image's default user, specified user UID must be an existing user in the image with a valid home directory
            "%
            = std.number.Integer,
          runs-on
            | doc m%"
            self-hosted runner labels
            "%
            = predicates.contract_from_predicate definitions.predicate.runs-on,
          script
            | doc m%"
            Contains a list of commands that are executed in sequence. 
            
            Scripts are executed in the order in which they appear in a step. 
            
            We recommend that you move large scripts to a separate script file and call it from the bitbucket-pipelines.yml.
            "%
            = predicates.contract_from_predicate definitions.predicate.script,
          services
            | doc m%"
            Rather than trying to build all the resources you might need into one large image, we can spin up separate docker containers for services. This will tend to speed up the build, and makes it very easy to change a single service without having to redo your whole image.
            "%
            = predicates.contract_from_predicate definitions.predicate.services,
          simpleImage
            | doc m%"
            The Docker container to run your builds.
            
            see: https://confluence.atlassian.com/x/kYU5Lw for details
            "%
            = predicates.contract_from_predicate
              definitions.predicate.simpleImage,
          size
            | doc m%"
            You can allocate additional resources to a step, or to the whole pipeline. 
            By specifying the size of 2x, you'll have double the resources available (eg. 4GB memory â†’ 8GB memory).
            
            At this time, valid sizes are 1x and 2x.
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| '"2x", '"1x" |] ],
          step
            | doc m%"
            Define s a build execution unit. 
            
            Steps are executed in the order that they appear in the bitbucket-pipelines.yml file. 
            You can use up to 10 steps in a pipeline.
            "%
            = {
                after-script
                  | definitions.contract.script
                  | doc m%"
                  Commands inside an after-script section will run when the step succeeds or fails. This could be useful for clean up commands, test coverage, notifications, or rollbacks you might want to run, especially if your after-script uses the value of BITBUCKET_EXIT_CODE.
                  
                  Note: If any commands in the after-script section fail:
                  
                  * we won't run any more commands in that section
                  
                  * it will not effect the reported status of the step.
                  "%
                  | optional,
                artifacts
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
                        predicates.strings.minLength 1
                      ])
                    ],
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.arrays.minItems 1,
                      predicates.records.required [ "paths" ],
                      predicates.records.record
                      {
                        download = predicates.isType '"Bool",
                        paths = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ])
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ]
                  ])
                  | optional,
                caches
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Caches enabled for the step
                  "%
                  | optional,
                clone | definitions.contract.clone | optional,
                condition
                  | {
                    changesets
                      | { includePaths | Array Dyn | optional, .. }
                      | optional,
                    ..
                  }
                  | doc m%"
                  Allows for steps to execute when certain conditions or rules are satisfied
                  "%
                  | optional,
                deployment
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Sets the type of environment for your deployment step, used in the Deployments dashboard.
                  "%
                  | optional,
                image | definitions.contract.image | optional,
                max-time | definitions.contract.max-time | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  You can add a name to a step to make displays and reports easier to read and understand.
                  "%
                  | optional,
                runs-on
                  | definitions.contract.runs-on
                  | doc m%"
                  self-hosted runner labels
                  "%
                  | optional,
                script
                  | definitions.contract.script
                  | doc m%"
                  Commands to execute in the step
                  "%,
                services
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]),
                    predicates.arrays.maxItems 5,
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Services enabled for the step
                  "%
                  | optional,
                size | definitions.contract.size | optional,
                trigger
                  | std.enum.TagOrString
                  | [| 'manual, 'automatic |]
                  | doc m%"
                  Specifies whether a step will run automatically or only after someone manually triggers it. You can define the trigger type as manual or automatic. If the trigger type is not defined, the step defaults to running automatically. The first step cannot be manual. If you want to have a whole pipeline only run from a manual trigger then use a custom pipeline.
                  "%
                  | optional,
              },
          steps = predicates.contract_from_predicate
              definitions.predicate.steps,
          stepsWithVariables = predicates.contract_from_predicate
              definitions.predicate.stepsWithVariables,
        },
    predicate = {
          awsImage
            | doc m%"
            A docker image hosted by AWS ECR
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "aws", "name" ],
                predicates.records.record
                {
                  aws = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [ "access-key", "secret-key" ],
                        predicates.records.record
                        {
                          access-key = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                          secret-key = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  name = definitions.predicate.simpleImage,
                  run-as-user = definitions.predicate.runAsUser,
                }
                {  }
                false
                predicates.never
              ],
          cache-key-files
            | doc m%"
            Checksum of these file paths will be used to generate the cache key
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [ predicates.isType '"String", predicates.strings.minLength 1 ])
              ],
          caches
            | doc m%"
            Caching build dependencies and directories enables faster builds and reduces the number of consumed build minutes.
            
            Learn more about caches: https://support.atlassian.com/bitbucket-cloud/docs/cache-dependencies
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.not
                (predicates.allOf
                [
                  predicates.records.required [ "docker" ],
                  predicates.records.record {  } {  } true predicates.always
                ]),
                predicates.records.record {  }
                {
                  "^(?!-)[-a-z0-9]{0,49}[a-z0-9]$" = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.strings.minLength 2,
                          predicates.records.required [ "key", "path" ],
                          predicates.records.record
                          {
                            key = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    files =
                                      definitions.predicate.cache-key-files,
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            path = predicates.allOf
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
                }
                false
                predicates.never
              ],
          clone
            | doc m%"
            Contains settings for when we clone your repository into a container. Settings here include:
            
            * lfs - Support for Git lfs
            
            * depth - the depth of the Git clone.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  depth = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 1
                        ],
                        predicates.const "full"
                      ],
                  enabled = predicates.isType '"Bool",
                  lfs = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          definitions
            | doc m%"
            Define resources used elsewhere in your pipeline configuration. 
            Resources can include:
            
            * services that run in separate Docker containers â€“ see https://confluence.atlassian.com/x/gC8kN
            
            * caches â€“ see https://confluence.atlassian.com/x/bA1hNQ#Cachingdependencies-custom-caches
            
            * YAML anchors - a way to define a chunk of your yaml for easy re-use - see https://confluence.atlassian.com/bitbucket/yaml-anchors-960154027.html
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  caches = definitions.predicate.caches,
                  pipelines = definitions.predicate.pipelinesUnderDefinitions,
                  services = definitions.predicate.services,
                }
                {  }
                true
                predicates.always
              ],
          image = predicates.oneOf
              [
                definitions.predicate.simpleImage,
                definitions.predicate.imageWithCustomUser,
                definitions.predicate.privateImage,
                definitions.predicate.awsImage
              ],
          imageWithCustomUser = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = definitions.predicate.simpleImage,
                  run-as-user = definitions.predicate.runAsUser,
                }
                {  }
                false
                predicates.never
              ],
          "import" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "import" = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^[^:]+:[^:]+:[^:]+$"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          max-time
            | doc m%"
            Maximum amount of minutes a step can execute
            "%
            = predicates.allOf
              [
                predicates.isType 'Integer,
                predicates.numbers.maximum 120,
                predicates.numbers.minimum 1
              ],
          options
            | doc m%"
            Contains global settings that apply to all your pipelines. The main keyword you'd use here is max-time.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  docker = predicates.isType '"Bool",
                  max-time = definitions.predicate.max-time,
                  size = definitions.predicate.size,
                }
                {  }
                false
                predicates.never
              ],
          parallel
            | doc m%"
            Parallel steps enable you to build and test faster, by running a set of steps at the same time.
            
            The total number of build minutes used by a pipeline will not change if you make the steps parallel, but you'll be able to see the results sooner.
            
            There is a limit of 10 for the total number of steps you can run in a pipeline, regardless of whether they are running in parallel or serial.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  { step = definitions.predicate.step, }
                  {  }
                  false
                  predicates.never
                ]),
                predicates.arrays.minItems 2
              ],
          pipe
            | doc m%"
            Pipes make complex tasks easier, by doing a lot of the work behind the scenes.
            This means you can just select which pipe you want to use, and supply the necessary variables.
            You can look at the repository for the pipe to see what commands it is running.
            
            Learn more about pipes: https://confluence.atlassian.com/bitbucket/pipes-958765631.html
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "pipe" ],
                predicates.records.record
                {
                  pipe = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  variables = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.minProperties 1,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ])
                      ],
                }
                {  }
                false
                predicates.never
              ],
          pipelines
            | doc m%"
            The start of your pipelines definitions. Under this keyword you must define your build pipelines using at least one of the following:
            
              * default (for all branches that don't match any of the following)
              * branches (Git and Mercurial)
              * tags (Git)
              * bookmarks (Mercurial)
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bookmarks = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.minProperties 1,
                        predicates.records.record {  } {  } true
                        (predicates.anyOf
                        [
                          definitions.predicate.steps,
                          definitions.predicate."import"
                        ])
                      ],
                  branches = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.minProperties 1,
                        predicates.records.record {  } {  } true
                        (predicates.anyOf
                        [
                          definitions.predicate.steps,
                          definitions.predicate."import"
                        ])
                      ],
                  custom = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.minProperties 1,
                        predicates.records.record {  } {  } true
                        (predicates.anyOf
                        [
                          definitions.predicate.stepsWithVariables,
                          definitions.predicate."import"
                        ])
                      ],
                  "default" = predicates.anyOf
                      [
                        definitions.predicate.steps,
                        definitions.predicate."import"
                      ],
                  pull-requests = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.minProperties 1,
                        predicates.records.record {  } {  } true
                        (predicates.anyOf
                        [
                          definitions.predicate.steps,
                          definitions.predicate."import"
                        ])
                      ],
                  tags = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.minProperties 1,
                        predicates.records.record {  } {  } true
                        definitions.predicate.steps
                      ],
                }
                {  }
                false
                predicates.never
              ],
          pipelinesUnderDefinitions
            | doc m%"
            Defines pipelines that can be used under root level pipelines section.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.minProperties 1,
                predicates.records.record {  } {  } true
                definitions.predicate.stepsWithVariables
              ],
          privateImage
            | doc m%"
            A docker image hosted in a private repository
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "password", "username" ],
                predicates.records.record
                {
                  email = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  name = definitions.predicate.simpleImage,
                  password = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  run-as-user = definitions.predicate.runAsUser,
                  username = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          runAsUser
            | doc m%"
            Overrides image's default user, specified user UID must be an existing user in the image with a valid home directory
            "%
            = predicates.isType 'Integer,
          runs-on
            | doc m%"
            self-hosted runner labels
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [ predicates.isType '"String", predicates.strings.minLength 1 ])
              ],
          script
            | doc m%"
            Contains a list of commands that are executed in sequence. 
            
            Scripts are executed in the order in which they appear in a step. 
            
            We recommend that you move large scripts to a separate script file and call it from the bitbucket-pipelines.yml.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ],
                  definitions.predicate.pipe
                ]),
                predicates.arrays.minItems 1
              ],
          services
            | doc m%"
            Rather than trying to build all the resources you might need into one large image, we can spin up separate docker containers for services. This will tend to speed up the build, and makes it very easy to change a single service without having to redo your whole image.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    image = definitions.predicate.image,
                    memory = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 128
                        ],
                    variables = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.minProperties 1,
                          predicates.records.record {  } {  } true
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ])
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          simpleImage
            | doc m%"
            The Docker container to run your builds.
            
            see: https://confluence.atlassian.com/x/kYU5Lw for details
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          size
            | doc m%"
            You can allocate additional resources to a step, or to the whole pipeline. 
            By specifying the size of 2x, you'll have double the resources available (eg. 4GB memory â†’ 8GB memory).
            
            At this time, valid sizes are 1x and 2x.
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.enum [ "1x", "2x" ] ],
          step
            | doc m%"
            Define s a build execution unit. 
            
            Steps are executed in the order that they appear in the bitbucket-pipelines.yml file. 
            You can use up to 10 steps in a pipeline.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "script" ],
                predicates.records.record
                {
                  after-script = definitions.predicate.script,
                  artifacts = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ])
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.arrays.minItems 1,
                          predicates.records.required [ "paths" ],
                          predicates.records.record
                          {
                            download = predicates.isType '"Bool",
                            paths = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.strings.minLength 1
                                  ])
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ]
                      ],
                  caches = predicates.allOf
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
                  clone = definitions.predicate.clone,
                  condition = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          changesets = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                { includePaths = predicates.isType '"Array", }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  deployment = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  image = definitions.predicate.image,
                  max-time = definitions.predicate.max-time,
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  runs-on = definitions.predicate.runs-on,
                  script = definitions.predicate.script,
                  services = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]),
                        predicates.arrays.maxItems 5,
                        predicates.arrays.minItems 1
                      ],
                  size = definitions.predicate.size,
                  trigger = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "automatic", "manual" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          steps = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    { step = definitions.predicate.step, }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    { parallel = definitions.predicate.parallel, }
                    {  }
                    false
                    predicates.never
                  ]
                ]),
                predicates.arrays.minItems 1
              ],
          stepsWithVariables = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      variables = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                name = predicates.allOf
                                    [
                                      predicates.isType '"String",
                                      predicates.strings.minLength 1
                                    ],
                              }
                              {  }
                              false
                              predicates.never
                            ]),
                            predicates.arrays.minItems 1
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    { step = definitions.predicate.step, }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    { parallel = definitions.predicate.parallel, }
                    {  }
                    false
                    predicates.never
                  ]
                ]),
                predicates.arrays.minItems 1
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.anyOf
  [
    predicates.allOf
    [
      predicates.records.required [ "pipelines" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.records.required [ "definitions", "export" ],
      predicates.records.record {  } {  } true predicates.always
    ]
  ],
  predicates.records.record
  {
    clone = definitions.predicate.clone,
    definitions = definitions.predicate.definitions,
    export = predicates.isType '"Bool",
    image = definitions.predicate.image,
    options = definitions.predicate.options,
    pipelines = definitions.predicate.pipelines,
  }
  {  }
  false
  predicates.never
])