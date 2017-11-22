# Compile yacc and lex
yacc -d -v parser.y
lex scanner.l
gcc y.tab.c lex.yy.c -ly -ll -o parser

# Remove useless files
rm y.tab.*
rm y.output
rm lex.yy.c

# Testing
echo "\n\nStart testing."
TEST_FILE="test.p"
./parser TestCase/Project2/$TEST_FILE >> ans.log 2>&1

DIFF_RESULT=$(diff ans.log TestCase/Project2/ExAns/r$TEST_FILE)
if [ "$DIFF_RESULT" = "" ]; then
    echo "Your answer is correct!"
else
    echo "Your answer is different!"
    echo "\nYour answer:"
    cat ans.log
    echo "\nExample answer:"
    cat TestCase/Project2/ExAns/r$TEST_FILE
fi
rm ans.log
