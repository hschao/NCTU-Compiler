# Compile
make

# Testing
printf "\n\nStart testing.\n"
TEST_FILE="error"
./parser TestCase/Project3/Examples/$TEST_FILE.p >> ans.log 2>&1

DIFF_RESULT=$(diff ans.log TestCase/Project3/Answers/$TEST_FILE.txt)
if [ "$DIFF_RESULT" = "" ]; then
    printf "Your answer is correct!\n"
else
    printf "Your answer is different!\n"
    printf "\nYour answer:\n"
    cat ans.log
    printf "\nExample answer:\n"
    cat TestCase/Project3/Answers/$TEST_FILE.txt
fi
rm ans.log
