<#
.NOTES
    This class demonstrates basic class structure and functionality in PowerShell.

    # Create an instance of the SampleClass
    $person = [SampleClass]::new('John Doe', 30)

    # Call the Greet method
    $message = $person.Greet()
    Write-Output $message

    # Increment the age and output a birthday message
    $person.HaveBirthday()

    # Access the properties
    Write-Output "Name: $($person.Name)"
    Write-Output "Age: $($person.Age)"
#>
class SampleClass {
    [string]$Name
    [int]$Age

    SampleClass([string]$Name, [int]$Age) {
        $this.Name = $Name
        $this.Age = $Age
    }

    [string]Greet() {
        return "Hello, my name is $($this.Name) and I am $($this.Age) years old."
    }

    [string]HaveBirthday() {
        $this.Age++
        return "Happy Birthday $($this.Name)! You are now $($this.Age) years old."
    }
}
