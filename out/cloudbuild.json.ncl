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
          ArtifactObjects
            | doc m%"
            Files in the workspace to upload to Cloud Storage upon successful
            completion of all build steps.
            "%
            = {
                location
                  | String
                  | doc m%"
                  Cloud Storage bucket and optional object path, in the form
                  "gs://bucket/path/to/somewhere/". (see [Bucket Name
                  Requirements](https://cloud.google.com/storage/docs/bucket-naming#requirements)).
                  
                  Files in the workspace matching any path pattern will be uploaded to
                  Cloud Storage with this location as a prefix.
                  "%
                  | optional,
                paths
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Path globs used to match files in the build's workspace.
                  "%
                  | optional,
                ..
              },
          Artifacts
            | doc m%"
            Artifacts produced by a build that should be uploaded upon
            successful completion of all build steps.
            "%
            = {
                images
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of images to be pushed upon the successful completion of all build
                  steps.
                  
                  The images will be pushed using the builder service account's credentials.
                  
                  The digests of the pushed images will be stored in the Build resource's
                  results field.
                  
                  If any of the images fail to be pushed, the build is marked FAILURE.
                  "%
                  | optional,
                objects
                  | definitions.contract.ArtifactObjects
                  | doc m%"
                  A list of objects to be uploaded to Cloud Storage upon successful
                  completion of all build steps.
                  
                  Files in the workspace matching specified paths globs will be uploaded to
                  the specified Cloud Storage location using the builder service account's
                  credentials.
                  
                  The location and generation of the uploaded objects will be stored in the
                  Build resource's results field.
                  
                  If any objects fail to be pushed, the build is marked FAILURE.
                  "%
                  | optional,
                ..
              },
          BuildOptions
            | doc m%"
            Optional arguments to enable specific features of builds.
            "%
            = {
                diskSizeGb
                  | String
                  | doc m%"
                  Requested disk size for the VM that runs the build. Note that this is *NOT*
                  "disk free"; some of the space will be used by the operating system and
                  build utilities. Also note that this is the minimum disk size that will be
                  allocated for the build -- the build may run with a larger disk than
                  requested. At present, the maximum disk size is 1000GB; builds that request
                  more than the maximum are rejected with an error.
                  "%
                  | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of global environment variable definitions that will exist for all
                  build steps in this build. If a variable is defined in both globally and in
                  a build step, the variable will use the build step value.
                  
                  The elements are of the form "KEY=VALUE" for the environment variable "KEY"
                  being given the value "VALUE".
                  "%
                  | optional,
                logStreamingOption
                  | std.enum.TagOrString
                  | [| 'STREAM_OFF, 'STREAM_ON, 'STREAM_DEFAULT |]
                  | doc m%"
                  Option to define build log streaming behavior to Google Cloud
                  Storage.
                  "%
                  | optional,
                logging
                  | std.enum.TagOrString
                  | [|
                    'NONE,
                    'CLOUD_LOGGING_ONLY,
                    'GCS_ONLY,
                    'LEGACY,
                    'LOGGING_UNSPECIFIED
                  |]
                  | doc m%"
                  Option to specify the logging mode, which determines where the logs are
                  stored.
                  "%
                  | optional,
                machineType
                  | std.enum.TagOrString
                  | [|
                    'UNSPECIFIED,
                    'N1_HIGHCPU_32,
                    'N1_HIGHCPU_8,
                    'E2_STANDARD_32,
                    'E2_STANDARD_16,
                    'E2_STANDARD_8,
                    'E2_STANDARD_4,
                    'E2_STANDARD_2,
                    'E2_MEDIUM,
                    'E2_HIGHMEM_16,
                    'E2_HIGHMEM_8,
                    'E2_HIGHMEM_4,
                    'E2_HIGHMEM_2,
                    'E2_HIGHCPU_32,
                    'E2_HIGHCPU_16,
                    'E2_HIGHCPU_8,
                    'E2_HIGHCPU_4,
                    'E2_HIGHCPU_2
                  |]
                  | doc m%"
                  Compute Engine machine type on which to run the build.
                  "%
                  | optional,
                requestedVerifyOption
                  | std.enum.TagOrString
                  | [| 'VERIFIED, 'NOT_VERIFIED |]
                  | doc m%"
                  Requested verifiability options.
                  "%
                  | optional,
                secretEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of global environment variables, which are encrypted using a Cloud
                  Key Management Service crypto key. These values must be specified in the
                  build's `Secret`. These variables will be available to all build steps
                  in this build.
                  "%
                  | optional,
                sourceProvenanceHash
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "NONE", "SHA256", "MD5" ]
                    ])
                  ])
                  | doc m%"
                  Requested hash for SourceProvenance.
                  "%
                  | optional,
                substitutionOption
                  | std.enum.TagOrString
                  | [| 'ALLOW_LOOSE, 'MUST_MATCH |]
                  | doc m%"
                  Option to specify behavior when there is an error in the substitution
                  checks.
                  "%
                  | optional,
                volumes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Volume
                  ])
                  | doc m%"
                  Global list of volumes to mount for ALL build steps
                  
                  Each volume is created as an empty volume prior to starting the build
                  process. Upon completion of the build, volumes and their contents are
                  discarded. Global volume names and paths cannot conflict with the volumes
                  defined a build step.
                  
                  Using a global volume in a build with only one step is not valid as
                  it is indicative of a build request with an incorrect configuration.
                  "%
                  | optional,
                workerPool
                  | String
                  | doc m%"
                  Option to specify a `WorkerPool` for the build. User specifies the pool
                  with the format "[WORKERPOOL_PROJECT_ID]/[WORKERPOOL_NAME]".
                  This is an experimental field.
                  "%
                  | optional,
                ..
              },
          BuildStep
            | doc m%"
            A step in the build pipeline.
            "%
            = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of arguments that will be presented to the step when it is started.
                  
                  If the image used to run the step's container has an entrypoint, the `args`
                  are used as arguments to that entrypoint. If the image does not define
                  an entrypoint, the first element in args is used as the entrypoint,
                  and the remainder will be used as arguments.
                  "%
                  | optional,
                dir
                  | String
                  | doc m%"
                  Working directory to use when running this step's container.
                  
                  If this value is a relative path, it is relative to the build's working
                  directory. If this value is absolute, it may be outside the build's working
                  directory, in which case the contents of the path may not be persisted
                  across build step executions, unless a `volume` for that path is specified.
                  
                  If the build specifies a `RepoSource` with `dir` and a step with a `dir`,
                  which specifies an absolute path, the `RepoSource` `dir` is ignored for
                  the step's execution.
                  "%
                  | optional,
                entrypoint
                  | String
                  | doc m%"
                  Entrypoint to be used instead of the build step image's default entrypoint.
                  If unset, the image's default entrypoint is used.
                  "%
                  | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of environment variable definitions to be used when running a step.
                  
                  The elements are of the form "KEY=VALUE" for the environment variable "KEY"
                  being given the value "VALUE".
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  Unique identifier for this build step, used in `wait_for` to
                  reference this build step as a dependency.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Required. The name of the container image that will run this particular
                  build step.
                  
                  If the image is available in the host's Docker daemon's cache, it
                  will be run directly. If not, the host will attempt to pull the image
                  first, using the builder service account's credentials if necessary.
                  
                  The Docker daemon's cache will already have the latest versions of all of
                  the officially supported build steps
                  ([https://github.com/GoogleCloudPlatform/cloud-builders](https://github.com/GoogleCloudPlatform/cloud-builders)).
                  The Docker daemon will also have cached many of the layers for some popular
                  images, like "ubuntu", "debian", but they will be refreshed at the time you
                  attempt to use them.
                  
                  If you built an image in a previous build step, it will be stored in the
                  host's Docker daemon's cache and is available to use as the name for a
                  later build step.
                  "%
                  | optional,
                secretEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of environment variables which are encrypted using a Cloud Key
                  Management Service crypto key. These values must be specified in the
                  build's `Secret`.
                  "%
                  | optional,
                timeout
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^\\d+(\\.\\d{0,9})?s$"
                  ])
                  | doc m%"
                  Time limit for executing this build step. If not defined, the step has no
                  time limit and will be allowed to continue to run until either it completes
                  or the build itself times out.
                  "%
                  | optional,
                volumes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Volume
                  ])
                  | doc m%"
                  List of volumes to mount into the build step.
                  
                  Each volume is created as an empty volume prior to execution of the
                  build step. Upon completion of the build, volumes and their contents are
                  discarded.
                  
                  Using a named volume in only one step is not valid as it is indicative
                  of a build request with an incorrect configuration.
                  "%
                  | optional,
                waitFor
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The ID(s) of the step(s) that this build step depends on.
                  This build step will not start until all the build steps in `wait_for`
                  have completed successfully. If `wait_for` is empty, this build step will
                  start when all previous build steps in the `Build.Steps` list have
                  completed successfully.
                  "%
                  | optional,
                ..
              },
          RepoSource
            | doc m%"
            Location of the source in a Google Cloud Source Repository.
            "%
            = {
                branchName
                  | String
                  | doc m%"
                  Name of the branch to build.
                  "%
                  | optional,
                commitSha
                  | String
                  | doc m%"
                  Explicit commit SHA to build.
                  "%
                  | optional,
                dir
                  | String
                  | doc m%"
                  Directory, relative to the source root, in which to run the build.
                  
                  This must be a relative path. If a step's `dir` is specified and is an
                  absolute path, this value is ignored for that step's execution.
                  "%
                  | optional,
                projectId
                  | String
                  | doc m%"
                  ID of the project that owns the Cloud Source Repository. If omitted, the
                  project ID requesting the build is assumed.
                  "%
                  | optional,
                repoName
                  | String
                  | doc m%"
                  Name of the Cloud Source Repository. If omitted, the name "default" is
                  assumed.
                  "%
                  | optional,
                tagName
                  | String
                  | doc m%"
                  Name of the tag to build.
                  "%
                  | optional,
                ..
              },
          Secret
            | doc m%"
            Pairs a set of secret environment variables containing encrypted
            values with the Cloud KMS key to use to decrypt the value.
            "%
            = {
                kmsKeyName
                  | String
                  | doc m%"
                  Cloud KMS key name to use to decrypt these envs.
                  "%
                  | optional,
                secretEnv
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Map of environment variable name to its encrypted value.
                  
                  Secret environment variables must be unique across all of a build's
                  secrets, and must be used by at least one build step. Values can be at most
                  64 KB in size. There can be at most 100 secret values across all of a
                  build's secrets.
                  "%
                  | optional,
                ..
              },
          Source
            | doc m%"
            Location of the source in a supported storage service.
            "%
            = {
                repoSource
                  | definitions.contract.RepoSource
                  | doc m%"
                  If provided, get the source from this location in a Cloud Source
                  Repository.
                  "%
                  | optional,
                storageSource
                  | definitions.contract.StorageSource
                  | doc m%"
                  If provided, get the source from this location in Google Cloud Storage.
                  "%
                  | optional,
                ..
              },
          StorageSource
            | doc m%"
            Location of the source in an archive file in Google Cloud Storage.
            "%
            = {
                bucket
                  | String
                  | doc m%"
                  Google Cloud Storage bucket containing the source (see
                  [Bucket Name
                  Requirements](https://cloud.google.com/storage/docs/bucket-naming#requirements)).
                  "%
                  | optional,
                generation
                  | String
                  | doc m%"
                  Google Cloud Storage generation for the object. If the generation is
                  omitted, the latest generation will be used.
                  "%
                  | optional,
                object
                  | String
                  | doc m%"
                  Google Cloud Storage object containing the source.
                  
                  This object must be a gzipped archive file (`.tar.gz`) containing source to
                  build.
                  "%
                  | optional,
                ..
              },
          Volume
            | doc m%"
            Volume describes a Docker container volume which is mounted into build steps
            in order to persist files across build step execution.
            "%
            = {
                name
                  | String
                  | doc m%"
                  Name of the volume to mount.
                  
                  Volume names must be unique per build step and must be valid names for
                  Docker volumes. Each named volume must be used by at least two build steps.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Path at which to mount the volume.
                  
                  Paths must be absolute and cannot conflict with other volume paths on the
                  same build step or with certain reserved volume paths.
                  "%
                  | optional,
                ..
              },
        },
    predicate = {
          ArtifactObjects
            | doc m%"
            Files in the workspace to upload to Cloud Storage upon successful
            completion of all build steps.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  location = predicates.isType '"String",
                  paths = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Artifacts
            | doc m%"
            Artifacts produced by a build that should be uploaded upon
            successful completion of all build steps.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  images = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  objects = definitions.predicate.ArtifactObjects,
                }
                {  }
                true
                predicates.always
              ],
          BuildOptions
            | doc m%"
            Optional arguments to enable specific features of builds.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  diskSizeGb = predicates.isType '"String",
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  logStreamingOption = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "STREAM_DEFAULT", "STREAM_ON", "STREAM_OFF" ]
                      ],
                  logging = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "LOGGING_UNSPECIFIED",
                          "LEGACY",
                          "GCS_ONLY",
                          "CLOUD_LOGGING_ONLY",
                          "NONE"
                        ]
                      ],
                  machineType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "E2_HIGHCPU_2",
                          "E2_HIGHCPU_4",
                          "E2_HIGHCPU_8",
                          "E2_HIGHCPU_16",
                          "E2_HIGHCPU_32",
                          "E2_HIGHMEM_2",
                          "E2_HIGHMEM_4",
                          "E2_HIGHMEM_8",
                          "E2_HIGHMEM_16",
                          "E2_MEDIUM",
                          "E2_STANDARD_2",
                          "E2_STANDARD_4",
                          "E2_STANDARD_8",
                          "E2_STANDARD_16",
                          "E2_STANDARD_32",
                          "N1_HIGHCPU_8",
                          "N1_HIGHCPU_32",
                          "UNSPECIFIED"
                        ]
                      ],
                  requestedVerifyOption = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "NOT_VERIFIED", "VERIFIED" ]
                      ],
                  secretEnv = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  sourceProvenanceHash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "NONE", "SHA256", "MD5" ]
                        ])
                      ],
                  substitutionOption = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "MUST_MATCH", "ALLOW_LOOSE" ]
                      ],
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Volume
                      ],
                  workerPool = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          BuildStep
            | doc m%"
            A step in the build pipeline.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  dir = predicates.isType '"String",
                  entrypoint = predicates.isType '"String",
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                  secretEnv = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  timeout = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^\\d+(\\.\\d{0,9})?s$"
                      ],
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Volume
                      ],
                  waitFor = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          RepoSource
            | doc m%"
            Location of the source in a Google Cloud Source Repository.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  branchName = predicates.isType '"String",
                  commitSha = predicates.isType '"String",
                  dir = predicates.isType '"String",
                  projectId = predicates.isType '"String",
                  repoName = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Secret
            | doc m%"
            Pairs a set of secret environment variables containing encrypted
            values with the Cloud KMS key to use to decrypt the value.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  kmsKeyName = predicates.isType '"String",
                  secretEnv = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Source
            | doc m%"
            Location of the source in a supported storage service.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  repoSource = definitions.predicate.RepoSource,
                  storageSource = definitions.predicate.StorageSource,
                }
                {  }
                true
                predicates.always
              ],
          StorageSource
            | doc m%"
            Location of the source in an archive file in Google Cloud Storage.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bucket = predicates.isType '"String",
                  generation = predicates.isType '"String",
                  object = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Volume
            | doc m%"
            Volume describes a Docker container volume which is mounted into build steps
            in order to persist files across build step execution.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  path = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

