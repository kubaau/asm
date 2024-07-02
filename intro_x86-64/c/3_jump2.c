int main()
{
    unsigned n = 3;
    unsigned power = 19;

    int result = 1;
    while (power)
    {
        if (power & 1)
        {
            result *= n;
            --power;
        }
        n *= n;
        power /= 2;
    }
    return result;
}
