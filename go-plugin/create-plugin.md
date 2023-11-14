## Creating a New Plugin: Step-by-Step Instructions

1. Shared Structures & Functions Setup
   - Define package: `package shared`
   - Import necessary packages:
     - `net/rpc`
     - `github.com/hashicorp/go-plugin`

2. Define Plugin Interface
   - Example: `type Greeter interface { Greet() string }`

3. Create RPC Implementation
   - Create an RPC structure (Example: `GreeterRPC`) that embeds an `*rpc.Client`
   - Implement the methods from your interface in this structure
   - For remote procedure calls:
     - Use `client.Call` method
     - Handle potential errors (consider returning errors or panicking)

4. Define RPC Server
   - Create an RPC server structure (Example: `GreeterRPCServer`)
   - This server should embed the real implementation of the interface
   - Implement the same methods as your plugin interface in this server but make them RPC-compatible

5. Implement Plugin Server/Client Methods
   - Create a structure (Example: `GreeterPlugin`) representing the plugin itself
   - This structure should embed your interface (Example: `Impl Greeter`)
   - Implement plugin.Plugin methods:
        - Signature: Server(*plugin.MuxBroker) (interface{}, error)
        - Signature: Client(b *plugin.MuxBroker, c *rpc.Client) (interface{}, error)

6. Embed Real Implementations
   - When instantiating the plugin, inject the real implementation of the interface into the plugin

7. Omit Advanced Features (Initially)
   - Ignore `MuxBroker` unless implementing advanced features.

## Creating a New Plugin Implementation

1. Setup and Imports
   - Define `main` package
   - Import necessary packages:
     - `os`
     - `github.com/hashicorp/go-hclog`
     - `github.com/hashicorp/go-plugin`
     - Your shared package (Example: `github.com/hashicorp/go-plugin/examples/basic/shared`)

2. Implement Actual Plugin Logic
   - Create a real implementation of the interface (Example: `GreeterHello`)
   - Implement the methods defined in the interface
     - Add any desired logging or additional functionality

3. Define Handshake Configuration
   - Create a `handshakeConfig` to set up a basic handshake between the plugin and the host
   - Set `ProtocolVersion`, `MagicCookieKey`, and `MagicCookieValue`

4. Main Function Setup
   - Initialize a logger (Example: `hclog.New`)
   - Instantiate the real implementation of the interface and assign to a variable (Example: `greeter`)
   - Create a `pluginMap` to map the plugin interface to its real implementation

5. Serve the Plugin
   - Call `plugin.Serve` function
   - Provide a `ServeConfig`:
     - Assign the `handshakeConfig`
     - Assign the `pluginMap` to the `Plugins` field

6. Additional Logging (Optional)
   - Use the logger to output any additional debug or info messages as required

## Loading and Using the Plugin

1. Setup and Imports
   - Define `main` package
   - Import necessary packages:
     - `fmt`
     - `log`
     - `os`
     - `os/exec`
     - `github.com/hashicorp/go-hclog`
     - `github.com/hashicorp/go-plugin`
     - Your shared package (Example: `github.com/hashicorp/go-plugin/examples/basic/shared`)

2. Initialize Logger
   - Create an `hclog.Logger` for logging activities

3. Launch the Plugin Process
   - Use `plugin.NewClient`:
     - Provide a `ClientConfig` with:
       - `HandshakeConfig` 
       - Plugin map (`Plugins`)
       - Command to start the plugin process (`Cmd`)
       - Logger 

4. Connect to Plugin via RPC
   - Use `client.Client()` to establish an RPC connection
   - Handle any connection errors

5. Request and Use the Plugin
   - Use `rpcClient.Dispense()` to request the desired plugin interface (Example: "greeter")
   - Cast the received plugin to its interface (Example: `raw.(shared.Greeter)`)
   - Invoke methods on the interface as if it was a local implementation (Example: `greeter.Greet()`)

6. Clean Up
   - Use `client.Kill()` to close the client when done

7. Define Handshake Configuration
   - Set up `handshakeConfig` for initial handshake between the plugin and host

8. Define Plugin Map
   - Create a `pluginMap` mapping the plugin name to its plugin interface


