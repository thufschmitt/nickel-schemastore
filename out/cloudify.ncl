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
          ansiblePlaybookConfig = {
                additional_args
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Additional args that you want to use, for example, '-c local'.
                  "%
                  | optional,
                additional_playbook_files
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of string paths blueprint resources that you
                  would like to download to the playbook directory.
                  If you use this variable, you must list all of the paths
                  that you expect to download.
                  "%
                  | optional,
                ansible_become
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  A boolean value, `true` or `false` whether
                  to assume the user privileges.
                  "%
                  | optional,
                ansible_env_vars
                  | {
                    ANSIBLE_HOST_KEY_CHECKING | Bool | optional,
                    ANSIBLE_INVALID_TASK_ATTRIBUTE_FAILED | Bool | optional,
                    ..
                  }
                  | doc m%"
                  A dictionary of environment variables to set.
                  "%
                  | optional,
                ansible_playbook_executable_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  A full path to your ansible_playbook executable if user don't want to
                  use the included version of executable in the plugin
                  "%
                  | optional,
                debug_level
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Debug level
                  "%
                  | optional,
                options_config
                  | {  .. }
                  | doc m%"
                  Command-line options, such as `tags` or `skip_tags`.
                  "%
                  | optional,
                playbook_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  A path to your `site.yaml` or `main.yaml` in your
                  Ansible Playbook relative to blueprint or playbook_source_path
                  if playbook_source_path is URL to archive File relative inside the archive.
                  "%
                  | optional,
                playbook_source_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  A full path/URL that contain playbook specified in playbook_path
                  or site_yaml_path.
                  "%
                  | optional,
                remerge_sources
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  update sources on target node
                  "%
                  | optional,
                run_data
                  | {  .. }
                  | doc m%"
                  Variable values.
                  "%
                  | optional,
                save_playbook
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Save playbook after action
                  "%
                  | optional,
                scp_extra_args
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specify extra arguments to pass to scp only (e.g. -l)
                  "%
                  | optional,
                sensitive_keys
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  keys that you want us to obscure
                  "%
                  | optional,
                sftp_extra_args
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specify extra arguments to pass to sftp only (e.g. -f, -l)
                  "%
                  | optional,
                site_yaml_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  DEPRECATED.
                  A path to your `site.yaml` or `main.yaml` in your
                  Ansible Playbook relative to blueprint or playbook_source_path
                  if playbook_source_path is URL to archive File relative inside the archive.
                  "%
                  | optional,
                sources
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Your Inventory sources. Either YAML or a path to a file.
                  If not provided the inventory will be take from the `sources`
                  runtime property.
                  "%
                  | optional,
                ssh_common_args
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                ssh_extra_args
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specify extra arguments to pass to ssh only (e.g. -R)
                  "%
                  | optional,
                start_at_task
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Start the playbook at the task matching this name
                  "%
                  | optional,
                timeout
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Override the connection timeout in seconds (default=10)
                  "%
                  | optional,
                ..
              },
          ansiblePlaybookInputs = {
                additional_args | String | optional,
                ansible_env_vars | String | optional,
                ansible_playbook_executable_path
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Record ])
                  | optional,
                debug_level | String | optional,
                options_config | String | optional,
                playbook_path | String | optional,
                playbook_source_path
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Record ])
                  | optional,
                remerge_sources | String | optional,
                run_data | String | optional,
                save_playbook | String | optional,
                scp_extra_args | String | optional,
                sensitive_keys | String | optional,
                sftp_extra_args | String | optional,
                site_yaml_path | String | optional,
                sources | String | optional,
                ssh_common_args | String | optional,
                ssh_extra_args | String | optional,
                start_at_task | String | optional,
                timeout | String | optional,
                ..
              },
          awsClientConfig = {
                aws_access_key_id
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                aws_secret_access_key
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                region_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                ..
              },
          awsConnectionConfig
            | doc m%"
            A dictionary of values to pass to authenticate with the AWS API.
            "%
            = {
                aws_access_key_id
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The ID of your AWS ACCESS KEY ID.
                  "%
                  | optional,
                aws_secret_access_key
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The ID of your AWS SECRET ACCESS KEY.
                  "%
                  | optional,
                region_name
                  | definitions.contract.cloudifyGetStringOrAwsRegion
                  | optional,
                ..
              },
          awsRegion = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'us-gov-west-1,
                  'us-gov-east-1,
                  'sa-east-1,
                  'me-south-1,
                  'eu-north-1,
                  'eu-west-3,
                  'eu-south-1,
                  'eu-west-2,
                  'eu-west-1,
                  'eu-central-1,
                  'cn-northwest-1,
                  'cn-north-1,
                  'ca-central-1,
                  'ap-southeast-2,
                  'ap-northeast-1,
                  'ap-northeast-3,
                  'ap-northeast-2,
                  'ap-southeast-1,
                  'ap-south-1,
                  'ap-east-1,
                  'af-south-1,
                  'us-west-2,
                  'us-west-1,
                  'us-east-2,
                  'us-east-1
                |]
              ],
          awsResourceId
            | doc m%"
            The AWS resource ID of the external resource, if
            use_external_resource is true. Otherwise it is an empty string.
            "%
            = String,
          cloudifyBooleanOrGetInput = predicates.contract_from_predicate
              definitions.predicate.cloudifyBooleanOrGetInput,
          cloudifyDataTypesAgentConfig
            | doc m%"
            Cloudify agent configuration schema.
            "%
            = {
                disable_requiretty
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  For linux based agents, disables the requiretty setting in the sudoers file. By default, this value will be true.
                  "%
                  | optional,
                env
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  Optional environment variables that the agent will be started with. (type: dictionary)
                  "%
                  | optional,
                extra
                  | {  .. }
                  | doc m%"
                  Optional additional low level configuration details. (type: dictionary)
                  "%
                  | optional,
                heartbeat
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  The interval of the AMQP heartbeats in seconds
                  Note: the AMQP heartbeat is only used on Linux.
                  "%
                  | optional,
                install_method
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies how (and if) the cloudify agent should be installed.
                  Valid values are:
                  * none - No agent will be installed on the host.
                  * remote - An agent will be installed using SSH on linux hosts and WinRM on windows hosts.
                  * init_script - An agent will be installed via a script that will run on the host when it gets created.
                                  This method is only supported for specific IaaS plugins.
                  * plugin - An agent will be installed via a plugin which will run a script on the host.
                            This method is only supported for specific IaaS plugins.
                  * provided - An agent is assumed to already be installed on the host image.
                              That agent will be configured and started via a script that will run on the host when it gets created.
                              This method is only supported for specific IaaS plugins.
                  "%,
                key
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  For host agents that are installed via SSH, this is the path to the private
                  key that will be used to connect to the host.
                  In most cases, this value will be derived automatically during bootstrap.
                  "%
                  | optional,
                max_workers
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Maximum number of agent workers. By default, the value will be 5.
                  "%
                  | optional,
                min_workers
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Minimum number of agent workers. By default, the value will be 0.
                  Note: For windows based agents, this property is ignored and min_workers is set to the value of max_workers.
                  "%
                  | optional,
                network
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The name of the manager network to which the agent should be
                  connected. By default, the value will be `default` (which is the
                  manager's private IP, by default)
                  "%
                  | optional,
                password
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  For host agents that are installed via SSH (on linux) and WinRM (on windows)
                  this property can be used to connect to the host.
                  For linux hosts, this property is optional in case the key property is properly configured
                  (either explicitly or implicitly during bootstrap).
                  For windows hosts that are installed via WinRM, this property is also optional
                  and depends on whether the password runtime property has been set by the relevant IaaS plugin,
                  prior to the agent installation.
                  "%
                  | optional,
                port
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  For host agents that are installed via SSH (on linux) and WinRM (on windows),
                  this is the port used to connect to the host.
                  The default values are 22 for linux hosts and 5985 for windows hosts.
                  "%
                  | optional,
                process_management
                  | {  .. }
                  | doc m%"
                  Process management specific configuration. (type: dictionary)
                  "%
                  | optional,
                service_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Used to set the the cloudify agent service name.
                  
                  If not set, the default value for the service name is:
                  - Linux: 'cloudify-worker-<id>'
                  - Windows: '<id>'
                  
                  where 'id' is the instance id of the compute node in which the agent is running.
                  
                  Note: the value in this field, takes precedence over the deprecated
                  'cloudify.nodes.Compute.cloudify_agent.name'.
                  "%
                  | optional,
                user
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  For host agents, the agent will be installed for this user.
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesAzureComputeAvailabilitySetConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163607.aspx
            "%
            = {
                platformFaultDomainCount
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | optional,
                platformUpdateDomainCount
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | optional,
                sku
                  | {  .. }
                  | doc m%"
                  dict to represent sku [for now we only provide name]
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesAzureComputeManagedClusterConfig
            | doc m%"
            See https://docs.microsoft.com/en-us/rest/api/aks/managedclusters
            "%
            = {
                addon_profiles
                  | {  .. }
                  | doc m%"
                  A dict to define addons to the managed cluster
                  "%
                  | optional,
                agent_pool_profiles
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          availabilityZones = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          count = predicates.isType '"Number",
                          enableNodePublicIP = predicates.isType '"Bool",
                          name = predicates.isType 'Record,
                          osType = predicates.isType '"String",
                          vmSize = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ]
                    ])
                  ])
                  | doc m%"
                  An array to pass an array of dict for agent profile
                  "%
                  | optional,
                dns_prefix
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                enable_rbac
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | optional,
                kubernetes_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                linux_profile
                  | {  .. }
                  | doc m%"
                  A dict to define linux profile with user name and public keys
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                network_profile
                  | {  .. }
                  | doc m%"
                  A dict to define network profile loadbalancer,outbound,IPs
                  "%
                  | optional,
                service_principal_profile
                  | {  .. }
                  | doc m%"
                  A dict to define service service_principal_profile [client_id, secret]
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  A dict containing resource tags
                  "%
                  | optional,
                windows_profile
                  | {  .. }
                  | doc m%"
                  A dict to define windows profile with user name and password
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesAzureComputeVirtualMachineConfig
            | doc m%"
            https://msdn.microsoft.com/en-us/library/azure/mt163591.aspx
            "%
            = {
                hardwareProfile
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                osProfile | {  .. } | optional,
                spot_instance
                  | definitions.contract.cloudifyDatatypesAzureComputeVirtualMachineSpotConfig
                  | optional,
                storageProfile
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                ..
              },
          cloudifyDatatypesAzureComputeVirtualMachineSpotConfig
            | doc m%"
            check the parameters from this link : https://www.shorturl.at/wHTU2
            "%
            = {
                billing_profile | {  .. } | optional,
                eviction_policy
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  the only supported value is 'Deallocate'
                  "%
                  | optional,
                is_spot_instance
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  set true if you want to consider spot instance params
                  "%
                  | optional,
                "priority"
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Possible values include: 'Regular', 'Low', 'Spot'
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesAzureConfig = {
                certificate
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Certificate private key.
                  "%
                  | optional,
                client_id
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  A Microsoft Azure client ID. This can be found in
                  the Azure Active Directory dashboard by accessing
                  your directory. View the Applications tab and select
                  the application used to access Azure APIs.  Your
                  client ID can be found by expanding the ACCESS WEB
                  APIS IN OTHER APPLICATIONS tab.
                  "%
                  | optional,
                client_secret
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  A Microsoft Azure client secret key. This can be found
                  or generated in the same location as your client ID.
                  "%
                  | optional,
                cloud_environment
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  An alternative cloud environment.
                  "%
                  | optional,
                endpoint_resource
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  A Microsoft Azure Active Directory Resource Id.
                  "%
                  | optional,
                endpoint_verify
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Connection certificate verify.
                  "%
                  | optional,
                endpoints_active_directory
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  A Microsoft Azure Active Directory endpoint.
                  "%
                  | optional,
                endpoints_resource_manager
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  A Microsoft Azure Active Directory Resource Manager.
                  "%
                  | optional,
                scale_name_separator
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  When scaling resources, a unique name must be sent to
                  the Azure API. Since names are left to the user to
                  manage (the service does not generate unique IDs),
                  this plugin will attempt to append characters or
                  numbers to the end of the resource name when resources
                  are scaled out. This value should be a character, or
                  characters, that will separate the base name from the
                  generated unique characters.  For instance, if the
                  base name of a resource is "myvm", the separator is
                  set to "_", and a scale workflow attempts to create
                  another resource, the resulting name could be
                  something like "myvm_1". This field can be left blank.
                  "%
                  | optional,
                scale_name_suffix_chars
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  A string of characters (ASCII) to be used when
                  generating unique suffix data when scaling resources.
                  See "scale_name_separator" for more information.
                  "%
                  | optional,
                subscription_id
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  A Microsoft Azure subscription ID. This is a unique
                  user account in Azure. This can be found in the
                  Subscriptions tab on your dashboard.
                  "%
                  | optional,
                tenant_id
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  A Microsoft Azure tenant ID. This can be found in the Azure Active Directory dashboard by accessing
                  your directory. Open the Application Endpoints
                  dialog and your tenant ID will be in the URL for
                  the OAUTH2.0 TOKEN ENDPOINT.
                  "%
                  | optional,
                thumbprint
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Certificate thumbprint.
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesAzureNetworkIPConfigurationConfig = {
                privateIPAddress
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Static, private IP Address
                  "%
                  | optional,
                privateIPAllocationMethod
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Defines how a private IP address is assigned. Options
                  are Static or Dynamic
                  "%,
                ..
              },
          cloudifyDatatypesAzureNetworkLoadBalancerConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163574.aspx
            "%
            = {
                backendAddressPools
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                frontendIPConfigurations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                inboundNatRules
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                loadBalancingRules
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                probes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                ..
              },
          cloudifyDatatypesAzureNetworkLoadBalancerIncomingNATRuleConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163574.aspx
            "%
            = {
                backendPort | definitions.contract.cloudifyIntegerOrGetInput,
                frontendPort | definitions.contract.cloudifyIntegerOrGetInput,
                protocol | definitions.contract.cloudifyStringOrGetInput,
                ..
              },
          cloudifyDatatypesAzureNetworkLoadBalancerProbeConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163574.aspx
            "%
            = {
                intervalInSeconds
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | optional,
                numberOfProbes
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | optional,
                port | definitions.contract.cloudifyIntegerOrGetInput,
                protocol
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                requestPath
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                ..
              },
          cloudifyDatatypesAzureNetworkLoadBalancerRuleConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163574.aspx
            "%
            = {
                backendPort | definitions.contract.cloudifyIntegerOrGetInput,
                enableFloatingIP
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | optional,
                frontendPort | definitions.contract.cloudifyIntegerOrGetInput,
                idleTimeoutInMinutes
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | optional,
                loadDistribution
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                protocol | definitions.contract.cloudifyStringOrGetInput,
                ..
              },
          cloudifyDatatypesAzureNetworkNetworkInterfaceCardConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163668.aspx
            "%
            = {
                dnsSettings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                ipConfigurations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                networkSecurityGroups
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                ..
              },
          cloudifyDatatypesAzureNetworkNetworkSecurityGroupConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163656.aspx
            "%
            = {
                securityRules
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType 'Record,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType 'Record)
                    ]
                  ])
                  | optional,
                ..
              },
          cloudifyDatatypesAzureNetworkNetworkSecurityRuleConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163645.aspx
            "%
            = {
                access | definitions.contract.cloudifyStringOrGetInput,
                description
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                destinationAddressPrefix
                  | definitions.contract.cloudifyStringOrGetInput,
                destinationPortRange
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                direction | definitions.contract.cloudifyStringOrGetInput,
                "priority" | definitions.contract.cloudifyIntegerOrGetInput,
                protocol | definitions.contract.cloudifyStringOrGetInput,
                sourceAddressPrefix
                  | definitions.contract.cloudifyStringOrGetInput,
                sourcePortRange
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                ..
              },
          cloudifyDatatypesAzureNetworkPublicIPAddressConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163590.aspx
            "%
            = {
                domainNameLabel
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The concatenation of the domain name label and the regionalized
                  DNS zone make up the fully qualified domain name associated
                  with the public IP address.
                  "%
                  | optional,
                idleTimeoutInMinutes
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Specifies the timeout (in minutes) for the TCP idle connection.
                  The value can be set between 4 and 30 minutes
                  "%
                  | optional,
                publicIPAllocationMethod
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Defines whether the IP address is stable or dynamic.
                  Options are Static or Dynamic
                  "%,
                reverseFqdn
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  A fully qualified domain name that resolves to this
                  public IP address.
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesAzureNetworkRouteConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt459110.aspx
            "%
            = {
                addressPrefix
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType 'Record ]),
                nextHopIpAddress | String | optional,
                nextHopType | String,
                ..
              },
          cloudifyDatatypesAzureNetworkRouteTableConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt502548.aspx
            "%
            = {
                routes
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                ..
              },
          cloudifyDatatypesAzureNetworkSubnetConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163621.aspx
            "%
            = {
                addressPrefix
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                networkSecurityGroup
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | optional,
                routeTable
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | optional,
                ..
              },
          cloudifyDatatypesAzureNetworkVirtualNetworkConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163661.aspx
            "%
            = {
                addressSpace | {  .. },
                dhcpOptions | {  .. } | optional,
                subnets | {  .. } | optional,
                ..
              },
          cloudifyDatatypesAzureStorageDataDiskConfig = {
                container_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Container for the resource.
                  "%
                  | optional,
                force_delete
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  If set to true, the resource's "delete" lifecycle will purge the
                  Azure Data Disk from the Azure Storage Account. If false, the
                  Data Disk is left as-is in the Storage Account.
                  "%
                  | optional,
                size
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Size of the Page Blob (Azure disk) in GiB. Maximum of 1023 GiB allowed.
                  "%,
                ..
              },
          cloudifyDatatypesAzureStorageFileShareConfig = {
                fail_on_exist
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  If true, causes the operation to raise a NonRecoverableError if
                  the file share already exists. If false, issues a warning and
                  continues execution.
                  "%
                  | optional,
                metadata
                  | {  .. }
                  | doc m%"
                  Metadata (dict) for the File Share
                  "%
                  | optional,
                quota
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Quote, in GiB, for the maximum size of the file share
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesAzureStorageStorageAccountConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163564.aspx
            "%
            = {
                accountType
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  An storage account type (case sensitive)
                  "%
                  | optional,
                encryption | {  .. } | optional,
                keySource | {  .. } | optional,
                networkAcls | {  .. } | optional,
                supportsHttpsTrafficOnly | {  .. } | optional,
                ..
              },
          cloudifyDatatypesBlueprint = {
                blueprint_archive
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The URL of a .zip to upload to the manager.(Can be skipped if external_resource == True)
                  "%
                  | optional,
                external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Use external resource.
                  "%
                  | optional,
                id
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  This is the blueprint that the deployment node is a proxy to.
                  "%
                  | optional,
                main_file_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The application blueprint filename. If the blueprint consists many
                  imported files this is the main blueprint.
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesDeployment = {
                all_outputs
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Ignored if "outputs" is specified.
                  Otherwise, if true (the default), then all outputs from the remote
                  deployment are exposed. If false, then no output is exposed.
                  "%
                  | optional,
                external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Use external resource.
                  "%
                  | optional,
                id
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  This is the deployment that the node is a proxy to.
                  "%
                  | optional,
                inputs
                  | {  .. }
                  | doc m%"
                  The inputs to the deployment.
                  "%
                  | optional,
                logs
                  | {  .. }
                  | doc m%"
                  Logs redirect settings, by default {redirect: true}
                  "%
                  | optional,
                outputs
                  | {  .. }
                  | doc m%"
                  A dictionary of "{ key: value, key: value }".
                  Get "key" the deployment.
                  Set "value" runtime property to the value of the output.
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesDeploymentProxy = {
                blueprint | definitions.contract.cloudifyDatatypesBlueprint,
                deployment | definitions.contract.cloudifyDatatypesDeployment,
                executions_start_args
                  | {  .. }
                  | doc m%"
                  Optional params for executions
                  "%
                  | optional,
                reexecute
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Reexecute workflows, on external deployment
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesFile = {
                allow_failure
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  If the download fails, log the error and continue.
                  "%
                  | optional,
                file_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The path on the machine where the file should be saved.
                  "%,
                mode
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  The file permissions, such as 777. Must be provided as an integer.
                  "0777" and 0777 are not valid. Only 777.
                  "%,
                owner
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The owner string, such as "centos:wheel"
                  "%,
                resource_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The path relative to the blueprint where the file is stored.
                  Currently this must be packaged in the blueprint. An external URI is
                  not valid.
                  "%,
                template_variables
                  | {  .. }
                  | doc m%"
                  Variables to render Jinja templates.
                  "%
                  | optional,
                use_sudo
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Whether or not to use sudo to move, rename, delete, chown, chmod,
                  the file.
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesFtpAuth = {
                ignore_host
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  optional, ignore host in ftp response
                  "%
                  | optional,
                ip
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  optional, device ip
                  "%
                  | optional,
                password
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  optional, ftp password
                  "%
                  | optional,
                port
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  optional, ftp port
                  "%
                  | optional,
                tls
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  optional, use tls connection to ftp
                  "%
                  | optional,
                user
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The login credentials for ftp server.
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesHelmApiOptions = {
                api_key
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Bearer token used for authentication.
                  "%
                  | optional,
                host
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  HTTP/HTTPS URL to Kubernetes API.
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesHelmAuthenticationVariant
            | doc m%"
            Type representing all authentication variants.
             for different Kubernetes cloud providers.
             Each property represents separate supported variant of authentication.
             You should choose one variant and fill in only on property.
            "%
            = {
                gcp_service_account
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                   (JSON) Content of Google Cloud Platform Service Account file.
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesHelmClientConfig
            | doc m%"
            Configuration properties for Helm to interact with kubernetes cluster.
             If kube_config file not provided then kube_token and kube_api_server should provided.
            "%
            = {
                authentication
                  | definitions.contract.cloudifyDatatypesHelmAuthenticationVariant
                  | optional,
                configuration
                  | definitions.contract.cloudifyDatatypesHelmConfigurationVariant
                  | optional,
                ..
              },
          cloudifyDatatypesHelmConfig = {
                executable_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Helm binary path.
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesHelmConfigurationVariant
            | doc m%"
            Type representing all Kubernetes API configuration variants. Each property represents separate supported variant of configuration. For now, until Helm support "--insecure" one of "blueprint_file_name",
                  "manager_file_path" and "file_content" must be used.
                  "api_key" inputs will override kubeconfig data.
            "%
            = {
                api_options
                  | definitions.contract.cloudifyDatatypesHelmApiOptions
                  | doc m%"
                  Set of basic properties describing Kubernetes API access.
                  "%
                  | optional,
                blueprint_file_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of Kubernetes configuration file attached to blueprint(path).
                  "%
                  | optional,
                file_content
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Content (YAML) of Kubernetes configuration file. kubeconfig string or dict are supported. 
                  "%
                  | optional,
                manager_file_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Path to Kubernetes configuration file placed on Cloudify Manager VM.
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesHelmReleaseConfig
            | doc m%"
            configuration properties for release node type.
            "%
            = {
                chart
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the chart to install.For example: stable/mysql.
                  "%,
                flags
                  | definitions.contract.cloudifyDatatypesHelmSetFlagsList
                  | doc m%"
                  List of flags add to both "helm install" and "helm uninstall" commands.
                            For example:
                            - name: namespace
                              value: my_namespace
                            If the flag not requires value, omit "value" and specify only the name as element in the list.
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the created release.
                  "%,
                set_values
                  | definitions.contract.cloudifyDatatypesHelmSetFlagsList
                  | doc m%"
                   List of variables names and values to set. For example:
                            - name: x
                              value: y
                            - name: a
                              value: b
                            It equals to --set x=y --set a=b in helm command.
                  "%
                  | optional,
                values_file
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Path to values files.
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesHelmRepoConfig
            | doc m%"
            configuration properties for repo node type.
            "%
            = {
                flags
                  | definitions.contract.cloudifyDatatypesHelmSetFlagsList
                  | doc m%"
                  List of flags add to both "helm repo add" and "helm repo remove" commands.
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the repo that added/removed.
                  "%,
                repo_url
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  URL of the repo to add.
                  "%,
                ..
              },
          cloudifyDatatypesHelmSetFlagsList = predicates.contract_from_predicate
              definitions.predicate.cloudifyDatatypesHelmSetFlagsList,
          cloudifyDatatypesKey = {
                algorithm
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                bits
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | optional,
                comment
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                key_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                openssh_format
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | optional,
                passphrase
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                private_key_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                public_key_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                unvalidated
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  Unvalidated parameters.
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesNode = {
                id | definitions.contract.cloudifyStringOrGetInput | optional,
                ..
              },
          cloudifyDatatypesNodeInstance = {
                id | definitions.contract.cloudifyStringOrGetInput | optional,
                node | definitions.contract.cloudifyDatatypesNode | optional,
                ..
              },
          cloudifyDatatypesNodeInstanceProxy = {
                blueprint | definitions.contract.cloudifyDatatypesBlueprint,
                deployment | definitions.contract.cloudifyDatatypesDeployment,
                executions_start_args
                  | {  .. }
                  | doc m%"
                  Optional params for executions
                  "%
                  | optional,
                node_instance
                  | definitions.contract.cloudifyDatatypesNodeInstance
                  | optional,
                reexecute
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Reexecute workflows, on external deployment
                  "%
                  | optional,
                ..
              },
          cloudifyDatatypesTerminalAuth = {
                criticals
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  optional, list of possible criticals without new line
                  "%
                  | optional,
                errors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  optional, list of possible errors without new line
                  "%
                  | optional,
                exit_command
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  optional, command for close connection, default 'exit'
                  "%
                  | optional,
                ip
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  optional, device ip
                  "%
                  | optional,
                key_content
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  optional, ssh user key
                  "%
                  | optional,
                password
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  optional, ssh password
                  "%
                  | optional,
                port
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  optional, ssh port
                  "%
                  | optional,
                promt_check
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  optional, list of prompts accepted from device, default is "#/$"
                  "%
                  | optional,
                smart_device
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  optional, use shell extension
                  "%
                  | optional,
                store_logs
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  optional, save communication logs
                  "%
                  | optional,
                user
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The login credentials for ssh server.
                  "%
                  | optional,
                warnings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  optional, list of possible warnings without new line
                  "%
                  | optional,
                ..
              },
          cloudifyGetAttribute = {
                get_attribute
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                ..
              },
          cloudifyGetInput = {
                get_input
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                ..
              },
          cloudifyGetIntrinsicFunction = predicates.contract_from_predicate
              definitions.predicate.cloudifyGetIntrinsicFunction,
          cloudifyGetProperty = {
                get_property
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                ..
              },
          cloudifyGetSecret = {
                get_secret
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                ..
              },
          cloudifyGetStringOrAwsRegion
            | doc m%"
            The server region name, such as us-east-1.
            (Not us-east-1b, which is an availability zone, or
            US East, which is a Region.)
            US East (N. Virginia) - us-east-1
            US East (Ohio) - us-east-2
            US West (N. California) - us-west-1
            US West (Oregon) - us-west-2
            Africa (Cape Town) - af-south-1
            Asia Pacific (Hong Kong) - ap-east-1
            Asia Pacific (Mumbai) - ap-south-1
            Asia Pacific (Seoul) - ap-northeast-2
            Asia Pacific (Osaka-Local) - ap-northeast-3
            Asia Pacific (Singapore) - ap-southeast-1
            Asia Pacific (Sydney) - ap-southeast-2
            Asia Pacific (Tokyo) - ap-northeast-1
            Canada (Central) - ca-central-1
            China (Beijing) - cn-north-1
            China (Ningxia) - cn-northwest-1
            Europe (Frankfurt) - eu-central-1
            Europe (Ireland) - eu-west-1
            Europe (London) - eu-west-2
            Europe (Milan) - eu-south-1
            Europe (Paris) - eu-west-3
            Europe (Stockholm) - eu-north-1
            Middle East (Bahrain) - me-south-1
            South America (São Paulo) - sa-east-1
            AWS GovCloud (US-East) - us-gov-east-1
            AWS GovCloud (US) - us-gov-west-1
            "%
            = predicates.contract_from_predicate
              definitions.predicate.cloudifyGetStringOrAwsRegion,
          cloudifyIntegerOrGetInput = predicates.contract_from_predicate
              definitions.predicate.cloudifyIntegerOrGetInput,
          cloudifyStringOrGetInput = predicates.contract_from_predicate
              definitions.predicate.cloudifyStringOrGetInput,
          dataType = {
                derived_from
                  | String
                  | doc m%"
                  Parent data type.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description for the data type.
                  "%
                  | optional,
                properties
                  | {  .. }
                  | doc m%"
                  Dictionary of the data type properties.
                  "%
                  | optional,
              },
          dataTypes
            | doc m%"
            To use data_types, the definitions version must be cloudify_dsl_1_2 or higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.dataTypes,
          dockerClientConfig = {
                docker_host
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Docker Machine IP to connect to.
                  "%
                  | optional,
                docker_rest_port
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Docker Machine rest port.
                  "%
                  | optional,
                ..
              },
          dockerInstallationConfig
            | doc m%"
            Docker Installation type
            "%
            = {
                install_script
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Docker Installation script
                  "%
                  | optional,
                install_url
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Docker Installation Link
                  "%
                  | optional,
                ..
              },
          dockerMachine
            | doc m%"
            Docker Machine IP,User,Private_key
            "%
            = {
                container_volume
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Docker Container volume_mapping
                  "%
                  | optional,
                docker_ip
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Docker Machine IP
                  "%
                  | optional,
                docker_key
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Docker Machine Private Key
                  "%
                  | optional,
                docker_user
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Docker Machine User
                  "%
                  | optional,
                ..
              },
          gcpExternalResource = {
                use_external_resource
                  | Bool
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource,
                  true if you are bringing an existing resource, false if you want cloudify to create it.
                  "%
                  | optional,
                ..
              },
          gcpResourceId = {
                resource_id
                  | String
                  | doc m%"
                  The GCP resource ID of the external resource, if
                  use_external_resource is true. Otherwise it is an empty string.
                  "%
                  | optional,
                ..
              },
          inputProperty
            | doc m%"
            inputs are parameters that are injected into a blueprint when a deployment is created. These parameters can be referenced by using the get_input intrinsic function.
            "%
            = {
                constraints
                  | definitions.contract.inputPropertyConstraints
                  | optional,
                "default"
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  An optional default value for the input.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  An optional description for the input.
                  "%
                  | optional,
                required
                  | Bool
                  | doc m%"
                  a boolean value to indicate whether the input is required must be passed or not.
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum
                      [
                        "string",
                        "integer",
                        "float",
                        "boolean",
                        "list",
                        "dict",
                        "regex"
                      ]
                    ]
                  ])
                  | doc m%"
                  The required data type of the input. Not specifying a data type means the type can be anything, including a list, an array or a dictionary. Valid types: string, integer, float, boolean, list, dict, regex or a custom data type.
                  "%
                  | optional,
              },
          inputPropertyConstraints
            | doc m%"
            The constraints the input value must comply with. Read more details about the format and usage of the constraints in the Constraints section below.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.inputPropertyConstraints,
          kubernetesTypesAbstractResource
            | doc m%"
            Type defining common base structure for any Kubernetes resource
            It is some kind of wrapper for native Kubernetes YAML definition
            "%
            = {
                apiVersion
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Kubernetes API version as a string
                  "%
                  | optional,
                kind | definitions.contract.cloudifyStringOrGetInput,
                metadata | {  .. } | optional,
                ..
              },
          kubernetesTypesApiMapping
            | doc m%"
            Type containing python Kubernetes API objects and methods definitions for all supported operations
            "%
            = {
                create
                  | definitions.contract.kubernetesTypesApiMappingEntry
                  | doc m%"
                  Python Kubernetes API objects and methods definitions for create operation
                  "%
                  | optional,
                delete
                  | definitions.contract.kubernetesTypesApiMappingEntry
                  | doc m%"
                  Python Kubernetes API objects and methods definitions for delete operation
                  "%
                  | optional,
                read
                  | definitions.contract.kubernetesTypesApiMappingEntry
                  | doc m%"
                  Python Kubernetes API objects and methods definitions for read operation
                  "%
                  | optional,
                update
                  | definitions.contract.kubernetesTypesApiMappingEntry
                  | doc m%"
                  Python Kubernetes API objects and methods definitions for update operation
                  "%
                  | optional,
                ..
              },
          kubernetesTypesApiMappingEntry
            | doc m%"
            Type defining python Kubernetes API objects and methods definitions for particular operation
            "%
            = {
                api
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of python Kubernetes API object which will be used to as request for particular operation type
                  "%,
                method
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Method name of python Kubernetes API object which will be used as request for particular operation type
                  "%,
                payload
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of python Kubernetes API object which will be used as request data for particular operation type
                  "%
                  | optional,
                ..
              },
          kubernetesTypesAuthenticationVariant
            | doc m%"
            Type representing all authentication variants
            for different Kubernetes cloud providers.
            Each property represents separate supported variant of authentication.
            You should choose one variant and fill in only on property.
            "%
            = {
                gcp_service_account
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  (JSON) Content of Google Cloud Platform Service Account file
                  "%
                  | optional,
                ..
              },
          kubernetesTypesClientConfig
            | doc m%"
            Configuration properties of kubernetes API and
            authentication properties of Kubernetes Cloud providers.
            "%
            = {
                authentication
                  | definitions.contract.kubernetesTypesAuthenticationVariant
                  | doc m%"
                  Authentication properties of Kubernetes Cloud providers. Optional.
                  Currently supported providers: Google Cloud Platform.
                  "%
                  | optional,
                configuration
                  | definitions.contract.kubernetesTypesConfigurationVariant
                  | doc m%"
                  Configuration properties of Kubernetes API. One of four configuration options can be used
                  1. Kubernetes config file contained by blueprint archive
                  2. Kubernetes config file previously uploaded into Cloudify Manager VM
                  3. Content of Kubernetes config file (YAML)
                  4. Kubernetes API set o properties
                  "%
                  | optional,
                ..
              },
          kubernetesTypesClusterRoleDefinitio
            | doc m%"
            Type defining single Kubernetes resource e.g. ClusterRole, ...
            It is some kind of wrapper for native Kubernetes YAML definition
            "%
            = predicates.contract_from_predicate
              definitions.predicate.kubernetesTypesClusterRoleDefinitio,
          kubernetesTypesConfigClassResourceDefinition
            | doc m%"
            Type defining Kubernetes resource for storing data.
            It is some kind of wrapper for native Kubernetes YAML definition
            "%
            = predicates.contract_from_predicate
              definitions.predicate.kubernetesTypesConfigClassResourceDefinition,
          kubernetesTypesConfigurationVariant
            | doc m%"
            Type representing all Kubernetes API configuration variants.
            Each property represents separate supported variant of configuration.
            You should choose one variant and fill in only on property.
            "%
            = {
                api_options
                  | {
                    api_key
                      | definitions.contract.cloudifyStringOrGetInput
                      | optional,
                    cert_file
                      | definitions.contract.cloudifyStringOrGetInput
                      | optional,
                    debug
                      | definitions.contract.cloudifyBooleanOrGetInput
                      | optional,
                    host
                      | definitions.contract.cloudifyStringOrGetInput
                      | doc m%"
                      HTTP/HTTPS URL to Kubernetes API
                      "%
                      | optional,
                    key_file
                      | definitions.contract.cloudifyStringOrGetInput
                      | optional,
                    ssl_ca_cert
                      | definitions.contract.cloudifyStringOrGetInput
                      | optional,
                    verify_ssl
                      | definitions.contract.cloudifyBooleanOrGetInput
                      | optional,
                    ..
                  }
                  | doc m%"
                  Set of basic properties describing Kubernetes API access
                  "%
                  | optional,
                blueprint_file_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of Kubernetes configuration file attached to blueprint
                  "%
                  | optional,
                file_content
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Content (YAML) of Kubernetes configuration file
                  "%
                  | optional,
                manager_file_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Path to Kubernetes configuration file placed on Cloudify Manager VM
                  "%
                  | optional,
                ..
              },
          kubernetesTypesFileResource = {
                resource_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  File relative to blueprint path.
                  "%
                  | optional,
                target_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Do not use.
                  "%
                  | optional,
                template_variables | {  .. } | optional,
                ..
              },
          kubernetesTypesResourceDefinition
            | doc m%"
            Type defining single Kubernetes resource e.g. Pod, Service, ...
            It is some kind of wrapper for native Kubernetes YAML definition
            "%
            = predicates.contract_from_predicate
              definitions.predicate.kubernetesTypesResourceDefinition,
          kubernetesTypesRoleBindingDefinitio
            | doc m%"
            Type defining single Kubernetes resource e.g. Pod, Service, ...
            It is some kind of wrapper for native Kubernetes YAML definition
            "%
            = predicates.contract_from_predicate
              definitions.predicate.kubernetesTypesRoleBindingDefinitio,
          kubernetesTypesRoleDefinitio
            | doc m%"
            Type defining single Kubernetes resource e.g. Role, ...
            It is some kind of wrapper for native Kubernetes YAML definition
            "%
            = predicates.contract_from_predicate
              definitions.predicate.kubernetesTypesRoleDefinitio,
          kubernetesTypesSecretDefinition
            | doc m%"
            Secret holds secret data of a certain type.
            The total bytes of the values in the Data field must be less than MaxSecretSize bytes
            "%
            = predicates.contract_from_predicate
              definitions.predicate.kubernetesTypesSecretDefinition,
          kubernetesTypesServiceAccountDefinition
            | doc m%"
            ServiceAccount binds together: a name, understood by users,
            and perhaps by peripheral systems, for an identity a principal
            that can be authenticated and authorized * a set of secrets
            "%
            = predicates.contract_from_predicate
              definitions.predicate.kubernetesTypesServiceAccountDefinition,
          kubernetesTypesStorageClassResourceDefinition
            | doc m%"
            Type defining single Kubernetes resource e.g. StorageClass
            It is some kind of wrapper for native Kubernetes YAML definition
            "%
            = predicates.contract_from_predicate
              definitions.predicate.kubernetesTypesStorageClassResourceDefinition,
          nodeTemplate = predicates.contract_from_predicate
              definitions.predicate.nodeTemplate,
          nodeTemplateInterface = predicates.contract_from_predicate
              definitions.predicate.nodeTemplateInterface,
          nodeTemplateInterfaceAction = predicates.contract_from_predicate
              definitions.predicate.nodeTemplateInterfaceAction,
          nodeTemplateInterfaces
            | doc m%"
            Interfaces enable you to map logical tasks to executable operations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.nodeTemplateInterfaces,
          nodeTemplateRelationship = {
                connection_type
                  | std.enum.TagOrString
                  | [| 'all_to_one, 'all_to_all |]
                  | doc m%"
                  Valid values: all_to_all and all_to_one (See explanation below.)
                  "%
                  | optional,
                source_interfaces
                  | {  .. }
                  | doc m%"
                  A dictionary of interfaces.
                  "%
                  | optional,
                target
                  | String
                  | doc m%"
                  The name of the node to which the current node is related.
                  "%
                  | optional,
                target_interfaces
                  | {  .. }
                  | doc m%"
                  A dictionary of interfaces.
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  Either a newly-declared relationship type or one of the relationship types provided by default when importing the types.yaml file.
                  "%,
              },
          nodeTemplateRelationships
            | doc m%"
            relationships enable you to define how nodes relate to one another. For example, a web_server node can be contained_in a vm node or an application node can be connected_to a database node.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.nodeTemplateRelationships,
          nodeTemplates
            | doc m%"
            node_templates represent the actual instances of node types that eventually represent the running application/service, as described in the blueprint. node_templates are more commonly referred to as nodes. Nodes can comprise more than one instance. For example, you might define a node that contains two VMs. Each VM is a node_instance.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.nodeTemplates,
          nodeType = {
                derived_from
                  | String
                  | doc m%"
                  A string referencing a parent type.
                  "%
                  | optional,
                interfaces
                  | {  .. }
                  | doc m%"
                  A dictionary of node interfaces.
                  "%
                  | optional,
                properties
                  | {  .. }
                  | doc m%"
                  A dictionary of node properties.
                  "%
                  | optional,
                ..
              },
          nodeTypeAWSEC2Base = {
                Tags | definitions.contract.tags | optional,
                client_config
                  | definitions.contract.awsConnectionConfig
                  | optional,
                resource_id | definitions.contract.awsResourceId | optional,
                use_external_resource
                  | Bool
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource,
                  true if you are bringing an existing resource, false if you want cloudify to create it.
                  "%
                  | optional,
                ..
              },
          nodeTypeAWSEC2EBSAttachment = {
                client_config
                  | definitions.contract.awsConnectionConfig
                  | optional,
                resource_config
                  | {
                    kwargs
                      | {
                        Device
                          | definitions.contract.cloudifyStringOrGetInput
                          | doc m%"
                          The device name (for example, /dev/sdh or xvdh )
                          "%,
                        DryRun
                          | definitions.contract.cloudifyBooleanOrGetInput
                          | doc m%"
                          Checks whether you have the required permissions for the action, without actually making the request, and provides an error response. If you have the required permissions, the error response is DryRunOperation . Otherwise, it is UnauthorizedOperation .
                          "%
                          | optional,
                        InstanceId
                          | definitions.contract.cloudifyStringOrGetInput
                          | doc m%"
                          The ID of the instance.
                          "%,
                        VolumeId
                          | definitions.contract.cloudifyStringOrGetInput
                          | doc m%"
                          The ID of the EBS volume. The volume and instance must be within the same Availability Zone
                          "%,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | doc m%"
                  Configuration key-value data to be passed as-is to the corresponding
                  Boto3 method. Key names must match the case that Boto3 requires.
                  "%
                  | optional,
                resource_id | definitions.contract.awsResourceId | optional,
                use_external_resource
                  | Bool
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource,
                  true if you are bringing an existing resource, false if you want cloudify to create it.
                  "%
                  | optional,
                ..
              },
          nodeTypeAWSEC2EBSVolume = predicates.contract_from_predicate
              definitions.predicate.nodeTypeAWSEC2EBSVolume,
          nodeTypeAWSEC2ElasticIP = {
                client_config | definitions.contract.awsClientConfig | optional,
                ..
              },
          nodeTypeAWSEC2Image = predicates.contract_from_predicate
              definitions.predicate.nodeTypeAWSEC2Image,
          nodeTypeAWSEC2Instances = predicates.contract_from_predicate
              definitions.predicate.nodeTypeAWSEC2Instances,
          nodeTypeAWSEC2Interface = predicates.contract_from_predicate
              definitions.predicate.nodeTypeAWSEC2Interface,
          nodeTypeAWSEC2NATGateway = {
                Tags | definitions.contract.tags | optional,
                client_config | definitions.contract.awsClientConfig | optional,
                ..
              },
          nodeTypeAWSEC2Route = {
                client_config | definitions.contract.awsClientConfig | optional,
                resource_config
                  | {
                    kwargs
                      | {
                        DestinationCidrBlock
                          | definitions.contract.cloudifyStringOrGetInput
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeAWSEC2RouteTable = {
                Tags | definitions.contract.tags | optional,
                client_config | definitions.contract.awsClientConfig | optional,
                ..
              },
          nodeTypeAWSEC2SecurityGroup = predicates.contract_from_predicate
              definitions.predicate.nodeTypeAWSEC2SecurityGroup,
          nodeTypeAWSEC2SecurityGroupRuleIngress =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeAWSEC2SecurityGroupRuleIngress,
          nodeTypeAWSEC2Subnet = {
                Tags | definitions.contract.tags | optional,
                client_config | definitions.contract.awsClientConfig | optional,
                resource_config
                  | {
                    AvailabilityZone
                      | definitions.contract.cloudifyStringOrGetInput
                      | optional,
                    CidrBlock
                      | definitions.contract.cloudifyStringOrGetInput
                      | optional,
                    kwargs
                      | {
                        Ipv6CidrBlock
                          | definitions.contract.cloudifyStringOrGetInput
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeAWSEC2VPC = {
                Tags | definitions.contract.tags | optional,
                client_config | definitions.contract.awsClientConfig | optional,
                resource_config
                  | {
                    CidrBlock
                      | definitions.contract.cloudifyStringOrGetInput
                      | optional,
                    kwargs
                      | {
                        AmazonProvidedIpv6CidrBlock
                          | definitions.contract.cloudifyBooleanOrGetInput
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeAWSInternetGateway = {
                client_config | definitions.contract.awsClientConfig | optional,
                ..
              },
          nodeTypeAnsibleExecutorInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"ansible.cloudify_ansible.tasks.cleanup" |]
                          | optional,
                        ..
                      }
                      | optional,
                    start
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"ansible.cloudify_ansible.tasks.run" |]
                          | optional,
                        inputs
                          | definitions.contract.ansiblePlaybookInputs
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeAnsibleExecutorProperties = predicates.contract_from_predicate
              definitions.predicate.nodeTypeAnsibleExecutorProperties,
          nodeTypeCloudifyAzureDeploymentInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.deployment.create"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.deployment.delete"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureDeploymentProperties = {
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location | definitions.contract.cloudifyStringOrGetInput,
                name | definitions.contract.cloudifyStringOrGetInput,
                params
                  | {  .. }
                  | doc m%"
                  Deployment params
                  "%
                  | optional,
                template
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.cloudifyStringOrGetInput,
                    predicates.isType 'Record
                  ])
                  | doc m%"
                  Deployment template. Can be either a string (which will be parsed as
                  JSON) or a dict (which will be passed as-is to the Azure SDK).
                  "%
                  | optional,
                template_file
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Path or URL to template file. Ignored if `template` is specified.
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesComputeAvailabilitySetInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.compute.availabilityset.create"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.compute.availabilityset.delete"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesComputeAvailabilitySetProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Compute API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureComputeAvailabilitySetConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesComputeContainerServiceInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"azure.cloudify_azure.resources.compute.container_service.create"
                          |]
                          | optional,
                        inputs
                          | predicates.contract_from_predicate predicates.always
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.records.record
                        {
                          implementation = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.compute.container_service.delete"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ])
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesComputeContainerServiceProperties = {
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                container_service_config
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Container service config details
                  "%
                  | optional,
                name | definitions.contract.cloudifyStringOrGetInput,
                resource_group | definitions.contract.cloudifyStringOrGetInput,
                ..
              },
          nodeTypeCloudifyAzureNodesComputeManagedClusterInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"azure.cloudify_azure.resources.compute.managed_cluster.create"
                          |]
                          | optional,
                        inputs
                          | {
                            azure_config
                              | definitions.contract.cloudifyDatatypesAzureConfig
                              | optional,
                            client_config
                              | definitions.contract.cloudifyDatatypesAzureConfig
                              | optional,
                            cluster_name | String | optional,
                            resource_config
                              | definitions.contract.cloudifyDatatypesAzureComputeManagedClusterConfig
                              | optional,
                            resource_group | String | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"azure.cloudify_azure.resources.compute.managed_cluster.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesComputeManagedClusterProperties = {
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                cluster_name | definitions.contract.cloudifyStringOrGetInput,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureComputeManagedClusterConfig
                  | doc m%"
                  Managed Cluster config details, including location, profiles
                  "%,
                resource_group | definitions.contract.cloudifyStringOrGetInput,
                store_kube_config_in_runtime
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  it will store the kubernetes configuration into a runtime property ['kubeconf'] to
                  use later to interact with the cluster
                  "%,
                ..
              },
          nodeTypeCloudifyAzureNodesComputeVirtualMachineExtensionInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    "create:"
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"azure.cloudify_azure.resources.compute.virtualmachineextension.create"
                          |]
                          | optional,
                        inputs
                          | { resource_config | {  .. } | optional, .. }
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.compute.virtualmachineextension.delete"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesComputeVirtualMachineExtensionProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Compute API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                virtual_machine_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Virtual Machine that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Virtual Machine node)
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesComputeVirtualMachineInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    configure
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"azure.cloudify_azure.resources.compute.virtualmachine.configure"
                          |]
                          | optional,
                        inputs
                          | {
                            command_to_execute
                              | definitions.contract.cloudifyStringOrGetInput
                              | optional,
                            file_uris
                              | predicates.contract_from_predicate
                              (predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ])
                              | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesComputeVirtualMachineProperties = {
                agent_config
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    definitions.predicate.cloudifyDataTypesAgentConfig
                  ])
                  | optional,
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Compute API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                ip
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Property specifying the IP address of the resource to
                  use for the agent installer.
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                os_family
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Property specifying what type of operating system family
                  this compute node will run.
                  "%
                  | optional,
                plan
                  | {  .. }
                  | doc m%"
                  Specifies information about the marketplace image used to create the virtual
                  machine. This element is only used for marketplace images.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureComputeVirtualMachineConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                storage_endpoint
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  This is the suffix for the storage endpoint. Supported values are core.windows.net or local.azurestack.external.
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                use_public_ip
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Tells the deployment to use the public IP (if available) of the resource
                  for Cloudify Agent connections
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesComputeWindowsVirtualMachineInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    configure
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"azure.cloudify_azure.resources.compute.virtualmachine.configure"
                          |]
                          | optional,
                        inputs
                          | {
                            command_to_execute
                              | definitions.contract.cloudifyStringOrGetInput
                              | optional,
                            file_uris
                              | predicates.contract_from_predicate
                              (predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ])
                              | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesComputeWindowsVirtualMachineProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeCloudifyAzureNodesComputeWindowsVirtualMachineProperties,
          nodeTypeCloudifyAzureNodesNetworkIPConfigurationProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Network API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureNetworkIPConfigurationConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerBackendAddressPoolInterfaces =
            {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.loadbalancer.create_backend_pool"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.loadbalancer.delete_backend_pool"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerBackendAddressPoolProperties =
            {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Network API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                load_balancer_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerIncomingNATRuleInterfaces =
            {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.loadbalancer.create_incoming_nat_rule"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.loadbalancer.delete_incoming_nat_rule"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerIncomingNATRuleProperties =
            {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Network API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                load_balancer_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureNetworkLoadBalancerIncomingNATRuleConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    configure
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.loadbalancer.configure"
                      |]
                      | optional,
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.loadbalancer.create"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.loadbalancer.delete"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerProbeInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.loadbalancer.create_probe"
                      |]
                      | optional,
                    delete
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.enum
                        [
                          "azure.cloudify_azure.resources.network.loadbalancer.delete_probe"
                        ]
                      ])
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerProbeProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Network API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                load_balancer_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureNetworkLoadBalancerProbeConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Network API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureNetworkLoadBalancerConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerRuleInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.loadbalancer.create_rule"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.loadbalancer.delete_rule"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerRuleProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Network API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                load_balancer_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureNetworkLoadBalancerRuleConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkNetworkInterfaceCardInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    configure
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.networkinterfacecard.configure"
                      |]
                      | optional,
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.networkinterfacecard.create"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.networkinterfacecard.delete"
                      |]
                      | optional,
                    start
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.networkinterfacecard.start"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkNetworkInterfaceCardProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Network API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                primary
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  When using multiple Network Interfaces, a primary must be set
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureNetworkNetworkInterfaceCardConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkNetworkSecurityGroupInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.networksecuritygroup.create"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.networksecuritygroup.delete"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkNetworkSecurityGroupProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Network API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureNetworkNetworkSecurityGroupConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkNetworkSecurityRuleInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.networksecurityrule.create"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.networksecurityrule.delete"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkNetworkSecurityRuleProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Network API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                network_security_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Network Security Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Network Security Groupnode)
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureNetworkNetworkSecurityRuleConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkPublicIPAddressInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.publicipaddress.create"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.publicipaddress.delete"
                      |]
                      | optional,
                    start
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.publicipaddress.start"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkPublicIPAddressProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Network API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureNetworkPublicIPAddressConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkRouteInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.route.create"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.route.delete"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkRouteProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Network API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureNetworkRouteConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                route_table_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Network Security Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Virtual Network node)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkRouteTableInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.routetable.create"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.routetable.delete"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkRouteTableProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Network API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                "location:"
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureNetworkRouteTableConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkSubnetInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | predicates.contract_from_predicate predicates.always
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkSubnetProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Network API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureNetworkSubnetConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                virtual_network_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Virtual Network that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Virtual Network node)
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkVirtualNetworkInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.virtualnetwork.create"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.network.virtualnetwork.delete"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesNetworkVirtualNetworkProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Network API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureNetworkVirtualNetworkConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesPlanInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"azure.cloudify_azure.resources.app_service.plan.create"
                          |]
                          | optional,
                        inputs
                          | {
                            azure_config
                              | definitions.contract.cloudifyDatatypesAzureConfig
                              | optional,
                            client_config
                              | definitions.contract.cloudifyDatatypesAzureConfig
                              | optional,
                            name
                              | definitions.contract.cloudifyStringOrGetInput
                              | optional,
                            resource_group
                              | definitions.contract.cloudifyStringOrGetInput
                              | optional,
                            sku
                              | definitions.contract.cloudifyStringOrGetInput
                              | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"azure.cloudify_azure.resources.app_service.plan.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesPlanProperties = {
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                name | definitions.contract.cloudifyStringOrGetInput,
                resource_group | definitions.contract.cloudifyStringOrGetInput,
                sku
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  SKU details, including location, name, capacity and tier
                  "%
                  | optional,
                use_external_resource
                  | Bool
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesPublishingUserInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"azure.cloudify_azure.resources.app_service.publishing_user.set_user"
                          |]
                          | optional,
                        inputs
                          | {
                            azure_config
                              | definitions.contract.cloudifyDatatypesAzureConfig
                              | optional,
                            client_config
                              | definitions.contract.cloudifyDatatypesAzureConfig
                              | optional,
                            user_details | {  .. } | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesPublishingUserProperties = {
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                user_details
                  | {  .. }
                  | doc m%"
                  User details including location, name, kind, user_name,...
                  "%,
                ..
              },
          nodeTypeCloudifyAzureNodesResourceGroupInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.resourcegroup.create"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.resourcegroup.delete"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesResourceGroupProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Resources API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource. Resource group name must be no longer than
                  80 characters long. It can contain only alphanumeric characters,
                  dash, underscore, opening parenthesis, closing parenthesis,
                  and period. The name cannot end with a period.
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesStorageDataDiskProperties = {
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource (include any extension, such as .vhd).
                  Can be up to 80 characters in length and
                  contain lowercase letters, numbers, ".", and "_". Must start
                  with a number or lowercase letter and cannot end with
                  either "_" or "."
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureStorageDataDiskConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesStorageDataDisktInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.storage.disk.create_data_disk"
                      |]
                      | optional,
                    delete
                      | std.enum.TagOrString
                      | [|
                        '"azure.cloudify_azure.resources.storage.disk.delete_data_disk"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesStorageFileShareInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | predicates.contract_from_predicate predicates.always
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesStorageFileShareProperties = {
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource. Can be up to 63 characters in length and
                  contain lowercase letters, numbers, and dashes. Must start
                  with a number or lowercase letter and cannot contain
                  two consecutive dashes.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureStorageFileShareConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This property
                  will set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesStorageStorageAccountInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      create = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "azure.cloudify_azure.resources.storage.storageaccount.create"
                            ]
                          ],
                    }
                    {  }
                    true
                    predicates.always
                  ])
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesStorageStorageAccountProperties = {
                api_version
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Storage API Version
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                location
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Specifies the supported Azure location for the resource
                  "%
                  | optional,
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name for the resource. Storage account name must be between
                  3 and 24 characters in length and use numbers and lower-case
                  letters only.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesAzureStorageStorageAccountConfig
                  | doc m%"
                  A dictionary of values to pass as properties when creating the resource
                  "%
                  | optional,
                resource_group_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Name of the Resource Group that the existing resource belongs to
                  (this is only useful when not using a relationship between a resource
                  node and a Resource Group node)
                  "%
                  | optional,
                retry_after
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Overrides the Azure-specified "retry_after" response. This propertynwill set the number of seconds for each task retry interval (in the
                  case of iteratively checking the status of an asynchronous operation)
                  "%
                  | optional,
                sku
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  A Storage account SKU if needed.
                  "%
                  | optional,
                tags
                  | {  .. }
                  | doc m%"
                  Specifies a dictionary of one or more name and value pairs that describe a tag
                  "%
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesWebAppInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"azure.cloudify_azure.resources.app_service.webapp.create"
                          |]
                          | optional,
                        inputs
                          | predicates.contract_from_predicate predicates.always
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"azure.cloudify_azure.resources.app_service.webapp.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyAzureNodesWebAppProperties = {
                app_config
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  App config details, including location and plan
                  "%
                  | optional,
                azure_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                client_config
                  | definitions.contract.cloudifyDatatypesAzureConfig
                  | doc m%"
                  A dictionary of values to pass to authenticate with the Azure API
                  "%
                  | optional,
                name | definitions.contract.cloudifyStringOrGetInput,
                resource_group | definitions.contract.cloudifyStringOrGetInput,
                ..
              },
          nodeTypeCloudifyGCPNodesInstanceInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    configure
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"gcp_plugin.cloudify_gcp.compute.instance.create"
                          |]
                          | optional,
                        inputs
                          | {
                            additional_settings | {  .. } | optional,
                            can_ip_forward | Bool | optional,
                            external_ip | Bool | optional,
                            image_id | String | optional,
                            instance_type | String | optional,
                            name | String | optional,
                            scopes
                              | predicates.contract_from_predicate
                              (predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ])
                              | optional,
                            startup_script | String | optional,
                            tags | String | optional,
                            zone | String | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"gcp_plugin.cloudify_gcp.compute.instance.delete"
                          |]
                          | optional,
                        inputs
                          | {
                            name | String | optional,
                            zone | String | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    start
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"gcp_plugin.cloudify_gcp.compute.instance.start"
                          |]
                          | optional,
                        inputs | { name | String | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyGCPNodesInstanceProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeCloudifyGCPNodesInstanceProperties,
          nodeTypeCloudifyGCPProjectInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"gcp_plugin.cloudify_gcp.admin.projects.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"gcp_plugin.cloudify_gcp.admin.projects.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyGCPProjectProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeCloudifyGCPProjectProperties,
          nodeTypeCloudifyNodesCloudInitCloudConfigInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    configure
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"cloudinit.cloudify_cloudinit.tasks.update" |]
                          | optional,
                        ..
                      }
                      | optional,
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"cloudinit.cloudify_cloudinit.tasks.update" |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"cloudinit.cloudify_cloudinit.tasks.delete" |]
                          | optional,
                        ..
                      }
                      | optional,
                    start
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"cloudinit.cloudify_cloudinit.tasks.update" |]
                          | optional,
                        ..
                      }
                      | optional,
                    stop
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"cloudinit.cloudify_cloudinit.tasks.update" |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyNodesCloudInitCloudConfigProperties = {
                encode_base64
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | optional,
                header
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                resource_config | {  .. } | optional,
                ..
              },
          nodeTypeCloudifyNodesDeploymentProxyInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    configure
                      | {
                        implementation
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.enum
                            [
                              "cfy_util.cloudify_deployment_proxy.tasks.create_deployment"
                            ]
                          ])
                          | optional,
                        ..
                      }
                      | optional,
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"cfy_util.cloudify_deployment_proxy.tasks.upload_blueprint"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"cfy_util.cloudify_deployment_proxy.tasks.delete_deployment"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    start
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"cfy_util.cloudify_deployment_proxy.tasks.execute_start"
                          |]
                          | optional,
                        inputs
                          | {
                            interval
                              | std.number.Integer
                              | doc m%"
                              Polling interval (seconds)
                              "%
                              | optional,
                            timeout
                              | std.number.Integer
                              | doc m%"
                              How long (in seconds) to wait for execution to finish before timing out
                              "%
                              | optional,
                            workflow_id | String | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    stop
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"cfy_util.cloudify_deployment_proxy.tasks.execute_start"
                          |]
                          | optional,
                        inputs
                          | {
                            resource_config
                              | definitions.contract.cloudifyDatatypesDeploymentProxy
                              | optional,
                            workflow_id | String | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyNodesDeploymentProxyProperties = {
                client
                  | {
                    host | String | optional,
                    password | String | optional,
                    tenant | String | optional,
                    username | String | optional,
                    ..
                  }
                  | doc m%"
                  Client configuration, if empty will be reused manager client:
                    host: Host of Cloudify's management machine.
                    port: Port of REST API service on management machine.
                    protocol: Protocol of REST API service on management machine,
                              defaults to http.
                    api_version: version of REST API service on management machine.
                    headers: Headers to be added to request.
                    query_params: Query parameters to be added to the request.
                    cert: Path to a copy of the server's self-signed certificate.
                    trust_all: if `False`, the server's certificate
                              (self-signed or not) will be verified.
                    username: Cloudify User username.
                    password: Cloudify User password.
                    token: Cloudify User token.
                    tenant: Cloudify Tenant name.
                  "%
                  | optional,
                plugins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Optional, list of plugins for upload.
                    wagon_path: Url for plugin wagon file.
                    plugin_yaml_path: Url for plugin yaml file.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesDeploymentProxy
                  | optional,
                secrets
                  | {  .. }
                  | doc m%"
                  Optional, dictionary of secrets for set before run deployments.
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyNodesFTPInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"cfy_ftp.cloudify_ftp.tasks.create" |]
                          | optional,
                        inputs
                          | {
                            files
                              | {  .. }
                              | doc m%"
                              list files with content from blueprint to upload
                              "%
                              | optional,
                            raw_files
                              | {  .. }
                              | doc m%"
                              list files from blueprint to upload
                              "%
                              | optional,
                            resource_config
                              | definitions.contract.cloudifyDatatypesFtpAuth
                              | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"cfy_ftp.cloudify_ftp.tasks.delete" |]
                          | optional,
                        inputs
                          | predicates.contract_from_predicate predicates.always
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyNodesFTPProperties = {
                files
                  | {  .. }
                  | doc m%"
                  list files with content from blueprint to upload
                  "%
                  | optional,
                raw_files
                  | {  .. }
                  | doc m%"
                  list files from blueprint to upload
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesFtpAuth
                  | optional,
                ..
              },
          nodeTypeCloudifyNodesFileInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"cfy_files.cloudify_files.tasks.create" |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"cfy_files.cloudify_files.tasks.delete" |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyNodesFileProperties = {
                resource_config
                  | definitions.contract.cloudifyDatatypesFile
                  | optional,
                ..
              },
          nodeTypeCloudifyNodesNodeInstanceProxyProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeCloudifyNodesNodeInstanceProxyProperties,
          nodeTypeCloudifyNodesRSAKeyInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"keys.cloudify_ssh_key.operations.create" |]
                          | optional,
                        inputs
                          | predicates.contract_from_predicate predicates.always
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"keys.cloudify_ssh_key.operations.delete" |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyNodesRSAKeyProperties = {
                key_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Deprecated. Use resource_config.key_name.
                  "%
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesKey
                  | doc m%"
                  A dictionary of values to pass to configure the key.
                  "%
                  | optional,
                use_secret_store
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | optional,
                use_secrets_if_exist
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  this flag is able to be true only if use_secret_store is true
                  if this property is false the secret for the key value will be
                  created, if true then the existing secrets of an existing node
                  with same key_name will be used as a key, if this property is true
                  and the secrets does not exist they will be created.
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyNodesSecretsReaderInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"secrets.cloudify_secrets.tasks.read" |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    update
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"secrets.cloudify_secrets.tasks.read" |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyNodesSecretsReaderProperties = {
                keys
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                separator
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                variant
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                ..
              },
          nodeTypeCloudifyNodesSecretsWriterInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"secrets.cloudify_secrets.tasks.create" |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"secrets.cloudify_secrets.tasks.delete" |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    update
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"secrets.cloudify_secrets.tasks.update" |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyNodesSecretsWriterProperties = {
                do_not_delete
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | optional,
                entries | {  .. } | optional,
                separator
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                variant
                  | definitions.contract.cloudifyStringOrGetInput
                  | optional,
                ..
              },
          nodeTypeCloudifyRestBunchRequestsInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    configure
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"rest.cloudify_rest.tasks.bunch_execute" |]
                          | optional,
                        inputs
                          | {
                            auth | {  .. } | optional,
                            templates | {  .. } | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"rest.cloudify_rest.tasks.bunch_execute" |]
                          | optional,
                        inputs
                          | {
                            auth | {  .. } | optional,
                            templates | {  .. } | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"rest.cloudify_rest.tasks.bunch_execute" |]
                          | optional,
                        inputs
                          | {
                            auth | {  .. } | optional,
                            templates | {  .. } | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    start
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"rest.cloudify_rest.tasks.bunch_execute" |]
                          | optional,
                        inputs
                          | {
                            auth | {  .. } | optional,
                            templates | {  .. } | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    stop
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"rest.cloudify_rest.tasks.bunch_execute" |]
                          | optional,
                        inputs
                          | {
                            auth | {  .. } | optional,
                            templates | {  .. } | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyRestBunchRequestsProperties = {
                cert
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Supported such values:
                  * `None`: default value, ignore client certificates,
                  * `<file path>`: path to certificate on local system,
                  * `<certificate content>`: certificate content.
                  "%
                  | optional,
                host
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  host name or IP addresses of Rest Servers
                  if list of hosts is not needed single host can be provided by this
                  property. NOTE: the 'hosts' property overwrite the 'host' property
                  "%
                  | optional,
                hosts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  list of hosts name or IP addresses of Rest Servers
                  "%
                  | optional,
                params
                  | {  .. }
                  | doc m%"
                  Template parameters. Default is empty dictionary.
                  "%
                  | optional,
                port
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  port number. When -1 default ports are used
                  (80 for ssl = false and 443 for ssl = true)
                  "%
                  | optional,
                proxies
                  | {  .. }
                  | doc m%"
                  List of proxies.
                  "%
                  | optional,
                ssl
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  http or https
                  "%
                  | optional,
                timeout
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Timeout value for requests.
                  "%
                  | optional,
                verify
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  A boolean which controls whether we verify the server's TLS
                  certificate. Supported such values:
                  * `True`: default value, check certificates,
                  * `False`: ignore server certificates,
                  * `<file path>`: path to certificate on local system,
                  * `<certificate content>`: certificate content.
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyRestRequestsInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    configure
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"rest.cloudify_rest.tasks.execute" |]
                          | optional,
                        inputs
                          | definitions.contract.restTemplateInputs
                          | optional,
                        ..
                      }
                      | optional,
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"rest.cloudify_rest.tasks.execute" |]
                          | optional,
                        inputs
                          | definitions.contract.restTemplateInputs
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"rest.cloudify_rest.tasks.execute" |]
                          | optional,
                        inputs
                          | definitions.contract.restTemplateInputs
                          | optional,
                        ..
                      }
                      | optional,
                    start
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"rest.cloudify_rest.tasks.execute" |]
                          | optional,
                        inputs
                          | definitions.contract.restTemplateInputs
                          | optional,
                        ..
                      }
                      | optional,
                    stop
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"rest.cloudify_rest.tasks.execute" |]
                          | optional,
                        inputs
                          | definitions.contract.restTemplateInputs
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyRestRequestsProperties = {
                cert
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Supported such values:
                  * `None`: default value, ignore client certificates,
                  * `<file path>`: path to certificate on local system,
                  * `<certificate content>`: certificate content.
                  "%
                  | optional,
                host
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  host name or IP addresses of Rest Servers
                  if list of hosts is not needed single host can be provided by this
                  property. NOTE: the 'hosts' property overwrite the 'host' property
                  "%
                  | optional,
                hosts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  list of hosts name or IP addresses of Rest Servers
                  "%
                  | optional,
                params
                  | {  .. }
                  | doc m%"
                  Template parameters. Default is empty dictionary.
                  "%
                  | optional,
                port
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  port number. When -1 default ports are used
                  (80 for ssl = false and 443 for ssl = true)
                  "%
                  | optional,
                proxies
                  | {  .. }
                  | doc m%"
                  List of proxies.
                  "%
                  | optional,
                ssl
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  http or https
                  "%
                  | optional,
                timeout
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Timeout value for requests.
                  "%
                  | optional,
                verify
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  A boolean which controls whether we verify the server's TLS
                  certificate. Supported such values:
                  * `True`: default value, check certificates,
                  * `False`: ignore server certificates,
                  * `<file path>`: path to certificate on local system,
                  * `<certificate content>`: certificate content.
                  "%
                  | optional,
                ..
              },
          nodeTypeCloudifyTerminalRawInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    configure
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"terminal.cloudify_terminal.tasks.run" |]
                          | optional,
                        inputs | {  .. } | optional,
                        ..
                      }
                      | optional,
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"terminal.cloudify_terminal.tasks.run" |]
                          | optional,
                        inputs | {  .. } | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"terminal.cloudify_terminal.tasks.run" |]
                          | optional,
                        inputs | {  .. } | optional,
                        ..
                      }
                      | optional,
                    start
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"terminal.cloudify_terminal.tasks.run" |]
                          | optional,
                        inputs | {  .. } | optional,
                        ..
                      }
                      | optional,
                    stop
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"terminal.cloudify_terminal.tasks.run" |]
                          | optional,
                        inputs | {  .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeCloudifyTerminalRawProperties = {
                terminal_auth
                  | definitions.contract.cloudifyDatatypesTerminalAuth
                  | doc m%"
                  terminal credentials, like example:
                    user: <user name>
                    password: <user password>
                    ip: <host name>
                  "%
                  | optional,
                ..
              },
          nodeTypeDockerAnsiblePlaybookInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"docker.cloudify_docker.ansible.create_ansible_playbook"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"docker.cloudify_docker.ansible.remove_ansible_playbook"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    precreate
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"docker.cloudify_docker.ansible.set_playbook_config"
                          |]
                          | optional,
                        inputs
                          | {
                            additional_args | String | optional,
                            ansible_env_vars | {  .. } | optional,
                            ansible_playbook_executable_path
                              | String
                              | optional,
                            debug_level | std.number.Integer | optional,
                            options_config | {  .. } | optional,
                            playbook_path | String | optional,
                            playbook_source_path | String | optional,
                            remerge_sources | Bool | optional,
                            run_data | {  .. } | optional,
                            save_playbook | Bool | optional,
                            sensitive_keys
                              | predicates.contract_from_predicate
                              (predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ])
                              | optional,
                            site_yaml_path | String | optional,
                            sources | {  .. } | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeDockerAnsiblePlaybookProperties = {
                additional_args
                  | String
                  | doc m%"
                  Additional args that you want to use, for example, '-c local'.
                  "%
                  | optional,
                additional_playbook_files
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of string paths blueprint resources that you
                  would like to download to the playbook directory.
                  If you use this variable, you must list all of the paths
                  that you expect to download.
                  "%
                  | optional,
                ansible_become
                  | Bool
                  | doc m%"
                  A boolean value, `true` or `false` whether
                  to assume the user privileges.
                  "%
                  | optional,
                ansible_env_vars
                  | {
                    ANSIBLE_HOST_KEY_CHECKING
                      | std.enum.TagOrString
                      | [| 'False, 'True |]
                      | optional,
                    ANSIBLE_INVALID_TASK_ATTRIBUTE_FAILED
                      | std.enum.TagOrString
                      | [| 'False, 'True |]
                      | optional,
                    ..
                  }
                  | doc m%"
                  A dictionary of environment variables to set.
                  "%
                  | optional,
                ansible_playbook_executable_path
                  | String
                  | doc m%"
                  A full path to your ansible_playbook executable if user don't want to
                  use the included version of executable in the plugin
                  "%
                  | optional,
                debug_level
                  | std.number.Integer
                  | doc m%"
                  Debug level
                  "%
                  | optional,
                docker_machine
                  | definitions.contract.dockerMachine
                  | doc m%"
                  Docker Machine IP,User,Private_key
                  "%
                  | optional,
                options_config
                  | {  .. }
                  | doc m%"
                  Command-line options, such as `tags` or `skip_tags`.
                  "%
                  | optional,
                playbook_path
                  | String
                  | doc m%"
                  A path to your `site.yaml` or `main.yaml` in your
                  Ansible Playbook relative to blueprint or playbook_source_path
                  if playbook_source_path is URL to archive File relative inside the archive.
                  "%
                  | optional,
                playbook_source_path
                  | String
                  | doc m%"
                  A full path/URL that contain playbook specified in playbook_path
                  or site_yaml_path.
                  "%
                  | optional,
                remerge_sources
                  | Bool
                  | doc m%"
                  update sources on target node
                  "%
                  | optional,
                run_data
                  | {  .. }
                  | doc m%"
                  Variable values.
                  "%
                  | optional,
                save_playbook
                  | Bool
                  | doc m%"
                  Save playbook after action
                  "%
                  | optional,
                sensitive_keys
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  keys that you want us to obscure
                  "%
                  | optional,
                site_yaml_path
                  | String
                  | doc m%"
                  DEPRECATED.
                  A path to your `site.yaml` or `main.yaml` in your
                  Ansible Playbook relative to blueprint or playbook_source_path
                  if playbook_source_path is URL to archive File relative inside the archive.
                  "%
                  | optional,
                sources
                  | {  .. }
                  | doc m%"
                  Your Inventory sources. Either YAML or a path to a file.
                  If not provided the inventory will be take from the `sources`
                  runtime property.
                  "%
                  | optional,
                ..
              },
          nodeTypeDockerContainerFilesInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"docker.cloudify_docker.tasks.prepare_container_files"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"docker.cloudify_docker.tasks.remove_container_files"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeDockerContainerFilesProperties = {
                resource_config
                  | predicates.contract_from_predicate
                  (predicates.records.record
                  {
                    ansible_sources = predicates.isType 'Record,
                    destination = predicates.isType '"String",
                    docker_machine = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            ansible_sources = predicates.isType 'Record,
                            destination = predicates.isType '"String",
                            docker_machine =
                              definitions.predicate.dockerMachine,
                            extra_files = predicates.isType '"String",
                            source = predicates.isType '"String",
                            terraform_sources = predicates.isType 'Record,
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    extra_files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    source = predicates.isType '"String",
                    terraform_sources = predicates.isType 'Record,
                  }
                  {  }
                  true
                  predicates.always)
                  | doc m%"
                  Docker Container Files type
                  "%
                  | optional,
                ..
              },
          nodeTypeDockerContainerInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"docker.cloudify_docker.tasks.create_container"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"docker.cloudify_docker.tasks.remove_container"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    stop
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"docker.cloudify_docker.tasks.remove_container"
                          |]
                          | optional,
                        inputs
                          | {
                            stop_command
                              | predicates.contract_from_predicate
                              (predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType 'Record
                              ])
                              | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeDockerContainerProperties = {
                client_config
                  | definitions.contract.dockerClientConfig
                  | optional,
                resource_config
                  | {
                    container_args
                      | {  .. }
                      | doc m%"
                      dict of arguments to pass to container when run
                      check this URL for details: https://tinyurl.com/v8url54
                      "%
                      | optional,
                    image_tag
                      | definitions.contract.cloudifyStringOrGetInput
                      | doc m%"
                      Docker image tag to build container
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Docker Container type
                  "%
                  | optional,
                ..
              },
          nodeTypeDockerContainersInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"docker.cloudify_docker.tasks.list_containers"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeDockerContainersProperties = {
                client_config
                  | definitions.contract.dockerClientConfig
                  | optional,
                ..
              },
          nodeTypeDockerHostDetailsInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"docker.cloudify_docker.tasks.list_host_details"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeDockerHostDetailsProperties = {
                client_config
                  | definitions.contract.dockerClientConfig
                  | optional,
                ..
              },
          nodeTypeDockerHostInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"docker.cloudify_docker.tasks.install_docker" |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"docker.cloudify_docker.tasks.uninstall_docker"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeDockerHostProperties = {
                docker_machine | definitions.contract.dockerMachine | optional,
                resource_config
                  | definitions.contract.dockerInstallationConfig
                  | optional,
                ..
              },
          nodeTypeDockerImageInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"docker.cloudify_docker.tasks.build_image" |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"docker.cloudify_docker.tasks.remove_image" |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeDockerImageProperties = {
                client_config
                  | definitions.contract.dockerClientConfig
                  | optional,
                resource_config
                  | {
                    image_content
                      | definitions.contract.cloudifyStringOrGetInput
                      | doc m%"
                      Docker image to build
                      "%
                      | optional,
                    tag
                      | definitions.contract.cloudifyStringOrGetInput
                      | doc m%"
                      Docker image tag
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Docker Image type
                  "%
                  | optional,
                ..
              },
          nodeTypeDockerImagesInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"docker.cloudify_docker.tasks.list_images" |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeDockerImagesProperties = {
                client_config
                  | definitions.contract.dockerClientConfig
                  | optional,
                ..
              },
          nodeTypeDockerTerraformModuleInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"docker.cloudify_docker.terraform.prepare_terraform_files"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"docker.cloudify_docker.terraform.remove_terraform_files"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeDockerTerraformModuleProperties = {
                docker_machine | definitions.contract.dockerMachine | optional,
                resource_config
                  | {
                    backend
                      | {
                        name
                          | String
                          | doc m%"
                          Some name.
                          "%
                          | optional,
                        options
                          | {  .. }
                          | doc m%"
                          Should be a dictionary of key/values.
                          "%
                          | optional,
                        ..
                      }
                      | doc m%"
                      If a backend is not defined in source,
                      and you want to use a specific backend, define that here.
                      "%
                      | optional,
                    environment_variables
                      | {  .. }
                      | doc m%"
                      A dictionary of environment variables.
                      "%
                      | optional,
                    source
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "location" ],
                          predicates.records.record
                          {
                            location = predicates.isType '"String",
                            password = predicates.isType '"String",
                            username = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ]
                      ]),
                    variables
                      | {  .. }
                      | doc m%"
                      A dictionary of variables.
                      "%
                      | optional,
                    ..
                  },
                terraform_plugins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Terraform Plugins to install
                  "%,
                ..
              },
          nodeTypeHelmBinaryProperties = {
                helm_config
                  | definitions.contract.cloudifyDatatypesHelmConfig
                  | optional,
                installation_source
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Location to download the Helm installation from. Ignored if 'use_existing_resource' is true.
                  "%
                  | optional,
                use_existing_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  If true, use an existing helm installation rather than installing it.
                  "%
                  | optional,
                ..
              },
          nodeTypeHelmReleaseInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"helm.cloudify_helm.tasks.uninstall_release" |]
                          | optional,
                        inputs
                          | {
                            flags
                              | definitions.contract.cloudifyDatatypesHelmSetFlagsList
                              | doc m%"
                               Flags to add only to `helm uninstall` command.The format is the same as "flags".
                              "%
                              | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    start
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"helm.cloudify_helm.tasks.install_release" |]
                          | optional,
                        inputs
                          | {
                            flags
                              | definitions.contract.cloudifyDatatypesHelmSetFlagsList
                              | doc m%"
                               Flags to add only to `helm install` command.The format is the same as "flags".
                              "%
                              | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeHelmReleaseProperties = {
                client_config
                  | definitions.contract.cloudifyDatatypesHelmClientConfig,
                helm_config
                  | definitions.contract.cloudifyDatatypesHelmConfig
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesHelmReleaseConfig,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource,
                  true if you are bringing an existing resource, false if you want cloudify to create it.
                  "%
                  | optional,
                ..
              },
          nodeTypeHelmRepoInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"helm.cloudify_helm.tasks.remove_repo" |]
                          | optional,
                        inputs
                          | {
                            flags
                              | definitions.contract.cloudifyDatatypesHelmSetFlagsList
                              | doc m%"
                               Flags to add only to `helm repo remove` command.The format is the same as "flags".
                              "%
                              | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    start
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"helm.cloudify_helm.tasks.add_repo" |]
                          | optional,
                        inputs
                          | {
                            flags
                              | definitions.contract.cloudifyDatatypesHelmSetFlagsList
                              | doc m%"
                               Flags to add only to `helm repo add` command.The format is the same as "flags".
                              "%
                              | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeHelmRepoProperties = {
                helm_config
                  | definitions.contract.cloudifyDatatypesHelmConfig
                  | optional,
                resource_config
                  | definitions.contract.cloudifyDatatypesHelmRepoConfig
                  | optional,
                use_external_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource,
                  true if you are bringing an existing resource, false if you want cloudify to create it.
                  "%
                  | optional,
                ..
              },
          nodeTypeKubernetesNodesMasterProperties = {
                authentication
                  | definitions.contract.kubernetesTypesAuthenticationVariant
                  | doc m%"
                  Authentication properties of Kubernetes Cloud providers. Optional.
                  Currently supported providers: Google Cloud Platform.
                  "%
                  | optional,
                configuration
                  | definitions.contract.kubernetesTypesConfigurationVariant
                  | doc m%"
                  Configuration properties of Kubernetes API. One of four configuration options can be used
                  1. Kubernetes config file contained by blueprint archive
                  2. Kubernetes config file previously uploaded into Cloudify Manager VM
                  3. Content of Kubernetes config file (YAML)
                  4. Kubernetes API set o properties
                  "%
                  | optional,
                ..
              },
          nodeTypeKubernetesResourcesBlueprintDefinedResource
            | doc m%"
            
            "%
            = predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
          nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces
            | doc m%"
            
            "%
            = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.enum
                            [
                              "kubernetes.cloudify_kubernetes.tasks.resource_create"
                            ],
                            definitions.predicate.cloudifyStringOrGetInput
                          ])
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.enum
                            [
                              "kubernetes.cloudify_kubernetes.tasks.resource_delete"
                            ],
                            definitions.predicate.cloudifyStringOrGetInput
                          ])
                          | optional,
                        ..
                      }
                      | optional,
                    poststart
                      | {
                        implementation
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.enum
                            [
                              "kubernetes.cloudify_kubernetes.tasks.resource_read"
                            ],
                            definitions.predicate.cloudifyStringOrGetInput
                          ])
                          | optional,
                        ..
                      }
                      | optional,
                    update
                      | {
                        implementation
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.enum
                            [
                              "kubernetes.cloudify_kubernetes.tasks.resource_update"
                            ],
                            definitions.predicate.cloudifyStringOrGetInput
                          ])
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeKubernetesResourcesClusterRoleBindingProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesClusterRoleBindingProperties,
          nodeTypeKubernetesResourcesClusterRoleProperties
            | doc m%"
            Definition of cluster role using native Kubernetes YAML spec
            "%
            = predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesClusterRoleProperties,
          nodeTypeKubernetesResourcesConfigMapProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesConfigMapProperties,
          nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceInterfaces =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceInterfaces,
          nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceProperties,
          nodeTypeKubernetesResourcesCustomResourceDefinitionProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesCustomResourceDefinitionProperties,
          nodeTypeKubernetesResourcesDaemonSetProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesDaemonSetProperties,
          nodeTypeKubernetesResourcesDeploymentProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesDeploymentProperties,
          nodeTypeKubernetesResourcesFileDefinedResourceInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.enum
                            [
                              "kubernetes.cloudify_kubernetes.tasks.file_resource_create"
                            ],
                            definitions.predicate.cloudifyStringOrGetInput
                          ])
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.enum
                            [
                              "kubernetes.cloudify_kubernetes.tasks.file_resource_delete"
                            ],
                            definitions.predicate.cloudifyStringOrGetInput
                          ])
                          | optional,
                        ..
                      }
                      | optional,
                    poststart
                      | {
                        implementation
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.enum
                            [
                              "kubernetes.cloudify_kubernetes.tasks.file_resource_read"
                            ],
                            definitions.predicate.cloudifyStringOrGetInput
                          ])
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeKubernetesResourcesFileDefinedResourceProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesFileDefinedResourceProperties,
          nodeTypeKubernetesResourcesIngressProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesIngressProperties,
          nodeTypeKubernetesResourcesMultipleFileDefinedResourcesInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"kubernetes.cloudify_kubernetes.tasks.multiple_file_resource_create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"kubernetes.cloudify_kubernetes.tasks.custom_resource_delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    poststart
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"kubernetes.cloudify_kubernetes.tasks.multiple_file_resource_delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeKubernetesResourcesMultipleFileDefinedResourcesProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesMultipleFileDefinedResourcesProperties,
          nodeTypeKubernetesResourcesNamespaceProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesNamespaceProperties,
          nodeTypeKubernetesResourcesNetworkPolicyProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesNetworkPolicyProperties,
          nodeTypeKubernetesResourcesNodeProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesNodeProperties,
          nodeTypeKubernetesResourcesPersistentVolumeClaimProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesPersistentVolumeClaimProperties,
          nodeTypeKubernetesResourcesPersistentVolumeProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesPersistentVolumeProperties,
          nodeTypeKubernetesResourcesPodProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesPodProperties,
          nodeTypeKubernetesResourcesPodSecurityPolicyProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesPodSecurityPolicyProperties,
          nodeTypeKubernetesResourcesReplicaSetProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesReplicaSetProperties,
          nodeTypeKubernetesResourcesReplicationControllerProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesReplicationControllerProperties,
          nodeTypeKubernetesResourcesResourceBase
            | doc m%"
            
            "%
            = {
                allow_node_redefinition
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Permit changing the name and kind and number of resources defined in file.
                  "%
                  | optional,
                client_config
                  | definitions.contract.kubernetesTypesClientConfig
                  | doc m%"
                  Configuration properties of kubernetes API and
                  authentication properties of Kubernetes Cloud providers.
                  "%
                  | optional,
                ..
              },
          nodeTypeKubernetesResourcesResourceWithValidateStatus =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesResourceWithValidateStatus,
          nodeTypeKubernetesResourcesRoleBinding =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesRoleBinding,
          nodeTypeKubernetesResourcesRoleProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesRoleProperties,
          nodeTypeKubernetesResourcesSecretProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesSecretProperties,
          nodeTypeKubernetesResourcesServiceAccountProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesServiceAccountProperties,
          nodeTypeKubernetesResourcesServiceProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesServiceProperties,
          nodeTypeKubernetesResourcesStatefulSetProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesStatefulSetProperties,
          nodeTypeKubernetesResourcesStorageClassProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeKubernetesResourcesStorageClassProperties,
          nodeTypeOpenstackFlavorInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.flavor.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.flavor.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.flavor.list_flavors"
                          |]
                          | optional,
                        inputs
                          | {
                            details | Bool | optional,
                            query | {  .. } | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    update
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.flavor.update"
                          |]
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackFlavorProperties = predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackFlavorProperties,
          nodeTypeOpenstackFloatingIPInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.floating_ip.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.floating_ip.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.floating_ip.list_floating_ips"
                          |]
                          | optional,
                        inputs | { query | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    update
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.floating_ip.update"
                          |]
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.validation"
                  | {
                    creation
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.floating_ip.creation_validation"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackFloatingIPProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackFloatingIPProperties,
          nodeTypeOpenstackGroupInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.group.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.group.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.group.list_groups"
                          |]
                          | optional,
                        inputs | { query | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    update
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.group.update"
                          |]
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackGroupProperties = predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackGroupProperties,
          nodeTypeOpenstackHostAggregateInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    configure
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.host_aggregate.configure"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.host_aggregate.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.host_aggregate.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    add_hosts
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.host_aggregate.add_hosts"
                          |]
                          | optional,
                        inputs
                          | {
                            hosts
                              | predicates.contract_from_predicate
                              (predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ])
                              | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.host_aggregate.list_aggregates"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    remove_hosts
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.host_aggregate.remove_hosts"
                          |]
                          | optional,
                        inputs
                          | {
                            hosts
                              | predicates.contract_from_predicate
                              (predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ])
                              | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    update
                      | {
                        implementation
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.enum
                            [
                              "openstack.openstack_plugin.resources.compute.host_aggregate.update"
                            ]
                          ])
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackHostAggregateProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackHostAggregateProperties,
          nodeTypeOpenstackImageInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.image.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.image.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    start
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.image.start"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.image.list_images"
                          |]
                          | optional,
                        inputs | { query | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    update
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.image.update"
                          |]
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.validation"
                  | {
                    creation
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.image.creation_validation"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackImageProperties = predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackImageProperties,
          nodeTypeOpenstackKeyPairInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.keypair.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.keypair.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.keypair.list_keypairs"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.validation"
                  | {
                    creation
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.compute.keypair.creation_validation"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackKeyPairProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackKeyPairProperties,
          nodeTypeOpenstackNetworkBaseProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackNetworkBaseProperties,
          nodeTypeOpenstackNetworkInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.network.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.network.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.network.list_networks"
                          |]
                          | optional,
                        inputs | { query | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    update
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.network.update"
                          |]
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.validation"
                  | {
                    creation
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.network.creation_validation"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackNetworkProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackNetworkProperties,
          nodeTypeOpenstackPortInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.port.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.port.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.port.list_ports"
                          |]
                          | optional,
                        inputs | { query | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    update
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.port.update"
                          |]
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.validation"
                  | {
                    creation
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.port.creation_validation"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackPortProperties = predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackPortProperties,
          nodeTypeOpenstackProjectInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.project.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.project.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    start
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.project.start"
                          |]
                          | optional,
                        inputs
                          | { quota_dict | {  .. } | optional, .. }
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    get_quota
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.project.get_project_quota"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.project.list_projects"
                          |]
                          | optional,
                        inputs | { query | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    update_project
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.project.update"
                          |]
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    update_quota
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.project.update_project_quota"
                          |]
                          | optional,
                        inputs | { quota | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.validation"
                  | {
                    creation
                      | std.enum.TagOrString
                      | [|
                        '"openstack.openstack_plugin.resources.identity.project.creation_validation"
                      |]
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackProjectProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackProjectProperties,
          nodeTypeOpenstackRBACPolicyProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackRBACPolicyProperties,
          nodeTypeOpenstackRecordSetInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.dns_service.record_set.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.dns_service.record_set.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackRecordSetProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackRecordSetProperties,
          nodeTypeOpenstackRoleInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.role.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.role.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.role.list_roles"
                          |]
                          | optional,
                        inputs | { query | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    update
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.role.update"
                          |]
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackRoleProperties = predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackRoleProperties,
          nodeTypeOpenstackRouterInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.router.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.router.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    start
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.router.start"
                          |]
                          | optional,
                        inputs | { routes | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    stop
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.router.stop"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.router.list_routers"
                          |]
                          | optional,
                        inputs | { query | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    update
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.router.update"
                          |]
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.validation"
                  | {
                    creation
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.router.creation_validation"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackRouterProperties = predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackRouterProperties,
          nodeTypeOpenstackSecurityGroupInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    configure
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.security_group.configure"
                          |]
                          | optional,
                        inputs
                          | {
                            security_group_rules
                              | predicates.contract_from_predicate
                              (predicates.anyOf
                              [
                                predicates.isType '"Array",
                                predicates.isType 'Record
                              ])
                              | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.security_group.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.security_group.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.security_group.list_security_groups"
                          |]
                          | optional,
                        inputs | { query | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    update
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.security_group.update"
                          |]
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.validation"
                  | {
                    creation
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.security_group.creation_validation"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackSecurityGroupProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackSecurityGroupProperties,
          nodeTypeOpenstackSecurityGroupRuleInterfaces =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackSecurityGroupRuleInterfaces,
          nodeTypeOpenstackSecurityGroupRuleProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackSecurityGroupRuleProperties,
          nodeTypeOpenstackServerProperties = predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackServerProperties,
          nodeTypeOpenstackSubnetInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.subnet.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.subnet.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.subnet.list_subnets"
                          |]
                          | optional,
                        inputs | { query | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    update
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.subnet.update"
                          |]
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.validation"
                  | {
                    creation
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.network.subnet.creation_validation"
                          |]
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackSubnetProperties = predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackSubnetProperties,
          nodeTypeOpenstackUserInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.user.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.user.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.user.list_users"
                          |]
                          | optional,
                        inputs | { query | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    update
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.identity.user.update"
                          |]
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackUserProperties = predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackUserProperties,
          nodeTypeOpenstackVolumeInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.volume.volume.create"
                          |]
                          | optional,
                        inputs | { args | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.volume.volume.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    start
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.volume.volume.start"
                          |]
                          | optional,
                        inputs | {  .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.operations"
                  | {
                    list
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.volume.volume.list_volumes"
                          |]
                          | optional,
                        inputs | { query | {  .. } | optional, .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.snapshot"
                  | {
                    apply
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.volume.volume.snapshot_apply"
                          |]
                          | optional,
                        inputs | {  .. } | optional,
                        ..
                      }
                      | optional,
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.volume.volume.snapshot_create"
                          |]
                          | optional,
                        inputs | {  .. } | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.volume.volume.snapshot_delete"
                          |]
                          | optional,
                        inputs | {  .. } | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                "cloudify.interfaces.validation"
                  | {
                    creation
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.volume.volume.creation_validation"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackVolumeProperties = predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackVolumeProperties,
          nodeTypeOpenstackVolumeTypeInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.volume.volume_type.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.volume.volume_type.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackVolumeTypeProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackVolumeTypeProperties,
          nodeTypeOpenstackWindowsServerProperties =
            predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackWindowsServerProperties,
          nodeTypeOpenstackZoneInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.dns_service.zone.create"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [|
                            '"openstack.openstack_plugin.resources.dns_service.zone.delete"
                          |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeOpenstackZoneProperties = predicates.contract_from_predicate
              definitions.predicate.nodeTypeOpenstackZoneProperties,
          nodeTypeTerraformDirectoryConfig = {
                executable_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The path to the terraform binary executable.
                  "%
                  | optional,
                plugins_dir
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Location where Terraform plugins are located. If a value is provided, then
                  the Terraform plugin uses '--plugin-dir' with that value, ensuring that
                  no plugins are downloaded on-the-fly, for increased stability.
                  If a value is not provided, plugins will be downloaded on-the-fly. This is
                  not recommended in production environments.
                  "%
                  | optional,
                storage_path
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Directory to store downloaded Terraform templates. The directory must
                  either already exist and be writable by 'cfyuser', or alternatively
                  be create-able by 'cfyuser'.
                  The default is an empty string, which prompts the plugin to use the OS
                  temporary directory.
                  "%
                  | optional,
                ..
              },
          nodeTypeTerraformInstallConfig = {
                installation_source
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Location to download the Terraform installation from. Ignored if 'use_existing' is true.
                  "%
                  | optional,
                plugins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of plugins to download and install.
                  "%
                  | optional,
                use_existing_resource
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  If true, use an existing Terraform installation rather than installing it
                  "%,
                ..
              },
          nodeTypeTerraformInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    create
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"tf.cloudify_tf.tasks.install" |]
                          | optional,
                        ..
                      }
                      | optional,
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"tf.cloudify_tf.tasks.uninstall" |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeTerraformModuleInterfaces = {
                "cloudify.interfaces.lifecycle"
                  | {
                    delete
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"tf.cloudify_tf.tasks.destroy" |]
                          | optional,
                        ..
                      }
                      | optional,
                    start
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"tf.cloudify_tf.tasks.apply" |]
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                terraform
                  | {
                    refresh
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"tf.cloudify_tf.tasks.state_pull" |]
                          | optional,
                        ..
                      }
                      | optional,
                    reload
                      | {
                        implementation
                          | std.enum.TagOrString
                          | [| '"tf.cloudify_tf.tasks.reload_template" |]
                          | optional,
                        inputs
                          | {
                            destroy_previous
                              | Bool
                              | doc m%"
                              If true, then the plugin destroys the existing Terraform
                              topology before applying the new one.
                              "%
                              | optional,
                            source
                              | String
                              | doc m%"
                              URL or path to a ZIP/tar.gz file or a Git repository to obtain
                              new module source from. If omitted, then the module is reloaded
                              from its last location.
                              "%
                              | optional,
                            ..
                          }
                          | optional,
                        ..
                      }
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          nodeTypeTerraformModuleProperties = {
                resource_config
                  | definitions.contract.terraformTypesRootModule
                  | optional,
                ..
              },
          nodeTypeTerraformProperties = predicates.contract_from_predicate
              definitions.predicate.nodeTypeTerraformProperties,
          nodeTypes = predicates.contract_from_predicate
              definitions.predicate.nodeTypes,
          openstackClientConfig = {
                client_config
                  | definitions.contract.openstackTypeClientConfig
                  | doc m%"
                  Your OpenStack client configuration.
                  "%
                  | optional,
                ..
              },
          openstackCreateIfMissing = {
                create_if_missing
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  If use_external_resource is ``true`` and the resource is missing,create it instead of failing.
                  "%
                  | optional,
                ..
              },
          openstackDataTypeDescription = {
                description
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Resource description.
                  "%
                  | optional,
                ..
              },
          openstackDataTypeId = {
                id
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Resource id
                  "%
                  | optional,
                ..
              },
          openstackDataTypeKwargs = {
                "kwargs:"
                  | {  .. }
                  | doc m%"
                  A dictionary of keys and values that is not validated but will override other values in the resource config.
                  "%
                  | optional,
                ..
              },
          openstackDataTypeName = {
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Resource name.
                  "%
                  | optional,
                ..
              },
          openstackExternalResource = {
                use_external_resource
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Indicate whether the resource exists or if Cloudify should create the resource, true if you are bringing an existing resource, false if you want cloudify to create it.
                  "%
                  | optional,
                ..
              },
          openstackRecordSetType = predicates.contract_from_predicate
              definitions.predicate.openstackRecordSetType,
          openstackTypeClientConfig = {
                auth_url
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Your OpenStack Client Authorization URL.
                  "%
                  | optional,
                ca_cert
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Path to CA certificate to validate OpenStack's endpoint with.
                  "%
                  | optional,
                insecure
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  If true, SSL validation is skipped.
                  "%
                  | optional,
                kwargs
                  | {  .. }
                  | doc m%"
                  A dictionary of keys and values that is not validated
                  but will override other values in the client config.
                  "%
                  | optional,
                logging
                  | definitions.contract.openstackTypesLogging
                  | doc m%"
                  Logging configuration.
                  "%
                  | optional,
                password
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Your OpenStack password.
                  "%
                  | optional,
                project_domain_id
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The Project domain id
                  "%
                  | optional,
                project_domain_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Project domain name to operate on.
                  "%
                  | optional,
                project_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The name of your OpenStack project.
                  "%
                  | optional,
                region_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The region where you want this particular resource to be created.
                  "%
                  | optional,
                tenant_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The name of your OpenStack tenant.
                  "%
                  | optional,
                user_domain_id
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  The user domain id
                  "%
                  | optional,
                user_domain_name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Domain name to operate on.
                  "%
                  | optional,
                username
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Your OpenStack username.
                  "%
                  | optional,
                ..
              },
          openstackTypesFlavor = predicates.contract_from_predicate
              definitions.predicate.openstackTypesFlavor,
          openstackTypesFloatingIP = predicates.contract_from_predicate
              definitions.predicate.openstackTypesFloatingIP,
          openstackTypesGroup = predicates.contract_from_predicate
              definitions.predicate.openstackTypesGroup,
          openstackTypesHostAggregate = predicates.contract_from_predicate
              definitions.predicate.openstackTypesHostAggregate,
          openstackTypesImage = predicates.contract_from_predicate
              definitions.predicate.openstackTypesImage,
          openstackTypesKeyPair = predicates.contract_from_predicate
              definitions.predicate.openstackTypesKeyPair,
          openstackTypesLogging
            | doc m%"
            For logging groups' configuration. Each level can be one of the following values:
            critical/error/warning/info/debug/notset
            "%
            = predicates.contract_from_predicate
              definitions.predicate.openstackTypesLogging,
          openstackTypesNetwork = predicates.contract_from_predicate
              definitions.predicate.openstackTypesNetwork,
          openstackTypesPort = predicates.contract_from_predicate
              definitions.predicate.openstackTypesPort,
          openstackTypesProject = predicates.contract_from_predicate
              definitions.predicate.openstackTypesProject,
          openstackTypesRole = predicates.contract_from_predicate
              definitions.predicate.openstackTypesRole,
          openstackTypesRouter = predicates.contract_from_predicate
              definitions.predicate.openstackTypesRouter,
          openstackTypesSecurityGroup = predicates.contract_from_predicate
              definitions.predicate.openstackTypesSecurityGroup,
          openstackTypesSecurityGroupRule = predicates.contract_from_predicate
              definitions.predicate.openstackTypesSecurityGroupRule,
          openstackTypesSubnet = predicates.contract_from_predicate
              definitions.predicate.openstackTypesSubnet,
          openstackTypesUser = predicates.contract_from_predicate
              definitions.predicate.openstackTypesUser,
          openstackTypesVolume = predicates.contract_from_predicate
              definitions.predicate.openstackTypesVolume,
          openstackTypesVolumeType = predicates.contract_from_predicate
              definitions.predicate.openstackTypesVolumeType,
          openstackTypesZoneType = predicates.contract_from_predicate
              definitions.predicate.openstackTypesZoneType,
          restTemplateInputs = {
                force_rerun
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Rerun operation if on next operation rerun
                  "%
                  | optional,
                params
                  | {  .. }
                  | doc m%"
                  Template parameters. Default is empty dictionary. Merged
                  with params from node properties and has 'ctx' key for
                  current action context.
                  "%
                  | optional,
                prerender
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Prerender template before run calls jinja render=>yaml parse.
                  Default is yaml parse=>jinja render.
                  "%
                  | optional,
                remove_calls
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Remove calls list from results. Default: save calls in
                  runtime properties.
                  "%
                  | optional,
                retry_count
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Rerun count on warning on caught warnings
                  "%
                  | optional,
                retry_sleep
                  | definitions.contract.cloudifyIntegerOrGetInput
                  | doc m%"
                  Sleep between rerun
                  "%
                  | optional,
                save_path
                  | definitions.contract.cloudifyBooleanOrGetInput
                  | doc m%"
                  Save result to runtime properties key. Default is directly
                  save to runtime properties.
                  "%
                  | optional,
                template_file
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Template path in blueprint directory
                  "%
                  | optional,
                ..
              },
          tags
            | doc m%"
            Tags to add to an EC2 resource
            "%
            = predicates.contract_from_predicate definitions.predicate.tags,
          terraformConfig
            | doc m%"
            Terraform directories for executions.
            "%
            = definitions.contract.nodeTypeTerraformDirectoryConfig,
          terraformTypesBackend = {
                name
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Some name.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Should be a dictionary of key/values.
                  "%
                  | optional,
                ..
              },
          terraformTypesRootModule = {
                backend
                  | definitions.contract.terraformTypesBackend
                  | doc m%"
                  If a backend is not defined in source,
                  and you want to use a specific backend, define that here.
                  "%
                  | optional,
                environment_variables
                  | {  .. }
                  | doc m%"
                  A dictionary of environment variables.
                  "%
                  | optional,
                source
                  | definitions.contract.cloudifyStringOrGetInput
                  | doc m%"
                  Path or URL to the ZIP file containing the Terraform project.
                  If this is a path, then it must be relative to the blueprint's root.
                  "%,
                variables
                  | {  .. }
                  | doc m%"
                  A dictionary of variables.
                  "%
                  | optional,
                ..
              },
        },
    predicate = {
          ansiblePlaybookConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  additional_args =
                    definitions.predicate.cloudifyStringOrGetInput,
                  additional_playbook_files = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  ansible_become =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  ansible_env_vars = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          ANSIBLE_HOST_KEY_CHECKING = predicates.isType '"Bool",
                          ANSIBLE_INVALID_TASK_ATTRIBUTE_FAILED =
                            predicates.isType '"Bool",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  ansible_playbook_executable_path =
                    definitions.predicate.cloudifyStringOrGetInput,
                  debug_level = definitions.predicate.cloudifyIntegerOrGetInput,
                  options_config = predicates.isType 'Record,
                  playbook_path =
                    definitions.predicate.cloudifyStringOrGetInput,
                  playbook_source_path =
                    definitions.predicate.cloudifyStringOrGetInput,
                  remerge_sources =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  run_data = predicates.isType 'Record,
                  save_playbook =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  scp_extra_args =
                    definitions.predicate.cloudifyStringOrGetInput,
                  sensitive_keys = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  sftp_extra_args =
                    definitions.predicate.cloudifyStringOrGetInput,
                  site_yaml_path =
                    definitions.predicate.cloudifyStringOrGetInput,
                  sources = definitions.predicate.cloudifyStringOrGetInput,
                  ssh_common_args =
                    definitions.predicate.cloudifyStringOrGetInput,
                  ssh_extra_args =
                    definitions.predicate.cloudifyStringOrGetInput,
                  start_at_task =
                    definitions.predicate.cloudifyStringOrGetInput,
                  timeout = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          ansiblePlaybookInputs = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  additional_args = predicates.isType '"String",
                  ansible_env_vars = predicates.isType '"String",
                  ansible_playbook_executable_path = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                  debug_level = predicates.isType '"String",
                  options_config = predicates.isType '"String",
                  playbook_path = predicates.isType '"String",
                  playbook_source_path = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                  remerge_sources = predicates.isType '"String",
                  run_data = predicates.isType '"String",
                  save_playbook = predicates.isType '"String",
                  scp_extra_args = predicates.isType '"String",
                  sensitive_keys = predicates.isType '"String",
                  sftp_extra_args = predicates.isType '"String",
                  site_yaml_path = predicates.isType '"String",
                  sources = predicates.isType '"String",
                  ssh_common_args = predicates.isType '"String",
                  ssh_extra_args = predicates.isType '"String",
                  start_at_task = predicates.isType '"String",
                  timeout = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          awsClientConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  aws_access_key_id =
                    definitions.predicate.cloudifyStringOrGetInput,
                  aws_secret_access_key =
                    definitions.predicate.cloudifyStringOrGetInput,
                  region_name = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          awsConnectionConfig
            | doc m%"
            A dictionary of values to pass to authenticate with the AWS API.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  aws_access_key_id =
                    definitions.predicate.cloudifyStringOrGetInput,
                  aws_secret_access_key =
                    definitions.predicate.cloudifyStringOrGetInput,
                  region_name =
                    definitions.predicate.cloudifyGetStringOrAwsRegion,
                }
                {  }
                true
                predicates.always
              ],
          awsRegion = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "us-east-1",
                  "us-east-2",
                  "us-west-1",
                  "us-west-2",
                  "af-south-1",
                  "ap-east-1",
                  "ap-south-1",
                  "ap-southeast-1",
                  "ap-northeast-2",
                  "ap-northeast-3",
                  "ap-northeast-1",
                  "ap-southeast-2",
                  "ca-central-1",
                  "cn-north-1",
                  "cn-northwest-1",
                  "eu-central-1",
                  "eu-west-1",
                  "eu-west-2",
                  "eu-south-1",
                  "eu-west-3",
                  "eu-north-1",
                  "me-south-1",
                  "sa-east-1",
                  "us-gov-east-1",
                  "us-gov-west-1"
                ]
              ],
          awsResourceId
            | doc m%"
            The AWS resource ID of the external resource, if
            use_external_resource is true. Otherwise it is an empty string.
            "%
            = predicates.isType '"String",
          cloudifyBooleanOrGetInput = predicates.anyOf
              [
                predicates.isType '"Bool",
                definitions.predicate.cloudifyGetIntrinsicFunction
              ],
          cloudifyDataTypesAgentConfig
            | doc m%"
            Cloudify agent configuration schema.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "install_method" ],
                predicates.records.record
                {
                  disable_requiretty =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  env = predicates.always,
                  extra = predicates.isType 'Record,
                  heartbeat = definitions.predicate.cloudifyIntegerOrGetInput,
                  install_method =
                    definitions.predicate.cloudifyStringOrGetInput,
                  key = definitions.predicate.cloudifyStringOrGetInput,
                  max_workers = definitions.predicate.cloudifyIntegerOrGetInput,
                  min_workers = definitions.predicate.cloudifyIntegerOrGetInput,
                  network = definitions.predicate.cloudifyStringOrGetInput,
                  password = definitions.predicate.cloudifyStringOrGetInput,
                  port = definitions.predicate.cloudifyIntegerOrGetInput,
                  process_management = predicates.isType 'Record,
                  service_name = definitions.predicate.cloudifyStringOrGetInput,
                  user = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureComputeAvailabilitySetConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163607.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  platformFaultDomainCount =
                    definitions.predicate.cloudifyIntegerOrGetInput,
                  platformUpdateDomainCount =
                    definitions.predicate.cloudifyIntegerOrGetInput,
                  sku = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureComputeManagedClusterConfig
            | doc m%"
            See https://docs.microsoft.com/en-us/rest/api/aks/managedclusters
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addon_profiles = predicates.isType 'Record,
                  agent_pool_profiles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              availabilityZones = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                              count = predicates.isType '"Number",
                              enableNodePublicIP = predicates.isType '"Bool",
                              name = predicates.isType 'Record,
                              osType = predicates.isType '"String",
                              vmSize = predicates.isType '"String",
                            }
                            {  }
                            true
                            predicates.always
                          ]
                        ])
                      ],
                  dns_prefix = definitions.predicate.cloudifyStringOrGetInput,
                  enable_rbac = definitions.predicate.cloudifyBooleanOrGetInput,
                  kubernetes_version =
                    definitions.predicate.cloudifyStringOrGetInput,
                  linux_profile = predicates.isType 'Record,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  network_profile = predicates.isType 'Record,
                  service_principal_profile = predicates.isType 'Record,
                  tags = predicates.isType 'Record,
                  windows_profile = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureComputeVirtualMachineConfig
            | doc m%"
            https://msdn.microsoft.com/en-us/library/azure/mt163591.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  hardwareProfile =
                    definitions.predicate.cloudifyStringOrGetInput,
                  osProfile = predicates.isType 'Record,
                  spot_instance =
                    definitions.predicate.cloudifyDatatypesAzureComputeVirtualMachineSpotConfig,
                  storageProfile =
                    definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureComputeVirtualMachineSpotConfig
            | doc m%"
            check the parameters from this link : https://www.shorturl.at/wHTU2
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  billing_profile = predicates.isType 'Record,
                  eviction_policy =
                    definitions.predicate.cloudifyStringOrGetInput,
                  is_spot_instance =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  "priority" = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  certificate = definitions.predicate.cloudifyStringOrGetInput,
                  client_id = definitions.predicate.cloudifyStringOrGetInput,
                  client_secret =
                    definitions.predicate.cloudifyStringOrGetInput,
                  cloud_environment =
                    definitions.predicate.cloudifyStringOrGetInput,
                  endpoint_resource =
                    definitions.predicate.cloudifyStringOrGetInput,
                  endpoint_verify =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  endpoints_active_directory =
                    definitions.predicate.cloudifyStringOrGetInput,
                  endpoints_resource_manager =
                    definitions.predicate.cloudifyStringOrGetInput,
                  scale_name_separator =
                    definitions.predicate.cloudifyStringOrGetInput,
                  scale_name_suffix_chars =
                    definitions.predicate.cloudifyStringOrGetInput,
                  subscription_id =
                    definitions.predicate.cloudifyStringOrGetInput,
                  tenant_id = definitions.predicate.cloudifyStringOrGetInput,
                  thumbprint = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureNetworkIPConfigurationConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "privateIPAllocationMethod" ],
                predicates.records.record
                {
                  privateIPAddress =
                    definitions.predicate.cloudifyStringOrGetInput,
                  privateIPAllocationMethod =
                    definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureNetworkLoadBalancerConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163574.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  backendAddressPools = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  frontendIPConfigurations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  inboundNatRules = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  loadBalancingRules = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  probes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureNetworkLoadBalancerIncomingNATRuleConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163574.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "backendPort", "frontendPort", "protocol" ],
                predicates.records.record
                {
                  backendPort = definitions.predicate.cloudifyIntegerOrGetInput,
                  frontendPort =
                    definitions.predicate.cloudifyIntegerOrGetInput,
                  protocol = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureNetworkLoadBalancerProbeConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163574.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "port" ],
                predicates.records.record
                {
                  intervalInSeconds =
                    definitions.predicate.cloudifyIntegerOrGetInput,
                  numberOfProbes =
                    definitions.predicate.cloudifyIntegerOrGetInput,
                  port = definitions.predicate.cloudifyIntegerOrGetInput,
                  protocol = definitions.predicate.cloudifyStringOrGetInput,
                  requestPath = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureNetworkLoadBalancerRuleConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163574.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "backendPort", "frontendPort", "protocol" ],
                predicates.records.record
                {
                  backendPort = definitions.predicate.cloudifyIntegerOrGetInput,
                  enableFloatingIP =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  frontendPort =
                    definitions.predicate.cloudifyIntegerOrGetInput,
                  idleTimeoutInMinutes =
                    definitions.predicate.cloudifyIntegerOrGetInput,
                  loadDistribution =
                    definitions.predicate.cloudifyStringOrGetInput,
                  protocol = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureNetworkNetworkInterfaceCardConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163668.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  dnsSettings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  ipConfigurations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  networkSecurityGroups = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureNetworkNetworkSecurityGroupConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163656.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  securityRules = predicates.anyOf
                      [
                        predicates.isType 'Record,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf (predicates.isType 'Record)
                        ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureNetworkNetworkSecurityRuleConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163645.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "access",
                  "destinationAddressPrefix",
                  "direction",
                  "priority",
                  "protocol",
                  "sourceAddressPrefix"
                ],
                predicates.records.record
                {
                  access = definitions.predicate.cloudifyStringOrGetInput,
                  description = definitions.predicate.cloudifyStringOrGetInput,
                  destinationAddressPrefix =
                    definitions.predicate.cloudifyStringOrGetInput,
                  destinationPortRange =
                    definitions.predicate.cloudifyStringOrGetInput,
                  direction = definitions.predicate.cloudifyStringOrGetInput,
                  "priority" = definitions.predicate.cloudifyIntegerOrGetInput,
                  protocol = definitions.predicate.cloudifyStringOrGetInput,
                  sourceAddressPrefix =
                    definitions.predicate.cloudifyStringOrGetInput,
                  sourcePortRange =
                    definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureNetworkPublicIPAddressConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163590.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "publicIPAllocationMethod" ],
                predicates.records.record
                {
                  domainNameLabel =
                    definitions.predicate.cloudifyStringOrGetInput,
                  idleTimeoutInMinutes =
                    definitions.predicate.cloudifyIntegerOrGetInput,
                  publicIPAllocationMethod =
                    definitions.predicate.cloudifyStringOrGetInput,
                  reverseFqdn = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureNetworkRouteConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt459110.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "addressPrefix", "nextHopType" ],
                predicates.records.record
                {
                  addressPrefix = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                  nextHopIpAddress = predicates.isType '"String",
                  nextHopType = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureNetworkRouteTableConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt502548.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { routes = definitions.predicate.cloudifyStringOrGetInput, }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureNetworkSubnetConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163621.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addressPrefix =
                    definitions.predicate.cloudifyStringOrGetInput,
                  networkSecurityGroup =
                    definitions.predicate.cloudifyIntegerOrGetInput,
                  routeTable = definitions.predicate.cloudifyIntegerOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureNetworkVirtualNetworkConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163661.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "addressSpace" ],
                predicates.records.record
                {
                  addressSpace = predicates.isType 'Record,
                  dhcpOptions = predicates.isType 'Record,
                  subnets = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureStorageDataDiskConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "size" ],
                predicates.records.record
                {
                  container_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  force_delete =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  size = definitions.predicate.cloudifyIntegerOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureStorageFileShareConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fail_on_exist =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  metadata = predicates.isType 'Record,
                  quota = definitions.predicate.cloudifyIntegerOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesAzureStorageStorageAccountConfig
            | doc m%"
            See https://msdn.microsoft.com/en-us/library/mt163564.aspx
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accountType = definitions.predicate.cloudifyStringOrGetInput,
                  encryption = predicates.isType 'Record,
                  keySource = predicates.isType 'Record,
                  networkAcls = predicates.isType 'Record,
                  supportsHttpsTrafficOnly = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesBlueprint = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  blueprint_archive =
                    definitions.predicate.cloudifyStringOrGetInput,
                  external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  id = predicates.always,
                  main_file_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesDeployment = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  all_outputs = definitions.predicate.cloudifyBooleanOrGetInput,
                  external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  id = definitions.predicate.cloudifyStringOrGetInput,
                  inputs = predicates.isType 'Record,
                  logs = predicates.isType 'Record,
                  outputs = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesDeploymentProxy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "blueprint", "deployment" ],
                predicates.records.record
                {
                  blueprint = definitions.predicate.cloudifyDatatypesBlueprint,
                  deployment =
                    definitions.predicate.cloudifyDatatypesDeployment,
                  executions_start_args = predicates.isType 'Record,
                  reexecute = definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesFile = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "file_path", "mode", "owner", "resource_path" ],
                predicates.records.record
                {
                  allow_failure =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  file_path = definitions.predicate.cloudifyStringOrGetInput,
                  mode = definitions.predicate.cloudifyIntegerOrGetInput,
                  owner = definitions.predicate.cloudifyStringOrGetInput,
                  resource_path =
                    definitions.predicate.cloudifyStringOrGetInput,
                  template_variables = predicates.isType 'Record,
                  use_sudo = definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesFtpAuth = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ignore_host = definitions.predicate.cloudifyBooleanOrGetInput,
                  ip = definitions.predicate.cloudifyStringOrGetInput,
                  password = definitions.predicate.cloudifyStringOrGetInput,
                  port = definitions.predicate.cloudifyIntegerOrGetInput,
                  tls = definitions.predicate.cloudifyBooleanOrGetInput,
                  user = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesHelmApiOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_key = definitions.predicate.cloudifyStringOrGetInput,
                  host = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesHelmAuthenticationVariant
            | doc m%"
            Type representing all authentication variants.
             for different Kubernetes cloud providers.
             Each property represents separate supported variant of authentication.
             You should choose one variant and fill in only on property.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  gcp_service_account =
                    definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesHelmClientConfig
            | doc m%"
            Configuration properties for Helm to interact with kubernetes cluster.
             If kube_config file not provided then kube_token and kube_api_server should provided.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  authentication =
                    definitions.predicate.cloudifyDatatypesHelmAuthenticationVariant,
                  configuration =
                    definitions.predicate.cloudifyDatatypesHelmConfigurationVariant,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesHelmConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  executable_path =
                    definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesHelmConfigurationVariant
            | doc m%"
            Type representing all Kubernetes API configuration variants. Each property represents separate supported variant of configuration. For now, until Helm support "--insecure" one of "blueprint_file_name",
                  "manager_file_path" and "file_content" must be used.
                  "api_key" inputs will override kubeconfig data.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_options =
                    definitions.predicate.cloudifyDatatypesHelmApiOptions,
                  blueprint_file_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  file_content = definitions.predicate.cloudifyStringOrGetInput,
                  manager_file_path =
                    definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesHelmReleaseConfig
            | doc m%"
            configuration properties for release node type.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "chart", "name" ],
                predicates.records.record
                {
                  chart = definitions.predicate.cloudifyStringOrGetInput,
                  flags =
                    definitions.predicate.cloudifyDatatypesHelmSetFlagsList,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  set_values =
                    definitions.predicate.cloudifyDatatypesHelmSetFlagsList,
                  values_file = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesHelmRepoConfig
            | doc m%"
            configuration properties for repo node type.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "repo_url" ],
                predicates.records.record
                {
                  flags =
                    definitions.predicate.cloudifyDatatypesHelmSetFlagsList,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  repo_url = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesHelmSetFlagsList = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    name = predicates.isType '"String",
                    value = predicates.always,
                  }
                  {  }
                  true
                  predicates.always
                ]),
                predicates.records.record {  } {  } false predicates.never
              ],
          cloudifyDatatypesKey = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  algorithm = definitions.predicate.cloudifyStringOrGetInput,
                  bits = definitions.predicate.cloudifyIntegerOrGetInput,
                  comment = definitions.predicate.cloudifyStringOrGetInput,
                  key_name = definitions.predicate.cloudifyStringOrGetInput,
                  openssh_format =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  passphrase = definitions.predicate.cloudifyStringOrGetInput,
                  private_key_path =
                    definitions.predicate.cloudifyStringOrGetInput,
                  public_key_path =
                    definitions.predicate.cloudifyStringOrGetInput,
                  unvalidated = predicates.always,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesNode = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { id = definitions.predicate.cloudifyStringOrGetInput, }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesNodeInstance = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  id = definitions.predicate.cloudifyStringOrGetInput,
                  node = definitions.predicate.cloudifyDatatypesNode,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesNodeInstanceProxy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "blueprint", "deployment" ],
                predicates.records.record
                {
                  blueprint = definitions.predicate.cloudifyDatatypesBlueprint,
                  deployment =
                    definitions.predicate.cloudifyDatatypesDeployment,
                  executions_start_args = predicates.isType 'Record,
                  node_instance =
                    definitions.predicate.cloudifyDatatypesNodeInstance,
                  reexecute = definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          cloudifyDatatypesTerminalAuth = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  criticals = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  errors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  exit_command = definitions.predicate.cloudifyStringOrGetInput,
                  ip = definitions.predicate.cloudifyStringOrGetInput,
                  key_content = definitions.predicate.cloudifyStringOrGetInput,
                  password = definitions.predicate.cloudifyStringOrGetInput,
                  port = definitions.predicate.cloudifyIntegerOrGetInput,
                  promt_check = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  smart_device =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  store_logs = definitions.predicate.cloudifyBooleanOrGetInput,
                  user = definitions.predicate.cloudifyStringOrGetInput,
                  warnings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          cloudifyGetAttribute = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  get_attribute = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          cloudifyGetInput = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  get_input = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          cloudifyGetIntrinsicFunction = predicates.anyOf
              [
                definitions.predicate.cloudifyGetInput,
                definitions.predicate.cloudifyGetSecret,
                definitions.predicate.cloudifyGetAttribute,
                definitions.predicate.cloudifyGetProperty
              ],
          cloudifyGetProperty = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  get_property = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          cloudifyGetSecret = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  get_secret = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          cloudifyGetStringOrAwsRegion
            | doc m%"
            The server region name, such as us-east-1.
            (Not us-east-1b, which is an availability zone, or
            US East, which is a Region.)
            US East (N. Virginia) - us-east-1
            US East (Ohio) - us-east-2
            US West (N. California) - us-west-1
            US West (Oregon) - us-west-2
            Africa (Cape Town) - af-south-1
            Asia Pacific (Hong Kong) - ap-east-1
            Asia Pacific (Mumbai) - ap-south-1
            Asia Pacific (Seoul) - ap-northeast-2
            Asia Pacific (Osaka-Local) - ap-northeast-3
            Asia Pacific (Singapore) - ap-southeast-1
            Asia Pacific (Sydney) - ap-southeast-2
            Asia Pacific (Tokyo) - ap-northeast-1
            Canada (Central) - ca-central-1
            China (Beijing) - cn-north-1
            China (Ningxia) - cn-northwest-1
            Europe (Frankfurt) - eu-central-1
            Europe (Ireland) - eu-west-1
            Europe (London) - eu-west-2
            Europe (Milan) - eu-south-1
            Europe (Paris) - eu-west-3
            Europe (Stockholm) - eu-north-1
            Middle East (Bahrain) - me-south-1
            South America (São Paulo) - sa-east-1
            AWS GovCloud (US-East) - us-gov-east-1
            AWS GovCloud (US) - us-gov-west-1
            "%
            = predicates.anyOf
              [
                definitions.predicate.awsRegion,
                definitions.predicate.cloudifyGetInput
              ],
          cloudifyIntegerOrGetInput = predicates.anyOf
              [
                predicates.isType 'Integer,
                definitions.predicate.cloudifyGetIntrinsicFunction
              ],
          cloudifyStringOrGetInput = predicates.anyOf
              [
                predicates.isType '"String",
                definitions.predicate.cloudifyGetIntrinsicFunction
              ],
          dataType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  derived_from = predicates.isType '"String",
                  description = predicates.isType '"String",
                  properties = predicates.isType 'Record,
                }
                {  }
                false
                predicates.never
              ],
          dataTypes
            | doc m%"
            To use data_types, the definitions version must be cloudify_dsl_1_2 or higher.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                { "" = definitions.predicate.dataType, }
                true
                predicates.always
              ],
          dockerClientConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  docker_host = definitions.predicate.cloudifyStringOrGetInput,
                  docker_rest_port =
                    definitions.predicate.cloudifyIntegerOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          dockerInstallationConfig
            | doc m%"
            Docker Installation type
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  install_script =
                    definitions.predicate.cloudifyStringOrGetInput,
                  install_url = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          dockerMachine
            | doc m%"
            Docker Machine IP,User,Private_key
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  container_volume =
                    definitions.predicate.cloudifyStringOrGetInput,
                  docker_ip = definitions.predicate.cloudifyStringOrGetInput,
                  docker_key = definitions.predicate.cloudifyStringOrGetInput,
                  docker_user = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          gcpExternalResource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { use_external_resource = predicates.isType '"Bool", }
                {  }
                true
                predicates.always
              ],
          gcpResourceId = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { resource_id = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          inputProperty
            | doc m%"
            inputs are parameters that are injected into a blueprint when a deployment is created. These parameters can be referenced by using the get_input intrinsic function.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  constraints = definitions.predicate.inputPropertyConstraints,
                  "default" = predicates.always,
                  description = predicates.isType '"String",
                  required = predicates.isType '"Bool",
                  type = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "string",
                            "integer",
                            "float",
                            "boolean",
                            "list",
                            "dict",
                            "regex"
                          ]
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          inputPropertyConstraints
            | doc m%"
            The constraints the input value must comply with. Read more details about the format and usage of the constraints in the Constraints section below.
            "%
            = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    equal = predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String",
                          predicates.isType '"Bool",
                          predicates.isType 'Integer
                        ],
                    greater_or_equal = predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String",
                          predicates.isType '"Bool",
                          predicates.isType 'Integer
                        ],
                    greater_than = predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String",
                          predicates.isType '"Bool",
                          predicates.isType 'Integer
                        ],
                    less_or_equal = predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String",
                          predicates.isType '"Bool",
                          predicates.isType 'Integer
                        ],
                    less_than = predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String",
                          predicates.isType '"Bool",
                          predicates.isType 'Integer
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.always
              ],
          kubernetesTypesAbstractResource
            | doc m%"
            Type defining common base structure for any Kubernetes resource
            It is some kind of wrapper for native Kubernetes YAML definition
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kind" ],
                predicates.records.record
                {
                  apiVersion = definitions.predicate.cloudifyStringOrGetInput,
                  kind = definitions.predicate.cloudifyStringOrGetInput,
                  metadata = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          kubernetesTypesApiMapping
            | doc m%"
            Type containing python Kubernetes API objects and methods definitions for all supported operations
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  create = definitions.predicate.kubernetesTypesApiMappingEntry,
                  delete = definitions.predicate.kubernetesTypesApiMappingEntry,
                  read = definitions.predicate.kubernetesTypesApiMappingEntry,
                  update = definitions.predicate.kubernetesTypesApiMappingEntry,
                }
                {  }
                true
                predicates.always
              ],
          kubernetesTypesApiMappingEntry
            | doc m%"
            Type defining python Kubernetes API objects and methods definitions for particular operation
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "api", "method" ],
                predicates.records.record
                {
                  api = definitions.predicate.cloudifyStringOrGetInput,
                  method = definitions.predicate.cloudifyStringOrGetInput,
                  payload = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          kubernetesTypesAuthenticationVariant
            | doc m%"
            Type representing all authentication variants
            for different Kubernetes cloud providers.
            Each property represents separate supported variant of authentication.
            You should choose one variant and fill in only on property.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  gcp_service_account =
                    definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          kubernetesTypesClientConfig
            | doc m%"
            Configuration properties of kubernetes API and
            authentication properties of Kubernetes Cloud providers.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  authentication =
                    definitions.predicate.kubernetesTypesAuthenticationVariant,
                  configuration =
                    definitions.predicate.kubernetesTypesConfigurationVariant,
                }
                {  }
                true
                predicates.always
              ],
          kubernetesTypesClusterRoleDefinitio
            | doc m%"
            Type defining single Kubernetes resource e.g. ClusterRole, ...
            It is some kind of wrapper for native Kubernetes YAML definition
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                definitions.predicate.kubernetesTypesAbstractResource
              ],
          kubernetesTypesConfigClassResourceDefinition
            | doc m%"
            Type defining Kubernetes resource for storing data.
            It is some kind of wrapper for native Kubernetes YAML definition
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.kubernetesTypesResourceDefinition,
                  predicates.records.record
                  { data = predicates.isType 'Record, }
                  {  }
                  true
                  predicates.always
                ]
              ],
          kubernetesTypesConfigurationVariant
            | doc m%"
            Type representing all Kubernetes API configuration variants.
            Each property represents separate supported variant of configuration.
            You should choose one variant and fill in only on property.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          api_key =
                            definitions.predicate.cloudifyStringOrGetInput,
                          cert_file =
                            definitions.predicate.cloudifyStringOrGetInput,
                          debug =
                            definitions.predicate.cloudifyBooleanOrGetInput,
                          host = definitions.predicate.cloudifyStringOrGetInput,
                          key_file =
                            definitions.predicate.cloudifyStringOrGetInput,
                          ssl_ca_cert =
                            definitions.predicate.cloudifyStringOrGetInput,
                          verify_ssl =
                            definitions.predicate.cloudifyBooleanOrGetInput,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  blueprint_file_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  file_content = definitions.predicate.cloudifyStringOrGetInput,
                  manager_file_path =
                    definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          kubernetesTypesFileResource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  resource_path =
                    definitions.predicate.cloudifyStringOrGetInput,
                  target_path = definitions.predicate.cloudifyStringOrGetInput,
                  template_variables = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          kubernetesTypesResourceDefinition
            | doc m%"
            Type defining single Kubernetes resource e.g. Pod, Service, ...
            It is some kind of wrapper for native Kubernetes YAML definition
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.kubernetesTypesAbstractResource,
                  predicates.records.record
                  { spec = predicates.isType 'Record, }
                  {  }
                  true
                  predicates.always
                ]
              ],
          kubernetesTypesRoleBindingDefinitio
            | doc m%"
            Type defining single Kubernetes resource e.g. Pod, Service, ...
            It is some kind of wrapper for native Kubernetes YAML definition
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.kubernetesTypesAbstractResource,
                  predicates.records.record
                  {
                    roleRef = predicates.isType 'Record,
                    subjects = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.cloudifyStringOrGetInput
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          kubernetesTypesRoleDefinitio
            | doc m%"
            Type defining single Kubernetes resource e.g. Role, ...
            It is some kind of wrapper for native Kubernetes YAML definition
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.kubernetesTypesAbstractResource,
                  predicates.records.record
                  {
                    rules = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.cloudifyStringOrGetInput
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          kubernetesTypesSecretDefinition
            | doc m%"
            Secret holds secret data of a certain type.
            The total bytes of the values in the Data field must be less than MaxSecretSize bytes
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.kubernetesTypesAbstractResource,
                  predicates.records.record
                  {
                    data = predicates.isType 'Record,
                    stringData = predicates.isType 'Record,
                    type = definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          kubernetesTypesServiceAccountDefinition
            | doc m%"
            ServiceAccount binds together: a name, understood by users,
            and perhaps by peripheral systems, for an identity a principal
            that can be authenticated and authorized * a set of secrets
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.kubernetesTypesAbstractResource,
                  predicates.records.record
                  {
                    automountServiceAccountToken =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                    imagePullSecrets = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.cloudifyStringOrGetInput
                        ],
                    secrets = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.cloudifyStringOrGetInput
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          kubernetesTypesStorageClassResourceDefinition
            | doc m%"
            Type defining single Kubernetes resource e.g. StorageClass
            It is some kind of wrapper for native Kubernetes YAML definition
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.kubernetesTypesAbstractResource,
                  predicates.records.record
                  {
                    parameters = predicates.isType 'Record,
                    provisioner = predicates.isType 'Record,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTemplate = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.aws.ec2.Vpc", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  { properties = definitions.predicate.nodeTypeAWSEC2VPC, }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.aws.ec2.InternetGateway",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties =
                      definitions.predicate.nodeTypeAWSInternetGateway,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.aws.ec2.Subnet", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  { properties = definitions.predicate.nodeTypeAWSEC2Subnet, }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const "cloudify.nodes.aws.ec2.RouteTable",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties = definitions.predicate.nodeTypeAWSEC2RouteTable,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.aws.ec2.Route", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  { properties = definitions.predicate.nodeTypeAWSEC2Route, }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const "cloudify.nodes.aws.ec2.ElasticIP",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties = definitions.predicate.nodeTypeAWSEC2ElasticIP,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const "cloudify.nodes.aws.ec2.NATGateway",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties = definitions.predicate.nodeTypeAWSEC2NATGateway,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.aws.ec2.SecurityGroup",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties =
                      definitions.predicate.nodeTypeAWSEC2SecurityGroup,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.aws.ec2.SecurityGroupRuleIngress",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties =
                      definitions.predicate.nodeTypeAWSEC2SecurityGroupRuleIngress,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const "cloudify.nodes.aws.ec2.Interface",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties = definitions.predicate.nodeTypeAWSEC2Interface,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.aws.ec2.Image", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  { properties = definitions.predicate.nodeTypeAWSEC2Image, }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const "cloudify.nodes.aws.ec2.Instances",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties = definitions.predicate.nodeTypeAWSEC2Instances,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const "cloudify.nodes.aws.ec2.EBSVolume",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties = definitions.predicate.nodeTypeAWSEC2EBSVolume,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.aws.ec2.EBSAttachment",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties =
                      definitions.predicate.nodeTypeAWSEC2EBSAttachment,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.docker.images", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeDockerImagesInterfaces,
                    properties =
                      definitions.predicate.nodeTypeDockerImagesProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const "cloudify.nodes.docker.containers",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeDockerContainersInterfaces,
                    properties =
                      definitions.predicate.nodeTypeDockerContainersProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.docker.host", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeDockerHostInterfaces,
                    properties =
                      definitions.predicate.nodeTypeDockerHostProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.docker.host_details",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeDockerHostDetailsInterfaces,
                    properties =
                      definitions.predicate.nodeTypeDockerHostDetailsProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.docker.image", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeDockerImageInterfaces,
                    properties =
                      definitions.predicate.nodeTypeDockerImageProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.docker.container", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeDockerContainerInterfaces,
                    properties =
                      definitions.predicate.nodeTypeDockerContainerProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.docker.container_files",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeDockerContainerFilesInterfaces,
                    properties =
                      definitions.predicate.nodeTypeDockerContainerFilesProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.docker.ansible_playbook",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeDockerAnsiblePlaybookInterfaces,
                    properties =
                      definitions.predicate.nodeTypeDockerAnsiblePlaybookProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.docker.terraform_module",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeDockerTerraformModuleInterfaces,
                    properties =
                      definitions.predicate.nodeTypeDockerTerraformModuleProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const "cloudify.kubernetes.nodes.Master",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties =
                      definitions.predicate.nodeTypeKubernetesNodesMasterProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.ResourceBase",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesResourceBase,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.ResourceWithValidateStatus",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesResourceWithValidateStatus,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.BlueprintDefinedResource",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.ClusterRoleBinding",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesClusterRoleBindingProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.RoleBinding",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesRoleBinding,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.Role",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesRoleProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.ClusterRole",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesClusterRoleProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.Secret",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesSecretProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.ServiceAccount",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesServiceAccountProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.Deployment",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesDeploymentProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.Node",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesNodeProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.Namespace",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesNamespaceProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const "cloudify.kubernetes.resources.Pod",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesPodProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.ReplicaSet",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesReplicaSetProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.ReplicationController",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesReplicationControllerProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.DaemonSet",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesDaemonSetProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.CustomResourceDefinition",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesCustomResourceDefinitionProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.Service",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesServiceProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.PersistentVolume",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesPersistentVolumeProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.ConfigMap",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesConfigMapProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.StorageClass",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesStorageClassProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.StatefulSet",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesStatefulSetProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.PodSecurityPolicy",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesPodSecurityPolicyProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.NetworkPolicy",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesNetworkPolicyProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.Ingress",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesIngressProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.PersistentVolumeClaim",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesPersistentVolumeClaimProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.CustomBlueprintDefinedResource",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.CustomBlueprintDefinedResource",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.FileDefinedResource",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesFileDefinedResourceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesFileDefinedResourceProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.kubernetes.resources.MultipleFileDefinedResources",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeKubernetesResourcesMultipleFileDefinedResourcesInterfaces,
                    properties =
                      definitions.predicate.nodeTypeKubernetesResourcesMultipleFileDefinedResourcesProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.terraform", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeTerraformInterfaces,
                    properties =
                      definitions.predicate.nodeTypeTerraformProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.terraform.Module", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeTerraformModuleInterfaces,
                    properties =
                      definitions.predicate.nodeTypeTerraformModuleProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.terraform.Module", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeTerraformModuleInterfaces,
                    properties =
                      definitions.predicate.nodeTypeTerraformModuleProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.ansible.Executor", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeAnsibleExecutorInterfaces,
                    properties =
                      definitions.predicate.nodeTypeAnsibleExecutorProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.openstack.NetworkBase",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties =
                      definitions.predicate.nodeTypeOpenstackNetworkBaseProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const "cloudify.nodes.openstack.Network",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackNetworkInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackNetworkProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.openstack.Subnet", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackSubnetInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackSubnetProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.openstack.Port", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackPortInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackPortProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.openstack.Router", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackRouterInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackRouterProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.openstack.FloatingIP",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackFloatingIPInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackFloatingIPProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.openstack.SecurityGroup",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackSecurityGroupInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackSecurityGroupProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.openstack.SecurityGroupRule",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackSecurityGroupRuleInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackSecurityGroupRuleProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.openstack.RBACPolicy",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties =
                      definitions.predicate.nodeTypeOpenstackRBACPolicyProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.openstack.Server", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties =
                      definitions.predicate.nodeTypeOpenstackServerProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.openstack.WindowsServer",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties =
                      definitions.predicate.nodeTypeOpenstackWindowsServerProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const "cloudify.nodes.openstack.KeyPair",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackKeyPairInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackKeyPairProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.openstack.HostAggregate",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackHostAggregateInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackHostAggregateProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.openstack.Image", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackImageInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackImageProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.openstack.Flavor", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackFlavorInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackFlavorProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.openstack.User", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackUserInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackUserProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.openstack.Group", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackGroupInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackGroupProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.openstack.Role", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackRoleInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackRoleProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const "cloudify.nodes.openstack.Project",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackProjectInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackProjectProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.openstack.Volume", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackVolumeInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackVolumeProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.openstack.VolumeType",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackVolumeTypeInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackVolumeTypeProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.openstack.Zone", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackZoneInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackZoneProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.openstack.RecordSet",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeOpenstackRecordSetInterfaces,
                    properties =
                      definitions.predicate.nodeTypeOpenstackRecordSetProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.DeploymentProxy", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyNodesDeploymentProxyInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyNodesDeploymentProxyProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const "cloudify.nodes.NodeInstanceProxy",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties =
                      definitions.predicate.nodeTypeCloudifyNodesNodeInstanceProxyProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.nodes.CloudInit.CloudConfig",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyNodesCloudInitCloudConfigInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyNodesCloudInitCloudConfigProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.keys.nodes.RSAKey", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyNodesRSAKeyInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyNodesRSAKeyProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.terminal.raw", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyTerminalRawInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyTerminalRawProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.File", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyNodesFileInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyNodesFileProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.ftp", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyNodesFTPInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyNodesFTPProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.rest.Requests", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyRestRequestsInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyRestRequestsProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.rest.BunchRequests", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyRestBunchRequestsInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyRestBunchRequestsProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.secrets.Writer", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyNodesSecretsWriterInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyNodesSecretsWriterProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.secrets.Reader", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyNodesSecretsReaderInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyNodesSecretsReaderProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.ResourceGroup",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesResourceGroupInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesResourceGroupProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.storage.StorageAccount",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesStorageStorageAccountInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesStorageStorageAccountProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.storage.DataDisk",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesStorageDataDisktInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesStorageDataDiskProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.storage.FileShare",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesStorageFileShareInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesStorageFileShareProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.network.VirtualNetwork",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkVirtualNetworkInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkVirtualNetworkProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.network.NetworkSecurityGroup",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkNetworkSecurityGroupInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkNetworkSecurityGroupProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.network.NetworkSecurityRule",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkNetworkSecurityRuleInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkNetworkSecurityRuleProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.network.Subnet",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkSubnetInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkSubnetProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.network.RouteTable",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkRouteTableInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkRouteTableProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.network.Route",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkRouteInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkRouteProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.network.NetworkInterfaceCard",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkNetworkInterfaceCardInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkNetworkInterfaceCardProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.network.IPConfiguration",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkIPConfigurationProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.network.PublicIPAddress",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkPublicIPAddressInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkPublicIPAddressProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.compute.AvailabilitySet",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesComputeAvailabilitySetInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesComputeAvailabilitySetProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.compute.VirtualMachine",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesComputeVirtualMachineInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesComputeVirtualMachineProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.compute.WindowsVirtualMachine",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesComputeWindowsVirtualMachineInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesComputeWindowsVirtualMachineProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.compute.VirtualMachineExtension",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesComputeVirtualMachineExtensionInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesComputeVirtualMachineExtensionProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.network.LoadBalancer",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkLoadBalancerInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkLoadBalancerProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.network.LoadBalancer.BackendAddressPool",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkLoadBalancerBackendAddressPoolInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkLoadBalancerBackendAddressPoolProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.network.LoadBalancer.Probe",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkLoadBalancerProbeInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkLoadBalancerProbeProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.network.LoadBalancer.IncomingNATRule",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkLoadBalancerIncomingNATRuleInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkLoadBalancerIncomingNATRuleProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.network.LoadBalancer.Rule",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkLoadBalancerRuleInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesNetworkLoadBalancerRuleProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.azure.Deployment", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureDeploymentInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureDeploymentProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.compute.ContainerService",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesComputeContainerServiceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesComputeContainerServiceProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.azure.nodes.Plan", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesPlanInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesPlanProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.azure.nodes.WebApp", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesWebAppInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesWebAppProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.PublishingUser",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesPublishingUserInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesPublishingUserProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  {
                    type = predicates.const
                        "cloudify.azure.nodes.compute.ManagedCluster",
                  }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyAzureNodesComputeManagedClusterInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyAzureNodesComputeManagedClusterProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.gcp.project", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyGCPProjectInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyGCPProjectProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.gcp.nodes.Instance", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeCloudifyGCPNodesInstanceInterfaces,
                    properties =
                      definitions.predicate.nodeTypeCloudifyGCPNodesInstanceProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.helm.Binary", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    properties =
                      definitions.predicate.nodeTypeHelmBinaryProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.helm.Release", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeHelmReleaseInterfaces,
                    properties =
                      definitions.predicate.nodeTypeHelmReleaseProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.const "cloudify.nodes.helm.Repo", }
                  {  }
                  true
                  predicates.always)
                  (predicates.records.record
                  {
                    interfaces =
                      definitions.predicate.nodeTypeHelmRepoInterfaces,
                    properties =
                      definitions.predicate.nodeTypeHelmRepoProperties,
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always
                ],
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  capabilities = predicates.isType 'Record,
                  instances = predicates.isType 'Record,
                  interfaces = definitions.predicate.nodeTemplateInterfaces,
                  properties = predicates.isType 'Record,
                  relationships =
                    definitions.predicate.nodeTemplateRelationships,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "cloudify.nodes.Root",
                              "cloudify.nodes.Tier",
                              "cloudify.nodes.Compute",
                              "cloudify.nodes.Container",
                              "cloudify.nodes.Network",
                              "cloudify.nodes.Subnet",
                              "cloudify.nodes.Router",
                              "cloudify.nodes.Port",
                              "cloudify.nodes.VirtualIP",
                              "cloudify.nodes.SecurityGroup",
                              "cloudify.nodes.LoadBalancer",
                              "cloudify.nodes.Volume",
                              "cloudify.nodes.FileSystem",
                              "cloudify.nodes.ObjectStorage",
                              "cloudify.nodes.SoftwareComponent",
                              "cloudify.nodes.WebServer",
                              "cloudify.nodes.ApplicationServer",
                              "cloudify.nodes.DBMS",
                              "cloudify.nodes.MessageBugServer",
                              "cloudify.nodes.ApplicationModule",
                              "cloudify.nodes.Component",
                              "cloudify.nodes.ServiceComponent",
                              "cloudify.nodes.SharedResource",
                              "cloudify.nodes.aws.dynamodb.Table",
                              "cloudify.nodes.aws.iam.Group",
                              "cloudify.nodes.aws.iam.AccessKey",
                              "cloudify.nodes.aws.iam.LoginProfile",
                              "cloudify.nodes.aws.iam.User",
                              "cloudify.nodes.aws.iam.Role",
                              "cloudify.nodes.aws.iam.RolePolicy",
                              "cloudify.nodes.aws.iam.InstanceProfile",
                              "cloudify.nodes.aws.iam.Policy",
                              "cloudify.nodes.aws.lambda.Function",
                              "cloudify.nodes.aws.lambda.Invoke",
                              "cloudify.nodes.aws.lambda.Permission",
                              "cloudify.nodes.aws.rds.Instance",
                              "cloudify.nodes.aws.rds.InstanceReadReplica",
                              "cloudify.nodes.aws.rds.SubnetGroup",
                              "cloudify.nodes.aws.rds.OptionGroup",
                              "cloudify.nodes.aws.rds.Option",
                              "cloudify.nodes.aws.rds.ParameterGroup",
                              "cloudify.nodes.aws.rds.Parameter",
                              "cloudify.nodes.aws.route53.HostedZone",
                              "cloudify.nodes.aws.route53.RecordSet",
                              "cloudify.nodes.aws.SQS.Queue",
                              "cloudify.nodes.aws.SNS.Topic",
                              "cloudify.nodes.aws.SNS.Subscription",
                              "cloudify.nodes.aws.elb.LoadBalancer",
                              "cloudify.nodes.aws.elb.Classic.LoadBalancer",
                              "cloudify.nodes.aws.elb.Classic.HealthCheck",
                              "cloudify.nodes.aws.elb.Listener",
                              "cloudify.nodes.aws.elb.Classic.Listener",
                              "cloudify.nodes.aws.elb.Rule",
                              "cloudify.nodes.aws.elb.TargetGroup",
                              "cloudify.nodes.aws.elb.Classic.Policy",
                              "cloudify.nodes.aws.elb.Classic.Policy.Stickiness",
                              "cloudify.nodes.aws.s3.BaseBucket",
                              "cloudify.nodes.aws.s3.BaseBucketObject",
                              "cloudify.nodes.aws.s3.Bucket",
                              "cloudify.nodes.aws.s3.BucketPolicy",
                              "cloudify.nodes.aws.s3.BucketLifecycleConfiguration",
                              "cloudify.nodes.aws.s3.BucketTagging",
                              "cloudify.nodes.aws.s3.BucketObject",
                              "cloudify.nodes.aws.ec2.BaseType",
                              "cloudify.nodes.aws.ec2.Vpc",
                              "cloudify.nodes.aws.ec2.VpcPeering",
                              "cloudify.nodes.aws.ec2.VpcPeeringRequest",
                              "cloudify.nodes.aws.ec2.VpcPeeringAcceptRequest",
                              "cloudify.nodes.aws.ec2.VpcPeeringRejectRequest",
                              "cloudify.nodes.aws.ec2.Subnet",
                              "cloudify.nodes.aws.ec2.SecurityGroup",
                              "cloudify.nodes.aws.ec2.SecurityGroupRuleIngress",
                              "cloudify.nodes.aws.ec2.SecurityGroupRuleEgress",
                              "cloudify.nodes.aws.ec2.NATGateway",
                              "cloudify.nodes.aws.ec2.Interface",
                              "cloudify.nodes.aws.ec2.Instances",
                              "cloudify.nodes.aws.ec2.Keypair",
                              "cloudify.nodes.aws.ec2.ElasticIP",
                              "cloudify.nodes.aws.ec2.NetworkACL",
                              "cloudify.nodes.aws.ec2.NetworkAclEntry",
                              "cloudify.nodes.aws.ec2.DHCPOptions",
                              "cloudify.nodes.aws.ec2.VPNGateway",
                              "cloudify.nodes.aws.ec2.VPNConnection",
                              "cloudify.nodes.aws.ec2.VPNConnectionRoute",
                              "cloudify.nodes.aws.ec2.CustomerGateway",
                              "cloudify.nodes.aws.ec2.InternetGateway",
                              "cloudify.nodes.aws.ec2.RouteTable",
                              "cloudify.nodes.aws.ec2.Route",
                              "cloudify.nodes.aws.ec2.Image",
                              "cloudify.nodes.aws.ec2.Tags",
                              "cloudify.nodes.aws.ec2.EBSVolume",
                              "cloudify.nodes.aws.ec2.EBSAttachment",
                              "cloudify.nodes.aws.autoscaling.Group",
                              "cloudify.nodes.aws.autoscaling.LaunchConfiguration",
                              "cloudify.nodes.aws.autoscaling.Policy",
                              "cloudify.nodes.aws.autoscaling.LifecycleHook",
                              "cloudify.nodes.aws.autoscaling.NotificationConfiguration",
                              "cloudify.nodes.aws.cloudwatch.Alarm",
                              "cloudify.nodes.aws.cloudwatch.Rule",
                              "cloudify.nodes.aws.cloudwatch.Event",
                              "cloudify.nodes.aws.cloudwatch.Target",
                              "cloudify.nodes.aws.efs.FileSystem",
                              "cloudify.nodes.aws.efs.MountTarget",
                              "cloudify.nodes.aws.efs.FileSystemTags",
                              "cloudify.nodes.aws.kms.CustomerMasterKey",
                              "cloudify.nodes.aws.kms.Alias",
                              "cloudify.nodes.aws.kms.Grant",
                              "cloudify.nodes.aws.CloudFormation.Stack",
                              "cloudify.nodes.aws.ecs.Cluster",
                              "cloudify.nodes.aws.ecs.Service",
                              "cloudify.nodes.aws.ecs.TaskDefinition",
                              "cloudify.nodes.swift.s3.Bucket",
                              "cloudify.nodes.swift.s3.BucketObject",
                              "cloudify.nodes.aws.eks.Cluster",
                              "cloudify.nodes.aws.eks.NodeGroup",
                              "cloudify.azure.nodes.storage.StorageAccount",
                              "cloudify.azure.nodes.storage.DataDisk",
                              "cloudify.azure.nodes.storage.FileShare",
                              "cloudify.azure.nodes.network.VirtualNetwork",
                              "cloudify.azure.nodes.network.NetworkSecurityGroup",
                              "cloudify.azure.nodes.network.NetworkSecurityRule",
                              "cloudify.azure.nodes.network.Subnet",
                              "cloudify.azure.nodes.network.RouteTable",
                              "cloudify.azure.nodes.network.Route",
                              "cloudify.azure.nodes.network.NetworkInterfaceCard",
                              "cloudify.azure.nodes.network.IPConfiguration",
                              "cloudify.azure.nodes.network.PublicIPAddress",
                              "cloudify.azure.nodes.compute.AvailabilitySet",
                              "cloudify.azure.nodes.compute.VirtualMachine",
                              "cloudify.azure.nodes.compute.WindowsVirtualMachine",
                              "cloudify.azure.nodes.compute.VirtualMachineExtension",
                              "cloudify.azure.nodes.network.LoadBalancer",
                              "cloudify.azure.nodes.network.LoadBalancer.BackendAddressPool",
                              "cloudify.azure.nodes.network.LoadBalancer.Probe",
                              "cloudify.azure.nodes.network.LoadBalancer.IncomingNATRule",
                              "cloudify.azure.nodes.network.LoadBalancer.Rule",
                              "cloudify.azure.Deployment",
                              "cloudify.azure.nodes.compute.ContainerService",
                              "cloudify.azure.nodes.Plan",
                              "cloudify.azure.nodes.WebApp",
                              "cloudify.azure.nodes.PublishingUser",
                              "cloudify.azure.nodes.compute.ManagedCluster",
                              "cloudify.gcp.project",
                              "cloudify.gcp.nodes.Instance",
                              "cloudify.gcp.nodes.InstanceGroup",
                              "cloudify.gcp.nodes.Volume",
                              "cloudify.gcp.nodes.Snapshot",
                              "cloudify.gcp.nodes.Network",
                              "cloudify.gcp.nodes.SubNetwork",
                              "cloudify.gcp.nodes.VPCNetworkPeering",
                              "cloudify.gcp.nodes.Route",
                              "cloudify.gcp.nodes.FirewallRule",
                              "cloudify.gcp.nodes.SecurityGroup",
                              "cloudify.gcp.nodes.Access",
                              "cloudify.gcp.nodes.KeyPair",
                              "cloudify.gcp.nodes.ExternalIP",
                              "cloudify.gcp.nodes.GlobalAddress",
                              "cloudify.gcp.nodes.StaticIP",
                              "cloudify.gcp.nodes.Address",
                              "cloudify.gcp.nodes.Image",
                              "cloudify.gcp.nodes.HealthCheck",
                              "cloudify.gcp.nodes.BackendService",
                              "cloudify.gcp.nodes.RegionBackendService",
                              "cloudify.gcp.nodes.UrlMap",
                              "cloudify.gcp.nodes.TargetProxy",
                              "cloudify.gcp.nodes.SslCertificate",
                              "cloudify.gcp.nodes.ForwardingRule",
                              "cloudify.gcp.nodes.GlobalForwardingRule",
                              "cloudify.gcp.nodes.DNSZone",
                              "cloudify.gcp.nodes.DNSRecord",
                              "cloudify.gcp.nodes.DNSAAAARecord",
                              "cloudify.gcp.nodes.DNSMXRecord",
                              "cloudify.gcp.nodes.DNSNSRecord",
                              "cloudify.gcp.nodes.DNSTXTRecord",
                              "cloudify.gcp.nodes.KubernetesCluster",
                              "cloudify.gcp.nodes.KubernetesNodePool",
                              "cloudify.gcp.nodes.KubernetesClusterMonitoring",
                              "cloudify.gcp.nodes.KubernetesClusterlegacyAbac",
                              "cloudify.gcp.nodes.KubernetesClusterNetworkPolicy",
                              "cloudify.gcp.nodes.Topic",
                              "cloudify.gcp.nodes.TopicPolicy",
                              "cloudify.gcp.nodes.TopicMessage",
                              "cloudify.gcp.nodes.Subscription",
                              "cloudify.gcp.nodes.SubscriptionPolicy",
                              "cloudify.gcp.nodes.Acknowledge",
                              "cloudify.gcp.nodes.PullRequest",
                              "cloudify.gcp.nodes.StackDriverGroup",
                              "cloudify.gcp.nodes.StackDriverTimeSeries",
                              "cloudify.gcp.nodes.StackDriverUpTimeCheckConfig",
                              "cloudify.gcp.nodes.LoggingSink",
                              "cloudify.gcp.nodes.LoggingExclusion",
                              "cloudify.gcp.nodes.Logging.BillingAccounts.sinks",
                              "cloudify.gcp.nodes.Logging.Folders.sinks",
                              "cloudify.gcp.nodes.Logging.Organizations.sinks",
                              "cloudify.gcp.nodes.Logging.Projects.sinks",
                              "cloudify.gcp.nodes.Logging.BillingAccounts.exclusions",
                              "cloudify.gcp.nodes.Logging.Folders.exclusions",
                              "cloudify.gcp.nodes.Logging.Organizations.exclusions",
                              "cloudify.gcp.nodes.Logging.Projects.exclusions",
                              "cloudify.gcp.nodes.Logging.Projects.metrics",
                              "cloudify.kubernetes.resources.StatefulSet",
                              "cloudify.nodes.helm.Binary",
                              "cloudify.nodes.helm.Release",
                              "cloudify.nodes.helm.Repo"
                            ]
                          ]
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          nodeTemplateInterface = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configure = definitions.predicate.nodeTemplateInterfaceAction,
                  delete = definitions.predicate.nodeTemplateInterfaceAction,
                }
                { "" = definitions.predicate.nodeTemplateInterfaceAction, }
                true
                predicates.always
              ],
          nodeTemplateInterfaceAction = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    executor = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "central_deployment_agent", "host_agent" ]
                        ],
                    implementation = predicates.isType '"String",
                    inputs = predicates.isType 'Record,
                    max_retries = predicates.isType '"Number",
                    retry_interval = predicates.isType '"Number",
                    timeone = predicates.isType '"Number",
                    timeout_recoverable = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          nodeTemplateInterfaces
            | doc m%"
            Interfaces enable you to map logical tasks to executable operations.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                { "" = definitions.predicate.nodeTemplateInterface, }
                true
                predicates.always
              ],
          nodeTemplateRelationship = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  connection_type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "all_to_all", "all_to_one" ]
                      ],
                  source_interfaces = predicates.isType 'Record,
                  target = predicates.isType '"String",
                  target_interfaces = predicates.isType 'Record,
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          nodeTemplateRelationships
            | doc m%"
            relationships enable you to define how nodes relate to one another. For example, a web_server node can be contained_in a vm node or an application node can be connected_to a database node.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.nodeTemplateRelationship
              ],
          nodeTemplates
            | doc m%"
            node_templates represent the actual instances of node types that eventually represent the running application/service, as described in the blueprint. node_templates are more commonly referred to as nodes. Nodes can comprise more than one instance. For example, you might define a node that contains two VMs. Each VM is a node_instance.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                { "" = definitions.predicate.nodeTemplate, }
                true
                predicates.always
              ],
          nodeType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  derived_from = predicates.isType '"String",
                  interfaces = predicates.isType 'Record,
                  properties = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeAWSEC2Base = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  Tags = definitions.predicate.tags,
                  client_config = definitions.predicate.awsConnectionConfig,
                  resource_id = definitions.predicate.awsResourceId,
                  use_external_resource = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeAWSEC2EBSAttachment = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  client_config = definitions.predicate.awsConnectionConfig,
                  resource_config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          kwargs = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required
                                [ "Device", "InstanceId", "VolumeId" ],
                                predicates.records.record
                                {
                                  Device =
                                    definitions.predicate.cloudifyStringOrGetInput,
                                  DryRun =
                                    definitions.predicate.cloudifyBooleanOrGetInput,
                                  InstanceId =
                                    definitions.predicate.cloudifyStringOrGetInput,
                                  VolumeId =
                                    definitions.predicate.cloudifyStringOrGetInput,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  resource_id = definitions.predicate.awsResourceId,
                  use_external_resource = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeAWSEC2EBSVolume = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeAWSEC2Base,
                  predicates.records.record
                  {
                    resource_config = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "AvailabilityZone" ],
                          predicates.records.record
                          {
                            AvailabilityZone =
                              definitions.predicate.cloudifyStringOrGetInput,
                            Size =
                              definitions.predicate.cloudifyIntegerOrGetInput,
                            kwargs = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    DryRun =
                                      definitions.predicate.cloudifyBooleanOrGetInput,
                                    Encrypted =
                                      definitions.predicate.cloudifyBooleanOrGetInput,
                                    Iops =
                                      definitions.predicate.cloudifyIntegerOrGetInput,
                                    KmsKeyId =
                                      definitions.predicate.cloudifyStringOrGetInput,
                                    OutpostArn =
                                      definitions.predicate.cloudifyStringOrGetInput,
                                    Size =
                                      definitions.predicate.cloudifyIntegerOrGetInput,
                                    SnapshotId =
                                      definitions.predicate.cloudifyStringOrGetInput,
                                    TagSpecifications = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              ResourceType =
                                                definitions.predicate.cloudifyStringOrGetInput,
                                              Tags = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.allOf
                                                    [
                                                      predicates.isType 'Record,
                                                      predicates.records.record
                                                      {
                                                        Key =
                                                          definitions.predicate.cloudifyStringOrGetInput,
                                                        Value =
                                                          definitions.predicate.cloudifyStringOrGetInput,
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
                                          ])
                                        ],
                                    VolumeType =
                                      definitions.predicate.cloudifyStringOrGetInput,
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    use_available_zones = predicates.isType '"Bool",
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeAWSEC2ElasticIP = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { client_config = definitions.predicate.awsClientConfig, }
                {  }
                true
                predicates.always
              ],
          nodeTypeAWSEC2Image = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeAWSEC2Base,
                  predicates.records.record
                  {
                    resource_config = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kwargs = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    Filters = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              Name = predicates.isType
                                                  '"String",
                                              Values = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
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
              ],
          nodeTypeAWSEC2Instances = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeAWSEC2Base,
                  predicates.records.record
                  {
                    agent_config = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          { install_method = predicates.isType '"String", }
                          {  }
                          true
                          predicates.always
                        ],
                    resource_config = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "MaxCount", "MinCount" ],
                          predicates.records.record
                          {
                            ImageId =
                              definitions.predicate.cloudifyStringOrGetInput,
                            InstanceType =
                              definitions.predicate.cloudifyStringOrGetInput,
                            LaunchTemplate = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    LaunchTemplateId =
                                      definitions.predicate.cloudifyStringOrGetInput,
                                    LaunchTemplateName =
                                      definitions.predicate.cloudifyStringOrGetInput,
                                    Version =
                                      definitions.predicate.cloudifyStringOrGetInput,
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            MaxCount =
                              definitions.predicate.cloudifyIntegerOrGetInput,
                            MinCount =
                              definitions.predicate.cloudifyIntegerOrGetInput,
                            kwargs = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    BlockDeviceMappings = predicates.isType
                                        'Record,
                                    Ipv6AddressCount =
                                      definitions.predicate.cloudifyIntegerOrGetInput,
                                    KernelId =
                                      definitions.predicate.cloudifyStringOrGetInput,
                                    KeyName =
                                      definitions.predicate.cloudifyStringOrGetInput,
                                    SecondaryPrivateIpAddressCount =
                                      definitions.predicate.cloudifyIntegerOrGetInput,
                                    SecurityGroupIds = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          definitions.predicate.cloudifyStringOrGetInput
                                        ],
                                    SubnetId =
                                      definitions.predicate.cloudifyStringOrGetInput,
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    use_ipv6_ip = predicates.isType '"Bool",
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeAWSEC2Interface = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeAWSEC2Base,
                  predicates.records.record
                  {
                    resource_config = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kwargs = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required [ "SubnetId" ],
                                  predicates.records.record
                                  {
                                    Description =
                                      definitions.predicate.cloudifyStringOrGetInput,
                                    Groups = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          definitions.predicate.cloudifyStringOrGetInput
                                        ],
                                    InterfaceType =
                                      definitions.predicate.cloudifyStringOrGetInput,
                                    Ipv6AddressCount =
                                      definitions.predicate.cloudifyIntegerOrGetInput,
                                    PrivateIpAddress =
                                      definitions.predicate.cloudifyStringOrGetInput,
                                    SecondaryPrivateIpAddressCount =
                                      definitions.predicate.cloudifyIntegerOrGetInput,
                                    SubnetId =
                                      definitions.predicate.cloudifyStringOrGetInput,
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
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
              ],
          nodeTypeAWSEC2NATGateway = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  Tags = definitions.predicate.tags,
                  client_config = definitions.predicate.awsClientConfig,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeAWSEC2Route = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  client_config = definitions.predicate.awsClientConfig,
                  resource_config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          kwargs = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  DestinationCidrBlock =
                                    definitions.predicate.cloudifyStringOrGetInput,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeAWSEC2RouteTable = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  Tags = definitions.predicate.tags,
                  client_config = definitions.predicate.awsClientConfig,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeAWSEC2SecurityGroup = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeAWSEC2Base,
                  predicates.records.record
                  {
                    resource_config = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "Description", "GroupName" ],
                          predicates.records.record
                          {
                            Description =
                              definitions.predicate.cloudifyStringOrGetInput,
                            GroupName =
                              definitions.predicate.cloudifyStringOrGetInput,
                            VpcId =
                              definitions.predicate.cloudifyStringOrGetInput,
                            kwargs = predicates.isType 'Record,
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
              ],
          nodeTypeAWSEC2SecurityGroupRuleIngress = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeAWSEC2Base,
                  predicates.records.record
                  {
                    resource_config = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            IpPermissions = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      FromPort = predicates.isType 'Integer,
                                      IpProtocol = predicates.isType '"String",
                                      IpRanges = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.records.record
                                            {
                                              CidrIp = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            true
                                            predicates.always
                                          ],
                                      ToPort = predicates.isType 'Integer,
                                    }
                                    {  }
                                    true
                                    predicates.always
                                  ])
                                ],
                            kwargs = predicates.isType 'Record,
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
              ],
          nodeTypeAWSEC2Subnet = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  Tags = definitions.predicate.tags,
                  client_config = definitions.predicate.awsClientConfig,
                  resource_config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          AvailabilityZone =
                            definitions.predicate.cloudifyStringOrGetInput,
                          CidrBlock =
                            definitions.predicate.cloudifyStringOrGetInput,
                          kwargs = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  Ipv6CidrBlock =
                                    definitions.predicate.cloudifyStringOrGetInput,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeAWSEC2VPC = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  Tags = definitions.predicate.tags,
                  client_config = definitions.predicate.awsClientConfig,
                  resource_config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          CidrBlock =
                            definitions.predicate.cloudifyStringOrGetInput,
                          kwargs = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  AmazonProvidedIpv6CidrBlock =
                                    definitions.predicate.cloudifyBooleanOrGetInput,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeAWSInternetGateway = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { client_config = definitions.predicate.awsClientConfig, }
                {  }
                true
                predicates.always
              ],
          nodeTypeAnsibleExecutorInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "ansible.cloudify_ansible.tasks.cleanup"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "ansible.cloudify_ansible.tasks.run" ]
                                      ],
                                  inputs =
                                    definitions.predicate.ansiblePlaybookInputs,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeAnsibleExecutorProperties = predicates.allOf
              [
                predicates.isType 'Record,
                definitions.predicate.ansiblePlaybookConfig
              ],
          nodeTypeCloudifyAzureDeploymentInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.deployment.create"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.deployment.delete"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureDeploymentProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "location", "name" ],
                predicates.records.record
                {
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  params = predicates.isType 'Record,
                  template = predicates.anyOf
                      [
                        definitions.predicate.cloudifyStringOrGetInput,
                        predicates.isType 'Record
                      ],
                  template_file =
                    definitions.predicate.cloudifyStringOrGetInput,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesComputeAvailabilitySetInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.compute.availabilityset.create"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.compute.availabilityset.delete"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesComputeAvailabilitySetProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureComputeAvailabilitySetConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesComputeContainerServiceInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "azure.cloudify_azure.resources.compute.container_service.create"
                                        ]
                                      ],
                                  inputs = predicates.always,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "azure.cloudify_azure.resources.compute.container_service.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesComputeContainerServiceProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "resource_group" ],
                predicates.records.record
                {
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  container_service_config =
                    definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_group =
                    definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesComputeManagedClusterInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "azure.cloudify_azure.resources.compute.managed_cluster.create"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          azure_config =
                                            definitions.predicate.cloudifyDatatypesAzureConfig,
                                          client_config =
                                            definitions.predicate.cloudifyDatatypesAzureConfig,
                                          cluster_name = predicates.isType
                                              '"String",
                                          resource_config =
                                            definitions.predicate.cloudifyDatatypesAzureComputeManagedClusterConfig,
                                          resource_group = predicates.isType
                                              '"String",
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "azure.cloudify_azure.resources.compute.managed_cluster.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesComputeManagedClusterProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "cluster_name",
                  "resource_config",
                  "resource_group",
                  "store_kube_config_in_runtime"
                ],
                predicates.records.record
                {
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  cluster_name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureComputeManagedClusterConfig,
                  resource_group =
                    definitions.predicate.cloudifyStringOrGetInput,
                  store_kube_config_in_runtime =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesComputeVirtualMachineExtensionInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          "create:" = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "azure.cloudify_azure.resources.compute.virtualmachineextension.create"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          resource_config = predicates.isType
                                              'Record,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.compute.virtualmachineextension.delete"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesComputeVirtualMachineExtensionProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  virtual_machine_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesComputeVirtualMachineInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          configure = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "azure.cloudify_azure.resources.compute.virtualmachine.configure"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          command_to_execute =
                                            definitions.predicate.cloudifyStringOrGetInput,
                                          file_uris = predicates.allOf
                                              [
                                                predicates.isType '"Array",
                                                predicates.arrays.arrayOf
                                                (predicates.isType '"String")
                                              ],
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesComputeVirtualMachineProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "resource_config" ],
                predicates.records.record
                {
                  agent_config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        definitions.predicate.cloudifyDataTypesAgentConfig
                      ],
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  ip = definitions.predicate.cloudifyStringOrGetInput,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  os_family = definitions.predicate.cloudifyStringOrGetInput,
                  plan = predicates.isType 'Record,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureComputeVirtualMachineConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  storage_endpoint =
                    definitions.predicate.cloudifyStringOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  use_public_ip =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesComputeWindowsVirtualMachineInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          configure = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "azure.cloudify_azure.resources.compute.virtualmachine.configure"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          command_to_execute =
                                            definitions.predicate.cloudifyStringOrGetInput,
                                          file_uris = predicates.allOf
                                              [
                                                predicates.isType '"Array",
                                                predicates.arrays.arrayOf
                                                (predicates.isType '"String")
                                              ],
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesComputeWindowsVirtualMachineProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeCloudifyAzureNodesComputeWindowsVirtualMachineProperties,
                  predicates.records.record
                  {
                    agent_config = predicates.isType 'Record,
                    os_family = definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeCloudifyAzureNodesNetworkIPConfigurationProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureNetworkIPConfigurationConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerBackendAddressPoolInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.loadbalancer.create_backend_pool"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.loadbalancer.delete_backend_pool"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerBackendAddressPoolProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  load_balancer_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.always,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerIncomingNATRuleInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.loadbalancer.create_incoming_nat_rule"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.loadbalancer.delete_incoming_nat_rule"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerIncomingNATRuleProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  load_balancer_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureNetworkLoadBalancerIncomingNATRuleConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          configure = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.loadbalancer.configure"
                                ]
                              ],
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.loadbalancer.create"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.loadbalancer.delete"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerProbeInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.loadbalancer.create_probe"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.loadbalancer.delete_probe"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerProbeProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  load_balancer_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureNetworkLoadBalancerProbeConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureNetworkLoadBalancerConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerRuleInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.loadbalancer.create_rule"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.loadbalancer.delete_rule"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkLoadBalancerRuleProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  load_balancer_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureNetworkLoadBalancerRuleConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkNetworkInterfaceCardInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          configure = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.networkinterfacecard.configure"
                                ]
                              ],
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.networkinterfacecard.create"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.networkinterfacecard.delete"
                                ]
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.networkinterfacecard.start"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkNetworkInterfaceCardProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  primary = predicates.always,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureNetworkNetworkInterfaceCardConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkNetworkSecurityGroupInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.networksecuritygroup.create"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.networksecuritygroup.delete"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkNetworkSecurityGroupProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureNetworkNetworkSecurityGroupConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkNetworkSecurityRuleInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.networksecurityrule.create"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.networksecurityrule.delete"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkNetworkSecurityRuleProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  network_security_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureNetworkNetworkSecurityRuleConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkPublicIPAddressInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.publicipaddress.create"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.publicipaddress.delete"
                                ]
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.publicipaddress.start"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkPublicIPAddressProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureNetworkPublicIPAddressConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkRouteInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.route.create"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.route.delete"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkRouteProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureNetworkRouteConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  route_table_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkRouteTableInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.routetable.create"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.routetable.delete"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkRouteTableProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  "location:" = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureNetworkRouteTableConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkSubnetInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { "cloudify.interfaces.lifecycle" = predicates.always, }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkSubnetProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureNetworkSubnetConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.always,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  virtual_network_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkVirtualNetworkInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.virtualnetwork.create"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.network.virtualnetwork.delete"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesNetworkVirtualNetworkProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureNetworkVirtualNetworkConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesPlanInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "azure.cloudify_azure.resources.app_service.plan.create"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          azure_config =
                                            definitions.predicate.cloudifyDatatypesAzureConfig,
                                          client_config =
                                            definitions.predicate.cloudifyDatatypesAzureConfig,
                                          name =
                                            definitions.predicate.cloudifyStringOrGetInput,
                                          resource_group =
                                            definitions.predicate.cloudifyStringOrGetInput,
                                          sku =
                                            definitions.predicate.cloudifyStringOrGetInput,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "azure.cloudify_azure.resources.app_service.plan.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesPlanProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "resource_group" ],
                predicates.records.record
                {
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_group =
                    definitions.predicate.cloudifyStringOrGetInput,
                  sku = definitions.predicate.cloudifyStringOrGetInput,
                  use_external_resource = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesPublishingUserInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "azure.cloudify_azure.resources.app_service.publishing_user.set_user"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          azure_config =
                                            definitions.predicate.cloudifyDatatypesAzureConfig,
                                          client_config =
                                            definitions.predicate.cloudifyDatatypesAzureConfig,
                                          user_details = predicates.isType
                                              'Record,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesPublishingUserProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "user_details" ],
                predicates.records.record
                {
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  user_details = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesResourceGroupInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.resourcegroup.create"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.resourcegroup.delete"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesResourceGroupProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesStorageDataDiskProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureStorageDataDiskConfig,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesStorageDataDisktInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.storage.disk.create_data_disk"
                                ]
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.storage.disk.delete_data_disk"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesStorageFileShareInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { "cloudify.interfaces.lifecycle" = predicates.always, }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesStorageFileShareProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureStorageFileShareConfig,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesStorageStorageAccountInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "azure.cloudify_azure.resources.storage.storageaccount.create"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesStorageStorageAccountProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_version = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  location = definitions.predicate.cloudifyStringOrGetInput,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesAzureStorageStorageAccountConfig,
                  resource_group_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  retry_after = definitions.predicate.cloudifyIntegerOrGetInput,
                  sku = definitions.predicate.cloudifyStringOrGetInput,
                  tags = predicates.isType 'Record,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesWebAppInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "azure.cloudify_azure.resources.app_service.webapp.create"
                                        ]
                                      ],
                                  inputs = predicates.always,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "azure.cloudify_azure.resources.app_service.webapp.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyAzureNodesWebAppProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "resource_group" ],
                predicates.records.record
                {
                  app_config = definitions.predicate.cloudifyStringOrGetInput,
                  azure_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  client_config =
                    definitions.predicate.cloudifyDatatypesAzureConfig,
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_group =
                    definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyGCPNodesInstanceInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          configure = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "gcp_plugin.cloudify_gcp.compute.instance.create"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          additional_settings =
                                            predicates.isType 'Record,
                                          can_ip_forward = predicates.isType
                                              '"Bool",
                                          external_ip = predicates.isType
                                              '"Bool",
                                          image_id = predicates.isType
                                              '"String",
                                          instance_type = predicates.isType
                                              '"String",
                                          name = predicates.isType '"String",
                                          scopes = predicates.allOf
                                              [
                                                predicates.isType '"Array",
                                                predicates.arrays.arrayOf
                                                (predicates.isType '"String")
                                              ],
                                          startup_script = predicates.isType
                                              '"String",
                                          tags = predicates.isType '"String",
                                          zone = predicates.isType '"String",
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "gcp_plugin.cloudify_gcp.compute.instance.delete"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          name = predicates.isType '"String",
                                          zone = predicates.isType '"String",
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "gcp_plugin.cloudify_gcp.compute.instance.start"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { name = predicates.isType '"String", }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyGCPNodesInstanceProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.gcpExternalResource,
                  definitions.predicate.gcpResourceId,
                  predicates.records.record
                  {
                    additional_settings = predicates.isType 'Record,
                    block_project_ssh_keys = predicates.isType '"Bool",
                    can_ip_forward = predicates.isType '"Bool",
                    external_ip = predicates.isType '"Bool",
                    gcp_config = predicates.isType 'Record,
                    image_id = predicates.isType '"String",
                    instance_type = predicates.isType '"String",
                    name = predicates.isType '"String",
                    scopes = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    startup_script = predicates.isType '"String",
                    tags = predicates.isType '"String",
                    use_public_ip = predicates.isType '"Bool",
                    zone = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeCloudifyGCPProjectInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "gcp_plugin.cloudify_gcp.admin.projects.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "gcp_plugin.cloudify_gcp.admin.projects.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyGCPProjectProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.gcpExternalResource,
                  definitions.predicate.gcpResourceId,
                  predicates.records.record
                  {
                    gcp_config = predicates.isType 'Record,
                    name = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeCloudifyNodesCloudInitCloudConfigInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          configure = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "cloudinit.cloudify_cloudinit.tasks.update"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "cloudinit.cloudify_cloudinit.tasks.update"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "cloudinit.cloudify_cloudinit.tasks.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "cloudinit.cloudify_cloudinit.tasks.update"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          stop = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "cloudinit.cloudify_cloudinit.tasks.update"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyNodesCloudInitCloudConfigProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  encode_base64 =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  header = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyNodesDeploymentProxyInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          configure = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.enum
                                        [
                                          "cfy_util.cloudify_deployment_proxy.tasks.create_deployment"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "cfy_util.cloudify_deployment_proxy.tasks.upload_blueprint"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "cfy_util.cloudify_deployment_proxy.tasks.delete_deployment"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "cfy_util.cloudify_deployment_proxy.tasks.execute_start"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          interval = predicates.isType 'Integer,
                                          timeout = predicates.isType 'Integer,
                                          workflow_id = predicates.isType
                                              '"String",
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          stop = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "cfy_util.cloudify_deployment_proxy.tasks.execute_start"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          resource_config =
                                            definitions.predicate.cloudifyDatatypesDeploymentProxy,
                                          workflow_id = predicates.isType
                                              '"String",
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyNodesDeploymentProxyProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  client = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          host = predicates.isType '"String",
                          password = predicates.isType '"String",
                          tenant = predicates.isType '"String",
                          username = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  plugins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  resource_config =
                    definitions.predicate.cloudifyDatatypesDeploymentProxy,
                  secrets = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyNodesFTPInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "cfy_ftp.cloudify_ftp.tasks.create" ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          files = predicates.isType 'Record,
                                          raw_files = predicates.isType 'Record,
                                          resource_config =
                                            definitions.predicate.cloudifyDatatypesFtpAuth,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "cfy_ftp.cloudify_ftp.tasks.delete" ]
                                      ],
                                  inputs = predicates.always,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyNodesFTPProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  files = predicates.isType 'Record,
                  raw_files = predicates.isType 'Record,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesFtpAuth,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyNodesFileInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "cfy_files.cloudify_files.tasks.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "cfy_files.cloudify_files.tasks.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyNodesFileProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  resource_config = definitions.predicate.cloudifyDatatypesFile,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyNodesNodeInstanceProxyProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeCloudifyNodesDeploymentProxyProperties,
                  predicates.records.record
                  {
                    resource_config =
                      definitions.predicate.cloudifyDatatypesNodeInstanceProxy,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeCloudifyNodesRSAKeyInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "keys.cloudify_ssh_key.operations.create"
                                        ]
                                      ],
                                  inputs = predicates.always,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "keys.cloudify_ssh_key.operations.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyNodesRSAKeyProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  key_name = definitions.predicate.cloudifyStringOrGetInput,
                  resource_config = definitions.predicate.cloudifyDatatypesKey,
                  use_secret_store =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  use_secrets_if_exist =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyNodesSecretsReaderInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "secrets.cloudify_secrets.tasks.read"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "secrets.cloudify_secrets.tasks.read"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyNodesSecretsReaderProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  keys = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  separator = definitions.predicate.cloudifyStringOrGetInput,
                  variant = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyNodesSecretsWriterInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "secrets.cloudify_secrets.tasks.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "secrets.cloudify_secrets.tasks.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "secrets.cloudify_secrets.tasks.update"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyNodesSecretsWriterProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  do_not_delete =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  entries = predicates.isType 'Record,
                  separator = definitions.predicate.cloudifyStringOrGetInput,
                  variant = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyRestBunchRequestsInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          configure = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "rest.cloudify_rest.tasks.bunch_execute"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          auth = predicates.isType 'Record,
                                          templates = predicates.isType 'Record,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "rest.cloudify_rest.tasks.bunch_execute"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          auth = predicates.isType 'Record,
                                          templates = predicates.isType 'Record,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "rest.cloudify_rest.tasks.bunch_execute"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          auth = predicates.isType 'Record,
                                          templates = predicates.isType 'Record,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "rest.cloudify_rest.tasks.bunch_execute"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          auth = predicates.isType 'Record,
                                          templates = predicates.isType 'Record,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          stop = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "rest.cloudify_rest.tasks.bunch_execute"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          auth = predicates.isType 'Record,
                                          templates = predicates.isType 'Record,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyRestBunchRequestsProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cert = definitions.predicate.cloudifyStringOrGetInput,
                  host = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  hosts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  params = predicates.isType 'Record,
                  port = definitions.predicate.cloudifyIntegerOrGetInput,
                  proxies = predicates.isType 'Record,
                  ssl = definitions.predicate.cloudifyBooleanOrGetInput,
                  timeout = definitions.predicate.cloudifyIntegerOrGetInput,
                  verify = definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyRestRequestsInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          configure = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "rest.cloudify_rest.tasks.execute" ]
                                      ],
                                  inputs =
                                    definitions.predicate.restTemplateInputs,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "rest.cloudify_rest.tasks.execute" ]
                                      ],
                                  inputs =
                                    definitions.predicate.restTemplateInputs,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "rest.cloudify_rest.tasks.execute" ]
                                      ],
                                  inputs =
                                    definitions.predicate.restTemplateInputs,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "rest.cloudify_rest.tasks.execute" ]
                                      ],
                                  inputs =
                                    definitions.predicate.restTemplateInputs,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          stop = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "rest.cloudify_rest.tasks.execute" ]
                                      ],
                                  inputs =
                                    definitions.predicate.restTemplateInputs,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyRestRequestsProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cert = definitions.predicate.cloudifyStringOrGetInput,
                  host = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  hosts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  params = predicates.isType 'Record,
                  port = definitions.predicate.cloudifyIntegerOrGetInput,
                  proxies = predicates.isType 'Record,
                  ssl = definitions.predicate.cloudifyBooleanOrGetInput,
                  timeout = definitions.predicate.cloudifyIntegerOrGetInput,
                  verify = definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyTerminalRawInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          configure = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "terminal.cloudify_terminal.tasks.run"
                                        ]
                                      ],
                                  inputs = predicates.isType 'Record,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "terminal.cloudify_terminal.tasks.run"
                                        ]
                                      ],
                                  inputs = predicates.isType 'Record,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "terminal.cloudify_terminal.tasks.run"
                                        ]
                                      ],
                                  inputs = predicates.isType 'Record,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "terminal.cloudify_terminal.tasks.run"
                                        ]
                                      ],
                                  inputs = predicates.isType 'Record,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          stop = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "terminal.cloudify_terminal.tasks.run"
                                        ]
                                      ],
                                  inputs = predicates.isType 'Record,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeCloudifyTerminalRawProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  terminal_auth =
                    definitions.predicate.cloudifyDatatypesTerminalAuth,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerAnsiblePlaybookInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.ansible.create_ansible_playbook"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.ansible.remove_ansible_playbook"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          precreate = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.ansible.set_playbook_config"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          additional_args = predicates.isType
                                              '"String",
                                          ansible_env_vars = predicates.isType
                                              'Record,
                                          ansible_playbook_executable_path =
                                            predicates.isType '"String",
                                          debug_level = predicates.isType
                                              'Integer,
                                          options_config = predicates.isType
                                              'Record,
                                          playbook_path = predicates.isType
                                              '"String",
                                          playbook_source_path =
                                            predicates.isType '"String",
                                          remerge_sources = predicates.isType
                                              '"Bool",
                                          run_data = predicates.isType 'Record,
                                          save_playbook = predicates.isType
                                              '"Bool",
                                          sensitive_keys = predicates.allOf
                                              [
                                                predicates.isType '"Array",
                                                predicates.arrays.arrayOf
                                                (predicates.isType '"String")
                                              ],
                                          site_yaml_path = predicates.isType
                                              '"String",
                                          sources = predicates.isType 'Record,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerAnsiblePlaybookProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  additional_args = predicates.isType '"String",
                  additional_playbook_files = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  ansible_become = predicates.isType '"Bool",
                  ansible_env_vars = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          ANSIBLE_HOST_KEY_CHECKING = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "True", "False" ]
                              ],
                          ANSIBLE_INVALID_TASK_ATTRIBUTE_FAILED =
                            predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "True", "False" ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  ansible_playbook_executable_path = predicates.isType
                      '"String",
                  debug_level = predicates.isType 'Integer,
                  docker_machine = definitions.predicate.dockerMachine,
                  options_config = predicates.isType 'Record,
                  playbook_path = predicates.isType '"String",
                  playbook_source_path = predicates.isType '"String",
                  remerge_sources = predicates.isType '"Bool",
                  run_data = predicates.isType 'Record,
                  save_playbook = predicates.isType '"Bool",
                  sensitive_keys = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  site_yaml_path = predicates.isType '"String",
                  sources = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerContainerFilesInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.tasks.prepare_container_files"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.tasks.remove_container_files"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerContainerFilesProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  resource_config = predicates.records.record
                      {
                        ansible_sources = predicates.isType 'Record,
                        destination = predicates.isType '"String",
                        docker_machine = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                ansible_sources = predicates.isType 'Record,
                                destination = predicates.isType '"String",
                                docker_machine =
                                  definitions.predicate.dockerMachine,
                                extra_files = predicates.isType '"String",
                                source = predicates.isType '"String",
                                terraform_sources = predicates.isType 'Record,
                              }
                              {  }
                              true
                              predicates.always
                            ],
                        extra_files = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                        source = predicates.isType '"String",
                        terraform_sources = predicates.isType 'Record,
                      }
                      {  }
                      true
                      predicates.always,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerContainerInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.tasks.create_container"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.tasks.remove_container"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          stop = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.tasks.remove_container"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          stop_command = predicates.anyOf
                                              [
                                                predicates.isType '"String",
                                                predicates.isType 'Record
                                              ],
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerContainerProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  client_config = definitions.predicate.dockerClientConfig,
                  resource_config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          container_args = predicates.isType 'Record,
                          image_tag =
                            definitions.predicate.cloudifyStringOrGetInput,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerContainersInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.tasks.list_containers"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerContainersProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { client_config = definitions.predicate.dockerClientConfig, }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerHostDetailsInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.tasks.list_host_details"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerHostDetailsProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { client_config = definitions.predicate.dockerClientConfig, }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerHostInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.tasks.install_docker"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.tasks.uninstall_docker"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerHostProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  docker_machine = definitions.predicate.dockerMachine,
                  resource_config =
                    definitions.predicate.dockerInstallationConfig,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerImageInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.tasks.build_image"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.tasks.remove_image"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerImageProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  client_config = definitions.predicate.dockerClientConfig,
                  resource_config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          image_content =
                            definitions.predicate.cloudifyStringOrGetInput,
                          tag = definitions.predicate.cloudifyStringOrGetInput,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerImagesInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.tasks.list_images"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerImagesProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { client_config = definitions.predicate.dockerClientConfig, }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerTerraformModuleInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.terraform.prepare_terraform_files"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "docker.cloudify_docker.terraform.remove_terraform_files"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeDockerTerraformModuleProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "resource_config", "terraform_plugins" ],
                predicates.records.record
                {
                  docker_machine = definitions.predicate.dockerMachine,
                  resource_config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "source" ],
                        predicates.records.record
                        {
                          backend = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  name = predicates.isType '"String",
                                  options = predicates.isType 'Record,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          environment_variables = predicates.isType 'Record,
                          source = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required [ "location" ],
                                  predicates.records.record
                                  {
                                    location = predicates.isType '"String",
                                    password = predicates.isType '"String",
                                    username = predicates.isType '"String",
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ]
                              ],
                          variables = predicates.isType 'Record,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  terraform_plugins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeHelmBinaryProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  helm_config =
                    definitions.predicate.cloudifyDatatypesHelmConfig,
                  installation_source =
                    definitions.predicate.cloudifyStringOrGetInput,
                  use_existing_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeHelmReleaseInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "helm.cloudify_helm.tasks.uninstall_release"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          flags =
                                            definitions.predicate.cloudifyDatatypesHelmSetFlagsList,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "helm.cloudify_helm.tasks.install_release"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          flags =
                                            definitions.predicate.cloudifyDatatypesHelmSetFlagsList,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeHelmReleaseProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "client_config", "resource_config" ],
                predicates.records.record
                {
                  client_config =
                    definitions.predicate.cloudifyDatatypesHelmClientConfig,
                  helm_config =
                    definitions.predicate.cloudifyDatatypesHelmConfig,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesHelmReleaseConfig,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeHelmRepoInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "helm.cloudify_helm.tasks.remove_repo"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          flags =
                                            definitions.predicate.cloudifyDatatypesHelmSetFlagsList,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "helm.cloudify_helm.tasks.add_repo" ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          flags =
                                            definitions.predicate.cloudifyDatatypesHelmSetFlagsList,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeHelmRepoProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  helm_config =
                    definitions.predicate.cloudifyDatatypesHelmConfig,
                  resource_config =
                    definitions.predicate.cloudifyDatatypesHelmRepoConfig,
                  use_external_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeKubernetesNodesMasterProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  authentication =
                    definitions.predicate.kubernetesTypesAuthenticationVariant,
                  configuration =
                    definitions.predicate.kubernetesTypesConfigurationVariant,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeKubernetesResourcesBlueprintDefinedResource
            | doc m%"
            
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesResourceWithValidateStatus,
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      definition =
                        definitions.predicate.kubernetesTypesResourceDefinition,
                      options = predicates.isType 'Record,
                      use_external_resource =
                        definitions.predicate.cloudifyBooleanOrGetInput,
                    }
                    {  }
                    true
                    predicates.always
                  ]
                ]
              ],
          nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces
            | doc m%"
            
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.enum
                                        [
                                          "kubernetes.cloudify_kubernetes.tasks.resource_create"
                                        ],
                                        definitions.predicate.cloudifyStringOrGetInput
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.enum
                                        [
                                          "kubernetes.cloudify_kubernetes.tasks.resource_delete"
                                        ],
                                        definitions.predicate.cloudifyStringOrGetInput
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          poststart = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.enum
                                        [
                                          "kubernetes.cloudify_kubernetes.tasks.resource_read"
                                        ],
                                        definitions.predicate.cloudifyStringOrGetInput
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.enum
                                        [
                                          "kubernetes.cloudify_kubernetes.tasks.resource_update"
                                        ],
                                        definitions.predicate.cloudifyStringOrGetInput
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeKubernetesResourcesClusterRoleBindingProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    definition =
                      definitions.predicate.kubernetesTypesRoleBindingDefinitio,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesClusterRoleProperties
            | doc m%"
            Definition of cluster role using native Kubernetes YAML spec
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesRoleProperties,
                  predicates.records.record
                  {
                    definition =
                      definitions.predicate.kubernetesTypesClusterRoleDefinitio,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesConfigMapProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    definition =
                      definitions.predicate.kubernetesTypesConfigClassResourceDefinition,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces,
                  predicates.records.record
                  {
                    "cloudify.interfaces.lifecycle" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            create = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    implementation = predicates.allOf
                                        [
                                          predicates.enum
                                          [
                                            "kubernetes.cloudify_kubernetes.tasks.custom_resource_create"
                                          ],
                                          definitions.predicate.cloudifyStringOrGetInput
                                        ],
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            delete = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    implementation = predicates.allOf
                                        [
                                          predicates.enum
                                          [
                                            "kubernetes.cloudify_kubernetes.tasks.custom_resource_delete"
                                          ],
                                          definitions.predicate.cloudifyStringOrGetInput
                                        ],
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
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
              ],
          nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    api_mapping =
                      definitions.predicate.kubernetesTypesApiMapping,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesCustomResourceDefinitionProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource
              ],
          nodeTypeKubernetesResourcesDaemonSetProperties = predicates.allOf
              [
                predicates.isType 'Record,
                definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource
              ],
          nodeTypeKubernetesResourcesDeploymentProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    validate_resource_status =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesFileDefinedResourceInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.enum
                                        [
                                          "kubernetes.cloudify_kubernetes.tasks.file_resource_create"
                                        ],
                                        definitions.predicate.cloudifyStringOrGetInput
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.enum
                                        [
                                          "kubernetes.cloudify_kubernetes.tasks.file_resource_delete"
                                        ],
                                        definitions.predicate.cloudifyStringOrGetInput
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          poststart = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.enum
                                        [
                                          "kubernetes.cloudify_kubernetes.tasks.file_resource_read"
                                        ],
                                        definitions.predicate.cloudifyStringOrGetInput
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeKubernetesResourcesFileDefinedResourceProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesResourceWithValidateStatus,
                  predicates.records.record
                  {
                    allow_node_redefinition =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                    file = definitions.predicate.kubernetesTypesFileResource,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesIngressProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  { definition = predicates.isType 'Record, }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesMultipleFileDefinedResourcesInterfaces =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "kubernetes.cloudify_kubernetes.tasks.multiple_file_resource_create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "kubernetes.cloudify_kubernetes.tasks.custom_resource_delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          poststart = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "kubernetes.cloudify_kubernetes.tasks.multiple_file_resource_delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeKubernetesResourcesMultipleFileDefinedResourcesProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesResourceWithValidateStatus,
                  predicates.records.record
                  {
                    allow_node_redefinition =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                    files = definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesNamespaceProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    use_external_resource =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesNetworkPolicyProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  { definition = predicates.isType 'Record, }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesNodeProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    use_external_resource =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesPersistentVolumeClaimProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  { definition = predicates.isType 'Record, }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesPersistentVolumeProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    validate_resource_status =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesPodProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    use_external_resource =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesPodSecurityPolicyProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  { definition = predicates.isType 'Record, }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesReplicaSetProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    use_external_resource =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesReplicationControllerProperties =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    use_external_resource =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesResourceBase
            | doc m%"
            
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allow_node_redefinition =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  client_config =
                    definitions.predicate.kubernetesTypesClientConfig,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeKubernetesResourcesResourceWithValidateStatus =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesResourceBase,
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      validate_resource_status =
                        definitions.predicate.cloudifyBooleanOrGetInput,
                    }
                    {  }
                    true
                    predicates.always
                  ]
                ]
              ],
          nodeTypeKubernetesResourcesRoleBinding = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    definition =
                      definitions.predicate.kubernetesTypesRoleBindingDefinitio,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesRoleProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    definition =
                      definitions.predicate.kubernetesTypesRoleDefinitio,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesSecretProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    definitions =
                      definitions.predicate.kubernetesTypesSecretDefinition,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesServiceAccountProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    definitions =
                      definitions.predicate.kubernetesTypesServiceAccountDefinition,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesServiceProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    validate_resource_status =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesStatefulSetProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  { definition = predicates.isType 'Record, }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeKubernetesResourcesStorageClassProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeKubernetesResourcesBlueprintDefinedResource,
                  predicates.records.record
                  {
                    definition =
                      definitions.predicate.kubernetesTypesStorageClassResourceDefinition,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackFlavorInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.flavor.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.flavor.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.flavor.list_flavors"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          details = predicates.isType '"Bool",
                                          query = predicates.isType 'Record,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.flavor.update"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackFlavorProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    extra_specs = predicates.isType 'Record,
                    resource_config =
                      definitions.predicate.openstackTypesFlavor,
                    tenants = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackFloatingIPInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.floating_ip.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.floating_ip.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.floating_ip.list_floating_ips"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { query = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.floating_ip.update"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.validation" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          creation = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.floating_ip.creation_validation"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackFloatingIPProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    allow_reallocation =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                    resource_config =
                      definitions.predicate.openstackTypesFloatingIP,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackGroupInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.group.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.group.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.group.list_groups"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { query = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.group.update"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackGroupProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    resource_config = definitions.predicate.openstackTypesGroup,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackHostAggregateInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          configure = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.host_aggregate.configure"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.host_aggregate.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.host_aggregate.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          add_hosts = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.host_aggregate.add_hosts"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          hosts = predicates.allOf
                                              [
                                                predicates.isType '"Array",
                                                predicates.arrays.arrayOf
                                                (predicates.isType '"String")
                                              ],
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.host_aggregate.list_aggregates"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          remove_hosts = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.host_aggregate.remove_hosts"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          hosts = predicates.allOf
                                              [
                                                predicates.isType '"Array",
                                                predicates.arrays.arrayOf
                                                (predicates.isType '"String")
                                              ],
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.host_aggregate.update"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackHostAggregateProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    hosts = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    metadata = predicates.isType 'Record,
                    resource_config =
                      definitions.predicate.openstackTypesHostAggregate,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackImageInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.image.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.image.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.image.start"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.image.list_images"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { query = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.image.update"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.validation" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          creation = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.image.creation_validation"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackImageProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    image_url = definitions.predicate.cloudifyStringOrGetInput,
                    resource_config = definitions.predicate.openstackTypesImage,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackKeyPairInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.keypair.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.keypair.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.keypair.list_keypairs"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.validation" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          creation = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.compute.keypair.creation_validation"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackKeyPairProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    resource_config =
                      definitions.predicate.openstackTypesKeyPair,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackNetworkBaseProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig
                ]
              ],
          nodeTypeOpenstackNetworkInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.network.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.network.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.network.list_networks"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { query = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.network.update"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.validation" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          creation = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.network.creation_validation"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackNetworkProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeOpenstackNetworkBaseProperties,
                  predicates.records.record
                  {
                    resource_config =
                      definitions.predicate.openstackTypesNetwork,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackPortInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.port.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.port.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.port.list_ports"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { query = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.port.update"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.validation" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          creation = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.port.creation_validation"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackPortProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    fixed_ip = definitions.predicate.cloudifyStringOrGetInput,
                    resource_config = definitions.predicate.openstackTypesPort,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackProjectInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.project.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.project.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.project.start"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          quota_dict = predicates.isType
                                              'Record,
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          get_quota = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.project.get_project_quota"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.project.list_projects"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { query = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update_project = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.project.update"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update_quota = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.project.update_project_quota"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { quota = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.validation" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          creation = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "openstack.openstack_plugin.resources.identity.project.creation_validation"
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackProjectProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    groups = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    quota = predicates.isType 'Record,
                    resource_config =
                      definitions.predicate.openstackTypesProject,
                    users = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackRBACPolicyProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeId,
                  predicates.records.record
                  {
                    action = definitions.predicate.cloudifyStringOrGetInput,
                    object_id = definitions.predicate.cloudifyStringOrGetInput,
                    object_type =
                      definitions.predicate.cloudifyStringOrGetInput,
                    target_tenant =
                      definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackRecordSetInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.dns_service.record_set.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.dns_service.record_set.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackRecordSetProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    resource_config =
                      definitions.predicate.openstackRecordSetType,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackRoleInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.role.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.role.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.role.list_roles"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { query = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.role.update"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackRoleProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    resource_config = definitions.predicate.openstackTypesRole,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackRouterInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.router.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.router.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.router.start"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { routes = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          stop = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.router.stop"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.router.list_routers"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { query = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.router.update"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.validation" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          creation = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.router.creation_validation"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackRouterProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    external_network =
                      definitions.predicate.cloudifyStringOrGetInput,
                    resource_config =
                      definitions.predicate.openstackTypesRouter,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackSecurityGroupInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          configure = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.security_group.configure"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          security_group_rules =
                                            predicates.anyOf
                                              [
                                                predicates.isType '"Array",
                                                predicates.isType 'Record
                                              ],
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.security_group.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.security_group.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.security_group.list_security_groups"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { query = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.security_group.update"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.validation" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          creation = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.security_group.creation_validation"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackSecurityGroupProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    disable_default_egress_rules =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                    resource_config =
                      definitions.predicate.openstackTypesSecurityGroup,
                    security_group_rules = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackSecurityGroupRuleInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeOpenstackSecurityGroupInterfaces,
                  predicates.records.record
                  {
                    "cloudify.interfaces.lifecycle" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            create = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    implementation = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "openstack.openstack_plugin.resources.network.security_group_rule.create"
                                          ]
                                        ],
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            delete = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    implementation = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "openstack.openstack_plugin.resources.network.security_group_rule.delete"
                                          ]
                                        ],
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    "cloudify.interfaces.operations" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            list = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    implementation = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "openstack.openstack_plugin.resources.network.security_group_rule.list_security_group_rules"
                                          ]
                                        ],
                                    inputs = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          { query = predicates.isType 'Record, }
                                          {  }
                                          true
                                          predicates.always
                                        ],
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    "cloudify.interfaces.validation" = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            creation = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    implementation = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "openstack.openstack_plugin.resources.network.security_group_rule.creation_validation"
                                          ]
                                        ],
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
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
              ],
          nodeTypeOpenstackSecurityGroupRuleProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeOpenstackSecurityGroupProperties,
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    resource_config =
                      definitions.predicate.openstackTypesSecurityGroupRule,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackServerProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  definitions.predicate.openstackDataTypeDescription,
                  predicates.records.record
                  {
                    availability_zone =
                      definitions.predicate.cloudifyStringOrGetInput,
                    flavor_id = definitions.predicate.cloudifyStringOrGetInput,
                    image_id = definitions.predicate.cloudifyStringOrGetInput,
                    key_name = definitions.predicate.cloudifyStringOrGetInput,
                    metadata = predicates.isType 'Record,
                    networks = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    security_groups = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    user_data = definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackSubnetInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.subnet.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.subnet.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.subnet.list_subnets"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { query = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.subnet.update"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.validation" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          creation = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.network.subnet.creation_validation"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackSubnetProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeOpenstackNetworkBaseProperties,
                  predicates.records.record
                  {
                    resource_config =
                      definitions.predicate.openstackTypesSubnet,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackUserInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.user.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.user.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.user.list_users"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { query = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          update = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.user.update"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackUserProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    resource_config = definitions.predicate.openstackTypesUser,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackVolumeInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.volume.volume.create"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { args = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.volume.volume.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.volume.volume.start"
                                        ]
                                      ],
                                  inputs = predicates.isType 'Record,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.operations" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          list = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.volume.volume.list_volumes"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { query = predicates.isType 'Record, }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.snapshot" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          apply = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.volume.volume.snapshot_apply"
                                        ]
                                      ],
                                  inputs = predicates.isType 'Record,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.volume.volume.snapshot_create"
                                        ]
                                      ],
                                  inputs = predicates.isType 'Record,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.volume.volume.snapshot_delete"
                                        ]
                                      ],
                                  inputs = predicates.isType 'Record,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  "cloudify.interfaces.validation" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          creation = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.volume.volume.creation_validation"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackVolumeProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    device_name =
                      definitions.predicate.cloudifyStringOrGetInput,
                    resource_config =
                      definitions.predicate.openstackTypesVolume,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackVolumeTypeInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.volume.volume_type.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.volume.volume_type.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackVolumeTypeProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackExternalResource,
                  definitions.predicate.openstackCreateIfMissing,
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    resource_config =
                      definitions.predicate.openstackTypesVolumeType,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackWindowsServerProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.nodeTypeOpenstackServerProperties,
                  predicates.records.record
                  {
                    agent_config =
                      definitions.predicate.cloudifyDataTypesAgentConfig,
                    os_family = definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeOpenstackZoneInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.dns_service.zone.create"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "openstack.openstack_plugin.resources.dns_service.zone.delete"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeOpenstackZoneProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackClientConfig,
                  predicates.records.record
                  {
                    resource_config =
                      definitions.predicate.openstackTypesZoneType,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypeTerraformDirectoryConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  executable_path =
                    definitions.predicate.cloudifyStringOrGetInput,
                  plugins_dir = definitions.predicate.cloudifyStringOrGetInput,
                  storage_path = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeTerraformInstallConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "use_existing_resource" ],
                predicates.records.record
                {
                  installation_source =
                    definitions.predicate.cloudifyStringOrGetInput,
                  plugins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  use_existing_resource =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeTerraformInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          create = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "tf.cloudify_tf.tasks.install" ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "tf.cloudify_tf.tasks.uninstall" ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeTerraformModuleInterfaces = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "cloudify.interfaces.lifecycle" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          delete = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "tf.cloudify_tf.tasks.destroy" ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          start = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "tf.cloudify_tf.tasks.apply" ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  terraform = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          refresh = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "tf.cloudify_tf.tasks.state_pull" ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          reload = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  implementation = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "tf.cloudify_tf.tasks.reload_template"
                                        ]
                                      ],
                                  inputs = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          destroy_previous = predicates.isType
                                              '"Bool",
                                          source = predicates.isType '"String",
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeTerraformModuleProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  resource_config =
                    definitions.predicate.terraformTypesRootModule,
                }
                {  }
                true
                predicates.always
              ],
          nodeTypeTerraformProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.terraformConfig,
                  predicates.records.record
                  {
                    resource_config =
                      definitions.predicate.nodeTypeTerraformInstallConfig,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          nodeTypes = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                { "" = definitions.predicate.nodeType, }
                true
                predicates.always
              ],
          openstackClientConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  client_config =
                    definitions.predicate.openstackTypeClientConfig,
                }
                {  }
                true
                predicates.always
              ],
          openstackCreateIfMissing = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  create_if_missing =
                    definitions.predicate.cloudifyIntegerOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          openstackDataTypeDescription = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  description = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          openstackDataTypeId = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { id = definitions.predicate.cloudifyStringOrGetInput, }
                {  }
                true
                predicates.always
              ],
          openstackDataTypeKwargs = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { "kwargs:" = predicates.isType 'Record, }
                {  }
                true
                predicates.always
              ],
          openstackDataTypeName = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { name = definitions.predicate.cloudifyStringOrGetInput, }
                {  }
                true
                predicates.always
              ],
          openstackExternalResource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  use_external_resource =
                    definitions.predicate.cloudifyIntegerOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          openstackRecordSetType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeDescription,
                  predicates.allOf
                  [
                    predicates.records.required [ "records", "zone_id" ],
                    predicates.records.record
                    {
                      records = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                      ttl = definitions.predicate.cloudifyIntegerOrGetInput,
                      type = definitions.predicate.cloudifyStringOrGetInput,
                      zone_id = definitions.predicate.cloudifyStringOrGetInput,
                    }
                    {  }
                    true
                    predicates.always
                  ]
                ]
              ],
          openstackTypeClientConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  auth_url = definitions.predicate.cloudifyStringOrGetInput,
                  ca_cert = definitions.predicate.cloudifyStringOrGetInput,
                  insecure = definitions.predicate.cloudifyIntegerOrGetInput,
                  kwargs = predicates.isType 'Record,
                  logging = definitions.predicate.openstackTypesLogging,
                  password = definitions.predicate.cloudifyStringOrGetInput,
                  project_domain_id =
                    definitions.predicate.cloudifyStringOrGetInput,
                  project_domain_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  project_name = definitions.predicate.cloudifyStringOrGetInput,
                  region_name = definitions.predicate.cloudifyStringOrGetInput,
                  tenant_name = definitions.predicate.cloudifyStringOrGetInput,
                  user_domain_id =
                    definitions.predicate.cloudifyStringOrGetInput,
                  user_domain_name =
                    definitions.predicate.cloudifyStringOrGetInput,
                  username = definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          openstackTypesFlavor = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  predicates.records.record
                  {
                    disk = definitions.predicate.cloudifyIntegerOrGetInput,
                    ram = definitions.predicate.cloudifyIntegerOrGetInput,
                    vcpus = definitions.predicate.cloudifyIntegerOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesFloatingIP = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  predicates.records.record
                  {
                    dns_domain = definitions.predicate.cloudifyStringOrGetInput,
                    dns_name = definitions.predicate.cloudifyStringOrGetInput,
                    fixed_ip_address =
                      definitions.predicate.cloudifyStringOrGetInput,
                    floating_ip_address =
                      definitions.predicate.cloudifyStringOrGetInput,
                    floating_network_id =
                      definitions.predicate.cloudifyStringOrGetInput,
                    floating_network_name =
                      definitions.predicate.cloudifyStringOrGetInput,
                    port_id = definitions.predicate.cloudifyStringOrGetInput,
                    subnet_id = definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesGroup = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  definitions.predicate.openstackDataTypeDescription,
                  predicates.records.record
                  {
                    domain_id = definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesHostAggregate = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  predicates.records.record
                  {
                    availability_zone =
                      definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesImage = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  predicates.records.record
                  {
                    container_format =
                      definitions.predicate.cloudifyStringOrGetInput,
                    disk_format =
                      definitions.predicate.cloudifyStringOrGetInput,
                    tags = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesKeyPair = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  predicates.records.record
                  {
                    public_key = definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesLogging
            | doc m%"
            For logging groups' configuration. Each level can be one of the following values:
            critical/error/warning/info/debug/notset
            "%
            = predicates.records.record
              { openstack = definitions.predicate.cloudifyStringOrGetInput, }
              {  }
              true
              predicates.always,
          openstackTypesNetwork = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  predicates.records.record
                  {
                    admin_state_up =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesPort = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  predicates.records.record
                  {
                    allowed_address_pairs = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    device_id = definitions.predicate.cloudifyStringOrGetInput,
                    device_owner =
                      definitions.predicate.cloudifyStringOrGetInput,
                    fixed_ips = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    network_id = definitions.predicate.cloudifyStringOrGetInput,
                    security_groups = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesProject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  definitions.predicate.openstackDataTypeDescription,
                  predicates.records.record
                  {
                    domain_id = definitions.predicate.cloudifyStringOrGetInput,
                    is_domain = definitions.predicate.cloudifyBooleanOrGetInput,
                    parent_id = definitions.predicate.cloudifyStringOrGetInput,
                    tags = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesRole = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  definitions.predicate.openstackDataTypeDescription,
                  predicates.records.record
                  {
                    domain_id = definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesRouter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId
                ]
              ],
          openstackTypesSecurityGroup = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  definitions.predicate.openstackDataTypeDescription
                ]
              ],
          openstackTypesSecurityGroupRule = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeId,
                  predicates.records.record
                  {
                    direction = definitions.predicate.cloudifyStringOrGetInput,
                    port_range_max =
                      definitions.predicate.cloudifyIntegerOrGetInput,
                    port_range_min =
                      definitions.predicate.cloudifyIntegerOrGetInput,
                    protocol = definitions.predicate.cloudifyStringOrGetInput,
                    remote_group_id =
                      definitions.predicate.cloudifyStringOrGetInput,
                    remote_ip_prefix =
                      definitions.predicate.cloudifyStringOrGetInput,
                    security_group_id =
                      definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesSubnet = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  predicates.records.record
                  {
                    allocation_pools = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    cidr = definitions.predicate.cloudifyStringOrGetInput,
                    dns_nameservers = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    enable_dhcp =
                      definitions.predicate.cloudifyBooleanOrGetInput,
                    gateway_ip = definitions.predicate.cloudifyStringOrGetInput,
                    host_routes = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    ip_version = definitions.predicate.cloudifyStringOrGetInput,
                    ipv6_address_mode =
                      definitions.predicate.cloudifyStringOrGetInput,
                    ipv6_ra_mode =
                      definitions.predicate.cloudifyStringOrGetInput,
                    network_id = definitions.predicate.cloudifyStringOrGetInput,
                    prefixlen = definitions.predicate.cloudifyIntegerOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesUser = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  predicates.records.record
                  {
                    default_project_id =
                      definitions.predicate.cloudifyStringOrGetInput,
                    domain_id = definitions.predicate.cloudifyStringOrGetInput,
                    email = definitions.predicate.cloudifyStringOrGetInput,
                    enabled = definitions.predicate.cloudifyBooleanOrGetInput,
                    password = definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesVolume = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  definitions.predicate.openstackDataTypeDescription,
                  predicates.records.record
                  {
                    availability_zone =
                      definitions.predicate.cloudifyStringOrGetInput,
                    imageRef = definitions.predicate.cloudifyStringOrGetInput,
                    project_id = definitions.predicate.cloudifyStringOrGetInput,
                    size = definitions.predicate.cloudifyIntegerOrGetInput,
                    snapshot_id =
                      definitions.predicate.cloudifyStringOrGetInput,
                    volume_type =
                      definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesVolumeType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeId,
                  definitions.predicate.openstackDataTypeDescription,
                  predicates.records.record
                  {
                    extra_specs = predicates.isType 'Record,
                    project_id = definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          openstackTypesZoneType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.openstackDataTypeKwargs,
                  definitions.predicate.openstackDataTypeName,
                  definitions.predicate.openstackDataTypeDescription,
                  predicates.records.record
                  {
                    attributes = predicates.isType 'Record,
                    email = definitions.predicate.cloudifyStringOrGetInput,
                    masters = definitions.predicate.cloudifyStringOrGetInput,
                    ttl = definitions.predicate.cloudifyIntegerOrGetInput,
                    type = definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          restTemplateInputs = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  force_rerun = definitions.predicate.cloudifyBooleanOrGetInput,
                  params = predicates.isType 'Record,
                  prerender = definitions.predicate.cloudifyBooleanOrGetInput,
                  remove_calls =
                    definitions.predicate.cloudifyBooleanOrGetInput,
                  retry_count = definitions.predicate.cloudifyIntegerOrGetInput,
                  retry_sleep = definitions.predicate.cloudifyIntegerOrGetInput,
                  save_path = definitions.predicate.cloudifyBooleanOrGetInput,
                  template_file =
                    definitions.predicate.cloudifyStringOrGetInput,
                }
                {  }
                true
                predicates.always
              ],
          tags
            | doc m%"
            Tags to add to an EC2 resource
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    Key = definitions.predicate.cloudifyStringOrGetInput,
                    Value = definitions.predicate.cloudifyStringOrGetInput,
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          terraformConfig
            | doc m%"
            Terraform directories for executions.
            "%
            = definitions.predicate.nodeTypeTerraformDirectoryConfig,
          terraformTypesBackend = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = definitions.predicate.cloudifyStringOrGetInput,
                  options = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          terraformTypesRootModule = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "source" ],
                predicates.records.record
                {
                  backend = definitions.predicate.terraformTypesBackend,
                  environment_variables = predicates.isType 'Record,
                  source = definitions.predicate.cloudifyStringOrGetInput,
                  variables = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

{
  data_types | definitions.contract.dataTypes | optional,
  dsl_definitions | {  .. } | optional,
  imports
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.anyOf
      [
        predicates.isType '"String",
        predicates.allOf
        [
          predicates.isType '"String",
          predicates.enum
          [
            "http://www.getcloudify.org/spec/cloudify/4.5/types.yaml",
            "plugin:cloudify-ansible-plugin",
            "plugin:cloudify-aws-plugin",
            "plugin:cloudify-azure-plugin",
            "plugin:cloudify-cloudstack-plugin",
            "plugin:cloudify-diamond-plugin",
            "plugin:cloudify-fabric-plugin",
            "plugin:cloudify-gcp-plugin",
            "plugin:cloudify-host-pool-plugin",
            "plugin:cloudify-kubernetes-plugin",
            "plugin:cloudify-openstack-plugin",
            "plugin:cloudify-utilities-plugin",
            "plugin:cloudify-vsphere-plugin",
            "plugin:cloudify-terraform-plugin",
            "plugin:cloudify-helm-plugin"
          ]
        ]
      ])
    ])
    | doc m%"
    imports enable the author of a blueprint to reuse blueprint files, or parts of them, and to use predefined types (e.g. from the types.yaml file).
    "%
    | optional,
  inputs
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record
      {
        aws_access_key_id = definitions.predicate.inputProperty,
        aws_account_id = definitions.predicate.inputProperty,
        aws_cloudwatch_log_arn = definitions.predicate.inputProperty,
        aws_region_name = definitions.predicate.inputProperty,
        aws_region_zone1 = definitions.predicate.inputProperty,
        aws_region_zone2 = definitions.predicate.inputProperty,
        aws_secret_access_key = definitions.predicate.inputProperty,
      }
      { "" = definitions.predicate.inputProperty, }
      true
      predicates.always
    ])
    | doc m%"
    inputs are parameters that are injected into a blueprint when a deployment is created. These parameters can be referenced by using the get_input intrinsic function.
    "%
    | optional,
  node_templates | definitions.contract.nodeTemplates | optional,
  node_types | definitions.contract.nodeTypes | optional,
  tosca_definitions_version
    | std.enum.TagOrString
    | [|
      'cloudify_dsl_1_3,
      'cloudify_dsl_1_2,
      'cloudify_dsl_1_1,
      'cloudify_dsl_1_0
    |]
    | doc m%"
    tosca_definitions_version is a top level property of the blueprint which is used to specify the DSL version used. For Cloudify, the versions that are currently defined are cloudify_dsl_1_0, cloudify_dsl_1_1, cloudify_dsl_1_2 and cloudify_dsl_1_3.
    "%
    | optional,
  ..
}