// Exports Ghidra symbols to Splat format and CSVs
// @category Export

import ghidra.app.script.GhidraScript;
import ghidra.program.model.symbol.*;
import ghidra.program.model.address.Address;
import java.io.PrintWriter;
import java.io.File;

public class ExportSplatSymbols extends GhidraScript {

    private String getSplatType(Symbol symbol) {
        SymbolType type = symbol.getSymbolType();
        if (type == SymbolType.FUNCTION) {
            return "func";
        } else if (type == SymbolType.LABEL) {
            return "label";
        }
        return "u32";
    }

    @Override
    protected void run() throws Exception {
        String baseDir;
        String[] args = getScriptArgs();
        
        if (args.length > 0) {
            baseDir = args[0];
        } else {
            File dir = askDirectory("Select ghidra_exports directory", "Select");
            if (dir == null) {
                println("Export cancelled.");
                return;
            }
            baseDir = dir.getAbsolutePath();
        }

        File splatDir = new File(baseDir, "splat");
        splatDir.mkdirs();

        String splatOutPath = new File(splatDir, "SCES_008.68.symbols.from_ghidra.txt").getAbsolutePath();
        String funcsCsvPath = new File(baseDir, "functions.csv").getAbsolutePath();
        String dataCsvPath = new File(baseDir, "data_labels.csv").getAbsolutePath();
        String symbolsCsvPath = new File(baseDir, "symbols.csv").getAbsolutePath();
        String commentsCsvPath = new File(baseDir, "comments.csv").getAbsolutePath();
        String stringsCsvPath = new File(baseDir, "strings.csv").getAbsolutePath();
        String callgraphCsvPath = new File(baseDir, "callgraph.csv").getAbsolutePath();

        println("Starting export to " + baseDir);
        
        SymbolTable symbolTable = currentProgram.getSymbolTable();
        SymbolIterator symbols = symbolTable.getAllSymbols(true);
        
        try (
            PrintWriter splatWriter = new PrintWriter(splatOutPath, "UTF-8");
            PrintWriter funcsWriter = new PrintWriter(funcsCsvPath, "UTF-8");
            PrintWriter dataWriter = new PrintWriter(dataCsvPath, "UTF-8");
            PrintWriter symbolsWriter = new PrintWriter(symbolsCsvPath, "UTF-8");
            PrintWriter commentsWriter = new PrintWriter(commentsCsvPath, "UTF-8");
            PrintWriter stringsWriter = new PrintWriter(stringsCsvPath, "UTF-8");
            PrintWriter callgraphWriter = new PrintWriter(callgraphCsvPath, "UTF-8");
        ) {
            funcsWriter.println("Name,Address");
            dataWriter.println("Name,Address");
            symbolsWriter.println("Name,Address,Type");
            commentsWriter.println("Address,Comment");
            stringsWriter.println("Address,String");
            callgraphWriter.println("Caller,Callee");

            int count = 0;
            for (Symbol sym : symbols) {
                if (sym.isDynamic() || sym.getSource() == SourceType.DEFAULT) {
                    continue;
                }
                
                Address addr = sym.getAddress();
                if (!addr.isMemoryAddress() || addr.getOffset() < 0x80000000L) {
                    continue;
                }
                
                String name = sym.getName();
                if (name.startsWith("DAT_") || name.startsWith("LAB_") || name.startsWith("FUN_")) {
                    continue;
                }
                
                String splatType = getSplatType(sym);
                splatWriter.printf("%s = 0x%08X; // type:%s\n", name, addr.getOffset(), splatType);
                
                symbolsWriter.printf("%s,0x%08X,%s\n", name, addr.getOffset(), splatType);
                if (splatType.equals("func")) {
                    funcsWriter.printf("%s,0x%08X\n", name, addr.getOffset());
                } else {
                    dataWriter.printf("%s,0x%08X\n", name, addr.getOffset());
                }
                count++;
            }
            println("Success: Exported " + count + " symbols to " + splatOutPath);
            println("Created CSVs in " + baseDir);
        } catch (Exception e) {
            printerr("Error writing files: " + e.getMessage());
        }
    }
}
