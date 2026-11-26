first(.[] | select(
  (.headRefName | startswith("bump-" + $formula + "-")) and
  (.title | startswith($formula + " "))
)) | .number
