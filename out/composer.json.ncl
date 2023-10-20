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
          artifact-repository = {
                canonical | Bool | optional,
                exclude
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                only
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                type | std.enum.TagOrString | [| 'artifact |],
                url | String,
                ..
              },
          authors
            | doc m%"
            List of authors that contributed to the package. This is typically the main maintainers, not the full list.
            "%
            = predicates.contract_from_predicate definitions.predicate.authors,
          autoload
            | doc m%"
            Description of how the package can be autoloaded.
            "%
            = {
                classmap
                  | Array Dyn
                  | doc m%"
                  This is an array of paths that contain classes to be included in the class-map generation process.
                  "%
                  | optional,
                exclude-from-classmap
                  | Array Dyn
                  | doc m%"
                  This is an array of patterns to exclude from autoload classmap generation. (e.g. "exclude-from-classmap": ["/test/", "/tests/", "/Tests/"]
                  "%
                  | optional,
                files
                  | Array Dyn
                  | doc m%"
                  This is an array of files that are always required on every request.
                  "%
                  | optional,
                psr-0
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ])
                  ])
                  | doc m%"
                  This is an object of namespaces (keys) and the directories they can be found in (values, can be arrays of paths) by the autoloader.
                  "%
                  | optional,
                psr-4
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ])
                  ])
                  | doc m%"
                  This is an object of namespaces (keys) and the PSR-4 directories they can map to (values, can be arrays of paths) by the autoloader.
                  "%
                  | optional,
                ..
              },
          composer-repository = {
                allow_ssl_downgrade | Bool | optional,
                canonical | Bool | optional,
                exclude
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                force-lazy-providers | Bool | optional,
                only
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                options | {  .. } | optional,
                type | std.enum.TagOrString | [| 'composer |],
                url | String,
                ..
              },
          dist = {
                mirrors | Array Dyn | optional,
                reference | String | optional,
                shasum | String | optional,
                type | String,
                url | String,
                ..
              },
          inline-package = {
                archive
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf [ predicates.isType 'Record ],
                    predicates.records.record
                    { exclude = predicates.isType '"Array", }
                    {  }
                    true
                    predicates.always
                  ])
                  | optional,
                authors | definitions.contract.authors | optional,
                autoload | definitions.contract.autoload | optional,
                bin
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType '"Array" ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A set of files, or a single file, that should be treated as binaries and symlinked into bin-dir (from config).
                  "%
                  | optional,
                conflict
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                description | String | optional,
                dist | definitions.contract.dist | optional,
                extra
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType '"Array" ],
                    predicates.records.record {  } {  } true predicates.always
                  ])
                  | optional,
                homepage | String | optional,
                include-path
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf [ predicates.isType '"Array" ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  DEPRECATED: A list of directories which should get added to PHP's include path. This is only present to support legacy projects, and all new code should preferably use autoloading.
                  "%
                  | optional,
                keywords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                license
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Array" ])
                  | optional,
                name
                  | String
                  | doc m%"
                  Package name, including 'vendor-name/' prefix.
                  "%,
                provide
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                replace
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                require
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                require-dev
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                source | definitions.contract.source | optional,
                suggest
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                target-dir
                  | String
                  | doc m%"
                  DEPRECATED: Forces the package to be installed into the given subdirectory path. This is used for autoloading PSR-0 packages that do not contain their full path. Use forward slashes for cross-platform compatibility.
                  "%
                  | optional,
                time | String | optional,
                type | String | optional,
                version | String,
                ..
              },
          package-repository = {
                canonical | Bool | optional,
                exclude
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                only
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                package
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.inline-package,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.inline-package
                    ]
                  ]),
                type | std.enum.TagOrString | [| 'package |],
                ..
              },
          path-repository = {
                canonical | Bool | optional,
                exclude
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                only
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                options
                  | {
                    symlink
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ])
                      | optional,
                    ..
                  }
                  | optional,
                type | std.enum.TagOrString | [| 'path |],
                url | String,
                ..
              },
          pear-repository = {
                canonical | Bool | optional,
                exclude
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                only
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                type | std.enum.TagOrString | [| 'pear |],
                url | String,
                vendor-alias | String | optional,
                ..
              },
          repository = predicates.contract_from_predicate
              definitions.predicate.repository,
          source = {
                mirrors | Array Dyn | optional,
                reference | String,
                type | String,
                url | String,
                ..
              },
          vcs-repository = {
                branch | String | optional,
                branches-path
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | optional,
                canonical | Bool | optional,
                depot | String | optional,
                exclude
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                no-api | Bool | optional,
                only
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                p4password | String | optional,
                p4user | String | optional,
                package-path | String | optional,
                secure-http | Bool | optional,
                svn-cache-credentials | Bool | optional,
                tags-path
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | optional,
                trunk-path
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | optional,
                type
                  | std.enum.TagOrString
                  | [|
                    'svn,
                    'perforce,
                    'fossil,
                    'hg,
                    'git-bitbucket,
                    'bitbucket,
                    'gitlab,
                    'git,
                    'github,
                    'vcs
                  |],
                unique_perforce_client_name | String | optional,
                url | String,
                ..
              },
        },
    predicate = {
          artifact-repository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type", "url" ],
                predicates.records.record
                {
                  canonical = predicates.isType '"Bool",
                  exclude = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  only = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "artifact" ]
                      ],
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          authors
            | doc m%"
            List of authors that contributed to the package. This is typically the main maintainers, not the full list.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    email = predicates.isType '"String",
                    homepage = predicates.isType '"String",
                    name = predicates.isType '"String",
                    role = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          autoload
            | doc m%"
            Description of how the package can be autoloaded.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  classmap = predicates.isType '"Array",
                  exclude-from-classmap = predicates.isType '"Array",
                  files = predicates.isType '"Array",
                  psr-0 = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Array"
                          ],
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ])
                      ],
                  psr-4 = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Array"
                          ],
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ])
                      ],
                }
                {  }
                true
                predicates.always
              ],
          composer-repository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type", "url" ],
                predicates.records.record
                {
                  allow_ssl_downgrade = predicates.isType '"Bool",
                  canonical = predicates.isType '"Bool",
                  exclude = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  force-lazy-providers = predicates.isType '"Bool",
                  only = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "composer" ]
                      ],
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dist = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type", "url" ],
                predicates.records.record
                {
                  mirrors = predicates.isType '"Array",
                  reference = predicates.isType '"String",
                  shasum = predicates.isType '"String",
                  type = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          inline-package = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "version" ],
                predicates.records.record
                {
                  archive = predicates.allOf
                      [
                        predicates.anyOf [ predicates.isType 'Record ],
                        predicates.records.record
                        { exclude = predicates.isType '"Array", }
                        {  }
                        true
                        predicates.always
                      ],
                  authors = definitions.predicate.authors,
                  autoload = definitions.predicate.autoload,
                  bin = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Array"
                        ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  conflict = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  description = predicates.isType '"String",
                  dist = definitions.predicate.dist,
                  extra = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType 'Record,
                          predicates.isType '"Array"
                        ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  homepage = predicates.isType '"String",
                  include-path = predicates.allOf
                      [
                        predicates.anyOf [ predicates.isType '"Array" ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  keywords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  license = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  name = predicates.isType '"String",
                  provide = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  replace = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  require = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  require-dev = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  source = definitions.predicate.source,
                  suggest = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  target-dir = predicates.isType '"String",
                  time = predicates.isType '"String",
                  type = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          package-repository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "package", "type" ],
                predicates.records.record
                {
                  canonical = predicates.isType '"Bool",
                  exclude = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  only = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  package = predicates.oneOf
                      [
                        definitions.predicate.inline-package,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.inline-package
                        ]
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "package" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          path-repository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type", "url" ],
                predicates.records.record
                {
                  canonical = predicates.isType '"Bool",
                  exclude = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  only = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          symlink = predicates.anyOf
                              [
                                predicates.isType '"Bool",
                                predicates.isType 'Null
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "path" ]
                      ],
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          pear-repository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type", "url" ],
                predicates.records.record
                {
                  canonical = predicates.isType '"Bool",
                  exclude = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  only = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "pear" ]
                      ],
                  url = predicates.isType '"String",
                  vendor-alias = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          repository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  definitions.predicate.composer-repository,
                  definitions.predicate.vcs-repository,
                  definitions.predicate.path-repository,
                  definitions.predicate.artifact-repository,
                  definitions.predicate.pear-repository,
                  definitions.predicate.package-repository
                ]
              ],
          source = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "reference", "type", "url" ],
                predicates.records.record
                {
                  mirrors = predicates.isType '"Array",
                  reference = predicates.isType '"String",
                  type = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          vcs-repository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type", "url" ],
                predicates.records.record
                {
                  branch = predicates.isType '"String",
                  branches-path = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  canonical = predicates.isType '"Bool",
                  depot = predicates.isType '"String",
                  exclude = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  no-api = predicates.isType '"Bool",
                  only = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  p4password = predicates.isType '"String",
                  p4user = predicates.isType '"String",
                  package-path = predicates.isType '"String",
                  secure-http = predicates.isType '"Bool",
                  svn-cache-credentials = predicates.isType '"Bool",
                  tags-path = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  trunk-path = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "vcs",
                          "github",
                          "git",
                          "gitlab",
                          "bitbucket",
                          "git-bitbucket",
                          "hg",
                          "fossil",
                          "perforce",
                          "svn"
                        ]
                      ],
                  unique_perforce_client_name = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

{
  _comment
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ predicates.isType '"Array", predicates.isType '"String" ])
    | doc m%"
    A key to store comments in
    "%
    | optional,
  abandoned
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ predicates.isType '"Bool", predicates.isType '"String" ])
    | doc m%"
    Indicates whether this package has been abandoned, it can be boolean or a package name/URL pointing to a recommended alternative. Defaults to false.
    "%
    | optional,
  archive
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType 'Record ],
      predicates.records.record
      {
        exclude = predicates.isType '"Array",
        name = predicates.isType '"String",
      }
      {  }
      true
      predicates.always
    ])
    | doc m%"
    Options for creating package archives for distribution.
    "%
    | optional,
  authors | definitions.contract.authors | optional,
  autoload | definitions.contract.autoload | optional,
  autoload-dev
    | {
      classmap
        | Array Dyn
        | doc m%"
        This is an array of paths that contain classes to be included in the class-map generation process.
        "%
        | optional,
      files
        | Array Dyn
        | doc m%"
        This is an array of files that are always required on every request.
        "%
        | optional,
      psr-0
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.anyOf
            [ predicates.isType '"String", predicates.isType '"Array" ],
            predicates.arrays.arrayOf (predicates.isType '"String")
          ])
        ])
        | doc m%"
        This is an object of namespaces (keys) and the directories they can be found into (values, can be arrays of paths) by the autoloader.
        "%
        | optional,
      psr-4
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.anyOf
            [ predicates.isType '"String", predicates.isType '"Array" ],
            predicates.arrays.arrayOf (predicates.isType '"String")
          ])
        ])
        | doc m%"
        This is an object of namespaces (keys) and the PSR-4 directories they can map to (values, can be arrays of paths) by the autoloader.
        "%
        | optional,
      ..
    }
    | doc m%"
    Description of additional autoload rules for development purpose (eg. a test suite).
    "%
    | optional,
  bin
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"String", predicates.isType '"Array" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A set of files, or a single file, that should be treated as binaries and symlinked into bin-dir (from config).
    "%
    | optional,
  config
    | {
      allow-plugins
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Record, predicates.isType '"Bool" ],
          predicates.records.record {  } {  } true
          (predicates.anyOf [ predicates.isType '"Bool" ])
        ])
        | doc m%"
        This is an object of {"pattern": true|false} with packages which are allowed to be loaded as plugins, or true to allow all, false to allow none. Defaults to {} which prompts when an unknown plugin is added.
        "%
        | optional,
      apcu-autoloader
        | Bool
        | doc m%"
        If true, the Composer autoloader will check for APCu and use it to cache found/not-found classes when the extension is enabled, defaults to false.
        "%
        | optional,
      archive-dir
        | String
        | doc m%"
        The default archive path when not provided on cli, defaults to ".".
        "%
        | optional,
      archive-format
        | String
        | doc m%"
        The default archiving format when not provided on cli, defaults to "tar".
        "%
        | optional,
      audit
        | {
          abandoned
            | predicates.contract_from_predicate
            (predicates.enum [ "ignore", "report", "fail" ])
            | doc m%"
            Whether abandoned packages should be ignored, reported as problems or cause an audit failure.
            "%
            | optional,
          ignore
            | predicates.contract_from_predicate
            (predicates.anyOf
            [
              predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.anyOf
                [ predicates.isType '"String", predicates.isType '"String" ])
              ],
              predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ]
            ])
            | optional,
          ..
        }
        | doc m%"
        Security audit configuration options
        "%
        | optional,
      autoloader-suffix
        | String
        | doc m%"
        Optional string to be used as a suffix for the generated Composer autoloader. When null a random one will be generated.
        "%
        | optional,
      bearer
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true (predicates.isType '"String")
        ])
        | doc m%"
        An object of domain name => bearer authentication token, for example {"example.com":"<token>"}.
        "%
        | optional,
      bin-compat
        | predicates.contract_from_predicate
        (predicates.enum [ "auto", "full", "proxy", "symlink" ])
        | doc m%"
        The compatibility of the binaries, defaults to "auto" (automatically guessed), can be "full" (compatible with both Windows and Unix-based systems) and "proxy" (only bash-style proxy).
        "%
        | optional,
      bin-dir
        | String
        | doc m%"
        The location where all binaries are linked, defaults to "vendor/bin".
        "%
        | optional,
      bitbucket-oauth
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "consumer-key", "consumer-secret" ],
            predicates.records.record
            {
              access-token = predicates.isType '"String",
              access-token-expiration = predicates.isType 'Integer,
              consumer-key = predicates.isType '"String",
              consumer-secret = predicates.isType '"String",
            }
            {  }
            true
            predicates.always
          ])
        ])
        | doc m%"
        An object of domain name => {"consumer-key": "...", "consumer-secret": "..."}.
        "%
        | optional,
      cache-dir
        | String
        | doc m%%"
        The location where all caches are located, defaults to "~/.composer/cache" on *nix and "%LOCALAPPDATA%\Composer" on windows.
        "%%
        | optional,
      cache-files-dir
        | String
        | doc m%"
        The location where files (zip downloads) are cached, defaults to "{$cache-dir}/files".
        "%
        | optional,
      cache-files-maxsize
        | predicates.contract_from_predicate
        (predicates.anyOf
        [ predicates.isType '"String", predicates.isType 'Integer ])
        | doc m%"
        The cache max size for the files cache, defaults to "300MiB".
        "%
        | optional,
      cache-files-ttl
        | std.number.Integer
        | doc m%"
        The cache time-to-live for files, defaults to the value of cache-ttl.
        "%
        | optional,
      cache-read-only
        | predicates.contract_from_predicate
        (predicates.anyOf [ predicates.isType '"Bool" ])
        | doc m%"
        Whether to use the Composer cache in read-only mode.
        "%
        | optional,
      cache-repo-dir
        | String
        | doc m%"
        The location where repo (git/hg repo clones) are cached, defaults to "{$cache-dir}/repo".
        "%
        | optional,
      cache-ttl
        | std.number.Integer
        | doc m%"
        The default cache time-to-live, defaults to 15552000 (6 months).
        "%
        | optional,
      cache-vcs-dir
        | String
        | doc m%"
        The location where vcs infos (git clones, github api calls, etc. when reading vcs repos) are cached, defaults to "{$cache-dir}/vcs".
        "%
        | optional,
      cafile
        | String
        | doc m%"
        A way to set the path to the openssl CA file. In PHP 5.6+ you should rather set this via openssl.cafile in php.ini, although PHP 5.6+ should be able to detect your system CA file automatically.
        "%
        | optional,
      capath
        | String
        | doc m%"
        If cafile is not specified or if the certificate is not found there, the directory pointed to by capath is searched for a suitable certificate. capath must be a correctly hashed certificate directory.
        "%
        | optional,
      classmap-authoritative
        | Bool
        | doc m%"
        If true, the composer autoloader will not scan the filesystem for classes that are not found in the class map, defaults to false.
        "%
        | optional,
      data-dir
        | String
        | doc m%"
        The location where old phar files are stored, defaults to "$home" except on XDG Base Directory compliant unixes.
        "%
        | optional,
      disable-tls
        | Bool
        | doc m%"
        Defaults to `false`. If set to true all HTTPS URLs will be tried with HTTP instead and no network level encryption is performed. Enabling this is a security risk and is NOT recommended. The better way is to enable the php_openssl extension in php.ini.
        "%
        | optional,
      discard-changes
        | predicates.contract_from_predicate
        (predicates.anyOf
        [ predicates.isType '"String", predicates.isType '"Bool" ])
        | doc m%"
        The default style of handling dirty updates, defaults to false and can be any of true, false or "stash".
        "%
        | optional,
      github-domains
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        A list of domains to use in github mode. This is used for GitHub Enterprise setups, defaults to ["github.com"].
        "%
        | optional,
      github-expose-hostname
        | Bool
        | doc m%"
        Defaults to true. If set to false, the OAuth tokens created to access the github API will have a date instead of the machine hostname.
        "%
        | optional,
      github-oauth
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true (predicates.isType '"String")
        ])
        | doc m%"
        An object of domain name => github API oauth tokens, typically {"github.com":"<token>"}.
        "%
        | optional,
      github-protocols
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        A list of protocols to use for github.com clones, in priority order, defaults to ["https", "ssh", "git"].
        "%
        | optional,
      gitlab-domains
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        A list of domains to use in gitlab mode. This is used for custom GitLab setups, defaults to ["gitlab.com"].
        "%
        | optional,
      gitlab-oauth
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.anyOf
            [ predicates.isType '"String", predicates.isType 'Record ],
            predicates.records.required [ "token" ],
            predicates.records.record
            {
              expires-at = predicates.isType 'Integer,
              refresh-token = predicates.isType '"String",
              token = predicates.isType '"String",
            }
            {  }
            true
            predicates.always
          ])
        ])
        | doc m%"
        An object of domain name => gitlab API oauth tokens, typically {"gitlab.com":{"expires-at":"<expiration date>", "refresh-token":"<refresh token>", "token":"<token>"}}.
        "%
        | optional,
      gitlab-protocol
        | predicates.contract_from_predicate
        (predicates.enum [ "git", "http", "https" ])
        | doc m%"
        A protocol to force use of when creating a repository URL for the `source` value of the package metadata. One of `git` or `http`. By default, Composer will generate a git URL for private repositories and http one for public repos.
        "%
        | optional,
      gitlab-token
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.anyOf
            [ predicates.isType '"String", predicates.isType 'Record ],
            predicates.records.required [ "token", "username" ],
            predicates.records.record
            {
              token = predicates.isType '"String",
              username = predicates.isType '"String",
            }
            {  }
            true
            predicates.always
          ])
        ])
        | doc m%"
        An object of domain name => gitlab private tokens, typically {"gitlab.com":"<token>"}, or an object with username and token keys.
        "%
        | optional,
      htaccess-protect
        | Bool
        | doc m%"
        Defaults to true. If set to false, Composer will not create .htaccess files in the composer home, cache, and data directories.
        "%
        | optional,
      http-basic
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "password", "username" ],
            predicates.records.record
            {
              password = predicates.isType '"String",
              username = predicates.isType '"String",
            }
            {  }
            true
            predicates.always
          ])
        ])
        | doc m%"
        An object of domain name => {"username": "...", "password": "..."}.
        "%
        | optional,
      lock
        | Bool
        | doc m%"
        Defaults to true. If set to false, Composer will not create a composer.lock file.
        "%
        | optional,
      notify-on-install
        | Bool
        | doc m%"
        Composer allows repositories to define a notification URL, so that they get notified whenever a package from that repository is installed. This option allows you to disable that behaviour, defaults to true.
        "%
        | optional,
      optimize-autoloader
        | Bool
        | doc m%"
        Always optimize when dumping the autoloader.
        "%
        | optional,
      platform
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Bool" ])
        ])
        | doc m%"
        This is an object of package name (keys) and version (values) that will be used to mock the platform packages on this machine, the version can be set to false to make it appear like the package is not present.
        "%
        | optional,
      platform-check
        | predicates.contract_from_predicate
        (predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType '"String" ])
        | doc m%"
        Defaults to "php-only" which checks only the PHP version. Setting to true will also check the presence of required PHP extensions. If set to false, Composer will not create and require a platform_check.php file as part of the autoloader bootstrap.
        "%
        | optional,
      preferred-install
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType 'Record ],
          predicates.records.record {  } {  } true
          (predicates.anyOf [ predicates.isType '"String" ])
        ])
        | doc m%"
        The install method Composer will prefer to use, defaults to auto and can be any of source, dist, auto, or an object of {"pattern": "preference"}.
        "%
        | optional,
      prepend-autoloader
        | Bool
        | doc m%"
        If false, the composer autoloader will not be prepended to existing autoloaders, defaults to true.
        "%
        | optional,
      process-timeout
        | std.number.Integer
        | doc m%"
        The timeout in seconds for process executions, defaults to 300 (5mins).
        "%
        | optional,
      secure-http
        | Bool
        | doc m%"
        Defaults to `true`. If set to true only HTTPS URLs are allowed to be downloaded via Composer. If you really absolutely need HTTP access to something then you can disable it, but using "Let's Encrypt" to get a free SSL certificate is generally a better alternative.
        "%
        | optional,
      secure-svn-domains
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        A list of domains which should be trusted/marked as using a secure Subversion/SVN transport. By default svn:// protocol is seen as insecure and will throw. This is a better/safer alternative to disabling `secure-http` altogether.
        "%
        | optional,
      sort-packages
        | Bool
        | doc m%"
        Defaults to false. If set to true, Composer will sort packages when adding/updating a new dependency.
        "%
        | optional,
      store-auths
        | predicates.contract_from_predicate
        (predicates.anyOf
        [ predicates.isType '"String", predicates.isType '"Bool" ])
        | doc m%"
        What to do after prompting for authentication, one of: true (store), false (do not store) or "prompt" (ask every time), defaults to prompt.
        "%
        | optional,
      use-github-api
        | Bool
        | doc m%"
        Defaults to true.  If set to false, globally disables the use of the GitHub API for all GitHub repositories and clones the repository as it would for any other repository.
        "%
        | optional,
      use-include-path
        | Bool
        | doc m%"
        If true, the Composer autoloader will also look for classes in the PHP include path.
        "%
        | optional,
      use-parent-dir
        | predicates.contract_from_predicate
        (predicates.anyOf
        [ predicates.isType '"String", predicates.isType '"Bool" ])
        | doc m%"
        When running Composer in a directory where there is no composer.json, if there is one present in a directory above Composer will by default ask you whether you want to use that directory's composer.json instead. One of: true (always use parent if needed), false (never ask or use it) or "prompt" (ask every time), defaults to prompt.
        "%
        | optional,
      vendor-dir
        | String
        | doc m%"
        The location where all packages are installed, defaults to "vendor".
        "%
        | optional,
      ..
    }
    | doc m%"
    Composer options.
    "%
    | optional,
  conflict
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true (predicates.isType '"String")
    ])
    | doc m%"
    This is an object of package name (keys) and version constraints (values) that conflict with this package.
    "%
    | optional,
  default-branch
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool" ])
    | doc m%"
    Internal use only, do not specify this in composer.json. Indicates whether this version is the default branch of the linked VCS repository. Defaults to false.
    "%
    | optional,
  description
    | String
    | doc m%"
    Short package description.
    "%
    | optional,
  dist | definitions.contract.dist | optional,
  extra
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType 'Record, predicates.isType '"Array" ],
      predicates.records.record {  } {  } true predicates.always
    ])
    | doc m%"
    Arbitrary extra data that can be used by plugins, for example, package of type composer-plugin may have a 'class' key defining an installer class name.
    "%
    | optional,
  funding
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record
        {
          type = predicates.isType '"String",
          url = predicates.isType '"String",
        }
        {  }
        true
        predicates.always
      ])
    ])
    | doc m%"
    A list of options to fund the development and maintenance of the package.
    "%
    | optional,
  homepage
    | String
    | doc m%"
    Homepage URL for the project.
    "%
    | optional,
  include-path
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    DEPRECATED: A list of directories which should get added to PHP's include path. This is only present to support legacy projects, and all new code should preferably use autoloading.
    "%
    | optional,
  keywords
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  license
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ predicates.isType '"String", predicates.isType '"Array" ])
    | doc m%"
    License name. Or an array of license names.
    "%
    | optional,
  minimum-stability
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"String" ],
      predicates.enum [ "dev", "alpha", "beta", "rc", "RC", "stable" ]
    ])
    | doc m%"
    The minimum stability the packages must have to be install-able. Possible values are: dev, alpha, beta, RC, stable.
    "%
    | optional,
  name
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"String",
      predicates.strings.pattern
      "^[a-z0-9]([_.-]?[a-z0-9]+)*/[a-z0-9](([_.]|-{1,2})?[a-z0-9]+)*$"
    ])
    | doc m%"
    Package name, including 'vendor-name/' prefix.
    "%
    | optional,
  non-feature-branches
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType '"Array" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A set of string or regex patterns for non-numeric branch names that will not be handled as feature branches.
    "%
    | optional,
  prefer-stable
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool" ])
    | doc m%"
    If set to true, stable packages will be preferred to dev packages when possible, even if the minimum-stability allows unstable packages.
    "%
    | optional,
  provide
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true (predicates.isType '"String")
    ])
    | doc m%"
    This is an object of package name (keys) and version constraints (values) that this package provides in addition to this package's name.
    "%
    | optional,
  readme
    | String
    | doc m%"
    Relative path to the readme document.
    "%
    | optional,
  replace
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true (predicates.isType '"String")
    ])
    | doc m%"
    This is an object of package name (keys) and version constraints (values) that can be replaced by this package.
    "%
    | optional,
  repositories
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType 'Record, predicates.isType '"Array" ],
      predicates.arrays.arrayOf
      (predicates.anyOf
      [
        definitions.predicate.repository,
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.maxProperties 1,
          predicates.records.minProperties 1,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [ predicates.isType '"Bool", predicates.enum [ false ] ])
        ]
      ]),
      predicates.records.record {  } {  } true
      (predicates.anyOf
      [
        definitions.predicate.repository,
        predicates.allOf
        [ predicates.isType '"Bool", predicates.enum [ false ] ]
      ])
    ])
    | doc m%"
    A set of additional repositories where packages can be found.
    "%
    | optional,
  require
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true (predicates.isType '"String")
    ])
    | doc m%"
    This is an object of package name (keys) and version constraints (values) that are required to run this package.
    "%
    | optional,
  require-dev
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true (predicates.isType '"String")
    ])
    | doc m%"
    This is an object of package name (keys) and version constraints (values) that this package requires for developing it (testing tools and such).
    "%
    | optional,
  scripts
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType 'Record ],
      predicates.records.record
      {
        post-autoload-dump = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        post-create-project-cmd = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        post-install-cmd = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        post-package-install = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        post-package-uninstall = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        post-package-update = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        post-root-package-install = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        post-status-cmd = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        post-update-cmd = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        pre-autoload-dump = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        pre-install-cmd = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        pre-package-install = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        pre-package-uninstall = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        pre-package-update = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        pre-status-cmd = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
        pre-update-cmd = predicates.anyOf
            [ predicates.isType '"Array", predicates.isType '"String" ],
      }
      {  }
      true
      predicates.always
    ])
    | doc m%"
    Script listeners that will be executed before/after some events.
    "%
    | optional,
  scripts-descriptions
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType 'Record ],
      predicates.records.record {  } {  } true (predicates.isType '"String")
    ])
    | doc m%"
    Descriptions for custom commands, shown in console help.
    "%
    | optional,
  source | definitions.contract.source | optional,
  suggest
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true (predicates.isType '"String")
    ])
    | doc m%"
    This is an object of package name (keys) and descriptions (values) that this package suggests work well with it (this will be suggested to the user during installation).
    "%
    | optional,
  support
    | {
      chat
        | String
        | doc m%"
        URL to the support chat.
        "%
        | optional,
      docs
        | String
        | doc m%"
        URL to the documentation.
        "%
        | optional,
      email
        | String
        | doc m%"
        Email address for support.
        "%
        | optional,
      forum
        | String
        | doc m%"
        URL to the forum.
        "%
        | optional,
      irc
        | String
        | doc m%"
        IRC channel for support, as irc://server/channel.
        "%
        | optional,
      issues
        | String
        | doc m%"
        URL to the issue tracker.
        "%
        | optional,
      rss
        | String
        | doc m%"
        URL to the RSS feed.
        "%
        | optional,
      security
        | String
        | doc m%"
        URL to the vulnerability disclosure policy (VDP).
        "%
        | optional,
      source
        | String
        | doc m%"
        URL to browse or download the sources.
        "%
        | optional,
      wiki
        | String
        | doc m%"
        URL to the wiki.
        "%
        | optional,
      ..
    }
    | optional,
  target-dir
    | String
    | doc m%"
    DEPRECATED: Forces the package to be installed into the given subdirectory path. This is used for autoloading PSR-0 packages that do not contain their full path. Use forward slashes for cross-platform compatibility.
    "%
    | optional,
  time
    | String
    | doc m%"
    Package release date, in 'YYYY-MM-DD', 'YYYY-MM-DD HH:MM:SS' or 'YYYY-MM-DDTHH:MM:SSZ' format.
    "%
    | optional,
  type
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.pattern "^[a-z0-9-]+$" ])
    | doc m%"
    Package type, either 'library' for common packages, 'composer-plugin' for plugins, 'metapackage' for empty packages, or a custom type ([a-z0-9-]+) defined by whatever project this package applies to.
    "%
    | optional,
  version
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"String",
      predicates.strings.pattern "^v?\\d+(\\.\\d+){0,3}|^dev-"
    ])
    | doc m%"
    Package version, see https://getcomposer.org/doc/04-schema.md#version for more info on valid schemes.
    "%
    | optional,
  ..
}