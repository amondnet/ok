MockWebServer
=============

A scriptable web server for testing HTTP clients


### Motivation

This library makes it easy to test that your app Does The Right Thing when it
makes HTTP and HTTPS calls. It lets you specify which responses to return and
then verify that requests were made as expected.

Because it exercises your full HTTP stack, you can be confident that you're
testing everything. You can even copy & paste HTTP responses from your real web
server to create representative test cases. Or test that your code survives in
awkward-to-reproduce situations like 500 errors or slow-loading responses.