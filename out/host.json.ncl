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
          aggregator
            | doc m%"
            Configuration settings for the function result aggregator.
            "%
            = {
                batchSize
                  | std.number.Integer
                  | doc m%"
                  The maximum batch size for aggregations. If this value is reached before the 'flushTimeout', all values will be flushed.
                  "%
                  | optional,
                flushTimeout
                  | predicates.contract_from_predicate
                  (predicates.strings.pattern
                  "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")
                  | doc m%"
                  The aggregation duration. The aggregator will flush periodically based on this value.
                  "%
                  | optional,
              },
          cosmosDB-extension
            | doc m%"
            Configuration settings for Azure Cosmos DB bindings and triggers.
            "%
            = {
                connectionMode
                  | predicates.contract_from_predicate
                  (predicates.enum [ "Gateway", "Direct" ])
                  | doc m%"
                  ConnectionMode to be used on the DocumentClients.
                  "%
                  | optional,
                protocol
                  | predicates.contract_from_predicate
                  (predicates.enum [ "Https", "Tcp" ])
                  | doc m%"
                  Protocol to be used on the DocumentClients.
                  "%
                  | optional,
              },
          cosmosDB-extension-v2
            | doc m%"
            Configuration settings for Azure Cosmos DB bindings and triggers.
            "%
            = {
                connectionMode
                  | predicates.contract_from_predicate
                  (predicates.enum [ "Gateway", "Direct" ])
                  | doc m%"
                  ConnectionMode to be used on the DocumentClients.
                  "%
                  | optional,
                leaseOptions
                  | {
                    leasePrefix
                      | String
                      | doc m%"
                      Lease prefix to use across all functions in an app.
                      "%
                      | optional,
                  }
                  | optional,
                protocol
                  | predicates.contract_from_predicate
                  (predicates.enum [ "Https", "Tcp" ])
                  | doc m%"
                  Protocol to be used on the DocumentClients.
                  "%
                  | optional,
              },
          durableTask-extension
            | doc m%"
            Configuration settings for 'orchestration'/'activity' triggers.
            "%
            = {
                extendedSessionIdleTimeoutInSeconds
                  | std.number.Integer
                  | optional,
                extendedSessionsEnabled | Bool | optional,
                hubName
                  | String
                  | doc m%"
                  Alternate task hub names can be used to isolate multiple Durable Functions applications from each other, even if they're using the same storage backend.
                  "%
                  | optional,
                maxConcurrentActivityFunctions
                  | std.number.Integer
                  | doc m%"
                  The maximum number of activity functions that can be processed concurrently on a single host instance.
                  "%
                  | optional,
                maxConcurrentOrchestratorFunctions
                  | std.number.Integer
                  | doc m%"
                  The maximum number of orchestrator functions that can be processed concurrently on a single host instance.
                  "%
                  | optional,
                maxEntityOperationBatchSize
                  | std.number.Integer
                  | doc m%"
                  The maximum number of entity operations that are processed as a batch. If set to 1, batching is disabled, and each operation message is processed by a separate function invocation.
                  "%
                  | optional,
                notifications
                  | {
                    eventGrid
                      | {
                        keySettingName
                          | String
                          | doc m%"
                          The name of the app setting containing the key used for authenticating with the Azure Event Grid custom topic at EventGridTopicEndpoint.
                          "%
                          | optional,
                        publishEventTypes
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum
                              [
                                "Started",
                                "Pending",
                                "Completed",
                                "Failed",
                                "Terminated"
                              ]
                            ]),
                            predicates.arrays.uniqueItems
                          ])
                          | doc m%"
                          A list of event types to publish to Event Grid. If not specified, all event types will be published.
                          "%
                          | optional,
                        publishRetryCount
                          | std.number.Integer
                          | doc m%"
                          The number of times to retry if publishing to the Event Grid Topic fails.
                          "%
                          | optional,
                        publishRetryInterval
                          | String
                          | doc m%"
                          The Event Grid publishes retry interval in the hh:mm:ss format.
                          "%
                          | optional,
                        topicEndpoint
                          | String
                          | doc m%"
                          The URL of an Azure Event Grid custom topic endpoint. When this property is set, orchestration life-cycle notification events are published to this endpoint. This property supports App Settings resolution.
                          "%
                          | optional,
                      }
                      | optional,
                  }
                  | optional,
                storageProvider
                  | {
                    connectionStringName | String | optional,
                    controlQueueBatchSize
                      | std.number.Integer
                      | doc m%"
                      The number of messages to pull from the control queue at a time.
                      "%
                      | optional,
                    controlQueueBufferThreshold
                      | std.number.Integer
                      | doc m%"
                      The number of control queue messages that can be buffered in memory at a time, at which point the dispatcher will wait before dequeuing any additional messages.
                      "%
                      | optional,
                    controlQueueVisibilityTimeout
                      | String
                      | doc m%"
                      The visibility timeout of dequeued control queue messages.
                      "%
                      | optional,
                    maxQueuePollingInterval
                      | String
                      | doc m%"
                      The maximum control and work-item queue polling interval in the hh:mm:ss format. Higher values can result in higher message processing latencies. Lower values can result in higher storage costs because of increased storage transactions.
                      "%
                      | optional,
                    partitionCount
                      | std.number.Integer
                      | doc m%"
                      The partition count for the control queue. May be a positive integer between 1 and 16.
                      "%
                      | optional,
                    trackingStoreConnectionStringName
                      | String
                      | doc m%"
                      The name of a connection string to use for the History and Instances tables. If not specified, the azureStorageConnectionStringName connection is used.
                      "%
                      | optional,
                    trackingStoreNamePrefix
                      | String
                      | doc m%"
                      The prefix to use for the History and Instances tables when trackingStoreConnectionStringName is specified. If not set, the default prefix value will be DurableTask. If trackingStoreConnectionStringName is not specified, then the History and Instances tables will use the hubName value as their prefix, and any setting for trackingStoreNamePrefix will be ignored.
                      "%
                      | optional,
                    useLegacyPartitionManagement
                      | Bool
                      | doc m%"
                      When set to false, uses a partition management algorithm that reduces the possibility of duplicate function execution when scaling out.
                      "%
                      | optional,
                    workItemQueueVisibilityTimeout
                      | String
                      | doc m%"
                      The visibility timeout of dequeued work item queue messages.
                      "%
                      | optional,
                  }
                  | optional,
                tracing
                  | {
                    traceInputsAndOutputs
                      | Bool
                      | doc m%"
                      A value indicating whether to trace the inputs and outputs of function calls. The default behavior when tracing function execution events is to include the number of bytes in the serialized inputs and outputs for function calls. This behavior provides minimal information about what the inputs and outputs look like without bloating the logs or inadvertently exposing sensitive information. Setting this property to true causes the default function logging to log the entire contents of function inputs and outputs.
                      "%
                      | optional,
                    traceReplayEvents
                      | Bool
                      | doc m%"
                      A value indicating whether to write orchestration replay events to Application Insights.
                      "%
                      | optional,
                  }
                  | optional,
                useAppLease
                  | Bool
                  | doc m%"
                  When set to true, apps will require acquiring an app-level blob lease before processing task hub messages.
                  "%
                  | optional,
                useGracefulShutdown
                  | Bool
                  | doc m%"
                  Enable gracefully shutting down to reduce the chance of host shutdowns failing in-process function executions.
                  "%
                  | optional,
                useTablePartitionManagement | Bool | optional,
              },
          functionTimeout
            | doc m%"
            Value indicating the timeout duration for all functions.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.functionTimeout,
          functions
            | doc m%"
            The list of functions the host should load.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.functions,
          healthMonitor
            | doc m%"
            Configuration settings for the Functions host health monitor
            "%
            = {
                counterThreshold
                  | Number
                  | doc m%"
                  The threshold at which a performance counter will be considered unhealthy.
                  "%
                  | optional,
                enabled
                  | Bool
                  | doc m%"
                  Specifies whether the feature is enabled.
                  "%
                  | optional,
                healthCheckInterval
                  | predicates.contract_from_predicate
                  (predicates.strings.pattern
                  "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")
                  | doc m%"
                  The time interval between the periodic background health checks
                  "%
                  | optional,
                healthCheckThreshold
                  | std.number.Integer
                  | doc m%"
                  Maximum number of times the health check can fail before a host recycle is initiated.
                  "%
                  | optional,
                healthCheckWindow
                  | predicates.contract_from_predicate
                  (predicates.strings.pattern
                  "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")
                  | doc m%"
                  A sliding time window used in conjunction with the healthCheckThreshold setting.
                  "%
                  | optional,
              },
          http-extension
            | doc m%"
            Configuration settings for 'http' triggers.
            "%
            = {
                customHeaders
                  | {  .. }
                  | doc m%"
                  Allows you to set custom headers in the HTTP response, ex. X-Content-Type-Options.
                  "%
                  | optional,
                dynamicThrottlesEnabled
                  | Bool
                  | doc m%"
                  Indicates whether dynamic host counter checks should be enabled.
                  "%
                  | optional,
                hsts
                  | {
                    excludedHosts
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      Defines the list of host names that will not add the HSTS header.
                      "%
                      | optional,
                    includeSubDomains
                      | Bool
                      | doc m%"
                      Indicates whether the includeSubDomain parameter of the Strict-Transport-Security header should be enabled.
                      "%
                      | optional,
                    isEnabled
                      | Bool
                      | doc m%"
                      Indicates whether the hsts configuration should be applied
                      "%
                      | optional,
                    maxAge
                      | String
                      | doc m%"
                      Defines the max-age parameter of the Strict-Transport-Security header.
                      "%
                      | optional,
                    preload
                      | Bool
                      | doc m%"
                      Indicates whether the preload parameter of the Strict-Transport-Security header should be enabled.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Configuration settings for Strict-Transport-Security
                  "%
                  | optional,
                maxConcurrentRequests
                  | std.number.Integer
                  | doc m%"
                  Defines the the maximum number of http functions that will execute in parallel.
                  "%
                  | optional,
                maxOutstandingRequests
                  | std.number.Integer
                  | doc m%"
                  Defines the maximum number of outstanding requests that will be held at any given time.
                  "%
                  | optional,
                routePrefix
                  | String
                  | doc m%"
                  Defines the default route prefix that applies to all routes. Use an empty string to remove the prefix.
                  "%,
              },
          queues-extension
            | doc m%"
            Configuration settings for 'queue' triggers.
            "%
            = {
                batchSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 32,
                    predicates.numbers.minimum 1
                  ])
                  | doc m%"
                  The number of queue messages to retrieve and process in parallel (per job function).
                  "%
                  | optional,
                maxDequeueCount
                  | std.number.Integer
                  | doc m%"
                  The number of times to try processing a message before moving it to the poison queue
                  "%
                  | optional,
                maxPollingInterval
                  | std.number.Integer
                  | doc m%"
                  The maximum interval in milliseconds between queue polls.
                  "%
                  | optional,
                newBatchThreshold
                  | std.number.Integer
                  | doc m%"
                  The threshold at which a new batch of messages will be fetched. The default is batchSize/2.
                  "%
                  | optional,
                visibilityTimeout
                  | predicates.contract_from_predicate
                  (predicates.strings.pattern
                  "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")
                  | doc m%"
                  The visibility timeout that will be applied to messages that fail processing.
                  "%
                  | optional,
              },
          queues-extension-v2
            | doc m%"
            Configuration settings for 'queue' triggers.
            "%
            = {
                batchSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 32,
                    predicates.numbers.minimum 1
                  ])
                  | doc m%"
                  The number of queue messages that the Functions runtime retrieves simultaneously and processes in parallel. When the number being processed gets down to the `newBatchThreshold`, the runtime gets another batch and starts processing those messages. So the maximum number of concurrent messages being processed per function is `batchSize` plus `newBatchThreshold`. This limit applies separately to each queue-triggered function. 
                  "%
                  | optional,
                maxDequeueCount
                  | std.number.Integer
                  | doc m%"
                  The number of times to try processing a message before moving it to the poison queue
                  "%
                  | optional,
                maxPollingInterval
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9][0-9]:[0-9][0-9]:[0-9][0-9](?:\\.[0-9]+)?$"
                  ])
                  | doc m%"
                  The maximum interval between queue polls. Minimum is 00:00:00.100 (100 ms).
                  "%
                  | optional,
                messageEncoding
                  | std.enum.TagOrString
                  | [| 'none, 'base64 |]
                  | doc m%"
                  This setting is only available in extension version 5.0.0 and higher. It represents the encoding format for messages.
                  "%
                  | optional,
                newBatchThreshold
                  | std.number.Integer
                  | doc m%"
                  The threshold at which a new batch of messages will be fetched. The default is batchSize/2.
                  "%
                  | optional,
                visibilityTimeout
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9][0-9]:[0-9][0-9]:[0-9][0-9](?:\\.[0-9]+)?$"
                  ])
                  | doc m%"
                  The time interval between retries when processing of a message fails.
                  "%
                  | optional,
              },
          singleton
            | doc m%"
            Configuration settings for Singleton lock behavior.
            "%
            = {
                listenerLockPeriod
                  | predicates.contract_from_predicate
                  (predicates.strings.pattern
                  "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")
                  | doc m%"
                  The period that listener locks are taken for.
                  "%
                  | optional,
                listenerLockRecoveryPollingInterval
                  | predicates.contract_from_predicate
                  (predicates.strings.pattern
                  "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")
                  | doc m%"
                  The time interval used for listener lock recovery if a listener lock couldn't be acquired on startup.
                  "%
                  | optional,
                lockAcquisitionPollingInterval
                  | predicates.contract_from_predicate
                  (predicates.strings.pattern
                  "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")
                  | doc m%"
                  The interval between lock acquisition attempts.
                  "%
                  | optional,
                lockAcquisitionTimeout
                  | predicates.contract_from_predicate
                  (predicates.strings.pattern
                  "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")
                  | doc m%"
                  The maximum amount of time the runtime will try to acquire a lock.
                  "%
                  | optional,
                lockPeriod
                  | predicates.contract_from_predicate
                  (predicates.strings.pattern
                  "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")
                  | doc m%"
                  The period that function level locks are taken for (they will auto renew).
                  "%
                  | optional,
              },
          version-1 = {
                aggregator | definitions.contract.aggregator | optional,
                applicationInsights
                  | {
                    sampling
                      | {
                        isEnabled
                          | Bool
                          | doc m%"
                          If true, client-side adaptive sampling is enabled.
                          "%
                          | optional,
                        maxTelemetryItemsPerSecond
                          | std.number.Integer
                          | doc m%"
                          The target rate that the adaptive algorithm aims for on each instance
                          "%
                          | optional,
                        ..
                      }
                      | doc m%"
                      Configuration settings for Application Insights client-side adaptive sampling.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Configuration settings for Application Insights logging.
                  "%
                  | optional,
                documentDB | definitions.contract.cosmosDB-extension | optional,
                durableTask
                  | definitions.contract.durableTask-extension
                  | optional,
                eventHub
                  | {
                    batchCheckpointFrequency
                      | std.number.Integer
                      | doc m%"
                      The number of batches to process before creating an EventHub cursor checkpoint
                      "%
                      | optional,
                    maxBatchSize
                      | std.number.Integer
                      | doc m%"
                      The maximum event count received per receive loop.
                      "%
                      | optional,
                    prefetchCount
                      | std.number.Integer
                      | doc m%"
                      The default PrefetchCount that will be used by the underlying EventProcessorHost.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Configuration settings for 'eventHub' triggers.
                  "%
                  | optional,
                functionTimeout
                  | definitions.contract.functionTimeout
                  | optional,
                functions | definitions.contract.functions | optional,
                healthMonitor | definitions.contract.healthMonitor | optional,
                http | definitions.contract.http-extension | optional,
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The unique ID for this job host. Can be a lower case GUID with dashes removed
                  "%
                  | optional,
                logger
                  | {
                    categoryLevels
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.enum
                        [
                          "Critical",
                          "Debug",
                          "Error",
                          "Information",
                          "None",
                          "Trace",
                          "Warning"
                        ])
                      ])
                      | doc m%"
                      Log levels for specific categories.
                      "%
                      | optional,
                    defaultLevel
                      | predicates.contract_from_predicate
                      (predicates.enum
                      [
                        "Critical",
                        "Debug",
                        "Error",
                        "Information",
                        "None",
                        "Trace",
                        "Warning"
                      ])
                      | doc m%"
                      The default level for logging. If a category level is not specified, this value is used.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Configuration settings for logging.
                  "%
                  | optional,
                queues | definitions.contract.queues-extension | optional,
                serviceBus
                  | {
                    autoComplete
                      | Bool
                      | doc m%"
                      Specifies whether messages should be automatically completed after successful processing.
                      "%
                      | optional,
                    autoRenewTimeout
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                      ])
                      | doc m%"
                      The maximum duration within which the Service Bus message lock will be renewed automatically.
                      "%
                      | optional,
                    maxConcurrentCalls
                      | std.number.Integer
                      | doc m%"
                      The maximum number of concurrent calls to the callback the message pump should initiate.
                      "%
                      | optional,
                    prefetchCount
                      | std.number.Integer
                      | doc m%"
                      The default PrefetchCount that will be used by the underlying MessageReceiver.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Configuration settings for 'serviceBus' triggers.
                  "%
                  | optional,
                singleton | definitions.contract.singleton | optional,
                tracing
                  | {
                    consoleLevel
                      | predicates.contract_from_predicate
                      (predicates.enum
                      [ "off", "error", "warning", "info", "verbose" ])
                      | doc m%"
                      The tracing level used for console logging.
                      "%
                      | optional,
                    fileLoggingMode
                      | predicates.contract_from_predicate
                      (predicates.enum [ "never", "always", "debugOnly" ])
                      | doc m%"
                      Value determining what level of file logging is enabled.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Configuration settings for logging/tracing behavior.
                  "%
                  | optional,
                watchDirectories
                  | definitions.contract.watchDirectories
                  | optional,
              },
          version-2 = {
                aggregator | definitions.contract.aggregator | optional,
                concurrency
                  | {
                    dynamicConcurrencyEnabled
                      | Bool
                      | doc m%"
                      Enables or disables dynamic concurrency for function apps.
                      "%
                      | optional,
                    snapshotPersistenceEnabled
                      | Bool
                      | doc m%"
                      Enables or disables the learned concurrency values persisting in storage.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Configuration settings for dynamic concurrency
                  "%
                  | optional,
                customHandler
                  | {
                    description
                      | {
                        arguments
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ])
                          | doc m%"
                          Arguments to be passed to the Custom Handler process. Can use environment variables following pattern %envVarName%
                          "%
                          | optional,
                        defaultExecutablePath
                          | String
                          | doc m%"
                          Name or path to the Custom Handler process
                          "%
                          | optional,
                        workingDirectory
                          | String
                          | doc m%"
                          WorkingDirectory to be used by the Custom Handler process. If not set, defaults to function app root folder.
                          "%
                          | optional,
                        ..
                      }
                      | doc m%"
                      Configuration settings for Custom Handler process
                      "%
                      | optional,
                    enableForwardingHttpRequest
                      | Bool
                      | doc m%"
                      Forward HttpTrigger request to the custom handler
                      "%
                      | optional,
                  }
                  | doc m%"
                  Configuration settings for Custom Handler.
                  "%
                  | optional,
                extensionBundle
                  | {
                    id
                      | String
                      | doc m%"
                      The id of the extension bundle
                      "%
                      | optional,
                    version
                      | String
                      | doc m%"
                      The version of the extension bundle.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Configuration settings for extension bundle
                  "%
                  | optional,
                extensions
                  | {
                    blobs
                      | {
                        maxDegreeOfParallelism
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.isType 'Integer,
                            predicates.numbers.minimum 1
                          ])
                          | doc m%"
                          The number of concurrent invocations allowed for each blob-triggered function.
                          "%
                          | optional,
                        poisonBlobThreshold
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.isType 'Integer,
                            predicates.numbers.minimum 1
                          ])
                          | doc m%"
                          The number of times to try processing a message before moving it to the poison queue.
                          "%
                          | optional,
                      }
                      | optional,
                    cosmosDB
                      | definitions.contract.cosmosDB-extension-v2
                      | optional,
                    durableTask
                      | definitions.contract.durableTask-extension
                      | optional,
                    eventHubs
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            batchCheckpointFrequency = predicates.isType
                                'Integer,
                            clientRetryOptions = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    delay = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d\\.\\d\\d$"
                                        ],
                                    maxDelay = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                        ],
                                    maxRetries = predicates.isType 'Integer,
                                    mode = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [ "exponential", "fixed" ]
                                        ],
                                    tryTimeout = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.pattern
                                          "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            customEndpointAddress = predicates.isType '"String",
                            initialOffsetOptions = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    enqueuedTimeUtc = predicates.isType
                                        '"String",
                                    type = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "fromStart",
                                            "fromEnd",
                                            "fromEnqueuedTime"
                                          ]
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            maxEventBatchSize = predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.minimum 1
                                ],
                            prefetchCount = predicates.isType 'Integer,
                            targetUnprocessedEventThreshold = predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.minimum 1
                                ],
                            transportType = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum
                                  [ "amqpTcp", "amqpWebSockets" ]
                                ],
                            webProxy = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            batchCheckpointFrequency = predicates.isType
                                'Integer,
                            eventProcessorOptions = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    maxBatchSize = predicates.isType 'Integer,
                                    prefetchCount = predicates.isType 'Integer,
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            initialOffsetOptions = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    type = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "fromStart",
                                            "fromEnd",
                                            "fromEnqueuedTime"
                                          ]
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
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
                          {
                            batchCheckpointFrequency = predicates.isType
                                'Integer,
                            maxBatchSize = predicates.isType 'Integer,
                            prefetchCount = predicates.isType 'Integer,
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ])
                      | doc m%"
                      Configuration settings for 'eventHub' triggers.
                      "%
                      | optional,
                    http | definitions.contract.http-extension | optional,
                    queues
                      | definitions.contract.queues-extension-v2
                      | optional,
                    sendGrid
                      | {
                        from
                          | String
                          | doc m%"
                          The sender's email address across all functions.
                          "%
                          | optional,
                      }
                      | optional,
                    serviceBus
                      | {
                        batchOptions
                          | {
                            autoComplete
                              | Bool
                              | doc m%"
                              Whether the trigger should automatically call complete after processing, or if the function code will manually call complete.
                              "%
                              | optional,
                            maxMessageCount
                              | std.number.Integer
                              | doc m%"
                              The maximum number of messages sent to the function when triggered.
                              "%
                              | optional,
                            operationTimeout
                              | predicates.contract_from_predicate
                              (predicates.strings.pattern
                              "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")
                              | doc m%"
                              A time span value expressed in hh:mm:ss.
                              "%
                              | optional,
                          }
                          | optional,
                        messageHandlerOptions
                          | {
                            autoComplete
                              | Bool
                              | doc m%"
                              Value determining whether messages will be completed automatically, or whether the function will take responsibility message completion.
                              "%
                              | optional,
                            maxAutoRenewDuration
                              | predicates.contract_from_predicate
                              (predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.pattern
                                "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                              ])
                              | doc m%"
                              The maximum duration within which the Service Bus message lock will be renewed automatically.
                              "%
                              | optional,
                            maxConcurrentCalls
                              | std.number.Integer
                              | doc m%"
                              The maximum number of concurrent calls to the callback the message pump should initiate.
                              "%
                              | optional,
                          }
                          | doc m%"
                          The options that will be used for the message handler registered with the MessageReceiver.
                          "%
                          | optional,
                        prefetchCount
                          | std.number.Integer
                          | doc m%"
                          The default PrefetchCount that will be used by the underlying MessageReceiver.
                          "%
                          | optional,
                        sessionHandlerOptions
                          | {
                            autoComplete
                              | Bool
                              | doc m%"
                              Value determining whether messages will be completed automatically, or whether the function will take responsibility message completion.
                              "%
                              | optional,
                            maxAutoRenewDuration
                              | predicates.contract_from_predicate
                              (predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.pattern
                                "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                              ])
                              | doc m%"
                              The maximum duration within which the Service Bus message lock will be renewed automatically.
                              "%
                              | optional,
                            maxConcurrentSessions
                              | std.number.Integer
                              | doc m%"
                              The maximum number of sessions that can be handled concurrently per scaled instance.
                              "%
                              | optional,
                            messageWaitTimeout | String | optional,
                          }
                          | optional,
                      }
                      | doc m%"
                      Configuration settings for 'serviceBus' triggers.
                      "%
                      | optional,
                    ..
                  }
                  | optional,
                functionTimeout
                  | definitions.contract.functionTimeout
                  | optional,
                functions | definitions.contract.functions | optional,
                healthMonitor | definitions.contract.healthMonitor | optional,
                languageWorker
                  | {
                    workersDirectory
                      | String
                      | doc m%"
                      Specifies full path of the directory for language workers
                      "%
                      | optional,
                  }
                  | doc m%"
                  Configuration settings for Language Workers.
                  "%
                  | optional,
                logging
                  | {
                    applicationInsights
                      | {
                        enableDependencyTracking
                          | Bool
                          | doc m%"
                          Enables dependency tracking
                          "%
                          | optional,
                        enableLiveMetrics
                          | Bool
                          | doc m%"
                          Enables live metrics collection.
                          "%
                          | optional,
                        enableLiveMetricsFilters
                          | Bool
                          | doc m%"
                          Enables live metrics filters.
                          "%
                          | optional,
                        enablePerformanceCountersCollection
                          | Bool
                          | doc m%"
                          Enables Kudu performance counters collection.
                          "%
                          | optional,
                        httpAutoCollectionOptions
                          | {
                            enableHttpTriggerExtendedInfoCollection
                              | Bool
                              | doc m%"
                              Enables or disables extended HTTP request information for HTTP triggers.
                              "%
                              | optional,
                            enableResponseHeaderInjection
                              | Bool
                              | doc m%"
                              Enables or disables injection of multi-component correlation headers into responses. Enabling injection allows Application Insights to construct an Application Map to when several instrumentation keys are used.
                              "%
                              | optional,
                            enableW3CDistributedTracing
                              | Bool
                              | doc m%"
                              Enables or disables support of W3C distributed tracing protocol (and turns on legacy correlation schema). Enabled by default if enableHttpTriggerExtendedInfoCollection is true. If enableHttpTriggerExtendedInfoCollection is false, this flag applies to outgoing requests only, not incoming requests
                              "%
                              | optional,
                          }
                          | optional,
                        samplingSettings
                          | {
                            evaluationInterval
                              | predicates.contract_from_predicate
                              (predicates.strings.pattern
                              "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")
                              | doc m%"
                              The interval at which the current rate of telemetry is reevaluated.
                              "%
                              | optional,
                            excludedTypes
                              | String
                              | doc m%"
                              A semi-colon delimited list of types excluded from sampling. Recognized: Dependency, Event, Exception, PageView, Request, Trace.
                              "%
                              | optional,
                            includedTypes
                              | String
                              | doc m%"
                              A semi-colon delimited list of types that you want to be sampled. Recognized: Dependency, Event, Exception, PageView, Request, and Trace.
                              "%
                              | optional,
                            initialSamplingPercentage
                              | Number
                              | doc m%"
                              The initial sampling percentage applied at the start of the sampling process to dynamically vary the percentage.
                              "%
                              | optional,
                            isEnabled
                              | Bool
                              | doc m%"
                              If true, client-side adaptive sampling is enabled.
                              "%
                              | optional,
                            maxSamplingPercentage
                              | Number
                              | doc m%"
                              As sampling percentage varies, this property determines the maximum allowed sampling percentage.
                              "%
                              | optional,
                            maxTelemetryItemsPerSecond
                              | std.number.Integer
                              | doc m%"
                              The target rate that the adaptive algorithm aims for on each instance
                              "%
                              | optional,
                            minSamplingPercentage
                              | Number
                              | doc m%"
                              As sampling percentage varies, this property determines the minimum allowed sampling percentage.
                              "%
                              | optional,
                            movingAverageRatio
                              | Number
                              | doc m%"
                              In the calculation of the moving average, the weight assigned to the most recent value. Use a value equal to or less than 1. Smaller values make the algorithm less reactive to sudden changes.
                              "%
                              | optional,
                            samplingPercentageDecreaseTimeout
                              | predicates.contract_from_predicate
                              (predicates.strings.pattern
                              "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")
                              | doc m%"
                              When the sampling percentage value changes, this property determines how soon afterwards Application Insights is allowed to lower sampling percentage again to capture less data.
                              "%
                              | optional,
                            samplingPercentageIncreaseTimeout
                              | predicates.contract_from_predicate
                              (predicates.strings.pattern
                              "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")
                              | doc m%"
                              When the sampling percentage value changes, this property determines how soon afterwards Application Insights is allowed to raise sampling percentage again to capture more data.
                              "%
                              | optional,
                            ..
                          }
                          | doc m%"
                          Configuration settings for Application Insights client-side adaptive sampling.
                          "%
                          | optional,
                        snapshotConfiguration
                          | {
                            agentEndpoint
                              | predicates.contract_from_predicate
                              (predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ null ]
                              ])
                              | doc m%"
                              The endpoint used to connect to the Application Insights Snapshot Debugger service.
                              "%
                              | optional,
                            captureSnapshotMemoryWeight
                              | Number
                              | doc m%"
                              The weight given to the current process memory size when checking if there's enough memory to take a snapshot.
                              "%
                              | optional,
                            failedRequestLimit
                              | std.number.Integer
                              | doc m%"
                              The limit on the number of failed requests to request snapshots before the telemetry processor is disabled.
                              "%
                              | optional,
                            handleUntrackedExceptions
                              | Bool
                              | doc m%"
                              Enables or disables tracking of exceptions that aren't tracked by Application Insights telemetry.
                              "%
                              | optional,
                            isEnabled
                              | Bool
                              | doc m%"
                              Enables or disables snapshot collection.
                              "%
                              | optional,
                            isEnabledInDeveloperMode
                              | Bool
                              | doc m%"
                              Enables or disables snapshot collection is enabled in developer mode.
                              "%
                              | optional,
                            isEnabledWhenProfiling
                              | Bool
                              | doc m%"
                              Enables or disables snapshot creation even if the Application Insights Profiler is collecting a detailed profiling session.
                              "%
                              | optional,
                            isExceptionSnappointsEnabled
                              | Bool
                              | doc m%"
                              Enables or disables filtering of exceptions.
                              "%
                              | optional,
                            isLowPrioritySnapshotUploader
                              | Bool
                              | doc m%"
                              Determines whether to run the SnapshotUploader process at below normal priority.
                              "%
                              | optional,
                            maximumCollectionPlanSize
                              | predicates.contract_from_predicate
                              (predicates.allOf
                              [
                                predicates.isType 'Integer,
                                predicates.numbers.maximum 9999,
                                predicates.numbers.minimum 1
                              ])
                              | doc m%"
                              The maximum number of problems that we can track at any time.
                              "%
                              | optional,
                            maximumSnapshotsRequired
                              | predicates.contract_from_predicate
                              (predicates.allOf
                              [
                                predicates.isType 'Integer,
                                predicates.numbers.maximum 999,
                                predicates.numbers.minimum 1
                              ])
                              | doc m%"
                              The maximum number of snapshots collected for a single problem.
                              "%
                              | optional,
                            problemCounterResetInterval
                              | predicates.contract_from_predicate
                              (predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.pattern
                                "^(?:[01]\\d|2[0-4]):[0-5]\\d:[0-5]\\d$"
                              ])
                              | doc m%"
                              How often to reset the problem counters in a range from one minute to seven days.
                              "%
                              | optional,
                            provideAnonymousTelemetry
                              | Bool
                              | doc m%"
                              Determines whether to send anonymous usage and error telemetry to Microsoft. This telemetry may be used if you contact Microsoft to help troubleshoot problems with the Snapshot Debugger
                              "%
                              | optional,
                            reconnectInterval
                              | predicates.contract_from_predicate
                              (predicates.strings.pattern
                              "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")
                              | doc m%"
                              How often we reconnect to the Snapshot Debugger endpoint. Allowable range is one minute to one day.
                              "%
                              | optional,
                            shadowCopyFolder
                              | predicates.contract_from_predicate
                              (predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ null ]
                              ])
                              | doc m%"
                              Specifies the folder to use for shadow copying binaries. If not set, the folders specified by the following environment variables are tried in order: Fabric_Folder_App_Temp, LOCALAPPDATA, APPDATA, TEMP.
                              "%
                              | optional,
                            shareUploaderProcess
                              | Bool
                              | doc m%"
                              If true, only one instance of SnapshotUploader will collect and upload snapshots for multiple apps that share the InstrumentationKey. If set to false, the SnapshotUploader will be unique for each (ProcessName, InstrumentationKey) tuple.
                              "%
                              | optional,
                            snapshotInLowPriorityThread
                              | Bool
                              | doc m%"
                              Determines whether or not to process snapshots in a low IO priority thread.
                              "%
                              | optional,
                            snapshotsPerDayLimit
                              | std.number.Integer
                              | doc m%"
                              The maximum number of snapshots allowed in one day (24 hours). This limit is also enforced on the Application Insights service side.
                              "%
                              | optional,
                            snapshotsPerTenMinutesLimit
                              | std.number.Integer
                              | doc m%"
                              The maximum number of snapshots allowed in 10 minutes. Although there is no upper bound on this value, exercise caution increasing it on production workloads because it could impact the performance of your application.
                              "%
                              | optional,
                            tempFolder
                              | predicates.contract_from_predicate
                              (predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ null ]
                              ])
                              | doc m%"
                              Specifies the folder to write minidumps and uploader log files. If not set, then %TEMP%\Dumps is used.
                              "%
                              | optional,
                            thresholdForSnapshotting
                              | std.number.Integer
                              | doc m%"
                              How many times Application Insights needs to see an exception before it asks for snapshots.
                              "%
                              | optional,
                            uploaderProxy
                              | predicates.contract_from_predicate
                              (predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ null ]
                              ])
                              | doc m%"
                              Overrides the proxy server used in the Snapshot Uploader process. You may need to use this setting if your application connects to the internet via a proxy server. The Snapshot Collector runs within your application's process and will use the same proxy settings.
                              "%
                              | optional,
                          }
                          | optional,
                      }
                      | doc m%"
                      Configuration settings for Application Insights logging.
                      "%
                      | optional,
                    fileLoggingMode
                      | predicates.contract_from_predicate
                      (predicates.enum [ "never", "always", "debugOnly" ])
                      | doc m%"
                      Value determining what level of file logging is enabled.
                      "%
                      | optional,
                    logLevel
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          "default" = predicates.enum
                              [
                                "Critical",
                                "Debug",
                                "Error",
                                "Information",
                                "None",
                                "Trace",
                                "Warning"
                              ],
                        }
                        {  }
                        true
                        (predicates.enum
                        [
                          "Critical",
                          "Debug",
                          "Error",
                          "Information",
                          "None",
                          "Trace",
                          "Warning"
                        ])
                      ])
                      | doc m%"
                      Log levels for specific categories.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Configuration settings for logging.
                  "%
                  | optional,
                managedDependency
                  | {
                    enabled
                      | Bool
                      | doc m%"
                      If true, the requirements.psd1 file is processed
                      "%
                      | optional,
                  }
                  | doc m%"
                  Managed dependency is a feature that is currently only supported with PowerShell based functions. It enables dependencies to be automatically managed by the service.
                  "%
                  | optional,
                retry
                  | {
                    delayInterval
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                        ],
                        predicates.enum [ null ]
                      ])
                      | doc m%"
                      Value indicating the delayInterval for function execution retries when using FixedDelay strategy.
                      "%
                      | optional,
                    maxRetryCount
                      | std.number.Integer
                      | doc m%"
                      The maximum number of retries allowed per function execution. -1 means to retry indefinitely.
                      "%
                      | optional,
                    maximumInterval
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                        ],
                        predicates.enum [ null ]
                      ])
                      | doc m%"
                      Value indicating the maximumInterval for function execution retries when using ExponentialBackoff strategy.
                      "%
                      | optional,
                    minimumInterval
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                        ],
                        predicates.enum [ null ]
                      ])
                      | doc m%"
                      Value indicating the minimumInterval for function execution retries when using ExponentialBackoff strategy.
                      "%
                      | optional,
                    strategy
                      | predicates.contract_from_predicate
                      (predicates.enum [ "exponentialBackoff", "fixedDelay" ])
                      | doc m%"
                      Retry strategy to use for retrying function executions
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Retry policy of function execution failures at the app level. Retry policy applies to all the functions in the function app.
                  "%
                  | optional,
                singleton | definitions.contract.singleton | optional,
                version
                  | predicates.contract_from_predicate
                  (predicates.enum [ "2.0" ])
                  | doc m%"
                  The version of the Azure Functions host.json schema. This is NOT the version of the Azure Functions host.
                  "%,
                watchDirectories
                  | definitions.contract.watchDirectories
                  | optional,
                watchFiles
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
                    predicates.arrays.uniqueItems,
                    predicates.records.record {  } {  } false predicates.never
                  ])
                  | doc m%"
                  An array of one or more names of files that are monitored for changes that require your app to restart. This guarantees that when code in these files are changed, the updates are picked up by your functions
                  "%
                  | optional,
              },
          watchDirectories
            | doc m%"
            Set of shared code directories that should be monitored for changes to ensure that when code in these directories is changed, it is picked up by your functions
            "%
            = predicates.contract_from_predicate
              definitions.predicate.watchDirectories,
        },
    predicate = {
          aggregator
            | doc m%"
            Configuration settings for the function result aggregator.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  batchSize = predicates.isType 'Integer,
                  flushTimeout = predicates.strings.pattern
                      "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                }
                {  }
                false
                predicates.never
              ],
          cosmosDB-extension
            | doc m%"
            Configuration settings for Azure Cosmos DB bindings and triggers.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  connectionMode = predicates.enum [ "Gateway", "Direct" ],
                  protocol = predicates.enum [ "Https", "Tcp" ],
                }
                {  }
                false
                predicates.never
              ],
          cosmosDB-extension-v2
            | doc m%"
            Configuration settings for Azure Cosmos DB bindings and triggers.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  connectionMode = predicates.enum [ "Gateway", "Direct" ],
                  leaseOptions = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { leasePrefix = predicates.isType '"String", }
                        {  }
                        false
                        predicates.never
                      ],
                  protocol = predicates.enum [ "Https", "Tcp" ],
                }
                {  }
                false
                predicates.never
              ],
          durableTask-extension
            | doc m%"
            Configuration settings for 'orchestration'/'activity' triggers.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  extendedSessionIdleTimeoutInSeconds = predicates.isType
                      'Integer,
                  extendedSessionsEnabled = predicates.isType '"Bool",
                  hubName = predicates.isType '"String",
                  maxConcurrentActivityFunctions = predicates.isType 'Integer,
                  maxConcurrentOrchestratorFunctions = predicates.isType
                      'Integer,
                  maxEntityOperationBatchSize = predicates.isType 'Integer,
                  notifications = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          eventGrid = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  keySettingName = predicates.isType '"String",
                                  publishEventTypes = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "Started",
                                            "Pending",
                                            "Completed",
                                            "Failed",
                                            "Terminated"
                                          ]
                                        ]),
                                        predicates.arrays.uniqueItems
                                      ],
                                  publishRetryCount = predicates.isType
                                      'Integer,
                                  publishRetryInterval = predicates.isType
                                      '"String",
                                  topicEndpoint = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  storageProvider = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          connectionStringName = predicates.isType '"String",
                          controlQueueBatchSize = predicates.isType 'Integer,
                          controlQueueBufferThreshold = predicates.isType
                              'Integer,
                          controlQueueVisibilityTimeout = predicates.isType
                              '"String",
                          maxQueuePollingInterval = predicates.isType '"String",
                          partitionCount = predicates.isType 'Integer,
                          trackingStoreConnectionStringName = predicates.isType
                              '"String",
                          trackingStoreNamePrefix = predicates.isType '"String",
                          useLegacyPartitionManagement = predicates.isType
                              '"Bool",
                          workItemQueueVisibilityTimeout = predicates.isType
                              '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  tracing = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          traceInputsAndOutputs = predicates.isType '"Bool",
                          traceReplayEvents = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  useAppLease = predicates.isType '"Bool",
                  useGracefulShutdown = predicates.isType '"Bool",
                  useTablePartitionManagement = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          functionTimeout
            | doc m%"
            Value indicating the timeout duration for all functions.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern
                  "^(-1|(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d)$"
                ],
                predicates.enum [ null ]
              ],
          functions
            | doc m%"
            The list of functions the host should load.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String"),
                predicates.arrays.uniqueItems
              ],
          healthMonitor
            | doc m%"
            Configuration settings for the Functions host health monitor
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  counterThreshold = predicates.isType '"Number",
                  enabled = predicates.isType '"Bool",
                  healthCheckInterval = predicates.strings.pattern
                      "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                  healthCheckThreshold = predicates.isType 'Integer,
                  healthCheckWindow = predicates.strings.pattern
                      "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                }
                {  }
                false
                predicates.never
              ],
          http-extension
            | doc m%"
            Configuration settings for 'http' triggers.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "routePrefix" ],
                predicates.records.record
                {
                  customHeaders = predicates.isType 'Record,
                  dynamicThrottlesEnabled = predicates.isType '"Bool",
                  hsts = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          excludedHosts = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                          includeSubDomains = predicates.isType '"Bool",
                          isEnabled = predicates.isType '"Bool",
                          maxAge = predicates.isType '"String",
                          preload = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  maxConcurrentRequests = predicates.isType 'Integer,
                  maxOutstandingRequests = predicates.isType 'Integer,
                  routePrefix = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          queues-extension
            | doc m%"
            Configuration settings for 'queue' triggers.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  batchSize = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 32,
                        predicates.numbers.minimum 1
                      ],
                  maxDequeueCount = predicates.isType 'Integer,
                  maxPollingInterval = predicates.isType 'Integer,
                  newBatchThreshold = predicates.isType 'Integer,
                  visibilityTimeout = predicates.strings.pattern
                      "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                }
                {  }
                false
                predicates.never
              ],
          queues-extension-v2
            | doc m%"
            Configuration settings for 'queue' triggers.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  batchSize = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 32,
                        predicates.numbers.minimum 1
                      ],
                  maxDequeueCount = predicates.isType 'Integer,
                  maxPollingInterval = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9][0-9]:[0-9][0-9]:[0-9][0-9](?:\\.[0-9]+)?$"
                      ],
                  messageEncoding = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "base64", "none" ]
                      ],
                  newBatchThreshold = predicates.isType 'Integer,
                  visibilityTimeout = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9][0-9]:[0-9][0-9]:[0-9][0-9](?:\\.[0-9]+)?$"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          singleton
            | doc m%"
            Configuration settings for Singleton lock behavior.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  listenerLockPeriod = predicates.strings.pattern
                      "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                  listenerLockRecoveryPollingInterval =
                    predicates.strings.pattern
                      "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                  lockAcquisitionPollingInterval = predicates.strings.pattern
                      "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                  lockAcquisitionTimeout = predicates.strings.pattern
                      "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                  lockPeriod = predicates.strings.pattern
                      "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                }
                {  }
                false
                predicates.never
              ],
          version-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  aggregator = definitions.predicate.aggregator,
                  applicationInsights = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          sampling = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  isEnabled = predicates.isType '"Bool",
                                  maxTelemetryItemsPerSecond = predicates.isType
                                      'Integer,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  documentDB = definitions.predicate.cosmosDB-extension,
                  durableTask = definitions.predicate.durableTask-extension,
                  eventHub = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          batchCheckpointFrequency = predicates.isType 'Integer,
                          maxBatchSize = predicates.isType 'Integer,
                          prefetchCount = predicates.isType 'Integer,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  functionTimeout = definitions.predicate.functionTimeout,
                  functions = definitions.predicate.functions,
                  healthMonitor = definitions.predicate.healthMonitor,
                  http = definitions.predicate.http-extension,
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  logger = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          categoryLevels = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  } {  } true
                                (predicates.enum
                                [
                                  "Critical",
                                  "Debug",
                                  "Error",
                                  "Information",
                                  "None",
                                  "Trace",
                                  "Warning"
                                ])
                              ],
                          defaultLevel = predicates.enum
                              [
                                "Critical",
                                "Debug",
                                "Error",
                                "Information",
                                "None",
                                "Trace",
                                "Warning"
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  queues = definitions.predicate.queues-extension,
                  serviceBus = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          autoComplete = predicates.isType '"Bool",
                          autoRenewTimeout = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.pattern
                                "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                              ],
                          maxConcurrentCalls = predicates.isType 'Integer,
                          prefetchCount = predicates.isType 'Integer,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  singleton = definitions.predicate.singleton,
                  tracing = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          consoleLevel = predicates.enum
                              [ "off", "error", "warning", "info", "verbose" ],
                          fileLoggingMode = predicates.enum
                              [ "never", "always", "debugOnly" ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  watchDirectories = definitions.predicate.watchDirectories,
                }
                {  }
                false
                predicates.never
              ],
          version-2 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "version" ],
                predicates.records.record
                {
                  aggregator = definitions.predicate.aggregator,
                  concurrency = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          dynamicConcurrencyEnabled = predicates.isType '"Bool",
                          snapshotPersistenceEnabled = predicates.isType
                              '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  customHandler = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          description = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  arguments = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.isType '"String")
                                      ],
                                  defaultExecutablePath = predicates.isType
                                      '"String",
                                  workingDirectory = predicates.isType
                                      '"String",
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          enableForwardingHttpRequest = predicates.isType
                              '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  extensionBundle = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          id = predicates.isType '"String",
                          version = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  extensions = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          blobs = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  maxDegreeOfParallelism = predicates.allOf
                                      [
                                        predicates.isType 'Integer,
                                        predicates.numbers.minimum 1
                                      ],
                                  poisonBlobThreshold = predicates.allOf
                                      [
                                        predicates.isType 'Integer,
                                        predicates.numbers.minimum 1
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          cosmosDB =
                            definitions.predicate.cosmosDB-extension-v2,
                          durableTask =
                            definitions.predicate.durableTask-extension,
                          eventHubs = predicates.oneOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    batchCheckpointFrequency = predicates.isType
                                        'Integer,
                                    clientRetryOptions = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            delay = predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.pattern
                                                  "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d\\.\\d\\d$"
                                                ],
                                            maxDelay = predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.pattern
                                                  "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                                ],
                                            maxRetries = predicates.isType
                                                'Integer,
                                            mode = predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.enum
                                                  [ "exponential", "fixed" ]
                                                ],
                                            tryTimeout = predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.pattern
                                                  "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                                ],
                                          }
                                          {  }
                                          false
                                          predicates.never
                                        ],
                                    customEndpointAddress = predicates.isType
                                        '"String",
                                    initialOffsetOptions = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            enqueuedTimeUtc = predicates.isType
                                                '"String",
                                            type = predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.enum
                                                  [
                                                    "fromStart",
                                                    "fromEnd",
                                                    "fromEnqueuedTime"
                                                  ]
                                                ],
                                          }
                                          {  }
                                          false
                                          predicates.never
                                        ],
                                    maxEventBatchSize = predicates.allOf
                                        [
                                          predicates.isType 'Integer,
                                          predicates.numbers.minimum 1
                                        ],
                                    prefetchCount = predicates.isType 'Integer,
                                    targetUnprocessedEventThreshold =
                                      predicates.allOf
                                        [
                                          predicates.isType 'Integer,
                                          predicates.numbers.minimum 1
                                        ],
                                    transportType = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [ "amqpTcp", "amqpWebSockets" ]
                                        ],
                                    webProxy = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                                predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    batchCheckpointFrequency = predicates.isType
                                        'Integer,
                                    eventProcessorOptions = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            maxBatchSize = predicates.isType
                                                'Integer,
                                            prefetchCount = predicates.isType
                                                'Integer,
                                          }
                                          {  }
                                          false
                                          predicates.never
                                        ],
                                    initialOffsetOptions = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            type = predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.enum
                                                  [
                                                    "fromStart",
                                                    "fromEnd",
                                                    "fromEnqueuedTime"
                                                  ]
                                                ],
                                          }
                                          {  }
                                          false
                                          predicates.never
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
                                  {
                                    batchCheckpointFrequency = predicates.isType
                                        'Integer,
                                    maxBatchSize = predicates.isType 'Integer,
                                    prefetchCount = predicates.isType 'Integer,
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ]
                              ],
                          http = definitions.predicate.http-extension,
                          queues = definitions.predicate.queues-extension-v2,
                          sendGrid = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                { from = predicates.isType '"String", }
                                {  }
                                false
                                predicates.never
                              ],
                          serviceBus = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  batchOptions = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          autoComplete = predicates.isType
                                              '"Bool",
                                          maxMessageCount = predicates.isType
                                              'Integer,
                                          operationTimeout =
                                            predicates.strings.pattern
                                              "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                  messageHandlerOptions = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          autoComplete = predicates.isType
                                              '"Bool",
                                          maxAutoRenewDuration =
                                            predicates.allOf
                                              [
                                                predicates.isType '"String",
                                                predicates.strings.pattern
                                                "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                              ],
                                          maxConcurrentCalls = predicates.isType
                                              'Integer,
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                  prefetchCount = predicates.isType 'Integer,
                                  sessionHandlerOptions = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          autoComplete = predicates.isType
                                              '"Bool",
                                          maxAutoRenewDuration =
                                            predicates.allOf
                                              [
                                                predicates.isType '"String",
                                                predicates.strings.pattern
                                                "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                              ],
                                          maxConcurrentSessions =
                                            predicates.isType 'Integer,
                                          messageWaitTimeout = predicates.isType
                                              '"String",
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  functionTimeout = definitions.predicate.functionTimeout,
                  functions = definitions.predicate.functions,
                  healthMonitor = definitions.predicate.healthMonitor,
                  languageWorker = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { workersDirectory = predicates.isType '"String", }
                        {  }
                        false
                        predicates.never
                      ],
                  logging = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          applicationInsights = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  enableDependencyTracking = predicates.isType
                                      '"Bool",
                                  enableLiveMetrics = predicates.isType '"Bool",
                                  enableLiveMetricsFilters = predicates.isType
                                      '"Bool",
                                  enablePerformanceCountersCollection =
                                    predicates.isType '"Bool",
                                  httpAutoCollectionOptions = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          enableHttpTriggerExtendedInfoCollection =
                                            predicates.isType '"Bool",
                                          enableResponseHeaderInjection =
                                            predicates.isType '"Bool",
                                          enableW3CDistributedTracing =
                                            predicates.isType '"Bool",
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                  samplingSettings = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          evaluationInterval =
                                            predicates.strings.pattern
                                              "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                                          excludedTypes = predicates.isType
                                              '"String",
                                          includedTypes = predicates.isType
                                              '"String",
                                          initialSamplingPercentage =
                                            predicates.isType '"Number",
                                          isEnabled = predicates.isType '"Bool",
                                          maxSamplingPercentage =
                                            predicates.isType '"Number",
                                          maxTelemetryItemsPerSecond =
                                            predicates.isType 'Integer,
                                          minSamplingPercentage =
                                            predicates.isType '"Number",
                                          movingAverageRatio = predicates.isType
                                              '"Number",
                                          samplingPercentageDecreaseTimeout =
                                            predicates.strings.pattern
                                              "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                                          samplingPercentageIncreaseTimeout =
                                            predicates.strings.pattern
                                              "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                  snapshotConfiguration = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          agentEndpoint = predicates.oneOf
                                              [
                                                predicates.isType '"String",
                                                predicates.enum [ null ]
                                              ],
                                          captureSnapshotMemoryWeight =
                                            predicates.isType '"Number",
                                          failedRequestLimit = predicates.isType
                                              'Integer,
                                          handleUntrackedExceptions =
                                            predicates.isType '"Bool",
                                          isEnabled = predicates.isType '"Bool",
                                          isEnabledInDeveloperMode =
                                            predicates.isType '"Bool",
                                          isEnabledWhenProfiling =
                                            predicates.isType '"Bool",
                                          isExceptionSnappointsEnabled =
                                            predicates.isType '"Bool",
                                          isLowPrioritySnapshotUploader =
                                            predicates.isType '"Bool",
                                          maximumCollectionPlanSize =
                                            predicates.allOf
                                              [
                                                predicates.isType 'Integer,
                                                predicates.numbers.maximum 9999,
                                                predicates.numbers.minimum 1
                                              ],
                                          maximumSnapshotsRequired =
                                            predicates.allOf
                                              [
                                                predicates.isType 'Integer,
                                                predicates.numbers.maximum 999,
                                                predicates.numbers.minimum 1
                                              ],
                                          problemCounterResetInterval =
                                            predicates.allOf
                                              [
                                                predicates.isType '"String",
                                                predicates.strings.pattern
                                                "^(?:[01]\\d|2[0-4]):[0-5]\\d:[0-5]\\d$"
                                              ],
                                          provideAnonymousTelemetry =
                                            predicates.isType '"Bool",
                                          reconnectInterval =
                                            predicates.strings.pattern
                                              "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                                          shadowCopyFolder = predicates.oneOf
                                              [
                                                predicates.isType '"String",
                                                predicates.enum [ null ]
                                              ],
                                          shareUploaderProcess =
                                            predicates.isType '"Bool",
                                          snapshotInLowPriorityThread =
                                            predicates.isType '"Bool",
                                          snapshotsPerDayLimit =
                                            predicates.isType 'Integer,
                                          snapshotsPerTenMinutesLimit =
                                            predicates.isType 'Integer,
                                          tempFolder = predicates.oneOf
                                              [
                                                predicates.isType '"String",
                                                predicates.enum [ null ]
                                              ],
                                          thresholdForSnapshotting =
                                            predicates.isType 'Integer,
                                          uploaderProxy = predicates.oneOf
                                              [
                                                predicates.isType '"String",
                                                predicates.enum [ null ]
                                              ],
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          fileLoggingMode = predicates.enum
                              [ "never", "always", "debugOnly" ],
                          logLevel = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  "default" = predicates.enum
                                      [
                                        "Critical",
                                        "Debug",
                                        "Error",
                                        "Information",
                                        "None",
                                        "Trace",
                                        "Warning"
                                      ],
                                }
                                {  }
                                true
                                (predicates.enum
                                [
                                  "Critical",
                                  "Debug",
                                  "Error",
                                  "Information",
                                  "None",
                                  "Trace",
                                  "Warning"
                                ])
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  managedDependency = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { enabled = predicates.isType '"Bool", }
                        {  }
                        false
                        predicates.never
                      ],
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
                          strategy = predicates.enum
                              [ "exponentialBackoff", "fixedDelay" ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  singleton = definitions.predicate.singleton,
                  version = predicates.enum [ "2.0" ],
                  watchDirectories = definitions.predicate.watchDirectories,
                  watchFiles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]),
                        predicates.arrays.uniqueItems,
                        predicates.records.record {  } {  } false
                        predicates.never
                      ],
                }
                {  }
                false
                predicates.never
              ],
          watchDirectories
            | doc m%"
            Set of shared code directories that should be monitored for changes to ensure that when code in these directories is changed, it is picked up by your functions
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.minLength 1
                ]),
                predicates.arrays.uniqueItems
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.oneOf
  [ definitions.predicate.version-1, definitions.predicate.version-2 ]
])