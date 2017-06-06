import DLParse
import Foundation
import CommandLineKit

let cli = CommandLineKit.CommandLine()

struct Options {
    /// File
    static let filePaths = MultiStringOption(shortFlag: "f", longFlag: "files",
                                            helpMessage: "Paths to DLVM IR source files")
    /// IR Optimizers
    static let passes = MultiStringOption(shortFlag: "p", longFlag: "passes",
                                          helpMessage: "Transformation passes")
    /// BPGen
    static let shouldBPGen = BoolOption(shortFlag: "b", longFlag: "backpropagation",
                                        helpMessage: "Generate backpropagation IR")
    /// NN optimization algorithm
    static let nnOptimizer = StringOption(longFlag: "training-optimizer",
                                          helpMessage: "Training optimization algorithm as part of backpropagation")
    /// Loss function
    static let lossFunction = StringOption(longFlag: "loss-function",
                                           helpMessage: "Loss function for training")
    /// Print IR
    static let shouldPrintIR = BoolOption(longFlag: "print-ir",
                                          helpMessage: "Print IR after transformation")
    /// Output
    static let outputPaths = MultiStringOption(shortFlag: "o", longFlag: "outputs",
                                               helpMessage: "Output file paths")
    /// Help
    static let needsHelp = BoolOption(shortFlag: "h", longFlag: "help",
                                      helpMessage: "Print help message")
}

cli.addOptions(Options.filePaths,
               Options.passes,
               Options.shouldBPGen,
               Options.nnOptimizer,
               Options.lossFunction,
               Options.shouldPrintIR,
               Options.outputPaths,
               Options.needsHelp)

/// Parse command line
do { try cli.parse(strict: true) }
catch { cli.printUsage(error); exit(EXIT_FAILURE) }

func error(_ message: String) {
    print("error: " + message)
    exit(EXIT_FAILURE)
}

func main() throws {
    
    guard !Options.needsHelp.wasSet else {
        print("Deep Learning Virtual Machine")
        print("IR Compiler\n")
        cli.printUsage()
        return
    }

    guard let filePaths = Options.filePaths.value else {
        error("no input files; use -f to specify files")
        return
    }

    if let outputPaths = Options.outputPaths.value, outputPaths.count != filePaths.count {
        error("different numbers of inputs and outputs specified")
    }

    let outputPaths = Options.outputPaths.value ?? filePaths

    for (filePath, outputPath) in zip(filePaths, outputPaths) {
        /// Read IR and verify
        let irSource = try String(contentsOfFile: filePath, encoding: .utf8)
        print("Source file:", filePath)
        let lexer = Lexer(text: irSource)
        let tokens = try lexer.performLexing()
        for tok in tokens {
            print(tok)
        }
        let parser = Parser(tokens: tokens)
        let module = try parser.parseModule()
        print("Module \"\(module.name)\"")
        try module.verify()

        if Options.shouldPrintIR.wasSet {
            print(module)
        }
        
        /// Write IR
        try module.write(toFile: outputPath)
        print("Written to \(outputPath)")
    }

}

do { try main() }
catch { print(error) }
