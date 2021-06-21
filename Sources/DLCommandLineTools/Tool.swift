//
//  Tool.swift
//  DLCommandLineTools
//
//  Copyright 2016-2018 The DLVM Team.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if os(Linux)
@_exported import Glibc
#else
@_exported import Darwin.C
#endif

//import TSCBasic
//import TSCUtility
import ArgumentParser
import struct TSCBasic.AbsolutePath
import Rainbow


extension AbsolutePath: ExpressibleByArgument {
  public init?(argument: String) {
    self.init(argument)
  }
}

/*extension OrderedSet: ExpressibleByArgument where Element == TransformPass {
  public init?(argument: String) {
    if let pass = TransformPass(rawValue: argument) {
      self.append(pass)
    } else {
      return nil
    }
  }
}*/

//import struct DLVM.OrderedSet
public struct ToolOptions: ParsableArguments {
  /// An enum indicating the execution status of run commands.
  public init() {}
  public enum ExecutionStatus: Codable {
      case success
      case failure
  }
  /*
  static let configuration =
    CommandConfiguration(
      commandName: "DLCommandLineTools",
      abstract:
"""
A command-line tool to interpolate numerical data from text at fixed intervals.
""".bold,
      discussion:
"""
This tool ...

There are various options to:
- abc
- abc
- abc
- abc
- abc
- abc
""",
      version: "0.1.0",
      shouldDisplay: false,
      subcommands: [ParsableCommand.Type](),
      defaultSubcommand: nil,
      helpNames: nil)
  */
  //var executionStatus: ExecutionStatus = .success
  /// Input files
  @Argument(help: "DLVM IR input file paths.", completion: .file())
  public var inputFiles: [AbsolutePath] = []
  /// Output paths
  @Option(name: [.short], parsing: .upToNextOption, help: "DLVM IR output file paths.", completion: .file())
  public var outputPaths: [AbsolutePath] = []
  
  @Flag
  public var passes: [TransformPass] = []
  
  @Flag(name: [.customLong("print-ir")], help:"""
                                   Print IR after transformations instead of \
                                   writing to files
                                   """)
  public var shouldPrintIR = false



/*
open class CommandLineTool<Options : ToolOptions> {
    /// An enum indicating the execution status of run commands.
    enum ExecutionStatus {
        case success
        case failure
    }

    /// The options of this tool.
    public let options: Options

    /// Reference to the argument parser.
  public let parser: ArgumentParser.ParsableArguments

    /// The execution status of the tool.
    var executionStatus: ExecutionStatus = .success

    /// Create an instance of this tool.
    ///
    /// - parameter args: The command line arguments to be passed to this tool.
    public init(name: String, usage: String, overview: String,
                arguments: [String], seeAlso: String? = nil) {
        // Create the parser.
      parser = ArgumentParser(
            commandName: name,
            usage: usage,
            overview: overview,
            seeAlso: seeAlso
        )

        // Create the binder.
        let binder = ArgumentBinder<Options>()

        // Bind the common options.
        binder.bindArray(
            positional: parser.add(positional: "input files",
                                   kind: [PathArgument].self,
                                   usage: "DLVM IR input files"),
            to: { $0.inputFiles = $1.lazy.map({ $0.path }) }
        )

        binder.bindArray(
            parser.add(option: "--passes", shortName: "-p",
                       kind: [TransformPass].self,
                       usage: "Transform passes"),
            parser.add(option: "--outputs", shortName: "-o",
                       kind: [PathArgument].self,
                       usage: "Output paths"),
            to: {
                if !$1.isEmpty { $0.passes = DLVM.OrderedSet($1) }
                if !$2.isEmpty { $0.outputPaths = $2.lazy.map({ $0.path }) }
            }
        )

        binder.bind(
            option: parser.add(option: "--print-ir", kind: Bool.self,
                               usage: """
                                   Print IR after transformations instead of \
                                   writing to files
                                   """),
            to: { $0.shouldPrintIR = $1 }
        )

        // Let subclasses bind arguments.
        type(of: self).setUp(parser: parser, binder: binder)

        do {
            // Parse the result.
            let result = try parser.parse(arguments)
            // Fill and set options.
            var options = Options()
            try! binder.fill(parseResult: result, into: &options)
            // Validate options.
            if let passes = options.passes, passes.contains(.differentiation) {
                printDiagnostic(RedundantDifferentiationFlagDiagnostic())
                options.passes?.remove(.differentiation)
            }
            self.options = options
        } catch {
            handleError(error)
            CommandLineTool.exit(with: .failure)
        }
    }


*/
  public static func setUp(parser: Any, //ArgumentParser,
                           binder: Any) {//ArgumentBinder<Options>) {
      fatalError("Must be implemented by subclasses")
  }


}


