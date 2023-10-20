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
          attachment
            | doc m%"
            A file relevant to a tool invocation or to a result.
            "%
            = {
                description
                  | definitions.contract.message
                  | doc m%"
                  A message describing the role played by the attachment.
                  "%
                  | optional,
                fileLocation
                  | definitions.contract.fileLocation
                  | doc m%"
                  The location of the attachment.
                  "%,
                rectangles
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.rectangle,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of rectangles specifying areas of interest within the image.
                  "%
                  | optional,
                regions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.region,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of regions of interest within the attachment.
                  "%
                  | optional,
              },
          codeFlow
            | doc m%"
            A set of threadFlows which together describe a pattern of code execution relevant to detecting a result.
            "%
            = {
                message
                  | definitions.contract.message
                  | doc m%"
                  A message relevant to the code flow.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the code flow.
                  "%
                  | optional,
                threadFlows
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.threadFlow,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of one or more unique threadFlow objects, each of which describes the progress of a program through a thread of execution.
                  "%,
              },
          conversion
            | doc m%"
            Describes how a converter transformed the output of a static analysis tool from the analysis tool's native output format into the SARIF format.
            "%
            = {
                analysisToolLogFiles
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.fileLocation,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The locations of the analysis tool's per-run log files.
                  "%
                  | optional,
                invocation
                  | definitions.contract.invocation
                  | doc m%"
                  An invocation object that describes the invocation of the converter.
                  "%
                  | optional,
                tool
                  | definitions.contract.tool
                  | doc m%"
                  A tool object that describes the converter.
                  "%,
              },
          edge
            | doc m%"
            Represents a directed edge in a graph.
            "%
            = {
                id
                  | String
                  | doc m%"
                  A string that uniquely identifies the edge within its graph.
                  "%,
                label
                  | definitions.contract.message
                  | doc m%"
                  A short description of the edge.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the edge.
                  "%
                  | optional,
                sourceNodeId
                  | String
                  | doc m%"
                  Identifies the source node (the node at which the edge starts).
                  "%,
                targetNodeId
                  | String
                  | doc m%"
                  Identifies the target node (the node at which the edge ends).
                  "%,
              },
          edgeTraversal
            | doc m%"
            Represents the traversal of a single edge during a graph traversal.
            "%
            = {
                edgeId
                  | String
                  | doc m%"
                  Identifies the edge being traversed.
                  "%,
                finalState
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  The values of relevant expressions after the edge has been traversed.
                  "%
                  | optional,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message to display to the user as the edge is traversed.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the edge traversal.
                  "%
                  | optional,
                stepOverEdgeCount
                  | std.number.Integer
                  | doc m%"
                  The number of edge traversals necessary to return from a nested graph.
                  "%
                  | optional,
              },
          exception = {
                innerExceptions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.exception
                  ])
                  | doc m%"
                  An array of exception objects each of which is considered a cause of this exception.
                  "%
                  | optional,
                kind
                  | String
                  | doc m%"
                  A string that identifies the kind of exception, for example, the fully qualified type name of an object that was thrown, or the symbolic name of a signal.
                  "%
                  | optional,
                message
                  | String
                  | doc m%"
                  A plain text message that describes the exception.
                  "%
                  | optional,
                stack
                  | definitions.contract.stack
                  | doc m%"
                  The sequence of function calls leading to the exception.
                  "%
                  | optional,
                ..
              },
          externalFiles
            | doc m%"
            References to external files that should be inlined with the content of a root log file.
            "%
            = {
                conversion
                  | definitions.contract.fileLocation
                  | doc m%"
                  The location of a file containing a run.conversion object to be merged with the root log file.
                  "%
                  | optional,
                files
                  | definitions.contract.fileLocation
                  | doc m%"
                  The location of a file containing a run.files object to be merged with the root log file.
                  "%
                  | optional,
                graphs
                  | definitions.contract.fileLocation
                  | doc m%"
                  The location of a file containing a run.graphs object to be merged with the root log file.
                  "%
                  | optional,
                invocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.fileLocation,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of locations of files containing arrays of run.invocation objects to be merged with the root log file.
                  "%
                  | optional,
                logicalLocations
                  | definitions.contract.fileLocation
                  | doc m%"
                  The location of a file containing a run.logicalLocations object to be merged with the root log file.
                  "%
                  | optional,
                resources
                  | definitions.contract.fileLocation
                  | doc m%"
                  The location of a file containing a run.resources object to be merged with the root log file.
                  "%
                  | optional,
                results
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.fileLocation,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of locations of files containing arrays of run.result objects to be merged with the root log file.
                  "%
                  | optional,
              },
          file
            | doc m%"
            A single file. In some cases, this file might be nested within another file.
            "%
            = {
                contents
                  | definitions.contract.fileContent
                  | doc m%"
                  The contents of the file.
                  "%
                  | optional,
                encoding
                  | String
                  | doc m%"
                  Specifies the encoding for a file object that refers to a text file.
                  "%
                  | optional,
                fileLocation
                  | definitions.contract.fileLocation
                  | doc m%"
                  The location of the file.
                  "%
                  | optional,
                hashes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.hash,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of hash objects, each of which specifies a hashed value for the file, along with the name of the hash function used to compute the hash.
                  "%
                  | optional,
                lastModifiedTime
                  | String
                  | doc m%"
                  The date and time at which the file was most recently modified. See "Date/time properties" in the SARIF spec for the required format.
                  "%
                  | optional,
                length
                  | std.number.Integer
                  | doc m%"
                  The length of the file in bytes.
                  "%
                  | optional,
                mimeType
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "[^/]+/.+"
                  ])
                  | doc m%"
                  The MIME type (RFC 2045) of the file.
                  "%
                  | optional,
                offset
                  | std.number.Integer
                  | doc m%"
                  The offset in bytes of the file within its containing file.
                  "%
                  | optional,
                parentKey
                  | String
                  | doc m%"
                  Identifies the key of the immediate parent of the file, if this file is nested.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the file.
                  "%
                  | optional,
                roles
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.enum
                    [
                      "analysisTarget",
                      "attachment",
                      "responseFile",
                      "resultFile",
                      "standardStream",
                      "traceFile",
                      "unmodifiedFile",
                      "modifiedFile",
                      "addedFile",
                      "deletedFile",
                      "renamedFile",
                      "uncontrolledFile"
                    ]),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The role or roles played by the file in the analysis.
                  "%
                  | optional,
              },
          fileChange
            | doc m%"
            A change to a single file.
            "%
            = {
                fileLocation
                  | definitions.contract.fileLocation
                  | doc m%"
                  The location of the file to change.
                  "%,
                replacements
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.replacement,
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  An array of replacement objects, each of which represents the replacement of a single region in a single file specified by 'fileLocation'.
                  "%,
              },
          fileContent
            | doc m%"
            Represents content from an external file.
            "%
            = {
                binary
                  | String
                  | doc m%"
                  MIME Base64-encoded content from a binary file, or from a text file in its original encoding.
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  UTF-8-encoded content from a text file.
                  "%
                  | optional,
              },
          fileLocation
            | doc m%"
            Specifies the location of a file.
            "%
            = {
                uri
                  | String
                  | doc m%"
                  A string containing a valid relative or absolute URI.
                  "%,
                uriBaseId
                  | String
                  | doc m%"
                  A string which indirectly specifies the absolute URI with respect to which a relative URI in the "uri" property is interpreted.
                  "%
                  | optional,
              },
          fix
            | doc m%"
            A proposed fix for the problem represented by a result object. A fix specifies a set of file to modify. For each file, it specifies a set of bytes to remove, and provides a set of new bytes to replace them.
            "%
            = {
                description
                  | definitions.contract.message
                  | doc m%"
                  A message that describes the proposed fix, enabling viewers to present the proposed change to an end user.
                  "%
                  | optional,
                fileChanges
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.fileChange
                  ])
                  | doc m%"
                  One or more file changes that comprise a fix for a result.
                  "%,
              },
          graph
            | doc m%"
            A network of nodes and directed edges that describes some aspect of the structure of the code (for example, a call graph).
            "%
            = {
                description
                  | definitions.contract.message
                  | doc m%"
                  A description of the graph.
                  "%
                  | optional,
                edges
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.edge
                  ])
                  | doc m%"
                  An array of edge objects representing the edges of the graph.
                  "%,
                id
                  | String
                  | doc m%"
                  A string that uniquely identifies the graph within a run.graphs or result.graphs array.
                  "%,
                nodes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.node
                  ])
                  | doc m%"
                  An array of node objects representing the nodes of the graph.
                  "%,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the graph.
                  "%
                  | optional,
              },
          graphTraversal
            | doc m%"
            Represents a path through a graph.
            "%
            = {
                description
                  | definitions.contract.message
                  | doc m%"
                  A description of this graph traversal.
                  "%
                  | optional,
                edgeTraversals
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.edgeTraversal
                  ])
                  | doc m%"
                  The sequences of edges traversed by this graph traversal.
                  "%,
                graphId
                  | String
                  | doc m%"
                  A string that uniquely identifies that graph being traversed.
                  "%,
                initialState
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Values of relevant expressions at the start of the graph traversal.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the graph traversal.
                  "%
                  | optional,
              },
          hash
            | doc m%"
            A hash value of some file or collection of files, together with the hash function used to compute the hash.
            "%
            = {
                algorithm
                  | String
                  | doc m%"
                  The name of the hash function used to compute the hash value specified in the 'value' property.
                  "%,
                value
                  | String
                  | doc m%"
                  The hash value of some file or collection of files, computed by the hash function named in the 'algorithm' property.
                  "%,
              },
          invocation
            | doc m%"
            The runtime environment of the analysis tool run.
            "%
            = {
                account
                  | String
                  | doc m%"
                  The account that ran the analysis tool.
                  "%
                  | optional,
                arguments
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of strings, containing in order the command line arguments passed to the tool from the operating system.
                  "%
                  | optional,
                attachments
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.attachment,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A set of files relevant to the invocation of the tool.
                  "%
                  | optional,
                commandLine
                  | String
                  | doc m%"
                  The command line used to invoke the tool.
                  "%
                  | optional,
                configurationNotifications
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.notification
                  ])
                  | doc m%"
                  A list of conditions detected by the tool that are relevant to the tool's configuration.
                  "%
                  | optional,
                endTime
                  | String
                  | doc m%"
                  The date and time at which the run ended. See "Date/time properties" in the SARIF spec for the required format.
                  "%
                  | optional,
                environmentVariables
                  | {  .. }
                  | doc m%"
                  The environment variables associated with the analysis tool process, expressed as key/value pairs.
                  "%
                  | optional,
                executableLocation
                  | definitions.contract.fileLocation
                  | doc m%"
                  An absolute URI specifying the location of the analysis tool's executable.
                  "%
                  | optional,
                exitCode
                  | std.number.Integer
                  | doc m%"
                  The process exit code.
                  "%
                  | optional,
                exitCodeDescription
                  | String
                  | doc m%"
                  The reason for the process exit.
                  "%
                  | optional,
                exitSignalName
                  | String
                  | doc m%"
                  The name of the signal that caused the process to exit.
                  "%
                  | optional,
                exitSignalNumber
                  | std.number.Integer
                  | doc m%"
                  The numeric value of the signal that caused the process to exit.
                  "%
                  | optional,
                machine
                  | String
                  | doc m%"
                  The machine that hosted the analysis tool run.
                  "%
                  | optional,
                processId
                  | std.number.Integer
                  | doc m%"
                  The process id for the analysis tool run.
                  "%
                  | optional,
                processStartFailureMessage
                  | String
                  | doc m%"
                  The reason given by the operating system that the process failed to start.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the invocation.
                  "%
                  | optional,
                responseFiles
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.fileLocation
                  ])
                  | doc m%"
                  The locations of any response files specified on the tool's command line.
                  "%
                  | optional,
                startTime
                  | String
                  | doc m%"
                  The date and time at which the run started. See "Date/time properties" in the SARIF spec for the required format.
                  "%
                  | optional,
                stderr
                  | definitions.contract.fileLocation
                  | doc m%"
                  A file containing the standard error stream from the process that was invoked.
                  "%
                  | optional,
                stdin
                  | definitions.contract.fileLocation
                  | doc m%"
                  A file containing the standard input stream to the process that was invoked.
                  "%
                  | optional,
                stdout
                  | definitions.contract.fileLocation
                  | doc m%"
                  A file containing the standard output stream from the process that was invoked.
                  "%
                  | optional,
                stdoutStderr
                  | definitions.contract.fileLocation
                  | doc m%"
                  A file containing the interleaved standard output and standard error stream from the process that was invoked.
                  "%
                  | optional,
                toolExecutionSuccessful
                  | Bool
                  | doc m%"
                  A value indicating whether the tool's execution completed successfully.
                  "%
                  | optional,
                toolNotifications
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.notification
                  ])
                  | doc m%"
                  A list of runtime conditions detected by the tool during the analysis.
                  "%
                  | optional,
                workingDirectory
                  | definitions.contract.fileLocation
                  | doc m%"
                  The working directory for the analysis tool run.
                  "%
                  | optional,
              },
          location
            | doc m%"
            A location within a programming artifact.
            "%
            = {
                annotations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.region,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A set of regions relevant to the location.
                  "%
                  | optional,
                fullyQualifiedLogicalName
                  | String
                  | doc m%"
                  The human-readable fully qualified name of the logical location. If run.logicalLocations is present, this value matches a property name within that object, from which further information about the logical location can be obtained.
                  "%
                  | optional,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message relevant to the location.
                  "%
                  | optional,
                physicalLocation
                  | definitions.contract.physicalLocation
                  | doc m%"
                  Identifies the file and region.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the location.
                  "%
                  | optional,
              },
          logicalLocation
            | doc m%"
            A logical location of a construct that produced a result.
            "%
            = {
                decoratedName
                  | String
                  | doc m%"
                  The machine-readable name for the logical location, such as a mangled function name provided by a C++ compiler that encodes calling convention, return type and other details along with the function name.
                  "%
                  | optional,
                fullyQualifiedName
                  | String
                  | doc m%"
                  The human-readable fully qualified name of the logical location.
                  "%
                  | optional,
                kind
                  | String
                  | doc m%"
                  The type of construct this logicalLocationComponent refers to. Should be one of 'function', 'member', 'module', 'namespace', 'package', 'parameter', 'resource', 'returnType', 'type', or 'variable', if any of those accurately describe the construct.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Identifies the construct in which the result occurred. For example, this property might contain the name of a class or a method.
                  "%
                  | optional,
                parentKey
                  | String
                  | doc m%"
                  Identifies the key of the immediate parent of the construct in which the result was detected. For example, this property might point to a logical location that represents the namespace that holds a type.
                  "%
                  | optional,
              },
          message
            | doc m%"
            Encapsulates a message intended to be read by the end user.
            "%
            = {
                arguments
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of strings to substitute into the message string.
                  "%
                  | optional,
                messageId
                  | String
                  | doc m%"
                  The resource id for a plain text message string.
                  "%
                  | optional,
                richMessageId
                  | String
                  | doc m%"
                  The resource id for a rich text message string.
                  "%
                  | optional,
                richText
                  | String
                  | doc m%"
                  A rich text message string.
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  A plain text message string.
                  "%
                  | optional,
              },
          node
            | doc m%"
            Represents a node in a graph.
            "%
            = {
                children
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.node,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Array of child nodes.
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  A string that uniquely identifies the node within its graph.
                  "%,
                label
                  | definitions.contract.message
                  | doc m%"
                  A short description of the node.
                  "%
                  | optional,
                location
                  | definitions.contract.location
                  | doc m%"
                  A code location associated with the node.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the node.
                  "%
                  | optional,
              },
          notification
            | doc m%"
            Describes a condition relevant to the tool itself, as opposed to being relevant to a target being analyzed by the tool.
            "%
            = {
                exception
                  | definitions.contract.exception
                  | doc m%"
                  The runtime exception, if any, relevant to this notification.
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  An identifier for the condition that was encountered.
                  "%
                  | optional,
                level
                  | predicates.contract_from_predicate
                  (predicates.enum [ "note", "warning", "error" ])
                  | doc m%"
                  A value specifying the severity level of the notification.
                  "%
                  | optional,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message that describes the condition that was encountered.
                  "%,
                physicalLocation
                  | definitions.contract.physicalLocation
                  | doc m%"
                  The file and region relevant to this notification.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the notification.
                  "%
                  | optional,
                ruleId
                  | String
                  | doc m%"
                  The stable, unique identifier of the rule (if any) to which this notification is relevant. This member can be used to retrieve rule metadata from the rules dictionary, if it exists.
                  "%
                  | optional,
                threadId
                  | std.number.Integer
                  | doc m%"
                  The thread identifier of the code that generated the notification.
                  "%
                  | optional,
                time
                  | String
                  | doc m%"
                  The date and time at which the analysis tool generated the notification.
                  "%
                  | optional,
              },
          physicalLocation
            | doc m%"
            A physical location relevant to a result. Specifies a reference to a programming artifact together with a range of bytes or characters within that artifact.
            "%
            = {
                contextRegion
                  | definitions.contract.region
                  | doc m%"
                  Specifies a portion of the file that encloses the region. Allows a viewer to display additional context around the region.
                  "%
                  | optional,
                fileLocation
                  | definitions.contract.fileLocation
                  | doc m%"
                  The location of the file.
                  "%,
                id
                  | std.number.Integer
                  | doc m%"
                  Value that distinguishes this physical location from all other physical locations in this run object.
                  "%
                  | optional,
                region
                  | definitions.contract.region
                  | doc m%"
                  Specifies a portion of the file.
                  "%
                  | optional,
              },
          rectangle
            | doc m%"
            An area within an image.
            "%
            = {
                bottom
                  | Number
                  | doc m%"
                  The Y coordinate of the bottom edge of the rectangle, measured in the image's natural units.
                  "%
                  | optional,
                left
                  | Number
                  | doc m%"
                  The X coordinate of the left edge of the rectangle, measured in the image's natural units.
                  "%
                  | optional,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message relevant to the rectangle.
                  "%
                  | optional,
                right
                  | Number
                  | doc m%"
                  The X coordinate of the right edge of the rectangle, measured in the image's natural units.
                  "%
                  | optional,
                top
                  | Number
                  | doc m%"
                  The Y coordinate of the top edge of the rectangle, measured in the image's natural units.
                  "%
                  | optional,
              },
          region
            | doc m%"
            A region within a file where a result was detected.
            "%
            = {
                byteLength
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  The length of the region in bytes.
                  "%
                  | optional,
                byteOffset
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  The zero-based offset from the beginning of the file of the first byte in the region.
                  "%
                  | optional,
                charLength
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  The length of the region in characters.
                  "%
                  | optional,
                charOffset
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  The zero-based offset from the beginning of the file of the first character in the region.
                  "%
                  | optional,
                endColumn
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  The column number of the character following the end of the region.
                  "%
                  | optional,
                endLine
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  The line number of the last character in the region.
                  "%
                  | optional,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message relevant to the region.
                  "%
                  | optional,
                snippet
                  | definitions.contract.fileContent
                  | doc m%"
                  The portion of the file contents within the specified region.
                  "%
                  | optional,
                startColumn
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  The column number of the first character in the region.
                  "%
                  | optional,
                startLine
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  The line number of the first character in the region.
                  "%
                  | optional,
              },
          replacement
            | doc m%"
            The replacement of a single region of a file.
            "%
            = {
                deletedRegion
                  | definitions.contract.region
                  | doc m%"
                  The region of the file to delete.
                  "%,
                insertedContent
                  | definitions.contract.fileContent
                  | doc m%"
                  The content to insert at the location specified by the 'deletedRegion' property.
                  "%
                  | optional,
              },
          resources
            | doc m%"
            Container for items that require localization.
            "%
            = {
                messageStrings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A dictionary, each of whose keys is a resource identifier and each of whose values is a localized string.
                  "%
                  | optional,
                rules
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.rule
                  ])
                  | doc m%"
                  A dictionary, each of whose keys is a string and each of whose values is a 'rule' object, that describe all rules associated with an analysis tool or a specific run of an analysis tool.
                  "%
                  | optional,
                ..
              },
          result
            | doc m%"
            A result produced by an analysis tool.
            "%
            = {
                analysisTarget
                  | definitions.contract.fileLocation
                  | doc m%"
                  Identifies the file that the analysis tool was instructed to scan. This need not be the same as the file where the result actually occurred.
                  "%
                  | optional,
                attachments
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.attachment,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A set of files relevant to the result.
                  "%
                  | optional,
                baselineState
                  | predicates.contract_from_predicate
                  (predicates.enum [ "new", "existing", "absent" ])
                  | doc m%"
                  The state of a result relative to a baseline of a previous run.
                  "%
                  | optional,
                codeFlows
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.codeFlow,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of 'codeFlow' objects relevant to the result.
                  "%
                  | optional,
                conversionProvenance
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.physicalLocation,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of physicalLocation objects which specify the portions of an analysis tool's output that a converter transformed into the result object.
                  "%
                  | optional,
                correlationGuid
                  | String
                  | doc m%"
                  A stable, unique identifier for the equivalence class of logically identical results to which this result belongs, in the form of a GUID.
                  "%
                  | optional,
                fingerprints
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A set of strings each of which individually defines a stable, unique identity for the result.
                  "%
                  | optional,
                fixes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.fix,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of 'fix' objects, each of which represents a proposed fix to the problem indicated by the result.
                  "%
                  | optional,
                graphTraversals
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.graphTraversal,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of one or more unique 'graphTraversal' objects.
                  "%
                  | optional,
                graphs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.graph,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of one or more unique 'graph' objects.
                  "%
                  | optional,
                instanceGuid
                  | String
                  | doc m%"
                  A stable, unique identifier for the result in the form of a GUID.
                  "%
                  | optional,
                level
                  | predicates.contract_from_predicate
                  (predicates.enum
                  [
                    "notApplicable",
                    "pass",
                    "note",
                    "warning",
                    "error",
                    "open"
                  ])
                  | doc m%"
                  A value specifying the severity level of the result.
                  "%
                  | optional,
                locations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.location,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  One or more locations where the result occurred. Specify only one location unless the problem indicated by the result can only be corrected by making a change at every specified location.
                  "%
                  | optional,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message that describes the result. The first sentence of the message only will be displayed when visible space is limited.
                  "%
                  | optional,
                partialFingerprints
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A set of strings that contribute to the stable, unique identity of the result.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the result.
                  "%
                  | optional,
                relatedLocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.location,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A set of locations relevant to this result.
                  "%
                  | optional,
                ruleId
                  | String
                  | doc m%"
                  The stable, unique identifier of the rule (if any) to which this notification is relevant. This member can be used to retrieve rule metadata from the rules dictionary, if it exists.
                  "%
                  | optional,
                stacks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.stack,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of 'stack' objects relevant to the result.
                  "%
                  | optional,
                suppressionStates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.enum
                    [ "suppressedInSource", "suppressedExternally" ])
                  ])
                  | doc m%"
                  A set of flags indicating one or more suppression conditions.
                  "%
                  | optional,
                workItemUris
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The URIs of the work items associated with this result
                  "%
                  | optional,
              },
          rule
            | doc m%"
            Describes an analysis rule.
            "%
            = {
                configuration
                  | definitions.contract.ruleConfiguration
                  | doc m%"
                  Information about the rule that can be configured at runtime.
                  "%
                  | optional,
                fullDescription
                  | definitions.contract.message
                  | doc m%"
                  A description of the rule. Should, as far as possible, provide details sufficient to enable resolution of any problem indicated by the result.
                  "%
                  | optional,
                help
                  | definitions.contract.message
                  | doc m%"
                  Provides the primary documentation for the rule, useful when there is no online documentation.
                  "%
                  | optional,
                helpUri
                  | String
                  | doc m%"
                  A URI where the primary documentation for the rule can be found.
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  A stable, opaque identifier for the rule.
                  "%,
                messageStrings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A set of name/value pairs with arbitrary names. The value within each name/value pair consists of plain text interspersed with placeholders, which can be used to construct a message in combination with an arbitrary number of additional string arguments.
                  "%
                  | optional,
                name
                  | definitions.contract.message
                  | doc m%"
                  A rule identifier that is understandable to an end user.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the rule.
                  "%
                  | optional,
                richMessageStrings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A set of name/value pairs with arbitrary names. The value within each name/value pair consists of rich text interspersed with placeholders, which can be used to construct a message in combination with an arbitrary number of additional string arguments.
                  "%
                  | optional,
                shortDescription
                  | definitions.contract.message
                  | doc m%"
                  A concise description of the rule. Should be a single sentence that is understandable when visible space is limited to a single line of text.
                  "%
                  | optional,
              },
          ruleConfiguration
            | doc m%"
            Information about a rule that can be configured at runtime.
            "%
            = {
                defaultLevel
                  | predicates.contract_from_predicate
                  (predicates.enum [ "note", "warning", "error", "open" ])
                  | doc m%"
                  Specifies the default severity level of the result.
                  "%
                  | optional,
                enabled
                  | Bool
                  | doc m%"
                  Specifies whether the rule will be evaluated during the scan.
                  "%
                  | optional,
                parameters
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional configuration information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Contains configuration information specific to this rule.
                  "%
                  | optional,
              },
          run
            | doc m%"
            Describes a single run of an analysis tool, and contains the output of that run.
            "%
            = {
                architecture
                  | String
                  | doc m%"
                  The hardware architecture for which the run was targeted.
                  "%
                  | optional,
                automationLogicalId
                  | String
                  | doc m%"
                  A global identifier that allows the run to be correlated with other artifacts produced by a larger automation process.
                  "%
                  | optional,
                baselineInstanceGuid
                  | String
                  | doc m%"
                  The 'instanceGuid' property of a previous SARIF 'run' that comprises the baseline that was used to compute result 'baselineState' properties for the run.
                  "%
                  | optional,
                columnKind
                  | predicates.contract_from_predicate
                  (predicates.enum [ "utf16CodeUnits", "unicodeCodePoints" ])
                  | doc m%"
                  Specifies the unit in which the tool measures columns.
                  "%
                  | optional,
                conversion
                  | definitions.contract.conversion
                  | doc m%"
                  A conversion object that describes how a converter transformed an analysis tool's native output format into the SARIF format.
                  "%
                  | optional,
                correlationGuid
                  | String
                  | doc m%"
                  A stable, unique identifier for the class of related runs to which this run belongs, in the form of a GUID.
                  "%
                  | optional,
                defaultFileEncoding
                  | String
                  | doc m%"
                  Specifies the default encoding for any file object that refers to a text file.
                  "%
                  | optional,
                description
                  | definitions.contract.message
                  | doc m%"
                  A description of the run.
                  "%
                  | optional,
                files
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.file
                  ])
                  | doc m%"
                  A dictionary, each of whose keys is a URI and each of whose values is a file object.
                  "%
                  | optional,
                graphs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.graph,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of one or more unique 'graph' objects.
                  "%
                  | optional,
                instanceGuid
                  | String
                  | doc m%"
                  A stable, unique identifier for the run, in the form of a GUID.
                  "%
                  | optional,
                invocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.invocation,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Describes the invocation of the analysis tool.
                  "%
                  | optional,
                logicalId
                  | String
                  | doc m%"
                  A logical identifier for a run, for example, 'nightly Clang analyzer run'. Multiple runs of the same type can have the same logical id.
                  "%
                  | optional,
                logicalLocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.logicalLocation
                  ])
                  | doc m%"
                  A dictionary, each of whose keys specifies a logical location such as a namespace, type or function.
                  "%
                  | optional,
                originalUriBaseIds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  The absolute URI specified by each uriBaseId symbol on the machine where the tool originally ran.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information about the run.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the run.
                  "%
                  | optional,
                redactionToken
                  | String
                  | doc m%"
                  The string used to replace sensitive information in a redaction-aware property.
                  "%
                  | optional,
                resources
                  | definitions.contract.resources
                  | doc m%"
                  Items that can be localized, such as message strings and rule metadata.
                  "%
                  | optional,
                results
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.result,
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  The set of results contained in an SARIF log. The results array can be omitted when a run is solely exporting rules metadata. It must be present (but may be empty) if a log file represents an actual scan.
                  "%
                  | optional,
                richMessageMimeType
                  | String
                  | doc m%"
                  The MIME type of all rich text message properties in the run. Default: "text/markdown;variant=GFM"
                  "%
                  | optional,
                tool
                  | definitions.contract.tool
                  | doc m%"
                  Information about the tool or tool pipeline that generated the results in this run. A run can only contain results produced by a single tool or tool pipeline. A run can aggregate results from multiple log files, as long as context around the tool run (tool command-line arguments and the like) is identical for all aggregated files.
                  "%,
                versionControlProvenance
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.versionControlDetails,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Specifies the revision in version control of the files that were scanned.
                  "%
                  | optional,
              },
          stack
            | doc m%"
            A call stack that is relevant to a result.
            "%
            = {
                frames
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.stackFrame,
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  An array of stack frames that represent a sequence of calls, rendered in reverse chronological order, that comprise the call stack.
                  "%,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message relevant to this call stack.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the stack.
                  "%
                  | optional,
              },
          stackFrame
            | doc m%"
            A function call within a stack trace.
            "%
            = {
                address
                  | std.number.Integer
                  | doc m%"
                  The address of the method or function that is executing.
                  "%
                  | optional,
                location
                  | definitions.contract.location
                  | doc m%"
                  The location to which this stack frame refers.
                  "%
                  | optional,
                module
                  | String
                  | doc m%"
                  The name of the module that contains the code of this stack frame.
                  "%
                  | optional,
                offset
                  | std.number.Integer
                  | doc m%"
                  The offset from the method or function that is executing.
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The parameters of the call that is executing.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the stack frame.
                  "%
                  | optional,
                threadId
                  | std.number.Integer
                  | doc m%"
                  The thread identifier of the stack frame.
                  "%
                  | optional,
              },
          threadFlow = {
                id
                  | String
                  | doc m%"
                  An string that uniquely identifies the threadFlow within the codeFlow in which it occurs.
                  "%
                  | optional,
                locations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.threadFlowLocation,
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  A temporally ordered array of 'threadFlowLocation' objects, each of which describes a location visited by the tool while producing the result.
                  "%,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message relevant to the thread flow.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the thread flow.
                  "%
                  | optional,
                ..
              },
          threadFlowLocation
            | doc m%"
            A location visited by an analysis tool while simulating or monitoring the execution of a program.
            "%
            = {
                executionOrder
                  | std.number.Integer
                  | doc m%"
                  An integer representing the temporal order in which execution reached this location.
                  "%
                  | optional,
                importance
                  | predicates.contract_from_predicate
                  (predicates.enum [ "important", "essential", "unimportant" ])
                  | doc m%"
                  Specifies the importance of this location in understanding the code flow in which it occurs. The order from most to least important is "essential", "important", "unimportant". Default: "important".
                  "%
                  | optional,
                kind
                  | String
                  | doc m%"
                  A string describing the type of this location.
                  "%
                  | optional,
                location
                  | definitions.contract.location
                  | doc m%"
                  The code location.
                  "%
                  | optional,
                module
                  | String
                  | doc m%"
                  The name of the module that contains the code that is executing.
                  "%
                  | optional,
                nestingLevel
                  | std.number.Integer
                  | doc m%"
                  An integer representing a containment hierarchy within the thread flow
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the code location.
                  "%
                  | optional,
                stack
                  | definitions.contract.stack
                  | doc m%"
                  The call stack leading to this location.
                  "%
                  | optional,
                state
                  | {  .. }
                  | doc m%"
                  A dictionary, each of whose keys specifies a variable or expression, the associated value of which represents the variable or expression value. For an annotation of kind 'continuation', for example, this dictionary might hold the current assumed values of a set of global variables.
                  "%
                  | optional,
                step
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  The 0-based sequence number of the location in the code flow within which it occurs.
                  "%
                  | optional,
                timestamp
                  | String
                  | doc m%"
                  The time at which this location was executed.
                  "%
                  | optional,
              },
          tool
            | doc m%"
            The analysis tool that was run.
            "%
            = {
                downloadUri
                  | String
                  | doc m%"
                  The absolute URI from which the tool can be downloaded.
                  "%
                  | optional,
                fileVersion
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "[0-9]+(\\.[0-9]+){3}"
                  ])
                  | doc m%"
                  The binary version of the tool's primary executable file (for operating systems such as Windows that provide that information).
                  "%
                  | optional,
                fullName
                  | String
                  | doc m%"
                  The name of the tool along with its version and any other useful identifying information, such as its locale.
                  "%
                  | optional,
                language
                  | String
                  | doc m%"
                  The tool language (expressed as an ISO 649 two-letter lowercase culture code) and region (expressed as an ISO 3166 two-letter uppercase subculture code associated with a country or region).
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the tool.
                  "%,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the tool.
                  "%
                  | optional,
                sarifLoggerVersion
                  | String
                  | doc m%"
                  A version that uniquely identifies the SARIF logging component that generated this file, if it is versioned separately from the tool.
                  "%
                  | optional,
                semanticVersion
                  | String
                  | doc m%"
                  The tool version in the format specified by Semantic Versioning 2.0.
                  "%
                  | optional,
                version
                  | String
                  | doc m%"
                  The tool version, in whatever format the tool natively provides.
                  "%
                  | optional,
              },
          versionControlDetails
            | doc m%"
            Specifies the information necessary to retrieve a desired revision from a version control system.
            "%
            = {
                branch
                  | String
                  | doc m%"
                  The name of a branch containing the revision.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the revision.
                  "%
                  | optional,
                revisionId
                  | String
                  | doc m%"
                  A string that uniquely and permanently identifies the revision within the repository.
                  "%
                  | optional,
                tag
                  | String
                  | doc m%"
                  A tag that has been applied to the revision.
                  "%
                  | optional,
                timestamp
                  | String
                  | doc m%"
                  The date and time at which the revision was created.
                  "%
                  | optional,
                uri
                  | String
                  | doc m%"
                  The absolute URI of the repository.
                  "%,
              },
        },
    predicate = {
          attachment
            | doc m%"
            A file relevant to a tool invocation or to a result.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fileLocation" ],
                predicates.records.record
                {
                  description = definitions.predicate.message,
                  fileLocation = definitions.predicate.fileLocation,
                  rectangles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.rectangle,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  regions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.region,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          codeFlow
            | doc m%"
            A set of threadFlows which together describe a pattern of code execution relevant to detecting a result.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "threadFlows" ],
                predicates.records.record
                {
                  message = definitions.predicate.message,
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  threadFlows = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.threadFlow,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          conversion
            | doc m%"
            Describes how a converter transformed the output of a static analysis tool from the analysis tool's native output format into the SARIF format.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tool" ],
                predicates.records.record
                {
                  analysisToolLogFiles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.fileLocation,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  invocation = definitions.predicate.invocation,
                  tool = definitions.predicate.tool,
                }
                {  }
                false
                predicates.never
              ],
          edge
            | doc m%"
            Represents a directed edge in a graph.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "id", "sourceNodeId", "targetNodeId" ],
                predicates.records.record
                {
                  id = predicates.isType '"String",
                  label = definitions.predicate.message,
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  sourceNodeId = predicates.isType '"String",
                  targetNodeId = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          edgeTraversal
            | doc m%"
            Represents the traversal of a single edge during a graph traversal.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "edgeId" ],
                predicates.records.record
                {
                  edgeId = predicates.isType '"String",
                  finalState = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  message = definitions.predicate.message,
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  stepOverEdgeCount = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          exception = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  innerExceptions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.exception
                      ],
                  kind = predicates.isType '"String",
                  message = predicates.isType '"String",
                  stack = definitions.predicate.stack,
                }
                {  }
                true
                predicates.always
              ],
          externalFiles
            | doc m%"
            References to external files that should be inlined with the content of a root log file.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  conversion = definitions.predicate.fileLocation,
                  files = definitions.predicate.fileLocation,
                  graphs = definitions.predicate.fileLocation,
                  invocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.fileLocation,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  logicalLocations = definitions.predicate.fileLocation,
                  resources = definitions.predicate.fileLocation,
                  results = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.fileLocation,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          file
            | doc m%"
            A single file. In some cases, this file might be nested within another file.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  contents = definitions.predicate.fileContent,
                  encoding = predicates.isType '"String",
                  fileLocation = definitions.predicate.fileLocation,
                  hashes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.hash,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  lastModifiedTime = predicates.isType '"String",
                  length = predicates.isType 'Integer,
                  mimeType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "[^/]+/.+"
                      ],
                  offset = predicates.isType 'Integer,
                  parentKey = predicates.isType '"String",
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  roles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.enum
                        [
                          "analysisTarget",
                          "attachment",
                          "responseFile",
                          "resultFile",
                          "standardStream",
                          "traceFile",
                          "unmodifiedFile",
                          "modifiedFile",
                          "addedFile",
                          "deletedFile",
                          "renamedFile",
                          "uncontrolledFile"
                        ]),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          fileChange
            | doc m%"
            A change to a single file.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fileLocation", "replacements" ],
                predicates.records.record
                {
                  fileLocation = definitions.predicate.fileLocation,
                  replacements = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.replacement,
                        predicates.arrays.minItems 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          fileContent
            | doc m%"
            Represents content from an external file.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  binary = predicates.isType '"String",
                  text = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          fileLocation
            | doc m%"
            Specifies the location of a file.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "uri" ],
                predicates.records.record
                {
                  uri = predicates.isType '"String",
                  uriBaseId = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          fix
            | doc m%"
            A proposed fix for the problem represented by a result object. A fix specifies a set of file to modify. For each file, it specifies a set of bytes to remove, and provides a set of new bytes to replace them.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fileChanges" ],
                predicates.records.record
                {
                  description = definitions.predicate.message,
                  fileChanges = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.fileChange
                      ],
                }
                {  }
                false
                predicates.never
              ],
          graph
            | doc m%"
            A network of nodes and directed edges that describes some aspect of the structure of the code (for example, a call graph).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "edges", "id", "nodes" ],
                predicates.records.record
                {
                  description = definitions.predicate.message,
                  edges = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.edge
                      ],
                  id = predicates.isType '"String",
                  nodes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.node
                      ],
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
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
          graphTraversal
            | doc m%"
            Represents a path through a graph.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "edgeTraversals", "graphId" ],
                predicates.records.record
                {
                  description = definitions.predicate.message,
                  edgeTraversals = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.edgeTraversal
                      ],
                  graphId = predicates.isType '"String",
                  initialState = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
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
          hash
            | doc m%"
            A hash value of some file or collection of files, together with the hash function used to compute the hash.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "algorithm", "value" ],
                predicates.records.record
                {
                  algorithm = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          invocation
            | doc m%"
            The runtime environment of the analysis tool run.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  account = predicates.isType '"String",
                  arguments = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  attachments = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.attachment,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  commandLine = predicates.isType '"String",
                  configurationNotifications = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.notification
                      ],
                  endTime = predicates.isType '"String",
                  environmentVariables = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  executableLocation = definitions.predicate.fileLocation,
                  exitCode = predicates.isType 'Integer,
                  exitCodeDescription = predicates.isType '"String",
                  exitSignalName = predicates.isType '"String",
                  exitSignalNumber = predicates.isType 'Integer,
                  machine = predicates.isType '"String",
                  processId = predicates.isType 'Integer,
                  processStartFailureMessage = predicates.isType '"String",
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  responseFiles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.fileLocation
                      ],
                  startTime = predicates.isType '"String",
                  stderr = definitions.predicate.fileLocation,
                  stdin = definitions.predicate.fileLocation,
                  stdout = definitions.predicate.fileLocation,
                  stdoutStderr = definitions.predicate.fileLocation,
                  toolExecutionSuccessful = predicates.isType '"Bool",
                  toolNotifications = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.notification
                      ],
                  workingDirectory = definitions.predicate.fileLocation,
                }
                {  }
                false
                predicates.never
              ],
          location
            | doc m%"
            A location within a programming artifact.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.region,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  fullyQualifiedLogicalName = predicates.isType '"String",
                  message = definitions.predicate.message,
                  physicalLocation = definitions.predicate.physicalLocation,
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
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
          logicalLocation
            | doc m%"
            A logical location of a construct that produced a result.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  decoratedName = predicates.isType '"String",
                  fullyQualifiedName = predicates.isType '"String",
                  kind = predicates.isType '"String",
                  name = predicates.isType '"String",
                  parentKey = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          message
            | doc m%"
            Encapsulates a message intended to be read by the end user.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  arguments = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  messageId = predicates.isType '"String",
                  richMessageId = predicates.isType '"String",
                  richText = predicates.isType '"String",
                  text = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          node
            | doc m%"
            Represents a node in a graph.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  children = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.node,
                        predicates.arrays.uniqueItems
                      ],
                  id = predicates.isType '"String",
                  label = definitions.predicate.message,
                  location = definitions.predicate.location,
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
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
          notification
            | doc m%"
            Describes a condition relevant to the tool itself, as opposed to being relevant to a target being analyzed by the tool.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "message" ],
                predicates.records.record
                {
                  exception = definitions.predicate.exception,
                  id = predicates.isType '"String",
                  level = predicates.enum [ "note", "warning", "error" ],
                  message = definitions.predicate.message,
                  physicalLocation = definitions.predicate.physicalLocation,
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  ruleId = predicates.isType '"String",
                  threadId = predicates.isType 'Integer,
                  time = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          physicalLocation
            | doc m%"
            A physical location relevant to a result. Specifies a reference to a programming artifact together with a range of bytes or characters within that artifact.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fileLocation" ],
                predicates.records.record
                {
                  contextRegion = definitions.predicate.region,
                  fileLocation = definitions.predicate.fileLocation,
                  id = predicates.isType 'Integer,
                  region = definitions.predicate.region,
                }
                {  }
                false
                predicates.never
              ],
          rectangle
            | doc m%"
            An area within an image.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bottom = predicates.isType '"Number",
                  left = predicates.isType '"Number",
                  message = definitions.predicate.message,
                  right = predicates.isType '"Number",
                  top = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          region
            | doc m%"
            A region within a file where a result was detected.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  byteLength = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  byteOffset = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  charLength = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  charOffset = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  endColumn = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                  endLine = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                  message = definitions.predicate.message,
                  snippet = definitions.predicate.fileContent,
                  startColumn = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                  startLine = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          replacement
            | doc m%"
            The replacement of a single region of a file.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "deletedRegion" ],
                predicates.records.record
                {
                  deletedRegion = definitions.predicate.region,
                  insertedContent = definitions.predicate.fileContent,
                }
                {  }
                false
                predicates.never
              ],
          resources
            | doc m%"
            Container for items that require localization.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  messageStrings = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  rules = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.rule
                      ],
                }
                {  }
                true
                predicates.always
              ],
          result
            | doc m%"
            A result produced by an analysis tool.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  analysisTarget = definitions.predicate.fileLocation,
                  attachments = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.attachment,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  baselineState = predicates.enum
                      [ "new", "existing", "absent" ],
                  codeFlows = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.codeFlow,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  conversionProvenance = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.physicalLocation,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  correlationGuid = predicates.isType '"String",
                  fingerprints = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  fixes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.fix,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  graphTraversals = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.graphTraversal,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  graphs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.graph,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  instanceGuid = predicates.isType '"String",
                  level = predicates.enum
                      [
                        "notApplicable",
                        "pass",
                        "note",
                        "warning",
                        "error",
                        "open"
                      ],
                  locations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.location,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  message = definitions.predicate.message,
                  partialFingerprints = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  relatedLocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.location,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  ruleId = predicates.isType '"String",
                  stacks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.stack,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  suppressionStates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.enum
                        [ "suppressedInSource", "suppressedExternally" ])
                      ],
                  workItemUris = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          rule
            | doc m%"
            Describes an analysis rule.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  configuration = definitions.predicate.ruleConfiguration,
                  fullDescription = definitions.predicate.message,
                  help = definitions.predicate.message,
                  helpUri = predicates.isType '"String",
                  id = predicates.isType '"String",
                  messageStrings = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  name = definitions.predicate.message,
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  richMessageStrings = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  shortDescription = definitions.predicate.message,
                }
                {  }
                false
                predicates.never
              ],
          ruleConfiguration
            | doc m%"
            Information about a rule that can be configured at runtime.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultLevel = predicates.enum
                      [ "note", "warning", "error", "open" ],
                  enabled = predicates.isType '"Bool",
                  parameters = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
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
          run
            | doc m%"
            Describes a single run of an analysis tool, and contains the output of that run.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tool" ],
                predicates.records.record
                {
                  architecture = predicates.isType '"String",
                  automationLogicalId = predicates.isType '"String",
                  baselineInstanceGuid = predicates.isType '"String",
                  columnKind = predicates.enum
                      [ "utf16CodeUnits", "unicodeCodePoints" ],
                  conversion = definitions.predicate.conversion,
                  correlationGuid = predicates.isType '"String",
                  defaultFileEncoding = predicates.isType '"String",
                  description = definitions.predicate.message,
                  files = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.file
                      ],
                  graphs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.graph,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  instanceGuid = predicates.isType '"String",
                  invocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.invocation,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  logicalId = predicates.isType '"String",
                  logicalLocations = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.logicalLocation
                      ],
                  originalUriBaseIds = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  redactionToken = predicates.isType '"String",
                  resources = definitions.predicate.resources,
                  results = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.result,
                        predicates.arrays.minItems 0
                      ],
                  richMessageMimeType = predicates.isType '"String",
                  tool = definitions.predicate.tool,
                  versionControlProvenance = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.versionControlDetails,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          stack
            | doc m%"
            A call stack that is relevant to a result.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "frames" ],
                predicates.records.record
                {
                  frames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.stackFrame,
                        predicates.arrays.minItems 1
                      ],
                  message = definitions.predicate.message,
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
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
          stackFrame
            | doc m%"
            A function call within a stack trace.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  address = predicates.isType 'Integer,
                  location = definitions.predicate.location,
                  module = predicates.isType '"String",
                  offset = predicates.isType 'Integer,
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  threadId = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          threadFlow = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "locations" ],
                predicates.records.record
                {
                  id = predicates.isType '"String",
                  locations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.threadFlowLocation,
                        predicates.arrays.minItems 1
                      ],
                  message = definitions.predicate.message,
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
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
          threadFlowLocation
            | doc m%"
            A location visited by an analysis tool while simulating or monitoring the execution of a program.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  executionOrder = predicates.isType 'Integer,
                  importance = predicates.enum
                      [ "important", "essential", "unimportant" ],
                  kind = predicates.isType '"String",
                  location = definitions.predicate.location,
                  module = predicates.isType '"String",
                  nestingLevel = predicates.isType 'Integer,
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  stack = definitions.predicate.stack,
                  state = predicates.isType 'Record,
                  step = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  timestamp = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          tool
            | doc m%"
            The analysis tool that was run.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  downloadUri = predicates.isType '"String",
                  fileVersion = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "[0-9]+(\\.[0-9]+){3}"
                      ],
                  fullName = predicates.isType '"String",
                  language = predicates.isType '"String",
                  name = predicates.isType '"String",
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  sarifLoggerVersion = predicates.isType '"String",
                  semanticVersion = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          versionControlDetails
            | doc m%"
            Specifies the information necessary to retrieve a desired revision from a version control system.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "uri" ],
                predicates.records.record
                {
                  branch = predicates.isType '"String",
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  revisionId = predicates.isType '"String",
                  tag = predicates.isType '"String",
                  timestamp = predicates.isType '"String",
                  uri = predicates.isType '"String",
                }
                {  }
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
  predicates.records.required [ "runs", "version" ],
  predicates.records.record
  {
    "$schema" = predicates.isType '"String",
    runs = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.run,
          predicates.arrays.minItems 1
        ],
    version = predicates.enum [ "2.0.0" ],
  }
  {  }
  false
  predicates.never
])