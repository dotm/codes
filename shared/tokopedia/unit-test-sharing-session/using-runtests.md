
**Note: if you add a new directory without a `_test.go` file,
it will NOT be included in the code coverage calculation.**

If you want to include your new directory,
adding an empty `_test.go` file will be enough.

Example:
```
main
 ├ main.go
 └ main_test.go
```
!main_test.go
```
package main

//this empty file is here to trigger the code coverage mechanism
```

Directories that ideally should be included in code coverage:
- `/cmd/*`
- `/internal/app/interface/*`
- `/internal/app/usecase/*`

Directories that might need to be included in code coverage:
- `/internal/pkg/*`
- `/internal/app/domain/*`

Directories that does not need to be included in code coverage:
- `/vendor/*`
- `/configs/*`
- etc.