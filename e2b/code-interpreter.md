# How to Use the Code Interpreter SDK JavaScript API

This guide provides comprehensive examples of using the Code Interpreter SDK JavaScript API, covering all major features and use cases.

## Table of Contents

1. [Basic Usage](#basic-usage)
2. [Working with Multiple Kernels](#working-with-multiple-kernels)
3. [Streaming Output](#streaming-output)
4. [Handling Errors](#handling-errors)
5. [Working with Charts and Graphs](#working-with-charts-and-graphs)
6. [Installing and Using External Packages](#installing-and-using-external-packages)
7. [Working with Files](#working-with-files)
8. [Timeout Handling](#timeout-handling)
9. [Stateful Execution](#stateful-execution)
10. [Advanced Kernel Management](#advanced-kernel-management)

## Basic Usage

**Headline: Execute a simple Python code snippet**

Example: Create a sandbox, execute a Python code cell, and retrieve the result.

```javascript
import { CodeInterpreter } from '@e2b/code-interpreter'

async function basicUsage() {
  const sandbox = await CodeInterpreter.create()
  
  const execution = await sandbox.notebook.execCell('print("Hello, World!")')
  console.log(execution.logs.stdout[0]) // Output: Hello, World!
  
  await sandbox.close()
}

basicUsage()
```

## Working with Multiple Kernels

**Headline: Create and use multiple independent kernels**

Example: Create two separate kernels and demonstrate their independence.

```javascript
import { CodeInterpreter } from '@e2b/code-interpreter'

async function multipleKernels() {
  const sandbox = await CodeInterpreter.create()
  
  const kernel1 = await sandbox.notebook.createKernel()
  const kernel2 = await sandbox.notebook.createKernel()
  
  await sandbox.notebook.execCell('x = 10', { kernelID: kernel1 })
  await sandbox.notebook.execCell('y = 20', { kernelID: kernel2 })
  
  const result1 = await sandbox.notebook.execCell('print(x)', { kernelID: kernel1 })
  const result2 = await sandbox.notebook.execCell('print(y)', { kernelID: kernel2 })
  
  console.log('Kernel 1:', result1.logs.stdout[0]) // Output: Kernel 1: 10
  console.log('Kernel 2:', result2.logs.stdout[0]) // Output: Kernel 2: 20
  
  await sandbox.close()
}

multipleKernels()
```

## Streaming Output

**Headline: Stream output in real-time during code execution**

Example: Execute a long-running task and stream its output as it becomes available.

```javascript
import { CodeInterpreter } from '@e2b/code-interpreter'

async function streamingOutput() {
  const sandbox = await CodeInterpreter.create()
  
  const code = `
import time
for i in range(5):
    print(f"Processing step {i+1}")
    time.sleep(1)
print("Done!")
  `
  
  await sandbox.notebook.execCell(code, {
    onStdout: (msg) => console.log('Output:', msg.line.trim()),
    onStderr: (msg) => console.error('Error:', msg.line.trim())
  })
  
  await sandbox.close()
}

streamingOutput()
```

## Handling Errors

**Headline: Gracefully handle execution errors**

Example: Execute code that raises an exception and handle the error.

```javascript
import { CodeInterpreter } from '@e2b/code-interpreter'

async function handleErrors() {
  const sandbox = await CodeInterpreter.create()
  
  const execution = await sandbox.notebook.execCell('1 / 0')
  
  if (execution.error) {
    console.error('Error occurred:')
    console.error('Name:', execution.error.name)
    console.error('Value:', execution.error.value)
    console.error('Traceback:', execution.error.traceback)
  } else {
    console.log('Execution successful')
  }
  
  await sandbox.close()
}

handleErrors()
```

## Working with Charts and Graphs

**Headline: Generate and retrieve matplotlib charts**

Example: Create a simple line plot and retrieve the image data.

```javascript
import { CodeInterpreter } from '@e2b/code-interpreter'
import fs from 'fs/promises'

async function createChart() {
  const sandbox = await CodeInterpreter.create()
  
  const code = `
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(0, 10, 100)
y = np.sin(x)

plt.plot(x, y)
plt.title('Sine Wave')
plt.xlabel('x')
plt.ylabel('sin(x)')
plt.show()
  `
  
  const execution = await sandbox.notebook.execCell(code)
  
  if (execution.results[0] && execution.results[0].png) {
    await fs.writeFile('sine_wave.png', Buffer.from(execution.results[0].png, 'base64'))
    console.log('Chart saved as sine_wave.png')
  } else {
    console.log('No chart data available')
  }
  
  await sandbox.close()
}

createChart()
```

## Installing and Using External Packages

**Headline: Install and use an external Python package**

Example: Install the `requests` package and use it to make an HTTP request.

```javascript
import { CodeInterpreter } from '@e2b/code-interpreter'

async function useExternalPackage() {
  const sandbox = await CodeInterpreter.create()
  
  await sandbox.notebook.execCell('!pip install requests')
  
  const code = `
import requests

response = requests.get('https://api.github.com')
print(f"GitHub API Status Code: {response.status_code}")
print(f"GitHub Rate Limit: {response.headers['X-RateLimit-Limit']}")
  `
  
  const execution = await sandbox.notebook.execCell(code)
  console.log(execution.logs.stdout.join('\n'))
  
  await sandbox.close()
}

useExternalPackage()
```

## Working with Files

**Headline: Create, read, and manipulate files in the sandbox**

Example: Create a file, write content to it, then read and print the content.

```javascript
import { CodeInterpreter } from '@e2b/code-interpreter'

async function workWithFiles() {
  const sandbox = await CodeInterpreter.create()
  
  const writeCode = `
with open('example.txt', 'w') as f:
    f.write("Hello, File System!")
print("File created and written")
  `
  
  await sandbox.notebook.execCell(writeCode)
  
  const readCode = `
with open('example.txt', 'r') as f:
    content = f.read()
print(f"File content: {content}")
  `
  
  const execution = await sandbox.notebook.execCell(readCode)
  console.log(execution.logs.stdout.join('\n'))
  
  await sandbox.close()
}

workWithFiles()
```

## Timeout Handling

**Headline: Set and handle execution timeouts**

Example: Set a timeout for code execution and handle the timeout error.

```javascript
import { CodeInterpreter } from '@e2b/code-interpreter'

async function handleTimeout() {
  const sandbox = await CodeInterpreter.create()
  
  const code = `
import time
time.sleep(10)
print("This won't be printed")
  `
  
  try {
    await sandbox.notebook.execCell(code, { timeout: 5000 }) // 5 seconds timeout
  } catch (error) {
    console.error('Execution timed out:', error.message)
  }
  
  await sandbox.close()
}

handleTimeout()
```

## Stateful Execution

**Headline: Maintain state between multiple code executions**

Example: Demonstrate how variables persist across multiple executions.

```javascript
import { CodeInterpreter } from '@e2b/code-interpreter'

async function statefulExecution() {
  const sandbox = await CodeInterpreter.create()
  
  await sandbox.notebook.execCell('x = 10')
  await sandbox.notebook.execCell('y = 20')
  
  const execution = await sandbox.notebook.execCell('print(f"x + y = {x + y}")')
  console.log(execution.logs.stdout[0])
  
  await sandbox.close()
}

statefulExecution()
```

## Advanced Kernel Management

**Headline: List, restart, and shut down kernels**

Example: Create multiple kernels, list them, restart one, and shut down another.

```javascript
import { CodeInterpreter } from '@e2b/code-interpreter'

async function advancedKernelManagement() {
  const sandbox = await CodeInterpreter.create()
  
  const kernel1 = await sandbox.notebook.createKernel()
  const kernel2 = await sandbox.notebook.createKernel()
  
  console.log('Available kernels:', await sandbox.notebook.listKernels())
  
  await sandbox.notebook.restartKernel(kernel1)
  console.log('Kernel 1 restarted')
  
  await sandbox.notebook.shutdownKernel(kernel2)
  console.log('Kernel 2 shut down')
  
  console.log('Remaining kernels:', await sandbox.notebook.listKernels())
  
  await sandbox.close()
}

advancedKernelManagement()
```

These examples cover a wide range of features provided by the Code Interpreter SDK JavaScript API. Each example demonstrates a specific use case and can be run independently. Remember to handle errors and close the sandbox properly in your actual applications.
