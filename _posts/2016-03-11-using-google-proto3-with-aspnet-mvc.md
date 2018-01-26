---
layout: post
title: Using Protocol buffers v3 with ASP.NET core
description: "This blog post gives a working Input and Output formatters for ASP.NET MVC to work with Google Protocol Buffers."
modified:
tags: [web, aspnet]
comments: true
share: true
---

By default [ASP.NET core](https://docs.asp.net/) API methods operate on JSON: they deserialize JSON from request/response
body to model type and back. JSON is everywhere and works well... unless you have very high
throughput requirements. There are many alternative formats, but
Google's serialization format [Protocol Buffers](https://developers.google.com/protocol-buffers/)
is one of the most used. It has overgone some changes recently: the old [proto2](https://developers.google.com/protocol-buffers/docs/proto)
syntax is replaced with [proto3](https://developers.google.com/protocol-buffers/docs/proto3). The latter
even has an official C# support.

The old proto2 used to have unofficial C# ports, and many ASP.NET MVC samples on the internet
are based on those. I couldn't find a working proto3 version, so I created my own.

To create custom input and output types for ASP.NET two interfaces need to be fullfilled:
IInputFormatter and IOutputFormatter. The easiest way to do this is to inherit from
InputFormatter and OutputFormatter base classes. Basically ASP.NET MVC tells the
content type, content and desired target type, and then custom formatter needs to
act on those.

Naturally this all needs to work for all possible types, otherwise the formatters would not
be reusable. Proto3 has some strangeness in its APIs, like some of the useful constructors being internal.
Luckily with some source code reading one can find the method that does the real work when
the actual type is not known on compile time: IMessage.MergeFrom(). Working Input and output formatters
are below:

```csharp
// The input formatter reading request body and mapping it to given data object.
public class ProtobufInputFormatter : InputFormatter
{
    static MediaTypeHeaderValue protoMediaType = MediaTypeHeaderValue.Parse("application/x-protobuf");

    public override bool CanRead(InputFormatterContext context)
    {
        var request = context.HttpContext.Request;
        MediaTypeHeaderValue requestContentType = null;
        MediaTypeHeaderValue.TryParse(request.ContentType, out requestContentType);

        if (requestContentType == null)
        {
            return false;
        }

        return requestContentType.IsSubsetOf(protoMediaType);
    }

    public override Task<InputFormatterResult> ReadRequestBodyAsync(InputFormatterContext context)
    {
        try
        {
            var request = context.HttpContext.Request;
            var obj = (IMessage)Activator.CreateInstance(context.ModelType);
            obj.MergeFrom(request.Body);

            return InputFormatterResult.SuccessAsync(obj);
        }
        catch (Exception ex)
        {
            Console.WriteLine("Exception: " + ex);
            return InputFormatterResult.FailureAsync();
        }
    }
}

// The output object mapping returned object to Protobuf-serialized response body.
public class ProtobufOutputFormatter : OutputFormatter
{
    static MediaTypeHeaderValue protoMediaType = MediaTypeHeaderValue.Parse("application/x-protobuf");

    public override bool CanWriteResult(OutputFormatterCanWriteContext context)
    {
        if (context.Object == null || !context.ContentType.IsSubsetOf(protoMediaType))
        {
            return false;
        }

        // Check whether the given object is a proto-generated object
        return context.ObjectType.GetTypeInfo()
            .ImplementedInterfaces
            .Where(i => i.GetTypeInfo().IsGenericType)
            .Any(i => i.GetGenericTypeDefinition() == typeof(IMessage<>));
    }

    public override Task WriteResponseBodyAsync(OutputFormatterWriteContext context)
    {
        var response = context.HttpContext.Response;

        // Proto-encode
        var protoObj = context.Object as IMessage;
        var serialized = protoObj.ToByteArray();

        return response.Body.WriteAsync(serialized, 0, serialized.Length);
    }
}
```

Formatters need to be registered for ASP.NET MVC to use them. This can be done
in the ConfigureServices method:

```csharp
public void ConfigureServices(IServiceCollection services)
{
    services.AddMvc();
    services.Configure<MvcOptions>(options => {
        options.InputFormatters.Add(new ProtobufInputFormatter());
        options.OutputFormatters.Add(new ProtobufOutputFormatter());
    });
}
```

And that's it, now you can control the desired format with requests by using either
application/json or application/x-protobuf as content and accept types. You can
even mix and match: send in JSON but request protobuf back.