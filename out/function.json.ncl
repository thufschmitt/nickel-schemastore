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
          bindingBase = predicates.contract_from_predicate
              definitions.predicate.bindingBase,
          blobBinding = predicates.contract_from_predicate
              definitions.predicate.blobBinding,
          documentDBBinding = predicates.contract_from_predicate
              definitions.predicate.documentDBBinding,
          dynamicBinding = predicates.contract_from_predicate
              definitions.predicate.dynamicBinding,
          eventHubBinding = predicates.contract_from_predicate
              definitions.predicate.eventHubBinding,
          httpBinding = predicates.contract_from_predicate
              definitions.predicate.httpBinding,
          httpTrigger = predicates.contract_from_predicate
              definitions.predicate.httpTrigger,
          kustoBinding = predicates.contract_from_predicate
              definitions.predicate.kustoBinding,
          manualTriggerBinding = predicates.contract_from_predicate
              definitions.predicate.manualTriggerBinding,
          mobileBinding = predicates.contract_from_predicate
              definitions.predicate.mobileBinding,
          notificationHubBinding = predicates.contract_from_predicate
              definitions.predicate.notificationHubBinding,
          queueBinding = predicates.contract_from_predicate
              definitions.predicate.queueBinding,
          sendGridBinding = predicates.contract_from_predicate
              definitions.predicate.sendGridBinding,
          serviceBusBinding = predicates.contract_from_predicate
              definitions.predicate.serviceBusBinding,
          sqlBinding = predicates.contract_from_predicate
              definitions.predicate.sqlBinding,
          tableBinding = predicates.contract_from_predicate
              definitions.predicate.tableBinding,
          timerTriggerBinding = predicates.contract_from_predicate
              definitions.predicate.timerTriggerBinding,
          twilioSmsBinding = predicates.contract_from_predicate
              definitions.predicate.twilioSmsBinding,
        },
    predicate = {
          bindingBase = predicates.allOf
              [
                predicates.records.required [ "direction", "name", "type" ],
                predicates.records.record
                {
                  dataType = predicates.enum [ "string", "binary", "stream" ],
                  direction = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "in", "out", "inout" ]
                      ],
                  name = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          blobBinding = predicates.allOf
              [
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    direction = predicates.enum [ "in" ],
                    type = predicates.enum [ "blobTrigger" ],
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  { type = predicates.enum [ "blob" ], }
                  {  }
                  true
                  predicates.always
                ],
                predicates.records.record
                {
                  connection = predicates.isType '"String",
                  path = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          documentDBBinding = predicates.allOf
              [
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    direction = predicates.enum [ "in" ],
                    id = predicates.isType '"String",
                    sqlQuery = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  {
                    createIfNotExists = predicates.isType '"Bool",
                    direction = predicates.enum [ "out" ],
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.records.record
                {
                  collectionName = predicates.isType '"String",
                  connection = predicates.isType '"String",
                  databaseName = predicates.isType '"String",
                  type = predicates.enum [ "documentDB" ],
                }
                {  }
                true
                predicates.always
              ],
          dynamicBinding = predicates.records.record
              {
                direction = predicates.enum [ "in", "out", "inout" ],
                type = predicates.not
                    (predicates.enum
                    [
                      "serviceBusTrigger",
                      "serviceBus",
                      "blobTrigger",
                      "blob",
                      "manualTrigger",
                      "eventHubTrigger",
                      "eventHub",
                      "timerTrigger",
                      "queueTrigger",
                      "queue",
                      "httpTrigger",
                      "http",
                      "mobileTable",
                      "documentDB",
                      "table",
                      "notificationHub",
                      "twilioSms",
                      "sendGrid",
                      "sql",
                      "sqlTrigger",
                      "kusto"
                    ]),
              }
              {  }
              true
              predicates.always,
          eventHubBinding = predicates.allOf
              [
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    cardinality = predicates.enum [ "one", "many" ],
                    consumerGroup = predicates.isType '"String",
                    direction = predicates.enum [ "in" ],
                    type = predicates.enum [ "eventHubTrigger" ],
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  {
                    direction = predicates.enum [ "out" ],
                    type = predicates.enum [ "eventHub" ],
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.records.record
                {
                  connection = predicates.isType '"String",
                  path = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          httpBinding = predicates.oneOf
              [
                predicates.records.record
                {
                  authLevel = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "anonymous", "function", "admin" ]
                      ],
                  direction = predicates.enum [ "in" ],
                  methods = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.items
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "get",
                              "post",
                              "delete",
                              "head",
                              "patch",
                              "put",
                              "options",
                              "trace"
                            ]
                          ]
                        ]
                      ],
                  route = predicates.isType '"String",
                  type = predicates.enum [ "httpTrigger" ],
                  webHookType = predicates.isType '"String",
                }
                {  }
                true
                predicates.always,
                predicates.records.record
                {
                  direction = predicates.enum [ "out" ],
                  type = predicates.enum [ "http" ],
                }
                {  }
                true
                predicates.always
              ],
          httpTrigger = predicates.always,
          kustoBinding = predicates.allOf
              [
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    direction = predicates.enum [ "in" ],
                    kqlCommand = predicates.isType '"String",
                    kqlParameters = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  {
                    dataFormat = predicates.isType '"String",
                    direction = predicates.enum [ "out" ],
                    mappingRef = predicates.isType '"String",
                    tableName = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.records.record
                {
                  connection = predicates.isType '"String",
                  database = predicates.isType '"String",
                  managedServiceIdentity = predicates.isType '"String",
                  type = predicates.enum [ "kusto" ],
                }
                {  }
                true
                predicates.always
              ],
          manualTriggerBinding = predicates.records.record
              {
                direction = predicates.enum [ "in" ],
                type = predicates.enum [ "manualTrigger" ],
              }
              {  }
              true
              predicates.always,
          mobileBinding = predicates.allOf
              [
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    direction = predicates.enum [ "in" ],
                    id = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  { direction = predicates.enum [ "out" ], }
                  {  }
                  true
                  predicates.always
                ],
                predicates.records.record
                {
                  apiKey = predicates.isType '"String",
                  connection = predicates.isType '"String",
                  tableName = predicates.isType '"String",
                  type = predicates.enum [ "mobileTable" ],
                }
                {  }
                true
                predicates.always
              ],
          notificationHubBinding = predicates.records.record
              {
                connection = predicates.isType '"String",
                direction = predicates.enum [ "out" ],
                hubName = predicates.isType '"String",
                platform = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "apns", "adm", "gcm", "wns", "mpns" ]
                    ],
                tagExpression = predicates.isType '"String",
                type = predicates.enum [ "notificationHub" ],
              }
              {  }
              true
              predicates.always,
          queueBinding = predicates.allOf
              [
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    direction = predicates.enum [ "in" ],
                    type = predicates.enum [ "queueTrigger" ],
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  {
                    direction = predicates.enum [ "out" ],
                    type = predicates.enum [ "queue" ],
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.records.record
                {
                  connection = predicates.isType '"String",
                  queueName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          sendGridBinding = predicates.records.record
              {
                apiKey = predicates.isType '"String",
                direction = predicates.enum [ "out" ],
                from = predicates.isType '"String",
                subject = predicates.isType '"String",
                text = predicates.isType '"String",
                to = predicates.isType '"String",
                type = predicates.enum [ "sendGrid" ],
              }
              {  }
              true
              predicates.always,
          serviceBusBinding = predicates.allOf
              [
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    direction = predicates.enum [ "in" ],
                    type = predicates.enum [ "serviceBusTrigger" ],
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  {
                    direction = predicates.enum [ "out" ],
                    type = predicates.enum [ "serviceBus" ],
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.records.record
                {
                  accessRights = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "manage", "listen", "send" ]
                      ],
                  connection = predicates.isType '"String",
                  queueName = predicates.isType '"String",
                  subscriptionName = predicates.isType '"String",
                  topicName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          sqlBinding = predicates.allOf
              [
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    tableName = predicates.isType '"String",
                    type = predicates.enum [ "sqlTrigger" ],
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  {
                    commandText = predicates.isType '"String",
                    commandType = predicates.enum [ "text", "storedProcedure" ],
                    direction = predicates.enum [ "in" ],
                    parameters = predicates.isType '"String",
                    type = predicates.enum [ "sql" ],
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  {
                    commandText = predicates.isType '"String",
                    direction = predicates.const "out",
                    type = predicates.const "sql",
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.records.record
                { connectionStringSetting = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          tableBinding = predicates.allOf
              [
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    direction = predicates.enum [ "in" ],
                    filter = predicates.isType '"String",
                    take = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  { direction = predicates.enum [ "out" ], }
                  {  }
                  true
                  predicates.always
                ],
                predicates.records.record
                {
                  connection = predicates.isType '"String",
                  partitionKey = predicates.isType '"String",
                  rowKey = predicates.isType '"String",
                  tableName = predicates.isType '"String",
                  type = predicates.enum [ "table" ],
                }
                {  }
                true
                predicates.always
              ],
          timerTriggerBinding = predicates.records.record
              {
                direction = predicates.enum [ "in" ],
                runOnStartup = predicates.isType '"Bool",
                schedule = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern
                      "^(\\*|((([1-5]\\d)|\\d)(-(([1-5]\\d)|\\d)(/\\d+)?)?)(,((([1-5]\\d)|\\d)(-(([1-5]\\d)|\\d)(/\\d+)?)?))*)(/\\d+)? (\\*|((([1-5]\\d)|\\d)(-(([1-5]\\d)|\\d)(/\\d+)?)?)(,((([1-5]\\d)|\\d)(-(([1-5]\\d)|\\d)(/\\d+)?)?))*)(/\\d+)? (\\*|(((1\\d)|(2[0-3])|\\d)(-((1\\d)|(2[0-3])|\\d)(/\\d+)?)?)(,(((1\\d)|(2[0-3])|\\d)(-((1\\d)|(2[0-3])|\\d)(/\\d+)?)?))*)(/\\d+)? (\\*|((([1-2]\\d)|(3[0-1])|[1-9])(-(([1-2]\\d)|(3[0-1])|[1-9])(/\\d+)?)?)(,((([1-2]\\d)|(3[0-1])|[1-9])(-(([1-2]\\d)|(3[0-1])|[1-9])(/\\d+)?)?))*)(/\\d+)? (\\*|(([A-Za-z]+|(1[0-2])|[1-9])(-([A-Za-z]+|(1[0-2])|[1-9])(/\\d+)?)?)(,(([A-Za-z]+|(1[0-2])|[1-9])(-([A-Za-z]+|(1[0-2])|[1-9])(/\\d+)?)?))*)(/\\d+)? (\\*|(([A-Za-z]+|[0-6])(-([A-Za-z]+|[0-6])(/\\d+)?)?)(,(([A-Za-z]+|[0-6])(-([A-Za-z]+|[0-6])(/\\d+)?)?))*)(/\\d+)?$"
                    ],
                type = predicates.enum [ "timerTrigger" ],
                useMonitor = predicates.isType '"Bool",
              }
              {  }
              true
              predicates.always,
          twilioSmsBinding = predicates.records.record
              {
                accountSid = predicates.isType '"String",
                authToken = predicates.isType '"String",
                body = predicates.isType '"String",
                direction = predicates.enum [ "out" ],
                from = predicates.isType '"String",
                to = predicates.isType '"String",
                type = predicates.enum [ "twilioSms" ],
              }
              {  }
              true
              predicates.always,
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.record
  {
    bindings = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            definitions.predicate.bindingBase,
            predicates.oneOf
            [
              definitions.predicate.dynamicBinding,
              predicates.oneOf
              [
                definitions.predicate.serviceBusBinding,
                definitions.predicate.blobBinding,
                definitions.predicate.manualTriggerBinding,
                definitions.predicate.eventHubBinding,
                definitions.predicate.timerTriggerBinding,
                definitions.predicate.queueBinding,
                definitions.predicate.httpBinding,
                definitions.predicate.mobileBinding,
                definitions.predicate.documentDBBinding,
                definitions.predicate.tableBinding,
                definitions.predicate.notificationHubBinding,
                definitions.predicate.twilioSmsBinding,
                definitions.predicate.sendGridBinding,
                definitions.predicate.sqlBinding,
                definitions.predicate.kustoBinding
              ]
            ]
          ])
        ],
    configurationSource = predicates.enum [ "attributes", "config" ],
    disabled = predicates.isType '"Bool",
    entryPoint = predicates.isType '"String",
    excluded = predicates.isType '"Bool",
    retry = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            delayInterval = predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                  ],
                  predicates.enum [ null ]
                ],
            maxRetryCount = predicates.isType 'Integer,
            maximumInterval = predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                  ],
                  predicates.enum [ null ]
                ],
            minimumInterval = predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                  ],
                  predicates.enum [ null ]
                ],
            strategy = predicates.enum [ "exponentialBackoff", "fixedDelay" ],
          }
          {  }
          true
          predicates.always
        ],
    scriptFile = predicates.isType '"String",
  }
  {  }
  true
  predicates.always
])