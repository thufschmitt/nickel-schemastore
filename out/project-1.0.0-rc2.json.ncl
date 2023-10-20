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
          buildOptions
            | doc m%"
            Options that are passed to the compiler.
            "%
            = {
                additionalArguments
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                allowUnsafe | Bool | optional,
                compile
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Array",
                      predicates.isType 'Record
                    ],
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.records.record
                    {
                      builtIns = predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Array",
                              predicates.isType 'Record
                            ],
                            predicates.arrays.arrayOf
                            (predicates.isType '"String"),
                            predicates.records.record
                            {
                              exclude = predicates.allOf
                                  [
                                    predicates.anyOf
                                    [
                                      predicates.isType '"String",
                                      predicates.isType '"Array"
                                    ],
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                              include = predicates.allOf
                                  [
                                    predicates.anyOf
                                    [
                                      predicates.isType '"String",
                                      predicates.isType '"Array"
                                    ],
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                            }
                            {  }
                            true
                            predicates.always
                          ],
                      exclude = predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Array"
                            ],
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                      excludeFiles = predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Array"
                            ],
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                      include = predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Array"
                            ],
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                      includeFiles = predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Array"
                            ],
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                      mappings = predicates.isType 'Record,
                    }
                    {  }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Defines glob patterns and file path to include for compilation.
                  "%
                  | optional,
                compilerName | String | optional,
                copyToOutput
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate."buildOptions/properties/compile",
                    predicates.always
                  ])
                  | optional,
                debugType
                  | std.enum.TagOrString
                  | [| 'none, 'full, 'portable |]
                  | optional,
                define
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | optional,
                delaySign | Bool | optional,
                embed
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate."buildOptions/properties/compile",
                    predicates.always
                  ])
                  | optional,
                emitEntryPoint | Bool | optional,
                keyFile | String | optional,
                languageVersion
                  | std.enum.TagOrString
                  | [|
                    'experimental,
                    'csharp6,
                    'csharp5,
                    'csharp4,
                    'csharp3,
                    'csharp2,
                    'csharp1
                  |]
                  | optional,
                nowarn
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | optional,
                optimize | Bool | optional,
                outputName | String | optional,
                platform
                  | std.enum.TagOrString
                  | [|
                    'Itanium,
                    'x64,
                    'x86,
                    'ARM,
                    'anycpu32bitpreferred,
                    'anycpu
                  |]
                  | optional,
                preserveCompilationContext
                  | Bool
                  | doc m%"
                  Set this option to preserve reference assemblies and other context data to allow for runtime compilation.
                  "%
                  | optional,
                publicSign | Bool | optional,
                warningsAsErrors | Bool | optional,
                xmlDoc | Bool | optional,
                ..
              },
          compilationOptions
            | doc m%"
            [Deprecated] Options that are passed to the compiler. Use 'buildOptions' instead.
            "%
            = {
                allowUnsafe | Bool | optional,
                debugType
                  | std.enum.TagOrString
                  | [| 'none, 'full, 'portable |]
                  | optional,
                define
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | optional,
                delaySign | Bool | optional,
                emitEntryPoint | Bool | optional,
                keyFile | String | optional,
                languageVersion
                  | std.enum.TagOrString
                  | [|
                    'experimental,
                    'csharp6,
                    'csharp5,
                    'csharp4,
                    'csharp3,
                    'csharp2,
                    'csharp1
                  |]
                  | optional,
                nowarn
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | optional,
                optimize | Bool | optional,
                outputName | String | optional,
                platform
                  | std.enum.TagOrString
                  | [|
                    'Itanium,
                    'x64,
                    'x86,
                    'ARM,
                    'anycpu32bitpreferred,
                    'anycpu
                  |]
                  | optional,
                preserveCompilationContext
                  | Bool
                  | doc m%"
                  Set this option to preserve reference assemblies and other context data to allow for runtime compilation
                  "%
                  | optional,
                publicSign | Bool | optional,
                warningsAsErrors | Bool | optional,
                ..
              },
          configType = {
                buildOptions | definitions.contract.buildOptions | optional,
                compilationOptions
                  | definitions.contract.compilationOptions
                  | optional,
                dependencies | definitions.contract.dependencies | optional,
                frameworkAssemblies
                  | definitions.contract.dependencies
                  | optional,
                imports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType '"Array" ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Allow packages supporting these frameworks to be installed in this target, regardless of the compatibility rules.
                  "%
                  | optional,
                ..
              },
          dependencies
            | doc m%"
            Each dependency is defined by a name and a version. Dependencies are resolved from NuGet feeds defined by your package sources and projects located in the directories specified by the 'global.json' file.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.dependencies,
          libraryIncludeFlag = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'none,
                  'analyzers,
                  'native,
                  'contentFiles,
                  'build,
                  'compile,
                  'runtime,
                  'all
                |]
              ],
          libraryIncludeFlags = predicates.contract_from_predicate
              definitions.predicate.libraryIncludeFlags,
          packOptions
            | doc m%"
            Defines options pertaining to the packaging of the project output into a NuGet package.
            "%
            = {
                files
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate."buildOptions/properties/compile",
                    predicates.always
                  ])
                  | optional,
                iconUrl
                  | String
                  | doc m%"
                  A URL for the image to use as the icon for the package. This should be a 32x32-pixel .png file that has a transparent background.
                  "%
                  | optional,
                licenseUrl
                  | String
                  | doc m%"
                  A link to the license for the package.
                  "%
                  | optional,
                owners
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  List of owners of the package.
                  "%
                  | optional,
                releaseNotes
                  | String
                  | doc m%"
                  A description of the changes made in each release of the package.
                  "%
                  | optional,
                repository
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      type = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "git" ]
                          ],
                      url = predicates.isType '"String",
                    }
                    {  }
                    true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Contains information about the repository where the project is stored.
                  "%
                  | optional,
                requireLicenseAcceptance
                  | Bool
                  | doc m%"
                  A Boolean value that specifies whether the client needs to ensure that the package license (described by licenseUrl) is accepted before the package is installed.
                  "%
                  | optional,
                summary
                  | String
                  | doc m%"
                  A short description of the package.
                  "%
                  | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A space-delimited list of tags and keywords that describe the package.
                  "%
                  | optional,
                ..
              },
          publishOptions = predicates.contract_from_predicate
              definitions.predicate.publishOptions,
          runtimeOptions = {
                configProperties
                  | {
                    "System.GC.Concurrent"
                      | Bool
                      | doc m%"
                      Enables/disables concurrent garbage collection.
                      "%
                      | optional,
                    "System.GC.GCHeapAffinitizeRanges"
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ])
                      | doc m%"
                      Specifies the list of processors to use for garbage collector threads.
                      "%
                      | optional,
                    "System.GC.HeapAffinitizeMask"
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ])
                      | doc m%"
                      Specifies the exact processors that garbage collector threads should use.
                      "%
                      | optional,
                    "System.GC.HeapCount"
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ])
                      | doc m%"
                      Limits the number of heaps created by the garbage collector.
                      "%
                      | optional,
                    "System.GC.HeapHardLimit"
                      | String
                      | doc m%"
                      Specifies the maximum commit size, in bytes, for the GC heap and GC bookkeeping.
                      "%
                      | optional,
                    "System.GC.HeapHardLimitPercent"
                      | Number
                      | doc m%"
                      Specifies the GC heap usage as a percentage of the total memory.
                      "%
                      | optional,
                    "System.GC.LOHThreshold"
                      | std.number.Integer
                      | doc m%"
                      Specifies the threshold size, in bytes, that causes objects to go on the large object heap (LOH).
                      "%
                      | optional,
                    "System.GC.NoAffinitize"
                      | Bool
                      | doc m%"
                      Specifies whether to affinitize garbage collection threads with processors. To affinitize a GC thread means that it can only run on its specific CPU. A heap is created for each GC thread.
                      "%
                      | optional,
                    "System.GC.RetainVM"
                      | Bool
                      | doc m%"
                      Configures whether segments that should be deleted are put on a standby list for future use or are released back to the operating system (OS).
                      "%
                      | optional,
                    "System.GC.Server"
                      | Bool
                      | doc m%"
                      Enables/disables server garbage collection.
                      "%
                      | optional,
                    "System.Threading.ThreadPool.MaxThreads"
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ])
                      | doc m%"
                      Sets the maximum number of threads for the thread pool.
                      "%
                      | optional,
                    "System.Threading.ThreadPool.MinThreads"
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ])
                      | doc m%"
                      Sets the minimum number of threads for the thread pool.
                      "%
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          script
            | doc m%"
            A command line script or scripts.Available variables:%project:Directory% - The project directory%project:Name% - The project name%project:Version% - The project version
            "%
            = predicates.contract_from_predicate definitions.predicate.script,
        },
    predicate = {
          buildOptions
            | doc m%"
            Options that are passed to the compiler.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  additionalArguments = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  allowUnsafe = predicates.isType '"Bool",
                  compile = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Array",
                          predicates.isType 'Record
                        ],
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.records.record
                        {
                          builtIns = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.isType '"Array",
                                  predicates.isType 'Record
                                ],
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.records.record
                                {
                                  exclude = predicates.allOf
                                      [
                                        predicates.anyOf
                                        [
                                          predicates.isType '"String",
                                          predicates.isType '"Array"
                                        ],
                                        predicates.arrays.arrayOf
                                        (predicates.isType '"String")
                                      ],
                                  include = predicates.allOf
                                      [
                                        predicates.anyOf
                                        [
                                          predicates.isType '"String",
                                          predicates.isType '"Array"
                                        ],
                                        predicates.arrays.arrayOf
                                        (predicates.isType '"String")
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          exclude = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.isType '"Array"
                                ],
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          excludeFiles = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.isType '"Array"
                                ],
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          include = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.isType '"Array"
                                ],
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          includeFiles = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.isType '"Array"
                                ],
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          mappings = predicates.isType 'Record,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  compilerName = predicates.isType '"String",
                  copyToOutput = predicates.allOf
                      [
                        definitions.predicate."buildOptions/properties/compile",
                        predicates.always
                      ],
                  debugType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "portable", "full", "none" ]
                      ],
                  define = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  delaySign = predicates.isType '"Bool",
                  embed = predicates.allOf
                      [
                        definitions.predicate."buildOptions/properties/compile",
                        predicates.always
                      ],
                  emitEntryPoint = predicates.isType '"Bool",
                  keyFile = predicates.isType '"String",
                  languageVersion = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "csharp1",
                          "csharp2",
                          "csharp3",
                          "csharp4",
                          "csharp5",
                          "csharp6",
                          "experimental"
                        ]
                      ],
                  nowarn = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  optimize = predicates.isType '"Bool",
                  outputName = predicates.isType '"String",
                  platform = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "anycpu",
                          "anycpu32bitpreferred",
                          "ARM",
                          "x86",
                          "x64",
                          "Itanium"
                        ]
                      ],
                  preserveCompilationContext = predicates.isType '"Bool",
                  publicSign = predicates.isType '"Bool",
                  warningsAsErrors = predicates.isType '"Bool",
                  xmlDoc = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          compilationOptions
            | doc m%"
            [Deprecated] Options that are passed to the compiler. Use 'buildOptions' instead.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allowUnsafe = predicates.isType '"Bool",
                  debugType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "portable", "full", "none" ]
                      ],
                  define = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  delaySign = predicates.isType '"Bool",
                  emitEntryPoint = predicates.isType '"Bool",
                  keyFile = predicates.isType '"String",
                  languageVersion = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "csharp1",
                          "csharp2",
                          "csharp3",
                          "csharp4",
                          "csharp5",
                          "csharp6",
                          "experimental"
                        ]
                      ],
                  nowarn = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  optimize = predicates.isType '"Bool",
                  outputName = predicates.isType '"String",
                  platform = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "anycpu",
                          "anycpu32bitpreferred",
                          "ARM",
                          "x86",
                          "x64",
                          "Itanium"
                        ]
                      ],
                  preserveCompilationContext = predicates.isType '"Bool",
                  publicSign = predicates.isType '"Bool",
                  warningsAsErrors = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          configType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  buildOptions = definitions.predicate.buildOptions,
                  compilationOptions = definitions.predicate.compilationOptions,
                  dependencies = definitions.predicate.dependencies,
                  frameworkAssemblies = definitions.predicate.dependencies,
                  imports = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Array"
                        ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dependencies
            | doc m%"
            Each dependency is defined by a name and a version. Dependencies are resolved from NuGet feeds defined by your package sources and projects located in the directories specified by the 'global.json' file.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.allOf
                [
                  predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Record ],
                  predicates.records.record
                  {
                    exclude = definitions.predicate.libraryIncludeFlags,
                    include = definitions.predicate.libraryIncludeFlags,
                    suppressParent = definitions.predicate.libraryIncludeFlags,
                    target = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "project", "package" ]
                        ],
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "default", "build", "platform" ]
                        ],
                    version = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          libraryIncludeFlag = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "all",
                  "runtime",
                  "compile",
                  "build",
                  "contentFiles",
                  "native",
                  "analyzers",
                  "none"
                ]
              ],
          libraryIncludeFlags = predicates.oneOf
              [
                definitions.predicate.libraryIncludeFlag,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.libraryIncludeFlag
                ]
              ],
          packOptions
            | doc m%"
            Defines options pertaining to the packaging of the project output into a NuGet package.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  files = predicates.allOf
                      [
                        definitions.predicate."buildOptions/properties/compile",
                        predicates.always
                      ],
                  iconUrl = predicates.isType '"String",
                  licenseUrl = predicates.isType '"String",
                  owners = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  releaseNotes = predicates.isType '"String",
                  repository = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          type = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "git" ]
                              ],
                          url = predicates.isType '"String",
                        }
                        {  }
                        true
                        (predicates.isType '"String")
                      ],
                  requireLicenseAcceptance = predicates.isType '"Bool",
                  summary = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                true
                predicates.always
              ],
          publishOptions = predicates.allOf
              [
                definitions.predicate."buildOptions/properties/compile",
                predicates.always
              ],
          runtimeOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configProperties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          "System.GC.Concurrent" = predicates.isType '"Bool",
                          "System.GC.GCHeapAffinitizeRanges" = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                          "System.GC.HeapAffinitizeMask" = predicates.allOf
                              [
                                predicates.isType 'Integer,
                                predicates.numbers.minimum 0
                              ],
                          "System.GC.HeapCount" = predicates.allOf
                              [
                                predicates.isType 'Integer,
                                predicates.numbers.minimum 0
                              ],
                          "System.GC.HeapHardLimit" = predicates.isType
                              '"String",
                          "System.GC.HeapHardLimitPercent" = predicates.isType
                              '"Number",
                          "System.GC.LOHThreshold" = predicates.isType 'Integer,
                          "System.GC.NoAffinitize" = predicates.isType '"Bool",
                          "System.GC.RetainVM" = predicates.isType '"Bool",
                          "System.GC.Server" = predicates.isType '"Bool",
                          "System.Threading.ThreadPool.MaxThreads" =
                            predicates.allOf
                              [
                                predicates.isType 'Integer,
                                predicates.numbers.minimum 1
                              ],
                          "System.Threading.ThreadPool.MinThreads" =
                            predicates.allOf
                              [
                                predicates.isType 'Integer,
                                predicates.numbers.minimum 1
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
          script
            | doc m%"
            A command line script or scripts.Available variables:%project:Directory% - The project directory%project:Name% - The project name%project:Version% - The project version
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"String", predicates.isType '"Array" ],
                predicates.arrays.arrayOf (predicates.isType '"String")
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
    authors = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String"),
          predicates.arrays.uniqueItems
        ],
    buildOptions = definitions.predicate.buildOptions,
    commands = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true (predicates.isType '"String")
        ],
    compilationOptions = definitions.predicate.compilationOptions,
    compile = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    compileExclude = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    compileFiles = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    configurations = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              buildOptions = definitions.predicate.buildOptions,
              compilationOptions = definitions.predicate.compilationOptions,
            }
            {  }
            true
            predicates.always
          ])
        ],
    content = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    contentExclude = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    contentFiles = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    copyright = predicates.isType '"String",
    dependencies = definitions.predicate.dependencies,
    description = predicates.isType '"String",
    exclude = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    excludeBuiltIn = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    frameworks = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          definitions.predicate.configType
        ],
    iconUrl = predicates.isType '"String",
    language = predicates.isType '"String",
    licenseUrl = predicates.isType '"String",
    namedResource = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true (predicates.isType '"String")
        ],
    owners = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String"),
          predicates.arrays.uniqueItems
        ],
    packInclude = predicates.isType 'Record,
    packOptions = definitions.predicate.packOptions,
    preprocess = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    preprocessExclude = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    preprocessFiles = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    projectUrl = predicates.isType '"String",
    publishExclude = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    publishOptions = definitions.predicate.publishOptions,
    releaseNotes = predicates.isType '"String",
    repository = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            type = predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "git" ] ],
            url = predicates.isType '"String",
          }
          {  }
          true
          (predicates.isType '"String")
        ],
    requireLicenseAcceptance = predicates.isType '"Bool",
    resource = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    resourceExclude = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    resourceFiles = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    runtimeOptions = definitions.predicate.runtimeOptions,
    runtimes = predicates.isType 'Record,
    scripts = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            postcompile = definitions.predicate.script,
            postpack = definitions.predicate.script,
            postpublish = definitions.predicate.script,
            postrestore = definitions.predicate.script,
            precompile = definitions.predicate.script,
            prepack = definitions.predicate.script,
            prepare = definitions.predicate.script,
            prepublish = definitions.predicate.script,
            prerestore = definitions.predicate.script,
          }
          {  }
          true
          predicates.always
        ],
    shared = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    sharedExclude = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    sharedFiles = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"String", predicates.isType '"Array" ],
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    summary = predicates.isType '"String",
    tags = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String"),
          predicates.arrays.uniqueItems
        ],
    testRunner = predicates.isType '"String",
    title = predicates.isType '"String",
    tools = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.anyOf
            [ predicates.isType '"String", predicates.isType 'Record ],
            predicates.records.record { version = predicates.isType '"String", }
            {  }
            true
            predicates.always
          ])
        ],
    version = predicates.isType '"String",
  }
  {  }
  true
  predicates.always
])