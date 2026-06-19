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
        String funcsUserCsvPath = new File(baseDir, "functions_user.csv").getAbsolutePath();
        String funcsAutoCsvPath = new File(baseDir, "functions_auto.csv").getAbsolutePath();
        String dataUserCsvPath = new File(baseDir, "data_labels_user.csv").getAbsolutePath();
        String dataAutoCsvPath = new File(baseDir, "data_labels_auto.csv").getAbsolutePath();
        String symbolsUserCsvPath = new File(baseDir, "symbols_user.csv").getAbsolutePath();
        String symbolsAutoCsvPath = new File(baseDir, "symbols_auto.csv").getAbsolutePath();
        String commentsCsvPath = new File(baseDir, "comments.csv").getAbsolutePath();
        String stringsCsvPath = new File(baseDir, "strings.csv").getAbsolutePath();
        String callgraphCsvPath = new File(baseDir, "callgraph.csv").getAbsolutePath();

        println("Starting export to " + baseDir);
        
        SymbolTable symbolTable = currentProgram.getSymbolTable();
        SymbolIterator symbols = symbolTable.getAllSymbols(true);
        
        try (
            PrintWriter splatWriter = new PrintWriter(splatOutPath, "UTF-8");
            PrintWriter funcsUserWriter = new PrintWriter(funcsUserCsvPath, "UTF-8");
            PrintWriter funcsAutoWriter = new PrintWriter(funcsAutoCsvPath, "UTF-8");
            PrintWriter dataUserWriter = new PrintWriter(dataUserCsvPath, "UTF-8");
            PrintWriter dataAutoWriter = new PrintWriter(dataAutoCsvPath, "UTF-8");
            PrintWriter symbolsUserWriter = new PrintWriter(symbolsUserCsvPath, "UTF-8");
            PrintWriter symbolsAutoWriter = new PrintWriter(symbolsAutoCsvPath, "UTF-8");
            PrintWriter commentsWriter = new PrintWriter(commentsCsvPath, "UTF-8");
            PrintWriter stringsWriter = new PrintWriter(stringsCsvPath, "UTF-8");
            PrintWriter callgraphWriter = new PrintWriter(callgraphCsvPath, "UTF-8");
        ) {
            funcsUserWriter.println("Name,Address");
            funcsAutoWriter.println("Name,Address");
            dataUserWriter.println("Name,Address");
            dataAutoWriter.println("Name,Address");
            symbolsUserWriter.println("Name,Address,Type");
            symbolsAutoWriter.println("Name,Address,Type");
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
                
                boolean isUser = (sym.getSource() == SourceType.USER_DEFINED);
                
                if (isUser) {
                    symbolsUserWriter.printf("%s,0x%08X,%s\n", name, addr.getOffset(), splatType);
                    if (splatType.equals("func")) {
                        funcsUserWriter.printf("%s,0x%08X\n", name, addr.getOffset());
                    } else {
                        dataUserWriter.printf("%s,0x%08X\n", name, addr.getOffset());
                    }
                } else {
                    symbolsAutoWriter.printf("%s,0x%08X,%s\n", name, addr.getOffset(), splatType);
                    if (splatType.equals("func")) {
                        funcsAutoWriter.printf("%s,0x%08X\n", name, addr.getOffset());
                    } else {
                        dataAutoWriter.printf("%s,0x%08X\n", name, addr.getOffset());
                    }
                }
                
                // Extract comment
                String comment = null;
                if (splatType.equals("func")) {
                    ghidra.program.model.listing.Function func = currentProgram.getFunctionManager().getFunctionAt(addr);
                    if (func != null) {
                        comment = func.getComment();
                        if (comment == null) comment = func.getRepeatableComment();
                    }
                }
                if (comment == null) {
                    ghidra.program.model.listing.CodeUnit cu = currentProgram.getListing().getCodeUnitAt(addr);
                    if (cu != null) {
                        comment = cu.getComment(ghidra.program.model.listing.CodeUnit.PLATE_COMMENT);
                        if (comment == null) comment = cu.getComment(ghidra.program.model.listing.CodeUnit.PRE_COMMENT);
                        if (comment == null) comment = cu.getComment(ghidra.program.model.listing.CodeUnit.EOL_COMMENT);
                    }
                }
                
                if (comment != null && !comment.trim().isEmpty()) {
                    comment = comment.replace("\"", "\"\"");
                    commentsWriter.printf("0x%08X,\"%s\"\n", addr.getOffset(), comment);
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
