# Bunny

Supervised RabbitMQ (hereinafter referred to as RMQ) channels and
connections.

> **Beware!**
>
> RabbitMQ channels and connections are stateful and their state is not set
> at creation time. Thus, delegating the responsibility of restarting a
> crashed channel or connection to a supervisor does not guarantee that the
> channel or connection will be in the same state they were last in.

Bunny handles the following crash scenarios as described below:

- Bunny detects when a RMQ connection goes down. Bunny will attempt to reconnect
until it succeeds or the connection is explicitly closed.

- Bunny detects when a RMQ channel goes down. Bunny will attempt to recreate
the channel until it succeeds or the channel is explicitly closed.

- If the owner of a channel goes down (i.e. the process who openned the
channel), Bunny takes care of terminating the channel owned by that process.


## Author(s)
- Enrique Fernandez `<efcasado@gmail.com>`


## License
> The MIT License (MIT)
>
> Copyright (c) 2016, Enrique Fernandez
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.
