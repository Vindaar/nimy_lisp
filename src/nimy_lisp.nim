import sequtils

proc dollar[T](s: T): string =
  result = $s

proc mapconcat*[T](s: openArray[T]; sep = " "; op: proc(x: T): string = dollar): string =
  ## Concatenate elements of ``s`` after applying ``op`` to each element.
  ## Separate each element using ``sep``.
  for i, x in s:
    result.add(op(x))
    if i < s.len-1:
      result.add(sep)

when isMainModule:
  import strformat
  let
    s1 = @["abc", "def", "ghi"]
    s2 = ["abc", "def", "ghi"]
    s3 = [1, 2, 3]
    s4: seq[string] = @[]
  echo fmt"`{s1.mapconcat()}'"
  echo fmt"`{s2.mapconcat()}'"
  echo fmt"`{s3.mapconcat()}'"
  echo fmt"`{s4.mapconcat()}'"
  let foo = s3.mapconcat("\n", proc(x: int): string = "Ha: " & $x)
  echo fmt"`{foo}'"
