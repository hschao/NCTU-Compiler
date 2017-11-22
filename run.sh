# Compile yacc and lex
yacc -d -v parser.y
lex scanner.l
gcc y.tab.c lex.yy.c -ly -ll -o parser.out

# Remove useless files
rm y.tab.*
rm y.output
rm lex.yy.c

# Testing
printf "\n\nStart testing.\n"
TEST_FILE="test.p"
./parser.out TestCase/Project2/$TEST_FILE >> ans.log 2>&1

DIFF_RESULT=$(diff ans.log TestCase/Project2/ExAns/r$TEST_FILE)
if [ "$DIFF_RESULT" = "" ]; then
    printf "Your answer is correct!\n"
else
    printf "Your answer is different!\n"
    printf "\nYour answer:\n"
    cat ans.log
    printf "\nExample answer:\n"
    cat TestCase/Project2/ExAns/r$TEST_FILE
fi
rm ans.log
