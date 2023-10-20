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
          bs-dependency = String,
          bsc-flags = predicates.contract_from_predicate
              definitions.predicate.bsc-flags,
          build-generator
            | doc m%"
            Note that we will add the directory path accordingly
            "%
            = {
                edge
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                name | String | optional,
                ..
              },
          dependencies = predicates.contract_from_predicate
              definitions.predicate.dependencies,
          entries
            | doc m%"
            A list of buildable targets
            "%
            = predicates.contract_from_predicate definitions.predicate.entries,
          gentype-specs
            | doc m%"
            path to gentype, path resolution is similar to ReScript
            "%
            = { path | String | optional, .. },
          js-post-build = { cmd | String | optional, .. },
          jsx-specs = {
                mode
                  | std.enum.TagOrString
                  | [| 'automatic, 'classic |]
                  | doc m%"
                  JSX transformation mode
                  "%
                  | optional,
                module
                  | std.enum.TagOrString
                  | [| 'react |]
                  | doc m%"
                  JSX module, currently only support the React.
                  "%
                  | optional,
                v3-dependencies
                  | definitions.contract.dependencies
                  | doc m%"
                  Build the given dependencies in JSX V3 compatibility mode.
                  "%
                  | optional,
                version
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.enum [ 3, 4 ] ])
                  | doc m%"
                  Whether to apply the specific version of JSX PPX transformation
                  "%,
              },
          module-format
            | doc m%"
            es6-global generate relative `require` paths instead of relying on NodeJS' module resolution. Default: commonjs.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.module-format,
          module-format-object = {
                in-source
                  | Bool
                  | doc m%"
                  Default: false.
                  "%
                  | optional,
                module | definitions.contract.module-format,
                suffix | definitions.contract.suffix-spec | optional,
                ..
              },
          namespace-spec = predicates.contract_from_predicate
              definitions.predicate.namespace-spec,
          package-spec = predicates.contract_from_predicate
              definitions.predicate.package-spec,
          package-specs = predicates.contract_from_predicate
              definitions.predicate.package-specs,
          pp-specs = String,
          ppx-specs = predicates.contract_from_predicate
              definitions.predicate.ppx-specs,
          react-jsx-version
            | doc m%"
            backward compatible mode, true means on with the default to be version 1 (the default value is subject to change)
            "%
            = Number,
          reanalyze = {
                analysis
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.enum [ "dce", "exception", "termination" ])
                  ])
                  | doc m%"
                  The types of analysis to activate. `dce` means dead code analysis, `exception` means exception analysis, and `termination` is to check for infinite loops.
                  "%
                  | optional,
                suppress
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Paths for any folders you'd like to exclude from analysis. Useful for bindings and similar. Example: `["src/bindings"]`.
                  "%
                  | optional,
                transitive
                  | Bool
                  | doc m%"
                  specify whether transitively dead items should be reported (default: false)
                  "%
                  | optional,
                unsuppress
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Any specific paths inside suppressed folders that you want to unsuppress. Example: ["src/bindings/SomeBinding.res"].
                  "%
                  | optional,
              },
          reason-specs = {
                react-jsx
                  | definitions.contract.react-jsx-version
                  | doc m%"
                  Whether to apply the [RescriptReact](https://github.com/rescript-lang/rescript-react)-specific JSX PPX transformation.
                  "%
                  | optional,
                ..
              },
          rule-generator
            | doc m%"
            The shell command is running in *dev* time, and you generated could should be checked in, the depedency is tracked properly during dev time,example: `{ "name" : "ocamllex", "command" : "ocamllex.opt $in -o $out"}`
            "%
            = { command | String | optional, name | String | optional, .. },
          sourceItem = predicates.contract_from_predicate
              definitions.predicate.sourceItem,
          sources
            | doc m%"
            Example: `"src"` or `["src", "test"]` or `[{"dir": "src", "subdirs": [...]}]`
            "%
            = predicates.contract_from_predicate definitions.predicate.sources,
          suffix-spec
            | doc m%"
            suffix of generated js files, default to [.js] 
            "%
            = predicates.contract_from_predicate
              definitions.predicate.suffix-spec,
          targetItems = {
                kind
                  | predicates.contract_from_predicate
                  (predicates.enum [ "native", "bytecode", "js" ])
                  | doc m%"
                  The compiler to use for the target
                  "%
                  | optional,
                main
                  | String
                  | doc m%"
                  Name of the main module used as entry point for this target. 'entry-point' isn't used when this project is built as a dependency.
                  "%
                  | optional,
                ..
              },
        },
    predicate = {
          bs-dependency = predicates.isType '"String",
          bsc-flags = predicates.oneOf
              [
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
                    flags = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    kind = predicates.enum [ "reset", "prefix", "append" ],
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          build-generator
            | doc m%"
            Note that we will add the directory path accordingly
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  edge = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dependencies = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.bs-dependency
              ],
          entries
            | doc m%"
            A list of buildable targets
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.targetItems
              ],
          gentype-specs
            | doc m%"
            path to gentype, path resolution is similar to ReScript
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { path = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          js-post-build = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record { cmd = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          jsx-specs = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "version" ],
                predicates.records.record
                {
                  mode = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "classic", "automatic" ]
                      ],
                  module = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "react" ]
                      ],
                  v3-dependencies = definitions.predicate.dependencies,
                  version = predicates.allOf
                      [ predicates.isType '"Number", predicates.enum [ 3, 4 ] ],
                }
                {  }
                false
                predicates.never
              ],
          module-format
            | doc m%"
            es6-global generate relative `require` paths instead of relying on NodeJS' module resolution. Default: commonjs.
            "%
            = predicates.enum [ "commonjs", "es6", "es6-global" ],
          module-format-object = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "module" ],
                predicates.records.record
                {
                  in-source = predicates.isType '"Bool",
                  module = definitions.predicate.module-format,
                  suffix = definitions.predicate.suffix-spec,
                }
                {  }
                true
                predicates.always
              ],
          namespace-spec = predicates.oneOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
          package-spec = predicates.oneOf
              [
                definitions.predicate.module-format,
                definitions.predicate.module-format-object
              ],
          package-specs = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.package-spec
                ],
                definitions.predicate.package-spec
              ],
          pp-specs = predicates.isType '"String",
          ppx-specs = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.oneOf
                [
                  predicates.isType '"String",
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]
                ])
              ],
          react-jsx-version
            | doc m%"
            backward compatible mode, true means on with the default to be version 1 (the default value is subject to change)
            "%
            = predicates.isType '"Number",
          reanalyze = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  analysis = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.enum [ "dce", "exception", "termination" ])
                      ],
                  suppress = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  transitive = predicates.isType '"Bool",
                  unsuppress = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          reason-specs = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { react-jsx = definitions.predicate.react-jsx-version, }
                {  }
                true
                predicates.always
              ],
          rule-generator
            | doc m%"
            The shell command is running in *dev* time, and you generated could should be checked in, the depedency is tracked properly during dev time,example: `{ "name" : "ocamllex", "command" : "ocamllex.opt $in -o $out"}`
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  command = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          sourceItem = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "dir" ],
                  predicates.records.record
                  {
                    dir = predicates.isType '"String",
                    files = predicates.oneOf
                        [
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
                              excludes = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                              slow-re = predicates.isType '"String",
                            }
                            {  }
                            true
                            predicates.always
                          ]
                        ],
                    generators = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.build-generator
                        ],
                    group = predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              hierachy = predicates.isType '"Bool",
                              name = predicates.isType '"String",
                            }
                            {  }
                            true
                            predicates.always
                          ]
                        ],
                    internal-depends = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    public = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                          predicates.enum [ "all" ]
                        ],
                    resources = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    subdirs = predicates.oneOf
                        [
                          definitions.predicate.sources,
                          predicates.isType '"Bool"
                        ],
                    type = predicates.enum [ "dev" ],
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.isType '"String"
              ],
          sources
            | doc m%"
            Example: `"src"` or `["src", "test"]` or `[{"dir": "src", "subdirs": [...]}]`
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.sourceItem
                ],
                definitions.predicate.sourceItem
              ],
          suffix-spec
            | doc m%"
            suffix of generated js files, default to [.js] 
            "%
            = predicates.enum
              [ ".js", ".mjs", ".cjs", ".bs.js", ".bs.mjs", ".bs.cjs" ],
          targetItems = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  kind = predicates.enum [ "native", "bytecode", "js" ],
                  main = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

