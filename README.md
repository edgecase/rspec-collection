# rspec-collection

Allow RSpec assertions over the elements of a collection.

## Usage

Allow RSpec assertions over the elements of a collection.  For example:

  collection.should all\_be > 0

will specify that each element of the collection should be greater
than zero.  Each element of the collection that fails the test will
be reported in the error message.

Examples:

  [1,1,1].should all\_be eq(1)
  [2,4,6].should all\_be\_even
  [3,6,9].should all\_be\_divisible_by(3)
  [1,1,1].should all\_be == 1
  [2,3,5].should all\_be { |n| prime?(n) }

(for appropriate definitions of prime? and divisible_by?)

### Requirements

* RSpec 2.0.0

## Todo

* Other means of navigation besides left/right keys
* Vertical view of all slides in a row
* Generate PDFs (maybe via cucumber)
* Stop making Nokogiri sad when parsing out snippets

## Contributors

* Jim Weirich

(c) Copyright 2010 Jim Weirich

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:
 
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
