slyncy
    by Max Aller (nanodeath@gmail)
    http://blog.maxaller.name/

== DESCRIPTION:

slyncy is a lightweight framework for firing off asynchronous calls as soon
as you know what calls you need and catching up with the results later.

== FEATURES/PROBLEMS:

* FIXME (list of features or problems)

== SYNOPSIS:

  You can defer a job either with a timeout or without.

  Without a timeout:
  the_job = slyncy { 5 }
  x = the_job.get # this will block until the_job is complete

  With a timeout:
  the_job = slyncy { 6 }
  x = the_job.get(3) # this will wait at most 3 seconds.
                     # after 3 seconds, a Slyncy::TimeoutException will be
                     # thrown
  
  With an exception in the job:
  the_job = slyncy { raise "error" }
  begin
    x = the_job.get
  rescue
    puts "an error occurred!"
  end

== REQUIREMENTS:

* FIXME (list of requirements)

== INSTALL:

* FIXME (sudo gem install, anything else)

== TODO:

* Add a JobProcessor based off of a thread pool.  Currently only available
  processor is JITJobProcessor.

== LICENSE:

(The MIT License)

Copyright (c) 2008 Max Aller

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
