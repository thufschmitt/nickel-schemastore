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
          "//" = predicates.contract_from_predicate definitions.predicate."//",
        },
    predicate = { "//" = predicates.always, },
  }
in

{
  "$schema" | String | optional,
  "__experimental"
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ predicates.isType '"String", predicates.isType '"Bool" ])
    | doc m%"
    The name of the experiment this block is a part of, or boolean true if there is no specific experiment name.
    "%
    | optional,
  ancestor
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    The `ancestor` property makes a block available inside the specified block types at any position of the ancestor block subtree. That allows, for example, to place a ‘Comment Content’ block inside a ‘Column’ block, as long as ‘Column’ is somewhere within a ‘Comment Template’ block.
    "%
    | optional,
  apiVersion
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType 'Integer, predicates.enum [ 1, 2, 3 ] ])
    | doc m%"
    The version of the Block API used by the block. The most recent version is 3 and it was introduced in WordPress 6.3.
    
     See the API versions documentation at https://developer.wordpress.org/block-editor/reference-guides/block-api/block-api-versions/ for more details.
    "%
    | optional,
  attributes
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      {
        "[a-zA-Z]" = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.records.required [ "type" ],
                  predicates.records.record {  } {  } true predicates.always
                ],
                predicates.allOf
                [
                  predicates.records.required [ "enum" ],
                  predicates.records.record {  } {  } true predicates.always
                ]
              ],
              predicates.records.record
              {
                attribute = predicates.isType '"String",
                "default" = predicates.always,
                enum = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.oneOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"Number",
                        predicates.isType '"String"
                      ])
                    ],
                meta = predicates.isType '"String",
                query = predicates.isType 'Record,
                selector = predicates.isType '"String",
                source = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum
                      [ "attribute", "text", "html", "raw", "query", "meta" ]
                    ],
                type = predicates.oneOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "null",
                          "boolean",
                          "object",
                          "array",
                          "string",
                          "integer",
                          "number"
                        ]
                      ],
                      predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "null",
                            "boolean",
                            "object",
                            "array",
                            "string",
                            "integer",
                            "number"
                          ]
                        ]),
                        predicates.arrays.uniqueItems
                      ]
                    ],
              }
              {  }
              true
              predicates.always
            ],
      }
      false
      predicates.never
    ])
    | doc m%"
    Attributes provide the structured data needs of a block. They can exist in different forms when they are serialized, but they are declared together under a common interface.
    
    See the attributes documentation at https://developer.wordpress.org/block-editor/reference-guides/block-api/block-attributes/ for more details.
    "%
    | optional,
  blockHooks
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      {
        "^[a-z][a-z0-9-]*/[a-z][a-z0-9-]*$" = predicates.enum
            [ "before", "after", "firstChild", "lastChild" ],
      }
      false
      predicates.never
    ])
    | doc m%"
    Block Hooks allow a block to automatically insert itself next to all instances of a given block type.
    
    See the Block Hooks documentation at https://developer.wordpress.org/block-editor/reference-guides/block-api/block-registration/#block-hooks-optional for more details.
    "%
    | optional,
  category
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.isType '"String",
      predicates.enum [ "text", "media", "design", "widgets", "theme", "embed" ]
    ])
    | doc m%"
    Blocks are grouped into categories to help users browse and discover them.
     Core provided categories are: text, media, design, widgets, theme, embed
    
    Plugins and Themes can also register custom block categories.
    
    https://developer.wordpress.org/block-editor/reference-guides/filters/block-filters/#managing-block-categories
    "%
    | optional,
  description
    | String
    | doc m%"
    This is a short description for your block, which can be translated with our translation functions. This will be shown in the block inspector.
    "%
    | optional,
  editorScript
    | predicates.contract_from_predicate
    (predicates.oneOf
    [
      predicates.isType '"String",
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf (predicates.isType '"String")
      ]
    ])
    | doc m%"
    Block type editor script definition. It will only be enqueued in the context of the editor.
    "%
    | optional,
  editorStyle
    | predicates.contract_from_predicate
    (predicates.oneOf
    [
      predicates.isType '"String",
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf (predicates.isType '"String")
      ]
    ])
    | doc m%"
    Block type editor style definition. It will only be enqueued in the context of the editor.
    "%
    | optional,
  example
    | {
      attributes
        | {  .. }
        | doc m%"
        Set the attributes for the block example
        "%
        | optional,
      innerBlocks
        | Array Dyn
        | doc m%"
        Set the inner blocks that should be used within the block example. The blocks should be defined as a nested array like this: 
        
         [ [ 'core/heading', { content: 'This is an Example' }, [] ] ]
        
         Where each block itself is an array that contains the block name, the block attributes, and the blocks inner blocks.
        "%
        | optional,
      viewportWidth
        | Number
        | doc m%"
        The viewportWidth controls the width of the iFrame container in which the block preview will get rendered
        "%
        | optional,
      ..
    }
    | doc m%"
    It provides structured example data for the block. This data is used to construct a preview for the block to be shown in the Inspector Help Panel when the user mouses over the block.
    
    See the example documentation at https://developer.wordpress.org/block-editor/reference-guides/block-api/block-registration/#example-optional for more details.
    "%
    | optional,
  icon
    | String
    | doc m%"
    An icon property should be specified to make it easier to identify a block. These can be any of WordPress’ Dashicons (slug serving also as a fallback in non-js contexts).
    "%
    | optional,
  keywords
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Sometimes a block could have aliases that help users discover it while searching. For example, an image block could also want to be discovered by photo. You can do so by providing an array of unlimited terms (which are translated).
    "%
    | optional,
  name
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"String",
      predicates.strings.pattern "^[a-z][a-z0-9-]*/[a-z][a-z0-9-]*$"
    ])
    | doc m%"
    The name for a block is a unique string that identifies a block. Names have to be structured as `namespace/block-name`, where namespace is the name of your plugin or theme.
    "%,
  parent
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Setting parent lets a block require that it is only available when nested within the specified blocks. For example, you might want to allow an ‘Add to Cart’ block to only be available within a ‘Product’ block.
    "%
    | optional,
  providesContext
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      { "[a-zA-Z]" = predicates.isType '"String", }
      true
      predicates.always
    ])
    | doc m%"
    Context provided for available access by descendants of blocks of this type, in the form of an object which maps a context name to one of the block’s own attribute.
    
    See the block context documentation at https://developer.wordpress.org/block-editor/reference-guides/block-api/block-context/ for more details.
    "%
    | optional,
  render
    | String
    | doc m%"
    Template file loaded on the server when rendering a block.
    "%
    | optional,
  script
    | predicates.contract_from_predicate
    (predicates.oneOf
    [
      predicates.isType '"String",
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf (predicates.isType '"String")
      ]
    ])
    | doc m%"
    Block type frontend and editor script definition. It will be enqueued both in the editor and when viewing the content on the front of the site.
    "%
    | optional,
  selectors
    | {
      border
        | predicates.contract_from_predicate
        (predicates.oneOf
        [
          predicates.isType '"String",
          predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              color = predicates.isType '"String",
              radius = predicates.isType '"String",
              root = predicates.isType '"String",
              style = predicates.isType '"String",
              width = predicates.isType '"String",
            }
            {  }
            true
            predicates.always
          ]
        ])
        | doc m%"
        Custom CSS selector used to generate rules for the block's theme.json border styles.
        "%
        | optional,
      color
        | predicates.contract_from_predicate
        (predicates.oneOf
        [
          predicates.isType '"String",
          predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              background = predicates.isType '"String",
              root = predicates.isType '"String",
              text = predicates.isType '"String",
            }
            {  }
            true
            predicates.always
          ]
        ])
        | doc m%"
        Custom CSS selector used to generate rules for the block's theme.json color styles.
        "%
        | optional,
      dimensions
        | predicates.contract_from_predicate
        (predicates.oneOf
        [
          predicates.isType '"String",
          predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              minHeight = predicates.isType '"String",
              root = predicates.isType '"String",
            }
            {  }
            true
            predicates.always
          ]
        ])
        | doc m%"
        Custom CSS selector used to generate rules for the block's theme.json dimensions styles.
        "%
        | optional,
      root
        | String
        | doc m%"
        The primary CSS class to apply to the block. This replaces the `.wp-block-name` class if set.
        "%
        | optional,
      spacing
        | predicates.contract_from_predicate
        (predicates.oneOf
        [
          predicates.isType '"String",
          predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              blockGap = predicates.isType '"String",
              margin = predicates.isType '"String",
              padding = predicates.isType '"String",
              root = predicates.isType '"String",
            }
            {  }
            true
            predicates.always
          ]
        ])
        | doc m%"
        Custom CSS selector used to generate rules for the block's theme.json spacing styles.
        "%
        | optional,
      typography
        | predicates.contract_from_predicate
        (predicates.oneOf
        [
          predicates.isType '"String",
          predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              fontFamily = predicates.isType '"String",
              fontSize = predicates.isType '"String",
              fontStyle = predicates.isType '"String",
              fontWeight = predicates.isType '"String",
              letterSpacing = predicates.isType '"String",
              lineHeight = predicates.isType '"String",
              root = predicates.isType '"String",
              textDecoration = predicates.isType '"String",
              textTransform = predicates.isType '"String",
            }
            {  }
            true
            predicates.always
          ]
        ])
        | doc m%"
        Custom CSS selector used to generate rules for the block's theme.json typography styles.
        "%
        | optional,
      ..
    }
    | doc m%"
    Provides custom CSS selectors and mappings for the block. Selectors may be set for the block itself or per-feature e.g. typography. Custom selectors per feature or sub-feature, allow different block styles to be applied to different elements within the block.
    "%
    | optional,
  style
    | predicates.contract_from_predicate
    (predicates.oneOf
    [
      predicates.isType '"String",
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf (predicates.isType '"String")
      ]
    ])
    | doc m%"
    Block type frontend style definition. It will be enqueued both in the editor and when viewing the content on the front of the site.
    "%
    | optional,
  styles
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "label", "name" ],
        predicates.records.record
        {
          isDefault = predicates.isType '"Bool",
          label = predicates.isType '"String",
          name = predicates.isType '"String",
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Block styles can be used to provide alternative styles to block. It works by adding a class name to the block’s wrapper. Using CSS, a theme developer can target the class name for the block style if it is selected.
    
    Plugins and Themes can also register custom block style for existing blocks.
    
    https://developer.wordpress.org/block-editor/reference-guides/block-api/block-styles
    "%
    | optional,
  supports
    | {
      align
        | predicates.contract_from_predicate
        (predicates.oneOf
        [
          predicates.isType '"Bool",
          predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.arrayOf
            (predicates.allOf
            [
              predicates.isType '"String",
              predicates.enum [ "wide", "full", "left", "center", "right" ]
            ])
          ]
        ])
        | doc m%"
        This property adds block controls which allow to change block’s alignment.
        "%
        | optional,
      alignWide
        | Bool
        | doc m%"
        This property allows to enable wide alignment for your theme. To disable this behavior for a single block, set this flag to false.
        "%
        | optional,
      anchor
        | Bool
        | doc m%"
        Anchors let you link directly to a specific block on a page. This property adds a field to define an id for the block and a button to copy the direct link.
        "%
        | optional,
      ariaLabel
        | Bool
        | doc m%"
        ARIA-labels let you define an accessible label for elements. This property allows enabling the definition of an aria-label for the block, without exposing a UI field.
        "%
        | optional,
      className
        | Bool
        | doc m%"
        By default, the class .wp-block-your-block-name is added to the root element of your saved markup. This helps having a consistent mechanism for styling blocks that themes and plugins can rely on. If, for whatever reason, a class is not desired on the markup, this functionality can be disabled.
        "%
        | optional,
      color
        | {
          background
            | Bool
            | doc m%"
            This property adds UI controls which allow the user to apply a solid background color to a block.
            
            When color support is declared, this property is enabled by default (along with text), so simply setting color will enable background color.
            
            To disable background support while keeping other color supports enabled, set to false.
            
            When the block declares support for color.background, its attributes definition is extended to include two new attributes: backgroundColor and style
            "%
            | optional,
          enableContrastChecker
            | Bool
            | doc m%"
            Determines whether the contrast checker widget displays in the block editor UI.
            
            The contrast checker appears only if the block declares support for color. It tests the readability of color combinations and warns if there is a potential issue. The property is enabled by default.
            
            Set to `false` to explicitly disable.
            "%
            | optional,
          gradients
            | Bool
            | doc m%"
            This property adds UI controls which allow the user to apply a gradient background to a block.
            
            Gradient presets are sourced from editor-gradient-presets theme support.
            
            When the block declares support for color.gradient, its attributes definition is extended to include two new attributes: gradient and style
            "%
            | optional,
          link
            | Bool
            | doc m%"
            This property adds block controls which allow the user to set link color in a block, link color is disabled by default.
            
            Link color presets are sourced from the editor-color-palette theme support.
            
            When the block declares support for color.link, its attributes definition is extended to include the style attribute
            "%
            | optional,
          text
            | Bool
            | doc m%"
            This property adds block controls which allow the user to set text color in a block.
            
            When color support is declared, this property is enabled by default (along with background), so simply setting color will enable text color.
            
            Text color presets are sourced from the editor-color-palette theme support.
            
            When the block declares support for color.text, its attributes definition is extended to include two new attributes: textColor and style
            "%
            | optional,
          ..
        }
        | doc m%"
        This value signals that a block supports some of the properties related to color. When it does, the block editor will show UI controls for the user to set their values.
        
        Note that the background and text keys have a default value of true, so if the color property is present they’ll also be considered enabled
        "%
        | optional,
      customClassName
        | Bool
        | doc m%"
        This property adds a field to define a custom className for the block’s wrapper.
        "%
        | optional,
      defaultStylePicker
        | Bool
        | doc m%"
        When the style picker is shown, a dropdown is displayed so the user can select a default style for this block type. If you prefer not to show the dropdown, set this property to false.
        "%
        | optional,
      dimensions
        | {
          minHeight
            | Bool
            | doc m%"
            Allow blocks to define a minimum height value.
            "%
            | optional,
          ..
        }
        | doc m%"
        This value signals that a block supports some of the CSS style properties related to dimensions. When it does, the block editor will show UI controls for the user to set their values if the theme declares support.
        
        When the block declares support for a specific dimensions property, its attributes definition is extended to include the style attribute.
        "%
        | optional,
      filter
        | {
          duotone
            | Bool
            | doc m%"
            Allow blocks to define a duotone filter.
            "%
            | optional,
          ..
        }
        | doc m%"
        This value signals that a block supports some of the properties related to filters. When it does, the block editor will show UI controls for the user to set their values if the theme declares support.
        
        When the block declares support for a specific filter property, its attributes definition is extended to include the style attribute.
        "%
        | optional,
      html
        | Bool
        | doc m%"
        By default, a block’s markup can be edited individually. To disable this behavior, set html to false.
        "%
        | optional,
      inserter
        | Bool
        | doc m%"
        By default, all blocks will appear in the inserter, block transforms menu, Style Book, etc. To hide a block from all parts of the user interface so that it can only be inserted programmatically, set inserter to false.
        "%
        | optional,
      layout
        | predicates.contract_from_predicate
        (predicates.oneOf
        [
          predicates.isType '"Bool",
          predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              allowEditing = predicates.isType '"Bool",
              allowInheriting = predicates.isType '"Bool",
              allowJustification = predicates.isType '"Bool",
              allowOrientation = predicates.isType '"Bool",
              allowSizingOnChildren = predicates.isType '"Bool",
              allowSwitching = predicates.isType '"Bool",
              allowVerticalAlignment = predicates.isType '"Bool",
              "default" = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      columnCount = predicates.isType '"Number",
                      contentSize = predicates.isType '"String",
                      flexWrap = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "wrap", "nowrap" ]
                          ],
                      justifyContent = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "right",
                              "center",
                              "space-between",
                              "left",
                              "stretch"
                            ]
                          ],
                      minimumColumnWidth = predicates.isType '"String",
                      orientation = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "horizontal", "vertical" ]
                          ],
                      type = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "constrained", "grid", "flex" ]
                          ],
                      verticalAlignment = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "top",
                              "center",
                              "bottom",
                              "space-between",
                              "stretch"
                            ]
                          ],
                      wideSize = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always
                  ],
            }
            {  }
            true
            predicates.always
          ]
        ])
        | doc m%"
        This value only applies to blocks that are containers for inner blocks. If set to `true` the layout type will be `flow`. For other layout types it's necessary to set the `type` explicitly inside the `default` object.
        "%
        | optional,
      lock
        | Bool
        | doc m%"
        A block may want to disable the ability to toggle the lock state. It can be locked/unlocked by a user from the block 'Options' dropdown by default. To disable this behavior, set lock to false.
        "%
        | optional,
      multiple
        | Bool
        | doc m%"
        A non-multiple block can be inserted into each post, one time only. For example, the built-in ‘More’ block cannot be inserted again if it already exists in the post being edited. A non-multiple block’s icon is automatically dimmed (unclickable) to prevent multiple instances.
        "%
        | optional,
      position
        | {
          sticky
            | Bool
            | doc m%"
            Allow blocks to stick to their immediate parent when scrolling the page.
            "%
            | optional,
          ..
        }
        | doc m%"
        This value signals that a block supports some of the CSS style properties related to position. When it does, the block editor will show UI controls for the user to set their values if the theme declares support.
        
        When the block declares support for a specific position property, its attributes definition is extended to include the style attribute.
        "%
        | optional,
      reusable
        | Bool
        | doc m%"
        A block may want to disable the ability of being converted into a reusable block. By default all blocks can be converted to a reusable block. If supports reusable is set to false, the option to convert the block into a reusable block will not appear.
        "%
        | optional,
      spacing
        | {
          margin
            | predicates.contract_from_predicate
            (predicates.oneOf
            [
              predicates.isType '"Bool",
              predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "top", "right", "left", "bottom" ]
                ])
              ],
              predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "vertical", "horizontal" ]
                ])
              ]
            ])
            | optional,
          padding
            | predicates.contract_from_predicate
            (predicates.oneOf
            [
              predicates.isType '"Bool",
              predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "top", "right", "left", "bottom" ]
                ])
              ],
              predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "vertical", "horizontal" ]
                ])
              ]
            ])
            | optional,
          ..
        }
        | doc m%"
        This value signals that a block supports some of the CSS style properties related to spacing. When it does, the block editor will show UI controls for the user to set their values if the theme declares support.
        
        When the block declares support for a specific spacing property, its attributes definition is extended to include the style attribute.
        "%
        | optional,
      typography
        | {
          fontSize
            | Bool
            | doc m%"
            This value signals that a block supports the font-size CSS style property. When it does, the block editor will show an UI control for the user to set its value.
            
            The values shown in this control are the ones declared by the theme via the editor-font-sizes theme support, or the default ones if none is provided.
            
            When the block declares support for fontSize, its attributes definition is extended to include two new attributes: fontSize and style
            "%
            | optional,
          lineHeight
            | Bool
            | doc m%"
            This value signals that a block supports the line-height CSS style property. When it does, the block editor will show an UI control for the user to set its value if the theme declares support.
            
            When the block declares support for lineHeight, its attributes definition is extended to include a new attribute style of object type with no default assigned. It stores the custom value set by the user. The block can apply a default style by specifying its own style attribute with a default
            "%
            | optional,
          ..
        }
        | doc m%"
        This value signals that a block supports some of the CSS style properties related to typography. When it does, the block editor will show UI controls for the user to set their values if the theme declares support.
        
        When the block declares support for a specific typography property, its attributes definition is extended to include the style attribute.
        "%
        | optional,
      ..
    }
    | doc m%"
    It contains as set of options to control features used in the editor. See the supports documentation at https://developer.wordpress.org/block-editor/reference-guides/block-api/block-supports/ for more details.
    "%
    | optional,
  textdomain
    | String
    | doc m%"
    The gettext text domain of the plugin/block. More information can be found in the Text Domain section of the How to Internationalize your Plugin page.
    
    https://developer.wordpress.org/plugins/internationalization/how-to-internationalize-your-plugin/
    "%
    | optional,
  title
    | String
    | doc m%"
    This is the display title for your block, which can be translated with our translation functions. The block inserter will show this name.
    "%,
  usesContext
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Array of the names of context values to inherit from an ancestor provider.
    
    See the block context documentation at https://developer.wordpress.org/block-editor/reference-guides/block-api/block-context/ for more details.
    "%
    | optional,
  variations
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "name", "title" ],
        predicates.records.record
        {
          attributes = predicates.isType 'Record,
          category = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "text", "media", "design", "widgets", "theme", "embed" ]
              ],
          description = predicates.isType '"String",
          example = predicates.isType 'Record,
          icon = predicates.isType '"String",
          innerBlocks = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"Array")
              ],
          isActive = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          isDefault = predicates.isType '"Bool",
          keywords = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          name = predicates.isType '"String",
          scope = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.enum [ "inserter", "block", "transform" ])
              ],
          title = predicates.isType '"String",
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Block Variations is the API that allows a block to have similar versions of it, but all these versions share some common functionality.
    "%
    | optional,
  version
    | String
    | doc m%"
    The current version number of the block, such as 1.0 or 1.0.3. It’s similar to how plugins are versioned. This field might be used with block assets to control cache invalidation, and when the block author omits it, then the installed version of WordPress is used instead.
    "%
    | optional,
  viewScript
    | predicates.contract_from_predicate
    (predicates.oneOf
    [
      predicates.isType '"String",
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf (predicates.isType '"String")
      ]
    ])
    | doc m%"
    Block type frontend script definition. It will be enqueued only when viewing the content on the front of the site.
    "%
    | optional,
}