{
  bs-dependencies
    | definitions.contract.dependencies
    | doc m%"
    ReScript dependencies of the library, like in package.json. Currently searches in `node_modules`
    "%
    | optional,
  bs-dev-dependencies
    | definitions.contract.dependencies
    | doc m%"
    ReScript dev dependencies of the library, like in package.json. Currently searches in `node_modules`
    "%
    | optional,
  bs-external-includes
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    (Not needed usually) external include directories, which will be applied `-I` to all compilation units
    "%
    | optional,
  bsc-flags
    | definitions.contract.bsc-flags
    | doc m%"
    Flags passed to bsc.exe
    "%
    | optional,
  cut-generators
    | Bool
    | doc m%"
    Ignore generators, cut the dependency on generator tools
    "%
    | optional,
  entries
    | definitions.contract.entries
    | doc m%"
    (internal) Used by bsb to build to different targets: native (ocamlopt), bytecode (ocamlc) or JS (bsc)
    "%
    | optional,
  external-stdlib
    | String
    | doc m%"
    Use the external stdlib library instead of the one shipped with the compiler package
    "%
    | optional,
  generators
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.rule-generator
    ])
    | doc m%"
    (WIP) Pre defined rules
    "%
    | optional,
  gentypeconfig
    | definitions.contract.gentype-specs
    | doc m%"
    gentype config, see cristianoc/genType for more details
    "%
    | optional,
  ignored-dirs
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    a list of directories that bsb will not look into
    "%
    | optional,
  js-post-build
    | definitions.contract.js-post-build
    | doc m%"
    (Experimental) post-processing hook. bsb will invoke `cmd ${file}` whenever a `${file}` is changed
    "%
    | optional,
  jsx
    | definitions.contract.jsx-specs
    | doc m%"
    Configuration for the JSX transformation.
    "%
    | optional,
  name
    | String
    | doc m%"
    Package name
    "%,
  namespace
    | definitions.contract.namespace-spec
    | doc m%"
    can be true/false or a customized name
    "%
    | optional,
  package-specs
    | definitions.contract.package-specs
    | doc m%"
    ReScript can currently output to [Commonjs](https://en.wikipedia.org/wiki/CommonJS), and [ES6 modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import)
    "%
    | optional,
  pinned-dependencies
    | definitions.contract.dependencies
    | doc m%"
    Those dependencies are pinned (since version 8.4)
    "%
    | optional,
  pp-flags
    | definitions.contract.pp-specs
    | doc m%"
    preprocessors to pass to compiler. The syntax is package_name/binary, for example: `pp/syntax.exe`. Currenly searches in `node_modules`
    "%
    | optional,
  ppx-flags
    | definitions.contract.ppx-specs
    | doc m%"
    PPX macros to pass to compiler. The syntax is package_name/binary, for example: `reason/reactjs_jsx_ppx_3.native`. Currenly searches in `node_modules`
    "%
    | optional,
  reanalyze
    | definitions.contract.reanalyze
    | doc m%"
    Configure reanalyze, a static code analysis tool for ReScript.
    "%
    | optional,
  reason
    | definitions.contract.reason-specs
    | doc m%"
    ReScript comes with [Reason](http://reasonml.github.io/) by default. Specific configurations here.
    "%
    | optional,
  sources
    | definitions.contract.sources
    | doc m%"
    Source code location
    "%,
  suffix | definitions.contract.suffix-spec | optional,
  uncurried
    | Bool
    | doc m%"
    Configuration for the uncurried mode.
    "%
    | optional,
  use-stdlib
    | Bool
    | doc m%"
    (Experimental) whether to use the OCaml standard library. Default: true
    "%
    | optional,
  version
    | String
    | doc m%"
    The semantic version of the ReScript library
    "%
    | optional,
  warnings
    | {
      error
        | predicates.contract_from_predicate
        (predicates.oneOf
        [ predicates.isType '"Bool", predicates.isType '"String" ])
        | optional,
      number
        | String
        | doc m%"
        Default: -40+6+7+27+32..39+44+45 [Here](https://caml.inria.fr/pub/docs/manual-ocaml/comp.html#sec270) for the meanings of the warning flags
        "%
        | optional,
      ..
    }
    | doc m%"
    warning numbers and whether to turn it into error or not
    "%
    | optional,
}