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
          AdvancedFsUserConfig
            | doc m%"
            Allows the user to specify the default behavior for file operations:
            
            1. `"read"` - Read from the remote file system (default) 2. `"write"` - Read/Write from the remote file system. 3. `"local"` - Read from the local file system. 5. `"disable"` - Disable file operations.
            
            Besides the default behavior, the user can specify behavior for specific regex patterns. Case insensitive.
            
            1. `"read_write"` - List of patterns that should be read/write remotely. 2. `"read_only"` - List of patterns that should be read only remotely. 3. `"local"` - List of patterns that should be read locally. 4. `"not_found"` - List of patters that should never be read nor written. These files should be treated as non-existent.
            
            The logic for choosing the behavior is as follows:
            
            1. Check if one of the patterns match the file path, do the corresponding action. There's no specified order if two lists match the same path, we will use the first one (and we do not guarantee what is first).
            
            **Warning**: Specifying the same path in two lists is unsupported and can lead to undefined behaviour.
            
            2. Check our "special list" - we have an internal at compile time list for different behavior based on patterns to provide better UX.
            
            3. If none of the above match, use the default behavior (mode).
            
            For more information, check the file operations [technical reference](https://mirrord.dev/docs/reference/fileops/).
            
            ```json { "feature": { "fs": { "mode": "write", "read_write": ".+\.json" , "read_only": [ ".+\.yaml", ".+important-file\.txt" ], "local": [ ".+\.js", ".+\.mjs" ], "not_found": [ "\.config/gcloud" ] } } } ```
            "%
            = {
                local
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.VecOrSingle_for_String,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Specify file path patterns that if matched will be opened locally.
                  "%
                  | optional,
                mode
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FsModeConfig,
                    predicates.isType 'Null
                  ])
                  | optional,
                not_found
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.VecOrSingle_for_String,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Specify file path patterns that if matched will be treated as non-existent.
                  "%
                  | optional,
                read_only
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.VecOrSingle_for_String,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Specify file path patterns that if matched will be read from the remote. if file matching the pattern is opened for writing or read/write it will be opened locally.
                  "%
                  | optional,
                read_write
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.VecOrSingle_for_String,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Specify file path patterns that if matched will be read and written to the remote.
                  "%
                  | optional,
              },
          AgentFileConfig
            | doc m%"
            Configuration for the mirrord-agent pod that is spawned in the Kubernetes cluster.
            
            We provide sane defaults for this option, so you don't have to set up anything here.
            
            ```json { "agent": { "log_level": "info", "namespace": "default", "image": "ghcr.io/metalbear-co/mirrord:latest", "image_pull_policy": "IfNotPresent", "image_pull_secrets": [ { "secret-key": "secret" } ], "ttl": 30, "ephemeral": false, "communication_timeout": 30, "startup_timeout": 360, "network_interface": "eth0", "pause": false, "flush_connections": false, } } ```
            "%
            = {
                check_out_of_pods
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Determine if to check whether there is room for agent job in target node. (Not applicable when using ephemeral containers feature)
                  
                  Can be disabled if the check takes too long and you are sure there is enough resources on each node
                  "%
                  | optional,
                communication_timeout
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Controls how long the agent lives when there are no connections.
                  
                  Each connection has its own heartbeat mechanism, so even if the local application has no messages, the agent stays alive until there are no more heartbeat messages.
                  "%
                  | optional,
                disabled_capabilities
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    definitions.predicate.LinuxCapability
                  ])
                  | doc m%"
                  Disables specified Linux capabilities for the agent container. If nothing is disabled here, agent uses `NET_ADMIN`, `NET_RAW`, `SYS_PTRACE` and `SYS_ADMIN`.
                  "%
                  | optional,
                ephemeral
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Runs the agent as an [ephemeral container](https://kubernetes.io/docs/concepts/workloads/pods/ephemeral-containers/)
                  
                  Defaults to `false`.
                  "%
                  | optional,
                flush_connections
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Flushes existing connections when starting to steal, might fix issues where connections aren't stolen (due to being already established)
                  
                  Defaults to `true`.
                  "%
                  | optional,
                image
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Name of the agent's docker image.
                  
                  Useful when a custom build of mirrord-agent is required, or when using an internal registry.
                  
                  Defaults to the latest stable image `"ghcr.io/metalbear-co/mirrord:latest"`.
                  
                  ```json { "agent": { "image": "internal.repo/images/mirrord:latest" } } ```
                  "%
                  | optional,
                image_pull_policy
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Controls when a new agent image is downloaded.
                  
                  Supports `"IfNotPresent"`, `"Always"`, `"Never"`, or any valid kubernetes [image pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy)
                  
                  Defaults to `"IfNotPresent"`
                  "%
                  | optional,
                image_pull_secrets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ])
                  ])
                  | doc m%"
                  List of secrets the agent pod has access to.
                  
                  Takes an array of hash with the format `{ name: <secret-name> }`.
                  
                  Read more [here](https://kubernetes.io/docs/concepts/containers/images/).
                  
                  ```json { "agent": { "image_pull_secrets": [ { "very-secret": "secret-key" }, { "very-secret": "keep-your-secrets" } ] } } ```
                  "%
                  | optional,
                log_level
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Log level for the agent.
                  
                  Supports `"trace"`, `"debug"`, `"info"`, `"warn"`, `"error"`, or any string that would work with `RUST_LOG`.
                  
                  ```json { "agent": { "log_level": "mirrord=debug,warn" } } ```
                  "%
                  | optional,
                namespace
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Namespace where the agent shall live. Note: Doesn't work with ephemeral containers. Defaults to the current kubernetes namespace.
                  "%
                  | optional,
                network_interface
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Which network interface to use for mirroring.
                  
                  The default behavior is try to access the internet and use that interface. If that fails it uses `eth0`.
                  "%
                  | optional,
                privileged
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Run the mirror agent as privileged container. Defaults to `false`.
                  
                  Might be needed in strict environments such as Bottlerocket.
                  "%
                  | optional,
                resources
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate."io.k8s.api.core.v1.ResourceRequirements",
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Set pod resource reqirements. (not with ephemeral agents) Default is ```json { "requests": { "cpu": "1m", "memory": "1Mi" }, "limits": { "cpu": "100m", "memory": "100Mi" } } ```
                  "%
                  | optional,
                startup_timeout
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Controls how long to wait for the agent to finish initialization.
                  
                  If initialization takes longer than this value, mirrord exits.
                  
                  Defaults to `60`.
                  "%
                  | optional,
                tolerations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.Toleration"
                  ])
                  | doc m%"
                  Set pod tolerations. (not with ephemeral agents) Default is ```json [ { "operator": "Exists" } ] ```
                  
                  Set to an empty array to have no tolerations at all
                  "%
                  | optional,
                ttl
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Controls how long the agent pod persists for after the agent exits (in seconds).
                  
                  Can be useful for collecting logs.
                  
                  Defaults to `1`.
                  "%
                  | optional,
              },
          ConcurrentSteal
            | doc m%"
            (Operator Only): Allows overriding port locks
            
            Can be set to either `"continue"` or `"override"`.
            
            - `"continue"`: Continue with normal execution - `"override"`: If port lock detected then override it with new lock and force close the original locking connection.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ConcurrentSteal,
          DeploymentTarget
            | doc m%"
            <!--${internal}--> Mirror the deployment specified by [`DeploymentTarget::deployment`].
            "%
            = {
                container
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | optional,
                deployment
                  | String
                  | doc m%"
                  <!--${internal}--> Deployment to mirror.
                  "%,
                ..
              },
          EnvFileConfig
            | doc m%"
            Allows the user to set or override the local process' environment variables with the ones from the remote pod.
            
            Which environment variables to load from the remote pod are controlled by setting either [`include`](#feature-env-include) or [`exclude`](#feature-env-exclude).
            
            See the environment variables [reference](https://mirrord.dev/docs/reference/env/) for more details.
            
            ```json { "feature": { "env": { "include": "DATABASE_USER;PUBLIC_ENV", "exclude": "DATABASE_PASSWORD;SECRET_ENV", "override": { "DATABASE_CONNECTION": "db://localhost:7777/my-db", "LOCAL_BEAR": "panda" } } } } ```
            "%
            = {
                exclude
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.VecOrSingle_for_String,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Include the remote environment variables in the local process that are **NOT** specified by this option.
                  
                  Some of the variables that are excluded by default: `PATH`, `HOME`, `HOMEPATH`, `CLASSPATH`, `JAVA_EXE`, `JAVA_HOME`, `PYTHONPATH`.
                  
                  Value is a list separated by ";".
                  "%
                  | optional,
                include
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.VecOrSingle_for_String,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Include only these remote environment variables in the local process.
                  
                  Value is a list separated by ";".
                  
                  Some environment variables are excluded by default (`PATH` for example), including these requires specifying them with `include`
                  "%
                  | optional,
                override
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Allows setting or overriding environment variables (locally) with a custom value.
                  
                  For example, if the remote pod has an environment variable `REGION=1`, but this is an undesirable value, it's possible to use `override` to set `REGION=2` (locally) instead.
                  "%
                  | optional,
              },
          FeatureFileConfig
            | doc m%"
            Controls mirrord features.
            
            See the [technical reference, Technical Reference](https://mirrord.dev/docs/reference/) to learn more about what each feature does.
            
            The [`env`](#feature-env), [`fs`](#feature-fs) and [`network`](#feature-network) options have support for a shortened version, that you can see [here](#root-shortened).
            
            ```json { "feature": { "env": { "include": "DATABASE_USER;PUBLIC_ENV", "exclude": "DATABASE_PASSWORD;SECRET_ENV", "override": { "DATABASE_CONNECTION": "db://localhost:7777/my-db", "LOCAL_BEAR": "panda" } }, "fs": { "mode": "write", "read_write": ".+\.json" , "read_only": [ ".+\.yaml", ".+important-file\.txt" ], "local": [ ".+\.js", ".+\.mjs" ] }, "network": { "incoming": { "mode": "steal", "http_header_filter": { "filter": "host: api\..+", "ports": [80, 8080] }, "port_mapping": [[ 7777, 8888 ]], "ignore_localhost": false, "ignore_ports": [9999, 10000] }, "outgoing": { "tcp": true, "udp": true, "filter": { "local": ["tcp://1.1.1.0/24:1337", "1.1.5.0/24", "google.com", ":53"] }, "ignore_localhost": false, "unix_streams": "bear.+" }, "dns": false }, } } ```
            "%
            = {
                env
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ToggleableConfig_for_EnvFileConfig,
                    predicates.isType 'Null
                  ])
                  | optional,
                fs
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ToggleableConfig_for_FsUserConfig,
                    predicates.isType 'Null
                  ])
                  | optional,
                network
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ToggleableConfig_for_NetworkFileConfig,
                    predicates.isType 'Null
                  ])
                  | optional,
              },
          FsModeConfig
            | doc m%"
            Configuration for enabling read-only or read-write file operations.
            
            These options are overriden by user specified overrides and mirrord default overrides.
            
            If you set [`"localwithoverrides"`](#feature-fs-mode-localwithoverrides) then some files can be read/write remotely based on our default/user specified. Default option for general file configuration.
            
            The accepted values are: `"local"`, `"localwithoverrides`, `"read"`, or `"write`.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.FsModeConfig,
          FsUserConfig
            | doc m%"
            Changes file operations behavior based on user configuration.
            
            See the file operations [reference](https://mirrord.dev/docs/reference/fileops/) for more details, and [fs advanced](#fs-advanced) for more information on how to fully setup mirrord file operations.
            
            ### Minimal `fs` config {#fs-minimal}
            
            ```json { "feature": { "fs": "read" } } ```
            
            ### Advanced `fs` config {#fs-advanced}
            
            ```json { "feature": { "fs": { "mode": "write", "read_write": ".+\.json" , "read_only": [ ".+\.yaml", ".+important-file\.txt" ], "local": [ ".+\.js", ".+\.mjs" ] } } } ```
            "%
            = predicates.contract_from_predicate
              definitions.predicate.FsUserConfig,
          HttpFilterFileConfig
            | doc m%"
            Filter configuration for the HTTP traffic stealer feature.
            
            Allows the user to set a filter (regex) for the HTTP headers, so that the stealer traffic feature only captures HTTP requests that match the specified filter, forwarding unmatched requests to their original destinations.
            
            Only does something when [`feature.network.incoming.mode`](#feature-network-incoming-mode) is set as `"steal"`, ignored otherwise.
            
            for example, to filter based on header: ```json { "header_filter": "host: api\..+", } ```
            
            for example, to filter based on path ```json { "path_filter": "host: api\..+", } ```
            "%
            = {
                header_filter
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Supports regexes validated by the [`fancy-regex`](https://docs.rs/fancy-regex/latest/fancy_regex/) crate.
                  
                  The HTTP traffic feature converts the HTTP headers to `HeaderKey: HeaderValue`, case-insensitive.
                  "%
                  | optional,
                path_filter
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Supports regexes validated by the [`fancy-regex`](https://docs.rs/fancy-regex/latest/fancy_regex/) crate.
                  
                  Case insensitive.
                  "%
                  | optional,
                ports
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.PortList, predicates.isType 'Null ])
                  | doc m%"
                  Activate the HTTP traffic filter only for these ports.
                  
                  Other ports will still be stolen (when `"steal`" is being used), they're just not checked for HTTP filtering.
                  "%
                  | optional,
              },
          HttpHeaderFilterFileConfig
            | doc m%"
            Filter configuration for the HTTP traffic stealer feature.
            
            DEPRECATED - USE http_filter instead, unless using old operator/agent version (pre 3.46.0) Allows the user to set a filter (regex) for the HTTP headers, so that the stealer traffic feature only captures HTTP requests that match the specified filter, forwarding unmatched requests to their original destinations.
            
            Only does something when [`feature.network.incoming.mode`](#feature-network-incoming-mode) is set as `"steal"`, ignored otherwise.
            
            ```json { "filter": "host: api\..+", "ports": [80, 8080] } ```
            "%
            = {
                filter
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Supports regexes validated by the [`fancy-regex`](https://docs.rs/fancy-regex/latest/fancy_regex/) crate.
                  
                  The HTTP traffic feature converts the HTTP headers to `HeaderKey: HeaderValue`, case-insensitive.
                  "%
                  | optional,
                ports
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.PortList, predicates.isType 'Null ])
                  | doc m%"
                  Activate the HTTP traffic filter only for these ports.
                  
                  Other ports will still be stolen (when `"steal`" is being used), they're just not checked for HTTP filtering.
                  "%
                  | optional,
              },
          IncomingAdvancedFileConfig
            | doc m%"
            Advanced user configuration for network incoming traffic.
            "%
            = {
                http_filter
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ToggleableConfig_for_HttpFilterFileConfig,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Sets up the HTTP traffic filter (currently, only useful when `incoming: steal`).
                  
                  See [`filter`](##filter) for details.
                  "%
                  | optional,
                http_header_filter
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ToggleableConfig_for_HttpHeaderFilterFileConfig,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Sets up the HTTP traffic filter (currently, only useful when `incoming: steal`).
                  
                  See [`filter`](##filter) for details.
                  "%
                  | optional,
                ignore_localhost
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Consider removing when adding https://github.com/metalbear-co/mirrord/issues/702
                  "%
                  | optional,
                ignore_ports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Integer,
                      predicates.numbers.minimum 0
                    ])
                  ])
                  | doc m%"
                  Ports to ignore when mirroring/stealing traffic. Useful if you want specific ports to be used locally only.
                  "%
                  | optional,
                listen_ports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.items
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ]
                      ],
                      predicates.arrays.maxItems 2,
                      predicates.arrays.minItems 2
                    ])
                  ])
                  | doc m%"
                  Mapping for local ports to actually used local ports. When application listens on a port while steal/mirror is active we fallback to random ports to avoid port conflicts. Using this configuration will always use the specified port. If this configuration doesn't exist, mirrord will try to listen on the original port and if it fails it will assign a random port
                  
                  This is useful when you want to access ports exposed by your service locally For example, if you have a service that listens on port `80` and you want to access it, you probably can't listen on `80` without sudo, so you can use `[[80, 4480]]` then access it on `4480` while getting traffic from remote `80`. The value of `port_mapping` doesn't affect this.
                  "%
                  | optional,
                mode
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.IncomingMode,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Allows selecting between mirrorring or stealing traffic.
                  
                  See [`mode`](##mode (incoming)) for details.
                  "%
                  | optional,
                on_concurrent_steal
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ConcurrentSteal,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  (Operator Only): if value of override will force close any other connections on requested target
                  "%
                  | optional,
                port_mapping
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType 'Null ],
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.items
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ]
                      ],
                      predicates.arrays.maxItems 2,
                      predicates.arrays.minItems 2
                    ])
                  ])
                  | doc m%"
                  Mapping for local ports to remote ports.
                  
                  This is useful when you want to mirror/steal a port to a different port on the remote machine. For example, your local process listens on port `9333` and the container listens on port `80`. You'd use `[[9333, 80]]`
                  "%
                  | optional,
                ..
              },
          IncomingFileConfig
            | doc m%"
            Controls the incoming TCP traffic feature.
            
            See the incoming [reference](https://mirrord.dev/docs/reference/traffic/#incoming) for more details.
            
            Incoming traffic supports 2 modes of operation:
            
            1. Mirror (**default**): Sniffs the TCP data from a port, and forwards a copy to the interested listeners;
            
            2. Steal: Captures the TCP data from a port, and forwards it to the local process, see [`steal`](##steal);
            
            ### Minimal `incoming` config
            
            ```json { "feature": { "network": { "incoming": "steal" } } } ```
            
            ### Advanced `incoming` config
            
            ```json { "feature": { "network": { "incoming": { "mode": "steal", "http_header_filter": { "filter": "host: api\..+", "ports": [80, 8080] }, "port_mapping": [[ 7777, 8888 ]], "ignore_localhost": false, "ignore_ports": [9999, 10000] "listen_ports": [[80, 8111]] } } } } ```
            "%
            = predicates.contract_from_predicate
              definitions.predicate.IncomingFileConfig,
          IncomingMode
            | doc m%"
            Allows selecting between mirrorring or stealing traffic.
            
            Can be set to either `"mirror"` (default), `"steal"` or `"off"`.
            
            - `"mirror"`: Sniffs on TCP port, and send a copy of the data to listeners. - `"off"`: Disables the incoming network feature. - `"steal"`: Supports 2 modes of operation:
            
            1. Port traffic stealing: Steals all TCP data from a port, which is selected whenever the user listens in a TCP socket (enabling the feature is enough to make this work, no additional configuration is needed);
            
            2. HTTP traffic stealing: Steals only HTTP traffic, mirrord tries to detect if the incoming data on a port is HTTP (in a best-effort kind of way, not guaranteed to be HTTP), and steals the traffic on the port if it is HTTP;
            "%
            = predicates.contract_from_predicate
              definitions.predicate.IncomingMode,
          InternalProxyFileConfig
            | doc m%"
            Configuration for the internal proxy mirrord spawns for each local mirrord session that local layers use to connect to the remote agent
            
            This is seldom used, but if you get `ConnectionRefused` errors, you might want to increase the timeouts a bit.
            
            ```json { "internal_proxy": { "start_idle_timeout": 30, "idle_timeout": 5, } } ```
            "%
            = {
                idle_timeout
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  How much time to wait while we don't have any active connections before exiting.
                  
                  Common cases would be running a chain of processes that skip using the layer and don't connect to the proxy.
                  
                  ```json { "internal_proxy": { "idle_timeout": 30 } } ```
                  "%
                  | optional,
                start_idle_timeout
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  How much time to wait for the first connection to the proxy in seconds.
                  
                  Common cases would be running with dlv or any other debugger, which sets a breakpoint on process execution, delaying the layer startup and connection to proxy.
                  
                  ```json { "internal_proxy": { "start_idle_timeout": 60 } } ```
                  "%
                  | optional,
              },
          LinuxCapability = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'NET_ADMIN, 'NET_RAW, 'SYS_PTRACE, 'SYS_ADMIN |]
              ],
          NetworkFileConfig
            | doc m%"
            Controls mirrord network operations.
            
            See the network traffic [reference](https://mirrord.dev/docs/reference/traffic/) for more details.
            
            ```json { "feature": { "network": { "incoming": { "mode": "steal", "http_header_filter": { "filter": "host: api\..+", "ports": [80, 8080] }, "port_mapping": [[ 7777, 8888 ]], "ignore_localhost": false, "ignore_ports": [9999, 10000] }, "outgoing": { "tcp": true, "udp": true, "filter": { "local": ["tcp://1.1.1.0/24:1337", "1.1.5.0/24", "google.com", ":53"] }, "ignore_localhost": false, "unix_streams": "bear.+" }, "dns": false } } } ```
            "%
            = {
                dns
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Resolve DNS via the remote pod.
                  
                  Defaults to `true`.
                  "%
                  | optional,
                incoming
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ToggleableConfig_for_IncomingFileConfig,
                    predicates.isType 'Null
                  ])
                  | optional,
                outgoing
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ToggleableConfig_for_OutgoingFileConfig,
                    predicates.isType 'Null
                  ])
                  | optional,
              },
          OutgoingFileConfig
            | doc m%"
            Tunnel outgoing network operations through mirrord.
            
            See the outgoing [reference](https://mirrord.dev/docs/reference/traffic/#outgoing) for more details.
            
            The `remote` and `local` config for this feature are **mutually** exclusive.
            
            ```json { "feature": { "network": { "outgoing": { "tcp": true, "udp": true, "ignore_localhost": false, "filter": { "local": ["tcp://1.1.1.0/24:1337", "1.1.5.0/24", "google.com", ":53"] }, "unix_streams": "bear.+" } } } } ```
            "%
            = {
                filter
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.OutgoingFilterConfig,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Unstable: the precise syntax of this config is subject to change.
                  "%
                  | optional,
                ignore_localhost
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Defaults to `false`.
                  "%
                  | optional,
                tcp
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Defaults to `true`.
                  "%
                  | optional,
                udp
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Defaults to `true`.
                  "%
                  | optional,
                unix_streams
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.VecOrSingle_for_String,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Connect to these unix streams remotely (and to all other paths locally).
                  
                  You can either specify a single value or an array of values. Each value is interpreted as a regular expression ([Supported Syntax](https://docs.rs/regex/1.7.1/regex/index.html#syntax)).
                  
                  When your application connects to a unix socket, the target address will be converted to a string (non-utf8 bytes are replaced by a placeholder character) and matched against the set of regexes specified here. If there is a match, mirrord will connect your application with the target unix socket address on the target pod. Otherwise, it will leave the connection to happen locally on your machine.
                  "%
                  | optional,
              },
          OutgoingFilterConfig
            | doc m%"
            List of addresses/ports/subnets that should be sent through either the remote pod or local app, depending how you set this up with either `remote` or `local`.
            
            You may use this option to specify when outgoing traffic is sent from the remote pod (which is the default behavior when you enable outgoing traffic), or from the local app (default when you have outgoing traffic disabled).
            
            Takes a list of values, such as:
            
            - Only UDP traffic on subnet `1.1.1.0/24` on port 1337 will go through the remote pod.
            
            ```json { "remote": ["udp://1.1.1.0/24:1337"] } ```
            
            - Only UDP and TCP traffic on resolved address of `google.com` on port `1337` and `7331` will go through the remote pod. ```json { "remote": ["google.com:1337", "google.com:7331"] } ```
            
            - Only TCP traffic on `localhost` on port 1337 will go through the local app, the rest will be emmited remotely in the cluster.
            
            ```json { "local": ["tcp://localhost:1337"] } ```
            
            - Only outgoing traffic on port `1337` and `7331` will go through the local app. ```json { "local": [":1337", ":7331"] } ```
            
            Valid values follow this pattern: `[protocol]://[name|address|subnet/mask]:[port]`.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.OutgoingFilterConfig,
          PodTarget
            | doc m%"
            <!--${internal}--> Mirror the pod specified by [`PodTarget::pod`].
            "%
            = {
                container
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | optional,
                pod
                  | String
                  | doc m%"
                  <!--${internal}--> Pod to mirror.
                  "%,
                ..
              },
          PortList
            | doc m%"
            <!--${internal}--> Helper struct for setting up ports configuration (part of the HTTP traffic stealer feature).
            
            Defaults to a list of ports `[80, 8080]`.
            
            We use this to allow implementing a custom [`Default`] initialization, as the [`MirrordConfig`] macro (currently) doesn't support more intricate expressions.
            "%
            = predicates.contract_from_predicate definitions.predicate.PortList,
          RolloutTarget
            | doc m%"
            <!--${internal}--> Mirror the rollout specified by [`RolloutTarget::rollout`].
            "%
            = {
                container
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | optional,
                rollout
                  | String
                  | doc m%"
                  <!--${internal}--> Rollout to mirror.
                  "%,
                ..
              },
          Target
            | doc m%"
            <!--${internal}--> ## path
            
            Specifies the running pod (or deployment) to mirror.
            
            Supports: - `pod/{sample-pod}`; - `podname/{sample-pod}`; - `deployment/{sample-deployment}`; - `container/{sample-container}`; - `containername/{sample-container}`.
            "%
            = predicates.contract_from_predicate definitions.predicate.Target,
          TargetFileConfig = predicates.contract_from_predicate
              definitions.predicate.TargetFileConfig,
          ToggleableConfig_for_EnvFileConfig =
            predicates.contract_from_predicate
              definitions.predicate.ToggleableConfig_for_EnvFileConfig,
          ToggleableConfig_for_FsUserConfig = predicates.contract_from_predicate
              definitions.predicate.ToggleableConfig_for_FsUserConfig,
          ToggleableConfig_for_HttpFilterFileConfig =
            predicates.contract_from_predicate
              definitions.predicate.ToggleableConfig_for_HttpFilterFileConfig,
          ToggleableConfig_for_HttpHeaderFilterFileConfig =
            predicates.contract_from_predicate
              definitions.predicate.ToggleableConfig_for_HttpHeaderFilterFileConfig,
          ToggleableConfig_for_IncomingFileConfig =
            predicates.contract_from_predicate
              definitions.predicate.ToggleableConfig_for_IncomingFileConfig,
          ToggleableConfig_for_NetworkFileConfig =
            predicates.contract_from_predicate
              definitions.predicate.ToggleableConfig_for_NetworkFileConfig,
          ToggleableConfig_for_OutgoingFileConfig =
            predicates.contract_from_predicate
              definitions.predicate.ToggleableConfig_for_OutgoingFileConfig,
          VecOrSingle_for_String = predicates.contract_from_predicate
              definitions.predicate.VecOrSingle_for_String,
          VecOrSingle_for_uint16 = predicates.contract_from_predicate
              definitions.predicate.VecOrSingle_for_uint16,
          "io.k8s.api.core.v1.ResourceRequirements"
            | doc m%"
            ResourceRequirements describes the compute resource requirements.
            "%
            = {
                limits
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.k8s.apimachinery.pkg.api.resource.Quantity"
                  ])
                  | doc m%"
                  Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
                  "%
                  | optional,
                requests
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.k8s.apimachinery.pkg.api.resource.Quantity"
                  ])
                  | doc m%"
                  Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.Toleration"
            | doc m%"
            The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>.
            "%
            = {
                effect
                  | String
                  | doc m%"
                  Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute.
                  
                  "%
                  | optional,
                key
                  | String
                  | doc m%"
                  Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys.
                  "%
                  | optional,
                operator
                  | String
                  | doc m%"
                  Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category.
                  
                  "%
                  | optional,
                tolerationSeconds
                  | std.number.Integer
                  | doc m%"
                  TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system.
                  "%
                  | optional,
                value
                  | String
                  | doc m%"
                  Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string.
                  "%
                  | optional,
                ..
              },
          "io.k8s.apimachinery.pkg.api.resource.Quantity"
            | doc m%"
            Quantity is a fixed-point representation of a number. It provides convenient marshaling/unmarshaling in JSON and YAML, in addition to String() and AsInt64() accessors.
            
            The serialization format is:
            
            <quantity>        ::= <signedNumber><suffix>
            
            	(Note that <suffix> may be empty, from the "" case in <decimalSI>.)
            
            <digit>           ::= 0 | 1 | ... | 9 <digits>          ::= <digit> | <digit><digits> <number>          ::= <digits> | <digits>.<digits> | <digits>. | .<digits> <sign>            ::= "+" | "-" <signedNumber>    ::= <number> | <sign><number> <suffix>          ::= <binarySI> | <decimalExponent> | <decimalSI> <binarySI>        ::= Ki | Mi | Gi | Ti | Pi | Ei
            
            	(International System of units; See: http://physics.nist.gov/cuu/Units/binary.html)
            
            <decimalSI>       ::= m | "" | k | M | G | T | P | E
            
            	(Note that 1024 = 1Ki but 1000 = 1k; I didn't choose the capitalization.)
            
            <decimalExponent> ::= "e" <signedNumber> | "E" <signedNumber>
            
            No matter which of the three exponent forms is used, no quantity may represent a number greater than 2^63-1 in magnitude, nor may it have more than 3 decimal places. Numbers larger or more precise will be capped or rounded up. (E.g.: 0.1m will rounded up to 1m.) This may be extended in the future if we require larger or smaller quantities.
            
            When a Quantity is parsed from a string, it will remember the type of suffix it had, and will use the same type again when it is serialized.
            
            Before serializing, Quantity will be put in "canonical form". This means that Exponent/suffix will be adjusted up or down (with a corresponding increase or decrease in Mantissa) such that:
            
            	a. No precision is lost
            	b. No fractional digits will be emitted
            	c. The exponent (or suffix) is as large as possible.
            
            The sign will be omitted unless the number is negative.
            
            Examples:
            
            	1.5 will be serialized as "1500m"
            	1.5Gi will be serialized as "1536Mi"
            
            Note that the quantity will NEVER be internally represented by a floating point number. That is the whole point of this exercise.
            
            Non-canonical values will still parse as long as they are well formed, but will be re-emitted in their canonical form. (So always use canonical form, or don't diff.)
            
            This format is intended to make it difficult to use these numbers without writing some sort of special handling code in the hopes that that will cause implementors to also use a fixed point implementation.
            "%
            = String,
        },
    predicate = {
          AdvancedFsUserConfig
            | doc m%"
            Allows the user to specify the default behavior for file operations:
            
            1. `"read"` - Read from the remote file system (default) 2. `"write"` - Read/Write from the remote file system. 3. `"local"` - Read from the local file system. 5. `"disable"` - Disable file operations.
            
            Besides the default behavior, the user can specify behavior for specific regex patterns. Case insensitive.
            
            1. `"read_write"` - List of patterns that should be read/write remotely. 2. `"read_only"` - List of patterns that should be read only remotely. 3. `"local"` - List of patterns that should be read locally. 4. `"not_found"` - List of patters that should never be read nor written. These files should be treated as non-existent.
            
            The logic for choosing the behavior is as follows:
            
            1. Check if one of the patterns match the file path, do the corresponding action. There's no specified order if two lists match the same path, we will use the first one (and we do not guarantee what is first).
            
            **Warning**: Specifying the same path in two lists is unsupported and can lead to undefined behaviour.
            
            2. Check our "special list" - we have an internal at compile time list for different behavior based on patterns to provide better UX.
            
            3. If none of the above match, use the default behavior (mode).
            
            For more information, check the file operations [technical reference](https://mirrord.dev/docs/reference/fileops/).
            
            ```json { "feature": { "fs": { "mode": "write", "read_write": ".+\.json" , "read_only": [ ".+\.yaml", ".+important-file\.txt" ], "local": [ ".+\.js", ".+\.mjs" ], "not_found": [ "\.config/gcloud" ] } } } ```
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  local = predicates.anyOf
                      [
                        definitions.predicate.VecOrSingle_for_String,
                        predicates.isType 'Null
                      ],
                  mode = predicates.anyOf
                      [
                        definitions.predicate.FsModeConfig,
                        predicates.isType 'Null
                      ],
                  not_found = predicates.anyOf
                      [
                        definitions.predicate.VecOrSingle_for_String,
                        predicates.isType 'Null
                      ],
                  read_only = predicates.anyOf
                      [
                        definitions.predicate.VecOrSingle_for_String,
                        predicates.isType 'Null
                      ],
                  read_write = predicates.anyOf
                      [
                        definitions.predicate.VecOrSingle_for_String,
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          AgentFileConfig
            | doc m%"
            Configuration for the mirrord-agent pod that is spawned in the Kubernetes cluster.
            
            We provide sane defaults for this option, so you don't have to set up anything here.
            
            ```json { "agent": { "log_level": "info", "namespace": "default", "image": "ghcr.io/metalbear-co/mirrord:latest", "image_pull_policy": "IfNotPresent", "image_pull_secrets": [ { "secret-key": "secret" } ], "ttl": 30, "ephemeral": false, "communication_timeout": 30, "startup_timeout": 360, "network_interface": "eth0", "pause": false, "flush_connections": false, } } ```
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  check_out_of_pods = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  communication_timeout = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                        predicates.numbers.minimum 0
                      ],
                  disabled_capabilities = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate.LinuxCapability
                      ],
                  ephemeral = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  flush_connections = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  image = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  image_pull_policy = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  image_pull_secrets = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ])
                      ],
                  log_level = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  namespace = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  network_interface = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  privileged = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  resources = predicates.anyOf
                      [
                        definitions.predicate."io.k8s.api.core.v1.ResourceRequirements",
                        predicates.isType 'Null
                      ],
                  startup_timeout = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                        predicates.numbers.minimum 0
                      ],
                  tolerations = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.Toleration"
                      ],
                  ttl = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ConcurrentSteal
            | doc m%"
            (Operator Only): Allows overriding port locks
            
            Can be set to either `"continue"` or `"override"`.
            
            - `"continue"`: Continue with normal execution - `"override"`: If port lock detected then override it with new lock and force close the original locking connection.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "override" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "continue" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "abort" ] ]
              ],
          DeploymentTarget
            | doc m%"
            <!--${internal}--> Mirror the deployment specified by [`DeploymentTarget::deployment`].
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "deployment" ],
                predicates.records.record
                {
                  container = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  deployment = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          EnvFileConfig
            | doc m%"
            Allows the user to set or override the local process' environment variables with the ones from the remote pod.
            
            Which environment variables to load from the remote pod are controlled by setting either [`include`](#feature-env-include) or [`exclude`](#feature-env-exclude).
            
            See the environment variables [reference](https://mirrord.dev/docs/reference/env/) for more details.
            
            ```json { "feature": { "env": { "include": "DATABASE_USER;PUBLIC_ENV", "exclude": "DATABASE_PASSWORD;SECRET_ENV", "override": { "DATABASE_CONNECTION": "db://localhost:7777/my-db", "LOCAL_BEAR": "panda" } } } } ```
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  exclude = predicates.anyOf
                      [
                        definitions.predicate.VecOrSingle_for_String,
                        predicates.isType 'Null
                      ],
                  include = predicates.anyOf
                      [
                        definitions.predicate.VecOrSingle_for_String,
                        predicates.isType 'Null
                      ],
                  override = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Record, predicates.isType 'Null ],
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FeatureFileConfig
            | doc m%"
            Controls mirrord features.
            
            See the [technical reference, Technical Reference](https://mirrord.dev/docs/reference/) to learn more about what each feature does.
            
            The [`env`](#feature-env), [`fs`](#feature-fs) and [`network`](#feature-network) options have support for a shortened version, that you can see [here](#root-shortened).
            
            ```json { "feature": { "env": { "include": "DATABASE_USER;PUBLIC_ENV", "exclude": "DATABASE_PASSWORD;SECRET_ENV", "override": { "DATABASE_CONNECTION": "db://localhost:7777/my-db", "LOCAL_BEAR": "panda" } }, "fs": { "mode": "write", "read_write": ".+\.json" , "read_only": [ ".+\.yaml", ".+important-file\.txt" ], "local": [ ".+\.js", ".+\.mjs" ] }, "network": { "incoming": { "mode": "steal", "http_header_filter": { "filter": "host: api\..+", "ports": [80, 8080] }, "port_mapping": [[ 7777, 8888 ]], "ignore_localhost": false, "ignore_ports": [9999, 10000] }, "outgoing": { "tcp": true, "udp": true, "filter": { "local": ["tcp://1.1.1.0/24:1337", "1.1.5.0/24", "google.com", ":53"] }, "ignore_localhost": false, "unix_streams": "bear.+" }, "dns": false }, } } ```
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  env = predicates.anyOf
                      [
                        definitions.predicate.ToggleableConfig_for_EnvFileConfig,
                        predicates.isType 'Null
                      ],
                  fs = predicates.anyOf
                      [
                        definitions.predicate.ToggleableConfig_for_FsUserConfig,
                        predicates.isType 'Null
                      ],
                  network = predicates.anyOf
                      [
                        definitions.predicate.ToggleableConfig_for_NetworkFileConfig,
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FsModeConfig
            | doc m%"
            Configuration for enabling read-only or read-write file operations.
            
            These options are overriden by user specified overrides and mirrord default overrides.
            
            If you set [`"localwithoverrides"`](#feature-fs-mode-localwithoverrides) then some files can be read/write remotely based on our default/user specified. Default option for general file configuration.
            
            The accepted values are: `"local"`, `"localwithoverrides`, `"read"`, or `"write`.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "local" ] ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "localwithoverrides" ]
                ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "read" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "write" ] ]
              ],
          FsUserConfig
            | doc m%"
            Changes file operations behavior based on user configuration.
            
            See the file operations [reference](https://mirrord.dev/docs/reference/fileops/) for more details, and [fs advanced](#fs-advanced) for more information on how to fully setup mirrord file operations.
            
            ### Minimal `fs` config {#fs-minimal}
            
            ```json { "feature": { "fs": "read" } } ```
            
            ### Advanced `fs` config {#fs-advanced}
            
            ```json { "feature": { "fs": { "mode": "write", "read_write": ".+\.json" , "read_only": [ ".+\.yaml", ".+important-file\.txt" ], "local": [ ".+\.js", ".+\.mjs" ] } } } ```
            "%
            = predicates.anyOf
              [
                definitions.predicate.FsModeConfig,
                definitions.predicate.AdvancedFsUserConfig
              ],
          HttpFilterFileConfig
            | doc m%"
            Filter configuration for the HTTP traffic stealer feature.
            
            Allows the user to set a filter (regex) for the HTTP headers, so that the stealer traffic feature only captures HTTP requests that match the specified filter, forwarding unmatched requests to their original destinations.
            
            Only does something when [`feature.network.incoming.mode`](#feature-network-incoming-mode) is set as `"steal"`, ignored otherwise.
            
            for example, to filter based on header: ```json { "header_filter": "host: api\..+", } ```
            
            for example, to filter based on path ```json { "path_filter": "host: api\..+", } ```
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  header_filter = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  path_filter = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  ports = predicates.anyOf
                      [
                        definitions.predicate.PortList,
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          HttpHeaderFilterFileConfig
            | doc m%"
            Filter configuration for the HTTP traffic stealer feature.
            
            DEPRECATED - USE http_filter instead, unless using old operator/agent version (pre 3.46.0) Allows the user to set a filter (regex) for the HTTP headers, so that the stealer traffic feature only captures HTTP requests that match the specified filter, forwarding unmatched requests to their original destinations.
            
            Only does something when [`feature.network.incoming.mode`](#feature-network-incoming-mode) is set as `"steal"`, ignored otherwise.
            
            ```json { "filter": "host: api\..+", "ports": [80, 8080] } ```
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  filter = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  ports = predicates.anyOf
                      [
                        definitions.predicate.PortList,
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          IncomingAdvancedFileConfig
            | doc m%"
            Advanced user configuration for network incoming traffic.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  http_filter = predicates.anyOf
                      [
                        definitions.predicate.ToggleableConfig_for_HttpFilterFileConfig,
                        predicates.isType 'Null
                      ],
                  http_header_filter = predicates.anyOf
                      [
                        definitions.predicate.ToggleableConfig_for_HttpHeaderFilterFileConfig,
                        predicates.isType 'Null
                      ],
                  ignore_localhost = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  ignore_ports = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ])
                      ],
                  listen_ports = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.items
                          [
                            predicates.allOf
                            [
                              predicates.isType 'Integer,
                              predicates.numbers.minimum 0
                            ],
                            predicates.allOf
                            [
                              predicates.isType 'Integer,
                              predicates.numbers.minimum 0
                            ]
                          ],
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2
                        ])
                      ],
                  mode = predicates.anyOf
                      [
                        definitions.predicate.IncomingMode,
                        predicates.isType 'Null
                      ],
                  on_concurrent_steal = predicates.anyOf
                      [
                        definitions.predicate.ConcurrentSteal,
                        predicates.isType 'Null
                      ],
                  port_mapping = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.items
                          [
                            predicates.allOf
                            [
                              predicates.isType 'Integer,
                              predicates.numbers.minimum 0
                            ],
                            predicates.allOf
                            [
                              predicates.isType 'Integer,
                              predicates.numbers.minimum 0
                            ]
                          ],
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2
                        ])
                      ],
                }
                {  }
                true
                predicates.always
              ],
          IncomingFileConfig
            | doc m%"
            Controls the incoming TCP traffic feature.
            
            See the incoming [reference](https://mirrord.dev/docs/reference/traffic/#incoming) for more details.
            
            Incoming traffic supports 2 modes of operation:
            
            1. Mirror (**default**): Sniffs the TCP data from a port, and forwards a copy to the interested listeners;
            
            2. Steal: Captures the TCP data from a port, and forwards it to the local process, see [`steal`](##steal);
            
            ### Minimal `incoming` config
            
            ```json { "feature": { "network": { "incoming": "steal" } } } ```
            
            ### Advanced `incoming` config
            
            ```json { "feature": { "network": { "incoming": { "mode": "steal", "http_header_filter": { "filter": "host: api\..+", "ports": [80, 8080] }, "port_mapping": [[ 7777, 8888 ]], "ignore_localhost": false, "ignore_ports": [9999, 10000] "listen_ports": [[80, 8111]] } } } } ```
            "%
            = predicates.anyOf
              [
                predicates.anyOf
                [ definitions.predicate.IncomingMode, predicates.isType 'Null ],
                definitions.predicate.IncomingAdvancedFileConfig
              ],
          IncomingMode
            | doc m%"
            Allows selecting between mirrorring or stealing traffic.
            
            Can be set to either `"mirror"` (default), `"steal"` or `"off"`.
            
            - `"mirror"`: Sniffs on TCP port, and send a copy of the data to listeners. - `"off"`: Disables the incoming network feature. - `"steal"`: Supports 2 modes of operation:
            
            1. Port traffic stealing: Steals all TCP data from a port, which is selected whenever the user listens in a TCP socket (enabling the feature is enough to make this work, no additional configuration is needed);
            
            2. HTTP traffic stealing: Steals only HTTP traffic, mirrord tries to detect if the incoming data on a port is HTTP (in a best-effort kind of way, not guaranteed to be HTTP), and steals the traffic on the port if it is HTTP;
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "mirror" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "steal" ] ],
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "off" ] ]
              ],
          InternalProxyFileConfig
            | doc m%"
            Configuration for the internal proxy mirrord spawns for each local mirrord session that local layers use to connect to the remote agent
            
            This is seldom used, but if you get `ConnectionRefused` errors, you might want to increase the timeouts a bit.
            
            ```json { "internal_proxy": { "start_idle_timeout": 30, "idle_timeout": 5, } } ```
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  idle_timeout = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                        predicates.numbers.minimum 0
                      ],
                  start_idle_timeout = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                false
                predicates.never
              ],
          LinuxCapability = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "SYS_ADMIN", "SYS_PTRACE", "NET_RAW", "NET_ADMIN" ]
              ],
          NetworkFileConfig
            | doc m%"
            Controls mirrord network operations.
            
            See the network traffic [reference](https://mirrord.dev/docs/reference/traffic/) for more details.
            
            ```json { "feature": { "network": { "incoming": { "mode": "steal", "http_header_filter": { "filter": "host: api\..+", "ports": [80, 8080] }, "port_mapping": [[ 7777, 8888 ]], "ignore_localhost": false, "ignore_ports": [9999, 10000] }, "outgoing": { "tcp": true, "udp": true, "filter": { "local": ["tcp://1.1.1.0/24:1337", "1.1.5.0/24", "google.com", ":53"] }, "ignore_localhost": false, "unix_streams": "bear.+" }, "dns": false } } } ```
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  dns = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  incoming = predicates.anyOf
                      [
                        definitions.predicate.ToggleableConfig_for_IncomingFileConfig,
                        predicates.isType 'Null
                      ],
                  outgoing = predicates.anyOf
                      [
                        definitions.predicate.ToggleableConfig_for_OutgoingFileConfig,
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          OutgoingFileConfig
            | doc m%"
            Tunnel outgoing network operations through mirrord.
            
            See the outgoing [reference](https://mirrord.dev/docs/reference/traffic/#outgoing) for more details.
            
            The `remote` and `local` config for this feature are **mutually** exclusive.
            
            ```json { "feature": { "network": { "outgoing": { "tcp": true, "udp": true, "ignore_localhost": false, "filter": { "local": ["tcp://1.1.1.0/24:1337", "1.1.5.0/24", "google.com", ":53"] }, "unix_streams": "bear.+" } } } } ```
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  filter = predicates.anyOf
                      [
                        definitions.predicate.OutgoingFilterConfig,
                        predicates.isType 'Null
                      ],
                  ignore_localhost = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  tcp = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  udp = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  unix_streams = predicates.anyOf
                      [
                        definitions.predicate.VecOrSingle_for_String,
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          OutgoingFilterConfig
            | doc m%"
            List of addresses/ports/subnets that should be sent through either the remote pod or local app, depending how you set this up with either `remote` or `local`.
            
            You may use this option to specify when outgoing traffic is sent from the remote pod (which is the default behavior when you enable outgoing traffic), or from the local app (default when you have outgoing traffic disabled).
            
            Takes a list of values, such as:
            
            - Only UDP traffic on subnet `1.1.1.0/24` on port 1337 will go through the remote pod.
            
            ```json { "remote": ["udp://1.1.1.0/24:1337"] } ```
            
            - Only UDP and TCP traffic on resolved address of `google.com` on port `1337` and `7331` will go through the remote pod. ```json { "remote": ["google.com:1337", "google.com:7331"] } ```
            
            - Only TCP traffic on `localhost` on port 1337 will go through the local app, the rest will be emmited remotely in the cluster.
            
            ```json { "local": ["tcp://localhost:1337"] } ```
            
            - Only outgoing traffic on port `1337` and `7331` will go through the local app. ```json { "local": [":1337", ":7331"] } ```
            
            Valid values follow this pattern: `[protocol]://[name|address|subnet/mask]:[port]`.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "remote" ],
                  predicates.records.record
                  { remote = definitions.predicate.VecOrSingle_for_String, }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "local" ],
                  predicates.records.record
                  { local = definitions.predicate.VecOrSingle_for_String, }
                  {  }
                  false
                  predicates.never
                ]
              ],
          PodTarget
            | doc m%"
            <!--${internal}--> Mirror the pod specified by [`PodTarget::pod`].
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "pod" ],
                predicates.records.record
                {
                  container = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  pod = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          PortList
            | doc m%"
            <!--${internal}--> Helper struct for setting up ports configuration (part of the HTTP traffic stealer feature).
            
            Defaults to a list of ports `[80, 8080]`.
            
            We use this to allow implementing a custom [`Default`] initialization, as the [`MirrordConfig`] macro (currently) doesn't support more intricate expressions.
            "%
            = definitions.predicate.VecOrSingle_for_uint16,
          RolloutTarget
            | doc m%"
            <!--${internal}--> Mirror the rollout specified by [`RolloutTarget::rollout`].
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "rollout" ],
                predicates.records.record
                {
                  container = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  rollout = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Target
            | doc m%"
            <!--${internal}--> ## path
            
            Specifies the running pod (or deployment) to mirror.
            
            Supports: - `pod/{sample-pod}`; - `podname/{sample-pod}`; - `deployment/{sample-deployment}`; - `container/{sample-container}`; - `containername/{sample-container}`.
            "%
            = predicates.anyOf
              [
                definitions.predicate.DeploymentTarget,
                definitions.predicate.PodTarget,
                definitions.predicate.RolloutTarget,
                predicates.isType 'Null
              ],
          TargetFileConfig = predicates.anyOf
              [
                predicates.anyOf
                [ definitions.predicate.Target, predicates.isType 'Null ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    namespace = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                    path = predicates.anyOf
                        [
                          definitions.predicate.Target,
                          predicates.isType 'Null
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          ToggleableConfig_for_EnvFileConfig = predicates.anyOf
              [
                predicates.isType '"Bool",
                definitions.predicate.EnvFileConfig
              ],
          ToggleableConfig_for_FsUserConfig = predicates.anyOf
              [ predicates.isType '"Bool", definitions.predicate.FsUserConfig ],
          ToggleableConfig_for_HttpFilterFileConfig = predicates.anyOf
              [
                predicates.isType '"Bool",
                definitions.predicate.HttpFilterFileConfig
              ],
          ToggleableConfig_for_HttpHeaderFilterFileConfig = predicates.anyOf
              [
                predicates.isType '"Bool",
                definitions.predicate.HttpHeaderFilterFileConfig
              ],
          ToggleableConfig_for_IncomingFileConfig = predicates.anyOf
              [
                predicates.isType '"Bool",
                definitions.predicate.IncomingFileConfig
              ],
          ToggleableConfig_for_NetworkFileConfig = predicates.anyOf
              [
                predicates.isType '"Bool",
                definitions.predicate.NetworkFileConfig
              ],
          ToggleableConfig_for_OutgoingFileConfig = predicates.anyOf
              [
                predicates.isType '"Bool",
                definitions.predicate.OutgoingFileConfig
              ],
          VecOrSingle_for_String = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
          VecOrSingle_for_uint16 = predicates.anyOf
              [
                predicates.allOf
                [ predicates.isType 'Integer, predicates.numbers.minimum 0 ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                ]
              ],
          "io.k8s.api.core.v1.ResourceRequirements"
            | doc m%"
            ResourceRequirements describes the compute resource requirements.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  limits = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.k8s.apimachinery.pkg.api.resource.Quantity"
                      ],
                  requests = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.k8s.apimachinery.pkg.api.resource.Quantity"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.Toleration"
            | doc m%"
            The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  effect = predicates.isType '"String",
                  key = predicates.isType '"String",
                  operator = predicates.isType '"String",
                  tolerationSeconds = predicates.isType 'Integer,
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.apimachinery.pkg.api.resource.Quantity"
            | doc m%"
            Quantity is a fixed-point representation of a number. It provides convenient marshaling/unmarshaling in JSON and YAML, in addition to String() and AsInt64() accessors.
            
            The serialization format is:
            
            <quantity>        ::= <signedNumber><suffix>
            
            	(Note that <suffix> may be empty, from the "" case in <decimalSI>.)
            
            <digit>           ::= 0 | 1 | ... | 9 <digits>          ::= <digit> | <digit><digits> <number>          ::= <digits> | <digits>.<digits> | <digits>. | .<digits> <sign>            ::= "+" | "-" <signedNumber>    ::= <number> | <sign><number> <suffix>          ::= <binarySI> | <decimalExponent> | <decimalSI> <binarySI>        ::= Ki | Mi | Gi | Ti | Pi | Ei
            
            	(International System of units; See: http://physics.nist.gov/cuu/Units/binary.html)
            
            <decimalSI>       ::= m | "" | k | M | G | T | P | E
            
            	(Note that 1024 = 1Ki but 1000 = 1k; I didn't choose the capitalization.)
            
            <decimalExponent> ::= "e" <signedNumber> | "E" <signedNumber>
            
            No matter which of the three exponent forms is used, no quantity may represent a number greater than 2^63-1 in magnitude, nor may it have more than 3 decimal places. Numbers larger or more precise will be capped or rounded up. (E.g.: 0.1m will rounded up to 1m.) This may be extended in the future if we require larger or smaller quantities.
            
            When a Quantity is parsed from a string, it will remember the type of suffix it had, and will use the same type again when it is serialized.
            
            Before serializing, Quantity will be put in "canonical form". This means that Exponent/suffix will be adjusted up or down (with a corresponding increase or decrease in Mantissa) such that:
            
            	a. No precision is lost
            	b. No fractional digits will be emitted
            	c. The exponent (or suffix) is as large as possible.
            
            The sign will be omitted unless the number is negative.
            
            Examples:
            
            	1.5 will be serialized as "1500m"
            	1.5Gi will be serialized as "1536Mi"
            
            Note that the quantity will NEVER be internally represented by a floating point number. That is the whole point of this exercise.
            
            Non-canonical values will still parse as long as they are well formed, but will be re-emitted in their canonical form. (So always use canonical form, or don't diff.)
            
            This format is intended to make it difficult to use these numbers without writing some sort of special handling code in the hopes that that will cause implementors to also use a fixed point implementation.
            "%
            = predicates.isType '"String",
        },
  }
in

{
  accept_invalid_certificates
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Controls whether or not mirrord accepts invalid TLS certificates (e.g. self-signed certificates).
    
    Defaults to `false`.
    "%
    | optional,
  agent
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.AgentFileConfig, predicates.isType 'Null ])
    | optional,
  connect_tcp
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"String", predicates.isType 'Null ])
    | doc m%"
    IP:PORT to connect to instead of using k8s api, for testing purposes.
    
    ```json { "connect_tcp": "10.10.0.100:7777" } ```
    "%
    | optional,
  feature
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.FeatureFileConfig, predicates.isType 'Null ])
    | optional,
  internal_proxy
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.InternalProxyFileConfig, predicates.isType 'Null ])
    | optional,
  kube_context
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"String", predicates.isType 'Null ])
    | doc m%"
    Kube context to use from the kubeconfig file. Will use current context if not specified.
    
    ```json { "kube_context": "mycluster" } ```
    "%
    | optional,
  kubeconfig
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"String", predicates.isType 'Null ])
    | doc m%"
    Path to a kubeconfig file, if not specified, will use `KUBECONFIG`, or `~/.kube/config`, or the in-cluster config.
    
    ```json { "kubeconfig": "~/bear/kube-config" } ```
    "%
    | optional,
  operator
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Allow to lookup if operator is installed on cluster and use it.
    
    Defaults to `true`.
    "%
    | optional,
  pause
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Controls target pause feature. Unstable.
    
    With this feature enabled, the remote container is paused while this layer is connected to the agent.
    
    Note: It requires agent configuration to be set to privileged when running with the ephemeral agent option. Defaults to `false`. Note2: Pause + ephemeral might not work on Docker runtimes.
    "%
    | optional,
  sip_binaries
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.VecOrSingle_for_String, predicates.isType 'Null ])
    | doc m%"
    Binaries to patch (macOS SIP).
    
    Use this when mirrord isn't loaded to protected binaries that weren't automatically patched.
    
    Runs `endswith` on the binary path (so `bash` would apply to any binary ending with `bash` while `/usr/bin/bash` would apply only for that binary).
    
    ```json { "sip_binaries": "bash;python" } ```
    "%
    | optional,
  skip_build_tools
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Allows mirrord to skip build tools. Useful when running command lines that build and run the application in a single command.
    
    Defaults to `true`.
    
    Build-Tools: `["as", "cc", "ld", "go", "air", "asm", "cc1", "cgo", "dlv", "gcc", "git", "link", "math", "cargo", "hpack", "rustc", "compile", "collect2", "cargo-watch", "debugserver"]`
    "%
    | optional,
  skip_processes
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.VecOrSingle_for_String, predicates.isType 'Null ])
    | doc m%"
    Allows mirrord to skip unwanted processes.
    
    Useful when process A spawns process B, and the user wants mirrord to operate only on process B. Accepts a single value, or multiple values separated by `;`.
    
    ```json { "skip_processes": "bash;node" } ```
    "%
    | optional,
  target
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.TargetFileConfig, predicates.isType 'Null ])
    | optional,
  telemetry
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool", predicates.isType 'Null ])
    | doc m%"
    Controls whether or not mirrord sends telemetry data to MetalBear cloud. Telemetry sent doesn't contain personal identifiers or any data that should be considered sensitive. It is used to improve the product. [For more information](https://github.com/metalbear-co/mirrord/blob/main/TELEMETRY.md)
    "%
    | optional,
}