{
  artifacts
    | definitions.contract.Artifacts
    | doc m%"
    Artifacts produced by the build that should be uploaded upon
    successful completion of all build steps.
    "%
    | optional,
  images
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A list of images to be pushed upon the successful completion of all build
    steps.
    
    The images are pushed using the builder service account's credentials.
    
    The digests of the pushed images will be stored in the `Build` resource's
    results field.
    
    If any of the images fail to be pushed, the build status is marked
    `FAILURE`.
    "%
    | optional,
  logsBucket
    | String
    | doc m%"
    Google Cloud Storage bucket where logs should be written (see
    [Bucket Name
    Requirements](https://cloud.google.com/storage/docs/bucket-naming#requirements)).
    Logs file names will be of the format `${logs_bucket}/log-${build_id}.txt`.
    "%
    | optional,
  options
    | definitions.contract.BuildOptions
    | doc m%"
    Special options for this build.
    "%
    | optional,
  secrets
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.Secret
    ])
    | doc m%"
    Secrets to decrypt using Cloud Key Management Service.
    "%
    | optional,
  serviceAccount
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"String",
      predicates.strings.pattern "^projects/\\w+/serviceAccounts/\\w+$"
    ])
    | doc m%"
    Use this field to specify the IAM service account to use at build time.
    "%
    | optional,
  source
    | definitions.contract.Source
    | doc m%"
    The location of the source files to build.
    "%
    | optional,
  steps
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.BuildStep
    ])
    | doc m%"
    Required. The operations to be performed on the workspace.
    "%,
  substitutions
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true (predicates.isType '"String")
    ])
    | doc m%"
    Substitutions data for `Build` resource.
    "%
    | optional,
  tags
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Tags for annotation of a `Build`. These are not docker tags.
    "%
    | optional,
  timeout
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"String",
      predicates.strings.pattern "^\\d+(\\.\\d{0,9})?s$"
    ])
    | doc m%"
    Amount of time that this build should be allowed to run, to second
    granularity. If this amount of time elapses, work on the build will cease
    and the build status will be `TIMEOUT`.
    
    Default time is ten minutes.
    "%
    | optional,
  ..
}