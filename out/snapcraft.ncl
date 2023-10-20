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
          apt-deb
            | doc m%"
            deb repositories
            "%
            = predicates.contract_from_predicate definitions.predicate.apt-deb,
          apt-ppa
            | doc m%"
            PPA repository
            "%
            = predicates.contract_from_predicate definitions.predicate.apt-ppa,
          build-environment-grammar = predicates.contract_from_predicate
              definitions.predicate.build-environment-grammar,
          environment
            | doc m%"
            environment entries
            "%
            = predicates.contract_from_predicate
              definitions.predicate.environment,
          grammar-array = predicates.contract_from_predicate
              definitions.predicate.grammar-array,
          grammar-string = predicates.contract_from_predicate
              definitions.predicate.grammar-string,
          system-username-scope
            | doc m%"
            short-form user configuration (<username>: <scope>)
            "%
            = std.contract.Sequence [ std.enum.TagOrString, [| 'shared |] ],
        },
    predicate = {
          apt-deb
            | doc m%"
            deb repositories
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key-id", "type", "url" ],
                predicates.records.record
                {
                  architectures = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  components = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  formats = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "deb", "deb-src" ]
                        ]),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  key-id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^[A-Z0-9]{40}$"
                      ],
                  key-server = predicates.isType '"String",
                  path = predicates.isType '"String",
                  suites = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "apt" ]
                      ],
                  url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          apt-ppa
            | doc m%"
            PPA repository
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "ppa", "type" ],
                predicates.records.record
                {
                  ppa = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "apt" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          build-environment-grammar = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.maxProperties 1,
                    predicates.records.minProperties 1,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      "^on\\s+.+$" =
                        definitions.predicate.build-environment-grammar,
                    }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      "^to\\s+.+$" =
                        definitions.predicate.build-environment-grammar,
                    }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      "^else$" =
                        definitions.predicate.build-environment-grammar,
                    }
                    false
                    predicates.never
                  ]
                ]),
                predicates.arrays.uniqueItems
              ],
          environment
            | doc m%"
            environment entries
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.arrays.minItems 1,
                predicates.records.record {  } {  } true
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ],
                  predicates.isType '"Number"
                ])
              ],
          grammar-array = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.oneOf
                [
                  predicates.isType '"String",
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { "^on\\s+.+$" = definitions.predicate.grammar-array, }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { "^to\\s+.+$" = definitions.predicate.grammar-array, }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { "^try$" = definitions.predicate.grammar-array, }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { "^else$" = definitions.predicate.grammar-array, }
                    false
                    predicates.never
                  ]
                ]),
                predicates.arrays.uniqueItems
              ],
          grammar-string = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.oneOf
                    [
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { "^on\\s+.+$" = definitions.predicate.grammar-string, }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { "^to\\s+.+$" = definitions.predicate.grammar-string, }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { "^try$" = definitions.predicate.grammar-string, }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { "^else$" = definitions.predicate.grammar-string, }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "else fail"
                      ]
                    ],
                    predicates.arrays.uniqueItems
                  ])
                ]
              ],
          system-username-scope
            | doc m%"
            short-form user configuration (<username>: <scope>)
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.enum [ "shared" ] ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.allOf
  [
    predicates.anyOf
    [
      predicates.allOf
      [
        predicates.allOf
        [
          predicates.allOf
          [
            predicates.records.required [ "type" ],
            predicates.records.record {  } {  } true predicates.always
          ],
          predicates.not
          (predicates.allOf
          [
            predicates.records.required [ "base" ],
            predicates.records.record {  } {  } true predicates.always
          ])
        ],
        predicates.records.record
        { type = predicates.enum [ "base", "kernel", "snapd" ], }
        {  }
        true
        predicates.always
      ],
      predicates.allOf
      [
        predicates.allOf
        [
          predicates.records.required [ "base" ],
          predicates.records.record {  } {  } true predicates.always
        ],
        predicates.records.record
        { type = predicates.enum [ "app", "gadget" ], }
        {  }
        true
        predicates.always
      ],
      predicates.allOf
      [
        predicates.records.required [ "build-base" ],
        predicates.records.record { base = predicates.enum [ "bare" ], } {  }
        true
        predicates.always
      ]
    ],
    predicates.anyOf
    [
      predicates.allOf
      [
        predicates.records.required [ "description", "summary", "version" ],
        predicates.records.record {  } {  } true predicates.always
      ],
      predicates.allOf
      [
        predicates.records.required [ "adopt-info" ],
        predicates.records.record {  } {  } true predicates.always
      ]
    ]
  ],
  predicates.records.required [ "name", "parts" ],
  predicates.records.record
  {
    adopt-info = predicates.isType '"String",
    apps = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "^[a-zA-Z0-9](?:-?[a-zA-Z0-9])*$" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "command" ],
                  predicates.records.record
                  {
                    activates-on = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.uniqueItems
                        ],
                    adapter = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "none", "legacy", "full" ]
                        ],
                    after = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.uniqueItems
                        ],
                    aliases = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern
                            "^[a-zA-Z0-9][-_.a-zA-Z0-9]*$"
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                    autostart = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^[A-Za-z0-9. _#:$-]+\\.desktop$"
                        ],
                    before = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.uniqueItems
                        ],
                    bus-name = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^[A-Za-z0-9/. _#:$-]*$"
                        ],
                    command = predicates.isType '"String",
                    command-chain = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "^[A-Za-z0-9/._#:$-]*$"
                          ])
                        ],
                    common-id = predicates.isType '"String",
                    completer = predicates.isType '"String",
                    daemon = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "simple", "forking", "oneshot", "notify", "dbus" ]
                        ],
                    desktop = predicates.isType '"String",
                    environment = definitions.predicate.environment,
                    extensions = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.enum
                          [
                            "flutter-stable",
                            "flutter-beta",
                            "flutter-dev",
                            "flutter-master",
                            "gnome",
                            "gnome-3-28",
                            "gnome-3-34",
                            "gnome-3-38",
                            "kde-neon",
                            "ros1-noetic",
                            "ros1-noetic-desktop",
                            "ros1-noetic-perception",
                            "ros1-noetic-robot",
                            "ros1-noetic-ros-base",
                            "ros1-noetic-ros-core",
                            "ros2-foxy",
                            "ros2-foxy-ros-base",
                            "ros2-foxy-ros-core",
                            "ros2-foxy-desktop"
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                    install-mode = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "enable", "disable" ]
                        ],
                    passthrough = predicates.isType 'Record,
                    plugs = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.uniqueItems
                        ],
                    post-stop-command = predicates.isType '"String",
                    refresh-mode = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "endure", "restart" ]
                        ],
                    reload-command = predicates.isType '"String",
                    restart-condition = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "on-success",
                            "on-failure",
                            "on-abnormal",
                            "on-abort",
                            "on-watchdog",
                            "always",
                            "never"
                          ]
                        ],
                    restart-delay = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^[0-9]+(ns|us|ms|s|m)*$"
                        ],
                    slots = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.uniqueItems
                        ],
                    sockets = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          {
                            "^[a-z][a-z0-9_-]*$" = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "listen-stream" ],
                                  predicates.records.record
                                  {
                                    listen-stream = predicates.anyOf
                                        [
                                          predicates.allOf
                                          [
                                            predicates.isType 'Integer,
                                            predicates.numbers.maximum 65535,
                                            predicates.numbers.minimum 1
                                          ],
                                          predicates.isType '"String"
                                        ],
                                    socket-mode = predicates.isType 'Integer,
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                          }
                          false
                          predicates.never
                        ],
                    start-timeout = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^[0-9]+(ns|us|ms|s|m)*$"
                        ],
                    stop-command = predicates.isType '"String",
                    stop-mode = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "sigterm",
                            "sigterm-all",
                            "sighup",
                            "sighup-all",
                            "sigusr1",
                            "sigusr1-all",
                            "sigusr2",
                            "sigusr2-all",
                            "sigint",
                            "sigint-all"
                          ]
                        ],
                    stop-timeout = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^[0-9]+(ns|us|ms|s|m)*$"
                        ],
                    timer = predicates.isType '"String",
                    watchdog-timeout = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^[0-9]+(ns|us|ms|s|m)*$"
                        ],
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.dependencies
                  {
                    activates-on = [ "daemon" ],
                    after = [ "daemon" ],
                    before = [ "daemon" ],
                    bus-name = [ "daemon" ],
                    install-mode = [ "daemon" ],
                    post-stop-command = [ "daemon" ],
                    refresh-mode = [ "daemon" ],
                    reload-command = [ "daemon" ],
                    restart-condition = [ "daemon" ],
                    restart-delay = [ "daemon" ],
                    start-timeout = [ "daemon" ],
                    stop-command = [ "daemon" ],
                    stop-mode = [ "daemon" ],
                    stop-timeout = [ "daemon" ],
                    timer = [ "daemon" ],
                    watchdog-timeout = [ "daemon" ],
                  }
                ],
          }
          false
          predicates.never
        ],
    architectures = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.anyOf
          [
            predicates.isType '"String",
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.required [ "build-on" ],
              predicates.records.record
              {
                build-on = predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ]
                    ],
                run-on = predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ]
                    ],
              }
              {  }
              false
              predicates.never
            ]
          ]),
          predicates.arrays.minItems 1,
          predicates.arrays.uniqueItems
        ],
    assumes = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.items [ predicates.isType '"String" ],
          predicates.arrays.minItems 1,
          predicates.arrays.uniqueItems
        ],
    base = predicates.isType '"String",
    build-base = predicates.isType '"String",
    build-packages = definitions.predicate.grammar-array,
    compression = predicates.allOf
        [ predicates.isType '"String", predicates.enum [ "lzo", "xz" ] ],
    confinement = predicates.allOf
        [
          predicates.isType '"String",
          predicates.enum [ "classic", "devmode", "strict" ]
        ],
    contact = predicates.oneOf
        [
          predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.items [ predicates.isType '"String" ],
            predicates.arrays.minItems 1,
            predicates.arrays.uniqueItems
          ],
          predicates.isType '"String"
        ],
    description = predicates.allOf
        [ predicates.isType '"String", predicates.strings.pattern ".+" ],
    donation = predicates.oneOf
        [
          predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.items [ predicates.isType '"String" ],
            predicates.arrays.minItems 1,
            predicates.arrays.uniqueItems
          ],
          predicates.isType '"String"
        ],
    environment = definitions.predicate.environment,
    epoch = predicates.always,
    frameworks = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.items [ predicates.isType '"String" ],
          predicates.arrays.minItems 1,
          predicates.arrays.uniqueItems
        ],
    grade = predicates.allOf
        [ predicates.isType '"String", predicates.enum [ "stable", "devel" ] ],
    hooks = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "^[a-z](?:-?[a-z0-9])*$" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    command-chain = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "^[A-Za-z0-9/._#:$-]*$"
                          ])
                        ],
                    environment = definitions.predicate.environment,
                    passthrough = predicates.isType 'Record,
                    plugs = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.uniqueItems
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
          }
          false
          predicates.never
        ],
    icon = predicates.isType '"String",
    issues = predicates.oneOf
        [
          predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.items [ predicates.isType '"String" ],
            predicates.arrays.minItems 1,
            predicates.arrays.uniqueItems
          ],
          predicates.isType '"String"
        ],
    layout = predicates.isType 'Record,
    license = predicates.isType '"String",
    name = predicates.allOf
        [
          predicates.allOf
          [ predicates.isType '"String", predicates.strings.maxLength 40 ],
          predicates.strings.pattern "^[a-z0-9-]*[a-z][a-z0-9-]*$",
          predicates.strings.pattern "^[^-]",
          predicates.strings.pattern "[^-]$",
          predicates.not (predicates.strings.pattern "--")
        ],
    package-repositories = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.items
          [
            predicates.oneOf
            [ definitions.predicate.apt-deb, definitions.predicate.apt-ppa ]
          ],
          predicates.arrays.minItems 0,
          predicates.arrays.uniqueItems
        ],
    parts = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.minProperties 1,
          predicates.records.record {  }
          {
            "^(?!plugins$)[a-z0-9][a-z0-9+-]*$" = predicates.allOf
                [
                  predicates.anyOf
                  [ predicates.isType 'Record, predicates.isType 'Null ],
                  predicates.records.minProperties 1,
                  predicates.records.required [ "plugin" ],
                  predicates.records.record
                  {
                    after = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.uniqueItems
                        ],
                    build-attributes = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "core22-step-dependencies",
                              "enable-patchelf",
                              "no-patchelf",
                              "no-install",
                              "debug",
                              "keep-execstack"
                            ]
                          ]),
                          predicates.arrays.uniqueItems
                        ],
                    build-environment =
                      definitions.predicate.build-environment-grammar,
                    build-packages = definitions.predicate.grammar-array,
                    build-snaps = definitions.predicate.grammar-array,
                    disable-parallel = predicates.isType '"Bool",
                    filesets = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.isType '"Array")
                        ],
                    organize = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ])
                        ],
                    override-build = predicates.isType '"String",
                    override-prime = predicates.isType '"String",
                    override-pull = predicates.isType '"String",
                    override-stage = predicates.isType '"String",
                    parse-info = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.uniqueItems
                        ],
                    plugin = predicates.isType '"String",
                    prime = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.uniqueItems
                        ],
                    source = definitions.predicate.grammar-string,
                    source-branch = predicates.isType '"String",
                    source-checksum = predicates.isType '"String",
                    source-commit = predicates.isType '"String",
                    source-depth = predicates.isType 'Integer,
                    source-subdir = predicates.isType '"String",
                    source-submodules = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.minItems 0,
                          predicates.arrays.uniqueItems
                        ],
                    source-tag = predicates.isType '"String",
                    source-type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "bzr",
                            "git",
                            "hg",
                            "mercurial",
                            "subversion",
                            "svn",
                            "tar",
                            "zip",
                            "deb",
                            "rpm",
                            "7z",
                            "local"
                          ]
                        ],
                    stage = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.uniqueItems
                        ],
                    stage-packages = definitions.predicate.grammar-array,
                    stage-snaps = definitions.predicate.grammar-array,
                  }
                  {  }
                  true
                  predicates.always
                ],
          }
          false
          predicates.never
        ],
    passthrough = predicates.isType 'Record,
    plugs = predicates.isType 'Record,
    slots = predicates.isType 'Record,
    source-code = predicates.isType '"String",
    summary = predicates.allOf
        [ predicates.isType '"String", predicates.strings.maxLength 78 ],
    system-usernames = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "^snap_(daemon|microk8s|aziotedge|aziotdu)$" = predicates.oneOf
                [
                  definitions.predicate.system-username-scope,
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "scope" ],
                    predicates.records.record
                    { scope = definitions.predicate.system-username-scope, }
                    {  }
                    false
                    predicates.never
                  ]
                ],
          }
          false
          predicates.never
        ],
    title = predicates.allOf
        [ predicates.isType '"String", predicates.strings.maxLength 40 ],
    type = predicates.allOf
        [
          predicates.isType '"String",
          predicates.enum [ "app", "base", "gadget", "kernel", "snapd" ]
        ],
    ua-services = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.items [ predicates.isType '"String" ],
          predicates.arrays.minItems 1,
          predicates.arrays.uniqueItems
        ],
    version = predicates.allOf
        [
          predicates.isType '"String",
          predicates.allOf
          [
            predicates.strings.maxLength 32,
            predicates.strings.pattern
            "^[a-zA-Z0-9](?:[a-zA-Z0-9:.+~-]*[a-zA-Z0-9+~])?$"
          ]
        ],
    version-script = predicates.isType '"String",
    website = predicates.isType '"String",
  }
  {  }
  false
  predicates.never,
  predicates.records.dependencies
  { license-agreement = [ "license" ], license-version = [ "license" ], }
])