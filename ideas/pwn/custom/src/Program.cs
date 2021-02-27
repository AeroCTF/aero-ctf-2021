using System;
using System.IO;
using System.Collections.Generic;
using System.Runtime.InteropServices;

namespace Custom
{
    public class CustomerInfo
    {
        public int Id;
        public int Balance;

        public virtual void ChangeBalance(int balance)
        {
            Balance = balance;
        }

        public virtual int BuyItem(long price)
        {
            Balance -= (int)price;
            return Balance;
        }
    }

    [StructLayout(LayoutKind.Explicit)]
    public struct Customer
    {
        [FieldOffset(0)]
        public string CustomerName;

        [FieldOffset(0)]
        public CustomerInfo CustomerInfo;
    }

    public class Program
    {
        public static void Main(string[] args)
        {
            var flag = File.ReadAllText("flag.txt");
            var customers = new List<Customer>();

            Console.WriteLine("[!] hello!");

            while (true)
            {
                Console.WriteLine(
                    "\n" +
                    "1. create customer\n" +
                    "2. change customer name\n" +
                    "3. change customer balance\n" +
                    "4. show customer name\n" +
                    "5. show customer balance\n" +
                    "6. buy an item\n" +
                    "7. exit\n"
                );

                Console.Write("[?] >>> ");
                var input = Console.ReadLine();

                if (!int.TryParse(input, out var option) || option < 1 || option > 7)
                {
                    Console.WriteLine("[-] incorrect option");
                    continue;
                }

                if (option == 1)
                {
                    var id = customers.Count;
                    var customer = new Customer() {
                        CustomerInfo = new CustomerInfo { Id = id }
                    };
                    
                    customers.Add(customer);
                    Console.WriteLine($"[+] id = {id}");
                }
                else if (option >= 2 && option <= 6)
                {
                    Console.Write("[?] customer id: ");
                    input = Console.ReadLine();

                    if (!int.TryParse(input, out var id) || id < 0 || id >= customers.Count) 
                    {
                        Console.WriteLine("[-] incorrect id");
                        continue;
                    }
                    
                    if (option == 2)
                    {
                        Console.Write("[?] name: ");
                        input = Console.ReadLine();
                        
                        customers[id] = new Customer {
                            CustomerInfo = customers[id].CustomerInfo,
                            CustomerName = input
                        };
                    }
                    else if (option == 3)
                    {
                        Console.Write("[?] balance: ");
                        input = Console.ReadLine();

                        if (!int.TryParse(input, out var balance)) 
                        {
                            Console.WriteLine("[-] incorrect balance");
                            continue;
                        }

                        customers[id].CustomerInfo.ChangeBalance(balance);
                    }
                    else if (option == 4)
                    {
                        Console.WriteLine($"[+] name = {customers[id].CustomerName}");
                    }
                    else if (option == 5)
                    {
                        Console.WriteLine($"[+] balance = {customers[id].CustomerInfo.Balance}");
                    }
                    else if (option == 6)
                    {
                        Console.Write("[?] item price: ");
                        input = Console.ReadLine();

                        if (!long.TryParse(input, out var price)) 
                        {
                            Console.WriteLine("[-] incorrect price");
                            continue;
                        }

                        var result = customers[id].CustomerInfo.BuyItem(price);
                        Console.WriteLine($"[+] new balance = {result}");
                    }
                }
                else if (option == 7)
                {
                    Console.WriteLine("[+] bye");
                    break;
                }
            }
        }
    }
}
