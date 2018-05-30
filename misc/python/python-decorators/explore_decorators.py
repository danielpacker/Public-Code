"""Some python decorator examples and experiments"""

import time
from functools import wraps
import inspect


def before_and_after(f):
    @wraps(f)
    def wrapper(self, *args, **kw):
        if hasattr(self, 'before') and inspect.ismethod(self.before):
            self.before()
        result = f(self, *args, **kw)
        if hasattr(self, 'after') and inspect.ismethod(self.after):
            self.after()
        return result
    return wrapper


class Dog:
    def __init__(self, sound, speed):
        self.sound = sound
        self.speed = speed

    def before(self):
        print('Doing this before the function')

    def after(self):
        print('Doing this after the function')

    @before_and_after
    def bark(self):
        print(self.sound)

    @before_and_after
    def run(self):
        print('running at speed: {}'.format(self.speed))


def timed(func):

    @wraps(func)
    def wrap(*args, **kwargs):

        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print('time elapsed: {} seconds'.format(end-start))
        return result

    return wrap


def hi():
    """This function says hello."""
    print('hello world')


hi = timed(hi)


def validate_min_value(mini):
    def decorator(func):

        @wraps(func)
        def wrap(*args, **kwargs):
            if args[0] < mini:
                raise ValueError
            return func(*args, **kwargs)
        return wrap
    return decorator


@validate_min_value(1.00)
def validate_money(amt):
    print(amt)


class MinValidator:

    def __init__(self, mini, **named):
        self.mini = mini
        stuff = named.setdefault('stuff', False)
        print(stuff)

    def __call__(self, func):
        def wrap(*args, **kwargs):
            if args[0] < self.mini:
                raise ValueError
            return func(*args, **kwargs)
        return wrap


@MinValidator(30.0, stuff=True)
def validate_temperature(t):
    print(t)


class CountMe:

    def __init__(self, func):

        self.count_me = 0
        self.func = func

    def __call__(self, *args, **kwargs):

        self.count_me += 1
        return self.func(*args, **kwargs)


@CountMe
def hi2(name):
    print('Hello, {}'.format(name))


class LogMe:

    def __init__(self):
        self.enabled = True

    def __call__(self, func):
        def wrap(*args, **kwargs):
            if self.enabled:
                print("Decorated function called!")
            return func(*args, **kwargs)
        return wrap


logger = LogMe()


@logger
def pop(items=[]):
    print(items.pop())


@timed
@CountMe
@logger
def multi(a=0, b=0):
    return a * b


class Memoize:

    def __init__(self, func):
        self.data = {}
        self.func = func

    def __call__(self, *args, **kwargs):
        if args[0] in self.data:
            return self.data.get(args[0])
        else:
            return self.data.setdefault(args[0], self.func(*args, **kwargs))


@Memoize
@logger
def square(n=0):
    return n * n


def memoize_func(func):
    data = {}

    def wrap(*args, **kwargs):
        if args[0] in data:
            return data.get(args[0])
        else:
            return data.setdefault(args[0], func(*args, **kwargs))
    return wrap


@memoize_func
@logger
def cube(n=0):
    return n * n * n


class Nameinator:
    def __init__(self, suffix='inator'):
        self.suffix = suffix

    @timed
    def nameinate(self, name):
        return name + self.suffix


def time_since_last(func):
    last_time = None

    def wrap(*args, **kwargs):
        nonlocal last_time
        now = time.time()
        elapsed = now - (last_time or now)
        print('Time since last call: {0:.1f} seconds'.format(elapsed))
        last_time = now
        return func(*args, *kwargs)
    return wrap


class DoStuff:

    def __init__(self):
        pass

    @classmethod
    @timed
    def stuff1(cls):
        print('doing 1st stuff')


@time_since_last
def speak_slowly(word):
    time.sleep(0.1)
    print(word)


if __name__ == "__main__":

    help(hi)
    x = hi()
    help(x)
    validate_money(6.50)
    #validate_money(0.99)

    hi2('Fred')
    hi2('Barney')
    hi2('Wilma')
    print(hi2.count_me)

    items = ['Velma', 'Shaggy', 'Daphne']
    pop(items)
    pop(items)
    logger.enabled = False
    pop(items)
    logger.enabled = True

    print(multi(2, 4))
    print(multi(3, 5))

    print(square(2))
    print(square(3))
    print(square(2))
    print(square.data)

    print(cube(2))
    print(cube(3))
    print(cube(2))
    #print(cube.data)

    speak_slowly("How")
    speak_slowly("are")
    speak_slowly("you?")

    nameinator = Nameinator('inator')
    print(nameinator.nameinate('Bob'))
    print(nameinator.nameinate('Beth'))
    print(nameinator.nameinate('Bob'))

    d = Dog('woof', 10)
    d.bark()
    d.run()

    DoStuff.stuff1()

    validate_temperature(99.5)
    #validate_temperature(20.0)
