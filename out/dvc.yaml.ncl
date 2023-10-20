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
          CustomParamFileKeys = predicates.contract_from_predicate
              definitions.predicate.CustomParamFileKeys,
          DepModel
            | doc m%"
            Path to a dependency (input) file or directory for the stage.
            "%
            = String,
          Dependencies = predicates.contract_from_predicate
              definitions.predicate.Dependencies,
          EmptyParamFileKeys = predicates.contract_from_predicate
              definitions.predicate.EmptyParamFileKeys,
          EmptyTopLevelPlotFlags = predicates.contract_from_predicate
              (predicates.isType 'Null),
          ForeachDo = {
                do
                  | predicates.contract_from_predicate
                  definitions.predicate.Stage
                  | doc m%"
                  Parametrized stage definition that'll be substituted over for each of the value from the foreach data.
                  "%,
                foreach
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern "^\\${.*?}$"
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf predicates.always
                    ],
                    predicates.isType 'Record
                  ])
                  | doc m%"
                  Iterable to loop through in foreach. Can be a parametrized string, list or a dict.
                  
                  The stages will be generated by iterating through this data, by substituting data in the `do` block.
                  "%,
              },
          Matrix
            | doc m%"
            A named stage of a pipeline.
            "%
            = {
                always_changed
                  | Bool
                  | doc m%"
                  Assume stage as always changed
                  "%
                  | optional,
                cmd
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
                  (Required) Command to run (anything your system terminal can run).
                  
                  Can be a string or a list of commands.
                  "%,
                deps
                  | predicates.contract_from_predicate
                  definitions.predicate.Dependencies
                  | doc m%"
                  List of the dependencies for the stage.
                  "%
                  | optional,
                desc
                  | String
                  | doc m%"
                  Description of the stage
                  "%
                  | optional,
                frozen
                  | Bool
                  | doc m%"
                  Assume stage as unchanged
                  "%
                  | optional,
                matrix
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.oneOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf predicates.always
                      ],
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^\\${.*?}$"
                      ]
                    ])
                  ])
                  | doc m%"
                  Generate stages based on combination of variables.
                  
                  The variable can be a list of values, or a parametrized string referencing a list.
                  "%,
                meta
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  Additional information/metadata
                  "%
                  | optional,
                metrics
                  | predicates.contract_from_predicate
                  definitions.predicate.Outs
                  | doc m%"
                  List of metrics of the stage written to JSON/TOML/YAML.
                  "%
                  | optional,
                outs
                  | predicates.contract_from_predicate
                  definitions.predicate.Outs
                  | doc m%"
                  List of the outputs of the stage.
                  "%
                  | optional,
                params
                  | predicates.contract_from_predicate
                  definitions.predicate.Params
                  | doc m%"
                  List of dot-separated parameter dependency keys to track from `params.yaml`.
                  
                  May contain other YAML/JSON/TOML/Python parameter file names, with a sub-list of the param names to track in them (leave empty to include all).
                  "%
                  | optional,
                plots
                  | predicates.contract_from_predicate
                  definitions.predicate.Plots
                  | doc m%"
                  List of plots of the stage for visualization.
                  
                  Plots may be written to JSON/YAML/CSV/TSV for data or JPEG/GIF/PNG for images.
                  "%
                  | optional,
                vars
                  | predicates.contract_from_predicate
                  definitions.predicate.Vars
                  | doc m%"
                  List of stage-specific values for substitution.
                  
                  May include any dict or a path to a params file.
                  
                  Use in the stage with the `${}` substitution expression.
                  "%
                  | optional,
                wdir
                  | String
                  | doc m%"
                  Working directory for the cmd, relative to `dvc.yaml`
                  "%
                  | optional,
              },
          Out
            | doc m%"
            Path to an output file or dir of the stage.
            "%
            = predicates.contract_from_predicate definitions.predicate.Out,
          OutFlags = {
                cache
                  | Bool
                  | doc m%"
                  Cache output by DVC
                  "%
                  | optional,
                checkpoint
                  | Bool
                  | doc m%"
                  Indicate that the output is associated with in-code checkpoints
                  "%
                  | optional,
                desc
                  | String
                  | doc m%"
                  User description for the output
                  "%
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  User assigned labels of the output
                  "%
                  | optional,
                meta
                  | {  .. }
                  | doc m%"
                  Custom metadata of the output.
                  "%
                  | optional,
                persist
                  | Bool
                  | doc m%"
                  Persist output between runs
                  "%
                  | optional,
                push
                  | Bool
                  | doc m%"
                  Whether the output should be pushed to remote during `dvc push`
                  "%
                  | optional,
                remote
                  | String
                  | doc m%"
                  Name of the remote to use for pushing/fetching
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  User assigned type of the output
                  "%
                  | optional,
              },
          Outs = predicates.contract_from_predicate definitions.predicate.Outs,
          Param = predicates.contract_from_predicate
              definitions.predicate.Param,
          ParamKey = predicates.contract_from_predicate
              definitions.predicate.ParamKey,
          Params = predicates.contract_from_predicate
              definitions.predicate.Params,
          Plot
            | doc m%"
            Path to plots file or dir of the stage.
            
            Data files may be JSON/YAML/CSV/TSV.
            
            Image files may be JPEG/GIF/PNG.
            "%
            = predicates.contract_from_predicate definitions.predicate.Plot,
          PlotFlags = {
                cache
                  | Bool
                  | doc m%"
                  Cache output by DVC
                  "%
                  | optional,
                checkpoint
                  | Bool
                  | doc m%"
                  Indicate that the output is associated with in-code checkpoints
                  "%
                  | optional,
                desc
                  | String
                  | doc m%"
                  User description for the output
                  "%
                  | optional,
                header
                  | Bool
                  | doc m%"
                  Whether the target CSV or TSV has a header or not
                  "%
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  User assigned labels of the output
                  "%
                  | optional,
                meta
                  | {  .. }
                  | doc m%"
                  Custom metadata of the output.
                  "%
                  | optional,
                persist
                  | Bool
                  | doc m%"
                  Persist output between runs
                  "%
                  | optional,
                push
                  | Bool
                  | doc m%"
                  Whether the output should be pushed to remote during `dvc push`
                  "%
                  | optional,
                remote
                  | String
                  | doc m%"
                  Name of the remote to use for pushing/fetching
                  "%
                  | optional,
                template
                  | String
                  | doc m%"
                  Default plot template
                  "%
                  | optional,
                title
                  | String
                  | doc m%"
                  Default plot title
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  User assigned type of the output
                  "%
                  | optional,
                x
                  | String
                  | doc m%"
                  Default field name to use as x-axis data
                  "%
                  | optional,
                x_label
                  | String
                  | doc m%"
                  Default label for the x-axis
                  "%
                  | optional,
                y
                  | String
                  | doc m%"
                  Default field name to use as y-axis data
                  "%
                  | optional,
                y_label
                  | String
                  | doc m%"
                  Default label for the y-axis
                  "%
                  | optional,
              },
          Plots = predicates.contract_from_predicate
              definitions.predicate.Plots,
          Stage
            | doc m%"
            A named stage of a pipeline.
            "%
            = {
                always_changed
                  | Bool
                  | doc m%"
                  Assume stage as always changed
                  "%
                  | optional,
                cmd
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
                  (Required) Command to run (anything your system terminal can run).
                  
                  Can be a string or a list of commands.
                  "%,
                deps
                  | predicates.contract_from_predicate
                  definitions.predicate.Dependencies
                  | doc m%"
                  List of the dependencies for the stage.
                  "%
                  | optional,
                desc
                  | String
                  | doc m%"
                  Description of the stage
                  "%
                  | optional,
                frozen
                  | Bool
                  | doc m%"
                  Assume stage as unchanged
                  "%
                  | optional,
                meta
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  Additional information/metadata
                  "%
                  | optional,
                metrics
                  | predicates.contract_from_predicate
                  definitions.predicate.Outs
                  | doc m%"
                  List of metrics of the stage written to JSON/TOML/YAML.
                  "%
                  | optional,
                outs
                  | predicates.contract_from_predicate
                  definitions.predicate.Outs
                  | doc m%"
                  List of the outputs of the stage.
                  "%
                  | optional,
                params
                  | predicates.contract_from_predicate
                  definitions.predicate.Params
                  | doc m%"
                  List of dot-separated parameter dependency keys to track from `params.yaml`.
                  
                  May contain other YAML/JSON/TOML/Python parameter file names, with a sub-list of the param names to track in them (leave empty to include all).
                  "%
                  | optional,
                plots
                  | predicates.contract_from_predicate
                  definitions.predicate.Plots
                  | doc m%"
                  List of plots of the stage for visualization.
                  
                  Plots may be written to JSON/YAML/CSV/TSV for data or JPEG/GIF/PNG for images.
                  "%
                  | optional,
                vars
                  | predicates.contract_from_predicate
                  definitions.predicate.Vars
                  | doc m%"
                  List of stage-specific values for substitution.
                  
                  May include any dict or a path to a params file.
                  
                  Use in the stage with the `${}` substitution expression.
                  "%
                  | optional,
                wdir
                  | String
                  | doc m%"
                  Working directory for the cmd, relative to `dvc.yaml`
                  "%
                  | optional,
              },
          TopLevelArtifactFlags = {
                desc
                  | String
                  | doc m%"
                  Description for the artifact
                  "%
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Labels for the artifact
                  "%
                  | optional,
                meta
                  | {  .. }
                  | doc m%"
                  Custom metadata for the artifact
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Path to the artifact
                  "%,
                type
                  | String
                  | doc m%"
                  Type of the artifact
                  "%
                  | optional,
              },
          TopLevelArtifacts = predicates.contract_from_predicate
              definitions.predicate.TopLevelArtifacts,
          TopLevelPlotFlags = {
                template
                  | String
                  | doc m%"
                  Default plot template
                  "%
                  | optional,
                title
                  | String
                  | doc m%"
                  Default plot title
                  "%
                  | optional,
                x
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", definitions.predicate.X ])
                  | doc m%"
                  A single column name, or a dictionary of data-source and column pair
                  "%
                  | optional,
                x_label
                  | String
                  | doc m%"
                  Default label for the x-axis
                  "%
                  | optional,
                y
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.uniqueItems
                    ],
                    definitions.predicate.Y
                  ])
                  | doc m%"
                  A single column name, list of columns, or a dictionary of data-source and column pair
                  "%
                  | optional,
                y_label
                  | String
                  | doc m%"
                  Default label for the y-axis
                  "%
                  | optional,
              },
          TopLevelPlots = predicates.contract_from_predicate
              definitions.predicate.TopLevelPlots,
          TopLevelPlotsList = predicates.contract_from_predicate
              definitions.predicate.TopLevelPlotsList,
          VarDecl
            | doc m%"
            Dict of values for substitution.
            "%
            = {  .. },
          VarPath
            | doc m%"
            Path to params file with values for substitution.
            "%
            = String,
          Vars = predicates.contract_from_predicate definitions.predicate.Vars,
          X = predicates.contract_from_predicate definitions.predicate.X,
          Y = predicates.contract_from_predicate definitions.predicate.Y,
        },
    predicate = {
          CustomParamFileKeys = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.ParamKey,
                  predicates.arrays.uniqueItems
                ])
              ],
          DepModel
            | doc m%"
            Path to a dependency (input) file or directory for the stage.
            "%
            = predicates.isType '"String",
          Dependencies = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.DepModel,
                predicates.arrays.uniqueItems
              ],
          EmptyParamFileKeys = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType 'Null)
              ],
          EmptyTopLevelPlotFlags = predicates.isType 'Null,
          ForeachDo = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "do", "foreach" ],
                predicates.records.record
                {
                  do = definitions.predicate.Stage,
                  foreach = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^\\${.*?}$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf predicates.always
                        ],
                        predicates.isType 'Record
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Matrix
            | doc m%"
            A named stage of a pipeline.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "cmd", "matrix" ],
                predicates.records.record
                {
                  always_changed = predicates.isType '"Bool",
                  cmd = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  deps = definitions.predicate.Dependencies,
                  desc = predicates.isType '"String",
                  frozen = predicates.isType '"Bool",
                  matrix = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf predicates.always
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "^\\${.*?}$"
                          ]
                        ])
                      ],
                  meta = predicates.always,
                  metrics = definitions.predicate.Outs,
                  outs = definitions.predicate.Outs,
                  params = definitions.predicate.Params,
                  plots = definitions.predicate.Plots,
                  vars = definitions.predicate.Vars,
                  wdir = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Out
            | doc m%"
            Path to an output file or dir of the stage.
            "%
            = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true
                  definitions.predicate.OutFlags
                ]
              ],
          OutFlags = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cache = predicates.isType '"Bool",
                  checkpoint = predicates.isType '"Bool",
                  desc = predicates.isType '"String",
                  labels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  meta = predicates.isType 'Record,
                  persist = predicates.isType '"Bool",
                  push = predicates.isType '"Bool",
                  remote = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Outs = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.Out,
                predicates.arrays.uniqueItems
              ],
          Param = predicates.oneOf
              [
                definitions.predicate.ParamKey,
                definitions.predicate.CustomParamFileKeys,
                definitions.predicate.EmptyParamFileKeys
              ],
          ParamKey = predicates.isType '"String",
          Params = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.Param,
                predicates.arrays.uniqueItems
              ],
          Plot
            | doc m%"
            Path to plots file or dir of the stage.
            
            Data files may be JSON/YAML/CSV/TSV.
            
            Image files may be JPEG/GIF/PNG.
            "%
            = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true
                  definitions.predicate.PlotFlags
                ]
              ],
          PlotFlags = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cache = predicates.isType '"Bool",
                  checkpoint = predicates.isType '"Bool",
                  desc = predicates.isType '"String",
                  header = predicates.isType '"Bool",
                  labels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  meta = predicates.isType 'Record,
                  persist = predicates.isType '"Bool",
                  push = predicates.isType '"Bool",
                  remote = predicates.isType '"String",
                  template = predicates.isType '"String",
                  title = predicates.isType '"String",
                  type = predicates.isType '"String",
                  x = predicates.isType '"String",
                  x_label = predicates.isType '"String",
                  y = predicates.isType '"String",
                  y_label = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Plots = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.Plot,
                predicates.arrays.uniqueItems
              ],
          Stage
            | doc m%"
            A named stage of a pipeline.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "cmd" ],
                predicates.records.record
                {
                  always_changed = predicates.isType '"Bool",
                  cmd = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  deps = definitions.predicate.Dependencies,
                  desc = predicates.isType '"String",
                  frozen = predicates.isType '"Bool",
                  meta = predicates.always,
                  metrics = definitions.predicate.Outs,
                  outs = definitions.predicate.Outs,
                  params = definitions.predicate.Params,
                  plots = definitions.predicate.Plots,
                  vars = definitions.predicate.Vars,
                  wdir = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          TopLevelArtifactFlags = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  desc = predicates.isType '"String",
                  labels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  meta = predicates.isType 'Record,
                  path = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          TopLevelArtifacts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-z0-9]([a-z0-9-/]*[a-z0-9])?$" =
                    definitions.predicate.TopLevelArtifactFlags,
                }
                true
                definitions.predicate.TopLevelArtifactFlags
              ],
          TopLevelPlotFlags = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  template = predicates.isType '"String",
                  title = predicates.isType '"String",
                  x = predicates.oneOf
                      [ predicates.isType '"String", definitions.predicate.X ],
                  x_label = predicates.isType '"String",
                  y = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.uniqueItems
                        ],
                        definitions.predicate.Y
                      ],
                  y_label = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          TopLevelPlots = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.oneOf
                [
                  definitions.predicate.TopLevelPlotFlags,
                  definitions.predicate.EmptyTopLevelPlotFlags
                ])
              ],
          TopLevelPlotsList = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.oneOf
                [
                  predicates.isType '"String",
                  definitions.predicate.TopLevelPlots
                ])
              ],
          VarDecl
            | doc m%"
            Dict of values for substitution.
            "%
            = predicates.isType 'Record,
          VarPath
            | doc m%"
            Path to params file with values for substitution.
            "%
            = predicates.isType '"String",
          Vars = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.oneOf
                [
                  definitions.predicate.VarPath,
                  definitions.predicate.VarDecl
                ])
              ],
          X = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          Y = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.oneOf
                [
                  predicates.isType '"String",
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ]
                ])
              ],
        },
  }
in

{
  artifacts
    | predicates.contract_from_predicate definitions.predicate.TopLevelArtifacts
    | doc m%"
    Top level artifacts definition.
    "%
    | optional,
  metrics
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String"),
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    List of metric files
    "%
    | optional,
  params
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String"),
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    List of parameter files
    "%
    | optional,
  plots
    | predicates.contract_from_predicate
    (predicates.oneOf
    [
      definitions.predicate.TopLevelPlots,
      definitions.predicate.TopLevelPlotsList
    ])
    | doc m%"
    Top level plots definition.
    "%
    | optional,
  stages
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.oneOf
      [
        definitions.predicate.ForeachDo,
        definitions.predicate.Matrix,
        definitions.predicate.Stage
      ])
    ])
    | doc m%"
    List of stages that form a pipeline.
    "%
    | optional,
  vars
    | predicates.contract_from_predicate definitions.predicate.Vars
    | doc m%"
    List of values for substitution.
    
    May include any dict or a path to a params file which may be a string or a dict to params in the file).
    
    Use elsewhere in `dvc.yaml` with the `${}` substitution expression.
    "%
    | optional,
}