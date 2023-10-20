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
          baseVariants = { base | String, condition | String, },
          enhancerRoute = {
                _arguments
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                _controller
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^([a-zA-Z0-9]{1,30})::([a-zA-Z0-9]{1,30})$"
                  ]),
                routePath | String,
              },
          errorHandling = predicates.contract_from_predicate
              definitions.predicate.errorHandling,
          language = {
                base
                  | String
                  | doc m%"
                  Use a full qualified domain "https://www.mydomain.fr/" or "/fr/". Use "/" to keep the main URL for the default language. Add language specific suffixes to use those, or configure complete URLs for independent domains.
                  "%,
                baseVariants
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.baseVariants
                  ])
                  | optional,
                direction
                  | std.enum.TagOrString
                  | [| 'rtl, 'ltr, '"" |]
                  | doc m%"
                  Language direction for "dir" attribute
                  "%
                  | optional,
                enabled
                  | Bool
                  | doc m%"
                  Visible in Frontend
                  "%,
                fallbackType
                  | std.enum.TagOrString
                  | [| 'free, 'fallback, 'strict |]
                  | doc m%"
                  Fallback Type
                  "%
                  | optional,
                fallbacks
                  | String
                  | doc m%"
                  Fallback to other Language(s) - order is important! Comma separated list
                  "%
                  | optional,
                flag
                  | std.enum.TagOrString
                  | [|
                    'zw,
                    'zm,
                    'za,
                    'yt,
                    'ye,
                    'ws,
                    'wf,
                    'gb-wls,
                    'vu,
                    'vn,
                    'vi,
                    'vg,
                    've,
                    'vc,
                    'va,
                    'uz,
                    'uy,
                    'us,
                    'um,
                    'ug,
                    'ua,
                    'tz,
                    'tw,
                    'tv,
                    'tt,
                    'tr,
                    'to,
                    'tn,
                    'tm,
                    'tl,
                    'tk,
                    'tj,
                    'th,
                    'tg,
                    'tf,
                    'td,
                    'tc,
                    'sz,
                    'sy,
                    'sx,
                    'sv,
                    'st,
                    'ss,
                    'sr,
                    'so,
                    'sn,
                    'sm,
                    'sl,
                    'sk,
                    'sj,
                    'si,
                    'sh,
                    'sg,
                    'se,
                    'sd,
                    'gb-sct,
                    'sc,
                    'sb,
                    'sa,
                    'rw,
                    'ru,
                    'rs,
                    'ro,
                    're,
                    'qc,
                    'qa,
                    'py,
                    'pw,
                    'pt,
                    'ps,
                    'pr,
                    'pn,
                    'pm,
                    'pl,
                    'pk,
                    'ph,
                    'pg,
                    'pf,
                    'pe,
                    'pa,
                    'om,
                    'nz,
                    'nu,
                    'nr,
                    'np,
                    'no,
                    'nl,
                    'gb-nir,
                    'ni,
                    'ng,
                    'nf,
                    'ne,
                    'nc,
                    'na,
                    'mz,
                    'my,
                    'mx,
                    'mw,
                    'mv,
                    'mu,
                    'mt,
                    'ms,
                    'mr,
                    'mq,
                    'mp,
                    'mo,
                    'mn,
                    'mm,
                    'ml,
                    'mk,
                    'mi,
                    'mh,
                    'mg,
                    'mf,
                    'me,
                    'md,
                    'mc,
                    'ma,
                    'ly,
                    'lv,
                    'lu,
                    'lt,
                    'ls,
                    'lr,
                    'lk,
                    'li,
                    'lc,
                    'lb,
                    'la,
                    'kz,
                    'ky,
                    'kw,
                    'kr,
                    'kp,
                    'kn,
                    'km,
                    'kl,
                    'ki,
                    'kh,
                    'kg,
                    'ke,
                    'jp,
                    'jo,
                    'jm,
                    'it,
                    'is,
                    'ir,
                    'iq,
                    'io,
                    '"in",
                    'im,
                    'il,
                    'ie,
                    'id,
                    'hu,
                    'ht,
                    'hr,
                    'hn,
                    'hm,
                    'hk,
                    'gy,
                    'gw,
                    'gu,
                    'gt,
                    'gs,
                    'gr,
                    'gq,
                    'gp,
                    'gn,
                    'gm,
                    'gl,
                    'gi,
                    'gh,
                    'gg,
                    'gf,
                    'ge,
                    'gd,
                    'gb,
                    'ga,
                    'fr,
                    'fo,
                    'fm,
                    'fk,
                    'fj,
                    'fi,
                    'eu,
                    'et,
                    'es,
                    'er,
                    'gb-eng,
                    'en-us-gb,
                    'eh,
                    'eg,
                    'ee,
                    'ec,
                    'dz,
                    'do,
                    'dm,
                    'dk,
                    'dj,
                    'de,
                    'cz,
                    'cy,
                    'cx,
                    'cw,
                    'cv,
                    'cu,
                    'cs,
                    'cr,
                    'co,
                    'cn,
                    'cm,
                    'cl,
                    'ck,
                    'ci,
                    'ch,
                    'cg,
                    'cf,
                    'cd,
                    'cc,
                    'catalonia,
                    'ca,
                    'bz,
                    'by,
                    'bw,
                    'bv,
                    'bt,
                    'bs,
                    'br,
                    'bq,
                    'bo,
                    'bn,
                    'bm,
                    'bl,
                    'bj,
                    'bi,
                    'bh,
                    'bg,
                    'bf,
                    'be,
                    'bd,
                    'bb,
                    'ba,
                    'az,
                    'ax,
                    'aw,
                    'au,
                    'at,
                    'as,
                    'ar,
                    'aq,
                    'ao,
                    'an,
                    'am,
                    'al,
                    'ai,
                    'ag,
                    'af,
                    'ae,
                    'ad,
                    'global
                  |]
                  | optional,
                hreflang
                  | String
                  | doc m%"
                  Used within for "lang" and "hreflang" attributes
                  "%
                  | optional,
                iso-639-1
                  | std.enum.TagOrString
                  | [|
                    'zu,
                    'za,
                    'yo,
                    'yi,
                    'xh,
                    'fy,
                    'wo,
                    'cy,
                    'wa,
                    'vo,
                    'vi,
                    've,
                    'uz,
                    'ur,
                    'uk,
                    'ug,
                    'ty,
                    'tw,
                    'tt,
                    'ts,
                    'tr,
                    'to,
                    'tn,
                    'tl,
                    'tk,
                    'bo,
                    'ti,
                    'th,
                    'tg,
                    'te,
                    'ta,
                    'sv,
                    'ss,
                    'sw,
                    'su,
                    'es,
                    'st,
                    'so,
                    'sl,
                    'sk,
                    'si,
                    'sn,
                    'gd,
                    'sr,
                    'sg,
                    'sm,
                    'se,
                    'sd,
                    'sc,
                    'sa,
                    'ru,
                    'ro,
                    'rn,
                    'rm,
                    'qu,
                    'pt,
                    'ps,
                    'pl,
                    'fa,
                    'pi,
                    'pa,
                    'os,
                    'or,
                    'om,
                    'cu,
                    'oj,
                    'oc,
                    'nr,
                    'ii,
                    'no,
                    'nn,
                    'nb,
                    'ng,
                    'ne,
                    'nd,
                    'nv,
                    'na,
                    'mn,
                    'mh,
                    'mr,
                    'mi,
                    'mt,
                    'ml,
                    'ms,
                    'mg,
                    'mk,
                    'gv,
                    'lv,
                    'lu,
                    'lt,
                    'lo,
                    'ln,
                    'li,
                    'lg,
                    'lb,
                    'la,
                    'kj,
                    'ku,
                    'ko,
                    'kg,
                    'kv,
                    'ky,
                    'rw,
                    'ki,
                    'km,
                    'kk,
                    'ks,
                    'kr,
                    'kn,
                    'kl,
                    'jv,
                    'ja,
                    'iu,
                    'it,
                    'is,
                    'io,
                    'ik,
                    'ig,
                    'ga,
                    'ie,
                    'id,
                    'ia,
                    'hu,
                    'ho,
                    'hi,
                    'hz,
                    'he,
                    'ha,
                    'ht,
                    'gu,
                    'gn,
                    'el,
                    'de,
                    'ka,
                    'gl,
                    'ff,
                    'fr,
                    'fi,
                    'fj,
                    'fo,
                    'ee,
                    'et,
                    'eo,
                    'en,
                    'dz,
                    'nl,
                    'dv,
                    'da,
                    'cs,
                    'hr,
                    'cr,
                    'co,
                    'kw,
                    'cv,
                    'zh,
                    'ny,
                    'ce,
                    'ch,
                    'ca,
                    'my,
                    'bg,
                    'br,
                    'bs,
                    'bi,
                    'bh,
                    'bn,
                    'be,
                    'eu,
                    'ba,
                    'bm,
                    'az,
                    'ay,
                    'ae,
                    'av,
                    'as,
                    'hy,
                    'an,
                    'ar,
                    'am,
                    'sq,
                    'ak,
                    'af,
                    'aa,
                    'ab
                  |]
                  | doc m%"
                  ISO 639-1 code of the Language
                  "%
                  | optional,
                languageId
                  | std.number.Integer
                  | doc m%"
                  ID of the related sys_language record
                  "%,
                locale
                  | String
                  | doc m%"
                  Used for localized date and currency formats. E.g. "de_DE" or "en_US.UTF-8".
                  "%,
                navigationTitle
                  | String
                  | doc m%"
                  Used within language-related menus
                  "%
                  | optional,
                title
                  | String
                  | doc m%"
                  Title
                  "%,
                typo3Language
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum
                      [
                        "default",
                        "af",
                        "ar",
                        "bs",
                        "bg",
                        "ca",
                        "ch",
                        "cs",
                        "da",
                        "de",
                        "el",
                        "eo",
                        "es",
                        "et",
                        "eu",
                        "fa",
                        "fi",
                        "fo",
                        "fr",
                        "fr_CA",
                        "gl",
                        "he",
                        "hi",
                        "hr",
                        "hu",
                        "is",
                        "it",
                        "ja",
                        "ka",
                        "kl",
                        "km",
                        "ko",
                        "lt",
                        "lv",
                        "mi",
                        "mk",
                        "ms",
                        "nl",
                        "no",
                        "pl",
                        "pt",
                        "pt_BR",
                        "ro",
                        "ru",
                        "rw",
                        "sk",
                        "sl",
                        "sq",
                        "sr",
                        "sv",
                        "th",
                        "tr",
                        "uk",
                        "vi",
                        "zh"
                      ]
                    ],
                    predicates.isType '"String"
                  ])
                  | doc m%"
                  Select the language to be used from translation files. Keep default if no translation files are available. Deprecated with TYPO3 12.3
                  "%
                  | optional,
                websiteTitle
                  | String
                  | doc m%"
                  With this language based Website title, you can override the Website title for this language
                  "%
                  | optional,
                ..
              },
          localeMap = predicates.contract_from_predicate
              definitions.predicate.localeMap,
          redirects = {
                autoCreateRedirects
                  | Bool
                  | doc m%"
                  Automatically create redirects for pages with a new slug (works only in LIVE workspace). Default: true
                  "%
                  | optional,
                autoUpdateSlugs
                  | Bool
                  | doc m%"
                  Automatically update slugs of all sub pages. Default: true
                  "%
                  | optional,
                httpStatusCode
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.allOf
                    [
                      predicates.isType 'Integer,
                      predicates.enum
                      [ 300, 301, 302, 303, 304, 305, 306, 307, 308 ]
                    ]
                  ])
                  | doc m%"
                  HTTP status code for the redirect, see https://developer.mozilla.org/en-US/docs/Web/HTTP/Redirections#Temporary_redirections. Default: 307
                  "%
                  | optional,
                redirectTTL
                  | std.number.Integer
                  | doc m%"
                  Time To Live in days for redirect records to be created - `0` disables TTL, no expiration. Default: 0
                  "%
                  | optional,
              },
          staticRoutes = predicates.contract_from_predicate
              definitions.predicate.staticRoutes,
        },
    predicate = {
          baseVariants = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "base", "condition" ],
                predicates.records.record
                {
                  base = predicates.isType '"String",
                  condition = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          enhancerRoute = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "_controller", "routePath" ],
                predicates.records.record
                {
                  _arguments = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  _controller = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^([a-zA-Z0-9]{1,30})::([a-zA-Z0-9]{1,30})$"
                      ],
                  routePath = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          errorHandling = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  predicates.ifThenElse
                  (predicates.records.record
                  { errorHandler = predicates.const "PHP", }
                  {  }
                  true
                  predicates.always)
                  (predicates.allOf
                  [
                    predicates.records.required
                    [ "errorCode", "errorHandler", "errorPhpClassFQCN" ],
                    predicates.records.record
                    {
                      errorCode = predicates.isType 'Integer,
                      errorHandler = predicates.isType '"String",
                      errorPhpClassFQCN = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { errorHandler = predicates.const "Fluid", }
                  {  }
                  true
                  predicates.always)
                  (predicates.allOf
                  [
                    predicates.records.required
                    [ "errorCode", "errorFluidTemplate", "errorHandler" ],
                    predicates.records.record
                    {
                      errorCode = predicates.isType 'Integer,
                      errorFluidLayoutsRootPath = predicates.isType '"String",
                      errorFluidPartialsRootPath = predicates.isType '"String",
                      errorFluidTemplate = predicates.isType '"String",
                      errorFluidTemplatesRootPath = predicates.isType '"String",
                      errorHandler = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { errorHandler = predicates.const "Page", }
                  {  }
                  true
                  predicates.always)
                  (predicates.allOf
                  [
                    predicates.records.required
                    [ "errorCode", "errorContentSource", "errorHandler" ],
                    predicates.records.record
                    {
                      errorCode = predicates.isType 'Integer,
                      errorContentSource = predicates.isType '"String",
                      errorHandler = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always
                  ])
                  predicates.always
                ],
                predicates.records.record
                {
                  errorCode = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.enum [ 0, 404, 403, 500, 503 ]
                        ],
                        predicates.isType 'Integer
                      ],
                  errorHandler = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Page", "Fluid", "PHP" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          language = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "base", "enabled", "languageId", "locale", "title" ],
                predicates.records.record
                {
                  base = predicates.isType '"String",
                  baseVariants = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.baseVariants
                      ],
                  direction = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "", "ltr", "rtl" ]
                      ],
                  enabled = predicates.isType '"Bool",
                  fallbackType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "strict", "fallback", "free" ]
                      ],
                  fallbacks = predicates.isType '"String",
                  flag = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "global",
                          "ad",
                          "ae",
                          "af",
                          "ag",
                          "ai",
                          "al",
                          "am",
                          "an",
                          "ao",
                          "aq",
                          "ar",
                          "as",
                          "at",
                          "au",
                          "aw",
                          "ax",
                          "az",
                          "ba",
                          "bb",
                          "bd",
                          "be",
                          "bf",
                          "bg",
                          "bh",
                          "bi",
                          "bj",
                          "bl",
                          "bm",
                          "bn",
                          "bo",
                          "bq",
                          "br",
                          "bs",
                          "bt",
                          "bv",
                          "bw",
                          "by",
                          "bz",
                          "ca",
                          "catalonia",
                          "cc",
                          "cd",
                          "cf",
                          "cg",
                          "ch",
                          "ci",
                          "ck",
                          "cl",
                          "cm",
                          "cn",
                          "co",
                          "cr",
                          "cs",
                          "cu",
                          "cv",
                          "cw",
                          "cx",
                          "cy",
                          "cz",
                          "de",
                          "dj",
                          "dk",
                          "dm",
                          "do",
                          "dz",
                          "ec",
                          "ee",
                          "eg",
                          "eh",
                          "en-us-gb",
                          "gb-eng",
                          "er",
                          "es",
                          "et",
                          "eu",
                          "fi",
                          "fj",
                          "fk",
                          "fm",
                          "fo",
                          "fr",
                          "ga",
                          "gb",
                          "gd",
                          "ge",
                          "gf",
                          "gg",
                          "gh",
                          "gi",
                          "gl",
                          "gm",
                          "gn",
                          "gp",
                          "gq",
                          "gr",
                          "gs",
                          "gt",
                          "gu",
                          "gw",
                          "gy",
                          "hk",
                          "hm",
                          "hn",
                          "hr",
                          "ht",
                          "hu",
                          "id",
                          "ie",
                          "il",
                          "im",
                          "in",
                          "io",
                          "iq",
                          "ir",
                          "is",
                          "it",
                          "jm",
                          "jo",
                          "jp",
                          "ke",
                          "kg",
                          "kh",
                          "ki",
                          "kl",
                          "km",
                          "kn",
                          "kp",
                          "kr",
                          "kw",
                          "ky",
                          "kz",
                          "la",
                          "lb",
                          "lc",
                          "li",
                          "lk",
                          "lr",
                          "ls",
                          "lt",
                          "lu",
                          "lv",
                          "ly",
                          "ma",
                          "mc",
                          "md",
                          "me",
                          "mf",
                          "mg",
                          "mh",
                          "mi",
                          "mk",
                          "ml",
                          "mm",
                          "mn",
                          "mo",
                          "mp",
                          "mq",
                          "mr",
                          "ms",
                          "mt",
                          "mu",
                          "mv",
                          "mw",
                          "mx",
                          "my",
                          "mz",
                          "na",
                          "nc",
                          "ne",
                          "nf",
                          "ng",
                          "ni",
                          "gb-nir",
                          "nl",
                          "no",
                          "np",
                          "nr",
                          "nu",
                          "nz",
                          "om",
                          "pa",
                          "pe",
                          "pf",
                          "pg",
                          "ph",
                          "pk",
                          "pl",
                          "pm",
                          "pn",
                          "pr",
                          "ps",
                          "pt",
                          "pw",
                          "py",
                          "qa",
                          "qc",
                          "re",
                          "ro",
                          "rs",
                          "ru",
                          "rw",
                          "sa",
                          "sb",
                          "sc",
                          "gb-sct",
                          "sd",
                          "se",
                          "sg",
                          "sh",
                          "si",
                          "sj",
                          "sk",
                          "sl",
                          "sm",
                          "sn",
                          "so",
                          "sr",
                          "ss",
                          "st",
                          "sv",
                          "sx",
                          "sy",
                          "sz",
                          "tc",
                          "td",
                          "tf",
                          "tg",
                          "th",
                          "tj",
                          "tk",
                          "tl",
                          "tm",
                          "tn",
                          "to",
                          "tr",
                          "tt",
                          "tv",
                          "tw",
                          "tz",
                          "ua",
                          "ug",
                          "um",
                          "us",
                          "uy",
                          "uz",
                          "va",
                          "vc",
                          "ve",
                          "vg",
                          "vi",
                          "vn",
                          "vu",
                          "gb-wls",
                          "wf",
                          "ws",
                          "ye",
                          "yt",
                          "za",
                          "zm",
                          "zw"
                        ]
                      ],
                  hreflang = predicates.isType '"String",
                  iso-639-1 = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "ab",
                          "aa",
                          "af",
                          "ak",
                          "sq",
                          "am",
                          "ar",
                          "an",
                          "hy",
                          "as",
                          "av",
                          "ae",
                          "ay",
                          "az",
                          "bm",
                          "ba",
                          "eu",
                          "be",
                          "bn",
                          "bh",
                          "bi",
                          "bs",
                          "br",
                          "bg",
                          "my",
                          "ca",
                          "ch",
                          "ce",
                          "ny",
                          "zh",
                          "cv",
                          "kw",
                          "co",
                          "cr",
                          "hr",
                          "cs",
                          "da",
                          "dv",
                          "nl",
                          "dz",
                          "en",
                          "eo",
                          "et",
                          "ee",
                          "fo",
                          "fj",
                          "fi",
                          "fr",
                          "ff",
                          "gl",
                          "ka",
                          "de",
                          "el",
                          "gn",
                          "gu",
                          "ht",
                          "ha",
                          "he",
                          "hz",
                          "hi",
                          "ho",
                          "hu",
                          "ia",
                          "id",
                          "ie",
                          "ga",
                          "ig",
                          "ik",
                          "io",
                          "is",
                          "it",
                          "iu",
                          "ja",
                          "jv",
                          "kl",
                          "kn",
                          "kr",
                          "ks",
                          "kk",
                          "km",
                          "ki",
                          "rw",
                          "ky",
                          "kv",
                          "kg",
                          "ko",
                          "ku",
                          "kj",
                          "la",
                          "lb",
                          "lg",
                          "li",
                          "ln",
                          "lo",
                          "lt",
                          "lu",
                          "lv",
                          "gv",
                          "mk",
                          "mg",
                          "ms",
                          "ml",
                          "mt",
                          "mi",
                          "mr",
                          "mh",
                          "mn",
                          "na",
                          "nv",
                          "nd",
                          "ne",
                          "ng",
                          "nb",
                          "nn",
                          "no",
                          "ii",
                          "nr",
                          "oc",
                          "oj",
                          "cu",
                          "om",
                          "or",
                          "os",
                          "pa",
                          "pi",
                          "fa",
                          "pl",
                          "ps",
                          "pt",
                          "qu",
                          "rm",
                          "rn",
                          "ro",
                          "ru",
                          "sa",
                          "sc",
                          "sd",
                          "se",
                          "sm",
                          "sg",
                          "sr",
                          "gd",
                          "sn",
                          "si",
                          "sk",
                          "sl",
                          "so",
                          "st",
                          "es",
                          "su",
                          "sw",
                          "ss",
                          "sv",
                          "ta",
                          "te",
                          "tg",
                          "th",
                          "ti",
                          "bo",
                          "tk",
                          "tl",
                          "tn",
                          "to",
                          "tr",
                          "ts",
                          "tt",
                          "tw",
                          "ty",
                          "ug",
                          "uk",
                          "ur",
                          "uz",
                          "ve",
                          "vi",
                          "vo",
                          "wa",
                          "cy",
                          "wo",
                          "fy",
                          "xh",
                          "yi",
                          "yo",
                          "za",
                          "zu"
                        ]
                      ],
                  languageId = predicates.isType 'Integer,
                  locale = predicates.isType '"String",
                  navigationTitle = predicates.isType '"String",
                  title = predicates.isType '"String",
                  typo3Language = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "default",
                            "af",
                            "ar",
                            "bs",
                            "bg",
                            "ca",
                            "ch",
                            "cs",
                            "da",
                            "de",
                            "el",
                            "eo",
                            "es",
                            "et",
                            "eu",
                            "fa",
                            "fi",
                            "fo",
                            "fr",
                            "fr_CA",
                            "gl",
                            "he",
                            "hi",
                            "hr",
                            "hu",
                            "is",
                            "it",
                            "ja",
                            "ka",
                            "kl",
                            "km",
                            "ko",
                            "lt",
                            "lv",
                            "mi",
                            "mk",
                            "ms",
                            "nl",
                            "no",
                            "pl",
                            "pt",
                            "pt_BR",
                            "ro",
                            "ru",
                            "rw",
                            "sk",
                            "sl",
                            "sq",
                            "sr",
                            "sv",
                            "th",
                            "tr",
                            "uk",
                            "vi",
                            "zh"
                          ]
                        ],
                        predicates.isType '"String"
                      ],
                  websiteTitle = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          localeMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.arrays.minItems 1,
                predicates.records.record
                {
                  locale = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          redirects = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  autoCreateRedirects = predicates.isType '"Bool",
                  autoUpdateSlugs = predicates.isType '"Bool",
                  httpStatusCode = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.enum
                          [ 300, 301, 302, 303, 304, 305, 306, 307, 308 ]
                        ]
                      ],
                  redirectTTL = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          staticRoutes = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.ifThenElse
                (predicates.records.record { type = predicates.const "uri", }
                {  }
                true
                predicates.always)
                (predicates.allOf
                [
                  predicates.records.required [ "source" ],
                  predicates.records.record
                  { source = predicates.isType '"String", }
                  {  }
                  true
                  predicates.always
                ])
                (predicates.allOf
                [
                  predicates.records.required [ "content" ],
                  predicates.records.record
                  { content = predicates.isType '"String", }
                  {  }
                  true
                  predicates.always
                ]),
                predicates.records.required [ "route", "type" ],
                predicates.records.record
                {
                  route = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "uri", "staticText" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

{
  base
    | String
    | doc m%"
    Base URL. This is the URL under which this site is available
    "%,
  baseVariants
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.baseVariants
    ])
    | optional,
  errorHandling
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.errorHandling
    ])
    | optional,
  languages
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.language
    ]),
  rootPageId
    | std.number.Integer
    | doc m%"
    ID of the page where this site begins
    "%,
  routeEnhancers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.allOf
        [
          predicates.ifThenElse
          (predicates.records.record { type = predicates.const "Simple", } {  }
          true
          predicates.always)
          (predicates.allOf
          [
            predicates.records.required [ "_arguments", "routePath", "type" ],
            predicates.records.record {  } {  } true predicates.always
          ])
          predicates.always,
          predicates.ifThenElse
          (predicates.records.record { type = predicates.const "Plugin", } {  }
          true
          predicates.always)
          (predicates.allOf
          [
            predicates.records.required [ "namespace", "requirements", "type" ],
            predicates.records.record
            { namespace = predicates.isType '"String", }
            {  }
            true
            predicates.always
          ])
          predicates.always,
          predicates.ifThenElse
          (predicates.records.record { type = predicates.const "Extbase", } {  }
          true
          predicates.always)
          (predicates.allOf
          [
            predicates.records.required
            [ "defaultController", "extension", "plugin", "type" ],
            predicates.records.record
            {
              defaultController = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^([a-zA-Z0-9]{1,30})::([a-zA-Z0-9]{1,30})$"
                  ],
              defaults = predicates.isType 'Record,
              extension = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^([A-Z]{1})([a-zA-Z0-9]{2,30})$"
                  ],
              plugin = predicates.isType '"String",
              routes = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.enhancerRoute
                  ],
            }
            {  }
            true
            predicates.always
          ])
          predicates.always
        ],
        predicates.records.required [ "type" ],
        predicates.records.record
        {
          _arguments = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          aspects = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.allOf
                  [
                    predicates.ifThenElse
                    (predicates.records.record
                    { type = predicates.const "PersistedAliasMapper", }
                    {  }
                    true
                    predicates.always)
                    (predicates.allOf
                    [
                      predicates.records.required
                      [ "routeFieldName", "tableName", "type" ],
                      predicates.records.record
                      {
                        routeFieldName = predicates.isType '"String",
                        routeValuePrefix = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.maxLength 1
                            ],
                        tableName = predicates.isType '"String",
                        type = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                    predicates.always,
                    predicates.ifThenElse
                    (predicates.records.record
                    { type = predicates.const "PersistedPatternMapper", }
                    {  }
                    true
                    predicates.always)
                    (predicates.allOf
                    [
                      predicates.records.required
                      [ "routeFieldName", "tableName", "type" ],
                      predicates.records.record
                      {
                        routeFieldName = predicates.isType '"String",
                        routeValuePrefix = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.maxLength 1
                            ],
                        tableName = predicates.isType '"String",
                        type = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                    predicates.always,
                    predicates.ifThenElse
                    (predicates.records.record
                    { type = predicates.const "LocaleModifier", }
                    {  }
                    true
                    predicates.always)
                    (predicates.allOf
                    [
                      predicates.records.required
                      [ "default", "localeMap", "type" ],
                      predicates.records.record
                      {
                        "default" = predicates.isType '"String",
                        localeMap = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              definitions.predicate.localeMap
                            ],
                        type = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                    predicates.always,
                    predicates.ifThenElse
                    (predicates.records.record
                    { type = predicates.const "StaticRangeMapper", }
                    {  }
                    true
                    predicates.always)
                    (predicates.allOf
                    [
                      predicates.records.required [ "end", "start", "type" ],
                      predicates.records.record
                      {
                        end = predicates.isType '"String",
                        start = predicates.isType '"String",
                        type = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                    predicates.always,
                    predicates.ifThenElse
                    (predicates.records.record
                    { type = predicates.const "StaticValueMapper", }
                    {  }
                    true
                    predicates.always)
                    (predicates.allOf
                    [
                      predicates.records.required [ "map", "type" ],
                      predicates.records.record
                      {
                        map = predicates.isType 'Record,
                        type = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                    predicates.always
                  ],
                  predicates.records.required [ "type" ],
                  predicates.records.record
                  {
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.anyOf
                          [
                            predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum
                              [
                                "LocaleModifier",
                                "PersistedAliasMapper",
                                "PersistedPatternMapper",
                                "StaticRangeMapper",
                                "StaticValueMapper"
                              ]
                            ],
                            predicates.isType '"String"
                          ]
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          "default" = predicates.isType '"String",
          limitToPages = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"Number"),
                predicates.arrays.uniqueItems
              ],
          requirements = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          routePath = predicates.isType '"String",
          type = predicates.allOf
              [
                predicates.isType '"String",
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum
                    [ "Simple", "Plugin", "Extbase", "PageType" ]
                  ],
                  predicates.isType '"String"
                ]
              ],
        }
        {  }
        true
        predicates.always
      ])
    ])
    | doc m%"
    routeEnhancers transform arguments into nice urls. Docs can be found at https://docs.typo3.org/m/typo3/reference-coreapi/master/en-us/ApiOverview/Routing/Index.html
    "%
    | optional,
  routes
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.staticRoutes
    ])
    | optional,
  settings
    | { redirects | definitions.contract.redirects | optional, .. }
    | optional,
  sitePackage
    | String
    | doc m%"
    Extension key for site setup (used by EXT:bolt)
    "%
    | optional,
  solr_core_read
    | String
    | doc m%"
    EXT:solr default core for read
    "%
    | optional,
  solr_enabled_read
    | Bool
    | doc m%"
    EXT:solr enable default solr read
    "%
    | optional,
  solr_host_read
    | String
    | doc m%"
    EXT:solr default host for read
    "%
    | optional,
  solr_password_read
    | String
    | doc m%"
    EXT:solr password for read
    "%
    | optional,
  solr_port_read
    | String
    | doc m%"
    EXT:solr port for read
    "%
    | optional,
  solr_scheme_read
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"String",
      predicates.allOf
      [
        predicates.isType '"String",
        predicates.enum [ "http", "https", "%env(SOLR_SCHEME)%" ]
      ]
    ])
    | doc m%"
    EXT:solr scheme for read
    "%
    | optional,
  solr_use_write_connection
    | Bool
    | doc m%"
    EXT:solr use write connection
    "%
    | optional,
  solr_username_read
    | String
    | doc m%"
    EXT:solr username for read
    "%
    | optional,
  websiteTitle
    | String
    | doc m%"
    Default website title
    "%
    | optional,
  ..
}