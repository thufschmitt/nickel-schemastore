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
          blkio_limit = {
                path | String | optional,
                rate
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType '"String" ])
                  | optional,
              },
          blkio_weight = {
                path | String | optional,
                weight | std.number.Integer | optional,
              },
          command = predicates.contract_from_predicate
              definitions.predicate.command,
          config = predicates.contract_from_predicate
              definitions.predicate.config,
          constraints = predicates.contract_from_predicate
              definitions.predicate.constraints,
          deployment = predicates.contract_from_predicate
              definitions.predicate.deployment,
          development = predicates.contract_from_predicate
              definitions.predicate.development,
          devices = predicates.contract_from_predicate
              definitions.predicate.devices,
          generic_resources = predicates.contract_from_predicate
              definitions.predicate.generic_resources,
          healthcheck = predicates.contract_from_predicate
              definitions.predicate.healthcheck,
          include = predicates.contract_from_predicate
              definitions.predicate.include,
          list_of_strings = predicates.contract_from_predicate
              definitions.predicate.list_of_strings,
          list_or_dict = predicates.contract_from_predicate
              definitions.predicate.list_or_dict,
          network = predicates.contract_from_predicate
              definitions.predicate.network,
          secret = predicates.contract_from_predicate
              definitions.predicate.secret,
          service = predicates.contract_from_predicate
              definitions.predicate.service,
          service_config_or_secret = predicates.contract_from_predicate
              definitions.predicate.service_config_or_secret,
          string_or_list = predicates.contract_from_predicate
              definitions.predicate.string_or_list,
          volume = predicates.contract_from_predicate
              definitions.predicate.volume,
        },
    predicate = {
          blkio_limit = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  rate = predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.isType '"String"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          blkio_weight = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  weight = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          command = predicates.oneOf
              [
                predicates.isType 'Null,
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
          config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  external = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType 'Record
                        ],
                        predicates.records.record
                        { name = predicates.isType '"String", }
                        {  }
                        true
                        predicates.always
                      ],
                  file = predicates.isType '"String",
                  labels = definitions.predicate.list_or_dict,
                  name = predicates.isType '"String",
                  template_driver = predicates.isType '"String",
                }
                { "^x-" = predicates.always, }
                false
                predicates.never
              ],
          constraints = predicates.always,
          deployment = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record
                {
                  endpoint_mode = predicates.isType '"String",
                  labels = definitions.predicate.list_or_dict,
                  mode = predicates.isType '"String",
                  placement = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          constraints = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          max_replicas_per_node = predicates.isType 'Integer,
                          preferences = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  { spread = predicates.isType '"String", }
                                  { "^x-" = predicates.always, }
                                  false
                                  predicates.never
                                ])
                              ],
                        }
                        { "^x-" = predicates.always, }
                        false
                        predicates.never
                      ],
                  replicas = predicates.isType 'Integer,
                  resources = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          limits = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  cpus = predicates.anyOf
                                      [
                                        predicates.isType '"Number",
                                        predicates.isType '"String"
                                      ],
                                  memory = predicates.isType '"String",
                                  pids = predicates.isType 'Integer,
                                }
                                { "^x-" = predicates.always, }
                                false
                                predicates.never
                              ],
                          reservations = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  cpus = predicates.anyOf
                                      [
                                        predicates.isType '"Number",
                                        predicates.isType '"String"
                                      ],
                                  devices = definitions.predicate.devices,
                                  generic_resources =
                                    definitions.predicate.generic_resources,
                                  memory = predicates.isType '"String",
                                }
                                { "^x-" = predicates.always, }
                                false
                                predicates.never
                              ],
                        }
                        { "^x-" = predicates.always, }
                        false
                        predicates.never
                      ],
                  restart_policy = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          condition = predicates.isType '"String",
                          delay = predicates.isType '"String",
                          max_attempts = predicates.isType 'Integer,
                          window = predicates.isType '"String",
                        }
                        { "^x-" = predicates.always, }
                        false
                        predicates.never
                      ],
                  rollback_config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          delay = predicates.isType '"String",
                          failure_action = predicates.isType '"String",
                          max_failure_ratio = predicates.isType '"Number",
                          monitor = predicates.isType '"String",
                          order = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "start-first", "stop-first" ]
                              ],
                          parallelism = predicates.isType 'Integer,
                        }
                        { "^x-" = predicates.always, }
                        false
                        predicates.never
                      ],
                  update_config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          delay = predicates.isType '"String",
                          failure_action = predicates.isType '"String",
                          max_failure_ratio = predicates.isType '"Number",
                          monitor = predicates.isType '"String",
                          order = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "start-first", "stop-first" ]
                              ],
                          parallelism = predicates.isType 'Integer,
                        }
                        { "^x-" = predicates.always, }
                        false
                        predicates.never
                      ],
                }
                { "^x-" = predicates.always, }
                false
                predicates.never
              ],
          development = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record
                {
                  watch = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            action = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum
                                  [ "rebuild", "sync", "sync+restart" ]
                                ],
                            ignore = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            path = predicates.isType '"String",
                            target = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ]),
                        predicates.records.record {  }
                        { "^x-" = predicates.always, }
                        false
                        predicates.never
                      ],
                }
                {  }
                true
                predicates.always
              ],
          devices = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    capabilities = definitions.predicate.list_of_strings,
                    count = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Integer
                        ],
                    device_ids = definitions.predicate.list_of_strings,
                    driver = predicates.isType '"String",
                    options = definitions.predicate.list_or_dict,
                  }
                  { "^x-" = predicates.always, }
                  false
                  predicates.never
                ])
              ],
          generic_resources = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    discrete_resource_spec = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            kind = predicates.isType '"String",
                            value = predicates.isType '"Number",
                          }
                          { "^x-" = predicates.always, }
                          false
                          predicates.never
                        ],
                  }
                  { "^x-" = predicates.always, }
                  false
                  predicates.never
                ])
              ],
          healthcheck = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  disable = predicates.isType '"Bool",
                  interval = predicates.isType '"String",
                  retries = predicates.isType '"Number",
                  start_interval = predicates.isType '"String",
                  start_period = predicates.isType '"String",
                  test = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  timeout = predicates.isType '"String",
                }
                { "^x-" = predicates.always, }
                false
                predicates.never
              ],
          include = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    env_file = definitions.predicate.string_or_list,
                    path = definitions.predicate.string_or_list,
                    project_directory = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          list_of_strings = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String"),
                predicates.arrays.uniqueItems
              ],
          list_or_dict = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    ".+" = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number",
                          predicates.isType '"Bool",
                          predicates.isType 'Null
                        ],
                  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String"),
                  predicates.arrays.uniqueItems
                ]
              ],
          network = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record
                {
                  attachable = predicates.isType '"Bool",
                  driver = predicates.isType '"String",
                  driver_opts = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^.+$" = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  enable_ipv6 = predicates.isType '"Bool",
                  external = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType 'Record
                        ],
                        predicates.records.record
                        { name = predicates.isType '"String", }
                        { "^x-" = predicates.always, }
                        false
                        predicates.never
                      ],
                  internal = predicates.isType '"Bool",
                  ipam = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          config = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    aux_addresses = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record {  }
                                          {
                                            "^.+$" = predicates.isType
                                                '"String",
                                          }
                                          false
                                          predicates.never
                                        ],
                                    gateway = predicates.isType '"String",
                                    ip_range = predicates.isType '"String",
                                    subnet = predicates.isType '"String",
                                  }
                                  { "^x-" = predicates.always, }
                                  false
                                  predicates.never
                                ])
                              ],
                          driver = predicates.isType '"String",
                          options = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                { "^.+$" = predicates.isType '"String", }
                                false
                                predicates.never
                              ],
                        }
                        { "^x-" = predicates.always, }
                        false
                        predicates.never
                      ],
                  labels = definitions.predicate.list_or_dict,
                  name = predicates.isType '"String",
                }
                { "^x-" = predicates.always, }
                false
                predicates.never
              ],
          secret = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  driver = predicates.isType '"String",
                  driver_opts = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^.+$" = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  environment = predicates.isType '"String",
                  external = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType 'Record
                        ],
                        predicates.records.record
                        { name = predicates.isType '"String", }
                        {  }
                        true
                        predicates.always
                      ],
                  file = predicates.isType '"String",
                  labels = definitions.predicate.list_or_dict,
                  name = predicates.isType '"String",
                  template_driver = predicates.isType '"String",
                }
                { "^x-" = predicates.always, }
                false
                predicates.never
              ],
          service = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotations = definitions.predicate.list_or_dict,
                  attach = predicates.isType '"Bool",
                  blkio_config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          device_read_bps = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.blkio_limit
                              ],
                          device_read_iops = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.blkio_limit
                              ],
                          device_write_bps = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.blkio_limit
                              ],
                          device_write_iops = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.blkio_limit
                              ],
                          weight = predicates.isType 'Integer,
                          weight_device = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.blkio_weight
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  build = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            additional_contexts =
                              definitions.predicate.list_or_dict,
                            args = definitions.predicate.list_or_dict,
                            cache_from = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            cache_to = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            context = predicates.isType '"String",
                            dockerfile = predicates.isType '"String",
                            dockerfile_inline = predicates.isType '"String",
                            extra_hosts = definitions.predicate.list_or_dict,
                            isolation = predicates.isType '"String",
                            labels = definitions.predicate.list_or_dict,
                            network = predicates.isType '"String",
                            no_cache = predicates.isType '"Bool",
                            platforms = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            privileged = predicates.isType '"Bool",
                            pull = predicates.isType '"Bool",
                            secrets =
                              definitions.predicate.service_config_or_secret,
                            shm_size = predicates.anyOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.isType '"String"
                                ],
                            ssh = definitions.predicate.list_or_dict,
                            tags = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            target = predicates.isType '"String",
                          }
                          { "^x-" = predicates.always, }
                          false
                          predicates.never
                        ]
                      ],
                  cap_add = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  cap_drop = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  cgroup = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "host", "private" ]
                      ],
                  cgroup_parent = predicates.isType '"String",
                  command = definitions.predicate.command,
                  configs = definitions.predicate.service_config_or_secret,
                  container_name = predicates.isType '"String",
                  cpu_count = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  cpu_percent = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 100,
                        predicates.numbers.minimum 0
                      ],
                  cpu_period = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String"
                      ],
                  cpu_quota = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String"
                      ],
                  cpu_rt_period = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String"
                      ],
                  cpu_rt_runtime = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String"
                      ],
                  cpu_shares = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String"
                      ],
                  cpus = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String"
                      ],
                  cpuset = predicates.isType '"String",
                  credential_spec = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          config = predicates.isType '"String",
                          file = predicates.isType '"String",
                          registry = predicates.isType '"String",
                        }
                        { "^x-" = predicates.always, }
                        false
                        predicates.never
                      ],
                  depends_on = predicates.oneOf
                      [
                        definitions.predicate.list_of_strings,
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          {
                            "^[a-zA-Z0-9._-]+$" = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required [ "condition" ],
                                  predicates.records.record
                                  {
                                    condition = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "service_started",
                                            "service_healthy",
                                            "service_completed_successfully"
                                          ]
                                        ],
                                    required = predicates.isType '"Bool",
                                    restart = predicates.isType '"Bool",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                          }
                          false
                          predicates.never
                        ]
                      ],
                  deploy = definitions.predicate.deployment,
                  develop = definitions.predicate.development,
                  device_cgroup_rules = definitions.predicate.list_of_strings,
                  devices = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  dns = definitions.predicate.string_or_list,
                  dns_opt = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  dns_search = definitions.predicate.string_or_list,
                  domainname = predicates.isType '"String",
                  entrypoint = definitions.predicate.command,
                  env_file = definitions.predicate.string_or_list,
                  environment = definitions.predicate.list_or_dict,
                  expose = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number"
                        ]),
                        predicates.arrays.uniqueItems
                      ],
                  extends = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "service" ],
                          predicates.records.record
                          {
                            file = predicates.isType '"String",
                            service = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ],
                  external_links = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  extra_hosts = definitions.predicate.list_or_dict,
                  group_add = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number"
                        ]),
                        predicates.arrays.uniqueItems
                      ],
                  healthcheck = definitions.predicate.healthcheck,
                  hostname = predicates.isType '"String",
                  image = predicates.isType '"String",
                  init = predicates.isType '"Bool",
                  ipc = predicates.isType '"String",
                  isolation = predicates.isType '"String",
                  labels = definitions.predicate.list_or_dict,
                  links = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  logging = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          driver = predicates.isType '"String",
                          options = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                {
                                  "^.+$" = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType '"Number",
                                        predicates.isType 'Null
                                      ],
                                }
                                true
                                predicates.always
                              ],
                        }
                        { "^x-" = predicates.always, }
                        false
                        predicates.never
                      ],
                  mac_address = predicates.isType '"String",
                  mem_limit = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String"
                      ],
                  mem_reservation = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Integer
                      ],
                  mem_swappiness = predicates.isType 'Integer,
                  memswap_limit = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String"
                      ],
                  network_mode = predicates.isType '"String",
                  networks = predicates.oneOf
                      [
                        definitions.predicate.list_of_strings,
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          {
                            "^[a-zA-Z0-9._-]+$" = predicates.oneOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      aliases =
                                        definitions.predicate.list_of_strings,
                                      ipv4_address = predicates.isType
                                          '"String",
                                      ipv6_address = predicates.isType
                                          '"String",
                                      link_local_ips =
                                        definitions.predicate.list_of_strings,
                                      "priority" = predicates.isType '"Number",
                                    }
                                    { "^x-" = predicates.always, }
                                    false
                                    predicates.never
                                  ],
                                  predicates.isType 'Null
                                ],
                          }
                          false
                          predicates.never
                        ]
                      ],
                  oom_kill_disable = predicates.isType '"Bool",
                  oom_score_adj = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 1000,
                        predicates.numbers.minimum (-1000)
                      ],
                  pid = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  pids_limit = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String"
                      ],
                  platform = predicates.isType '"String",
                  ports = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.oneOf
                        [
                          predicates.isType '"Number",
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              host_ip = predicates.isType '"String",
                              mode = predicates.isType '"String",
                              protocol = predicates.isType '"String",
                              published = predicates.anyOf
                                  [
                                    predicates.isType '"String",
                                    predicates.isType 'Integer
                                  ],
                              target = predicates.isType 'Integer,
                            }
                            { "^x-" = predicates.always, }
                            false
                            predicates.never
                          ]
                        ]),
                        predicates.arrays.uniqueItems
                      ],
                  privileged = predicates.isType '"Bool",
                  profiles = definitions.predicate.list_of_strings,
                  pull_policy = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "always",
                          "never",
                          "if_not_present",
                          "build",
                          "missing"
                        ]
                      ],
                  read_only = predicates.isType '"Bool",
                  restart = predicates.isType '"String",
                  runtime = predicates.isType '"String",
                  scale = predicates.isType 'Integer,
                  secrets = definitions.predicate.service_config_or_secret,
                  security_opt = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  shm_size = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String"
                      ],
                  stdin_open = predicates.isType '"Bool",
                  stop_grace_period = predicates.isType '"String",
                  stop_signal = predicates.isType '"String",
                  storage_opt = predicates.isType 'Record,
                  sysctls = definitions.predicate.list_or_dict,
                  tmpfs = definitions.predicate.string_or_list,
                  tty = predicates.isType '"Bool",
                  ulimits = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[a-z]+$" = predicates.oneOf
                              [
                                predicates.isType 'Integer,
                                predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "hard", "soft" ],
                                  predicates.records.record
                                  {
                                    hard = predicates.isType 'Integer,
                                    soft = predicates.isType 'Integer,
                                  }
                                  { "^x-" = predicates.always, }
                                  false
                                  predicates.never
                                ]
                              ],
                        }
                        true
                        predicates.always
                      ],
                  user = predicates.isType '"String",
                  userns_mode = predicates.isType '"String",
                  uts = predicates.isType '"String",
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "type" ],
                            predicates.records.record
                            {
                              bind = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      create_host_path = predicates.isType
                                          '"Bool",
                                      propagation = predicates.isType '"String",
                                      selinux = predicates.allOf
                                          [
                                            predicates.isType '"String",
                                            predicates.enum [ "z", "Z" ]
                                          ],
                                    }
                                    { "^x-" = predicates.always, }
                                    false
                                    predicates.never
                                  ],
                              consistency = predicates.isType '"String",
                              read_only = predicates.isType '"Bool",
                              source = predicates.isType '"String",
                              target = predicates.isType '"String",
                              tmpfs = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      mode = predicates.isType '"Number",
                                      size = predicates.oneOf
                                          [
                                            predicates.allOf
                                            [
                                              predicates.isType 'Integer,
                                              predicates.numbers.minimum 0
                                            ],
                                            predicates.isType '"String"
                                          ],
                                    }
                                    { "^x-" = predicates.always, }
                                    false
                                    predicates.never
                                  ],
                              type = predicates.isType '"String",
                              volume = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    { nocopy = predicates.isType '"Bool", }
                                    { "^x-" = predicates.always, }
                                    false
                                    predicates.never
                                  ],
                            }
                            { "^x-" = predicates.always, }
                            false
                            predicates.never
                          ]
                        ]),
                        predicates.arrays.uniqueItems
                      ],
                  volumes_from = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  working_dir = predicates.isType '"String",
                }
                { "^x-" = predicates.always, }
                false
                predicates.never
              ],
          service_config_or_secret = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.oneOf
                [
                  predicates.isType '"String",
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      gid = predicates.isType '"String",
                      mode = predicates.isType '"Number",
                      source = predicates.isType '"String",
                      target = predicates.isType '"String",
                      uid = predicates.isType '"String",
                    }
                    { "^x-" = predicates.always, }
                    false
                    predicates.never
                  ]
                ])
              ],
          string_or_list = predicates.oneOf
              [
                predicates.isType '"String",
                definitions.predicate.list_of_strings
              ],
          volume = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record
                {
                  driver = predicates.isType '"String",
                  driver_opts = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^.+$" = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  external = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType 'Record
                        ],
                        predicates.records.record
                        { name = predicates.isType '"String", }
                        { "^x-" = predicates.always, }
                        false
                        predicates.never
                      ],
                  labels = definitions.predicate.list_or_dict,
                  name = predicates.isType '"String",
                }
                { "^x-" = predicates.always, }
                false
                predicates.never
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.record
  {
    configs = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          { "^[a-zA-Z0-9._-]+$" = definitions.predicate.config, }
          false
          predicates.never
        ],
    include = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType 'Record, definitions.predicate.include ])
        ],
    name = predicates.allOf
        [
          predicates.isType '"String",
          predicates.strings.pattern "^[a-z0-9][a-z0-9_-]*$"
        ],
    networks = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          { "^[a-zA-Z0-9._-]+$" = definitions.predicate.network, }
          true
          predicates.always
        ],
    secrets = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          { "^[a-zA-Z0-9._-]+$" = definitions.predicate.secret, }
          false
          predicates.never
        ],
    services = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          { "^[a-zA-Z0-9._-]+$" = definitions.predicate.service, }
          false
          predicates.never
        ],
    version = predicates.isType '"String",
    volumes = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          { "^[a-zA-Z0-9._-]+$" = definitions.predicate.volume, }
          false
          predicates.never
        ],
  }
  { "^x-" = predicates.always, }
  false
  predicates.never
])