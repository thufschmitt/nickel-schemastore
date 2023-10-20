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
          Action = predicates.contract_from_predicate
              definitions.predicate.Action,
          ActionChain
            | doc m%"
            A chain of actions in sequential order
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ActionChain,
          ActionType
            | doc m%"
            An identifier/name for an action
            "%
            = String,
          AwaitReference
            | doc m%"
            A reference that returns its result after the value at the referenced path is received
            "%
            = predicates.contract_from_predicate
              definitions.predicate.AwaitReference,
          Boolean
            | doc m%"
            A boolean value is either one of "true", true, "false", or false
            "%
            = predicates.contract_from_predicate definitions.predicate.Boolean,
          Border
            | doc m%"
            Border styles
            "%
            = predicates.contract_from_predicate definitions.predicate.Border,
          BorderPreset1
            | doc m%"
            Removes border including the radius
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BorderPreset1,
          BorderPreset2
            | doc m%"
            Removes border from all sides (including radius) except the bottom. This will create an underline effect
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BorderPreset2,
          BorderPreset3
            | doc m%"
            Applies a solid border to all sides
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BorderPreset3,
          BorderPreset4
            | doc m%"
            Sets the border to be a dashed border
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BorderPreset4,
          BorderPreset5
            | doc m%"
            Removes border from all sides
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BorderPreset5,
          BorderPreset6
            | doc m%"
            Sets the border to be a solid border. This will also remove border radius from all sides
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BorderPreset6,
          BorderStylePreset
            | doc m%"
            A set of border presets, each applying a different style
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BorderStylePreset,
          BuiltInEval
            | doc m%"
            Objects that become built in functions when parsed/serialized
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BuiltInEval,
          Color = predicates.contract_from_predicate
              definitions.predicate.Color,
          Component
            | doc m%"
            Components are the building blocks that construct to user interfaces
            "%
            = {
                audioStream | Bool | optional,
                borderRadius | definitions.contract.NoodlUnit | optional,
                children
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.oneOf
                    [
                      definitions.predicate.Component,
                      definitions.predicate.Reference
                    ])
                  ])
                  | optional,
                contentType | definitions.contract.ContentType | optional,
                dataKey | definitions.contract.DataKey | optional,
                ecosObj | String | optional,
                global | definitions.contract.Boolean | optional,
                image | String | optional,
                imgPath | String | optional,
                isEdit | definitions.contract.Boolean | optional,
                isEditable
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Boolean,
                    predicates.isType '"String"
                  ])
                  | optional,
                itemObject
                  | String
                  | doc m%"
                  This is a common value used for iteratorVar
                  "%
                  | optional,
                iteratorVar | String | optional,
                listObject
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Empty,
                    definitions.predicate.Reference,
                    predicates.isType '"Array"
                  ])
                  | optional,
                onBlur
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.ActionChain,
                    definitions.predicate.UserEvent
                  ])
                  | optional,
                onChange
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.ActionChain,
                    definitions.predicate.UserEvent
                  ])
                  | optional,
                onClick
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.ActionChain,
                    definitions.predicate.UserEvent
                  ])
                  | optional,
                onEvent | String | optional,
                onFocus
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.ActionChain,
                    definitions.predicate.UserEvent
                  ])
                  | optional,
                onHover
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.ActionChain,
                    definitions.predicate.UserEvent
                  ])
                  | optional,
                onInput
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.ActionChain,
                    definitions.predicate.UserEvent
                  ])
                  | optional,
                onMouseEnter
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.ActionChain,
                    definitions.predicate.UserEvent
                  ])
                  | optional,
                onMouseLeave
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.ActionChain,
                    definitions.predicate.UserEvent
                  ])
                  | optional,
                onMouseOut
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.ActionChain,
                    definitions.predicate.UserEvent
                  ])
                  | optional,
                onMouseOver
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.ActionChain,
                    definitions.predicate.UserEvent
                  ])
                  | optional,
                options
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Array" ])
                  | optional,
                overflow | String | optional,
                path | definitions.contract.Path | optional,
                placeholder
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.If,
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      { emit = definitions.predicate.Emit, }
                      {  }
                      true
                      predicates.always
                    ]
                  ])
                  | optional,
                popUpView | String | optional,
                postMessage | Array Dyn | optional,
                poster
                  | String
                  | doc m%"
                  A cover image used on video components. When a video has not been interacted with by a user, a cover image is displayed. This value can be used for the cover image
                  "%
                  | optional,
                required
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | optional,
                resource | String | optional,
                style | definitions.contract.Style | optional,
                text | definitions.contract.Text | optional,
                "text=func"
                  | String
                  | doc m%"
                  A function to transform a component's text. A component must have the 'text' property.
                  "%
                  | optional,
                textAlign | definitions.contract.TextAlign | optional,
                textBoard | definitions.contract.TextBoard | optional,
                type | definitions.contract.ComponentType | optional,
                videoFormat | String | optional,
                videoStream | Bool | optional,
                viewTag | definitions.contract.ViewTag | optional,
                zIndex | Number | optional,
                ..
              },
          ComponentType = String,
          ConfigVersionObjectByDevice = {
                cadlVersion
                  | { stable | String | optional, test | String | optional, .. }
                  | optional,
              },
          ContentType
            | doc m%"
            Determines the content type of the component. For example, a textField component may be a date textField if it has contentType: date, or a password textField with contentType: password, etc
            "%
            = String,
          DataIn
            | doc m%"
            Argument(s) to the surrounding built in function
            "%
            = definitions.contract.Value,
          DataKey
            | doc m%"
            A value/pointer to a a property of an object
            "%
            = predicates.contract_from_predicate definitions.predicate.DataKey,
          DataKeyObject
            | doc m%"
            Data key in the emit object
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DataKeyObject,
          DataKeyString
            | doc m%"
            The path to a data object or value. It might provide a different behavior depending on where it is placed. For example, a dataKey set on a textField component will bind its value to the path in the dataKey, enabling it to mutate the value while updating textField's value
            "%
            = String,
          DataObject
            | doc m%"
            An object that contains data. It is most commonly used in actions such as updateObject as a way to update its data values
            "%
            = String,
          DataOut
            | doc m%"
            Return value(s) to the surrounding built in function
            "%
            = definitions.contract.Value,
          Emit
            | doc m%"
            An emit is a special type of action that usually contains a dataKey paired with a list of actions that are called in order. Some emits can contain just a list of actions. When paired with a dataKey it is usually mutating the value at the path in the dataKey
            "%
            = {
                actions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.Action,
                      definitions.predicate.BuiltInEval
                    ])
                  ]),
                dataKey
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType 'Record ])
                  | optional,
              },
          Empty
            | doc m%"
            Empty value (empty string)
            "%
            = predicates.contract_from_predicate definitions.predicate.Empty,
          Goto
            | doc m%"
            The destination the user should navigate to
            "%
            = predicates.contract_from_predicate definitions.predicate.Goto,
          GotoObject = { destination | String | optional, .. },
          GotoPage = String,
          GotoPageComponentUrl = predicates.contract_from_predicate
              definitions.predicate.GotoPageComponentUrl,
          If
            | doc m%"
            If objects contain an array with three items used for conditional checks. The first item is used as a test for truthiness which can be in the form of any data type such as a string, number, boolean, object, etc. Either the second or third item is returned depending on the result of the truthiness test
            "%
            = {
                "if"
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Value,
                    predicates.arrays.maxItems 3,
                    predicates.arrays.minItems 3
                  ])
                  | optional,
                ..
              },
          Init
            | doc m%"
            One or more action(s) which will occur when entering a page
            "%
            = predicates.contract_from_predicate definitions.predicate.Init,
          LocalEvalReference
            | doc m%"
            Mutates the value at the referenced path after receiving its result
            "%
            = predicates.contract_from_predicate
              definitions.predicate.LocalEvalReference,
          LocalReference
            | doc m%"
            A reference whose scope is within the page object, making them invisible to the objects outside of its scope
            "%
            = predicates.contract_from_predicate
              definitions.predicate.LocalReference,
          MixedActionChain
            | doc m%"
            An ActionChain but also includes the BuiltInEval objects =.builtIn.* as well as await/eval references
            "%
            = predicates.contract_from_predicate
              definitions.predicate.MixedActionChain,
          NoodlUnit
            | doc m%"
            A measurement adaptive to the size of the viewport
            "%
            = String,
          Page
            | doc m%"
            A page object
            "%
            = predicates.contract_from_predicate definitions.predicate.Page,
          PageActions = predicates.contract_from_predicate
              definitions.predicate.PageActions,
          PageModule = String,
          PageNumber
            | doc m%"
            A page number may help distinguish between pages with similar names
            "%
            = String,
          Path
            | doc m%"
            A path can be in the form of a string, an if object, or an emit object
            "%
            = predicates.contract_from_predicate definitions.predicate.Path,
          Reference
            | doc m%"
            Placeholder values that obtain their real values at a later time
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Reference,
          Root
            | doc m%"
            The root/base object. It is global to all descendants
            "%
            = {
                BaseCSS
                  | { Style | definitions.contract.Style | optional, .. }
                  | optional,
                BaseDataModel
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      Config = definitions.predicate.RootConfig,
                      Global = predicates.isType 'Record,
                    }
                    {  }
                    true
                    (predicates.isType 'Record)
                  ])
                  | optional,
                BasePage | {  .. } | optional,
                Config | definitions.contract.RootConfig | optional,
                Global
                  | {  .. }
                  | doc m%"
                  This can be accessed and mutated by any object at any time
                  "%
                  | optional,
                ..
              },
          RootConfig = {
                android
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    definitions.predicate.ConfigVersionObjectByDevice
                  ])
                  | optional,
                apiCheck | {  .. } | optional,
                apiHost | String | optional,
                apiPort | String | optional,
                appApiHost | String | optional,
                cadlBaseUrl | String | optional,
                cadlMain | String | optional,
                cadlVersion | {  .. } | optional,
                connectiontimeout | String | optional,
                debug
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType 'Record ])
                  | optional,
                elasticClient | {  .. } | optional,
                ios
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    definitions.predicate.ConfigVersionObjectByDevice
                  ])
                  | optional,
                isGetPosition | definitions.contract.Boolean | optional,
                keywords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                loadingLevel | Number | optional,
                log | String | optional,
                myBaseUrl | String | optional,
                searchLink | {  .. } | optional,
                syncHost | String | optional,
                timestamp | Number | optional,
                viewWidthHeightRatio
                  | { max | Number | optional, min | Number | optional, .. }
                  | optional,
                web
                  | definitions.contract.ConfigVersionObjectByDevice
                  | optional,
                webApiHost | String | optional,
                ..
              },
          RootEvalReference
            | doc m%"
            Mutates the value at the root referenced path after receiving its result
            "%
            = predicates.contract_from_predicate
              definitions.predicate.RootEvalReference,
          RootReference
            | doc m%"
            A reference whose scope is at the global level
            "%
            = predicates.contract_from_predicate
              definitions.predicate.RootReference,
          SelectOptions
            | doc m%"
            Options for a select component. These are the items that appear in the drop down menu when interacting with a select component
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SelectOptions,
          Style = {
                align
                  | String
                  | doc m%"
                  The alignment in a block. If align is horizontal, siblings will align horizontally, vice versa. This is functionally equivalent to the "axis" keyword
                  "%
                  | optional,
                axis
                  | String
                  | doc m%"
                  The axis in a block. If axis is horizontal, siblings will align horizontally, vice versa. This was previously used in list/listItem components
                  "%
                  | optional,
                backgroundColor | String | optional,
                border | definitions.contract.Border | optional,
                borderBottom | String | optional,
                borderColor | String | optional,
                borderRadius | definitions.contract.NoodlUnit | optional,
                borderWidth | definitions.contract.NoodlUnit | optional,
                boxShadow
                  | String
                  | doc m%"
                  Applies a box shadow style effect
                  "%
                  | optional,
                boxSizing | String | optional,
                color | String | optional,
                fontFamily | String | optional,
                fontSize | definitions.contract.NoodlUnit | optional,
                fontStyle | String | optional,
                fontWeight
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"Number", predicates.isType '"String" ])
                  | optional,
                height | definitions.contract.NoodlUnit | optional,
                isEditable | definitions.contract.Boolean | optional,
                isHidden
                  | definitions.contract.Boolean
                  | doc m%"
                  Used for hiding/showing components
                  "%
                  | optional,
                justifyContent | String | optional,
                left
                  | definitions.contract.NoodlUnit
                  | doc m%"
                  Left position. The greater the value, the further away from the left position
                  "%
                  | optional,
                letterSpacing
                  | String
                  | doc m%"
                  Spacing between each letter
                  "%
                  | optional,
                lineHeight
                  | String
                  | doc m%"
                  Spacing between each line
                  "%
                  | optional,
                margin | definitions.contract.NoodlUnit | optional,
                marginTop | definitions.contract.NoodlUnit | optional,
                opacity
                  | Number
                  | doc m%"
                  Applies a transparenct style effect. The lower the opacity, the more the transparent effect is applied
                  "%
                  | optional,
                overflow
                  | String
                  | doc m%"
                  If hidden, any styles flowing outside of a component's bounds will be invisible
                  "%
                  | optional,
                paddingBottom | definitions.contract.NoodlUnit | optional,
                paddingLeft | definitions.contract.NoodlUnit | optional,
                position | String | optional,
                required | String | optional,
                shadow
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Applies a box shadow effect
                  "%
                  | optional,
                textAlign | definitions.contract.TextAlign | optional,
                textColor | definitions.contract.Color | optional,
                textIndent | String | optional,
                top
                  | definitions.contract.NoodlUnit
                  | doc m%"
                  Top position. The greater the value, the further away from the top position
                  "%
                  | optional,
                width | definitions.contract.NoodlUnit | optional,
                zIndex
                  | String
                  | doc m%"
                  Applies a level of precedence/importance to a component. The higher the zIndex the higher level the component will be placed. For example, if a child 3 levels down applies a higher zIndex than the parent, then the child will appear to be on top in the page
                  "%
                  | optional,
                ..
              },
          Text
            | doc m%"
            Used to display text in the user interface. Most commonly used in label components
            "%
            = predicates.contract_from_predicate definitions.predicate.Text,
          TextAlign = predicates.contract_from_predicate
              definitions.predicate.TextAlign,
          TextAlignEnum = String,
          TextAlignObject = {
                x | String | optional,
                y | String | optional,
                ..
              },
          TextBoard
            | doc m%"
            A component that contains children of text that are positioned inline (side by side)
            "%
            = predicates.contract_from_predicate
              definitions.predicate.TextBoard,
          UserEvent
            | doc m%"
            An event in the form of an ActionChain that triggers from user interactions, like onClick and onFocus
            "%
            = predicates.contract_from_predicate
              definitions.predicate.UserEvent,
          Value
            | doc m%"
            A valid value in accordance to the noodl specification
            "%
            = predicates.contract_from_predicate definitions.predicate.Value,
          ViewTag
            | doc m%"
            An identifier which is used to bind a component and an action together. Actions can define a viewTag that invokes certain behavior towards a component. The component must also contain the same viewTag key/value. If multiple components have the same viewTag, then the action will effect multiple components
            "%
            = String,
        },
    predicate = {
          Action = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  actionType = definitions.predicate.ActionType,
                  contentType = definitions.predicate.ContentType,
                  dataKey = definitions.predicate.DataKeyString,
                  dataObject = definitions.predicate.DataObject,
                  dismissOnTouchOutside = predicates.isType '"Bool",
                  emit = definitions.predicate.Emit,
                  funcName = predicates.isType '"String",
                  goto = definitions.predicate.Goto,
                  object = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record,
                        predicates.isType '"Array"
                      ],
                  popUpView = predicates.isType '"String",
                  reload = predicates.isType '"Bool",
                  timer = predicates.isType '"String",
                  timerTag = predicates.isType '"String",
                  viewTag = definitions.predicate.ViewTag,
                  wait = predicates.oneOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"Number"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          ActionChain
            | doc m%"
            A chain of actions in sequential order
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.UserEvent
              ],
          ActionType
            | doc m%"
            An identifier/name for an action
            "%
            = predicates.isType '"String",
          AwaitReference
            | doc m%"
            A reference that returns its result after the value at the referenced path is received
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[=.]*[a-zA-Z0-9]+.*@$"
              ],
          Boolean
            | doc m%"
            A boolean value is either one of "true", true, "false", or false
            "%
            = predicates.enum [ "true", "false", true, false ],
          Border
            | doc m%"
            Border styles
            "%
            = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    color = definitions.predicate.Color,
                    line = predicates.isType '"String",
                    style = definitions.predicate.BorderStylePreset,
                    width = definitions.predicate.NoodlUnit,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          BorderPreset1
            | doc m%"
            Removes border including the radius
            "%
            = predicates.allOf
              [
                predicates.enum [ "1", 1 ],
                predicates.oneOf
                [ predicates.isType '"String", predicates.isType '"Number" ]
              ],
          BorderPreset2
            | doc m%"
            Removes border from all sides (including radius) except the bottom. This will create an underline effect
            "%
            = predicates.allOf
              [
                predicates.enum [ 2, "2" ],
                predicates.oneOf
                [ predicates.isType '"String", predicates.isType '"Number" ]
              ],
          BorderPreset3
            | doc m%"
            Applies a solid border to all sides
            "%
            = predicates.allOf
              [
                predicates.enum [ "3", 3 ],
                predicates.oneOf
                [ predicates.isType '"String", predicates.isType '"Number" ]
              ],
          BorderPreset4
            | doc m%"
            Sets the border to be a dashed border
            "%
            = predicates.allOf
              [
                predicates.enum [ "4", 4 ],
                predicates.oneOf
                [ predicates.isType '"String", predicates.isType '"Number" ]
              ],
          BorderPreset5
            | doc m%"
            Removes border from all sides
            "%
            = predicates.allOf
              [
                predicates.enum [ "5", 5 ],
                predicates.oneOf
                [ predicates.isType '"String", predicates.isType '"Number" ]
              ],
          BorderPreset6
            | doc m%"
            Sets the border to be a solid border. This will also remove border radius from all sides
            "%
            = predicates.allOf
              [
                predicates.enum [ "6", 6 ],
                predicates.oneOf
                [ predicates.isType '"String", predicates.isType '"Number" ]
              ],
          BorderStylePreset
            | doc m%"
            A set of border presets, each applying a different style
            "%
            = predicates.oneOf
              [
                definitions.predicate.BorderPreset1,
                definitions.predicate.BorderPreset2,
                definitions.predicate.BorderPreset3,
                definitions.predicate.BorderPreset4,
                definitions.predicate.BorderPreset5,
                definitions.predicate.BorderPreset6
              ],
          BuiltInEval
            | doc m%"
            Objects that become built in functions when parsed/serialized
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^=.builtIn.[a-zA-Z0-9]+$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          dataIn = definitions.predicate.DataIn,
                          dataOut = definitions.predicate.DataOut,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                true
                predicates.always
              ],
          Color = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^(0x)[a-zA-Z0-9]+$"
              ],
          Component
            | doc m%"
            Components are the building blocks that construct to user interfaces
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  audioStream = predicates.isType '"Bool",
                  borderRadius = definitions.predicate.NoodlUnit,
                  children = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.oneOf
                        [
                          definitions.predicate.Component,
                          definitions.predicate.Reference
                        ])
                      ],
                  contentType = definitions.predicate.ContentType,
                  dataKey = definitions.predicate.DataKey,
                  ecosObj = predicates.isType '"String",
                  global = definitions.predicate.Boolean,
                  image = predicates.isType '"String",
                  imgPath = predicates.isType '"String",
                  isEdit = definitions.predicate.Boolean,
                  isEditable = predicates.anyOf
                      [
                        definitions.predicate.Boolean,
                        predicates.isType '"String"
                      ],
                  itemObject = predicates.isType '"String",
                  iteratorVar = predicates.isType '"String",
                  listObject = predicates.anyOf
                      [
                        definitions.predicate.Empty,
                        definitions.predicate.Reference,
                        predicates.isType '"Array"
                      ],
                  onBlur = predicates.oneOf
                      [
                        definitions.predicate.ActionChain,
                        definitions.predicate.UserEvent
                      ],
                  onChange = predicates.oneOf
                      [
                        definitions.predicate.ActionChain,
                        definitions.predicate.UserEvent
                      ],
                  onClick = predicates.oneOf
                      [
                        definitions.predicate.ActionChain,
                        definitions.predicate.UserEvent
                      ],
                  onEvent = predicates.isType '"String",
                  onFocus = predicates.oneOf
                      [
                        definitions.predicate.ActionChain,
                        definitions.predicate.UserEvent
                      ],
                  onHover = predicates.oneOf
                      [
                        definitions.predicate.ActionChain,
                        definitions.predicate.UserEvent
                      ],
                  onInput = predicates.oneOf
                      [
                        definitions.predicate.ActionChain,
                        definitions.predicate.UserEvent
                      ],
                  onMouseEnter = predicates.oneOf
                      [
                        definitions.predicate.ActionChain,
                        definitions.predicate.UserEvent
                      ],
                  onMouseLeave = predicates.oneOf
                      [
                        definitions.predicate.ActionChain,
                        definitions.predicate.UserEvent
                      ],
                  onMouseOut = predicates.oneOf
                      [
                        definitions.predicate.ActionChain,
                        definitions.predicate.UserEvent
                      ],
                  onMouseOver = predicates.oneOf
                      [
                        definitions.predicate.ActionChain,
                        definitions.predicate.UserEvent
                      ],
                  options = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  overflow = predicates.isType '"String",
                  path = definitions.predicate.Path,
                  placeholder = predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.If,
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          { emit = definitions.predicate.Emit, }
                          {  }
                          true
                          predicates.always
                        ]
                      ],
                  popUpView = predicates.isType '"String",
                  postMessage = predicates.isType '"Array",
                  poster = predicates.isType '"String",
                  required = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  resource = predicates.isType '"String",
                  style = definitions.predicate.Style,
                  text = definitions.predicate.Text,
                  "text=func" = predicates.isType '"String",
                  textAlign = definitions.predicate.TextAlign,
                  textBoard = definitions.predicate.TextBoard,
                  type = definitions.predicate.ComponentType,
                  videoFormat = predicates.isType '"String",
                  videoStream = predicates.isType '"Bool",
                  viewTag = definitions.predicate.ViewTag,
                  zIndex = predicates.isType '"Number",
                }
                {  }
                true
                predicates.always
              ],
          ComponentType = predicates.isType '"String",
          ConfigVersionObjectByDevice = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cadlVersion = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          stable = predicates.isType '"String",
                          test = predicates.isType '"String",
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
          ContentType
            | doc m%"
            Determines the content type of the component. For example, a textField component may be a date textField if it has contentType: date, or a password textField with contentType: password, etc
            "%
            = predicates.isType '"String",
          DataIn
            | doc m%"
            Argument(s) to the surrounding built in function
            "%
            = definitions.predicate.Value,
          DataKey
            | doc m%"
            A value/pointer to a a property of an object
            "%
            = predicates.anyOf
              [
                definitions.predicate.DataKeyString,
                definitions.predicate.DataKeyObject
              ],
          DataKeyObject
            | doc m%"
            Data key in the emit object
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                { "^[a-zA-Z0-9]+$" = predicates.isType 'Record, }
                true
                predicates.always
              ],
          DataKeyString
            | doc m%"
            The path to a data object or value. It might provide a different behavior depending on where it is placed. For example, a dataKey set on a textField component will bind its value to the path in the dataKey, enabling it to mutate the value while updating textField's value
            "%
            = predicates.isType '"String",
          DataObject
            | doc m%"
            An object that contains data. It is most commonly used in actions such as updateObject as a way to update its data values
            "%
            = predicates.isType '"String",
          DataOut
            | doc m%"
            Return value(s) to the surrounding built in function
            "%
            = definitions.predicate.Value,
          Emit
            | doc m%"
            An emit is a special type of action that usually contains a dataKey paired with a list of actions that are called in order. Some emits can contain just a list of actions. When paired with a dataKey it is usually mutating the value at the path in the dataKey
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "actions" ],
                predicates.records.record
                {
                  actions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.Action,
                          definitions.predicate.BuiltInEval
                        ])
                      ],
                  dataKey = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Empty
            | doc m%"
            Empty value (empty string)
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.const "" ],
          Goto
            | doc m%"
            The destination the user should navigate to
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType '"String",
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    definitions.predicate.GotoObject
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.GotoPageComponentUrl
                  ]
                ],
                predicates.not (predicates.isType '"Number")
              ],
          GotoObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { destination = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          GotoPage = predicates.isType '"String",
          GotoPageComponentUrl = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "[a-zA-Z0-9]+@[a-zA-Z0-9]+#[a-zA-Z0-9]+"
              ],
          If
            | doc m%"
            If objects contain an array with three items used for conditional checks. The first item is used as a test for truthiness which can be in the form of any data type such as a string, number, boolean, object, etc. Either the second or third item is returned depending on the result of the truthiness test
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "if" = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Value,
                        predicates.arrays.maxItems 3,
                        predicates.arrays.minItems 3
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Init
            | doc m%"
            One or more action(s) which will occur when entering a page
            "%
            = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.anyOf
                  [
                    definitions.predicate.If,
                    predicates.isType '"String",
                    definitions.predicate.Goto,
                    predicates.allOf
                    [ predicates.isType '"String", predicates.const [ "" ] ]
                  ])
                ],
                definitions.predicate.MixedActionChain
              ],
          LocalEvalReference
            | doc m%"
            Mutates the value at the referenced path after receiving its result
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^=[.][.][a-zA-Z0-9]+.*$"
              ],
          LocalReference
            | doc m%"
            A reference whose scope is within the page object, making them invisible to the objects outside of its scope
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[.][.][a-zA-Z0-9]+.*$"
              ],
          MixedActionChain
            | doc m%"
            An ActionChain but also includes the BuiltInEval objects =.builtIn.* as well as await/eval references
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  definitions.predicate.ActionChain,
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.BuiltInEval
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { "(=.[a-zA_Z0-9])*@$" = definitions.predicate.Value, }
                    true
                    predicates.always
                  ]
                ])
              ],
          NoodlUnit
            | doc m%"
            A measurement adaptive to the size of the viewport
            "%
            = predicates.isType '"String",
          Page
            | doc m%"
            A page object
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  check = definitions.predicate.Init,
                  components = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Component
                      ],
                  init = predicates.oneOf
                      [ definitions.predicate.Init, predicates.const "" ],
                  module = definitions.predicate.PageModule,
                  pageNumber = definitions.predicate.PageNumber,
                  save = definitions.predicate.Init,
                  title = predicates.isType '"String",
                  update = definitions.predicate.Init,
                  viewPort = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          PageActions = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.anyOf
                  [
                    definitions.predicate.If,
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      { emit = definitions.predicate.Emit, }
                      {  }
                      true
                      predicates.always
                    ],
                    predicates.isType 'Record,
                    definitions.predicate.BuiltInEval
                  ]
                ])
              ],
          PageModule = predicates.isType '"String",
          PageNumber
            | doc m%"
            A page number may help distinguish between pages with similar names
            "%
            = predicates.isType '"String",
          Path
            | doc m%"
            A path can be in the form of a string, an if object, or an emit object
            "%
            = predicates.oneOf
              [
                predicates.anyOf
                [
                  predicates.isType '"String",
                  definitions.predicate.GotoPageComponentUrl
                ],
                predicates.anyOf
                [
                  definitions.predicate.BuiltInEval,
                  definitions.predicate.If,
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    { emit = definitions.predicate.Emit, }
                    {  }
                    true
                    predicates.always
                  ]
                ]
              ],
          Reference
            | doc m%"
            Placeholder values that obtain their real values at a later time
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.oneOf
                [
                  definitions.predicate.LocalReference,
                  definitions.predicate.RootReference,
                  definitions.predicate.LocalEvalReference,
                  definitions.predicate.RootEvalReference,
                  definitions.predicate.AwaitReference
                ]
              ],
          Root
            | doc m%"
            The root/base object. It is global to all descendants
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  BaseCSS = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { Style = definitions.predicate.Style, }
                        {  }
                        true
                        predicates.always
                      ],
                  BaseDataModel = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          Config = definitions.predicate.RootConfig,
                          Global = predicates.isType 'Record,
                        }
                        {  }
                        true
                        (predicates.isType 'Record)
                      ],
                  BasePage = predicates.isType 'Record,
                  Config = definitions.predicate.RootConfig,
                  Global = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          RootConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  android = predicates.allOf
                      [
                        predicates.isType 'Record,
                        definitions.predicate.ConfigVersionObjectByDevice
                      ],
                  apiCheck = predicates.isType 'Record,
                  apiHost = predicates.isType '"String",
                  apiPort = predicates.isType '"String",
                  appApiHost = predicates.isType '"String",
                  cadlBaseUrl = predicates.isType '"String",
                  cadlMain = predicates.isType '"String",
                  cadlVersion = predicates.isType 'Record,
                  connectiontimeout = predicates.isType '"String",
                  debug = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                  elasticClient = predicates.isType 'Record,
                  ios = predicates.allOf
                      [
                        predicates.isType 'Record,
                        definitions.predicate.ConfigVersionObjectByDevice
                      ],
                  isGetPosition = definitions.predicate.Boolean,
                  keywords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  loadingLevel = predicates.isType '"Number",
                  log = predicates.isType '"String",
                  myBaseUrl = predicates.isType '"String",
                  searchLink = predicates.isType 'Record,
                  syncHost = predicates.isType '"String",
                  timestamp = predicates.isType '"Number",
                  viewWidthHeightRatio = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          max = predicates.isType '"Number",
                          min = predicates.isType '"Number",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  web = definitions.predicate.ConfigVersionObjectByDevice,
                  webApiHost = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          RootEvalReference
            | doc m%"
            Mutates the value at the root referenced path after receiving its result
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^=[.][a-zA-Z0-9]+.*$"
              ],
          RootReference
            | doc m%"
            A reference whose scope is at the global level
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[.][a-zA-Z0-9]+.*$"
              ],
          SelectOptions
            | doc m%"
            Options for a select component. These are the items that appear in the drop down menu when interacting with a select component
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.anyOf
                [ predicates.isType '"String", predicates.isType '"Number" ])
              ],
          Style = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  align = predicates.isType '"String",
                  axis = predicates.isType '"String",
                  backgroundColor = predicates.isType '"String",
                  border = definitions.predicate.Border,
                  borderBottom = predicates.isType '"String",
                  borderColor = predicates.isType '"String",
                  borderRadius = definitions.predicate.NoodlUnit,
                  borderWidth = definitions.predicate.NoodlUnit,
                  boxShadow = predicates.isType '"String",
                  boxSizing = predicates.isType '"String",
                  color = predicates.isType '"String",
                  fontFamily = predicates.isType '"String",
                  fontSize = definitions.predicate.NoodlUnit,
                  fontStyle = predicates.isType '"String",
                  fontWeight = predicates.oneOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String"
                      ],
                  height = definitions.predicate.NoodlUnit,
                  isEditable = definitions.predicate.Boolean,
                  isHidden = definitions.predicate.Boolean,
                  justifyContent = predicates.isType '"String",
                  left = definitions.predicate.NoodlUnit,
                  letterSpacing = predicates.isType '"String",
                  lineHeight = predicates.isType '"String",
                  margin = definitions.predicate.NoodlUnit,
                  marginTop = definitions.predicate.NoodlUnit,
                  opacity = predicates.isType '"Number",
                  overflow = predicates.isType '"String",
                  paddingBottom = definitions.predicate.NoodlUnit,
                  paddingLeft = definitions.predicate.NoodlUnit,
                  position = predicates.isType '"String",
                  required = predicates.isType '"String",
                  shadow = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  textAlign = definitions.predicate.TextAlign,
                  textColor = definitions.predicate.Color,
                  textIndent = predicates.isType '"String",
                  top = definitions.predicate.NoodlUnit,
                  width = definitions.predicate.NoodlUnit,
                  zIndex = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Text
            | doc m%"
            Used to display text in the user interface. Most commonly used in label components
            "%
            = predicates.oneOf
              [ predicates.isType '"String", definitions.predicate.If ],
          TextAlign = predicates.oneOf
              [
                definitions.predicate.TextAlignEnum,
                definitions.predicate.TextAlignObject
              ],
          TextAlignEnum = predicates.isType '"String",
          TextAlignObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  x = predicates.isType '"String",
                  y = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          TextBoard
            | doc m%"
            A component that contains children of text that are positioned inline (side by side)
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
                    color = predicates.isType '"String",
                    text = definitions.predicate.Text,
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          UserEvent
            | doc m%"
            An event in the form of an ActionChain that triggers from user interactions, like onClick and onFocus
            "%
            = predicates.anyOf
              [
                predicates.allOf
                [ predicates.isType 'Record, definitions.predicate.Action ],
                definitions.predicate.Reference
              ],
          Value
            | doc m%"
            A valid value in accordance to the noodl specification
            "%
            = predicates.oneOf
              [
                predicates.isType '"String",
                definitions.predicate.NoodlUnit,
                predicates.isType '"Number",
                predicates.isType 'Record,
                predicates.isType '"Array",
                definitions.predicate.Reference,
                predicates.isType 'Null,
                definitions.predicate.If,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  { emit = definitions.predicate.Emit, }
                  {  }
                  true
                  predicates.always
                ]
              ],
          ViewTag
            | doc m%"
            An identifier which is used to bind a component and an action together. Actions can define a viewTag that invokes certain behavior towards a component. The component must also contain the same viewTag key/value. If multiple components have the same viewTag, then the action will effect multiple components
            "%
            = predicates.isType '"String",
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.record {  }
  {
    "^[a-zA-Z0-9]*$" = predicates.allOf
        [ predicates.isType 'Record, definitions.predicate.Page ],
  }
  true
  predicates.always,
  definitions.predicate.RootConfig
])