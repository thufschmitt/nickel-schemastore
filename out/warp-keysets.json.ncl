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
          key = predicates.contract_from_predicate definitions.predicate.key,
        },
    predicate = {
          key = predicates.allOf
              [
                predicates.isType '"String",
                predicates.not (predicates.strings.pattern "---"),
                predicates.strings.minLength 1
              ],
        },
  }
in

{
  "editor:delete_word_left"
    | definitions.contract.key
    | doc m%"
    Delete word left
    "%
    | optional,
  "editor:delete_word_right"
    | definitions.contract.key
    | doc m%"
    Delete word right
    "%
    | optional,
  "editor:insert_last_word_previous_command"
    | definitions.contract.key
    | doc m%"
    Insert last word of previous command
    "%
    | optional,
  "editor:select_right"
    | definitions.contract.key
    | doc m%"
    Select one character to the right
    "%
    | optional,
  "editor:select_to_line_end"
    | definitions.contract.key
    | doc m%"
    Select to end of line
    "%
    | optional,
  "editor_view:add_cursor_above"
    | definitions.contract.key
    | doc m%"
    Add cursor above
    "%
    | optional,
  "editor_view:add_cursor_below"
    | definitions.contract.key
    | doc m%"
    Add cursor below
    "%
    | optional,
  "editor_view:add_next_occurrence"
    | definitions.contract.key
    | doc m%"
    Add selection for next occurrence
    "%
    | optional,
  "editor_view:backspace"
    | definitions.contract.key
    | doc m%"
    Remove the previous character
    "%
    | optional,
  "editor_view:clear_and_copy_lines"
    | definitions.contract.key
    | doc m%"
    Copy and clear selected lines
    "%
    | optional,
  "editor_view:clear_buffer"
    | definitions.contract.key
    | doc m%"
    Clear command editor
    "%
    | optional,
  "editor_view:clear_lines"
    | definitions.contract.key
    | doc m%"
    Clear selected lines
    "%
    | optional,
  "editor_view:cmd_down"
    | definitions.contract.key
    | doc m%"
    Move cursor to the bottom
    "%
    | optional,
  "editor_view:cmd_i"
    | definitions.contract.key
    | doc m%"
    Inspect command
    "%
    | optional,
  "editor_view:cut_all_right"
    | definitions.contract.key
    | doc m%"
    Cut all right
    "%
    | optional,
  "editor_view:cut_word_left"
    | definitions.contract.key
    | doc m%"
    Cut word left
    "%
    | optional,
  "editor_view:cut_word_right"
    | definitions.contract.key
    | doc m%"
    Cut word right
    "%
    | optional,
  "editor_view:delete"
    | definitions.contract.key
    | doc m%"
    Delete
    "%
    | optional,
  "editor_view:delete_all_left"
    | definitions.contract.key
    | doc m%"
    Delete all left
    "%
    | optional,
  "editor_view:delete_all_right"
    | definitions.contract.key
    | doc m%"
    Delete all right
    "%
    | optional,
  "editor_view:down"
    | definitions.contract.key
    | doc m%"
    Move cursor down
    "%
    | optional,
  "editor_view:end"
    | definitions.contract.key
    | doc m%"
    End
    "%
    | optional,
  "editor_view:fold"
    | definitions.contract.key
    | doc m%"
    Fold
    "%
    | optional,
  "editor_view:fold_selected_ranges"
    | definitions.contract.key
    | doc m%"
    Fold selected ranges
    "%
    | optional,
  "editor_view:home"
    | definitions.contract.key
    | doc m%"
    Home
    "%
    | optional,
  "editor_view:insert_newline"
    | definitions.contract.key
    | doc m%"
    Insert newline
    "%
    | optional,
  "editor_view:left"
    | definitions.contract.key
    | doc m%"
    Move cursor left
    "%
    | optional,
  "editor_view:move_backward_one_subword"
    | definitions.contract.key
    | doc m%"
    Move backward one subword
    "%
    | optional,
  "editor_view:move_backward_one_word"
    | definitions.contract.key
    | doc m%"
    Move backward one word
    "%
    | optional,
  "editor_view:move_forward_one_subword"
    | definitions.contract.key
    | doc m%"
    Move forward one subword
    "%
    | optional,
  "editor_view:move_forward_one_word"
    | definitions.contract.key
    | doc m%"
    Move forward one word
    "%
    | optional,
  "editor_view:move_to_buffer_end"
    | definitions.contract.key
    | doc m%"
    Move to the end of the buffer
    "%
    | optional,
  "editor_view:move_to_buffer_start"
    | definitions.contract.key
    | doc m%"
    Move to the start of the buffer
    "%
    | optional,
  "editor_view:move_to_line_end"
    | definitions.contract.key
    | doc m%"
    Move to end of line
    "%
    | optional,
  "editor_view:move_to_line_start"
    | definitions.contract.key
    | doc m%"
    Move to start of line
    "%
    | optional,
  "editor_view:move_to_paragraph_end"
    | definitions.contract.key
    | doc m%"
    Move to the end of the paragraph
    "%
    | optional,
  "editor_view:move_to_paragraph_start"
    | definitions.contract.key
    | doc m%"
    Move to the start of the paragraph
    "%
    | optional,
  "editor_view:right"
    | definitions.contract.key
    | doc m%"
    Move cursor right / accept autosuggestion
    "%
    | optional,
  "editor_view:select_all"
    | definitions.contract.key
    | doc m%"
    Select all
    "%
    | optional,
  "editor_view:select_down"
    | definitions.contract.key
    | doc m%"
    Select down
    "%
    | optional,
  "editor_view:select_left"
    | definitions.contract.key
    | doc m%"
    Select one character to the left
    "%
    | optional,
  "editor_view:select_left_by_word"
    | definitions.contract.key
    | doc m%"
    Select one word to the left
    "%
    | optional,
  "editor_view:select_right_by_word"
    | definitions.contract.key
    | doc m%"
    Select one word to the right
    "%
    | optional,
  "editor_view:select_to_line_start"
    | definitions.contract.key
    | doc m%"
    Select to start of line
    "%
    | optional,
  "editor_view:select_up"
    | definitions.contract.key
    | doc m%"
    Select up
    "%
    | optional,
  "editor_view:unfold"
    | definitions.contract.key
    | doc m%"
    Unfold
    "%
    | optional,
  "editor_view:up"
    | definitions.contract.key
    | doc m%"
    Move cursor up
    "%
    | optional,
  "find:find_next_occurrence"
    | definitions.contract.key
    | doc m%"
    Find the next occurrence of your search query
    "%
    | optional,
  "find:find_prev_occurrence"
    | definitions.contract.key
    | doc m%"
    Find the previous occurrence of your search query
    "%
    | optional,
  "input:clear_screen"
    | definitions.contract.key
    | doc m%"
    Clear screen
    "%
    | optional,
  "input:toggle_natural_language_command_search"
    | definitions.contract.key
    | doc m%"
    Ai command suggestions
    "%
    | optional,
  "input:toggle_workflows"
    | definitions.contract.key
    | doc m%"
    Workflows
    "%
    | optional,
  "pane_group:add_down"
    | definitions.contract.key
    | doc m%"
    Split pane down
    "%
    | optional,
  "pane_group:add_right"
    | definitions.contract.key
    | doc m%"
    Split pane right
    "%
    | optional,
  "pane_group:navigate_down"
    | definitions.contract.key
    | doc m%"
    Switch panes down
    "%
    | optional,
  "pane_group:navigate_left"
    | definitions.contract.key
    | doc m%"
    Switch panes left
    "%
    | optional,
  "pane_group:navigate_next"
    | definitions.contract.key
    | doc m%"
    Activate next pane
    "%
    | optional,
  "pane_group:navigate_prev"
    | definitions.contract.key
    | doc m%"
    Activate previous pane
    "%
    | optional,
  "pane_group:navigate_right"
    | definitions.contract.key
    | doc m%"
    Switch panes right
    "%
    | optional,
  "pane_group:navigate_up"
    | definitions.contract.key
    | doc m%"
    Switch panes up
    "%
    | optional,
  "pane_group:resize_down"
    | definitions.contract.key
    | doc m%"
    Resize pane > move divider down
    "%
    | optional,
  "pane_group:resize_left"
    | definitions.contract.key
    | doc m%"
    Resize pane > move divider left
    "%
    | optional,
  "pane_group:resize_right"
    | definitions.contract.key
    | doc m%"
    Resize pane > move divider right
    "%
    | optional,
  "pane_group:resize_up"
    | definitions.contract.key
    | doc m%"
    Resize pane > move divider up
    "%
    | optional,
  "pane_group:toggle_maximize_pane"
    | definitions.contract.key
    | doc m%"
    Toggle maximize active pane
    "%
    | optional,
  "terminal:bookmark_selected_block"
    | definitions.contract.key
    | doc m%"
    Bookmark selected block
    "%
    | optional,
  "terminal:clear_blocks"
    | definitions.contract.key
    | doc m%"
    Clear blocks
    "%
    | optional,
  "terminal:copy"
    | definitions.contract.key
    | doc m%"
    Copy
    "%
    | optional,
  "terminal:copy_commands"
    | definitions.contract.key
    | doc m%"
    Copy command
    "%
    | optional,
  "terminal:copy_outputs"
    | definitions.contract.key
    | doc m%"
    Copy command output
    "%
    | optional,
  "terminal:expand_block_selection_above"
    | definitions.contract.key
    | doc m%"
    Expand selected blocks above
    "%
    | optional,
  "terminal:expand_block_selection_below"
    | definitions.contract.key
    | doc m%"
    Expand selected blocks below
    "%
    | optional,
  "terminal:find"
    | definitions.contract.key
    | doc m%"
    Find
    "%
    | optional,
  "terminal:focus_input"
    | definitions.contract.key
    | doc m%"
    Focus terminal input
    "%
    | optional,
  "terminal:open_block_list_context_menu_via_keybinding"
    | definitions.contract.key
    | doc m%"
    Open block context menu
    "%
    | optional,
  "terminal:open_share_modal"
    | definitions.contract.key
    | doc m%"
    Share selected block
    "%
    | optional,
  "terminal:paste"
    | definitions.contract.key
    | doc m%"
    Paste
    "%
    | optional,
  "terminal:reinput_commands"
    | definitions.contract.key
    | doc m%"
    Reinput selected commands
    "%
    | optional,
  "terminal:reinput_commands_with_sudo"
    | definitions.contract.key
    | doc m%"
    Reinput selected commands as root
    "%
    | optional,
  "terminal:select_all_blocks"
    | definitions.contract.key
    | doc m%"
    Select all blocks
    "%
    | optional,
  "terminal:select_bookmark_down"
    | definitions.contract.key
    | doc m%"
    Select the closest bookmark down
    "%
    | optional,
  "terminal:select_bookmark_up"
    | definitions.contract.key
    | doc m%"
    Select the closest bookmark up
    "%
    | optional,
  "terminal:select_next_block"
    | definitions.contract.key
    | doc m%"
    Select next block
    "%
    | optional,
  "terminal:select_previous_block"
    | definitions.contract.key
    | doc m%"
    Select previous block
    "%
    | optional,
  "workspace:activate_eighth_tab"
    | definitions.contract.key
    | doc m%"
    Switch to 8th tab
    "%
    | optional,
  "workspace:activate_fifth_tab"
    | definitions.contract.key
    | doc m%"
    Switch to 5th tab
    "%
    | optional,
  "workspace:activate_first_tab"
    | definitions.contract.key
    | doc m%"
    Switch to 1st tab
    "%
    | optional,
  "workspace:activate_fourth_tab"
    | definitions.contract.key
    | doc m%"
    Switch to 4th tab
    "%
    | optional,
  "workspace:activate_last_tab"
    | definitions.contract.key
    | doc m%"
    Switch to last tab
    "%
    | optional,
  "workspace:activate_next_tab"
    | definitions.contract.key
    | doc m%"
    Activate next tab
    "%
    | optional,
  "workspace:activate_prev_tab"
    | definitions.contract.key
    | doc m%"
    Activate previous tab
    "%
    | optional,
  "workspace:activate_second_tab"
    | definitions.contract.key
    | doc m%"
    Switch to 2nd tab
    "%
    | optional,
  "workspace:activate_seventh_tab"
    | definitions.contract.key
    | doc m%"
    Switch to 7th tab
    "%
    | optional,
  "workspace:activate_sixth_tab"
    | definitions.contract.key
    | doc m%"
    Switch to 6th tab
    "%
    | optional,
  "workspace:activate_third_tab"
    | definitions.contract.key
    | doc m%"
    Switch to 3rd tab
    "%
    | optional,
  "workspace:decrease_font_size"
    | definitions.contract.key
    | doc m%"
    Decrease font size
    "%
    | optional,
  "workspace:increase_font_size"
    | definitions.contract.key
    | doc m%"
    Increase font size
    "%
    | optional,
  "workspace:move_tab_left"
    | definitions.contract.key
    | doc m%"
    Move tab left
    "%
    | optional,
  "workspace:move_tab_right"
    | definitions.contract.key
    | doc m%"
    Move tab right
    "%
    | optional,
  "workspace:reset_font_size"
    | definitions.contract.key
    | doc m%"
    Reset font size to default
    "%
    | optional,
  "workspace:set_a11y_concise_verbosity_level"
    | definitions.contract.key
    | doc m%"
    [a11y] set concise accessibility announcements
    "%
    | optional,
  "workspace:set_a11y_verbose_verbosity_level"
    | definitions.contract.key
    | doc m%"
    [a11y] set verbose accessibility announcements
    "%
    | optional,
  "workspace:show_command_search"
    | definitions.contract.key
    | doc m%"
    Command search
    "%
    | optional,
  "workspace:show_keybinding_settings"
    | definitions.contract.key
    | doc m%"
    Open keybindings editor
    "%
    | optional,
  "workspace:show_settings_account_page"
    | definitions.contract.key
    | doc m%"
    Open settings: account
    "%
    | optional,
  "workspace:show_settings_modal"
    | definitions.contract.key
    | doc m%"
    Open settings
    "%
    | optional,
  "workspace:show_theme_chooser"
    | definitions.contract.key
    | doc m%"
    Open theme picker
    "%
    | optional,
  "workspace:toggle_command_palette"
    | definitions.contract.key
    | doc m%"
    Toggle command palette
    "%
    | optional,
  "workspace:toggle_launch_config_palette"
    | definitions.contract.key
    | doc m%"
    Launch configuration palette
    "%
    | optional,
  "workspace:toggle_mouse_reporting"
    | definitions.contract.key
    | doc m%"
    Toggle mouse reporting
    "%
    | optional,
  "workspace:toggle_navigation_palette"
    | definitions.contract.key
    | doc m%"
    Toggle navigation palette
    "%
    | optional,
  "workspace:toggle_resource_center"
    | definitions.contract.key
    | doc m%"
    Open resource center
    "%
    | optional,
}