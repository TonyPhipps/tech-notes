Basic Function Creation and Use

```kotlin
fun thisIsMyAddFunction(number1: Number = 1, number2: Number = 2, name: String = "Dummy"): Long {
    println("Ok, $name! Combining your numbers $number1 and $number2")
    val number1 = number1.toLong()
    val number2 = number2.toLong()
    val mySolution = number1 + number2
    return mySolution
}

fun main() {
    val solution1 = thisIsMyAddFunction(2, 622222222222, "Sally")
    println("the Solution is $solution1")
    val solution2 = thisIsMyAddFunction(name = "Tony", number2 = 3, number1 = 9)
    println("the Solution is $solution2")
    val solution3 = thisIsMyAddFunction()
    println("the Solution is $solution3")
}
```