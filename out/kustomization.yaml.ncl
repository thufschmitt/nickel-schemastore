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
          ConfigMapArgs
            | doc m%"
            ConfigMapArgs contains the metadata of how to generate a configmap
            "%
            = {
                KVSources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.KVSource
                  ])
                  | optional,
                behavior
                  | predicates.contract_from_predicate
                  (predicates.enum [ "create", "replace", "merge" ])
                  | optional,
                env
                  | String
                  | doc m%"
                  Deprecated.  Use envs instead.
                  "%
                  | optional,
                envs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of file paths. The contents of each file should be one key=value pair per line
                  "%
                  | optional,
                files
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of file sources to use in creating a list of key, value pairs
                  "%
                  | optional,
                literals
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of literal pair sources. Each literal source should be a key and literal value, e.g. `key=value`
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name - actually the partial name - of the generated resource
                  "%
                  | optional,
                namespace
                  | String
                  | doc m%"
                  Namespace for the configmap, optional
                  "%
                  | optional,
                options | definitions.contract.GeneratorOptions | optional,
              },
          FieldSelector
            | doc m%"
            Contains the fieldPath to an object field
            "%
            = { fieldpath | String | optional, },
          FieldSpec = {
                create | Bool | optional,
                group | String | optional,
                kind | String | optional,
                path | String | optional,
                version | String | optional,
                ..
              },
          GeneratorOptions
            | doc m%"
            GeneratorOptions modify behavior of all ConfigMap and Secret generators
            "%
            = {
                annotations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Annotations to add to all generated resources
                  "%
                  | optional,
                disableNameSuffixHash
                  | Bool
                  | doc m%"
                  DisableNameSuffixHash if true disables the default behavior of adding a suffix to the names of generated resources that is a hash of the resource contents
                  "%
                  | optional,
                immutable
                  | Bool
                  | doc m%"
                  Immutable if true add to all generated resources
                  "%
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Labels to add to all generated resources
                  "%
                  | optional,
              },
          HelmChart = {
                additionalValuesFiles
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                apiVersions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                includeCRDs | Bool | optional,
                name | String | optional,
                nameTemplate | String | optional,
                namespace | String | optional,
                releaseName | String | optional,
                repo | String | optional,
                skipTests | Bool | optional,
                valuesFile | String | optional,
                valuesInline
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.records.record {  } {  } true
                          predicates.always,
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                valuesMerge
                  | std.enum.TagOrString
                  | [| 'replace, 'override, '"merge" |]
                  | optional,
                version | String | optional,
              },
          Image = {
                digest | String | optional,
                name | String | optional,
                newName | String | optional,
                newTag | String | optional,
              },
          Inventory
            | doc m%"
            Inventory appends an object that contains the record of all other objects, which can be used in apply, prune and delete
            "%
            = {
                configMap | definitions.contract.NameArgs | optional,
                type | String | optional,
              },
          KVSource = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                name | String | optional,
                pluginType | String | optional,
              },
          Kustomization = {
                apiVersion | String | optional,
                bases
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  DEPRECATED. Bases are relative paths or git repository URLs specifying a directory containing a kustomization.yaml file.
                  "%
                  | optional,
                buildMetadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  BuildMetadata is a list of strings used to toggle different build options
                  "%
                  | optional,
                commonAnnotations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  CommonAnnotations to add to all objects
                  "%
                  | optional,
                commonLabels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | doc m%"
                   CommonLabels to add to all objects and selectors
                  "%
                  | optional,
                components
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Components are relative paths or git repository URLs specifying a directory containing a kustomization.yaml file of Kind Component.
                  "%
                  | optional,
                configMapGenerator
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ConfigMapArgs
                  ])
                  | doc m%"
                  ConfigMapGenerator is a list of configmaps to generate from local data (one configMap per list item)
                  "%
                  | optional,
                configurations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Configurations is a list of transformer configuration files
                  "%
                  | optional,
                crds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Crds specifies relative paths to Custom Resource Definition files. This allows custom resources to be recognized as operands, making it possible to add them to the Resources list. CRDs themselves are not modified.
                  "%
                  | optional,
                generatorOptions
                  | definitions.contract.GeneratorOptions
                  | optional,
                generators
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Generators is a list of files containing custom generators
                  "%
                  | optional,
                helmCharts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.HelmChart
                  ])
                  | doc m%"
                  HelmCharts is a list of helm chart configuration instances
                  "%
                  | optional,
                helmGlobals
                  | {
                    chartHome
                      | String
                      | doc m%"
                      ChartHome is a file path, relative to the kustomization root, to a directory containing a subdirectory for each chart to be included in the kustomization
                      "%
                      | optional,
                    configHome
                      | String
                      | doc m%"
                      ConfigHome defines a value that kustomize should pass to helm via the HELM_CONFIG_HOME environment variable
                      "%
                      | optional,
                  }
                  | doc m%"
                  HelmGlobals contains helm configuration that isn't chart specific
                  "%
                  | optional,
                images
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Image
                  ])
                  | doc m%"
                  Images is a list of (image name, new name, new tag or digest) for changing image names, tags or digests. This can also be achieved with a patch, but this operator is simpler to specify.
                  "%
                  | optional,
                inventory | definitions.contract.Inventory | optional,
                kind | String | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Labels
                  ])
                  | doc m%"
                  Labels to add to all objects but not selectors
                  "%
                  | optional,
                metadata
                  | definitions.contract.Metadata
                  | doc m%"
                  Contains metadata about a Resource
                  "%
                  | optional,
                namePrefix
                  | String
                  | doc m%"
                  NamePrefix will prefix the names of all resources mentioned in the kustomization file including generated configmaps and secrets
                  "%
                  | optional,
                nameSuffix
                  | String
                  | doc m%"
                  NameSuffix will suffix the names of all resources mentioned in the kustomization file including generated configmaps and secrets
                  "%
                  | optional,
                namespace
                  | String
                  | doc m%"
                  Namespace to add to all objects
                  "%
                  | optional,
                openapi
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  OpenAPI contains information about what kubernetes schema to use
                  "%
                  | optional,
                patches
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.oneOf
                    [
                      definitions.predicate.PatchesPatchPath,
                      definitions.predicate.PatchesInlinePatch
                    ])
                  ])
                  | doc m%"
                  Apply a patch to multiple resources
                  "%
                  | optional,
                patchesJson6902
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.PatchJson6902
                  ])
                  | doc m%"
                  JSONPatches is a list of JSONPatch for applying JSON patch. See http://jsonpatch.com
                  "%
                  | optional,
                patchesStrategicMerge
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                   PatchesStrategicMerge specifies the relative path to a file containing a strategic merge patch. URLs and globs are not supported
                  "%
                  | optional,
                replacements
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.oneOf
                    [
                      definitions.predicate.ReplacementsPath,
                      definitions.predicate.ReplacementsInline
                    ])
                  ])
                  | doc m%"
                  Substitute field(s) in N target(s) with a field from a source
                  "%
                  | optional,
                replicas
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Replicas
                  ])
                  | doc m%"
                  Replicas is a list of (resource name, count) for changing number of replicas for a resources. It will match any group and kind that has a matching name and that is one of: Deployment, ReplicationController, Replicaset, Statefulset.
                  "%
                  | optional,
                resources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Resources specifies relative paths to files holding YAML representations of kubernetes API objects. URLs and globs not supported.
                  "%
                  | optional,
                secretGenerator
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.SecretArgs
                  ])
                  | doc m%"
                  SecretGenerator is a list of secrets to generate from local data (one secret per list item)
                  "%
                  | optional,
                transformers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Transformers is a list of files containing transformers
                  "%
                  | optional,
                validators
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Validators is a list of files containing validators
                  "%
                  | optional,
                vars
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Var
                  ])
                  | doc m%"
                  Allows things modified by kustomize to be injected into a container specification. A var is a name (e.g. FOO) associated with a field in a specific resource instance.  The field must contain a value of type string, and defaults to the name field of the instance
                  "%
                  | optional,
              },
          Labels = {
                fields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.FieldSpec
                  ])
                  | doc m%"
                  FieldSpec completely specifies a kustomizable field in a k8s API object. It helps define the operands of transformations
                  "%
                  | optional,
                includeSelectors
                  | Bool
                  | doc m%"
                  IncludeSelectors inidicates should transformer include the fieldSpecs for selectors
                  "%
                  | optional,
                includeTemplates
                  | Bool
                  | doc m%"
                  IncludeTemplates inidicates should transformer include the template labels
                  "%
                  | optional,
                pairs
                  | predicates.contract_from_predicate
                  (predicates.records.record {  }
                  { ".*" = predicates.isType '"String", }
                  true
                  predicates.always)
                  | doc m%"
                  Pairs contains the key-value pairs for labels to add
                  "%
                  | optional,
              },
          Metadata = {
                annotations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | optional,
                name | String | optional,
                namespace | String | optional,
              },
          NameArgs = {
                name | String | optional,
                namespace | String | optional,
              },
          PatchJson6902 = predicates.contract_from_predicate
              definitions.predicate.PatchJson6902,
          PatchTarget = {
                group | String | optional,
                kind | String,
                name | String,
                namespace | String | optional,
                version | String,
              },
          PatchTargetOptional = {
                annotationSelector | String | optional,
                group | String | optional,
                kind | String | optional,
                labelSelector | String | optional,
                name | String | optional,
                namespace | String | optional,
                version | String | optional,
              },
          PatchesInlinePatch = predicates.contract_from_predicate
              definitions.predicate.PatchesInlinePatch,
          PatchesOptions = {
                allowKindChange | Bool | optional,
                allowNameChange | Bool | optional,
              },
          PatchesPatchPath = predicates.contract_from_predicate
              definitions.predicate.PatchesPatchPath,
          ReplacementsInline = {
                source
                  | {
                    fieldPath
                      | String
                      | doc m%"
                      The structured path to the source value
                      "%
                      | optional,
                    group
                      | String
                      | doc m%"
                      The group of the referent
                      "%
                      | optional,
                    kind
                      | String
                      | doc m%"
                      The kind of the referent
                      "%
                      | optional,
                    name
                      | String
                      | doc m%"
                      The name of the referent
                      "%
                      | optional,
                    namespace
                      | String
                      | doc m%"
                      The namespace of the referent
                      "%
                      | optional,
                    options
                      | {
                        create | Bool | optional,
                        delimiter | String | optional,
                        index | Number | optional,
                        ..
                      }
                      | optional,
                    version
                      | String
                      | doc m%"
                      The version of the referent
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  The source of the value
                  "%,
                targets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "select" ],
                      predicates.records.record
                      {
                        fieldPaths = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                        options = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                create = predicates.isType '"Bool",
                                delimiter = predicates.isType '"String",
                                index = predicates.isType '"Number",
                              }
                              {  }
                              true
                              predicates.always
                            ],
                        reject = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  group = predicates.isType '"String",
                                  kind = predicates.isType '"String",
                                  name = predicates.isType '"String",
                                  namespace = predicates.isType '"String",
                                  version = predicates.isType '"String",
                                }
                                {  }
                                true
                                predicates.always
                              ])
                            ],
                        select = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                group = predicates.isType '"String",
                                kind = predicates.isType '"String",
                                name = predicates.isType '"String",
                                namespace = predicates.isType '"String",
                                version = predicates.isType '"String",
                              }
                              {  }
                              true
                              predicates.always
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ])
                  | doc m%"
                  The N fields to write the value to
                  "%,
              },
          ReplacementsPath = { path | String, },
          Replicas = { count | Number | optional, name | String | optional, },
          SecretArgs
            | doc m%"
            SecretArgs contains the metadata of how to generate a secret
            "%
            = {
                KVSources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.KVSource
                  ])
                  | optional,
                behavior
                  | predicates.contract_from_predicate
                  (predicates.enum [ "create", "replace", "merge" ])
                  | optional,
                env | String | optional,
                envs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                files
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                literals
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                name
                  | String
                  | doc m%"
                  Name - actually the partial name - of the generated resource
                  "%
                  | optional,
                namespace
                  | String
                  | doc m%"
                  Namespace for the secret, optional
                  "%
                  | optional,
                options | definitions.contract.GeneratorOptions | optional,
                type
                  | String
                  | doc m%"
                  Type of the secret, optional
                  "%
                  | optional,
              },
          Target = {
                apiVersion | String | optional,
                group | String | optional,
                kind | String | optional,
                name | String,
                version | String | optional,
              },
          Var
            | doc m%"
            Represents a variable whose value will be sourced from a field in a Kubernetes object.
            "%
            = {
                fieldref
                  | definitions.contract.FieldSelector
                  | doc m%"
                  Refers to the field of the object referred to by objref whose value will be extracted for use in replacing $(FOO)
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Value of identifier name e.g. FOO used in container args, annotations, Appears in pod template as $(FOO)
                  "%,
                objref
                  | definitions.contract.Target
                  | doc m%"
                  Refers to a Kubernetes resource under the purview of this kustomization
                  "%,
              },
        },
    predicate = {
          ConfigMapArgs
            | doc m%"
            ConfigMapArgs contains the metadata of how to generate a configmap
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  KVSources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.KVSource
                      ],
                  behavior = predicates.enum [ "create", "replace", "merge" ],
                  env = predicates.isType '"String",
                  envs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  files = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  literals = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  options = definitions.predicate.GeneratorOptions,
                }
                {  }
                false
                predicates.never
              ],
          FieldSelector
            | doc m%"
            Contains the fieldPath to an object field
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { fieldpath = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          FieldSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  create = predicates.isType '"Bool",
                  group = predicates.isType '"String",
                  kind = predicates.isType '"String",
                  path = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          GeneratorOptions
            | doc m%"
            GeneratorOptions modify behavior of all ConfigMap and Secret generators
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotations = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  disableNameSuffixHash = predicates.isType '"Bool",
                  immutable = predicates.isType '"Bool",
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          HelmChart = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  additionalValuesFiles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  apiVersions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  includeCRDs = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  nameTemplate = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  releaseName = predicates.isType '"String",
                  repo = predicates.isType '"String",
                  skipTests = predicates.isType '"Bool",
                  valuesFile = predicates.isType '"String",
                  valuesInline = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.records.record {  } {  } true
                              predicates.always,
                        }
                        true
                        predicates.always
                      ],
                  valuesMerge = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "merge", "override", "replace" ]
                      ],
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Image = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  digest = predicates.isType '"String",
                  name = predicates.isType '"String",
                  newName = predicates.isType '"String",
                  newTag = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Inventory
            | doc m%"
            Inventory appends an object that contains the record of all other objects, which can be used in apply, prune and delete
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configMap = definitions.predicate.NameArgs,
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          KVSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                  pluginType = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Kustomization = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  bases = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  buildMetadata = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  commonAnnotations = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  commonLabels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  components = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  configMapGenerator = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ConfigMapArgs
                      ],
                  configurations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  crds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  generatorOptions = definitions.predicate.GeneratorOptions,
                  generators = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  helmCharts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.HelmChart
                      ],
                  helmGlobals = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          chartHome = predicates.isType '"String",
                          configHome = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  images = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Image
                      ],
                  inventory = definitions.predicate.Inventory,
                  kind = predicates.isType '"String",
                  labels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Labels
                      ],
                  metadata = definitions.predicate.Metadata,
                  namePrefix = predicates.isType '"String",
                  nameSuffix = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  openapi = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  patches = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.oneOf
                        [
                          definitions.predicate.PatchesPatchPath,
                          definitions.predicate.PatchesInlinePatch
                        ])
                      ],
                  patchesJson6902 = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.PatchJson6902
                      ],
                  patchesStrategicMerge = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  replacements = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.oneOf
                        [
                          definitions.predicate.ReplacementsPath,
                          definitions.predicate.ReplacementsInline
                        ])
                      ],
                  replicas = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Replicas
                      ],
                  resources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  secretGenerator = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SecretArgs
                      ],
                  transformers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  validators = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  vars = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Var
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Labels = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.FieldSpec
                      ],
                  includeSelectors = predicates.isType '"Bool",
                  includeTemplates = predicates.isType '"Bool",
                  pairs = predicates.records.record {  }
                      { ".*" = predicates.isType '"String", }
                      true
                      predicates.always,
                }
                {  }
                false
                predicates.never
              ],
          Metadata = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotations = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          NameArgs = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PatchJson6902 = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "path", "target" ],
                  predicates.records.record
                  {
                    path = predicates.isType '"String",
                    target = definitions.predicate.PatchTarget,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "patch", "target" ],
                  predicates.records.record
                  {
                    patch = predicates.isType '"String",
                    target = definitions.predicate.PatchTarget,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "op", "path" ],
                  predicates.records.record
                  {
                    from = predicates.isType '"String",
                    op = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "add", "remove", "replace", "move", "copy", "test" ]
                        ],
                    path = predicates.isType '"String",
                    value = predicates.oneOf
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
                  false
                  predicates.never
                ]
              ],
          PatchTarget = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kind", "name", "version" ],
                predicates.records.record
                {
                  group = predicates.isType '"String",
                  kind = predicates.isType '"String",
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PatchTargetOptional = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotationSelector = predicates.isType '"String",
                  group = predicates.isType '"String",
                  kind = predicates.isType '"String",
                  labelSelector = predicates.isType '"String",
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PatchesInlinePatch = predicates.allOf
              [
                predicates.records.required [ "patch" ],
                predicates.records.record
                {
                  options = definitions.predicate.PatchesOptions,
                  patch = predicates.isType '"String",
                  target = definitions.predicate.PatchTargetOptional,
                }
                {  }
                false
                predicates.never
              ],
          PatchesOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allowKindChange = predicates.isType '"Bool",
                  allowNameChange = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          PatchesPatchPath = predicates.allOf
              [
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  options = definitions.predicate.PatchesOptions,
                  path = predicates.isType '"String",
                  target = definitions.predicate.PatchTargetOptional,
                }
                {  }
                false
                predicates.never
              ],
          ReplacementsInline = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "source", "targets" ],
                predicates.records.record
                {
                  source = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          fieldPath = predicates.isType '"String",
                          group = predicates.isType '"String",
                          kind = predicates.isType '"String",
                          name = predicates.isType '"String",
                          namespace = predicates.isType '"String",
                          options = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  create = predicates.isType '"Bool",
                                  delimiter = predicates.isType '"String",
                                  index = predicates.isType '"Number",
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          version = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  targets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "select" ],
                          predicates.records.record
                          {
                            fieldPaths = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            options = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    create = predicates.isType '"Bool",
                                    delimiter = predicates.isType '"String",
                                    index = predicates.isType '"Number",
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            reject = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      group = predicates.isType '"String",
                                      kind = predicates.isType '"String",
                                      name = predicates.isType '"String",
                                      namespace = predicates.isType '"String",
                                      version = predicates.isType '"String",
                                    }
                                    {  }
                                    true
                                    predicates.always
                                  ])
                                ],
                            select = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    group = predicates.isType '"String",
                                    kind = predicates.isType '"String",
                                    name = predicates.isType '"String",
                                    namespace = predicates.isType '"String",
                                    version = predicates.isType '"String",
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ])
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ReplacementsPath = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                { path = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          Replicas = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  count = predicates.isType '"Number",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SecretArgs
            | doc m%"
            SecretArgs contains the metadata of how to generate a secret
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  KVSources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.KVSource
                      ],
                  behavior = predicates.enum [ "create", "replace", "merge" ],
                  env = predicates.isType '"String",
                  envs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  files = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  literals = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  options = definitions.predicate.GeneratorOptions,
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Target = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  group = predicates.isType '"String",
                  kind = predicates.isType '"String",
                  name = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Var
            | doc m%"
            Represents a variable whose value will be sourced from a field in a Kubernetes object.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "objref" ],
                predicates.records.record
                {
                  fieldref = definitions.predicate.FieldSelector,
                  name = predicates.isType '"String",
                  objref = definitions.predicate.Target,
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

predicates.contract_from_predicate definitions.predicate.Kustomization