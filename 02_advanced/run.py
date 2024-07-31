import sys

def option1():
  print("Option 1 selected")
  # Add your code for option 1 here

def option2():
  print("Option 2 selected")
  # Add your code for option 2 here

def option3():
  print("Option 3 selected")
  # Add your code for option 3 here

def main():
  print("Please select:")
  print("- [1-2] Reproduce some/all experiments found in the paper.")
  print("- [3] Browse sources and supporting files.")
  print("1) Figure 1")
  print("2) Paper (~1 min)")
  print("3) Browse")
  choice = input("Enter your choice (1-3): ")

  if choice == "1":
    option1()
  elif choice == "2":
    option2()
  elif choice == "3":
    option3()
  else:
    print("Invalid choice. Please try again.")
    main()

main()
