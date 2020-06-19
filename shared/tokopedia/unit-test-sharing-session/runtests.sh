#Run in CLI with: ./runtests.sh
#if you encounter command not found error
#  don't forget the dot before `/runtests.sh`
#if you encounter permission denied error
#  run this first: chmod +x runtests.sh
#  and then try running the command again: ./runtests.sh

OUTPUT_FILE_FOR_UNIT_TEST=test-coverage.out
readonly OUTPUT_FILE_FOR_UNIT_TEST

go test ./... -coverprofile=$OUTPUT_FILE_FOR_UNIT_TEST
#the ./... in the line above means: go test all subdirectory (/...) of current directory (./)
#  for more details, run this from command line: go help package
#we are assuming here that this run test script is put in the root project directory
#  and the user also run the script from the root project directory

#Reporting code coverage
echo "\n"
echo "Total coverage: "
go tool cover -func $OUTPUT_FILE_FOR_UNIT_TEST | grep total | awk '{print $3}'

#Add instruction to manually view coverage output
echo "\n"
echo "To view the coverage data, run this command from your terminal:"
echo "go tool cover -html=${OUTPUT_FILE_FOR_UNIT_TEST}"