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
          AppStoreConnect = {
                api_key
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern "^Encrypted\\(.+\\)$"
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{?([^:}]+).*\\}?$"
                    ]
                  ])
                  | doc m%"
                  App Store Connect API key in .p8 format that is used for authenticating application packages validation and upload to App Store Connect. It is required for TestFlight submission.
                  "%
                  | optional,
                apple_id
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern "^Encrypted\\(.+\\)$"
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{?([^:}]+).*\\}?$"
                    ]
                  ])
                  | doc m%"
                  The email address used to log in to App Store Connect. It can also be passed with an environment variable.
                  "%
                  | optional,
                auth
                  | predicates.contract_from_predicate
                  definitions.predicate.AppStoreConnectAuth
                  | doc m%"
                  Accepted value: integration. When defined, the API key info inherited from integrations is used for authenticating with App Store Connect. If you omit this key-value pair, you must define API key, key identifier and issuer identifier explicitly.
                  "%
                  | optional,
                beta_groups
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Published build will be made available to the specified Beta groups in App Store Connect. TestFlight submission is required in order to release builds to the groups of beta testers.
                  "%
                  | optional,
                cancel_previous_submissions
                  | Bool
                  | doc m%"
                  Cancel previous submissions before submitting application package to App Store review. Requires authentication using App Store Connect API key.
                  "%
                  | optional,
                copyright
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{?([^:}]+).*\\}?$"
                    ]
                  ])
                  | doc m%"
                  The name of the person or entity that owns the exclusive rights to your app, preceded by the year the rights were obtained (for example, "2008 Acme Inc."). Do not provide a URL.
                  "%
                  | optional,
                earliest_release_date
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Specify earliest return date for scheduled release type. Timezone aware ISO8601 timestamp, for example 2021-11-10T14:55:41+00:00.
                  "%
                  | optional,
                expire_build_submitted_for_review
                  | Bool
                  | doc m%"
                  Expire previously submitted build that is in review before submitting published build to Testflight. Requires authentication using App Store Connect API key.
                  "%
                  | optional,
                issuer_id
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern "^Encrypted\\(.+\\)$"
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{?([^:}]+).*\\}?$"
                    ]
                  ])
                  | doc m%"
                  App Store Connect API key issuer identifier that is used for authenticating application packages validation and upload to App Store Connect. It is required for TestFlight submission.
                  "%
                  | optional,
                key_id
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern "^Encrypted\\(.+\\)$"
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{?([^:}]+).*\\}?$"
                    ]
                  ])
                  | doc m%"
                  App Store Connect API key identifier that is used for authenticating application packages validation and upload to App Store Connect. It is required for TestFlight submission.
                  "%
                  | optional,
                password
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^([a-z]{4}-){3}[a-z]{4}$"
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern "^Encrypted\\(.+\\)$"
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^\\$\\{?([^:}]+).*\\}?$"
                    ]
                  ])
                  | doc m%"
                  App-specific passwords allow you to sign in to your account securely when you use third-party apps with your Apple ID. e.g. ujlw-ypqu-dgzw-vyog. The plain or encrypted password can also be passed with en environment variable.
                  "%
                  | optional,
                release_type
                  | predicates.contract_from_predicate
                  definitions.predicate.AppStoreReleaseType
                  | doc m%"
                  Choose when to release the app. You can either manually release the app at a later date on the App Store Connect website, or the app version can be automatically released right after it has been approved by App Review.
                  "%
                  | optional,
                submit_to_app_store
                  | Bool
                  | doc m%"
                  Submit published build to App Store review. Requires authentication using App Store Connect API key.
                  "%
                  | optional,
                submit_to_testflight
                  | Bool
                  | doc m%"
                  Submit published build to Testflight. Requires authentication using App Store Connect API key.
                  "%
                  | optional,
              },
          AppStoreConnectAuth
            | doc m%"
            An enumeration.
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| 'integration |] ],
          AppStoreReleaseType
            | doc m%"
            An enumeration.
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'SCHEDULED, 'AFTER_APPROVAL, 'MANUAL |]
              ],
          BranchPattern = {
                include
                  | Bool
                  | doc m%"
                  If set to false, the matching branches will not be watched for triggering events.
                  "%
                  | optional,
                pattern
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType 'Integer,
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ])
                  | doc m%"
                  The pattern can also be passed with an environment variable.
                  "%
                  | optional,
                source
                  | Bool
                  | doc m%"
                  The variable is ignored for events other than pull_request.
                  "%
                  | optional,
              },
          Cache = {
                cache_paths
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ])
                  ])
                  | doc m%"
                  For example, you may consider caching the following paths: "$FLUTTER_ROOT/.pub-cache" for Dart cache, "$HOME/.gradle/caches" for gradle cache, "$HOME/Library/Caches/CocoaPods" for CocoaPods cache.
                  "%
                  | optional,
              },
          CertificateWithVariable = {
                certificate
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Certificate reference found in Team settings -> Code signing identities
                  "%,
                environment_variable
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Name of the variable containing the certificate path
                  "%
                  | optional,
              },
          Changeset = {
                excludes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                      predicates.isType 'Integer,
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ])
                  | optional,
                includes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                      predicates.isType 'Integer,
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ])
                  | optional,
              },
          DistributionType
            | doc m%"
            An enumeration.
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'enterprise, 'development, 'app_store, 'ad_hoc |]
              ],
          Email = {
                notify
                  | predicates.contract_from_predicate
                  definitions.predicate.PublisherNotification
                  | doc m%"
                  Allows to turn on or turn off email notification on build success or failure.
                  "%
                  | optional,
                recipients
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
                        predicates.strings.minLength 1,
                        predicates.strings.pattern "^\\$\\{?([^:}]+).*\\}?$"
                      ]
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Provide valid email addresses here.
                  "%,
              },
          Environment = {
                android_signing
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.KeystoreWithVariables,
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ]
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Android code signing identities configured under Team settings
                  "%
                  | optional,
                cocoapods
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType 'Integer,
                    predicates.isType '"Number"
                  ])
                  | doc m%"
                  Define default or version (e.g. 1.9.1).
                  "%
                  | optional,
                flutter
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType 'Integer,
                    predicates.isType '"Number",
                    definitions.predicate.FlutterWithFlavor
                  ])
                  | doc m%"
                  Define the channel name, version (e.g. v1.13.4) or 'fvm' if using Flutter Version Management.
                  "%
                  | optional,
                groups
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ])
                  ])
                  | doc m%"
                  Define environment variable group names that have been configured in app or team settings.
                  "%
                  | optional,
                ios_signing
                  | predicates.contract_from_predicate
                  definitions.predicate.IosSigning
                  | doc m%"
                  iOS code signing identities configured under Team settings
                  "%
                  | optional,
                java
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType 'Integer,
                    predicates.isType '"Number"
                  ])
                  | doc m%"
                  Define default, or platform version (e.g. 11).
                  "%
                  | optional,
                ndk
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType 'Integer,
                    predicates.isType '"Number"
                  ])
                  | doc m%"
                  Define default or revision (e.g. r19c).
                  "%
                  | optional,
                node
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType 'Integer,
                    predicates.isType '"Number"
                  ])
                  | doc m%"
                  Define default, latest, current, lts, carbon (or another stream), nightly or version (e.g. 12.4.0).
                  "%
                  | optional,
                npm
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType 'Integer,
                    predicates.isType '"Number"
                  ])
                  | doc m%"
                  Define default, latest, next, lts or version (e.g. 6.13.7).
                  "%
                  | optional,
                ruby
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType 'Integer,
                    predicates.isType '"Number"
                  ])
                  | doc m%"
                  Define default, or platform version (e.g. 2.5.1).
                  "%
                  | optional,
                unity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Define exact version (e.g. 2020.3.15f2).
                  "%
                  | optional,
                vars
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      "[0-9a-zA-Z_]+" = predicates.anyOf
                          [
                            predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.minLength 1
                            ],
                            predicates.isType 'Integer,
                            predicates.isType '"Number",
                            predicates.isType '"Bool"
                          ],
                    }
                    true
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                      predicates.isType 'Integer,
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ])
                  | doc m%"
                  Define your environment variables.
                  "%
                  | optional,
                xcode
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType 'Integer,
                    predicates.isType '"Number"
                  ])
                  | doc m%"
                  Define latest, edge or version (e.g. 11.2).
                  "%
                  | optional,
              },
          Firebase = {
                android
                  | predicates.contract_from_predicate
                  definitions.predicate.FirebaseType
                  | doc m%"
                  Codemagic enables you to automatically publish your Android app to Firebase App Distribution.
                  "%
                  | optional,
                firebase_service_account
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The content of service account file that has "Firebase App Distribution Admin" role.
                  "%
                  | optional,
                firebase_token
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Firebase access token generated using Firebase CLI; to receive the token use firebase login:ci with Firebase CLI installed.
                  "%
                  | optional,
                ios
                  | predicates.contract_from_predicate
                  definitions.predicate.FirebaseType
                  | doc m%"
                  Codemagic enables you to automatically publish your iOS app to Firebase App Distribution.
                  "%
                  | optional,
              },
          FirebaseAndroidArtifactType
            | doc m%"
            An enumeration.
            "%
            = std.contract.Sequence [ std.enum.TagOrString, [| 'apk, 'aab |] ],
          FirebaseType = {
                app_id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Firebase application id found in Firebase application settings.
                  "%,
                artifact_type
                  | predicates.contract_from_predicate
                  definitions.predicate.FirebaseAndroidArtifactType
                  | doc m%"
                  Artifact type (aab/apk) to prioritize when uploading to Firebase App Distribution, by default app bundles are prioritized.
                  "%
                  | optional,
                groups
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ])
                  ])
                  | doc m%"
                  Test groups that the application should be distributed to.
                  "%
                  | optional,
              },
          FlutterWithFlavor = {
                flavor
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The name of the flavor to use when using FVM.
                  "%
                  | optional,
                version
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType 'Integer,
                    predicates.isType '"Number"
                  ])
                  | doc m%"
                  Define the channel name, version (e.g. v1.13.4) or 'fvm' if using Flutter Version Management.
                  "%,
              },
          GooglePlay = {
                changes_not_sent_for_review
                  | Bool
                  | doc m%"
                  Indicates that the changes in this edit will not be reviewed until they are explicitly sent for review from the Google Play Console UI.
                  "%
                  | optional,
                credentials
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The encrypted JSON key file or the encrypted contents of the JSON key file. The value can also be passed with an environment variable.
                  "%,
                in_app_update_priority
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 5,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  If your application supports in-app updates, set the release priority by specifying an integer in range [0, 5]. Otherwise, in_app_update_priority can be omitted.
                  "%
                  | optional,
                release_promotion
                  | predicates.contract_from_predicate
                  definitions.predicate.ReleasePromotion
                  | doc m%"
                  Additionally, promote the uploaded release to another track
                  "%
                  | optional,
                rollout_fraction
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.exclusiveMaximum 1,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  Codemagic supports staged releases, allowing users to choose which fraction of the testers or users get access to the application. To release to everyone, omit the rollout_fraction field.
                  "%
                  | optional,
                submit_as_draft
                  | Bool
                  | doc m%"
                  Indicates that the artifacts generated in the build will be uploaded to Google Play as a draft release.
                  "%
                  | optional,
                track
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Codemagic enables you to automatically publish your app to Google Play.
                  "%,
              },
          InstanceType
            | doc m%"
            Build machine type to use for the build.
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'windows_x2,
                  'linux_x2,
                  'linux,
                  'mac_pro,
                  'mac_mini_m2,
                  'mac_mini_m1,
                  'mac_mini
                |]
              ],
          Integrations = {
                app_store_connect
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Specify the name of the App Store Connect API key to be used from team or personal integrations to authenticate actions for code signing and publishing.
                  "%
                  | optional,
              },
          IosSigning = {
                bundle_identifier
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Bundle identifier of certificates and profiles to fetch from Code signing identities
                  "%
                  | optional,
                certificates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                      definitions.predicate.CertificateWithVariable
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Certificates to fetch from Code signing identities
                  "%
                  | optional,
                distribution_type
                  | predicates.contract_from_predicate
                  definitions.predicate.DistributionType
                  | doc m%"
                  Type of certificates and profiles to fetch from Code signing identities
                  "%
                  | optional,
                provisioning_profiles
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                      definitions.predicate.ProfileWithVariable
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Provisioning profiles to fetch from Code signing identities
                  "%
                  | optional,
              },
          KeystoreWithVariables = {
                key_alias_environment_variable
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Name of the variable containing the key alias
                  "%
                  | optional,
                key_password_environment_variable
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Name of the variable containing the key password
                  "%
                  | optional,
                keystore
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Keystore reference found in Team settings -> Code signing identities
                  "%,
                keystore_environment_variable
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Name of the variable containing the keystore path
                  "%
                  | optional,
                keystore_password_environment_variable
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Name of the variable containing the keystore password
                  "%
                  | optional,
              },
          NamedScript = {
                ignore_failure
                  | Bool
                  | doc m%"
                  If set to true, the workflow will continue to run even if the script fails.
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType 'Integer,
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ])
                  | doc m%"
                  A descriptive script name can be provided to be shown in the UI. If not passed, the first line of your script will be shown in the UI for the script block.
                  "%
                  | optional,
                on_failure
                  | predicates.contract_from_predicate
                  definitions.predicate.ScriptOnFailure
                  | doc m%"
                  The only supported action is to proceed directly to publishing.
                  "%
                  | optional,
                script
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  By default the script will be run in the Bash shell. You can run the script in other languages by defining a shebang line in the beginning.
                  "%,
                test_report
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  You can display test results visually in the build overview. The value can be an absolute path, or a path relative to $CM_BUILD_DIR (in this case the patterns will be searched recursively). Supported test report formats are Junit XML and .JSON for Flutter's --machine report.
                  "%
                  | optional,
                when
                  | predicates.contract_from_predicate
                  definitions.predicate.When
                  | doc m%"
                  All conditions below should be met in order for script to continue.
                  "%
                  | optional,
                working_directory
                  | String
                  | doc m%"
                  Specify directory where this script will be executed. It overrides global workflow working directory.
                  "%
                  | optional,
              },
          PartnerCenter = {
                client_id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Application (client) ID in Azure AD portal.
                  "%
                  | optional,
                client_secret
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The value of the Azure AD app key.
                  "%
                  | optional,
                store_id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Store ID set up on Microsoft Partner Center.
                  "%
                  | optional,
                tenant_id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Directory (tenant) ID in Azure AD portal.
                  "%
                  | optional,
              },
          ProfileWithVariable = {
                environment_variable
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Name of the variable containing the profile path
                  "%
                  | optional,
                profile
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Profile reference found in Team settings -> Code signing identities
                  "%,
              },
          PublisherNotification = {
                failure
                  | Bool
                  | doc m%"
                  Set to false to not receive a notification when a build fails.
                  "%
                  | optional,
                success
                  | Bool
                  | doc m%"
                  Set to false to not receive a notification when a build succeeds.
                  "%
                  | optional,
              },
          Publishing = {
                app_store_connect
                  | predicates.contract_from_predicate
                  definitions.predicate.AppStoreConnect
                  | doc m%"
                  Codemagic enables you to automatically publish your iOS app to App Store Connect for beta testing with TestFlight or distributing the app to users via App Store.
                  "%
                  | optional,
                email
                  | predicates.contract_from_predicate
                  definitions.predicate.Email
                  | doc m%"
                  If the build finishes successfully, release notes (if passed) and the generated artifacts will be published to the provided email address(es). If the build fails, an email with a link to build logs will be sent.
                  "%
                  | optional,
                firebase
                  | predicates.contract_from_predicate
                  definitions.predicate.Firebase
                  | doc m%"
                  Codemagic enables you to automatically publish your app to Firebase App Distribution. In order to do so, set up an account and project on Firebase and provide Codemagic with your Firebase token, Firebase app id and test groups.
                  "%
                  | optional,
                google_play
                  | predicates.contract_from_predicate
                  definitions.predicate.GooglePlay
                  | doc m%"
                  Codemagic enables you to automatically publish your app to the internal, alpha, beta and production tracks on Google Play. In order to do so, you will need to set up a service account in Google Play Console and add the JSON key file to your Codemagic configuration file.
                  "%
                  | optional,
                partner_center
                  | predicates.contract_from_predicate
                  definitions.predicate.PartnerCenter
                  | doc m%"
                  Codemagic enables you to automatically publish your app to Microsoft Store. In order to do so, set up an account and project on Microsoft Partner Center and provide Codemagic with your store id, client id, client secret and tenant id.
                  "%
                  | optional,
                scripts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                      definitions.predicate.NamedScript
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Add scripts to publish to any other service.
                  "%
                  | optional,
                slack
                  | predicates.contract_from_predicate
                  definitions.predicate.Slack
                  | doc m%"
                  Integrate Slack publishing into your Codemagic build pipeline to get notified when a build starts and receive build artifacts or logs when the build finishes. To set up publishing to Slack, you first need to connect your Slack workspace in User integrations for personal apps and in Team integrations for team apps.
                  "%
                  | optional,
              },
          ReleasePromotion = {
                promote_as_draft
                  | Bool
                  | doc m%"
                  Indicates that the promoted release will be in the draft status in the target track.
                  "%
                  | optional,
                rollout_fraction
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.exclusiveMaximum 1,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  The promoted release in the target track will be staged, allowing users to choose which fraction of the testers or users get access to the application. To release to everyone, omit the rollout_fraction field.
                  "%
                  | optional,
                track
                  | String
                  | doc m%"
                  The track to promote the release to. Used in conjunction with the 'track` argument.
                  "%,
              },
          ScriptOnFailure
            | doc m%"
            The only supported action is to proceed directly to publishing.
            "%
            = std.contract.Sequence [ std.enum.TagOrString, [| 'publish |] ],
          Slack = {
                channel
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  To allow publishing to private channels, invite the Codemagic Slack app to the channels by writing @codemagic in the channel.
                  "%,
                notify
                  | predicates.contract_from_predicate
                  definitions.predicate.PublisherNotification
                  | doc m%"
                  Allows to turn on or turn off slack notification on build success or failure.
                  "%
                  | optional,
                notify_on_build_start
                  | Bool
                  | doc m%"
                  When you set notify_on_build_start to true, the channel will be notified when a build starts.
                  "%
                  | optional,
              },
          TagPattern = {
                include
                  | Bool
                  | doc m%"
                  If set to false, the matching tags will not be watched for triggering events.
                  "%
                  | optional,
                pattern
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType 'Integer,
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ])
                  | doc m%"
                  The pattern can also be passed with an environment variable.
                  "%
                  | optional,
              },
          Triggering = {
                branch_patterns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.BranchPattern,
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  A branch pattern can match the name of a particular branch, or you can use wildcard symbols to create a pattern that matches several branches. Note that for pull request builds you have to specify whether the watched branch is the source or the target of the pull request.
                  "%
                  | optional,
                cancel_previous_builds
                  | Bool
                  | doc m%"
                  To avoid running builds on outdated commits, set cancel_previous_builds to true to automatically cancel all ongoing and queued builds triggered by webhooks on push or pull request commit when a more recent build has been triggered for the same branch.
                  "%
                  | optional,
                events
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.TriggeringEvent
                  ])
                  | doc m%"
                  Currently supported events are push, pull_request, tag.
                  "%
                  | optional,
                tag_patterns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.TagPattern,
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  A tag pattern can match the name of a particular tag, or you can use wildcard symbols to create a pattern that matches several tags.
                  "%
                  | optional,
              },
          TriggeringEvent
            | doc m%"
            Currently supported events are push, pull_request.
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| 'tag, 'pull_request, 'push |] ],
          When = {
                changeset
                  | predicates.contract_from_predicate
                  definitions.predicate.Changeset
                  | doc m%"
                  List of paths or path patterns to watch for changes, proceed if changes are detected.
                  "%
                  | optional,
                condition
                  | String
                  | doc m%"
                  Check if condition evaluates to true before proceeding with building workflow or script.
                  "%
                  | optional,
              },
          Workflow = {
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                      predicates.isType 'Integer,
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Configure the paths and names of the artifacts you would like to use in the following steps, e.g. for publishing, or have available for download on the build page. All paths are relative to the clone directory, but absolute paths are supported as well. You can also use environment variables in artifact patterns.
                  The pattern can match several files or folders. If it picks up files or folders with the same name, the top level file or folder name will be suffixed with _{number}.
                  If one of the patterns includes another pattern, duplicate artifacts are not created.
                  apk, aab, aar, ipa, app, proguard mapping (mapping.txt), flutter_drive.log, jar, zip, xarchive and dSYM.zip files will be available as separate items in the Artifacts section on the build page. The rest of the artifacts will be included in an archive with the following name pattern: {project-name}_{version}_artifacts.zip.
                  "%
                  | optional,
                cache
                  | predicates.contract_from_predicate
                  definitions.predicate.Cache
                  | doc m%"
                  Define the paths to be cached and stored on Codemagic.
                  "%
                  | optional,
                environment
                  | predicates.contract_from_predicate
                  definitions.predicate.Environment
                  | doc m%"
                  Environment contains all the environment variables and enables to specify the version of Flutter, Xcode, CocoaPods, Node, npm, ndk, Java and Ruby used for building. This is also where you can add credentials and API keys required for code signing. Make sure to encrypt the values of variables that hold sensitive data.
                  "%
                  | optional,
                instance_type
                  | predicates.contract_from_predicate
                  definitions.predicate.InstanceType
                  | doc m%"
                  Build machine type to use for the build.
                  "%
                  | optional,
                integrations
                  | predicates.contract_from_predicate
                  definitions.predicate.Integrations
                  | doc m%"
                  Allows using info from the integrations connected in Codemagic UI. Currently supported: app_store_connect.
                  "%
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Define label names to easily filter builds in UI. You can use environment variable as well.
                  "%
                  | optional,
                max_build_duration
                  | std.number.Integer
                  | doc m%"
                  By default, Codemagic builds are set to time out after 60 minutes. You can decrease or increase the maximum build duration. 
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Workflow name displayed in the Codemagic UI.
                  "%
                  | optional,
                publishing
                  | predicates.contract_from_predicate
                  definitions.predicate.Publishing
                  | doc m%"
                  The matching artifacts will be published to the services you have configured. The available integrations currently are email, Slack, Google Play and App Store Connect. It is also possible to publish elsewhere with custom publishing scripts.
                  "%
                  | optional,
                scripts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                      definitions.predicate.NamedScript
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Scripts specify what kind of application is built. This is where you can specify the commands to test, build and code sign your project. You can also run shell (sh) scripts directly in your .yaml file, or run scripts in other languages by defining the language with a shebang line or by launching a script file present in your repository.
                  "%
                  | optional,
                triggering
                  | predicates.contract_from_predicate
                  definitions.predicate.Triggering
                  | doc m%"
                  Triggering defines the events for automatic build triggering and watched branches. If no events are defined, you can start builds only manually.
                  "%
                  | optional,
                when
                  | predicates.contract_from_predicate
                  definitions.predicate.When
                  | doc m%"
                  All conditions below should be met in order for build to continue.
                  "%
                  | optional,
                working_directory
                  | String
                  | doc m%"
                  Specify the default directory to run script commands. Each script will be executed inside the specified directory, unless the working directory is specified for the script itself.
                  "%
                  | optional,
              },
        },
    predicate = {
          AppStoreConnect = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_key = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^Encrypted\\(.+\\)$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{?([^:}]+).*\\}?$"
                        ]
                      ],
                  apple_id = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^Encrypted\\(.+\\)$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{?([^:}]+).*\\}?$"
                        ]
                      ],
                  auth = definitions.predicate.AppStoreConnectAuth,
                  beta_groups = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  cancel_previous_submissions = predicates.isType '"Bool",
                  copyright = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{?([^:}]+).*\\}?$"
                        ]
                      ],
                  earliest_release_date = predicates.isType '"String",
                  expire_build_submitted_for_review = predicates.isType '"Bool",
                  issuer_id = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^Encrypted\\(.+\\)$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{?([^:}]+).*\\}?$"
                        ]
                      ],
                  key_id = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^Encrypted\\(.+\\)$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{?([^:}]+).*\\}?$"
                        ]
                      ],
                  password = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^([a-z]{4}-){3}[a-z]{4}$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^Encrypted\\(.+\\)$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^\\$\\{?([^:}]+).*\\}?$"
                        ]
                      ],
                  release_type = definitions.predicate.AppStoreReleaseType,
                  submit_to_app_store = predicates.isType '"Bool",
                  submit_to_testflight = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          AppStoreConnectAuth
            | doc m%"
            An enumeration.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "integration" ]
              ],
          AppStoreReleaseType
            | doc m%"
            An enumeration.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "MANUAL", "AFTER_APPROVAL", "SCHEDULED" ]
              ],
          BranchPattern = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  include = predicates.isType '"Bool",
                  pattern = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType 'Integer,
                        predicates.isType '"Number",
                        predicates.isType '"Bool"
                      ],
                  source = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          Cache = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cache_paths = predicates.allOf
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
                false
                predicates.never
              ],
          CertificateWithVariable = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "certificate" ],
                predicates.records.record
                {
                  certificate = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  environment_variable = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Changeset = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  excludes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                          predicates.isType 'Integer,
                          predicates.isType '"Number",
                          predicates.isType '"Bool"
                        ])
                      ],
                  includes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                          predicates.isType 'Integer,
                          predicates.isType '"Number",
                          predicates.isType '"Bool"
                        ])
                      ],
                }
                {  }
                false
                predicates.never
              ],
          DistributionType
            | doc m%"
            An enumeration.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "ad_hoc", "app_store", "development", "enterprise" ]
              ],
          Email = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "recipients" ],
                predicates.records.record
                {
                  notify = definitions.predicate.PublisherNotification,
                  recipients = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1,
                            predicates.strings.pattern "^\\$\\{?([^:}]+).*\\}?$"
                          ]
                        ]),
                        predicates.arrays.minItems 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Environment = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  android_signing = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.KeystoreWithVariables,
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ]
                        ]),
                        predicates.arrays.minItems 1
                      ],
                  cocoapods = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType 'Integer,
                        predicates.isType '"Number"
                      ],
                  flutter = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType 'Integer,
                        predicates.isType '"Number",
                        definitions.predicate.FlutterWithFlavor
                      ],
                  groups = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ])
                      ],
                  ios_signing = definitions.predicate.IosSigning,
                  java = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType 'Integer,
                        predicates.isType '"Number"
                      ],
                  ndk = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType 'Integer,
                        predicates.isType '"Number"
                      ],
                  node = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType 'Integer,
                        predicates.isType '"Number"
                      ],
                  npm = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType 'Integer,
                        predicates.isType '"Number"
                      ],
                  ruby = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType 'Integer,
                        predicates.isType '"Number"
                      ],
                  unity = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  vars = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "[0-9a-zA-Z_]+" = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.minLength 1
                                ],
                                predicates.isType 'Integer,
                                predicates.isType '"Number",
                                predicates.isType '"Bool"
                              ],
                        }
                        true
                        (predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                          predicates.isType 'Integer,
                          predicates.isType '"Number",
                          predicates.isType '"Bool"
                        ])
                      ],
                  xcode = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType 'Integer,
                        predicates.isType '"Number"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Firebase = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  android = definitions.predicate.FirebaseType,
                  firebase_service_account = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  firebase_token = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  ios = definitions.predicate.FirebaseType,
                }
                {  }
                false
                predicates.never
              ],
          FirebaseAndroidArtifactType
            | doc m%"
            An enumeration.
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.enum [ "aab", "apk" ] ],
          FirebaseType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "app_id" ],
                predicates.records.record
                {
                  app_id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  artifact_type =
                    definitions.predicate.FirebaseAndroidArtifactType,
                  groups = predicates.allOf
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
                false
                predicates.never
              ],
          FlutterWithFlavor = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "version" ],
                predicates.records.record
                {
                  flavor = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  version = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType 'Integer,
                        predicates.isType '"Number"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          GooglePlay = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "credentials", "track" ],
                predicates.records.record
                {
                  changes_not_sent_for_review = predicates.isType '"Bool",
                  credentials = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  in_app_update_priority = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 5,
                        predicates.numbers.minimum 0
                      ],
                  release_promotion = definitions.predicate.ReleasePromotion,
                  rollout_fraction = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.exclusiveMaximum 1,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  submit_as_draft = predicates.isType '"Bool",
                  track = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          InstanceType
            | doc m%"
            Build machine type to use for the build.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "mac_mini",
                  "mac_mini_m1",
                  "mac_mini_m2",
                  "mac_pro",
                  "linux",
                  "linux_x2",
                  "windows_x2"
                ]
              ],
          Integrations = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  app_store_connect = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          IosSigning = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bundle_identifier = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  certificates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                          definitions.predicate.CertificateWithVariable
                        ]),
                        predicates.arrays.minItems 1
                      ],
                  distribution_type = definitions.predicate.DistributionType,
                  provisioning_profiles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                          definitions.predicate.ProfileWithVariable
                        ]),
                        predicates.arrays.minItems 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          KeystoreWithVariables = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "keystore" ],
                predicates.records.record
                {
                  key_alias_environment_variable = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  key_password_environment_variable = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  keystore = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  keystore_environment_variable = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  keystore_password_environment_variable = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          NamedScript = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "script" ],
                predicates.records.record
                {
                  ignore_failure = predicates.isType '"Bool",
                  name = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType 'Integer,
                        predicates.isType '"Number",
                        predicates.isType '"Bool"
                      ],
                  on_failure = definitions.predicate.ScriptOnFailure,
                  script = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  test_report = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  when = definitions.predicate.When,
                  working_directory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PartnerCenter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  client_id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  client_secret = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  store_id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  tenant_id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ProfileWithVariable = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "profile" ],
                predicates.records.record
                {
                  environment_variable = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  profile = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PublisherNotification = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  failure = predicates.isType '"Bool",
                  success = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          Publishing = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  app_store_connect = definitions.predicate.AppStoreConnect,
                  email = definitions.predicate.Email,
                  firebase = definitions.predicate.Firebase,
                  google_play = definitions.predicate.GooglePlay,
                  partner_center = definitions.predicate.PartnerCenter,
                  scripts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                          definitions.predicate.NamedScript
                        ]),
                        predicates.arrays.minItems 1
                      ],
                  slack = definitions.predicate.Slack,
                }
                {  }
                false
                predicates.never
              ],
          ReleasePromotion = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "track" ],
                predicates.records.record
                {
                  promote_as_draft = predicates.isType '"Bool",
                  rollout_fraction = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.exclusiveMaximum 1,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  track = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ScriptOnFailure
            | doc m%"
            The only supported action is to proceed directly to publishing.
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.enum [ "publish" ] ],
          Slack = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "channel" ],
                predicates.records.record
                {
                  channel = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  notify = definitions.predicate.PublisherNotification,
                  notify_on_build_start = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          TagPattern = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  include = predicates.isType '"Bool",
                  pattern = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType 'Integer,
                        predicates.isType '"Number",
                        predicates.isType '"Bool"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Triggering = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  branch_patterns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.BranchPattern,
                        predicates.arrays.minItems 1
                      ],
                  cancel_previous_builds = predicates.isType '"Bool",
                  events = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.TriggeringEvent
                      ],
                  tag_patterns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.TagPattern,
                        predicates.arrays.minItems 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          TriggeringEvent
            | doc m%"
            Currently supported events are push, pull_request.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "push", "pull_request", "tag" ]
              ],
          When = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  changeset = definitions.predicate.Changeset,
                  condition = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Workflow = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifacts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                          predicates.isType 'Integer,
                          predicates.isType '"Number",
                          predicates.isType '"Bool"
                        ]),
                        predicates.arrays.minItems 1
                      ],
                  cache = definitions.predicate.Cache,
                  environment = definitions.predicate.Environment,
                  instance_type = definitions.predicate.InstanceType,
                  integrations = definitions.predicate.Integrations,
                  labels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  max_build_duration = predicates.isType 'Integer,
                  name = predicates.isType '"String",
                  publishing = definitions.predicate.Publishing,
                  scripts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                          definitions.predicate.NamedScript
                        ]),
                        predicates.arrays.minItems 1
                      ],
                  triggering = definitions.predicate.Triggering,
                  when = definitions.predicate.When,
                  working_directory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

{
  workflows
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true definitions.predicate.Workflow
    ])
    | doc m%"
    You can use codemagic.yaml to define several workflows for building a project. Each workflow describes the entire build pipeline from triggers to publishing. For example, you may want to have separate workflows for developing, testing and publishing the app.
    "%,
  ..
}