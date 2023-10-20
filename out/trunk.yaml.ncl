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
          filetype_list
            | doc m%"
            List of filetypes
            To refer to all filetypes, use [ALL]
            "%
            = predicates.contract_from_predicate
              definitions.predicate.filetype_list,
          linter_list
            | doc m%"
            List of linter IDs
            To refer to all linters, use [ALL]
            "%
            = predicates.contract_from_predicate
              definitions.predicate.linter_list,
          template_string
            | doc m%"
            String where "${key1} ${key2}" will be expanded into "value1 value2"
            "%
            = String,
        },
    predicate = {
          filetype_list
            | doc m%"
            List of filetypes
            To refer to all filetypes, use [ALL]
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          linter_list
            | doc m%"
            List of linter IDs
            To refer to all linters, use [ALL]
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          template_string
            | doc m%"
            String where "${key1} ${key2}" will be expanded into "value1 value2"
            "%
            = predicates.isType '"String",
        },
  }
in

{
  actions
    | {
      definitions
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              description = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              display_name = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              enabled = predicates.isType '"Bool",
              id = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              interactive = predicates.isType '"Bool",
              notify_on_error = predicates.isType '"Bool",
              output_type = predicates.isType '"String",
              packages_file = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              run = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              run_from = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              runtime = predicates.isType '"String",
              triggers = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        files = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType '"Bool"
                              ])
                            ],
                        git_hooks = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType '"Bool"
                              ])
                            ],
                        schedule = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      disabled
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.anyOf
          [
            predicates.isType '"String",
            predicates.isType '"Number",
            predicates.isType '"Bool"
          ])
        ])
        | optional,
      enabled
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.anyOf
          [
            predicates.isType '"String",
            predicates.isType '"Number",
            predicates.isType '"Bool"
          ])
        ])
        | optional,
      ..
    }
    | optional,
  api
    | {
      address
        | predicates.contract_from_predicate
        (predicates.anyOf
        [
          predicates.isType '"String",
          predicates.isType '"Number",
          predicates.isType '"Bool"
        ])
        | optional,
      ..
    }
    | optional,
  cli
    | {
      check_for_upgrades | Bool | optional,
      options
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              args = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              commands = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      sha256
        | {
          darwin_arm64
            | predicates.contract_from_predicate
            (predicates.anyOf
            [
              predicates.isType '"String",
              predicates.isType '"Number",
              predicates.isType '"Bool"
            ])
            | optional,
          darwin_x86_64
            | predicates.contract_from_predicate
            (predicates.anyOf
            [
              predicates.isType '"String",
              predicates.isType '"Number",
              predicates.isType '"Bool"
            ])
            | optional,
          linux_x86_64
            | predicates.contract_from_predicate
            (predicates.anyOf
            [
              predicates.isType '"String",
              predicates.isType '"Number",
              predicates.isType '"Bool"
            ])
            | optional,
          ..
        }
        | optional,
      version
        | predicates.contract_from_predicate
        (predicates.anyOf
        [
          predicates.isType '"String",
          predicates.isType '"Number",
          predicates.isType '"Bool"
        ])
        | optional,
      ..
    }
    | optional,
  daemon
    | {
      check_for_upgrades | Bool | optional,
      log_level | String | optional,
      monitor_repository | Bool | optional,
      ..
    }
    | optional,
  downloads
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record
        {
          args = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.anyOf
                [
                  predicates.isType '"String",
                  predicates.isType '"Number",
                  predicates.isType '"Bool"
                ])
              ],
          downloads = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    cpu = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number",
                            predicates.isType '"Bool"
                          ])
                        ],
                    os = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number",
                            predicates.isType '"Bool"
                          ])
                        ],
                    sha256 = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number",
                          predicates.isType '"Bool"
                        ],
                    strip_components = predicates.isType 'Integer,
                    url = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number",
                          predicates.isType '"Bool"
                        ],
                    version = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number",
                          predicates.isType '"Bool"
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          executable = predicates.isType '"Bool",
          name = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.isType '"Number",
                predicates.isType '"Bool"
              ],
          version = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.isType '"Number",
                predicates.isType '"Bool"
              ],
        }
        {  }
        true
        predicates.always
      ])
    ])
    | optional,
  environments
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record
        {
          environment = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    list = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number",
                            predicates.isType '"Bool"
                          ])
                        ],
                    name = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number",
                          predicates.isType '"Bool"
                        ],
                    "optional" = predicates.isType '"Bool",
                    value = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number",
                          predicates.isType '"Bool"
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          name = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.isType '"Number",
                predicates.isType '"Bool"
              ],
        }
        {  }
        true
        predicates.always
      ])
    ])
    | optional,
  lint
    | {
      allow
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              linters = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              paths = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      bazel
        | {
          all_targets_query
            | predicates.contract_from_predicate
            (predicates.anyOf
            [
              predicates.isType '"String",
              predicates.isType '"Number",
              predicates.isType '"Bool"
            ])
            | optional,
          compiler_override_paths
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cpu = predicates.isType '"String",
                  os = predicates.isType '"String",
                  path = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number",
                        predicates.isType '"Bool"
                      ],
                }
                {  }
                true
                predicates.always
              ])
            ])
            | optional,
          paths
            | {
              system
                | predicates.contract_from_predicate
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ])
                ])
                | optional,
              workspace
                | predicates.contract_from_predicate
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ])
                ])
                | optional,
              ..
            }
            | optional,
          ..
        }
        | optional,
      comment_formats
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              leading_delimiter = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              name = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              trailing_delimiter = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      compile_commands | String | optional,
      default_max_file_size | std.number.Integer | optional,
      definitions
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              affects_cache = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              allow_empty_files = predicates.isType '"Bool",
              batch = predicates.isType '"Bool",
              cache_results = predicates.isType '"Bool",
              command = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              commands = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        allow_empty_files = predicates.isType '"Bool",
                        batch = predicates.isType '"Bool",
                        cache_results = predicates.isType '"Bool",
                        disable_upstream = predicates.isType '"Bool",
                        enabled = predicates.isType '"Bool",
                        error_codes = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType 'Integer)
                            ],
                        formatter = predicates.isType '"Bool",
                        in_place = predicates.isType '"Bool",
                        max_file_size = predicates.isType 'Integer,
                        name = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        output = predicates.isType '"String",
                        parse_regex = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        parser = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                run = predicates.anyOf
                                    [
                                      predicates.isType '"String",
                                      predicates.isType '"Number",
                                      predicates.isType '"Bool"
                                    ],
                                runtime = predicates.isType '"String",
                              }
                              {  }
                              true
                              predicates.always
                            ],
                        prepare_run = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        read_output_from = predicates.isType '"String",
                        run = definitions.predicate.template_string,
                        run_from_root_target = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        run_linter_from = predicates.isType '"String",
                        run_when = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                        stdin = predicates.isType '"Bool",
                        success_codes = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType 'Integer)
                            ],
                        supports_sandbox = predicates.isType '"Bool",
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              deprecated = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              direct_configs = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              disable_upstream = predicates.isType '"Bool",
              disabled = predicates.isType '"Bool",
              download = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              enabled = predicates.isType '"Bool",
              environment = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.records.required [ "name", "value" ],
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.allOf
                        [
                          predicates.records.required [ "list", "name" ],
                          predicates.records.record {  } {  } true
                          predicates.always
                        ]
                      ],
                      predicates.records.record
                      {
                        list = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              definitions.predicate.template_string
                            ],
                        name = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        "optional" = predicates.isType '"Bool",
                        value = definitions.predicate.template_string,
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              error_codes = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType 'Integer)
                  ],
              extra_packages = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              files = definitions.predicate.filetype_list,
              formatter = predicates.isType '"Bool",
              good_without_config = predicates.isType '"Bool",
              hold_the_line = predicates.isType '"Bool",
              in_place = predicates.isType '"Bool",
              include_lfs = predicates.isType '"Bool",
              include_scanner_type = predicates.isType '"String",
              is_manual = predicates.isType '"Bool",
              is_recommended = predicates.isType '"Bool",
              issue_url_format = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              known_bad_versions = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              known_good_version = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              name = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              package = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              plugin_url = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              prepare_command = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              query_compile_commands = predicates.isType '"Bool",
              read_output_from = predicates.isType '"String",
              run_from_root_file = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              run_from_root_target = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              run_linter_from = predicates.isType '"String",
              run_timeout = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              run_when = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ],
              runtime = predicates.isType '"String",
              stdin = predicates.isType '"Bool",
              success_codes = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType 'Integer)
                  ],
              symlinks = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        from = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        to = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              type = predicates.isType '"String",
              version = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              version_command = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      parse_regex = predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number",
                            predicates.isType '"Bool"
                          ],
                      run = predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number",
                            predicates.isType '"Bool"
                          ],
                    }
                    {  }
                    true
                    predicates.always
                  ],
            }
            {  }
            true
            predicates.always,
            predicates.records.dependencies
            {
              download = predicates.not
                  (predicates.allOf
                  [
                    predicates.records.required [ "package" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]),
              package = predicates.allOf
                  [
                    predicates.allOf
                    [
                      predicates.records.required [ "runtime" ],
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.not
                    (predicates.allOf
                    [
                      predicates.records.required [ "download" ],
                      predicates.records.record {  } {  } true predicates.always
                    ])
                  ],
            }
          ])
        ])
        | optional,
      disabled
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.anyOf
          [
            predicates.isType '"String",
            predicates.isType '"Number",
            predicates.isType '"Bool"
          ])
        ])
        | optional,
      do_not_recommend_linters
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.anyOf
          [
            predicates.isType '"String",
            predicates.isType '"Number",
            predicates.isType '"Bool"
          ])
        ])
        | optional,
      downloads
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              args = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              downloads = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        cpu = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record {  } {  } true
                              (predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType '"Bool"
                              ])
                            ],
                        os = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record {  } {  } true
                              (predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType '"Bool"
                              ])
                            ],
                        sha256 = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        strip_components = predicates.isType 'Integer,
                        url = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        version = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              executable = predicates.isType '"Bool",
              name = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              version = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      enabled
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.oneOf
          [
            predicates.isType '"String",
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record {  } {  } true
              (predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  commands = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number",
                          predicates.isType '"Bool"
                        ])
                      ],
                  name = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number",
                        predicates.isType '"Bool"
                      ],
                  packages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number",
                          predicates.isType '"Bool"
                        ])
                      ],
                }
                {  }
                true
                predicates.always
              ])
            ]
          ])
        ])
        | optional,
      environments
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              environment = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        list = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType '"Bool"
                              ])
                            ],
                        name = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        "optional" = predicates.isType '"Bool",
                        value = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              name = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      files
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              comments = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              extensions = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              filenames = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              inherit = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              name = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              regexes = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              shebangs = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      ignore
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              linters = definitions.predicate.linter_list,
              paths = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      landing_mode
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              landing_mode = predicates.isType '"String",
              linters = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      linters
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              affects_cache = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              allow_empty_files = predicates.isType '"Bool",
              batch = predicates.isType '"Bool",
              cache_results = predicates.isType '"Bool",
              command = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              commands = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        allow_empty_files = predicates.isType '"Bool",
                        batch = predicates.isType '"Bool",
                        cache_results = predicates.isType '"Bool",
                        disable_upstream = predicates.isType '"Bool",
                        enabled = predicates.isType '"Bool",
                        error_codes = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType 'Integer)
                            ],
                        formatter = predicates.isType '"Bool",
                        in_place = predicates.isType '"Bool",
                        max_file_size = predicates.isType 'Integer,
                        name = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        output = predicates.isType '"String",
                        parse_regex = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        parser = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                run = predicates.anyOf
                                    [
                                      predicates.isType '"String",
                                      predicates.isType '"Number",
                                      predicates.isType '"Bool"
                                    ],
                                runtime = predicates.isType '"String",
                              }
                              {  }
                              true
                              predicates.always
                            ],
                        prepare_run = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        read_output_from = predicates.isType '"String",
                        run = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        run_from_root_target = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        run_linter_from = predicates.isType '"String",
                        run_when = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                        stdin = predicates.isType '"Bool",
                        success_codes = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType 'Integer)
                            ],
                        supports_sandbox = predicates.isType '"Bool",
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              deprecated = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              direct_configs = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              disable_upstream = predicates.isType '"Bool",
              disabled = predicates.isType '"Bool",
              download = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              enabled = predicates.isType '"Bool",
              environment = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        list = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType '"Bool"
                              ])
                            ],
                        name = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        "optional" = predicates.isType '"Bool",
                        value = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              error_codes = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType 'Integer)
                  ],
              extra_packages = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              files = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              formatter = predicates.isType '"Bool",
              good_without_config = predicates.isType '"Bool",
              hold_the_line = predicates.isType '"Bool",
              in_place = predicates.isType '"Bool",
              include_lfs = predicates.isType '"Bool",
              include_scanner_type = predicates.isType '"String",
              is_manual = predicates.isType '"Bool",
              is_recommended = predicates.isType '"Bool",
              issue_url_format = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              known_bad_versions = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              known_good_version = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              name = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              package = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              plugin_url = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              prepare_command = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              query_compile_commands = predicates.isType '"Bool",
              read_output_from = predicates.isType '"String",
              run_from_root_file = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              run_from_root_target = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              run_linter_from = predicates.isType '"String",
              run_timeout = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              run_when = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ],
              runtime = predicates.isType '"String",
              stdin = predicates.isType '"Bool",
              success_codes = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType 'Integer)
                  ],
              symlinks = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        from = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        to = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              type = predicates.isType '"String",
              version = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              version_command = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      parse_regex = predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number",
                            predicates.isType '"Bool"
                          ],
                      run = predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number",
                            predicates.isType '"Bool"
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
          ])
        ])
        | optional,
      runtimes
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              download = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              enabled = predicates.isType '"Bool",
              known_good_version = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              linter_environment = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        list = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType '"Bool"
                              ])
                            ],
                        name = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        "optional" = predicates.isType '"Bool",
                        value = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              runtime_environment = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        list = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType '"Bool"
                              ])
                            ],
                        name = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        "optional" = predicates.isType '"Bool",
                        value = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              system_version = predicates.isType '"String",
              type = predicates.isType '"String",
              version = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              version_commands = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        parse_regex = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        run = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      shared_configs
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              file = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              regex = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      threshold
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              level = predicates.isType '"String",
              linters = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      triggers
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              files = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              linters = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              paths = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              regexes = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
              targets = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      ..
    }
    | optional,
  "merge"
    | {
      required_statuses
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.anyOf
          [
            predicates.isType '"String",
            predicates.isType '"Number",
            predicates.isType '"Bool"
          ])
        ])
        | optional,
      statuses
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.anyOf
          [
            predicates.isType '"String",
            predicates.isType '"Number",
            predicates.isType '"Bool"
          ])
        ])
        | optional,
      ..
    }
    | optional,
  notifications
    | {
      sleep
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              "priority" = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.isType '"Number",
                      predicates.isType '"Bool"
                    ])
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      ..
    }
    | optional,
  plugin_url
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.isType '"String",
      predicates.isType '"Number",
      predicates.isType '"Bool"
    ])
    | optional,
  plugins
    | {
      sources
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              id = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              import_to_global = predicates.isType '"Bool",
              local = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              ref = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              uri = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      ..
    }
    | optional,
  repo
    | {
      git
        | {
          allowed_user_email_domains
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.anyOf
              [
                predicates.isType '"String",
                predicates.isType '"Number",
                predicates.isType '"Bool"
              ])
            ])
            | optional,
          branch_name_format
            | predicates.contract_from_predicate
            (predicates.anyOf
            [
              predicates.isType '"String",
              predicates.isType '"Number",
              predicates.isType '"Bool"
            ])
            | optional,
          new_files_warning_threshold_kb | std.number.Integer | optional,
          ..
        }
        | optional,
      repo
        | {
          host
            | predicates.contract_from_predicate
            (predicates.anyOf
            [
              predicates.isType '"String",
              predicates.isType '"Number",
              predicates.isType '"Bool"
            ])
            | optional,
          name
            | predicates.contract_from_predicate
            (predicates.anyOf
            [
              predicates.isType '"String",
              predicates.isType '"Number",
              predicates.isType '"Bool"
            ])
            | optional,
          owner
            | predicates.contract_from_predicate
            (predicates.anyOf
            [
              predicates.isType '"String",
              predicates.isType '"Number",
              predicates.isType '"Bool"
            ])
            | optional,
          ..
        }
        | optional,
      trunk_branch
        | predicates.contract_from_predicate
        (predicates.anyOf
        [
          predicates.isType '"String",
          predicates.isType '"Number",
          predicates.isType '"Bool"
        ])
        | optional,
      trunk_primary_remote
        | predicates.contract_from_predicate
        (predicates.anyOf
        [
          predicates.isType '"String",
          predicates.isType '"Number",
          predicates.isType '"Bool"
        ])
        | optional,
      use_branch_upstream | Bool | optional,
      ..
    }
    | optional,
  required_trunk_version
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.isType '"String",
      predicates.isType '"Number",
      predicates.isType '"Bool"
    ])
    | optional,
  runtimes
    | {
      definitions
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              download = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              enabled = predicates.isType '"Bool",
              known_good_version = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              linter_environment = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        list = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType '"Bool"
                              ])
                            ],
                        name = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        "optional" = predicates.isType '"Bool",
                        value = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              runtime_environment = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        list = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType '"Bool"
                              ])
                            ],
                        name = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        "optional" = predicates.isType '"Bool",
                        value = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              system_version = predicates.isType '"String",
              type = predicates.isType '"String",
              version = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool"
                  ],
              version_commands = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        parse_regex = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                        run = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Bool"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | optional,
      enabled
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | optional,
      ..
    }
    | optional,
  version
    | predicates.contract_from_predicate (predicates.enum [ "0.1", 0.1 ])
    | doc m%"
    The trunk config version being parsed. The only possible value is 0.1.
    "%,
  ..
}