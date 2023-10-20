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
          GeneralConfig
            | doc m%"
            General configuration settings.
            "%
            = {
                artifact_regions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern
                      "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                    ])
                  ])
                  | doc m%"
                  List of AWS regions where artifacts need to be copied. This helps same region artifact bucket access to resources
                  "%
                  | optional,
                auth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  AWS authentication section
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType 'Integer,
                          predicates.isType '"String"
                        ])
                      ],
                      predicates.isType '"Bool",
                      predicates.isType 'Integer,
                      predicates.isType '"String"
                    ])
                  ])
                  | doc m%"
                  Parameter key-values to pass to CloudFormation, parameters provided in global config take precedence
                  "%
                  | optional,
                posthooks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.HookData
                  ])
                  | doc m%"
                  hooks to execute after executing tests
                  "%
                  | optional,
                prehooks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.HookData
                  ])
                  | doc m%"
                  hooks to execute prior to executing tests
                  "%
                  | optional,
                regions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern
                      "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                    ])
                  ])
                  | doc m%"
                  List of AWS regions
                  "%
                  | optional,
                s3_bucket
                  | String
                  | doc m%"
                  Name of S3 bucket to upload project to, if left out a bucket will be auto-generated
                  "%
                  | optional,
                s3_regional_buckets
                  | Bool
                  | doc m%"
                  Enable regional auto-buckets.
                  "%
                  | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Tags to apply to CloudFormation template
                  "%
                  | optional,
              },
          HookData
            | doc m%"
            Hook definition
            "%
            = {
                config
                  | {  .. }
                  | doc m%"
                  hook configuration
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  hook type
                  "%
                  | optional,
              },
          ProjectConfig
            | doc m%"
            Project specific configuration section
            "%
            = {
                artifact_regions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern
                      "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                    ])
                  ])
                  | doc m%"
                  List of AWS regions where artifacts need to be copied. This helps same region artifact bucket access to resources
                  "%
                  | optional,
                auth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  AWS authentication section
                  "%
                  | optional,
                az_blacklist
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern
                      "(afs1-az1|afs1-az2|afs1-az3|afs1-los1-az1|ape1-az1|ape1-az2|ape1-az3|apne1-az1|apne1-az2|apne1-az4|apne1-tpe1-az1|apne2-az1|apne2-az2|apne2-az3|apne2-az4|apne3-az1|apne3-az2|apne3-az3|aps1-az1|aps1-az2|aps1-az3|aps1-ccu1-az1|aps1-del1-az1|aps2-az1|aps2-az2|aps2-az3|apse1-az1|apse1-az2|apse1-az3|apse1-bkk1-az1|apse2-az1|apse2-az2|apse2-az3|apse2-per1-az1|apse3-az1|apse3-az2|apse3-az3|apse4-az1|apse4-az2|apse4-az3|cac1-az1|cac1-az2|cac1-az4|euc1-az1|euc1-az2|euc1-az3|euc1-ham1-az1|euc1-waw1-az1|euc2-az1|euc2-az2|euc2-az3|eun1-az1|eun1-az2|eun1-az3|eun1-cph1-az1|eun1-hel1-az1|eus1-az1|eus1-az2|eus1-az3|eus2-az1|eus2-az2|eus2-az3|euw1-az1|euw1-az2|euw1-az3|euw2-az1|euw2-az2|euw2-az3|euw3-az1|euw3-az2|euw3-az3|mec1-az1|mec1-az2|mec1-az3|mes1-az1|mes1-az2|mes1-az3|mes1-mct1-az1|sae1-az1|sae1-az2|sae1-az3|use1-atl1-az1|use1-az1|use1-az2|use1-az3|use1-az4|use1-az5|use1-az6|use1-bos1-az1|use1-bue1-az1|use1-chi1-az1|use1-dfw1-az1|use1-iah1-az1|use1-lim1-az1|use1-mci1-az1|use1-mia1-az1|use1-msp1-az1|use1-nyc1-az1|use1-phl1-az1|use1-qro1-az1|use1-scl1-az1|use2-az1|use2-az2|use2-az3|usw1-az1|usw1-az3|usw2-az1|usw2-az2|usw2-az3|usw2-az4|usw2-den1-az1|usw2-las1-az1|usw2-lax1-az1|usw2-lax1-az2|usw2-pdx1-az1|usw2-phx1-az1|usw2-sea1-az1)"
                    ])
                  ])
                  | doc m%"
                  List of Availablilty Zones ID's to exclude when generating availability zones
                  "%
                  | optional,
                build_submodules
                  | Bool
                  | doc m%"
                  Build Lambda zips recursively for submodules, set to false to disable
                  "%
                  | optional,
                lambda_source_path
                  | String
                  | doc m%"
                  Path relative to the project root containing Lambda zip files, default is 'lambda_functions/source'
                  "%
                  | optional,
                lambda_zip_path
                  | String
                  | doc m%"
                  Path relative to the project root to place Lambda zip files
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^[a-z0-9-/]*$"
                  ])
                  | doc m%"
                  Project name, used as s3 key prefix when uploading objects
                  "%
                  | optional,
                org_id
                  | String
                  | doc m%"
                  Organization ID to use when launching CFN Stacks. starts with o-. It is found on Organization Settings page
                  "%
                  | optional,
                owner
                  | String
                  | doc m%"
                  email address for project owner (not used at present)
                  "%
                  | optional,
                package_lambda
                  | Bool
                  | doc m%"
                  Package Lambda functions into zips before uploading to s3, set to false to disable
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType 'Integer,
                          predicates.isType '"String"
                        ])
                      ],
                      predicates.isType '"Bool",
                      predicates.isType 'Integer,
                      predicates.isType '"String"
                    ])
                  ])
                  | doc m%"
                  Parameter key-values to pass to CloudFormation, parameters provided in global config take precedence
                  "%
                  | optional,
                posthooks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.HookData
                  ])
                  | doc m%"
                  hooks to execute after executing tests
                  "%
                  | optional,
                prehooks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.HookData
                  ])
                  | doc m%"
                  hooks to execute prior to executing tests
                  "%
                  | optional,
                regions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern
                      "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                    ])
                  ])
                  | doc m%"
                  List of AWS regions
                  "%
                  | optional,
                role_name
                  | String
                  | doc m%"
                  Role name to use when launching CFN Stacks.
                  "%
                  | optional,
                s3_bucket
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^[a-z0-9-]*$"
                  ])
                  | doc m%"
                  Name of S3 bucket to upload project to, if left out a bucket will be auto-generated
                  "%
                  | optional,
                s3_enable_sig_v2
                  | Bool
                  | doc m%"
                  Enable (deprecated) sigv2 access to auto-generated buckets
                  "%
                  | optional,
                s3_object_acl
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^(bucket-owner-full-control|bucket-owner-read|authenticated-read|aws-exec-read|public-read-write|public-read|private)$"
                  ])
                  | doc m%"
                  ACL for uploaded s3 objects
                  "%
                  | optional,
                s3_regional_buckets
                  | Bool
                  | doc m%"
                  Enable regional auto-buckets.
                  "%
                  | optional,
                shorten_stack_name
                  | Bool
                  | doc m%"
                  Shorten stack names generated for tests, set to true to enable
                  "%
                  | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Tags to apply to CloudFormation template
                  "%
                  | optional,
                template
                  | String
                  | doc m%"
                  path to template file relative to the project config file path
                  "%
                  | optional,
              },
          TestConfig
            | doc m%"
            Test specific configuration section.
            "%
            = {
                artifact_regions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern
                      "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                    ])
                  ])
                  | doc m%"
                  List of AWS regions where artifacts need to be copied. This helps same region artifact bucket access to resources
                  "%
                  | optional,
                auth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  AWS authentication section
                  "%
                  | optional,
                az_blacklist
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern
                      "(afs1-az1|afs1-az2|afs1-az3|afs1-los1-az1|ape1-az1|ape1-az2|ape1-az3|apne1-az1|apne1-az2|apne1-az4|apne1-tpe1-az1|apne2-az1|apne2-az2|apne2-az3|apne2-az4|apne3-az1|apne3-az2|apne3-az3|aps1-az1|aps1-az2|aps1-az3|aps1-ccu1-az1|aps1-del1-az1|aps2-az1|aps2-az2|aps2-az3|apse1-az1|apse1-az2|apse1-az3|apse1-bkk1-az1|apse2-az1|apse2-az2|apse2-az3|apse2-per1-az1|apse3-az1|apse3-az2|apse3-az3|apse4-az1|apse4-az2|apse4-az3|cac1-az1|cac1-az2|cac1-az4|euc1-az1|euc1-az2|euc1-az3|euc1-ham1-az1|euc1-waw1-az1|euc2-az1|euc2-az2|euc2-az3|eun1-az1|eun1-az2|eun1-az3|eun1-cph1-az1|eun1-hel1-az1|eus1-az1|eus1-az2|eus1-az3|eus2-az1|eus2-az2|eus2-az3|euw1-az1|euw1-az2|euw1-az3|euw2-az1|euw2-az2|euw2-az3|euw3-az1|euw3-az2|euw3-az3|mec1-az1|mec1-az2|mec1-az3|mes1-az1|mes1-az2|mes1-az3|mes1-mct1-az1|sae1-az1|sae1-az2|sae1-az3|use1-atl1-az1|use1-az1|use1-az2|use1-az3|use1-az4|use1-az5|use1-az6|use1-bos1-az1|use1-bue1-az1|use1-chi1-az1|use1-dfw1-az1|use1-iah1-az1|use1-lim1-az1|use1-mci1-az1|use1-mia1-az1|use1-msp1-az1|use1-nyc1-az1|use1-phl1-az1|use1-qro1-az1|use1-scl1-az1|use2-az1|use2-az2|use2-az3|usw1-az1|usw1-az3|usw2-az1|usw2-az2|usw2-az3|usw2-az4|usw2-den1-az1|usw2-las1-az1|usw2-lax1-az1|usw2-lax1-az2|usw2-pdx1-az1|usw2-phx1-az1|usw2-sea1-az1)"
                    ])
                  ])
                  | doc m%"
                  List of Availablilty Zones ID's to exclude when generating availability zones
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType 'Integer,
                          predicates.isType '"String"
                        ])
                      ],
                      predicates.isType '"Bool",
                      predicates.isType 'Integer,
                      predicates.isType '"String"
                    ])
                  ])
                  | doc m%"
                  Parameter key-values to pass to CloudFormation, parameters provided in global config take precedence
                  "%
                  | optional,
                posthooks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.HookData
                  ])
                  | doc m%"
                  hooks to execute after executing tests
                  "%
                  | optional,
                prehooks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.HookData
                  ])
                  | doc m%"
                  hooks to execute prior to executing tests
                  "%
                  | optional,
                regions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern
                      "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                    ])
                  ])
                  | doc m%"
                  List of AWS regions
                  "%
                  | optional,
                role_name
                  | String
                  | doc m%"
                  Role name to use when launching CFN Stacks.
                  "%
                  | optional,
                s3_bucket
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^[a-z0-9-]*$"
                  ])
                  | doc m%"
                  Name of S3 bucket to upload project to, if left out a bucket will be auto-generated
                  "%
                  | optional,
                s3_regional_buckets
                  | Bool
                  | doc m%"
                  Enable regional auto-buckets.
                  "%
                  | optional,
                stack_name
                  | String
                  | doc m%"
                  Cloudformation Stack Name
                  "%
                  | optional,
                stack_name_prefix
                  | String
                  | doc m%"
                  Prefix to apply to generated CFN Stack Name
                  "%
                  | optional,
                stack_name_suffix
                  | String
                  | doc m%"
                  Suffix to apply to generated CFN Stack Name
                  "%
                  | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Tags to apply to CloudFormation template
                  "%
                  | optional,
                template
                  | String
                  | doc m%"
                  path to template file relative to the project config file path
                  "%
                  | optional,
              },
        },
    predicate = {
          GeneralConfig
            | doc m%"
            General configuration settings.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifact_regions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                        ])
                      ],
                  auth = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  parameters = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.anyOf
                            [
                              predicates.isType 'Integer,
                              predicates.isType '"String"
                            ])
                          ],
                          predicates.isType '"Bool",
                          predicates.isType 'Integer,
                          predicates.isType '"String"
                        ])
                      ],
                  posthooks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.HookData
                      ],
                  prehooks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.HookData
                      ],
                  regions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                        ])
                      ],
                  s3_bucket = predicates.isType '"String",
                  s3_regional_buckets = predicates.isType '"Bool",
                  tags = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          HookData
            | doc m%"
            Hook definition
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  config = predicates.isType 'Record,
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ProjectConfig
            | doc m%"
            Project specific configuration section
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifact_regions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                        ])
                      ],
                  auth = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  az_blacklist = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "(afs1-az1|afs1-az2|afs1-az3|afs1-los1-az1|ape1-az1|ape1-az2|ape1-az3|apne1-az1|apne1-az2|apne1-az4|apne1-tpe1-az1|apne2-az1|apne2-az2|apne2-az3|apne2-az4|apne3-az1|apne3-az2|apne3-az3|aps1-az1|aps1-az2|aps1-az3|aps1-ccu1-az1|aps1-del1-az1|aps2-az1|aps2-az2|aps2-az3|apse1-az1|apse1-az2|apse1-az3|apse1-bkk1-az1|apse2-az1|apse2-az2|apse2-az3|apse2-per1-az1|apse3-az1|apse3-az2|apse3-az3|apse4-az1|apse4-az2|apse4-az3|cac1-az1|cac1-az2|cac1-az4|euc1-az1|euc1-az2|euc1-az3|euc1-ham1-az1|euc1-waw1-az1|euc2-az1|euc2-az2|euc2-az3|eun1-az1|eun1-az2|eun1-az3|eun1-cph1-az1|eun1-hel1-az1|eus1-az1|eus1-az2|eus1-az3|eus2-az1|eus2-az2|eus2-az3|euw1-az1|euw1-az2|euw1-az3|euw2-az1|euw2-az2|euw2-az3|euw3-az1|euw3-az2|euw3-az3|mec1-az1|mec1-az2|mec1-az3|mes1-az1|mes1-az2|mes1-az3|mes1-mct1-az1|sae1-az1|sae1-az2|sae1-az3|use1-atl1-az1|use1-az1|use1-az2|use1-az3|use1-az4|use1-az5|use1-az6|use1-bos1-az1|use1-bue1-az1|use1-chi1-az1|use1-dfw1-az1|use1-iah1-az1|use1-lim1-az1|use1-mci1-az1|use1-mia1-az1|use1-msp1-az1|use1-nyc1-az1|use1-phl1-az1|use1-qro1-az1|use1-scl1-az1|use2-az1|use2-az2|use2-az3|usw1-az1|usw1-az3|usw2-az1|usw2-az2|usw2-az3|usw2-az4|usw2-den1-az1|usw2-las1-az1|usw2-lax1-az1|usw2-lax1-az2|usw2-pdx1-az1|usw2-phx1-az1|usw2-sea1-az1)"
                        ])
                      ],
                  build_submodules = predicates.isType '"Bool",
                  lambda_source_path = predicates.isType '"String",
                  lambda_zip_path = predicates.isType '"String",
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^[a-z0-9-/]*$"
                      ],
                  org_id = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  package_lambda = predicates.isType '"Bool",
                  parameters = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.anyOf
                            [
                              predicates.isType 'Integer,
                              predicates.isType '"String"
                            ])
                          ],
                          predicates.isType '"Bool",
                          predicates.isType 'Integer,
                          predicates.isType '"String"
                        ])
                      ],
                  posthooks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.HookData
                      ],
                  prehooks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.HookData
                      ],
                  regions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                        ])
                      ],
                  role_name = predicates.isType '"String",
                  s3_bucket = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^[a-z0-9-]*$"
                      ],
                  s3_enable_sig_v2 = predicates.isType '"Bool",
                  s3_object_acl = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(bucket-owner-full-control|bucket-owner-read|authenticated-read|aws-exec-read|public-read-write|public-read|private)$"
                      ],
                  s3_regional_buckets = predicates.isType '"Bool",
                  shorten_stack_name = predicates.isType '"Bool",
                  tags = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  template = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          TestConfig
            | doc m%"
            Test specific configuration section.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifact_regions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                        ])
                      ],
                  auth = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  az_blacklist = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "(afs1-az1|afs1-az2|afs1-az3|afs1-los1-az1|ape1-az1|ape1-az2|ape1-az3|apne1-az1|apne1-az2|apne1-az4|apne1-tpe1-az1|apne2-az1|apne2-az2|apne2-az3|apne2-az4|apne3-az1|apne3-az2|apne3-az3|aps1-az1|aps1-az2|aps1-az3|aps1-ccu1-az1|aps1-del1-az1|aps2-az1|aps2-az2|aps2-az3|apse1-az1|apse1-az2|apse1-az3|apse1-bkk1-az1|apse2-az1|apse2-az2|apse2-az3|apse2-per1-az1|apse3-az1|apse3-az2|apse3-az3|apse4-az1|apse4-az2|apse4-az3|cac1-az1|cac1-az2|cac1-az4|euc1-az1|euc1-az2|euc1-az3|euc1-ham1-az1|euc1-waw1-az1|euc2-az1|euc2-az2|euc2-az3|eun1-az1|eun1-az2|eun1-az3|eun1-cph1-az1|eun1-hel1-az1|eus1-az1|eus1-az2|eus1-az3|eus2-az1|eus2-az2|eus2-az3|euw1-az1|euw1-az2|euw1-az3|euw2-az1|euw2-az2|euw2-az3|euw3-az1|euw3-az2|euw3-az3|mec1-az1|mec1-az2|mec1-az3|mes1-az1|mes1-az2|mes1-az3|mes1-mct1-az1|sae1-az1|sae1-az2|sae1-az3|use1-atl1-az1|use1-az1|use1-az2|use1-az3|use1-az4|use1-az5|use1-az6|use1-bos1-az1|use1-bue1-az1|use1-chi1-az1|use1-dfw1-az1|use1-iah1-az1|use1-lim1-az1|use1-mci1-az1|use1-mia1-az1|use1-msp1-az1|use1-nyc1-az1|use1-phl1-az1|use1-qro1-az1|use1-scl1-az1|use2-az1|use2-az2|use2-az3|usw1-az1|usw1-az3|usw2-az1|usw2-az2|usw2-az3|usw2-az4|usw2-den1-az1|usw2-las1-az1|usw2-lax1-az1|usw2-lax1-az2|usw2-pdx1-az1|usw2-phx1-az1|usw2-sea1-az1)"
                        ])
                      ],
                  parameters = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.anyOf
                            [
                              predicates.isType 'Integer,
                              predicates.isType '"String"
                            ])
                          ],
                          predicates.isType '"Bool",
                          predicates.isType 'Integer,
                          predicates.isType '"String"
                        ])
                      ],
                  posthooks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.HookData
                      ],
                  prehooks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.HookData
                      ],
                  regions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                        ])
                      ],
                  role_name = predicates.isType '"String",
                  s3_bucket = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^[a-z0-9-]*$"
                      ],
                  s3_regional_buckets = predicates.isType '"Bool",
                  stack_name = predicates.isType '"String",
                  stack_name_prefix = predicates.isType '"String",
                  stack_name_suffix = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  template = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

{
  general | definitions.contract.GeneralConfig | optional,
  project | definitions.contract.ProjectConfig | optional,
  tests
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true definitions.predicate.TestConfig
    ])
    | optional,
}